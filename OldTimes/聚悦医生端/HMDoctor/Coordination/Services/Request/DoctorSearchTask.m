//
//  DoctorSearchTask.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "DoctorSearchTask.h"
#import "DoctorSearchResultsModel.h"

@implementation DoctorSearchTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"searchStaffUser"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        DoctorSearchResultsModel *model = [DoctorSearchResultsModel mj_objectWithKeyValues:stepResult];
        _taskResult = model;
    }

}

@end
