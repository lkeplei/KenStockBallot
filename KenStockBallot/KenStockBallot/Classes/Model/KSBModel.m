//
//  KSBModel.m
//  KenStockBallot
//
//  Created by ken on 15/5/27.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBModel.h"
#import "KSBStockInfo.h"

@implementation KSBModel

static KSBModel *_sharedModel = nil;

+ (KSBModel *)shareKSBModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[KSBModel alloc] init];
    });
    return _sharedModel;
}

- (void)saveStock:(NSArray *)stockArray {
    NSMutableArray *array = [NSMutableArray array];
    for (KSBStockInfo *info in stockArray) {
        [array addObject:[info getStockDictionary]];
    }
    [self setDataByKey:array forkey:kUserDefaultUserStock];
}

- (NSArray *)getStock {
    NSArray *stockArray = [self getDataByKey:kUserDefaultUserStock];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in stockArray) {
        [array addObject:[dic returnStockInfo]];
    }
    
    return array;
}

#pragma mark - user default
- (void)setDataByKey:(id)object forkey:(NSString *)key {
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}

- (void)removeDataByKey:(NSString *)key {
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

- (id)getDataByKey:(NSString *)key {
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}
@end
