//
//  MainConsoleFunctionsTask.m
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "MainConsoleFunctionsTask.h"
#import "MainConsoleFunctionModel.h"

@implementation MainConsoleFunctionsTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postWorkTaskServiceUrl:@"doctorHomePageFunction"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if ([stepResult isKindOfClass:[NSDictionary class]]) {
        NSDictionary* respDictionary = (NSDictionary*) stepResult;
        MainConsoleFunctionRetModel* statiscticsRetModel = [MainConsoleFunctionRetModel mj_objectWithKeyValues:respDictionary];
        _taskResult = statiscticsRetModel;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
