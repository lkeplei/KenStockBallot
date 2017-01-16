//
//  KSBAboutUsVC.m
//  KenStockBallot
//
//  Created by Ken.Liu on 2017/1/16.
//  Copyright © 2017年 ken. All rights reserved.
//

#import "KSBAboutUsVC.h"

@interface KSBAboutUsVC ()

@end

@implementation KSBAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_us_bg"]];
    bg.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    [self.view addSubview:bg];
}

@end
