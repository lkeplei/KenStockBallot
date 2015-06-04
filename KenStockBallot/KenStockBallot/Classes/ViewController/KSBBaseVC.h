//
//  KSBBaseVC.h
//  CCVision
//
//  Created by ken on 15/4/9.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSBBaseVC : UIViewController

- (void)setNavigationTitle:(NSString *)title;
- (BOOL)alterNavBarBackTitle:(NSString *)title;
- (void)setRightNavItemWithTitle:(NSString *)title selector:(SEL)sel;
- (void)setRightNavItemWithImage:(UIImage *)img imgSec:(UIImage *)imgSec selector:(SEL)sel;
- (void)setLeftNavItemWithImage:(UIImage *)img imgSec:(UIImage *)imgSec selector:(SEL)sel;

- (void)pushViewController:(KSBBaseVC *)vc;

@end
