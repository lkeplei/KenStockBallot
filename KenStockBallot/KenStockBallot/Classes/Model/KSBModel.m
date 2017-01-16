//
//  KSBModel.m
//  KenStockBallot
//
//  Created by ken on 15/5/27.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBModel.h"
#import "KSBStockInfo.h"
#import "KSBHistoryInfo.h"

@implementation KSBModel

static KSBModel *_sharedModel = nil;

+ (KSBModel *)shareKSBModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[KSBModel alloc] init];
    });
    return _sharedModel;
}

- (void)saveStock:(NSArray *)stockArray type:(KSBCalculateType)type {
    NSMutableArray *array = [NSMutableArray array];
    for (KSBStockInfo *info in stockArray) {
        [array addObject:[info getStockDictionary]];
    }
    
    if (type == kKSBCalculateQuestion1) {
        [self setDataByKey:array forkey:kUserDefaultUserStock1];
    } else if (type == kKSBCalculateQuestion2) {
        [self setDataByKey:array forkey:kUserDefaultUserStock2];
    }
}

- (NSArray *)getStock:(KSBCalculateType)type {
    NSArray *stockArray = nil;
    if (type == kKSBCalculateQuestion1) {
        stockArray = [self getDataByKey:kUserDefaultUserStock1];
    } else if (type == kKSBCalculateQuestion2) {
        stockArray = [self getDataByKey:kUserDefaultUserStock2];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in stockArray) {
        [array addObject:[dic returnStockInfo]];
    }
    
    NSArray *sortedArray = [array sortedArrayUsingComparator: ^(KSBStockInfo *obj1, KSBStockInfo *obj2) {
        NSComparisonResult result = [obj1.stockDate compare:obj2.stockDate];
        switch(result) {
            case NSOrderedAscending:
                return NSOrderedDescending;
            case NSOrderedDescending:
                return NSOrderedAscending;
            case NSOrderedSame:
            default: {
                NSComparisonResult result1 = [obj1.stockCode compare:obj2.stockCode];
                switch(result1) {
                    case NSOrderedAscending:
                        return NSOrderedAscending;
                    case NSOrderedDescending:
                        return NSOrderedDescending;
                    case NSOrderedSame:
                    default:
                        return NSOrderedSame;
                }
            }
                break;
        }
    }];
    
    return sortedArray;
}

- (void)saveHistory:(NSArray *)stockArray {
    NSMutableArray *array = [NSMutableArray array];
    for (KSBHistoryInfo *info in stockArray) {
        [array addObject:[info getHistoryDictionary]];
    }
    
    [self setDataByKey:array forkey:kUserDefaultUserHistroy];
}

- (NSArray *)getHistory {
    NSArray *stockArray = [self getDataByKey:kUserDefaultUserHistroy];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in stockArray) {
        [array addObject:[dic returnHistoryInfo]];
    }
    
    NSArray *sortedArray = [array sortedArrayUsingComparator: ^(KSBHistoryInfo *obj1, KSBHistoryInfo *obj2) {
        NSComparisonResult result = [obj1.date compare:obj2.date];
        switch(result) {
            case NSOrderedAscending:
                return NSOrderedDescending;
            case NSOrderedDescending:
                return NSOrderedAscending;
            case NSOrderedSame:
            default: {
                NSComparisonResult result1 = [obj1.code compare:obj2.code];
                switch(result1) {
                    case NSOrderedAscending:
                        return NSOrderedAscending;
                    case NSOrderedDescending:
                        return NSOrderedDescending;
                    case NSOrderedSame:
                    default:
                        return NSOrderedSame;
                }
            }
                break;
        }
    }];
    
    return sortedArray;
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
