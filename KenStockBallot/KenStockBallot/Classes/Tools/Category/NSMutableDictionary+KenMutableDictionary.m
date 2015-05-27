//
//  NSMutableDictionary+KenMutableDictionary.m
//  KenPro
//
//  Created by ken on 14-8-14.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "NSMutableDictionary+KenMutableDictionary.h"

@implementation NSMutableDictionary (KenMutableDictionary)

#pragma mark - safe
- (void)KenremoveObjectForKey:(id)aKey {
    if (!aKey) {
        [self logWarning:@"removeObjectForKey: ==> key is nil"];
        return;
    }
    [self KenremoveObjectForKey:aKey];
}

- (void)KensetObject:(id)anObject forKey:(id <NSCopying>)aKey {
    if (!anObject) {
        [self logWarning:@"setObject:forKey: ==> object is nil"];
        return;
    }
    
    if (!aKey) {
        [self logWarning:@"setObject:forKey: ==> key is nil"];
        return;
    }
    [self KensetObject:anObject forKey:aKey];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [self swizzleMethod:@selector(KenremoveObjectForKey:) tarClass:@"__NSDictionaryM" tarSel:@selector(removeObjectForKey:)];
            [self swizzleMethod:@selector(KensetObject:forKey:) tarClass:@"__NSDictionaryM" tarSel:@selector(setObject:forKey:)];
        }
    });
}

@end
