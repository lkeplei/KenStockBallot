//
//  KSBHistoryInfo.h
//  KenStockBallot
//
//  Created by hzyouda on 2016/12/24.
//  Copyright © 2016年 ken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSBHistoryInfo : NSObject

@property (nonatomic, strong) NSString *jiaoYS;          //交易所
@property (nonatomic, strong) NSString *name;            //申购简称
@property (nonatomic, strong) NSString *code;            //申购代码
@property (nonatomic, strong) NSString *price;             //发行价
@property (nonatomic, strong) NSString *date;            //申购日期

@property (nonatomic, strong) NSString *times;          //累计申购新股次数
@property (nonatomic, strong) NSString *ballot;          //累计概念


- (NSDictionary *)getHistoryDictionary;

@end


@interface NSDictionary (returnHistoryInfo)
-(KSBHistoryInfo *) returnHistoryInfo;
@end
