//
//  HMSendReceipMagRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2017/8/11.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMSendReceipMagRequest.h"

@implementation HMSendReceipMagRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postReceiptMsgServiceURL:@"sendMsgWithUserId"];
    return postUrl;
}

//- (void) makeTaskResult
//{
//    id stepResult = currentStep.stepResult;
//    
//    if ([stepResult isKindOfClass:[NSArray class]])
//    {
//        NSArray *array = [RecordExtendTitleModel mj_objectArrayWithKeyValuesArray:stepResult];
//        _taskResult = array;
//        return;
//    }
//    _taskErrorMessage = @"接口数据访问失败。";
//    _taskError = StepError_NetwordDataError;
//}

@end
