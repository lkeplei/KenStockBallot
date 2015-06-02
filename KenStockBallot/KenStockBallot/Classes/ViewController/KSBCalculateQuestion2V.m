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
    return @"100000";
}

- (NSString *)getBallot {
    return @"26%";
}

- (void)calculateStockCombination {
    _dataArray = [NSMutableArray array];
    
    for (int i = 0; i < 6; i++) {
        [_dataArray addObject:@[@"永创智能", @"20000股", @"1000000元", @"603901"]];
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
    
    NSArray *contentArray = [_dataArray objectAtIndex:indexPath.row];
    float width = self.contentView.width / ([contentArray count] - 1);
    for (int i = 0; i < [contentArray count] - 1; i++) {
        float height = i == 0 ? cellHeight * 0.4 : cellHeight;
        UILabel *label = [KenUtils labelWithTxt:contentArray[i] frame:(CGRect){width * i, i == 0 ? cellHeight * 0.15 : 0, width, height}
                                           font:kKenFontHelvetica(12) color:[UIColor blackTextColor]];
        [cell.contentView addSubview:label];
        if (i == 0) {
            UILabel *code = [KenUtils labelWithTxt:[contentArray lastObject] frame:(CGRect){0, cellHeight * 0.5, width, height}
                                              font:kKenFontHelvetica(12) color:[UIColor grayTextColor]];
            [cell.contentView addSubview:code];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
@end
