//
//  StaffPatientCountTask.m
//  HMDoctor
//
//  Created by lkl on 16/7/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "StaffPatientCountTask.h"

@implementation StaffPatientCountTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServicePoServiceUrl:@"getStaffPatientCount"];
    return postUrl;
}

@end
