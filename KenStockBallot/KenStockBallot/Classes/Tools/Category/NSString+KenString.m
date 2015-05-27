//
//  NSString+KenString.m
//  KenPro
//
//  Created by ken on 14-8-13.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "NSString+KenString.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (KenString)

+ (NSString *)getStringByInt:(int)number {
    return [self stringWithFormat:@"%d", number];
}

+ (NSString *)encodeToPercentEscapeString:(NSString *)input {
    // Encode all the reserved characters, per RFC 3986
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

+ (NSString *)decodeFromPercentEscapeString:(NSString *)input {
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (BOOL)isNumText:(NSString *)str {
    NSString * regex        = @"^(0|[1-9]\\d*)$|^(0|[1-9]\\d*)\\.(\\d+)$";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)stringByURLEncodingStringParameter {
    NSString *resultStr = self;
    
    CFStringRef originalString = (__bridge CFStringRef) self;
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
    
    CFStringRef escapedStr;
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         originalString,
                                                         leaveUnescaped,
                                                         forceEscaped,
                                                         kCFStringEncodingUTF8);
    
    if( escapedStr ) {
        NSMutableString *mutableStr = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
        CFRelease(escapedStr);
        
        // replace spaces with plusses
        [mutableStr replaceOccurrencesOfString:@" "
                                    withString:@"%20"
                                       options:0
                                         range:NSMakeRange(0, [mutableStr length])];
        resultStr = mutableStr;
    }
    
    return resultStr;
}

- (NSString *)stringFromMD5 {
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

#pragma mark - safe code
- (NSString *)KensubstringFromIndex:(NSUInteger)from {
    if ([self length] < from) {
        [self logWarning:[@"substringFromIndex: ==>" stringByAppendingFormat:@"from[%ld] > length[%ld]",(long)from ,(long)[self length]]];
        return nil;
    }
    
    return [self KensubstringFromIndex:from];
}

- (NSString *)KensubstringToIndex:(NSUInteger)to {
    if ([self length] < to) {
        [self logWarning:[@"substringToIndex: ==>" stringByAppendingFormat:@"to[%ld] > length[%ld]",(long)to ,(long)[self length]]];
        return nil;
    }
    
    return [self KensubstringToIndex:to];
}

- (NSString *)KensubstringWithRange:(NSRange)range {
    if ([self length] < range.location) {
        [self logWarning:[@"substringWithRange: ==>" stringByAppendingFormat:@"location[%ld] > length[%ld]",(long)range.location ,(long)[self length]]];
        return nil;
    }
    
    if ([self length] < range.location + range.length) {
        [self logWarning:[@"substringWithRange: ==>" stringByAppendingFormat:@"length[%ld] > length[%ld]",(long)range.location + range.length, (long)[self length]]];
        return nil;
    }
    
    return [self KensubstringWithRange:range];
}

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [self swizzleMethod:@selector(KensubstringFromIndex:) tarClass:@"__NSCFString" tarSel:@selector(substringFromIndex:)];
            [self swizzleMethod:@selector(KensubstringToIndex:) tarClass:@"__NSCFString" tarSel:@selector(substringToIndex:)];
            [self swizzleMethod:@selector(KensubstringWithRange:) tarClass:@"__NSCFString" tarSel:@selector(substringWithRange:)];
        }
    });
}
@end
