//
//  KSBSelectedVC.h
//  KenStockBallot
//
//  Created by hzyouda on 2016/12/24.
//  Copyright © 2016年 ken. All rights reserved.
//

#import "KSBBaseVC.h"

@interface KSBSelectedVC : KSBBaseVC

- (instancetype)initWithStockType:(KSBCalculateType)type num:(NSInteger)num ballot:(NSString *)ballot;

@end
