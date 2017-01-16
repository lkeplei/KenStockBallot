//
//  KSBSelectedVC.h
//  KenStockBallot
//
//  Created by hzyouda on 2016/12/24.
//  Copyright © 2016年 ken. All rights reserved.
//

#import "KSBBaseVC.h"

@class KSBHistoryInfo;

typedef void (^KSBSelectBlock)(KSBHistoryInfo *info);

@interface KSBSelectedVC : KSBBaseVC

- (instancetype)initWithStockType:(KSBCalculateType)type num:(NSInteger)num ballot:(NSString *)ballot;

@property (nonatomic, copy) KSBSelectBlock selectBlock;

@end
