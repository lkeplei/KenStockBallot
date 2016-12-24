//
//  KSBSelectedVC.m
//  KenStockBallot
//
//  Created by hzyouda on 2016/12/24.
//  Copyright © 2016年 ken. All rights reserved.
//

#import "KSBSelectedVC.h"
#import "KSBStockInfo.h"
#import "KSBHistoryVC.h"

#import <BmobSDK/Bmob.h>

static const int cellEitOffX = 40;

@interface KSBSelectedVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger preSlectedIndex;
@property (assign) KSBCalculateType calculateType;
@property (nonatomic, strong) UITableView *stockTable;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *preDataArray;
@property (nonatomic, strong) NSMutableArray *statusArray;

@end

@implementation KSBSelectedVC
- (instancetype)initWithStockType:(KSBCalculateType)type {
    self = [super init];
    if (self) {
        self.title = KenLocal(@"app_selected_title");
        
        _calculateType = type;
        _preSlectedIndex = -1;
        [self setData:[[KSBModel shareKSBModel] getStock:_calculateType]];
        
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

    //title
    NSArray *titleArr = @[KenLocal(@"question_title1"), KenLocal(@"question_title3"),
                          _calculateType == kKSBCalculateQuestion1 ? KenLocal(@"question_title4") : KenLocal(@"question_title4_2"),
                          KenLocal(@"question_title5"), KenLocal(@"question_title6")];
    float width = (kGSize.width - cellEitOffX) / [titleArr count];
    for (int i = 0; i < [titleArr count]; i++) {
        UILabel *label = [KenUtils labelWithTxt:titleArr[i]
                                          frame:(CGRect){cellEitOffX + width * i, 0, (i == 0 ? width - 20 : width), 44}
                                           font:kKenFontHelvetica(12) color:[UIColor greenTextColor]];
        label.numberOfLines = i == ([titleArr count] - 1) ? 2 : 1;
        [titleV addSubview:label];
    }
    
    //bottom delete or add
    UIButton *deleteBtn = [KenUtils buttonWithImg:@"确认" off:0 zoomIn:NO image:nil
                                         imagesec:nil target:self action:@selector(deleteBtnClicked)];
    [deleteBtn.titleLabel setFont:kKenFontHelvetica(16)];
    deleteBtn.frame = CGRectMake(0, kGSize.height - 44, self.view.width, 44);
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"add_bg"] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"add_bg_sec"] forState:UIControlStateHighlighted];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"add_bg_sec"] forState:UIControlStateSelected];
    [self.view addSubview:deleteBtn];
    
    //table
    CGRect rect = CGRectMake(0, CGRectGetMaxY(topView.frame), kGSize.width, deleteBtn.originY - CGRectGetMaxY(topView.frame));
    _stockTable = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _stockTable.delegate = self;
    _stockTable.dataSource = self;
    [_stockTable setBackgroundColor:[UIColor grayBgColor]];
    _stockTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_stockTable];
    
    [_stockTable reloadData];
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
    
    NSString *selectName = @"select_green.png";
    UIImageView *status = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_statusArray[indexPath.row] boolValue] ? selectName : @"select_none.png"]];
    status.center = CGPointMake(cell.height / 2, cell.height / 2);
    status.tag = 10001;
    [cell.contentView addSubview:status];
    
    KSBStockInfo *info = _dataArray[indexPath.row];
    NSArray *array = @[info.stockName,
                       [NSString stringWithFormat:@"%.2f%@", info.stockPrice, KenLocal(@"edit_yuan")],
                       [NSString stringWithFormat:@"%d%@", (int)info.stockBuyMax, KenLocal(@"edit_gu")],
                       [NSString stringWithFormat:@"%.2f%%", info.stockBallot], info.stockDate];
    float width = (kGSize.width - cellEitOffX) / [array count];
    for (int i = 0; i < [array count]; i++) {
        float height = i == 0 ? cell.height * 0.4 : cell.height;
        UILabel *label = [KenUtils labelWithTxt:array[i] frame:(CGRect){cellEitOffX + width * i, i == 0 ? cell.height * 0.15 : 0, width, height}
                                           font:kKenFontHelvetica(12) color:[UIColor blackTextColor]];
        [cell.contentView addSubview:label];
        if (i == 0) {
            label.textAlignment = KTextAlignmentLeft;
            
            NSString *image = @"new_hu";
            if ([info.stockJiaoYS isEqual:@"深圳"]) {
                image = @"new_sheng";
            }
            UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
            imgV.originX = label.originX;
            [cell.contentView addSubview:imgV];
            
            UILabel *code = [KenUtils labelWithTxt:info.stockCode
                                             frame:(CGRect){cellEitOffX + imgV.width + 4, cell.height * 0.5, width, height}
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
    _preSlectedIndex = indexPath.row;
    
    _statusArray[indexPath.row] = [NSNumber numberWithBool:![_statusArray[indexPath.row] boolValue]];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *statusImg = (UIImageView *)[cell viewWithTag:10001];
    if (statusImg) {
        NSString *selectName = @"select_green.png";
        [statusImg setImage:[UIImage imageNamed:[_statusArray[indexPath.row] boolValue] ? selectName : @"select_none.png"]];
    }
}

#pragma mark - button
- (void)deleteBtnClicked {
    if (_preSlectedIndex == -1) {
        kKenAlert(@"请选择中签股");
    } else {
        [self pushViewController:[[KSBHistoryVC alloc] init]];
    }
}

@end
