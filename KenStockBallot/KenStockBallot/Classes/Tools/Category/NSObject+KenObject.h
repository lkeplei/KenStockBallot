//
//  NSObject+KenObject.h
//  KenPro
//
//  Created by ken on 14-8-14.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KenObject)

/*
 * To swizzle two selector for self class.
 * @param srcSel source selector
 * @param tarSel target selector
 */
+ (void)swizzleMethod:(SEL)srcSel tarSel:(SEL)tarSel;

/*
 * To swizzle two selector from self class to target class.
 * @param srcSel source selector
 * @param tarClassName target class name string
 * @param tarSel target selector
 */
+ (void)swizzleMethod:(SEL)srcSel tarClass:(NSString *)tarClassName tarSel:(SEL)tarSel;

/*
 * To swizzle two selector from self class to target class.
 * @param srcClass source class
 * @param srcSel source selector
 * @param tarClass target class
 * @param tarSel target selector
 */
+ (void)swizzleMethod:(Class)srcClass srcSel:(SEL)srcSel tarClass:(Class)tarClass tarSel:(SEL)tarSel;

- (void)logWarning:(NSString *)aString;

@end
