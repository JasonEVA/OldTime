//
//  PointRedemptionMonthlyRecordTask.m
//  HMClient
//
//  Created by yinquan on 2017/7/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PointRedemptionMonthlyRecordTask.h"
#import "PointRedemptionMonthRecordModel.h"

@implementation PointRedemptionMonthlyRecordTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postAttendanceServiceUrl:@"getAttendanceRecord"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* respList = (NSArray*) stepResult;
        NSMutableArray* models = [NSMutableArray array];
        [respList enumerateObjectsUsingBlock:^(NSDictionary* respDict, NSUInteger idx, BOOL * _Nonnull stop) {
            PointRedemptionMonthRecordModel* model = [PointRedemptionMonthRecordModel mj_objectWithKeyValues:respDict];
            [models addObject:model];
        }];
        
        _taskResult = models;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
