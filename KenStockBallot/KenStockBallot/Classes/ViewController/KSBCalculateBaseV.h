//
//  KSBCalculateBaseV.h
//  KenStockBallot
//
//  Created by ken on 15/5/29.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSBCalculateBaseV : UIView

- (instancetype)initWithStockArray:(NSArray *)array;
- (void)showContent;
- (CGRect)getContentFrame;
- (void)initContent;

@property (nonatomic, strong) NSArray *stockArray;
@property (nonatomic, strong) UIView *contentView;

@end
