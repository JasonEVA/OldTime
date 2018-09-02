//
//  NewCommentAddUserServiceEvaluateRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/3/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewCommentAddUserServiceEvaluateRequest.h"

@implementation NewCommentAddUserServiceEvaluateRequest
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postuserServiceEvaluateURL:@"addUserServiceEvaluate"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
//        if ([stepResult isKindOfClass:[NSDictionary class]] && stepResult) {
//            NewCommentDetailModel *model = [NewCommentDetailModel mj_objectWithKeyValues:stepResult];
//            _taskResult = model;
//            return;
//        }
//        _taskError = StepError_NetwordDataError;
//        _taskErrorMessage = @"服务器数据访问失败。";
}

@end
