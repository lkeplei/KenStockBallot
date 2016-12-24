//
//  AppDelegate.h
//  KenStockBallot
//
//  Created by ken on 15/5/27.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSBRootVC;
@class KSBRootNewVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) KSBRootVC *rootOldVC;
@property (strong, nonatomic) KSBRootNewVC *rootNewVC;

@end

