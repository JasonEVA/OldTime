//
//  NewMissionGetTeamMemberRequest.m
//  HMDoctor
//
//  Created by jasonwang on 16/8/5.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "NewMissionGetTeamMemberRequest.h"
#import "ServiceGroupMemberModel.h"
@implementation NewMissionGetTeamMemberRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrgTeamServiceUrl:@"getOrgTeamDetsByTeamId"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]]) {
        NSArray *tempArr = [ServiceGroupMemberModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = tempArr;
    }
}
@end
