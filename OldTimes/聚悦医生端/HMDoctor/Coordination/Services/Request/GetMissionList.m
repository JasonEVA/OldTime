//
//  GetMissionList.m
//  HMDoctor
//
//  Created by kylehe on 16/6/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GetMissionList.h"

@implementation GetMissionList

- (NSString *) postUrl
{
    NSString *postUrl = [ClientHelper postUserServiceUrl:@"queryTaskPage"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {

    }
}
@end
