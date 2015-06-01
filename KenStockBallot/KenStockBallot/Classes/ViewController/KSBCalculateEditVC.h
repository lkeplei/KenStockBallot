//
//  KSBCalculateEditVC.h
//  KenStockBallot
//
//  Created by ken on 15/6/1.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBBaseVC.h"

@interface KSBCalculateEditVC : KSBBaseVC<UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithStock:(NSArray *)stockArray questionType:(KSBCalculateType)type;

@end
