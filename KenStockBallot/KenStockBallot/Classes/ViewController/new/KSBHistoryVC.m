//
//  KSBHistoryVC.m
//  KenStockBallot
//
//  Created by hzyouda on 2016/12/24.
//  Copyright © 2016年 ken. All rights reserved.
//

#import "KSBHistoryVC.h"
#import "KSBHistoryInfo.h"

#import <BmobSDK/Bmob.h>

static const int cellEitOffX = 20;

@interface KSBHistoryVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *stockTable;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *preDataArray;

@end

@implementation KSBHistoryVC
- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = KenLocal(@"app_history_title");
        
        [self setData:[[KSBModel shareKSBModel] getHistory]];
        
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
    NSArray *titleArr = @[KenLocal(@"question_title1"), KenLocal(@"question_title3"), @"累计申购\n新股次数",
                          @"中签时的\n累积概率", KenLocal(@"question_title6")];
    float width = (kGSize.width - cellEitOffX) / [titleArr count];
    for (int i = 0; i < [titleArr count]; i++) {
        UILabel *label = [KenUtils labelWithTxt:titleArr[i]
                                          frame:(CGRect){cellEitOffX + width * i, 0, (i == 0 ? width - 20 : width), 44}
                                           font:kKenFontHelvetica(12) color:[UIColor greenTextColor]];
        label.numberOfLines = 0;
        [titleV addSubview:label];
    }
    
    //table
    CGRect rect = CGRectMake(0, CGRectGetMaxY(topView.frame), kGSize.width, self.view.height - CGRectGetMaxY(topView.frame));
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
    
    KSBHistoryInfo *info = _dataArray[indexPath.row];
    NSArray *array = @[info.name, info.price, info.times, info.ballot, info.date];
    float width = (kGSize.width - cellEitOffX) / [array count];
    for (int i = 0; i < [array count]; i++) {
        float height = i == 0 ? cell.height * 0.4 : cell.height;
        UILabel *label = [KenUtils labelWithTxt:array[i] frame:(CGRect){cellEitOffX + width * i, i == 0 ? cell.height * 0.15 : 0, width, height}
                                           font:kKenFontHelvetica(12) color:[UIColor blackTextColor]];
        [cell.contentView addSubview:label];
        if (i == 0) {
            label.textAlignment = KTextAlignmentLeft;
            
            NSString *image = @"new_hu";
            if ([info.jiaoYS isEqual:@"深圳"]) {
                image = @"new_sheng";
            }
            UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
            imgV.originX = label.originX;
            [cell.contentView addSubview:imgV];
            
            UILabel *code = [KenUtils labelWithTxt:info.code
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

}

@end
