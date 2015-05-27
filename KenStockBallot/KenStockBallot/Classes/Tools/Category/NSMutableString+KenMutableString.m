//
//  NSMutableString+KenMutableString.m
//  KenPro
//
//  Created by ken on 14-8-14.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "NSMutableString+KenMutableString.h"

@implementation NSMutableString (KenMutableString)

#pragma mark - safe
- (void)KenappendString:(NSString *)aString{
    if (!aString) {
        [self logWarning:@"appendString: ==> aString is nil"];
        return;
    }
    [self KenappendString:aString];
}

- (void)KenappendFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2){
    if (!format) {
        [self logWarning:@"appendFormat: ==> aString is nil"];
        return;
    }
    va_list arguments;
    va_start(arguments, format);
    NSString *formatStr = [[NSString alloc]initWithFormat:format arguments:arguments];
    [self KenappendFormat:@"%@",formatStr];
    va_end(arguments);
}

- (void)KensetString:(NSString *)aString{
    if (!aString) {
        [self logWarning:@"setString: ==> aString is nil"];
        return;
    }
    [self KensetString:aString];
}

- (void)KeninsertString:(NSString *)aString atIndex:(NSUInteger)index{
    if (index > [self length]) {
        [self logWarning:[@"insertString:atIndex: ==>" stringByAppendingFormat:@"index[%ld] >= length[%ld]",(long)index ,(long)[self length]]];
        return;
    }
    if (!aString) {
        [self logWarning:@"insertString:atIndex: ==> aString is nil"];
        return;
    }
    
    [self KeninsertString:aString atIndex:index];
}

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [self swizzleMethod:@selector(KenappendString:) tarClass:@"__NSCFConstantString" tarSel:@selector(appendString:)];
            [self swizzleMethod:@selector(KenappendFormat:) tarClass:@"__NSCFConstantString" tarSel:@selector(appendFormat:)];
            [self swizzleMethod:@selector(KensetString:) tarClass:@"__NSCFConstantString" tarSel:@selector(setString:)];
            [self swizzleMethod:@selector(KeninsertString:atIndex:) tarClass:@"__NSCFConstantString" tarSel:@selector(insertString:atIndex:)];
        }
    });
}

@end
