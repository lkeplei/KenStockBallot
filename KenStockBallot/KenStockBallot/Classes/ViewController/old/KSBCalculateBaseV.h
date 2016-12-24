//
//  KSBCalculateBaseV.h
//  KenStockBallot
//
//  Created by ken on 15/5/29.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSBBaseVC;

@interface KSBCalculateBaseV : UIView

- (instancetype)initWithStockArray:(NSArray *)array money:(NSString *)money;
- (void)showContent;
- (CGRect)getContentFrame;
- (CGRect)initContent;
- (NSString *)getTotalMoney;
- (NSString *)getBallot;

@property (nonatomic, readonly) NSInteger totalMoney;
@property (nonatomic, strong) NSArray *stockArray;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) KSBBaseVC *parentVC;

@end
