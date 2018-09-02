//
//  UserInfo.m
//  HealthManagerDoctorDemo
//
//  Created by yinqaun on 16/1/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserInfo.h"
#import "LoginAccount.h"
//#import "LoginAccountUtil.h"

@implementation UserInfo


@end

@implementation StaffInfo


@end

static UserInfoHelper* defaultUserInfoHelper = nil;

@implementation UserInfoHelper

@synthesize staffRole = _staffRole;

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
        
        NSDictionary* dicStaff = [[NSUserDefaults standardUserDefaults] valueForKey:@"staffinfo"];
        if (dicStaff && [dicStaff isKindOfClass:[NSDictionary class]])
        {
            StaffInfo* staff = [StaffInfo mj_objectWithKeyValues:dicStaff];
            if (staff)
            {
                _currentStaffInfo = staff;
            }
        }
        
        NSString* staffRole = [[NSUserDefaults standardUserDefaults] valueForKey:@"staffRole"];
        if (staffRole && [staffRole isKindOfClass:[NSString class]])
        {
            _staffRole = staffRole;
        }
    }
    return self;
}

- (void) userlogout
{
    _currentUserInfo = nil;
    _currentStaffInfo = nil;
    _staffRole = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userinfo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"staffinfo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"staffRole"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void) saveUserInfo:(UserInfo*) user
{
    if (!user)
    {
        return;
    }
    
    _currentUserInfo = user;
    NSDictionary* dicUser = [user mj_keyValues];
    [[NSUserDefaults standardUserDefaults] setValue:dicUser forKey:@"userinfo"];
    [[NSUserDefaults standardUserDefaults] setValue:user.logonAcct forKey:@"logonAcct"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) saveStaffInfo:(StaffInfo*) staff
{
    if (!staff)
    {
        return;
    }
    
    _currentStaffInfo = staff;
    NSDictionary* dicStaff = [staff mj_keyValues];
    [[NSUserDefaults standardUserDefaults] setValue:dicStaff forKey:@"staffinfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) setStaffRole:(NSString*) role
{
    if (!role)
    {
        return;
    }
    
    _staffRole = role;
    
    [[NSUserDefaults standardUserDefaults] setValue:role forKey:@"staffRole"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (NSString*) loginAcct
{
    NSString* loginAcct = [[NSUserDefaults standardUserDefaults] valueForKey:@"logonAcct"];
    return loginAcct;
}

+ (void) makeDirectory:(NSString*) path
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (NSString*) docDir
{
    NSArray *cache = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    NSString *cachePath = [[cache objectAtIndex:0] stringByAppendingPathComponent:@"JYHM"];
    [self makeDirectory:cachePath];
    return cachePath;
}

+ (NSString*) userDir
{
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSString* dicName = [NSString stringWithFormat:@"%ld", staff.staffId];
    NSString* userDir = [[self docDir] stringByAppendingPathComponent:dicName];
    [self makeDirectory:userDir];
    return userDir;
}

- (BOOL)isBigFont
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:@"isBigFont"] boolValue];
}

- (void)setIsBigFont:(BOOL)isBigFont
{
    [[NSUserDefaults standardUserDefaults] setValue:@(isBigFont) forKey:@"isBigFont"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
