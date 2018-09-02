//
//  UserInfoTask.m
//  HMClient
//
//  Created by yinqaun on 16/4/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserInfoTask.h"
#import "ImageHttpStep.h"
#import "JsonHttpStep.h"
#import "UserOftenIllInfo.h"

@implementation UserInfoTask
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"getUserById"];
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
        
        //NSDictionary* dicUser = [dicResp valueForKey:@"user"];
        if (dicResp && [dicResp isKindOfClass:[NSDictionary class]])
        {
            UserInfo* user = [UserInfo mj_objectWithKeyValues:dicResp];
            [[UserInfoHelper defaultHelper] saveUserInfo:user];
            [dicResult setValue:user forKey:@"user"];
            
            if (user.userIlls && 0 < user.userIlls.count) {
                NSMutableArray* ills = [NSMutableArray array];
                for (NSDictionary* dicIll in user.userIlls)
                {
                    UserOftenIllInfo* ill =[[UserOftenIllInfo alloc]init];
                    NSString* illName = [dicIll valueForKey:@"ILL_NAME"];
                    if (illName && [illName isKindOfClass:[NSString class]])
                    {
                        [ill setIllName:illName];
                    }
                    
                    NSNumber* numId = [dicIll valueForKey:@"ILL_ID"];
                    if (numId && [numId isKindOfClass:[NSNumber class]])
                    {
                        [ill setIllId:numId.integerValue];
                    }
                    
                    [ills addObject:ill];
                    
                }
                
                [user setUserIlls:ills];
            }
        }
        
        _taskResult = dicResult;
    }
    
}
@end


typedef enum : NSUInteger {
    UserPhotoPostIndex,
    UserPhotoUpdateInfoIndex,
} UserPhotoStepIndex;

@interface UserPhotoUpdateTask ()
{
    NSString* photoUrl;
}
@end

@implementation UserPhotoUpdateTask

- (Step*) createFristStep
{

    if (self.extParam && [self.extParam isKindOfClass:[NSData class]])
    {
        NSMutableDictionary* dicParam = [ClientHelper buildCommonHttpParam];
        ImageHttpStep* step = [[ImageHttpStep alloc]initWithType:@"userPhoto" Params:dicParam ImageData:self.extParam];
        step.tag = UserPhotoPostIndex;
        return step;
    }
    return nil;

}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    switch (currentStep.tag)
    {
        case UserPhotoPostIndex:
        {
            if ([stepResult isKindOfClass:[NSString class]])
            {
                photoUrl = stepResult;
            }
        }
            break;
        case UserPhotoUpdateInfoIndex:
        {
            if ([stepResult isKindOfClass:[NSDictionary class]])
            {
                NSDictionary* dicResp = stepResult;
                UserInfo* userInfo = [UserInfo mj_objectWithKeyValues:dicResp];
                if (userInfo.userIlls && 0 < userInfo.userIlls.count) {
                    NSMutableArray* ills = [NSMutableArray array];
                    for (NSDictionary* dicIll in userInfo.userIlls)
                    {
                        UserOftenIllInfo* ill =[[UserOftenIllInfo alloc]init];
                        NSString* illName = [dicIll valueForKey:@"ILL_NAME"];
                        if (illName && [illName isKindOfClass:[NSString class]])
                        {
                            [ill setIllName:illName];
                        }
                        
                        NSNumber* numId = [dicIll valueForKey:@"ILL_ID"];
                        if (numId && [numId isKindOfClass:[NSNumber class]])
                        {
                            [ill setIllId:numId.integerValue];
                        }
                        
                        [ills addObject:ill];
                        
                    }
                    
                    [userInfo setUserIlls:ills];
                }

                [[UserInfoHelper defaultHelper] saveUserInfo:userInfo];
                _taskResult = userInfo;
            }
        }
            break;
        default:
            break;
    }
}

- (Step*) createNextStep
{
    switch (currentStep.tag)
    {
        case UserPhotoPostIndex:
        {
            //更新用户头像信息
            if (photoUrl && 0 < photoUrl.length)
            {
                NSString* postUrl = [ClientHelper postUserServiceUrl:@"userInfoUpdate"];;
                if (postUrl)
                {
                    NSMutableDictionary* dicParam = [NSMutableDictionary dictionary];
                    [dicParam setValue:photoUrl forKey:@"imgUrl"];
                    
                    JsonHttpStep* step = [[JsonHttpStep alloc]initWithUrl:postUrl Params:dicParam];
                    step.tag = UserPhotoUpdateInfoIndex;
                    return step;
                }

            }
        }
            break;
        default:
            break;
    }
    return nil;
}

@end

@implementation UserResetPasswordTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"updateUserPwdNoConfirm"];
    return postUrl;
}

@end

@implementation UpdateUserInfoTask


- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"userInfoUpdate"];
    return postUrl;
}

@end

@implementation BindUserMobileTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"userBindMobile"];
    return postUrl;
}

@end


@implementation BindUserIdCardTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"bindIdCardCreateDocment"];
    return postUrl;
}

@end
