//
//  NSMutableArray+KenMutableArray.m
//  KenPro
//
//  Created by ken on 14-8-14.
//  Copyright (c) 2014年 Ken. All rights reserved.
//

#import "NSMutableArray+KenMutableArray.h"
#import <objc/runtime.h>

@implementation NSMutableArray (KenMutableArray)

+ (NSMutableArray *)getPropertyList:(Class)className {
    NSMutableArray *mutableArr = [NSMutableArray array];
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList(className, &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        [mutableArr addObject:[NSString stringWithUTF8String:property_getName(property)]];
    }
    
    free(properties);
    return mutableArr;
}

#pragma mark - safe
- (id)KenobjectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        [self logWarning:[@"objectAtIndex: array bounds ==>" stringByAppendingFormat:@"index[%ld] >= count[%ld]",(long)index ,(long)[self count]]];
        return nil;
    }
    return [self KenobjectAtIndex:index];
}

- (void)KenaddObject:(id)anObject {
    if (!anObject) {
        [self logWarning:@"addObject: ==> object is nil"];
        return;
    }
    [self KenaddObject:anObject];
}

- (void)KeninsertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > [self count]) {
        [self logWarning:[@"insertObject:atIndex: array bounds ==>" stringByAppendingFormat:@"index[%ld] >= count[%ld]",(long)index ,(long)[self count]]];
        return;
    }
    
    if (!anObject) {
        [self logWarning:@"insertObject:atIndex: ==> object is nil"];
        return;
    }
    
    [self KeninsertObject:anObject atIndex:index];
}

- (void)KenremoveObjectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        [self logWarning:[@"removeObjectAtIndex: array bounds ==>" stringByAppendingFormat:@"index[%ld] >= count[%ld]",(long)index ,(long)[self count]]];
        return;
    }
    
    return [self KenremoveObjectAtIndex:index];
}

- (void)KenreplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= [self count]) {
        [self logWarning:[@"replaceObjectAtIndex:withObject: array bounds ==>" stringByAppendingFormat:@"index[%ld] >= count[%ld]",(long)index ,(long)[self count]]];
        return;
    }
    
    if (!anObject) {
        [self logWarning:@"replaceObjectAtIndex:withObject: ==> object is nil"];
        return;
    }
    
    [self KenreplaceObjectAtIndex:index withObject:anObject];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        @autoreleasepool {
//            [self swizzleMethod:@selector(KenobjectAtIndex:) tarClass:@"__NSArrayM" tarSel:@selector(objectAtIndex:)];
            [self swizzleMethod:@selector(KenaddObject:) tarClass:@"__NSArrayM" tarSel:@selector(addObject:)];
            [self swizzleMethod:@selector(KeninsertObject:atIndex:) tarClass:@"__NSArrayM" tarSel:@selector(insertObject:atIndex:)];
            [self swizzleMethod:@selector(KenremoveObjectAtIndex:) tarClass:@"__NSArrayM" tarSel:@selector(removeObjectAtIndex:)];
            [self swizzleMethod:@selector(KenreplaceObjectAtIndex:withObject:) tarClass:@"__NSArrayM" tarSel:@selector(replaceObjectAtIndex:withObject:)];
        }
    });
}

@end
