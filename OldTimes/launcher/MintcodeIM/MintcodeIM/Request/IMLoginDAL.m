//
//  IMLoginDAL.m
//  launcher
//
//  Created by William Zhang on 15/8/27.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "IMLoginDAL.h"
#import "NSDictionary+IMSafeManager.h"
#import "MsgUserInfoMgr.h"
#import "IMConfigure.h"

static NSString * const d_deviceName = @"deviceName";
static NSString * const d_os         = @"os";
static NSString * const d_osVer      = @"osVer";
static NSString * const d_appVer     = @"appVer";
static NSString * const d_deviceUUID = @"deviceUUID";
static NSString * const d_appToken   = @"appToken";

static NSString * const d_userName  = @"userName";
static NSString * const d_appName   = @"appName";
static NSString * const d_loginType = @"loginType";

@interface IMLoginDAL ()

@end

@implementation IMLoginDAL

+ (void)loginCompletion:(IMBaseResponseCompletion)completion {
    
    NSParameterAssert(completion);
    
    IMLoginDAL *loginRequest = [[IMLoginDAL alloc] init];
    
    loginRequest.params[d_appVer]      = IM_SDK_Version;
    loginRequest.params[d_os]          = IM_iOS_system_name;
    loginRequest.params[d_userName]    = [[MsgUserInfoMgr share] getUid] ?:@"";
    loginRequest.params[d_appName]     = [[MsgUserInfoMgr share] getAppName];
    loginRequest.params[d_deviceName]  = IM_iOS_device_type();
    loginRequest.params[d_deviceUUID]  = [[MsgUserInfoMgr share] remoteNotifyToken];
    loginRequest.params[d_appToken]    = [[MsgUserInfoMgr share] getAppToken];
    loginRequest.params[d_osVer]       = IM_iOS_device_version();
    loginRequest.params[d_loginType]   = [[MsgUserInfoMgr share] loginType];
    loginRequest.params[@"voipDevice"] = [[MsgUserInfoMgr share] voipToken];
    
    [loginRequest requestDataCompletion:completion];
}

- (NSString *)action { return @"/login"; }
- (BOOL)configEssentialParamsIfNeed { return NO; }

- (IMBaseResponse *)prepareResponse:(NSDictionary *)data {
    IMLoginResponse *response = [IMLoginResponse new];
    response.token = [data im_valueStringForKey:@"userToken"];
    response.uid   = [data im_valueStringForKey:@"uid"];
    return response;
}

@end

@implementation IMLoginResponse
@end