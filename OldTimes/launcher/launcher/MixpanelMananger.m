//
//  MixpanelMananger.m
//  launcher
//
//  Created by williamzhang on 15/11/11.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MixpanelMananger.h"
#import "ContactPersonDetailInformationModel.h"
#import "UnifiedUserInfoManager.h"
#import <Mixpanel/Mixpanel.h>
#import "UnifiedSqlManager.h"

@implementation MixpanelMananger

+ (void)installToken:(NSString *)token {
#if (defined(JAPANMODE) && defined(JAPANTESTMODE))
    [Mixpanel sharedInstanceWithToken:token];
#else
    
#endif
}

+ (void)track:(NSString *)track {
#if (defined(JAPANMODE) && defined(JAPANTESTMODE))
    [[Mixpanel sharedInstance] track:track properties:[self userInfoDict]];
#else
    
#endif
}

+ (void)track:(NSString *)track properties:(NSDictionary *)properties {
#if (defined(JAPANMODE) && defined(JAPANTESTMODE))
    NSMutableDictionary *dict = [self userInfoDict];
    [dict setDictionary:properties];
    [[Mixpanel sharedInstance] track:track properties:dict];
#endif
}

+ (NSMutableDictionary *)userInfoDict {
#if (defined(JAPANMODE) && defined(JAPANTESTMODE))
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionary];
    
    ContactPersonDetailInformationModel *model = [[UnifiedSqlManager share] findPersonWithShowId:[[UnifiedUserInfoManager share] userShowID]];
    if (!model) {
        return userinfo;
    }
    [userinfo setObject:model.u_true_name forKey:@"userName"];
    [userinfo setObject:model.u_mail forKey:@"email"];
    [userinfo setObject:model.u_job forKey:@"job"];
    [userinfo setObject:[NSDate dateWithTimeIntervalSince1970:model.last_login_time] forKey:@"lastloginTime"];
    [userinfo setObject:[NSDate date] forKey:@"loginTime"];
    [userinfo setObject:@"iOS" forKey:@"device"];
    return userinfo;
#else
    return nil;
#endif
}

@end
