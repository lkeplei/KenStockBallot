//
//  NSObject+KenObject.m
//  KenPro
//
//  Created by ken on 14-8-14.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "NSObject+KenObject.h"
#import <objc/runtime.h>

@implementation NSObject (KenObject)

#pragma mark - safe
+ (void)swizzleMethod:(SEL)srcSel tarSel:(SEL)tarSel {
    Class clazz = [self class];
    [self swizzleMethod:clazz srcSel:srcSel tarClass:clazz tarSel:tarSel];
}

+ (void)swizzleMethod:(SEL)srcSel tarClass:(NSString *)tarClassName tarSel:(SEL)tarSel {
    if (!tarClassName) {
        return;
    }
    Class srcClass = [self class];
    Class tarClass = NSClassFromString(tarClassName);
    [self swizzleMethod:srcClass srcSel:srcSel tarClass:tarClass tarSel:tarSel];
}

+ (void)swizzleMethod:(Class)srcClass srcSel:(SEL)srcSel tarClass:(Class)tarClass tarSel:(SEL)tarSel {
    if (!srcClass) {
        return;
    }
    if (!srcSel) {
        return;
    }
    if (!tarClass) {
        return;
    }
    if (!tarSel) {
        return;
    }
    
    @try {
        Method srcMethod = class_getInstanceMethod(srcClass,srcSel);
        Method tarMethod = class_getInstanceMethod(tarClass,tarSel);
        method_exchangeImplementations(srcMethod, tarMethod);
    } @catch (NSException *exception) {
        NSString *exceptionStr = [self formatExceptionToString:exception withReason:nil];
        DebugLog("%@", exceptionStr);
    } @finally {
        
    }
}

- (NSString *)formatExceptionToString:(NSException *)exception withReason:(NSString *)reasonStr{
    NSArray *arr = [exception callStackSymbols];
    NSString *reasonText = nil;
    if (reasonStr) {
        reasonText = reasonStr;
    }else{
        reasonText = [exception reason];
    }

    NSString *exceptionDes = [NSString stringWithFormat:@"\n\n%@\nname: %@\ntime: %@\nreason: %@\ncallStackSymbols: \n%@\n%@\n\n",
                              @"=============KenObject Exception Report=============",
                              [exception name],
                              [NSDate date],
                              reasonText,
                              [arr componentsJoinedByString:@"\n"],
                              @"=============KenObject Exception Report end========="];
    
    return exceptionDes;
}

- (void)logWarning:(NSString *)aString {
    @try {
        NSException *e = [NSException exceptionWithName:@"KenExceptionLog" reason:aString userInfo:nil];

        DebugLog("%@", [self formatExceptionToString:e withReason:nil]);
#ifndef KKenProReleaseServer
        @throw e;
#endif
    } @catch (NSException *exception) {
        NSString *exceptionStr = [self formatExceptionToString:exception withReason:nil];
        DebugLog("%@", exceptionStr);
    }
}
@end
