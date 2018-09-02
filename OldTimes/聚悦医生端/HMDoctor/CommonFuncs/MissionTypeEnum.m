//
//  MissionTypeEnum.m
//  HMDoctor
//
//  Created by jasonwang on 16/5/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionTypeEnum.h"

@implementation MissionTypeEnum

- (NSString *)getTitelWithMissionType:(MissionType)type
{
    NSString *titel = @"";
    titel = self.titels[type];
    return titel;
}

- (NSArray *)titels
{
    if (!_titels) {
        _titels = [NSArray arrayWithObjects:@"今天",@"明天",@"所有任务",@"我拒绝的任务",@"我发出的",@"已完成", nil];
    }
    return _titels;
}

+ (NSString *)getTitelWithMissionTaskRemindType:(MissionTaskRemindType)type {
    NSString *title;
    switch (type) {
        case MissionTaskRemindTypeNone: {
            title = @"不提醒";
            break;
        }
        case MissionTaskRemindTypeToday: {
            title = @"当天";
            break;
        }
        case MissionTaskRemindType5Min: {
            title = @"开始前5分钟";
            break;
        }
        case MissionTaskRemindType15Min: {
            title = @"开始前15分钟";
             break;
        }
        case MissionTaskRemindTypeHalfHour: {
            title = @"开始前半小时";
            break;
        }
        case MissionTaskRemindType1Hour: {
            title = @"开始前1小时";
            break;
        }
        case MissionTaskRemindType2Hours: {
            title = @"开始前2小时";
            break;
        }
        case MissionTaskRemindType1Day: {
            title = @"开始前1天";
             break;
        }
        case MissionTaskRemindType2Days: {
            title = @"开始前2天";
            break;
        }
        case MissionTaskRemindType1Weak: {
            title = @"开始前1星期";
            break;
        }
    }
    return title;
}

@end
