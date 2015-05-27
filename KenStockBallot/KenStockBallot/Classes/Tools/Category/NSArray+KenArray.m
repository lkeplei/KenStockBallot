//
//  NSArray+KenArray.m
//  KenPro
//
//  Created by ken on 14-8-13.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "NSArray+KenArray.h"

@implementation NSArray (KenArray)

#pragma mark - safe
- (id)KenobjectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        [self logWarning:[@"objectAtIndex: array bounds ==>" stringByAppendingFormat:@"index[%ld] >= count[%ld]",(long)index ,(long)[self count]]];
        return nil;
    }
    return [self KenobjectAtIndex:index];
}

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [self swizzleMethod:@selector(KenobjectAtIndex:) tarClass:@"__NSArrayI" tarSel:@selector(objectAtIndex:)];
        }
    });
}

@end
