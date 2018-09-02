//
//  GetPersonServiceComplainListTask.m
//  HMClient
//
//  Created by Dee on 16/6/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "GetPersonServiceComplainListTask.h"
#import "PersonServiceComplainListModel.h"
@implementation GetPersonServiceComplainListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper posuserServicePoServiceUrl:@"getUserServiceComplain"];
    return postUrl;
}


- (void)makeTaskResult
{
    id result = currentStep.stepResult;
    if ([result isKindOfClass:[NSDictionary class]])
    {
        id stepResult = [result objectForKey:@"list"];
        NSMutableArray *tempModelArray = [NSMutableArray array];
        for (int i = 0; i < [stepResult count]; i++)
        {
            PersonServiceComplainListModel *model = [PersonServiceComplainListModel mj_objectWithKeyValues:stepResult[i]];
            [tempModelArray addObject:model];
        }
        _taskResult =tempModelArray;
    }
}
@end
