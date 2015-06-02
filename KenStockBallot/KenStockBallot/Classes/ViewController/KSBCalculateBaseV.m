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
        UILabel *content1 = [KenUtils labelWithTxt:KenLocal(@"result1_content1") frame:(CGRect){15, CGRectGetMaxY(frame), 140, 40}
                                              font:kKenFontHelvetica(17) color:[UIColor greenTextColor]];
        content1.textAlignment = KTextAlignmentLeft;
        [self.contentView addSubview:content1];
        
        content1 = [KenUtils labelWithTxt:[self getTotalMoney]
                                    frame:(CGRect){CGRectGetMaxX(content1.frame), content1.originY, self.contentView.width, 40}
                                     font:kKenFontHelvetica(17) color:[UIColor blackTextColor]];
        content1.textAlignment = KTextAlignmentLeft;
        [self.contentView addSubview:content1];
        
        //content2
        UILabel *content2 = [KenUtils labelWithTxt:KenLocal(@"result1_content2")
                                             frame:(CGRect){15, CGRectGetMaxY(content1.frame), 140, 40}
                                              font:kKenFontHelvetica(17) color:[UIColor greenTextColor]];
        content2.textAlignment = KTextAlignmentLeft;
        [self.contentView addSubview:content2];
        
        content2 = [KenUtils labelWithTxt:[self getBallot] frame:(CGRect){content1.originX, content2.originY, self.contentView.width, 40}
                                     font:kKenFontHelvetica(17) color:[UIColor blackTextColor]];
        content2.textAlignment = KTextAlignmentLeft;
        [self.contentView addSubview:content2];
        
        //confirm btn
        UIButton *confirmBtn = [KenUtils buttonWithImg:nil off:0 zoomIn:NO
                                                 image:[UIImage imageNamed:@"close_btn.png"]
                                              imagesec:[UIImage imageNamed:@"close_btn_sec.png"] target:self action:@selector(closeClicked)];
        confirmBtn.center = CGPointMake(_contentView.width / 2, _contentView.height - confirmBtn.height);
        [_contentView addSubview:confirmBtn];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _contentView.frame = (CGRect){kGSize.width * 0.1, _contentView.originY, _contentView.size};
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
