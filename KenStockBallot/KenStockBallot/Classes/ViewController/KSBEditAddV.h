//
//  KSBEditAddV.h
//  KenStockBallot
//
//  Created by ken on 15/5/28.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSBStockInfo;

@interface KSBEditAddV : UIView

- (instancetype)initWithStock:(KSBStockInfo *)info;

- (void)showView;

@end
