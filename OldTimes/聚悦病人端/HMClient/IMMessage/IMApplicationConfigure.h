//
//  IMApplicationConfigure.h
//  HMClient
//
//  Created by yinqaun on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MintcodeIMKit/MintcodeIMKit.h>

// ************** 应用Id **************//
extern NSString *const im_task_uid;
extern NSString *const im_approval_uid;
extern NSString *const im_schedule_uid;

////聚悦平台
//#ifdef kPlantform_JuYue
//#ifdef YuYouNetowrk
//
//static NSString * const im_IP_http = @"http://imhttp.joyjk.com:10017/launchr";
//static NSString * const im_IP_ws   = @"ws://imws.joyjk.com:10016/launchr";
//static NSString * const im_IP_test = @"0.0.0.0";
//
//static NSString * const im_appName = @"test";
//static NSString * const im_appToken = @"verify-code";
//
//#else
//static NSString * const im_IP_http = @"http://imhttp.juyuejk.com/launchr";
//static NSString * const im_IP_ws   = @"ws://imws.juyuejk.com/launchr";
//static NSString * const im_IP_test = @"0.0.0.0";
//
//static NSString * const im_appName = @"ALL";
//static NSString * const im_appToken = @"verify-code";
//#endif
//
//#endif




/// 应用配置 [10001, 19999]
typedef NS_ENUM(NSUInteger, IM_Applicaion_Type) {
    IM_Applicaion_task = 10001,
    IM_Applicaion_approval,
    IM_Applicaion_schedule,
};
