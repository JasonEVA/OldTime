//
//  IpAddressHealper.h
//  HMClient
//
//  Created by Dee on 16/9/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//  帮助获取ip地址

#import <Foundation/Foundation.h>

@interface IpAddressHealper : NSObject


/**
 返回当前设备的IP
 
 @param preferIPv4 是否是Ipv4
 
 @return 返回对应的字符串
 */
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

@end
