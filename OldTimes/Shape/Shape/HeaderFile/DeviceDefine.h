//
//  DeviceDefine.h
//  Shape
//
//  Created by Andrew Shen on 15/10/14.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#ifndef DeviceDefine_h
#define DeviceDefine_h

// UUID
#define IOS_DIVICE_UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]

// TYPE
#define IOS_DIVICE_TYPE [[UIDevice currentDevice] model]

// SYSTEM_VERSION
#define IOS_SYSTEM_VER [[UIDevice currentDevice] systemVersion]

// SYSTEM_NAME
//#define IOS_SYSTEM_NAME [[UIDevice currentDevice] systemName]
#define IOS_SYSTEM_NAME @"iOS"


#endif /* DeviceDefine_h */
