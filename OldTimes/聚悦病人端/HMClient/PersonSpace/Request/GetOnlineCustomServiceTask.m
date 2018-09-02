//
//  GetOnlineCustomServiceTask.m
//  HMClient
//
//  Created by Andrew Shen on 16/6/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "GetOnlineCustomServiceTask.h"
#import "OnlineCustomServiceModel.h"

@implementation GetOnlineCustomServiceTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"getOnlineCustomService"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]]) {
        NSArray *arrayResult = [OnlineCustomServiceModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = arrayResult;
    }

}

@end
