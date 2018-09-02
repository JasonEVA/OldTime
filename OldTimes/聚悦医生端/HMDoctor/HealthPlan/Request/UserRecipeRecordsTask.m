//
//  UserRecipeRecordsTask.m
//  HMDoctor
//
//  Created by yinquan on 2017/9/14.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "UserRecipeRecordsTask.h"
#import "PrescribeInfo.h"

@implementation UserRecipeRecordsTask


- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postRecipeServiceUrl:@"getUserCurrentMedication"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSArray class]])
    {
        __block NSMutableArray* durgList = [NSMutableArray array];
        NSArray* respArray = (NSArray*) stepResult;
        
        [respArray enumerateObjectsUsingBlock:^(NSDictionary* dict, NSUInteger idx, BOOL * _Nonnull stop) {
            PrescribeTempInfo* drug = [PrescribeTempInfo mj_objectWithKeyValues:dict];
            [durgList addObject:drug];
        }];
        
        _taskResult = durgList;
        return;
    }

    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
