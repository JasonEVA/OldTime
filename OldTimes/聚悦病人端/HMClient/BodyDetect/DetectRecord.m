//
//  DetectRecord.m
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectRecord.h"

@implementation DetectRecord

- (NSString*) dateStr
{
    if (!_testTime)
    {
        return nil;
    }
    
    //NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    NSDate* visitDate = [NSDate dateWithString:_testTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateStr = [visitDate formattedDateWithFormat:@"MM-dd"];
    
    return dateStr;
}

- (NSString*) timeStr
{
    if (!_testTime)
    {
        return nil;
    }
    
    //NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    NSDate* visitDate = [NSDate dateWithString:_testTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timeStr = [visitDate formattedDateWithFormat:@"HH:mm"];
    
    return timeStr;
}

- (BOOL)isAlertGrade
{
    if ([_alertGrade isEqualToString:@"3"]) {
        return YES;
    }
    return NO;
}

@end

@implementation DetectResult

@end
