//
//  DeviceDefine.h
//  VerusKnight
//
//  Created by William Zhang on 15/1/5.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#ifndef VerusKnight_DeviceDefine_h
#define VerusKnight_DeviceDefine_h

#pragma mark -- Device
// 设备系统版本 > 7.0
#define IOS_VERSION_7_OR_ABOVE  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS_VERSION_8_OR_ABOVE  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOS_VERSION_9_OR_ABOVE  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IOS_VERSION_10_OR_ABOVE  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

// 判断设备为哪种型号
#define IOS_DEVICE_6        ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IOS_DEVICE_5        ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IOS_DEVICE_4        ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IOS_DEVICE_6Plus    ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )

#define IOS_SCREEN_WIDTH    ([ [ UIScreen mainScreen ] bounds ].size.width)
#define IOS_SCREEN_HEIGHT   ([ [ UIScreen mainScreen ] bounds ].size.height)

// UUID
#define IOS_DEVICE_UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]

// TYPE
#define IOS_DEVICE_TYPE [[UIDevice currentDevice] model]

// SYSTEM_VERSION
#define IOS_SYSTEM_VER [[UIDevice currentDevice] systemVersion]

// SYSTEM_NAME
//#define IOS_SYSTEM_NAME [[UIDevice currentDevice] systemName]
#define IOS_SYSTEM_NAME @"iOS"

#define APP_STATUSBAR_HEIGHT                (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))

// 高度栏
#define Y_STATUSBAR_IOS7 64
#define Y_STATUSBAR_IOS6 44

#endif
