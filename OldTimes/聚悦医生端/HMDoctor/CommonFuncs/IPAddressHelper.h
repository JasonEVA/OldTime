//
//  IPAddressHelper.h
//  HMDoctor
//
//  Created by Dee on 16/9/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPAddressHelper : NSObject

/**
 返回当前设备的IP
 
 @param preferIPv4 是否是Ipv4
 
 @return 返回对应的字符串
 */
+ (NSString *)getIPAddress:(BOOL)preferIPv4;


@end
