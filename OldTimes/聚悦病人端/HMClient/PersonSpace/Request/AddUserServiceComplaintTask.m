//
//  AddUserServiceComplaintTask.m
//  HMClient
//
//  Created by Dee on 16/6/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AddUserServiceComplaintTask.h"

@implementation AddUserServiceComplaintTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper posuserServicePoServiceUrl:@"addUserServiceComplain"];
    return postUrl;
}

- (void)makeTaskResult
{
    
}

@end
