//
//  KSBRootNewVC.m
//  KenStockBallot
//
//  Created by hzyouda on 2016/12/24.
//  Copyright © 2016年 ken. All rights reserved.
//

#import "KSBRootNewVC.h"
#import "KSBRootBtn1VC.h"
#import "KSBRootBtn2VC.h"

@interface KSBRootNewVC ()

@end

@implementation KSBRootNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_root_bg"]];
    bgView.frame = (CGRect){CGPointZero, kGSize};
    [self.view addSubview:bgView];
    
    UIImageView *titleV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_select_title.png"]];
    titleV.center = CGPointMake(self.view.centerX, kGSize.height * 0.22);
    [self.view addSubview:titleV];
    
    UIButton *button1 = [KenUtils buttonWithImg:nil off:0 zoomIn:NO image:[UIImage imageNamed:@"new_root1_normal"]
                                       imagesec:[UIImage imageNamed:@"new_root1_hl"]
                                         target:self action:@selector(button1Clicked:)];
    button1.center = CGPointMake(self.view.width / 2, CGRectGetMaxY(titleV.frame) + button1.height / 2 + 40);
    [self.view addSubview:button1];
    
    UIButton *button2 = [KenUtils buttonWithImg:nil off:0 zoomIn:NO image:[UIImage imageNamed:@"new_root2_normal"]
                                       imagesec:[UIImage imageNamed:@"new_root2_hl"]
                                         target:self action:@selector(button2Clicked:)];
    button2.center = CGPointMake(self.view.width / 2, CGRectGetMaxY(button1.frame) + button2.height / 2 + 40);
    [self.view addSubview:button2];
}

#pragma mark - event
- (void)button1Clicked:(UIButton *)button {
    [self pushViewController:[[KSBRootBtn1VC alloc] init]];
}

- (void)button2Clicked:(UIButton *)button {
    [self pushViewController:[[KSBRootBtn2VC alloc] init]];
}

@end
