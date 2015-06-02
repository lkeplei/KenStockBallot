//
//  KSBMainCalculateVC.h
//  KenStockBallot
//
//  Created by ken on 15/5/27.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBBaseVC.h"

@interface KSBMainCalculateVC : KSBBaseVC<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

- (instancetype)initWithCalculateType:(KSBCalculateType)type;

@end
