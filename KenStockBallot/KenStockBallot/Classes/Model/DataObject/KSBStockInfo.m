//
//  KSBStockInfo.m
//  KenStockBallot
//
//  Created by ken on 15/5/27.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBStockInfo.h"

@implementation KSBStockInfo

- (NSDictionary *)getStockDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[self stockJiaoYS] forKey:@"stockJiaoYS"];
    [dic setObject:[self stockName] forKey:@"stockName"];
    [dic setObject:[self stockCode] forKey:@"stockCode"];
    [dic setObject:[NSNumber numberWithFloat:[self stockPrice]] forKey:@"stockPrice"];
    [dic setObject:[NSNumber numberWithInteger:[self stockBuyMax]] forKey:@"stockBuyMax"];
    [dic setObject:[NSNumber numberWithFloat:[self stockBallot]] forKey:@"stockBallot"];
    return dic;
}

- (void)setStockJiaoYS:(NSString *)stockJiaoYS {
    if ([KenUtils isEmpty:stockJiaoYS]) {
        _stockJiaoYS = @"";
    } else {
        _stockJiaoYS = stockJiaoYS;
    }
}

- (void)setStockName:(NSString *)stockName {
    if ([KenUtils isEmpty:stockName]) {
        _stockName = @"";
    } else {
        _stockName = stockName;
    }
}

- (void)setStockCode:(NSString *)stockCode {
    if ([KenUtils isEmpty:stockCode]) {
        _stockCode = @"";
    } else {
        _stockCode = stockCode;
    }
}

//交易所、申购代码或简称、发行价、申购股数、预估中签率为输入数据，公开渠道获得，不需计算。
//申购共需资金    =   ∑申购金额"
//"至少中一签概率=100%-（100%-申购中签率1）×（100%-申购中签率2）×（100%-申购中签率3）……

//每签股数为规定值，上海交易所为1000股，深证交易所为500股。
- (NSInteger)getMeiQianGuShu {
    if ([_stockJiaoYS isEqual:@"深圳"]) {
        return 500;
    } else if ([_stockJiaoYS isEqual:@"上海"]) {
        return 1000;
    } else {
        return 1000;
    }
}

//申购倍数      =   申购股数÷每签股数
//最大申购倍数    =   申购上限÷每签股数
- (NSInteger)getShengGouBeiShu {
    return _stockBuyMax / [self getMeiQianGuShu];
}

//申购金额      =   发行价×申购股数
//最大申购金额    =   发行价×申购上限
- (CGFloat)getShengGouMoney {
    return _stockPrice * _stockBuyMax;
}

//申购中签率 =   预估中签率×申购倍数
//累计中签率 =   预估中签率×最大申购倍数
- (CGFloat)getShengGouBallot {
    return _stockBallot * [self getShengGouBeiShu];
}

//万元中签率 =   累计中签率÷最大申购金额×10000
- (CGFloat)getTenThoundBallot {
    return [self getShengGouBallot] / [self getShengGouMoney] * 10000;
}


//计划申购总资金为输入数据。
//"依据万元中签率可以得出建议申购股数、建议申购金额、申购中签率、至少中一签概率这些数据。
//计算原则为：从万元中签率最高的股票开始买入，按照申购上限买入后还有资金剩余，继续买入剩余股票中万元中签率最高的股票，直到将计划申购总资金分配完。其中，建议申购股数必须为每签股数的整数倍。
//建议申购金额=发行价×建议申购股数
//申购中签率=建议申购股数÷每签股数×预估中签率
//至少中一签概率=100%-（100%-申购中签率1）×（100%-申购中签率2）×（100%-申购中签率3）……
//申购共需资金=∑建议申购金额"
- (CGFloat)getSuggestionBallot {
    return _suggestionBuy / [self getMeiQianGuShu] * _stockBallot;
}

@end


@implementation NSDictionary (returnStockInfo)

- (KSBStockInfo *)returnStockInfo {
    KSBStockInfo *info = [[KSBStockInfo alloc] init];

    info.stockJiaoYS = [self objectForKey:@"stockJiaoYS"];
    info.stockName = [self objectForKey:@"stockName"];
    info.stockCode = [self objectForKey:@"stockCode"];
    info.stockPrice = [[self objectForKey:@"stockPrice"] floatValue];
    info.stockBuyMax = [[self objectForKey:@"stockBuyMax"] integerValue];
    info.stockBallot = [[self objectForKey:@"stockBallot"] floatValue];
    
    return info;
}

@end