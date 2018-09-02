//
//  GetOrgTeamServiceTask.m
//  HMDoctor
//
//  Created by kylehe on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GetOrgTeamServiceTask.h"
#import "NSDictionary+SafeManager.h"
#import "PatientModel.h"
static NSString *const t_list = @"list";
@implementation GetOrgTeamServiceTask

- (NSString *) postUrl
{
    NSString *posturl = [ClientHelper postOrgTeamServiceUrl:@"getTeamUserPatientByTeamId"];
    return posturl;
}

- (void)makeTaskResult
{
    NSDictionary *stepResult = currentStep.stepResult;
    NSArray *listArray = [stepResult valueArrayForKey:t_list];
    NSMutableArray *modelArray = [NSMutableArray array];
    
    for (NSDictionary *dict in listArray)
    {
        PatientModel *model = [[PatientModel alloc] initWithDitc:dict];
        [modelArray addObject:model];
    }
    _taskResult = modelArray;
}

@end
