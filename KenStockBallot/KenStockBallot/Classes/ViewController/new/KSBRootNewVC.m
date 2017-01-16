//
//  KSBRootNewVC.m
//  KenStockBallot
//
//  Created by hzyouda on 2016/12/24.
//  Copyright © 2016年 ken. All rights reserved.
//

#import "KSBRootNewVC.h"
#import "KSBRootBtn1VC.h"
#import "KSBHistoryVC.h"
#import "KSBAboutUsVC.h"

#import "BaiduMobAdSDK/BaiduMobAdSetting.h"
#import "BaiduMobAdSDK/BaiduMobAdView.h"
#import "BaiduMobAdSDK/BaiduMobAdDelegateProtocol.h"

@interface KSBRootNewVC ()<BaiduMobAdViewDelegate>

@property (nonatomic, strong) BaiduMobAdView *sharedAdView;

@end

@implementation KSBRootNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightNavItemWithImage:[UIImage imageNamed:@"about_us_normal"]
                            imgSec:[UIImage imageNamed:@"about_us_hl"] selector:@selector(aboutUs)];
    
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
    
    
    [self.view addSubview:self.sharedAdView];
}

#pragma mark - event
- (void)button1Clicked:(UIButton *)button {
    [self pushViewController:[[KSBRootBtn1VC alloc] init]];
}

- (void)button2Clicked:(UIButton *)button {
    [self pushViewController:[[KSBHistoryVC alloc] init]];
}

- (void)aboutUs {
    [self pushViewController:[[KSBAboutUsVC alloc] init]];
}

#pragma mark - baidu delegate
- (NSString *)publisherId {
    return kBaiduPublisherId; //@"your_own_app_id";注意，iOS和android的app请使用不同的app ID
}

- (BOOL)enableLocation {
    //启用location会有一次alert提示
    return YES;
}

- (void)willDisplayAd:(BaiduMobAdView*)adview {
    NSLog(@"delegate: will display ad");
}

- (void)failedDisplayAd:(BaiduMobFailReason)reason {
    NSLog(@"delegate: failedDisplayAd %d", reason);
}

- (void)didAdImpressed {
    NSLog(@"delegate: didAdImpressed");
    
}

- (void)didAdClicked {
    NSLog(@"delegate: didAdClicked");
}

- (void)didAdClose {
    NSLog(@"delegate: didAdClose");
}

#pragma mark - getter setter
#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height
- (BaiduMobAdView *)sharedAdView {
    if (_sharedAdView == nil) {
        //lp颜色配置
        [BaiduMobAdSetting setLpStyle:BaiduMobAdLpStyleDefault];
#warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.    [BaiduMobAdSetting sharedInstance].supportHttps = NO;
        
        //使用嵌入广告的方法实例。
        _sharedAdView = [[BaiduMobAdView alloc] init];
        _sharedAdView.AdUnitTag = @"3191691";
        _sharedAdView.AdType = BaiduMobAdViewTypeBanner;
        CGFloat bannerY = kScreenHeight - 0.15 * kScreenWidth;
        _sharedAdView.frame = CGRectMake(0, bannerY, kScreenWidth, 0.15*kScreenWidth);
        
        _sharedAdView.delegate = self;
        [_sharedAdView start];
    }
    return _sharedAdView;
}

@end
