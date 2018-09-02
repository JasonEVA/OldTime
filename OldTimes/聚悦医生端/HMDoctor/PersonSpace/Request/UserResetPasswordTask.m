//
//  UserResetPasswordTask.m
//  HMDoctor
//
//  Created by lkl on 16/6/27.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "UserResetPasswordTask.h"

@implementation UserResetPasswordTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"updateUserPwdNoConfirm"];
    return postUrl;
}

@end

@implementation USerUpdatePwdTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"updateUserPwd"];
    return postUrl;
}

@end


@implementation UserMobileConfirmTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"getConfirmCode"];
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

@implementation UserModifyPwdTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"modifyUserPwd"];
    return postUrl;
}

@end

