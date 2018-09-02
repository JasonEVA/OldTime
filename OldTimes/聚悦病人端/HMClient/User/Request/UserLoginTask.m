//
//  UserLoginTask.m
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserLoginTask.h"

@implementation UserLoginTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"etLogin"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        //VersionUpdateInfo* verInfo = [VersionUpdateInfo mj_objectWithKeyValues:dicResp];
        //_taskResult = verInfo;
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];

        //保存已登录账号
        NSString* logonAcct = [taskParam valueForKey:@"logonAcct"];
        [[NSUserDefaults standardUserDefaults] setValue:logonAcct forKey:@"logonAcct"];
        
        NSDictionary* dicUser = [dicResp valueForKey:@"user"];
        if (dicUser && [dicUser isKindOfClass:[NSDictionary class]])
        {
            UserInfo* user = [UserInfo mj_objectWithKeyValues:dicUser];
            [[UserInfoHelper defaultHelper] saveUserInfo:user];
            [dicResult setValue:user forKey:@"user"];
        }
        
        _taskResult = dicResult;
    }
    
}

@end

@implementation UserMobileConfirmTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"getConfirmCode"];
    return postUrl;
}

@end

@implementation UserRegisterTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"userRegister"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        
       // NSDictionary* dicUser = [dicResp valueForKey:@"user"];
        if (dicResp && [dicResp isKindOfClass:[NSDictionary class]])
        {
            UserInfo* user = [UserInfo mj_objectWithKeyValues:dicResp];
            [[UserInfoHelper defaultHelper] saveUserInfo:user];
            //[dicResult setValue:user forKey:@"user"];
             _taskResult = user;
        }
        
       
    }
    
}
@end
