//
//  MessageSqlVersionManager.h
//  launcher
//
//  Created by williamzhang on 16/3/4.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  消息数据库版本控制

#import <Foundation/Foundation.h>

extern uint32_t const IM_SQL_VERSION;

@class FMDatabase;

@interface MessageSqlVersionManager : NSObject

/**
 *  如果配置需要更新则更新至最新版本
 *
 *  @param database 待修改的数据库
 */
+ (void)versionUpdateIfNeedInDatabase:(FMDatabase *)database;

@end
