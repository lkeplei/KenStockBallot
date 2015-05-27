//
//  KSBModel.m
//  KenStockBallot
//
//  Created by ken on 15/5/27.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBModel.h"

@implementation KSBModel

static KSBModel *_sharedModel = nil;

+ (KSBModel *)shareKSBModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[KSBModel alloc] init];
    });
    return _sharedModel;
}

@end
