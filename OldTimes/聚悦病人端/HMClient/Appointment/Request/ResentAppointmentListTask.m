//
//  ResentAppointmentListTask.m
//  HMClient
//
//  Created by yinquan on 2017/10/18.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "ResentAppointmentListTask.h"
#import "RecentlyAppointmentModel.h"

@implementation ResentAppointmentListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postAppointmetnServiceUrl:@"findUserAppointedStaffList"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSMutableArray* models = [NSMutableArray array];
        NSArray<NSDictionary*>* dictionarys = (NSArray<NSDictionary*>*) stepResult;
        [dictionarys enumerateObjectsUsingBlock:^(NSDictionary * dict, NSUInteger idx, BOOL * _Nonnull stop) {
            RecentlyAppointmentModel* model = [RecentlyAppointmentModel mj_objectWithKeyValues:dict];
            [models addObject:model];
        }];
        
        _taskResult = models;
        return;
    }
    
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
