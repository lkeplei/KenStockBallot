//
//  KSBModel.h
//  KenStockBallot
//
//  Created by ken on 15/5/27.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSBModel : NSObject

//model
+ (KSBModel *)shareKSBModel;

- (void)setDataByKey:(id)object forkey:(NSString *)key;
- (void)removeDataByKey:(NSString *)key;
- (id)getDataByKey:(NSString *)key;

- (void)saveStock:(NSArray *)stockArray type:(KSBCalculateType)type;
- (NSArray *)getStock:(KSBCalculateType)type;

@end
