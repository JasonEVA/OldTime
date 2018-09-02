//
//  NSDate+IMManager.h
//  MintcodeIM
//
//  Created by williamzhang on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (IMManager)

/// 获取当前时间的时间戳
+ (long long)wzim_currentTimestamp;

/// 计算时间格式（无必要不拼接小时分钟）
+ (NSString *)wzim_dateFormaterWithTimeInterval:(long long)timeInterval;
/**
 *  计算时间格式
 *
 *  @param timeInterval 正常时间戳*1000
 *
 *  @param appendMinute 是否拼接上小时分钟
 *  @return 2015-01-12 13:57
 */
+ (NSString *)wzim_dateFormaterWithTimeInterval:(long long)timeInterval appendMinute:(BOOL)appendMinute;
/**
 *  计算时间格式
 *
 *  @param timeInterval 正常时间戳*1000
 *  @param showWeek     是否显示显示周几
 *  @param appendMinute 是否拼接上小时分钟
 *
 *  @return 2015-01-12(周一) 13:57
 */
+ (NSString *)wzim_dateFormaterWithTimeInterval:(long long)timeInterval showWeek:(BOOL)showWeek appendMinute:(BOOL)appendMinute;

@end
