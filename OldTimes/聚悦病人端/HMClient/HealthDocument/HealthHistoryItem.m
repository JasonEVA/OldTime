//
//  HealthHistoryItem.m
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthHistoryItem.h"

@implementation HealthHistoryItem

- (NSString*) yearStr
{
    if (!_visitTime)
    {
        return @"";
    }
    
    //NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    NSDate* visitDate = [NSDate dateWithString:_visitTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSInteger nYear = [visitDate year];
    NSString* yearStr = [NSString stringWithFormat:@"%ld", nYear];
    if (!yearStr)
    {
        return @"";
    }
    return yearStr;
}

- (NSString*) dateStr
{
    if (!_visitTime)
    {
        return nil;
    }
    
    //NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    NSDate* visitDate = [NSDate dateWithString:_visitTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateStr = [visitDate formattedDateWithFormat:@"MM-dd"];
    
    return dateStr;
}


@end
