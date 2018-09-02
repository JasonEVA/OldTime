//
//  UserAlertListTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/2.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "UserAlertListTask.h"
#import "UserAlertInfo.h"

@implementation UserAlertListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataServiceUrl:@"getUserTestDataAlert"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSNumber* numCount = [dicResp valueForKey:@"count"];
        NSArray* lstResp = [dicResp valueForKey:@"list"];
        NSMutableArray* alertItems = [NSMutableArray array];
        if (lstResp && [lstResp isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicAlert in lstResp)
            {
                UserAlertInfo* alert = [UserAlertInfo mj_objectWithKeyValues:dicAlert];
                [alertItems addObject:alert];
            }
        }
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        [dicResult setValue:alertItems forKey:@"list"];
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        
        _taskResult = dicResult;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end

@implementation DealUserAlertTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataServiceUrl:@"doUserTestDataAlert"];
    return postUrl;
}

@end

@implementation UserAlertCountTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataServiceUrl:@"checkHasAlert"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSNumber class]])
    {
        NSNumber* numCount = (NSNumber*) stepResult;
        _taskResult = numCount;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end

@implementation DealWarningTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postDealWarningServiceUrl:@"doWarning"];
    return postUrl;
}

@end

//预警处理-联系患者
@implementation DoContactPatientTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postDealWarningServiceUrl:@"doContactPatients"];
    return postUrl;
}

@end

//获取一条预警信息
@implementation GetWarningDetTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postDealWarningServiceUrl:@"getWarningDet"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        UserWarningDetInfo *detInfo = [UserWarningDetInfo mj_objectWithKeyValues:stepResult];
        _taskResult = detInfo;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
