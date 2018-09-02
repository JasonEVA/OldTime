//
//  GetSiteMessageListTask.m
//  HMClient
//
//  Created by Dee on 16/6/22.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "GetSiteMessageListTask.h"
#import "SiteMessageModel.h"
@implementation GetSiteMessageListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"getMsgByPage"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]]){
        NSMutableArray *tempArray = [NSMutableArray array];
        NSArray *dataArray = [stepResult objectForKey:@"list"];
        for (NSDictionary *dict in dataArray) {
            SiteMessageModel *model = [SiteMessageModel mj_objectWithKeyValues:dict];
            [tempArray addObject:model];
        }
        _taskResult = tempArray;
    }
}

@end
