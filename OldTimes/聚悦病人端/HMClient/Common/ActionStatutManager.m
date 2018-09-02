//
//  ActionStatutManager.m
//  HMClient
//
//  Created by Dee on 16/9/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ActionStatutManager.h"
#import "TaskManager.h"
#import "UserInfo.h"
#import "IpAddressHealper.h"
static NSString *const kCallType        = @"calltype";        //调用标志
static NSString *const kUserID          = @"userId";          //用户Id
static NSString *const kFuncName        = @"funcName";        //app功能页面Name
static NSString *const kActionTime      = @"actionTime";      //操作时间
static NSString *const kSubmitTime      = @"submitTime";      //提交数据时间
static NSString *const kIP              = @"ip";              //IP地址
static NSString *const kUserMark        = @"userMark";        //用户标识 IMEI
static NSString *const kPhoneSystem     = @"phoneSystem";      //手机系统类型

@interface ActionStatutManager ()

@property(nonatomic, strong) NSMutableDictionary  *dict;

@end

@implementation ActionStatutManager

+ (ActionStatutManager *)shareInstance {
    static ActionStatutManager *manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.userStaticsticIsOn = YES;
    });
    return manager;
}


//数据分析接口
- (void)addActionStatusWithPageName:(NSString *)pageName {
    
    if (self.userStaticsticIsOn) {
        NSDictionary * paramdict = [self prepareDictWithPageName:pageName];
        [[TaskManager shareInstance] createTaskWithTaskName:@"AppendActionStatTask" taskParam:paramdict TaskObserver:nil];
    }
}

- (NSDictionary *)prepareDictWithPageName:(NSString *)pageName {
    UserInfo *userInfo = [[UserInfoHelper defaultHelper] currentUserInfo];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:@"1" forKey:kCallType];
    [dict setValue:[NSString stringWithFormat:@"%@",@(userInfo.userId)]  forKey:kUserID]; //用户的USERID
    [dict setValue:pageName?[NSString stringWithFormat:@"%@",pageName]:@"" forKey:kFuncName];
    [dict setValue:[self getCurrntTime] forKey:kActionTime];
    [dict setValue:[self getCurrntTime] forKey:kSubmitTime];
    [dict setValue:[IpAddressHealper getIPAddress:NO] forKey:kIP];
    [dict setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:kUserMark];
    return dict;
}

- (NSString *)getCurrntTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [format stringFromDate:date];
}
#pragma mark - setterAndGetter



@end
