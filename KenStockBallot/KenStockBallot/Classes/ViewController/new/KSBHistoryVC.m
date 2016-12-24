//
//  KSBHistoryVC.m
//  KenStockBallot
//
//  Created by hzyouda on 2016/12/24.
//  Copyright © 2016年 ken. All rights reserved.
//

#import "KSBHistoryVC.h"

@interface KSBHistoryVC ()

@end

@implementation KSBHistoryVC
- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = KenLocal(@"app_history_title");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
