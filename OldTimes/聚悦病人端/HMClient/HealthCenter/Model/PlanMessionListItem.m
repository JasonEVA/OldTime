//
//  PlanMessionListItem.m
//  HMClient
//
//  Created by yinqaun on 16/6/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PlanMessionListItem.h"

@implementation PlanMessionListItem

- (NSString*) excTimeString
{
    if (!_excTime || 0 == _excTime.length)
    {
        return nil;
    }
    NSDate* exeDate = [NSDate dateWithString:_excTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timeStr = [exeDate formattedDateWithFormat:@"HH:mm"];
    return timeStr;
}



- (UIColor*) statusColor
{
    UIColor* statusColor = [UIColor colorWithHexString:@"CCCCCC"];
    
    if ([_status isEqualToString:@"1"]) {
        //待记录
        statusColor = [UIColor colorWithHexString:@"FF6666"];
    }
    else if ([_status isEqualToString:@"2"]) {
        //已记录
        statusColor = [UIColor colorWithHexString:@"31C9BA"];

    }
    else if ([_status isEqualToString:@"3"]) {
        //已过期
        statusColor = [UIColor colorWithHexString:@"FFA63C"];
    }
    
    return statusColor;
}

- (CGFloat) cellHeihgt
{
    CGFloat cellHeiht = 35 + 9;
    if (!_taskCon || 0 == _taskCon.length)
    {
        cellHeiht += (11 + 13);
    }
    else
    {
        CGFloat conHeight = [_taskCon heightSystemFont:[UIFont font_26] width:(kScreenWidth - 82 - 28)];
        cellHeiht += (11 + conHeight);
    }
    
    return cellHeiht;
}
@end
