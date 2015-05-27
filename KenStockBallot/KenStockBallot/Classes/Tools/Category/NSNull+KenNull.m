//
//  NSNull+KenNull.m
//  KenPro
//
//  Created by ken on 14-8-13.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "NSNull+KenNull.h"

@implementation NSNull (KenNull)

- (float)floatValue{
    return 0.00;
}

- (double)doubleValue{
    return 0.00;
}

- (NSString *)stringValue{
    return @"--";
}

- (int)intValue{
    return 0;
}

- (NSString *)charValue{
    return nil;
}

- (BOOL)isEqualToString:(NSString *)string{
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

- (NSArray *)componentsSeparatedByString:(NSString *)string{
    return @[@"",@""];
}

@end
