//
//  NSDictionary+IMSafeManager.h
//  MintcodeIM
//
//  Created by williamzhang on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (IMSafeManager)

- (NSString *)im_valueStringForKey:(NSString *)key;

- (NSNumber *)im_valueNumberForKey:(NSString *)key;
- (BOOL)im_valueBoolForKey:(NSString *)key;

- (NSArray *)im_valueArrayForKey:(NSString *)key;
- (NSMutableArray *)im_valueMutableArrayForKey:(NSString *)key;

- (NSDictionary *)im_valueDictonaryForKey:(NSString *)key;
- (NSMutableDictionary *)im_valueMutableDictionayForKey:(NSString *)key;

/** 服务器定义时间戳 / 1000 转换为时间 */
- (NSDate *)im_valueDateForKey:(NSString *)key;

- (NSString *)im_valueStringForKeyPath:(NSString *)keyPath;

- (NSNumber *)im_valueNumberForKeyPath:(NSString *)keyPath;
- (BOOL)im_valueBoolForKeyPath:(NSString *)keyPath;

- (NSArray *)im_valueArrayForKeyPath:(NSString *)keyPath;
- (NSMutableArray *)im_valueMutableArrayForKeyPath:(NSString *)keyPath;

- (NSDictionary *)im_valueDictonaryForKeyPath:(NSString *)keyPath;
- (NSMutableDictionary *)im_valueMutableDictionayForKeyPath:(NSString *)keyPath;

/** 服务器定义时间戳 / 1000 转换为时间 */
- (NSDate *)im_valueDateForKeyPath:(NSString *)keyPath;

@end
