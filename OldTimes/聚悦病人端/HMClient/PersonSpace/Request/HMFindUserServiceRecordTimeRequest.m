//
//  HMFindUserServiceRecordTimeRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/4/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMFindUserServiceRecordTimeRequest.h"
#import "HMConsultingRecordsModel.h"

@implementation HMFindUserServiceRecordTimeRequest

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"findUserServiceRecordTime"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]]) {
        NSArray *arrayResult = [HMConsultingRecordsModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = arrayResult;
    }
    
}

@end
