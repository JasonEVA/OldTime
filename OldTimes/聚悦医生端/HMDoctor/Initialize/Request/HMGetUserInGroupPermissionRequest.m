//
//  HMGetUserInGroupPermissionRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2017/4/21.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMGetUserInGroupPermissionRequest.h"
#define FASTINGROUP   @"HMFastInGroupPermission"
@implementation HMGetUserInGroupPermissionRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postFastInGroupService:@"getUserInGroupPermission"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        if (stepResult[@"hasPermission"]) {
            [[NSUserDefaults standardUserDefaults] setValue:stepResult[@"hasPermission"] forKey:FASTINGROUP];
        }
        return;
    }
}
@end
