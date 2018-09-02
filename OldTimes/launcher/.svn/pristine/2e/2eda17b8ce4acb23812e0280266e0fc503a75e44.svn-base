//
//  ChatIMConfigure.h
//  launcher
//
//  Created by williamzhang on 16/3/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#ifndef ChatIMConfigure_h
#define ChatIMConfigure_h

#define M_N_GETMESSAGELIST @"m_getMessageList"// 获取离线

#pragma mark - Address Ip

#ifdef JAPANMODE// 🇯🇵
static NSString * const im_IP_http = @"https://imhttp.workhub.jp/launchr";
static NSString * const im_IP_ws   = @"wss://imws.workhub.jp";
static NSString * const im_IP_test = @"0.0.0.0";//@"121.41.96.47";
//
#elif JAPANTESTMODE// 🇯🇵测试
static NSString * const im_IP_http = @"http://imhttptest.workhub.jp/launchr";
static NSString * const im_IP_ws   = @"ws://imwstest.launchr.jp:20000";
static NSString * const im_IP_test = @"0.0.0.0";//@"121.41.96.47";

#elif CHINAMODE // 演示专用
static NSString * const im_IP_http = @"http://imhttp.mintcode.com/launchr";
static NSString * const im_IP_ws   = @"ws://imws.mintcode.com:20000";
static NSString * const im_IP_test = @"192.168.1.249";

#elif HAIGUANMODE // 海关
static NSString * const im_IP_http = @"http://60.191.36.201:20001/launchr";
static NSString * const im_IP_ws   = @"ws://60.191.36.201:20000";
static NSString * const im_IP_test = @"192.168.1.249";

#elif MT        // 自己公司
static NSString * const im_IP_http = @"http://imhttp.mintcode.com:20001/launchr";
static NSString * const im_IP_ws   = @"ws://imws.mintcode.com:20000";
static NSString * const im_IP_test = @"192.168.1.249";

#elif XIHUMODE  // 西湖
static NSString * const im_IP_http = @"http://xhqimhttp.mintcode.com/launchr";
static NSString * const im_IP_ws   = @"ws://xhqimws.mintcode.com";
static NSString * const im_IP_test = @"192.168.1.249";

#else           // 内网
static NSString * const im_IP_http = @"http://192.168.1.251:20001/launchr";
static NSString * const im_IP_ws   = @"ws://192.168.1.251:20000";
// 测试wss
//static NSString * const im_IP_ws   = @"wss://192.168.1.251:20002";
static NSString * const im_IP_test = @"192.168.1.249";

#endif

static NSString * const im_appName = @"launchr";
static NSString * const im_appToken = @"verify-code";

#endif /* ChatIMConfigure_h */
