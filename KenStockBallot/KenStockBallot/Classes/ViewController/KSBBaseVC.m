//
//  KSBBaseVC.m
//  CCVision
//
//  Created by ken on 15/4/9.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBBaseVC.h"

@interface KSBBaseVC ()

@end

@implementation KSBBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor separatorColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationTitle:(NSString *)title {
    UILabel *navTitle = (UILabel *) self.navigationItem.titleView;

    if (navTitle) {
        navTitle.text = title;
    } else {
        navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.width / 2, 44)];
        navTitle.font = kKenFontArial(18);
        navTitle.textColor = [UIColor blackColor];
        navTitle.textAlignment = KTextAlignmentCenter;
        navTitle.text = title;
        self.navigationItem.titleView = navTitle;
    }
}

- (BOOL)alterNavBarBackTitle:(NSString *) title {
    if(self.navigationItem.leftBarButtonItem.customView) {
        UIButton *btnBack = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
        if (btnBack) {
            [btnBack setTitle:title forState:UIControlStateNormal];
            return YES;
        }
    }
    return NO;
}

- (void)setRightNavItemWithTitle:(NSString *)title selector:(SEL)sel{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor colorWithRed:(CGFloat)99/255 green:(CGFloat)152/255 blue:(CGFloat)200/255 alpha:1] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:(CGFloat)59/255 green:(CGFloat)93/255 blue:(CGFloat)119/255 alpha:1] forState:UIControlStateHighlighted];
    btn.bounds = CGRectMake(0, 0, (kIPhone4 ? 90 : 64), 44);
    
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, -18)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setRightNavItemWithImage:(UIImage *)img imgSec:(UIImage *)imgSec selector:(SEL)sel {
    UIButton *btn = [KenUtils buttonWithImg:nil off:0 zoomIn:NO image:img imagesec:imgSec target:self action:sel];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setLeftNavItemWithImage:(UIImage *)img imgSec:(UIImage *)imgSec selector:(SEL)sel {
    UIButton *btn = [KenUtils buttonWithImg:nil off:0 zoomIn:NO image:img imagesec:imgSec target:self action:sel];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}
@end
