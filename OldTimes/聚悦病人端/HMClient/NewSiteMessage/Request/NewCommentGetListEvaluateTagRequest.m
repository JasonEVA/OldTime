//
//  NewCommentGetListEvaluateTagRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/3/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//  


#import "NewCommentGetListEvaluateTagRequest.h"
#import "NewCommentSelectLabelModel.h"

@implementation NewCommentGetListEvaluateTagRequest
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postuserServiceEvaluateURL:@"listEvaluateTag"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]] && stepResult) {
        NSArray *array = [NewCommentSelectLabelModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = array;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
