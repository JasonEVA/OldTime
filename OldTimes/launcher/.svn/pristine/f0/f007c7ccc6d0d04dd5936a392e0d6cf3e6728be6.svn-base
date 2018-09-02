//
//  ATAppSync.m
//  Clock
//
//  Created by SimonMiao on 16/7/20.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATAppSync.h"

static NSString *const PunchCard_SYNC = @"PunchCard_SYNC";
static NSString *const PunchCard_count =  @"PunchCardCount";
static NSString *const ClockRule_dict =  @"ClockRule_dict";

@implementation ATAppSync

+ (long long)getNowTimestamp {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    long long timestamp = now*1000;
    
    return timestamp;
}

+ (void)setPunchCardSync:(long long)sync
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",PunchCard_SYNC,@"125"];
    NSNumber *synobj = [NSNumber numberWithLongLong:sync];
    
    [[NSUserDefaults standardUserDefaults] setObject:synobj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (long long)getPunchCardSync
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",PunchCard_SYNC,@"125"];
    NSNumber *synobj = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return [synobj longLongValue];
}

+ (void)setPunchCardCount:(NSUInteger)count
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",PunchCard_count,@"125"];
    NSNumber *obj = [NSNumber numberWithLongLong:count];
    
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSUInteger)getPunchCardCount
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",PunchCard_count,@"125"];
    NSNumber *obj = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    return obj.unsignedIntegerValue;
}

+ (void)setClockRuleDict:(NSDictionary *)dict
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",ClockRule_dict,@"125"];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)getClockRuleDict
{
    NSString *key = [NSString stringWithFormat:@"%@_%@",ClockRule_dict,@"125"];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    return dict;
}


@end
