//
//  IMApplicationManager.m
//  launcher
//
//  Created by williamzhang on 16/3/4.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "IMApplicationManager.h"

@interface IMApplicationManager ()

/// (key,value) = (@"PWP16jXXLjFEZXLe@APP",@(10001))
@property (nonatomic, strong) NSMutableDictionary *appDictionary;
/// (key,value) = (@(10001),@"PWP16jXXLjFEZXLe@APP")
@property (nonatomic, strong) NSMutableDictionary *reverseDictionary;

@end

@implementation IMApplicationManager

+ (IMApplicationManager *)share {
    static IMApplicationManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}

+ (void)setApplicationConfig:(NSDictionary *)dictionary {
    if (!dictionary || [dictionary count] == 0) {
        return;
    }
    
    [self share].appDictionary = nil;
    [[self share].appDictionary addEntriesFromDictionary:dictionary];
    
    [self share].reverseDictionary = nil;
    for (NSString *key in [[self share].appDictionary allKeys]) {
        id value = [[self share].appDictionary objectForKey:key];
        [[self share].reverseDictionary setObject:key forKey:value];
    }
}

+ (NSInteger)applicationTypeFromUid:(NSString *)uid {
    NSNumber *number = [[self share].appDictionary objectForKey:uid];
    return number ? [number integerValue] : -1;
}
//
+ (NSString *)applicaionUidFromType:(NSInteger)type {
    return [[self share].reverseDictionary objectForKey:@(type)];
}
//获取所有
+ (NSArray *)applicaitonUids {
    return [[self share].appDictionary allKeys];
}

#pragma mark - Initalizer
- (NSMutableDictionary *)appDictionary {
    if (!_appDictionary) {
        _appDictionary = [NSMutableDictionary dictionary];
    }
    return _appDictionary;
}

- (NSMutableDictionary *)reverseDictionary {
    if (!_reverseDictionary) {
        _reverseDictionary = [NSMutableDictionary dictionary];
    }
    return _reverseDictionary;
}

@end
