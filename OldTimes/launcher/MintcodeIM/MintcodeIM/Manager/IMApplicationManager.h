//
//  IMApplicationManager.h
//  launcher
//
//  Created by williamzhang on 16/3/4.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMApplicationManager : NSObject

+ (void)setApplicationConfig:(NSDictionary *)dictionary;
/**
 *  通过application Uid获取类型
 *
 *  @param uid PWXXXjQLLjFEZXLe@APP
 *
 *  @return uid对应的类型(无则返回－1)
 */
+ (NSInteger)applicationTypeFromUid:(NSString *)uid;

/**
 *  通过application type获取类型
 *
 *  @param type 自定义好的数值 10001
 *
 *  @return uid(无则返回nil)
 */
+ (NSString *)applicaionUidFromType:(NSInteger)type;

/// 所有app的Uid集合
+ (NSArray *)applicaitonUids;

@end
