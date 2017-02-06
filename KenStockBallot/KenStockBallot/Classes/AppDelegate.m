//
//  AppDelegate.m
//  KenStockBallot
//
//  Created by ken on 15/5/27.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "AppDelegate.h"
#import "KSBRootVC.h"
#import "KSBRootNewVC.h"

#import "MobClick.h"

#import <BmobSDK/Bmob.h>

#import "BaiduMobAdSDK/BaiduMobAdSplash.h"
#import "BaiduMobAdSDK/BaiduMobAdSetting.h"

@interface AppDelegate ()<BaiduMobAdSplashDelegate>

@property (nonatomic, strong) BaiduMobAdSplash *splash;
@property (nonatomic, retain) UIView *customSplashView;

@end

@implementation AppDelegate

-(void)umengTrack{
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    //    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    
    if (IsPad) {
        [MobClick startWithAppkey:@"5566736167e58e53f9002abf"];
    } else {
        [MobClick startWithAppkey:@"5566732267e58e6e4c005e41"];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //1.创建Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    _rootOldVC = [[KSBRootVC alloc] init];
//    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:_rootOldVC];
    
    _rootNewVC = [[KSBRootNewVC alloc] init];
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:_rootNewVC];
    
    //设置控制器为Window的根控制器
    self.window.rootViewController = rootNav;
    
    //2.设置Window为主窗口并显示出来
    [self.window makeKeyAndVisible];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    //设置导航栏背景色
    if (IsPad) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor greenTextColor]];   
    } else {
        [[UINavigationBar appearance] setBarTintColor:[UIColor greenTextColor]];
//        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:kIPhone6 ? @"app_nav_bg_iphone6" : @"app_nav_bg"]
//                                           forBarMetrics:UIBarMetricsDefault];
    }
    //设置导航栏文字颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //bmob
    [Bmob registerWithAppKey:@"bd7722d61ece9296b9e66223f7d441b5"];
    
    //  友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];
    
    //添加百度的开屏广告
    [self addBaiduMobAdSplash];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - baidu ad splash
- (void)addBaiduMobAdSplash {
#warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.    [BaiduMobAdSetting sharedInstance].supportHttps = NO;
    [BaiduMobAdSetting sharedInstance].supportHttps = YES;
    //    自定义开屏
    BaiduMobAdSplash *splash = [[BaiduMobAdSplash alloc] init];
    splash.delegate = self;
    splash.AdUnitTag = @"3342092";
    splash.canSplashClick = YES;
    self.splash = splash;
    
    //可以在customSplashView上显示包含icon的自定义开屏
    self.customSplashView = [[UIView alloc]initWithFrame:self.window.frame];
    self.customSplashView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:self.customSplashView];
    
    CGFloat screenWidth = self.window.frame.size.width;
    CGFloat screenHeight = self.window.frame.size.height;
    
    //在baiduSplashContainer用做上展现百度广告的容器，注意尺寸必须大于200*200，并且baiduSplashContainer需要全部在window内，同时开机画面不建议旋转
    UIView * baiduSplashContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.customSplashView addSubview:baiduSplashContainer];
    
    //在的baiduSplashContainer里展现百度广告
    [splash loadAndDisplayUsingContainerView:baiduSplashContainer];
}

- (NSString *)publisherId {
    return kBaiduPublisherId;
}

- (void)splashDidClicked:(BaiduMobAdSplash *)splash {
    NSLog(@"splashDidClicked");
}

- (void)splashDidDismissLp:(BaiduMobAdSplash *)splash {
    NSLog(@"splashDidDismissLp");
}

- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash {
    NSLog(@"splashDidDismissScreen");
    [self removeSplash];
}

- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash {
    NSLog(@"splashSuccessPresentScreen");
}

- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason)reason {
    NSLog(@"splashlFailPresentScreen withError %d", reason);
    [self removeSplash];
}

/**
 *  展示结束or展示失败后, 手动移除splash和delegate
 */
- (void) removeSplash {
    if (self.splash) {
        self.splash.delegate = nil;
        self.splash = nil;
        [self.customSplashView removeFromSuperview];
    }
}

@end
