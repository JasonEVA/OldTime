//
//  GetJKGWListRequest.m
//  HMDoctor
//
//  Created by jasonwang on 16/7/18.
//  Copyright © 2016年 yinquan. All rights reserved.
//  

#import "GetJKGWListRequest.h"
#import "JKGWModel.h"

@implementation GetJKGWListRequest

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrgTeamServiceUrl:@"getJKGWByStaffId"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]]) {
        NSArray *arrayResult = [JKGWModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = arrayResult;
    }
    
}
@end
