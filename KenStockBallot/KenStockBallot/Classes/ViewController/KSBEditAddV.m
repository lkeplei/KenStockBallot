//
//  KSBEditAddV.m
//  KenStockBallot
//
//  Created by ken on 15/5/28.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBEditAddV.h"
#import "KSBStockInfo.h"

@interface KSBEditAddV ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong, readonly) KSBStockInfo *stockInfo;

@end

@implementation KSBEditAddV

- (instancetype)initWithStock:(KSBStockInfo *)info {
    self = [super initWithFrame:(CGRect){CGPointZero, kGSize}];
    if (self) {
        _stockInfo = info;
    }
    return self;
}

- (void)showView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:(CGRect){}];
    }
}
@end
