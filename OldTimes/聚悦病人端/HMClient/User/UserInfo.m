//
//  UserInfo.m
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserInfo.h"
#import "InitializationHelper.h"
static NSString *const kIsBigFont = @"isBigFont";
@implementation UserInfo

- (NSString*) imgUrl
{
    if (_imgUrl)
    {
        return _imgUrl;
    }
    if (_img)
    {
        return _img;
    }
    return nil;
}

@end

@implementation StaffInfo

- (NSString*) imgUrl
{
    if (_imgUrl)
    {
        return _imgUrl;
    }
    if (_staffIcon)
    {
        return _staffIcon;
    }
    return nil;
}
@end

static UserInfoHelper* defaultUserInfoHelper = nil;

@interface UserInfoHelper ()<TaskObserver>
@property (nonatomic, copy) UserInfoHelperBlock block;
@end
@implementation UserInfoHelper

@synthesize lastSignedDate = _lastSignedDate;
@synthesize showBrithDay = _showBrithDay;

+ (UserInfoHelper*) defaultHelper
{
    if (!defaultUserInfoHelper)
    {
        defaultUserInfoHelper = [[UserInfoHelper alloc]init];
    }
    return defaultUserInfoHelper;
}

- (id) init
{
    self = [super init];
    if (self){
        NSDictionary* dicUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"userinfo"];
        if (dicUser && [dicUser isKindOfClass:[NSDictionary class]])
        {
            UserInfo* user = [UserInfo mj_objectWithKeyValues:dicUser];
            if (user)
            {
                _currentUserInfo = user;
            }
        }
        
    }
    return self;
}

- (void) saveUserInfo:(UserInfo*) userInfo
{
    if (!userInfo)
    {
        return;
    }
    [self setCurrentUserInfo:userInfo];
    
    NSDictionary* dicUser = [userInfo mj_keyValues];
    [[NSUserDefaults standardUserDefaults] setValue:dicUser forKey:@"userinfo"];
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) userlogout
{
    _currentUserInfo = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userinfo"];
    [[NSUserDefaults standardUserDefaults] setValue:@"N" forKey:@"hasService"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"privilege"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastSignedDate"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //[[InitializationHelper defaultHelper] setUserService:nil];
}

+ (BOOL) needLogin
{
    UserInfoHelper* helper = [UserInfoHelper defaultHelper];
    UserInfo* curUser = [helper currentUserInfo];
    return (nil == curUser);
}

- (NSString*) loginAcct
{
    NSString* loginAcct = [[NSUserDefaults standardUserDefaults] valueForKey:@"logonAcct"];
    return loginAcct;
}

- (BOOL)isBigFont
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kIsBigFont] boolValue];
}

- (void)setIsBigFont:(BOOL)isBigFont
{
    [[NSUserDefaults standardUserDefaults] setValue:@(isBigFont) forKey:kIsBigFont];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*) lastSignedDate
{
    if (!_lastSignedDate) {
        _lastSignedDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastSignedDate"];
    }
    return _lastSignedDate;
}

- (void) setLastSignedDate:(NSString *)lastSignedDate
{
    if (!lastSignedDate) {
        return;
    }
    _lastSignedDate = lastSignedDate;
    [[NSUserDefaults standardUserDefaults] setValue:lastSignedDate forKey:@"lastSignedDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*) showBrithDay
{
    if (!_showBrithDay) {
        _showBrithDay = [[NSUserDefaults standardUserDefaults] valueForKey:@"showBrithDay"];
    }
    return _showBrithDay;
}

- (void) setShowBrithDay:(NSString *)showBrithDay
{
    if (!showBrithDay) {
        return;
    }
    _showBrithDay = showBrithDay;
    [[NSUserDefaults standardUserDefaults] setValue:showBrithDay forKey:@"showBrithDay"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) todayHasBeenSigned
{
    BOOL todayHasBeenSigned = NO;
    if (!self.lastSignedDate) {
        return todayHasBeenSigned;
    }
    
    NSDate* signDate = [NSDate dateWithString:self.lastSignedDate formatString:@"yyyy-MM-dd HH:mm:ss"];
    if (!signDate) {
        return todayHasBeenSigned;
    }
    todayHasBeenSigned = [signDate isToday];
    return todayHasBeenSigned;
}

- (BOOL) todayHasShownBrithday
{
    BOOL todayHasShownBrithday = NO;
    if (!self.showBrithDay) {
        return todayHasShownBrithday;
    }
    
    NSDate* signDate = [NSDate dateWithString:self.showBrithDay formatString:@"yyyy-MM-dd"];
    if (!signDate) {
        return todayHasShownBrithday;
    }
    
    todayHasShownBrithday = [signDate isToday];
    
    return todayHasShownBrithday;
}

//获取当前账号下最新IMGroup的UID
- (void)getIMGroupUid:(UserInfoHelperBlock)block {
    self.block = block;
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceStaffTeamTask" taskParam:nil TaskObserver:self];

}

#pragma mark - TaskObserver
- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage{
    if (errorMessage.length > 0) {
        if (self.block) {
            self.block([UserInfo new],errorMessage);
        }
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"ServiceStaffTeamTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            NSNumber* numTeamId = [dicResult valueForKey:@"teamId"];
            if (numTeamId && [numTeamId isKindOfClass:[NSNumber class]])
            {
                NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
                [dicPost setValue:[NSString stringWithFormat:@"%ld", numTeamId.integerValue] forKey:@"teamId"];
                self.currentUserInfo.teamId = [NSString stringWithFormat:@"%@",numTeamId];
                [[TaskManager shareInstance] createTaskWithTaskName:@"TeamImGroupIdTask" taskParam:dicPost TaskObserver:self];
            }
            
        }
    }
    else if ([taskname isEqualToString:@"TeamImGroupIdTask"])
    {
//        [self.view closeWaitView];
        if (taskResult && [taskResult isKindOfClass:[NSString class]])
        {
            NSString* targetId = (NSString*) taskResult;
            if (!targetId || 0 == targetId) {
                return;
            }
            
            NSString *grouptargetId = (NSString*) taskResult;
            self.currentUserInfo.IMUid = grouptargetId;
            
            if (self.block) {
                self.block(self.currentUserInfo,@"");
            }
        }
        
    }
}

@end
