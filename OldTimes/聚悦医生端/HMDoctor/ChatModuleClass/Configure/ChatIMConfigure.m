//
//  ChatIMConfigure.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/5.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ChatIMConfigure.h"

//聚悦平台
#ifdef kPlantform_JuYue
#ifdef YuYouNetowrk

NSString * const im_IP_http = @"http://imhttp.joyjk.com:10017/launchr";
NSString * const im_IP_ws   = @"ws://imws.joyjk.com:10016/launchr";
NSString * const im_IP_test = @"0.0.0.0";

NSString * const im_appName = @"test";
NSString * const im_appToken = @"verify-code";

#elif kSimulation_Netwrok
//仿真环境
NSString * const im_IP_http = @"http://imhttp.joyjk.cn/launchr";
NSString * const im_IP_ws   = @"ws://imws.joyjk.cn/launchr";
NSString * const im_IP_test = @"0.0.0.0";

NSString * const im_appName = @"ALL";
NSString * const im_appToken = @"verify-code";
#else
NSString * const im_IP_http = @"http://imhttp.juyuejk.com/launchr";
NSString * const im_IP_ws   = @"ws://imws.juyuejk.com/launchr";
NSString * const im_IP_test = @"0.0.0.0";

NSString * const im_appName = @"ALL";
NSString * const im_appToken = @"verify-code";
#endif

NSString * const im_doctorPatientGroupTag = @"DOCTOR_USER_GROUP"; // 医患群聊天tag
NSString * const im_workGroupTag = @"WORK_GROUP"; // 医生群聊天tag

#endif

