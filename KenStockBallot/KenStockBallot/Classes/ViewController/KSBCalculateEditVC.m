//
//  KSBCalculateEditVC.m
//  KenStockBallot
//
//  Created by ken on 15/6/1.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBCalculateEditVC.h"
#import "KSBStockInfo.h"

static const int cellEitOffX = 30;

@interface KSBCalculateEditVC ()

@property (assign) KSBCalculateType calculateType;
@property (nonatomic, strong) UITableView *stockTable;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *statusArray;

@end

@implementation KSBCalculateEditVC

- (instancetype)initWithStock:(NSArray *)stockArray questionType:(KSBCalculateType)type {
    self = [super init];
    if (self) {
        self.title = KenLocal(@"app_title");
        [self.view setBackgroundColor:[UIColor grayBgColor]];

        _calculateType = type;
        _dataArray = [NSMutableArray arrayWithArray:stockArray];
        _statusArray = [NSMutableArray array];
        for (int i = 0; i < [_dataArray count]; i++) {
            [_statusArray addObject:[NSNumber numberWithBool:NO]];
        }
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
    
    NSArray *titleArr = @[KenLocal(@"question_title1"), KenLocal(@"question_title2"), KenLocal(@"question_title3"),
                          KenLocal(@"question_title4"), KenLocal(@"question_title5")];
    float width = (kGSize.width - cellEitOffX) / [titleArr count];
    for (int i = 0; i < [titleArr count]; i++) {
        UILabel *label = [KenUtils labelWithTxt:titleArr[i] frame:(CGRect){cellEitOffX + width * i, 0, width, 44}
                                           font:kKenFontHelvetica(12) color:[UIColor greenTextColor]];
        label.numberOfLines = i == ([titleArr count] - 1) ? 2 : 1;
        [titleV addSubview:label];
    }
    
    UIButton *deleteBtn = [KenUtils buttonWithImg:KenLocal(@"app_delete") off:0 zoomIn:NO image:nil
                                            imagesec:nil target:self action:@selector(deleteBtnClicked)];
    [deleteBtn.titleLabel setFont:kKenFontHelvetica(16)];
    deleteBtn.frame = CGRectMake(0, kGSize.height - 44, self.view.width, 44);
    [deleteBtn setBackgroundColor:[UIColor colorWithHexString:@"#FF643B"]];
    [self.view addSubview:deleteBtn];
    
    CGRect rect = CGRectMake(0, CGRectGetMaxY(topView.frame), kGSize.width, deleteBtn.originY - CGRectGetMaxY(topView.frame));
    _stockTable = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _stockTable.delegate = self;
    _stockTable.dataSource = self;
    [_stockTable setBackgroundColor:[UIColor grayBgColor]];
    _stockTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_stockTable];
    
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
    
    UIImageView *status = [[UIImageView alloc] initWithImage:[UIImage imageNamed:
                                                              [_statusArray[indexPath.row] boolValue] ? @"select_red.png" : @"select_none.png"]];
    status.center = CGPointMake(cell.height / 2, cell.height / 2);
    status.tag = 10001;
    [cell.contentView addSubview:status];
    
    KSBStockInfo *info = _dataArray[indexPath.row];
    NSArray *array = @[info.stockName, info.stockJiaoYS,
                       [NSString stringWithFormat:@"%.2f%@", info.stockPrice, KenLocal(@"edit_yuan")],
                       [NSString stringWithFormat:@"%d%@", info.stockBuyMax, KenLocal(@"edit_gu")],
                       [NSString stringWithFormat:@"%.4f%%", info.stockBallot]];
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
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){cellEitOffX, cell.height - 1, cell.width, 1}];
    [line setBackgroundColor:[UIColor separatorMainColor]];
    [cell.contentView addSubview:line];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _statusArray[indexPath.row] = [NSNumber numberWithBool:![_statusArray[indexPath.row] boolValue]];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *statusImg = (UIImageView *)[cell viewWithTag:10001];
    if (statusImg) {
        [statusImg setImage:[UIImage imageNamed:[_statusArray[indexPath.row] boolValue] ? @"select_red.png" : @"select_none.png"]];
    }
}

#pragma mark - button
- (void)deleteBtnClicked {
    for (int i = [_statusArray count] - 1; i >= 0; i--) {
        if ([_statusArray[i] boolValue]) {
            [_dataArray removeObjectAtIndex:i];
            [_statusArray removeObjectAtIndex:i];
        }
    }
    
    [_stockTable reloadData];
    
    [[KSBModel shareKSBModel] saveStock:_dataArray type:_calculateType];
}
@end
