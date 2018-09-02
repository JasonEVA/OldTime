//
//  HMGetCommonLangageListRequest.m
//  HMDoctor
//
//  Created by jasonwang on 16/9/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMGetCommonLangageListRequest.h"
#import "HMCommonLangageModel.h"
@implementation HMGetCommonLangageListRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"getCommonLanguageListByStaffId"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]]){
                NSArray *dataArray = [stepResult objectForKey:@"list"];
                _taskResult = [HMCommonLangageModel mj_objectArrayWithKeyValuesArray:dataArray];
    }
}

@end
