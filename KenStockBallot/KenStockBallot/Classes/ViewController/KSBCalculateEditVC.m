//
//  KSBCalculateEditVC.m
//  KenStockBallot
//
//  Created by ken on 15/6/1.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBCalculateEditVC.h"
#import "KSBStockInfo.h"

#import <BmobSDK/Bmob.h>

static const int cellEitOffX = 30;

@interface KSBCalculateEditVC ()

@property (assign) BOOL isAdd;
@property (assign) BOOL isSelectAll;
@property (assign) KSBCalculateType calculateType;
@property (nonatomic, strong) UIButton *selectAllBtn;
@property (nonatomic, strong) UITableView *stockTable;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *preDataArray;
@property (nonatomic, strong) NSMutableArray *statusArray;

@end

@implementation KSBCalculateEditVC

- (instancetype)initWithStock:(NSArray *)stockArray questionType:(KSBCalculateType)type add:(BOOL)add {
    self = [super init];
    if (self) {
        _isAdd = add;
        _calculateType = type;
        _isSelectAll = NO;
        if (_isAdd) {
            _preDataArray = [NSMutableArray arrayWithArray:stockArray];
        } else {
            [self setData:stockArray];
        }
        
        if (IsPad) {
            self.title = KenLocal(@"app_title");
        }
        
        [self.view setBackgroundColor:[UIColor grayBgColor]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *topView = [[UIView alloc] initWithFrame:(CGRect){0, kAppViewOrginY, kGSize.width, 44}];
    [topView setBackgroundColor:[UIColor grayBgColor]];
    [self.view addSubview:topView];

    UIView *titleV = [[UIView alloc] initWithFrame:(CGRect){0, 0, topView.width, 44}];
    [titleV setBackgroundColor:[UIColor grayBgColor]];
    [topView addSubview:titleV];
    
    //select all
    _selectAllBtn = [KenUtils buttonWithImg:nil off:0 zoomIn:YES image:[UIImage imageNamed:@"select_none.png"]
                                   imagesec:[UIImage imageNamed:@"select_none.png"] target:self action:@selector(selectAllClicked)];
    _selectAllBtn.center = CGPointMake(titleV.height / 2, titleV.height / 2);
    [titleV addSubview:_selectAllBtn];
    
    //title
    NSArray *titleArr = @[KenLocal(@"question_title1"), KenLocal(@"question_title2"), KenLocal(@"question_title3"),
                          _calculateType == kKSBCalculateQuestion1 ? KenLocal(@"question_title4") : KenLocal(@"question_title4_2"),
                          KenLocal(@"question_title5")];
    float width = (kGSize.width - cellEitOffX) / [titleArr count];
    for (int i = 0; i < [titleArr count]; i++) {
        UILabel *label = [KenUtils labelWithTxt:titleArr[i] frame:(CGRect){cellEitOffX + width * i, 0, width, 44}
                                           font:kKenFontHelvetica(12) color:[UIColor greenTextColor]];
        label.numberOfLines = i == ([titleArr count] - 1) ? 2 : 1;
        [titleV addSubview:label];
    }
    
    //bottom delete or add
    UIButton *deleteBtn = [KenUtils buttonWithImg:_isAdd ? KenLocal(@"app_add") : KenLocal(@"app_delete") off:0 zoomIn:NO image:nil
                                            imagesec:nil target:self action:@selector(deleteBtnClicked)];
    [deleteBtn.titleLabel setFont:kKenFontHelvetica(16)];
    deleteBtn.frame = CGRectMake(0, kGSize.height - 44, self.view.width, 44);
    if (_isAdd) {
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"add_bg"] forState:UIControlStateNormal];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"add_bg_sec"] forState:UIControlStateHighlighted];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"add_bg_sec"] forState:UIControlStateSelected];
    } else {
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_bg"] forState:UIControlStateNormal];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_bg_sec"] forState:UIControlStateHighlighted];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_bg_sec"] forState:UIControlStateSelected];
    }
    [self.view addSubview:deleteBtn];
    
    //table
    CGRect rect = CGRectMake(0, CGRectGetMaxY(topView.frame), kGSize.width, deleteBtn.originY - CGRectGetMaxY(topView.frame));
    _stockTable = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _stockTable.delegate = self;
    _stockTable.dataSource = self;
    [_stockTable setBackgroundColor:[UIColor grayBgColor]];
    _stockTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_stockTable];
    
    [self loadTable];
}

- (void)setData:(NSArray *)array {
    if (_dataArray) {
        [_dataArray removeAllObjects];
    } else {
        _dataArray = [NSMutableArray array];
    }
    [_dataArray addObjectsFromArray:array];
    
    if (_statusArray) {
        [_statusArray removeAllObjects];
    } else {
        _statusArray = [NSMutableArray array];
    }
    for (int i = 0; i < [_dataArray count]; i++) {
        [_statusArray addObject:[NSNumber numberWithBool:NO]];
    }
}

- (void)loadTable {
    if (_isAdd) {
        __block UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        indicatorView.center = self.view.center;
        [indicatorView setColor:[UIColor grayColor]];
        [self.view addSubview:indicatorView];
        [indicatorView startAnimating];
        
        BmobQuery *bquery = [BmobQuery queryWithClassName:@"StockTable"];
        //查找GameScore表里面id为0c6db13c的数据
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
            [indicatorView stopAnimating];
            [indicatorView removeFromSuperview];
            indicatorView = nil;
            
            if (error){
                DebugLog("error = %@", error);
            } else {
                if (array) {
                    NSMutableArray *bmobArray = [NSMutableArray array];
                    for (int i = 0; i < [array count]; i++) {
                        BmobObject *object = (BmobObject *)[array objectAtIndex:i];
                        
                        KSBStockInfo *info = [[KSBStockInfo alloc] init];
                        info.stockJiaoYS = [object objectForKey:@"jiaoYS"];
                        info.stockName = [object objectForKey:@"name"];
                        info.stockCode = [object objectForKey:@"code"];
                        info.stockPrice = [[object objectForKey:@"price"] floatValue];
                        info.stockBuyMax = [[object objectForKey:@"buyMax"] integerValue];
                        info.stockBallot = [[object objectForKey:@"ballot"] floatValue];
                        
                        [bmobArray addObject:info];
                    }
                    [self setData:bmobArray];
                    [_stockTable reloadData];
                }
            }
        }];
    } else {
        [_stockTable reloadData];
    }
}

#pragma mark - Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *bankCellIdentifier = @"videoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bankCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bankCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSString *selectName = _isAdd ? @"select_green.png" : @"select_red.png";
    UIImageView *status = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_statusArray[indexPath.row] boolValue] ? selectName : @"select_none.png"]];
    status.center = CGPointMake(cell.height / 2, cell.height / 2);
    status.tag = 10001;
    [cell.contentView addSubview:status];
    
    KSBStockInfo *info = _dataArray[indexPath.row];
    NSArray *array = @[info.stockName, info.stockJiaoYS,
                       [NSString stringWithFormat:@"%.2f%@", info.stockPrice, KenLocal(@"edit_yuan")],
                       [NSString stringWithFormat:@"%d%@", info.stockBuyMax, KenLocal(@"edit_gu")],
                       [NSString stringWithFormat:@"%.2f%%", info.stockBallot]];
    float width = (kGSize.width - cellEitOffX) / [array count];
    for (int i = 0; i < [array count]; i++) {
        float height = i == 0 ? cell.height * 0.4 : cell.height;
        UILabel *label = [KenUtils labelWithTxt:array[i] frame:(CGRect){cellEitOffX + width * i, i == 0 ? cell.height * 0.15 : 0, width, height}
                                           font:kKenFontHelvetica(12) color:[UIColor blackTextColor]];
        [cell.contentView addSubview:label];
        if (i == 0) {
            UILabel *code = [KenUtils labelWithTxt:info.stockCode frame:(CGRect){cellEitOffX, cell.height * 0.5, width, height}
                                              font:kKenFontHelvetica(12) color:[UIColor grayTextColor]];
            [cell.contentView addSubview:code];
        }
    }
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){cellEitOffX, cell.height - 1, kGSize.width, 1}];
    [line setBackgroundColor:[UIColor separatorMainColor]];
    [cell.contentView addSubview:line];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _statusArray[indexPath.row] = [NSNumber numberWithBool:![_statusArray[indexPath.row] boolValue]];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *statusImg = (UIImageView *)[cell viewWithTag:10001];
    if (statusImg) {
        NSString *selectName = _isAdd ? @"select_green.png" : @"select_red.png";
        [statusImg setImage:[UIImage imageNamed:[_statusArray[indexPath.row] boolValue] ? selectName : @"select_none.png"]];
    }
}

#pragma mark - button
- (void)selectAllClicked {
    _isSelectAll = !_isSelectAll;
    for (int i = 0; i < [_statusArray count]; i++) {
        _statusArray[i] = [NSNumber numberWithBool:_isSelectAll];
    }
    
    NSString *selectName = _isAdd ? @"select_green.png" : @"select_red.png";
    UIImage *image = [UIImage imageNamed:_isSelectAll ? selectName : @"select_none.png"];
    [_selectAllBtn setImage:image forState:UIControlStateNormal];
    [_selectAllBtn setImage:image forState:UIControlStateHighlighted];
    [_selectAllBtn setImage:image forState:UIControlStateSelected];
    
    [_stockTable reloadData];
}

- (void)deleteBtnClicked {
    if (_isAdd) {
        for (int i = 0; i < [_statusArray count]; i++) {
            if ([_statusArray[i] boolValue]) {
                BOOL add = YES;
                for (KSBStockInfo *info in _preDataArray) {
                    if ([[info stockCode] isEqual:[[_dataArray objectAtIndex:i] stockCode]]) {
                        add = NO;
                        break;
                    }
                }
                if (add) {
                    [_preDataArray addObject:[_dataArray objectAtIndex:i]];
                }
            }
        }
        [[KSBModel shareKSBModel] saveStock:_preDataArray type:_calculateType];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        for (int i = [_statusArray count] - 1; i >= 0; i--) {
            if ([_statusArray[i] boolValue]) {
                [_dataArray removeObjectAtIndex:i];
                [_statusArray removeObjectAtIndex:i];
            }
        }
        
        [_stockTable reloadData];
        
        [[KSBModel shareKSBModel] saveStock:_dataArray type:_calculateType];
    }
}
@end
