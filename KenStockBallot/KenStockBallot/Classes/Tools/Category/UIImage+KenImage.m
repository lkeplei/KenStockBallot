//
//  UIImage+KenImage.m
//  TBJPro
//
//  Created by ken on 14-8-13.
//  Copyright (c) 2014年 TBJ. All rights reserved.
//

#import "UIImage+KenImage.h"

@implementation UIImage (TBJImage)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
