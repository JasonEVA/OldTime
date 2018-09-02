//
//  HMPhoneNumberUtil.h
//  HMClient
//
//  Created by jasonwang on 2017/2/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//  判断手机号工具类

#import <Foundation/Foundation.h>

@interface HMPhoneNumberUtil : NSObject

/**
 *  // 验证是固话或者手机号
 *
 *  @param mobileNum 手机号
 *
 *  @return 是否
 */
+ (BOOL)isMobilePhoneOrtelePhone:(NSString *)mobileNum;

@end
