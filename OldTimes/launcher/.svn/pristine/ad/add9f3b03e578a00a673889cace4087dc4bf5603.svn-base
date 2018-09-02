//
//  GetSessionUserProfileDAL.m
//  MintcodeIMFramework
//
//  Created by Andrew Shen on 15/6/11.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#import "GetSessionUserProfileDAL.h"
#import <AFNetworking/AFNetworking.h>
#import "NSDictionary+IMSafeManager.h"
#import "UserProfileModel+Private.h"
#import "MsgUserInfoMgr.h"
#import "MsgDefine.h"

#define Dict_sessionName @"sessionName"

@interface GetSessionUserProfileResponse : IMBaseResponse
@property (nonatomic, strong) UserProfileModel *userProfile;
@end
@implementation GetSessionUserProfileResponse
@end


@implementation GetSessionUserProfileDAL

- (NSString *)action { return @"/session";}

+ (void)sessionid:(NSString *)sessionId completion:(void (^)(UserProfileModel *))completion {
    if (!completion) {
        return;
    }
    
    GetSessionUserProfileDAL *request = [GetSessionUserProfileDAL new];
    request.params[Dict_sessionName] = sessionId;
    [request requestDataCompletion:^(IMBaseResponse *response, BOOL success) {
        if (!success) {
            return;
        }
       
        if (!response) {
            return;
        }
        
        completion([(id)response userProfile]);
    }];
}

- (IMBaseResponse *)prepareResponse:(NSDictionary *)data {
    NSDictionary *dataDictionary = [data im_valueDictonaryForKey:M_I_data];
    UserProfileModel *userProfile = [[UserProfileModel alloc] initWithDict:dataDictionary];
    if (![userProfile.userName length] || ![userProfile.nickName length]) {
        return nil;
    }
    
    GetSessionUserProfileResponse *response = [GetSessionUserProfileResponse new];
    response.userProfile = userProfile;
    return response;
}

@end
