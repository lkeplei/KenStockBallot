//
//  KSBCalculateBaseV.m
//  KenStockBallot
//
//  Created by ken on 15/5/29.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBCalculateBaseV.h"

@implementation KSBCalculateBaseV

- (instancetype)initWithStockArray:(NSArray *)array money:(NSString *)money {
    self = [super initWithFrame:(CGRect){CGPointZero, kGSize}];
    if (self) {
        _stockArray = [NSArray arrayWithArray:array];
        if ([KenUtils isNotEmpty:money]) {
            _totalMoney = [money integerValue];
        }
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    }
    return self;
}

- (void)showContent {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:[self getContentFrame]];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        
        [[_contentView layer] setBorderWidth:0.2];//画线的宽度
        [[_contentView layer] setBorderColor:[UIColor darkGrayColor].CGColor];//颜色
        [[_contentView layer] setCornerRadius:8];//圆角
        [[_contentView layer] setMasksToBounds:YES];
        
        [self addSubview:_contentView];
        
        CGRect frame = [self initContent];
        
        //content1
        NSString *ballot = [self getBallot];
        NSString *string = [KenLocal(@"result1_content3") stringByAppendingString:ballot];
        UILabel *content1 = [KenUtils labelWithTxt:string frame:(CGRect){20, CGRectGetMaxY(frame), self.contentView.width - 40, 70}
                                              font:kKenFontHelvetica(20) color:[UIColor greenTextColor]];
        content1.textAlignment = KTextAlignmentLeft;
        content1.numberOfLines = 0;
        [self.contentView addSubview:content1];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenTextColor]
//                                 range:NSMakeRange(0, 19)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackTextColor]
                                 range:NSMakeRange(19, string.length - 19)];
        content1.attributedText = attributedString;
        
        
        CGFloat number = [ballot floatValue];
        NSString *name = @"new_select_1";
        if (number >= 75.0) {
            name = @"new_select_4";
        } else if (number >= 50.0) {
            name = @"new_select_3";
        } else if (number >= 25.0) {
            name = @"new_select_2";
        }
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
        imgV.center = CGPointMake(self.contentView.width / 2, CGRectGetMaxY(content1.frame) + imgV.height / 2);
        [self.contentView addSubview:imgV];
        
        //confirm btn
        UIButton *confirmBtn = [KenUtils buttonWithImg:nil off:0 zoomIn:NO
                                                 image:[UIImage imageNamed:@"close_btn.png"]
                                              imagesec:[UIImage imageNamed:@"close_btn_sec.png"] target:self action:@selector(closeClicked)];
        confirmBtn.center = CGPointMake(_contentView.width / 2, _contentView.height - confirmBtn.height);
        [_contentView addSubview:confirmBtn];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _contentView.frame = (CGRect){IsPad ? kGSize.width * 0.3 : kGSize.width * 0.1, _contentView.originY, _contentView.size};
    }];
}

- (NSString *)getTotalMoney {
    return @"";
}

- (NSString *)getBallot {
    return @"";
}

- (CGRect)getContentFrame {
    return (CGRect){kGSize.width, kGSize.height * 0.2, kGSize.width * 0.8, kGSize.height * 0.6};
}

- (CGRect)initContent {
    return CGRectMake(0, 0, 0, 0);
}

#pragma mark - button
- (void)closeClicked {
    if (_contentView) {
        [UIView animateWithDuration:0.5 animations:^{
            _contentView.frame = (CGRect){kGSize.width, _contentView.originY, _contentView.size};
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

@end
