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
    return (CGRect){kGSize.width, kGSize.height * 0.32, kGSize.width * 0.8, kGSize.height * 0.36};
}

- (void)initContent {
    UILabel *title = [KenUtils labelWithTxt:KenLocal(@"result1_title") frame:(CGRect){0, 5, self.contentView.width, 44}
                                       font:kKenFontHelvetica(18) color:[UIColor greenTextColor]];
    [self.contentView addSubview:title];
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){0, CGRectGetMaxY(title.frame), self.contentView.width, 1}];
    [line setBackgroundColor:[UIColor greenTextColor]];
    [self.contentView addSubview:line];
    
    //content1
    UILabel *content1 = [KenUtils labelWithTxt:KenLocal(@"result1_content1") frame:(CGRect){15, CGRectGetMaxY(line.frame), 130, 40}
                                       font:kKenFontHelvetica(16) color:[UIColor greenTextColor]];
    content1.textAlignment = KTextAlignmentLeft;
    [self.contentView addSubview:content1];
    
    content1 = [KenUtils labelWithTxt:[self getTotalMoney]
                                frame:(CGRect){CGRectGetMaxX(content1.frame), content1.originY, self.contentView.width, 40}
                                 font:kKenFontHelvetica(16) color:[UIColor blackTextColor]];
    content1.textAlignment = KTextAlignmentLeft;
    [self.contentView addSubview:content1];
    
    //content2
    UILabel *content2 = [KenUtils labelWithTxt:KenLocal(@"result1_content2")
                                         frame:(CGRect){15, CGRectGetMaxY(content1.frame), 130, 40}
                                          font:kKenFontHelvetica(16) color:[UIColor greenTextColor]];
    content2.textAlignment = KTextAlignmentLeft;
    [self.contentView addSubview:content2];
    
    content2 = [KenUtils labelWithTxt:[self getBallot] frame:(CGRect){content1.originX, content2.originY, self.contentView.width, 40}
                                 font:kKenFontHelvetica(16) color:[UIColor blackTextColor]];
    content2.textAlignment = KTextAlignmentLeft;
    [self.contentView addSubview:content2];
}

- (NSString *)getTotalMoney {
    NSInteger money = 0;
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
        ballot *= (1 - [info getShengGouBallot]);
    }
    return [NSString stringWithFormat:@"%.2f%%", (1 - ballot) * 100];
}
@end
