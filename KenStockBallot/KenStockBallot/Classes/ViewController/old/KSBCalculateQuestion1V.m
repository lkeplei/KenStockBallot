//
//  KSBCalculateQuestion1V.m
//  KenStockBallot
//
//  Created by ken on 15/5/29.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBCalculateQuestion1V.h"
#import "KSBStockInfo.h"
#import "KSBSelectedVC.h"

@interface KSBCalculateQuestion1V ()

@end

@implementation KSBCalculateQuestion1V

- (CGRect)getContentFrame {
    UIImage *image = [UIImage imageNamed:@"new_select_1"];
    return (CGRect){kGSize.width, (kGSize.height - 180) / 2, IsPad ? kGSize.width * 0.4 : kGSize.width * 0.8,
                    180 + image.size.height * 1.2};
}

- (CGRect)initContent {
    UILabel *title = [KenUtils labelWithTxt:KenLocal(@"result1_title") frame:(CGRect){0, 5, self.contentView.width, 44}
                                       font:kKenFontHelvetica(18) color:[UIColor greenTextColor]];
    [self.contentView addSubview:title];
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){0, CGRectGetMaxY(title.frame), self.contentView.width, 1}];
    [line setBackgroundColor:[UIColor greenTextColor]];
    [self.contentView addSubview:line];
    
    UIButton *seleBtn = [KenUtils buttonWithImg:nil off:0 zoomIn:YES
                                          image:[UIImage imageNamed:@"new_select_normal"]
                                       imagesec:[UIImage imageNamed:@"new_select_hl"] target:self action:@selector(seleBtnCliked)];
    seleBtn.height = title.height;
    seleBtn.center = CGPointMake(self.contentView.width - seleBtn.width / 2 - 15, title.centerY);
    [self.contentView addSubview:seleBtn];
    
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
    return [NSString stringWithFormat:@"%.4f%%", MIN((1 - ballot), 1) * 100];
}

#pragma mark - event
- (void)seleBtnCliked {
    if (self.parentVC) {
        [self removeFromSuperview];
        [self.parentVC pushViewController:[[KSBSelectedVC alloc] initWithStockType:kKSBCalculateQuestion1]];
    }
}

@end
