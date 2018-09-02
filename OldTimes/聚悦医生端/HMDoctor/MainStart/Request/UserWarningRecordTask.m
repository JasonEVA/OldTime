//
//  UserWarningRecordTask.m
//  HMDoctor
//
//  Created by lkl on 16/12/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "UserWarningRecordTask.h"
#import "UserAlertInfo.h"

@implementation UserWarningRecordTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataServiceUrl:@"getUserTestWarningLastThreeDays"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*) stepResult;
        NSMutableArray *items = [NSMutableArray array];
        for (NSDictionary *dicRecord in lstResp)
        {
            UserWarningRecord *record = [UserWarningRecord mj_objectWithKeyValues:dicRecord];
            [items addObject:record];
        }
        
        _taskResult = items;
        return;
    }
    //_taskErrorMessage = @"接口数据访问失败。";
    //_taskError = StepError_NetwordDataError;

}

@end


@implementation checkAlertIsAppearTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postDealWarningServiceUrl:@"checkAlertAppearIn24Hours"];
    return postUrl;
}

@end
