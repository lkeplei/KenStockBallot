//
//  KSBEditAddV.h
//  KenStockBallot
//
//  Created by ken on 15/5/28.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSBStockInfo;

typedef void (^addStockInfo)(KSBStockInfo *info);
typedef void (^editStockInfo)(KSBStockInfo *info);

@interface KSBEditAddV : UIView<UITextFieldDelegate>

- (instancetype)initWithStock:(KSBStockInfo *)info;
- (void)showContent;

@property (nonatomic, copy) addStockInfo addBlock;
@property (nonatomic, copy) editStockInfo editBlock;

@end
