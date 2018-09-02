//
//  ATAppSync.h
//  Clock
//
//  Created by SimonMiao on 16/7/20.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+ATCompare.h"

@interface ATAppSync : NSObject

+ (long long)getNowTimestamp;

+ (void)setPunchCardSync:(long long)sync;
+ (long long)getPunchCardSync;

+ (void)setPunchCardCount:(NSUInteger)count;
+ (NSUInteger)getPunchCardCount;

/** 存储考勤规则 */
+ (void)setClockRuleDict:(NSDictionary *)dict;
/** 从UserDefault获取考勤规则 */
+ (NSDictionary *)getClockRuleDict;

@end
