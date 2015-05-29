//
//  KSBStockInfo.h
//  KenStockBallot
//
//  Created by ken on 15/5/27.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSBStockInfo : NSObject

@property (nonatomic, strong) NSString *stockJiaoYS;          //交易所
@property (nonatomic, strong) NSString *stockName;            //申购简称
@property (nonatomic, strong) NSString *stockCode;            //申购代码
@property (nonatomic, assign) CGFloat stockPrice;             //发行价
@property (nonatomic, assign) NSInteger stockBuyMax;          //申购上限（申购股数）
@property (nonatomic, assign) CGFloat stockBallot;            //预估中签率

- (NSDictionary *)getStockDictionary;

- (NSInteger)getMeiQianGuShu;
- (NSInteger)getShengGouBeiShu;
- (CGFloat)getShengGouMoney;
- (CGFloat)getShengGouBallot;
- (CGFloat)getTenThoundBallot;

@end

@interface NSDictionary (returnStockInfo)
-(KSBStockInfo *) returnStockInfo;
@end