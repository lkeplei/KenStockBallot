//
//  NSString+KenString.h
//  KenPro
//
//  Created by ken on 14-8-13.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KenString)

+ (NSString *)getStringByInt:(int)number;

//urlEncode
+ (NSString *)encodeToPercentEscapeString:(NSString *)input;
//urldecode
+ (NSString *)decodeFromPercentEscapeString:(NSString *)input;
+ (BOOL)isNumText:(NSString *)str;
- (NSString *)stringFromMD5;

- (NSString*)stringByURLEncodingStringParameter;

@end
