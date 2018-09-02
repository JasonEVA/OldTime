//
//  CreateServiceOrderTask.m
//  HMClient
//
//  Created by yinqaun on 16/5/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "CreateServiceOrderTask.h"
#import "ServiceOrder.h"

@implementation CreateServiceOrderTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrderServiceUrl:@"placeOrderUpgrade"];//@"http://192.168.0.61:10018/uniqueComservice2/base.do?do=httpInterface&module=orderService&method=placeOrderUpgrade";
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        ServiceOrder* order = [ServiceOrder mj_objectWithKeyValues:dicResp];
        _taskResult = order;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
