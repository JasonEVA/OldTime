//
//  NewCommentGetUserServiceEvaluateRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/3/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewCommentGetUserServiceEvaluateRequest.h"
#import "NewCommentDetailModel.h"

@implementation NewCommentGetUserServiceEvaluateRequest
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postuserServiceEvaluateURL:@"getUserServiceEvaluate"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]] && stepResult) {
        NewCommentDetailModel *model = [NewCommentDetailModel mj_objectWithKeyValues:stepResult];
        _taskResult = model;
        return;
    }
}
@end
