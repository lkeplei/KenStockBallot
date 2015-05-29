//
//  KenConfig.h
//  KenRecorder
//
//  Created by 刘坤 on 15/1/20.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#ifndef KenRecorder_KenConfig_h
#define KenRecorder_KenConfig_h

#define KYDTestCode

#define IsPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)    //是否为pad判断
#define KenLocal(x, ...) NSLocalizedString(x, nil)       //定义国际化使用

//日志输出定义
#ifdef DEBUG
#   define DebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DebugLog(...)
#endif

#define KenHandleBlock(block, ...)        if(block) { block(__VA_ARGS__); }

//颜色取值宏
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//取图片宏
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//取字典宏
#define LOADDIC(file,ext) [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//取版本号
#define kbundleVersion              [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kBuildVersion               [[[NSBundle mainBundle] infoDictionary] objectForKey:kCFBundleVersionKey]

//判断设备是否为iPad
#define kIsPad                      ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
// 判断iphone5
#define kIPhone5                    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iphone4
#define kIPhone4                    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iphone6
#define kIPhone6                    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iphone6 plus
#define kIPhone6PlusZoomIn          ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIPhone6Plus                ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//系统版本判断
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//去除对齐警告
#ifdef __IPHONE_6_0
#   define KTextAlignmentLeft NSTextAlignmentLeft
#   define KTextAlignmentCenter NSTextAlignmentCenter
#   define KTextAlignmentRight NSTextAlignmentRight
#   define KLineBreakModeCharaterWrap NSLineBreakByCharWrapping
#   define KLineBreakModeWordWrap NSLineBreakByWordWrapping
#   define KLineBreakModeClip NSLineBreakByClipping
#   define KLineBreakModeTruncatingHead NSLineBreakByTruncatingHead
#   define KLineBreakModeTruncatingMiddle NSLineBreakByTruncatingMiddle
#   define KLineBreakModeTruncatingTail NSLineBreakByTruncatingTail
#else
#   define KTextAlignmentLeft UITextAlignmentLeft
#   define KTextAlignmentCenter UITextAlignmentCenter
#   define KTextAlignmentRight UITextAlignmentRight
#   define KLineBreakModeCharaterWrap UILineBreakModeCharacterWrap
#   define KLineBreakModeWordWrap UILineBreakModeWordWrap
#   define KLineBreakModeClip UILineBreakModeClip
#   define KLineBreakModeTruncatingHead UILineBreakModeHeadTruncation
#   define KLineBreakModeTruncatingMiddle UILineBreakModeMiddleTruncation
#   define KLineBreakModeTruncatingTail UILineBreakModeTailTruncation
#endif

#define KMainScreenFrame    [[UIScreen mainScreen] bounds]
#define kGSize              KMainScreenFrame.size
#define KMainScreenWidth    KMainScreenFrame.size.width
#define KMainScreenHeight   (KMainScreenFrame.size.height - 20)
#define KApplicationFrame   [[UIScreen mainScreen] applicationFrame]

#define kKenAlert(x)        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",x] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]; [alertView show];

//配置
#define kAppViewOrginY      (64)
#define kAppTabbarHeight    (49)

//字体、字号、颜色
#define kKenFontArial(a)        [UIFont fontWithName:@"Arial" size:a]
#define kKenFontStd(a)          [UIFont fontWithName:@"Std" size:a]
#define kKenFontHelvetica(a)    [UIFont fontWithName:@"Helvetica" size:a]

//user default 数据
#define kUserDefaultUserStock           @"default_user_stock"

#endif
