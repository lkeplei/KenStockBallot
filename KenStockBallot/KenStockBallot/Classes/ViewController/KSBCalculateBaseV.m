//
//  KSBCalculateBaseV.m
//  KenStockBallot
//
//  Created by ken on 15/5/29.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBCalculateBaseV.h"

@implementation KSBCalculateBaseV

- (instancetype)initWithStockArray:(NSArray *)array {
    self = [super initWithFrame:(CGRect){CGPointZero, kGSize}];
    if (self) {
        _stockArray = [NSArray arrayWithArray:array];
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
        
        [self initContent];
        
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

- (CGRect)getContentFrame {
    return (CGRect){kGSize.width, kGSize.height * 0.2, kGSize.width * 0.8, kGSize.height * 0.6};
}

- (void)initContent {
    
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
