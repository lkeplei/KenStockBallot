//
//  KSBHistoryInfo.m
//  KenStockBallot
//
//  Created by hzyouda on 2016/12/24.
//  Copyright © 2016年 ken. All rights reserved.
//

#import "KSBHistoryInfo.h"

@implementation KSBHistoryInfo

- (NSDictionary *)getHistoryDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.jiaoYS forKey:@"jiaoYS"];
    [dic setObject:self.name forKey:@"name"];
    [dic setObject:self.code forKey:@"code"];
    [dic setObject:self.date forKey:@"date"];
    [dic setObject:self.price forKey:@"price"];
    [dic setObject:self.times forKey:@"times"];
    [dic setObject:self.ballot forKey:@"ballot"];
    return dic;
}

@end


@implementation NSDictionary (returnHistoryInfo)

- (KSBHistoryInfo *)returnHistoryInfo {
    KSBHistoryInfo *info = [[KSBHistoryInfo alloc] init];
    
    info.jiaoYS = [self objectForKey:@"jiaoYS"];
    info.name = [self objectForKey:@"name"];
    info.code = [self objectForKey:@"code"];
    info.date = [self objectForKey:@"date"];
    info.price = [self objectForKey:@"price"];
    info.times = [self objectForKey:@"times"];
    info.ballot = [self objectForKey:@"ballot"];
    
    return info;
}

@end
