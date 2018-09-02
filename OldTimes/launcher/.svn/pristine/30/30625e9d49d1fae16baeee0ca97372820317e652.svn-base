//
//  NSDictionary+IMSafeManager.m
//  MintcodeIM
//
//  Created by williamzhang on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NSDictionary+IMSafeManager.h"

@implementation NSDictionary (Private)

- (id)im_safeValueForKey:(NSString *)key {
    return [self im_safeValueForKey:key originalClass:nil];
}

- (id)im_safeValueForKey:(NSString *)key originalClass:(Class)aClass {
    return [self im_safeValueForKeyPath:key originalClass:aClass];
}

- (id)im_safeValueForKeyPath:(NSString *)keyPath {
    return [self im_safeValueForKeyPath:keyPath originalClass:nil];
}

- (id)im_safeValueForKeyPath:(NSString *)keyPath originalClass:(Class)aClass {
    id value = [self valueForKeyPath:keyPath];
    if ([value isKindOfClass:[NSNull class]]) {
        value = nil;
    }
    
    if (value) {
        return value;
    }
    
    if (aClass == [NSString class]) {
        return @"";
    }
    
    if (aClass == [NSNumber class]) {
        return @0;
    }
    
    NSArray *array = @[@"NSArray",
                       @"NSMutaleArray",
                       @"NSDictionary",
                       @"NSMutableDictionary",
                       @"NSDate"];
    
    for (NSString *className in array) {
        Class bClass = NSClassFromString(className);
        if (aClass != bClass) {
            continue;
        }
        
        value = [[bClass alloc] init];
        break;
    }
    
    return value;
}

@end

@implementation NSDictionary (IMSafeManager)

- (NSString *)im_valueStringForKey:(NSString *)key {return [self im_valueStringForKeyPath:key];}
- (NSString *)im_valueStringForKeyPath:(NSString *)keyPath {
    return [self im_safeValueForKeyPath:keyPath originalClass:[NSString class]];
}

- (NSNumber *)im_valueNumberForKey:(NSString *)key {return [self im_valueNumberForKeyPath:key];}
- (NSNumber *)im_valueNumberForKeyPath:(NSString *)keyPath {
    return [self im_safeValueForKeyPath:keyPath originalClass:[NSNumber class]];
}

- (BOOL)im_valueBoolForKey:(NSString *)key { return [self im_valueBoolForKeyPath:key];}
- (BOOL)im_valueBoolForKeyPath:(NSString *)keyPath {
    return [[self im_valueNumberForKeyPath:keyPath] boolValue];
};

- (NSArray *)im_valueArrayForKey:(NSString *)key {return [self im_valueArrayForKeyPath:key];}
- (NSArray *)im_valueArrayForKeyPath:(NSString *)keyPath {
    return [self im_safeValueForKeyPath:keyPath originalClass:[NSArray class]];
}

- (NSMutableArray *)im_valueMutableArrayForKey:(NSString *)key {return  [self im_valueMutableArrayForKeyPath:key];}
- (NSMutableArray *)im_valueMutableArrayForKeyPath:(NSString *)keyPath {
    return [self im_safeValueForKeyPath:keyPath originalClass:[NSMutableArray class]];
}

- (NSDictionary *)im_valueDictonaryForKey:(NSString *)key {return [self im_valueDictonaryForKeyPath:key];}
- (NSDictionary *)im_valueDictonaryForKeyPath:(NSString *)keyPath {
    return [self im_safeValueForKeyPath:keyPath originalClass:[NSDictionary class]];
}

- (NSMutableDictionary *)im_valueMutableDictionayForKey:(NSString *)key {return [self im_valueMutableDictionayForKeyPath:key];}
- (NSMutableDictionary *)im_valueMutableDictionayForKeyPath:(NSString *)keyPath {
    return [self im_safeValueForKeyPath:keyPath originalClass:[NSMutableDictionary class]];
}

- (NSDate *)im_valueDateForKey:(NSString *)key {return [self im_valueDateForKeyPath:key];}
- (NSDate *)im_valueDateForKeyPath:(NSString *)keyPath {
    NSNumber *timeIntervalNumber = [self im_valueNumberForKeyPath:keyPath];
    long long timeInterval = [timeIntervalNumber longLongValue] / 1000;
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

@end
