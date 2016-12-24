//
//  UIColor+KenColor.h
//  KenPro
//
//  Created by ken on 14-8-13.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KenColor)

//比如：#FF3388、0X22FF11 等颜色字符串转换到RGB
+ (UIColor *)kenColorWithHexString:(NSString *)stringToConvert;

+ (UIColor *)bgGreenColor;
+ (UIColor *)bgLightGrayColor;
+ (UIColor *)descGrayColor;
+ (UIColor *)separatorMainColor;
+ (UIColor *)separatorColor;
+ (UIColor *)lineColor;

+ (UIColor *)grayBgColor;
+ (UIColor *)greenTextColor;
+ (UIColor *)blackTextColor;
+ (UIColor *)grayTextColor;

@end
