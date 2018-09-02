//
//  HMIMCELLFeedBackPatientRoundsRequest.m
//  HMDoctor
//
//  Created by jasonwang on 16/9/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMIMCELLFeedBackPatientRoundsRequest.h"

@implementation HMIMCELLFeedBackPatientRoundsRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postPatientRoundsService:@"feedBackPatientRounds"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]]){
        //        NSMutableArray *tempArray = [NSMutableArray array];
        //        NSArray *dataArray = [stepResult objectForKey:@"list"];
        //        for (NSDictionary *dict in dataArray) {
        //            SiteMessageModel *model = [SiteMessageModel mj_objectWithKeyValues:dict];
        //            [tempArray addObject:model];
        //        }
        _taskResult = stepResult;
    }
}

@end
