//
//  KSBStockInfo.h
//  KenStockBallot
//
//  Created by ken on 15/5/27.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSBStockInfo : NSObject

@property (nonatomic, readonly) NSString *stockJiaoYS;          //交易所
@property (nonatomic, readonly) NSString *stockCode;            //申购代码或简称
@property (nonatomic, readonly) CGFloat stockPrice;             //发行价
@property (nonatomic, readonly) NSInteger stockBuyMax;          //申购上限（申购股数）
@property (nonatomic, readonly) CGFloat stockBallot;            //预估中签率

@end

@interface NSDictionary (returnStockInfo)
-(KSBStockInfo *) returnStockInfo;
@end