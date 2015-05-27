//
//  UIColor+KenColor.m
//  KenPro
//
//  Created by ken on 14-8-13.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "UIColor+KenColor.h"

@implementation UIColor (KenColor)

//比如：#FF3388、0X22FF11 等颜色字符串转换到RGB
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    if (![KenUtils isEmpty:stringToConvert]) {
        NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
        
        // String should be 6 or 8 characters
        if ([cString length] < 6) return [UIColor grayColor];
        
        // strip 0X if it appears
        if ([cString hasPrefix:@"0X"]) {
            cString = [cString substringFromIndex:2];
        }
        
        if ([cString hasPrefix:@"#"]) {
            cString = [cString substringFromIndex:1];
        }
        
        if ([cString length] != 6) {
            return [UIColor grayColor];
        }
        
        // Separate into r, g, b substrings
        NSRange range;
        range.location = 0;
        range.length = 2;
        NSString *rString = [cString substringWithRange:range];
        
        range.location = 2;
        NSString *gString = [cString substringWithRange:range];
        
        range.location = 4;
        NSString *bString = [cString substringWithRange:range];
        
        // Scan values
        unsigned int r, g, b;
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:1.0f];
    } else {
        return nil;
    }
}

+ (UIColor *)bgGreenColor {
    return [self colorWithHexString:@"#19A58E"];            //R25 G165 B142
}

+ (UIColor *)bgLightGrayColor {
    return [self colorWithHexString:@"#E8E8E8"];            
}

+ (UIColor *)descGrayColor {
    return [self colorWithHexString:@"#828282"];
}

+ (UIColor *)separatorMainColor {
    return [self colorWithHexString:@"#c8c7cc"];
}

+ (UIColor *)separatorColor {
    return [self colorWithHexString:@"#eeeeee"];
}

+ (UIColor *)lineColor {
    return [self colorWithHexString:@"#C0C0C0"];
}
@end
