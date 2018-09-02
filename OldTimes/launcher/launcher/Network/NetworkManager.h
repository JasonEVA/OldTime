//
//  NetworkManager.h
//  launcher
//
//  Created by williamzhang on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  网络管理manager

#import <UIKit/UIKit.h>

@interface NetworkManager : NSObject

/**
 *  进行网络进程时调用
 */
+ (void)addNetworkProgress;
/**
 *  网络进程结束时调用
 */
+ (void)removeNetworkProgress;

@end
