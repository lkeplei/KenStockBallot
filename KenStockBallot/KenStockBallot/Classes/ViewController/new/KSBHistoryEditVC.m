//
//  KSBHistoryEditVC.m
//  KenStockBallot
//
//  Created by Ken.Liu on 2017/1/19.
//  Copyright © 2017年 ken. All rights reserved.
//

#import "KSBHistoryEditVC.h"
#import "KSBHistoryInfo.h"

static const int cellEitOffX = 40;

@interface KSBHistoryEditVC ()<UITableViewDataSource, UITableViewDelegate>

@property (assign) BOOL isSelectAll;
@property (nonatomic, strong) UIButton *selectAllBtn;
@property (nonatomic, strong) UITableView *stockTable;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *preDataArray;
@property (nonatomic, strong) NSMutableArray *statusArray;

@end

@implementation KSBHistoryEditVC
- (instancetype)initWithData:(NSArray *)data {
    self = [super init];
    if (self) {
        _isSelectAll = NO;
        [self setData:data];
        
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
    NSArray *titleArr = @[KenLocal(@"question_title1"), KenLocal(@"question_title3"), @"累计申购\n新股次数",
                          @"中签时的\n累积概率", KenLocal(@"question_title6")];
    float width = (kGSize.width - cellEitOffX) / [titleArr count];
    for (int i = 0; i < [titleArr count]; i++) {
        UILabel *label = [KenUtils labelWithTxt:titleArr[i]
                                          frame:(CGRect){cellEitOffX + width * i, 0, width, 44}
                                           font:kKenFontHelvetica(14) color:[UIColor greenTextColor]];
        label.numberOfLines = 0;
        [titleV addSubview:label];
    }
    
    //bottom delete or add
    UIButton *deleteBtn = [KenUtils buttonWithImg:KenLocal(@"app_delete") off:0 zoomIn:NO
                                            image:[UIImage imageNamed:@"delete_bg"]
                                         imagesec:[UIImage imageNamed:@"delete_bg_sec"]
                                           target:self action:@selector(deleteBtnClicked)];
    [deleteBtn.titleLabel setFont:kKenFontHelvetica(16)];
    deleteBtn.frame = CGRectMake(0, kGSize.height - 44, self.view.width, 44);
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
    NSArray *sortedArray = [array sortedArrayUsingComparator: ^(KSBHistoryInfo *obj1, KSBHistoryInfo *obj2) {
        NSComparisonResult result = [obj1.date compare:obj2.date];
        switch(result) {
            case NSOrderedAscending:
                return NSOrderedDescending;
            case NSOrderedDescending:
                return NSOrderedAscending;
            case NSOrderedSame:
            default: {
                NSComparisonResult result1 = [obj1.code compare:obj2.code];
                switch(result1) {
                    case NSOrderedAscending:
                        return NSOrderedAscending;
                    case NSOrderedDescending:
                        return NSOrderedDescending;
                    case NSOrderedSame:
                    default:
                        return NSOrderedSame;
                }
            }
                break;
        }
    }];
    
    
    if (_dataArray) {
        [_dataArray removeAllObjects];
    } else {
        _dataArray = [NSMutableArray array];
    }
    [_dataArray addObjectsFromArray:sortedArray];
    
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
    [_stockTable reloadData];
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
    
    NSString *selectName = @"select_red.png";
    UIImageView *status = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_statusArray[indexPath.row] boolValue] ? selectName : @"select_none.png"]];
    status.center = CGPointMake(cell.height / 2, cell.height / 2);
    status.tag = 10001;
    [cell.contentView addSubview:status];
    
    KSBHistoryInfo *info = _dataArray[indexPath.row];
    NSArray *array = @[info.name, info.price, info.times, info.ballot, info.date];
    float width = (kGSize.width - cellEitOffX) / [array count];
    for (int i = 0; i < [array count]; i++) {
        float height = i == 0 ? cell.height * 0.4 : cell.height;
        UILabel *label = [KenUtils labelWithTxt:array[i] frame:(CGRect){cellEitOffX + width * i, i == 0 ? cell.height * 0.15 : 0, width, height}
                                           font:kKenFontHelvetica(14) color:[UIColor blackTextColor]];
        [cell.contentView addSubview:label];
        if (i == 0) {
            NSString *image = @"new_hu";
            if ([info.jiaoYS isEqual:@"深圳"]) {
                image = @"new_sheng";
            }
            CGFloat codeWidth = [KenUtils getFontSize:info.code font:kKenFontHelvetica(12)].width + 4;
            
            UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
            imgV.originX = label.originX + (width - codeWidth - imgV.width) / 2;
            [cell.contentView addSubview:imgV];
            
            UILabel *code = [KenUtils labelWithTxt:info.code
                                             frame:(CGRect){CGRectGetMaxX(imgV.frame) + 4, cell.height * 0.5, codeWidth, height}
                                              font:kKenFontHelvetica(12) color:[UIColor grayTextColor]];
            code.textAlignment = KTextAlignmentLeft;
            [cell.contentView addSubview:code];
            
            imgV.centerY = code.centerY;
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
        NSString *selectName = @"select_red.png";
        [statusImg setImage:[UIImage imageNamed:[_statusArray[indexPath.row] boolValue] ? selectName : @"select_none.png"]];
    }
}

#pragma mark - button
- (void)selectAllClicked {
    _isSelectAll = !_isSelectAll;
    for (int i = 0; i < [_statusArray count]; i++) {
        _statusArray[i] = [NSNumber numberWithBool:_isSelectAll];
    }
    
    NSString *selectName = @"select_red.png";
    UIImage *image = [UIImage imageNamed:_isSelectAll ? selectName : @"select_none.png"];
    [_selectAllBtn setImage:image forState:UIControlStateNormal];
    [_selectAllBtn setImage:image forState:UIControlStateHighlighted];
    [_selectAllBtn setImage:image forState:UIControlStateSelected];
    
    [_stockTable reloadData];
}

- (void)deleteBtnClicked {
    for (int i = (int)[_statusArray count] - 1; i >= 0; i--) {
        if ([_statusArray[i] boolValue]) {
            [_dataArray removeObjectAtIndex:i];
            [_statusArray removeObjectAtIndex:i];
        }
    }
    
    [_stockTable reloadData];
    
    [[KSBModel shareKSBModel] saveHistory:_dataArray];
}

@end
