//
//  KSBCalculateQuestion2V.m
//  KenStockBallot
//
//  Created by ken on 15/5/29.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBCalculateQuestion2V.h"
#import "KSBStockInfo.h"

static const float cellHeight = 40;
static const float maxCellNumber = 3;

@interface KSBCalculateQuestion2V ()

@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *stockTable;

@end

@implementation KSBCalculateQuestion2V

- (CGRect)getContentFrame {
    [self calculateStockCombination];
    
    _centerView = [[UIView alloc] initWithFrame:(CGRect){0, 45, kGSize.width * 0.8, cellHeight * (MIN(maxCellNumber, _dataArray.count)  + 1)}];
    float height = 45 + _centerView.height + 80 + 64;
    
    return (CGRect){kGSize.width, (kGSize.height - height) / 2, kGSize.width * 0.8, height};
}

- (CGRect)initContent {
    UILabel *title = [KenUtils labelWithTxt:KenLocal(@"result2_title") frame:(CGRect){0, 0, self.contentView.width, 44}
                                       font:kKenFontHelvetica(16) color:[UIColor greenTextColor]];
    [self.contentView addSubview:title];
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){0, CGRectGetMaxY(title.frame), self.contentView.width, 1}];
    [line setBackgroundColor:[UIColor greenTextColor]];
    [self.contentView addSubview:line];
    
    //center view
    [_centerView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:_centerView];
    
    NSArray *titleArr = @[KenLocal(@"result2_cell_title1"), KenLocal(@"result2_cell_title2"), KenLocal(@"result2_cell_title3")];
    float width = self.contentView.width / [titleArr count];
    for (int i = 0; i < [titleArr count]; i++) {
        UILabel *label = [KenUtils labelWithTxt:titleArr[i] frame:(CGRect){width * i, 0, width, cellHeight}
                                           font:kKenFontHelvetica(16) color:[UIColor greenTextColor]];
        [_centerView addSubview:label];
    }
    
    CGRect rect = CGRectMake(0, cellHeight, _centerView.width, cellHeight * MIN(maxCellNumber, _dataArray.count));
    _stockTable = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _stockTable.delegate = self;
    _stockTable.dataSource = self;
    _stockTable.rowHeight = cellHeight;
    [_stockTable setBackgroundColor:[UIColor whiteColor]];
    _stockTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_stockTable setScrollEnabled:[_dataArray count] > maxCellNumber];
    [_centerView addSubview:_stockTable];

    UIView *lineB = [[UIView alloc] initWithFrame:(CGRect){10, CGRectGetMaxY(_centerView.frame), self.contentView.width - 20, 1}];
    [lineB setBackgroundColor:[UIColor greenTextColor]];
    [self.contentView addSubview:lineB];
    
    return _centerView.frame;
}

- (NSString *)getTotalMoney {
    NSInteger money = 0;
    for (int i = 0; i < [_dataArray count]; i++) {
        KSBStockInfo *info = (KSBStockInfo *)[_dataArray objectAtIndex:i];
        money += info.suggestionMoney;
    }
    return [NSString stringWithFormat:@"%d%@", money, KenLocal(@"edit_yuan")];
}

- (NSString *)getBallot {
    //"至少中一签概率=100%-（100%-申购中签率1）×（100%-申购中签率2）×（100%-申购中签率3）……
    float ballot = 1;
    for (int i = 0; i < [_dataArray count]; i++) {
        KSBStockInfo *info = (KSBStockInfo *)[_dataArray objectAtIndex:i];
        ballot *= (1 - ([info getSuggestionBallot] / 100));
    }
    return [NSString stringWithFormat:@"%.2f%%", MIN((1 - ballot), 1) * 100];
}

NSInteger sortType(id st, id str, void *cha) {
    KSBStockInfo *info1 = (KSBStockInfo *)st;
    KSBStockInfo *info2 = (KSBStockInfo *)str;

    if (info1.stockBallot > info2.stockBallot) {
        return NSOrderedAscending;
    } else if (info1.stockBallot < info2.stockBallot) {
        return NSOrderedDescending;
    }
    
    return NSOrderedSame;
}

- (void)calculateStockCombination {
    _dataArray = [NSMutableArray array];
    
    //首先对股票进行排序，中签率由高到低
    NSArray *resultArray = [self.stockArray sortedArrayUsingFunction:sortType context:nil];
    
    float currentMoney = self.totalMoney;
    BOOL over = NO;
    for (int i = 0; i < [resultArray count]; i++) {
        KSBStockInfo *info = [resultArray objectAtIndex:i];
        if (currentMoney > info.stockBuyMax * info.stockPrice) {
            [info setSuggestionBuy:info.stockBuyMax];
            [info setSuggestionMoney:[info getShengGouMoney]];
        } else {
            [info setSuggestionBuy:currentMoney / info.stockPrice];
            [info setSuggestionMoney:info.suggestionBuy * info.stockPrice];
            over = YES;
        }
        
        if (info.suggestionBuy <= 0 && [_dataArray count] <= 0) {
            kKenAlert(KenLocal(@"result2_alert"));
            return;
        } else {
            currentMoney -= info.suggestionMoney;
            [_dataArray addObject:info];
            if (over) {
                return;
            }
        }
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
    
    KSBStockInfo *info = _dataArray[indexPath.row];
    NSArray *array = @[info.stockName, [NSString stringWithFormat:@"%d%@", info.suggestionBuy, KenLocal(@"edit_gu")],
                       [NSString stringWithFormat:@"%.2f%@", info.suggestionMoney, KenLocal(@"edit_yuan")]];
    float width = self.contentView.width / [array count];
    for (int i = 0; i < [array count]; i++) {
        float height = i == 0 ? cellHeight * 0.4 : cellHeight;
        UILabel *label = [KenUtils labelWithTxt:array[i] frame:(CGRect){width * i, i == 0 ? cellHeight * 0.15 : 0, width, height}
                                           font:kKenFontHelvetica(12) color:[UIColor blackTextColor]];
        [cell.contentView addSubview:label];
        if (i == 0) {
            UILabel *code = [KenUtils labelWithTxt:info.stockCode frame:(CGRect){0, cellHeight * 0.5, width, height}
                                              font:kKenFontHelvetica(12) color:[UIColor grayTextColor]];
            [cell.contentView addSubview:code];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
@end
