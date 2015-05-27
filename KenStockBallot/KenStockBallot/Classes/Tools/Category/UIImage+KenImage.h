//
//  UIImage+KenImage.h
//  TBJPro
//
//  Created by ken on 14-8-13.
//  Copyright (c) 2014年 TBJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KenImage)

/*!
 *  图片由颜色填充
 *
 *  @param color 颜色
 *
 *  @return uiimage
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
