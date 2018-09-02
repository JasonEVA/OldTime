//
//  ForgetPasswordTask.m
//  HMClient
//
//  Created by lkl on 16/6/28.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ForgetPasswordTask.h"

@implementation ForgetPasswordTask

@end


@implementation USerUpdatePwdTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"updateUserPwd"];
    return postUrl;
}

@end

@implementation UserMobileByIdCardTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"getUserMobileByIdCard"];
    return postUrl;
}

@end

@implementation UserMobileByMobileTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"getUserByMobile"];
    return postUrl;
}

@end

@implementation UserModifyPwdTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"modifyUserPwd"];
    return postUrl;
}

@end
