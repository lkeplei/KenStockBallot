//
//  KSBCalculateQuestion1V.m
//  KenStockBallot
//
//  Created by ken on 15/5/29.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBCalculateQuestion1V.h"
#import "KSBStockInfo.h"

@interface KSBCalculateQuestion1V ()

@end

@implementation KSBCalculateQuestion1V

- (CGRect)getContentFrame {
    return (CGRect){kGSize.width, (kGSize.height - 180) / 2, IsPad ? kGSize.width * 0.4 : kGSize.width * 0.8, 180};
}

- (CGRect)initContent {
    UILabel *title = [KenUtils labelWithTxt:KenLocal(@"result1_title") frame:(CGRect){0, 5, self.contentView.width, 44}
                                       font:kKenFontHelvetica(18) color:[UIColor greenTextColor]];
    [self.contentView addSubview:title];
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){0, CGRectGetMaxY(title.frame), self.contentView.width, 1}];
    [line setBackgroundColor:[UIColor greenTextColor]];
    [self.contentView addSubview:line];
    
    return line.frame;
}

- (NSString *)getTotalMoney {
    int money = 0;
    for (int i = 0; i < [self.stockArray count]; i++) {
        KSBStockInfo *info = (KSBStockInfo *)[self.stockArray objectAtIndex:i];
        money += [info getShengGouMoney];
    }
    return [NSString stringWithFormat:@"%d%@", money, KenLocal(@"edit_yuan")];
}

- (NSString *)getBallot {
    //"至少中一签概率=100%-（100%-申购中签率1）×（100%-申购中签率2）×（100%-申购中签率3）……
    float ballot = 1;
    for (int i = 0; i < [self.stockArray count]; i++) {
        KSBStockInfo *info = (KSBStockInfo *)[self.stockArray objectAtIndex:i];
        ballot *= (1 - ([info getShengGouBallot] / 100));
    }
    return [NSString stringWithFormat:@"%.2f%%", MIN((1 - ballot), 1) * 100];
}
@end
