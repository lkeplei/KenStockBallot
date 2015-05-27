//
//  UIFont+KenFont.m
//  KenPro
//
//  Created by ken on 14-8-13.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "UIFont+KenFont.h"

@implementation UIFont (KenFont)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
+ (UIFont *)systemFontOfSize:(CGFloat)fontSize{
    return [UIFont fontWithName:@"Heiti SC" size:fontSize];
}
#pragma clang diagnostic pop

@end
