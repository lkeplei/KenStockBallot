//
//  KSBSelectedVC.m
//  KenStockBallot
//
//  Created by hzyouda on 2016/12/24.
//  Copyright © 2016年 ken. All rights reserved.
//

#import "KSBSelectedVC.h"

@interface KSBSelectedVC ()

@end

@implementation KSBSelectedVC
- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = KenLocal(@"app_selected_title");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
