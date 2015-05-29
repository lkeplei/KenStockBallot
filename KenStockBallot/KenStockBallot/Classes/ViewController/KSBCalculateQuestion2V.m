//
//  KSBCalculateQuestion2V.m
//  KenStockBallot
//
//  Created by ken on 15/5/29.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBCalculateQuestion2V.h"

@interface KSBCalculateQuestion2V ()

@end

@implementation KSBCalculateQuestion2V

- (CGRect)getContentFrame {
    return (CGRect){kGSize.width, kGSize.height * 0.2, kGSize.width * 0.8, kGSize.height * 0.8};
}

- (void)initContent {
    UILabel *title = [KenUtils labelWithTxt:KenLocal(@"result2_title") frame:(CGRect){15, 5, self.contentView.width, 44}
                                       font:kKenFontHelvetica(16) color:[UIColor greenTextColor]];
    title.textAlignment = KTextAlignmentLeft;
    [self.contentView addSubview:title];
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){0, CGRectGetMaxY(title.frame), self.contentView.width, 1}];
    [line setBackgroundColor:[UIColor greenTextColor]];
    [self.contentView addSubview:line];
}
@end
