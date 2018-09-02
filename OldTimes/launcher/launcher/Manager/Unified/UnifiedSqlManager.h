//
//  UnifiedSqlManager.h
//  Titans
//
//  Created by Andrew Shen on 14-8-30.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  全局数据库管理

#import <Foundation/Foundation.h>

@class ContactPersonDetailInformationModel;

@interface UnifiedSqlManager : NSObject

/// 数据库已经失去作用
+ (UnifiedSqlManager *)share DEPRECATED_ATTRIBUTE;

/**
 *  获取所有联系人 (ContactPersonDetailInfomationModel) For Launchr
 *
 *  @return 联系人数组
 */
- (NSArray *)findAllContactPeople;
/**
 *  查找联系人详情 For Launchr
 *
 *  @param userName 联系人用户名（账号）
 *
 *  @return 0.0 or nil
 */
- (ContactPersonDetailInformationModel *)findPersonWithUserName:(NSString *)userName;
/**
 *  查找联系人详情 For Launchr
 *
 *  @param showId 联系人关键字
 *
 *  @return 联系人 or nil
 */
- (ContactPersonDetailInformationModel *)findPersonWithShowId:(NSString *)showId;
/**
 *  批量插入联系人 （单独操作，不与其他表产生关联）by William For Launchr
 *
 *  @param array 联系人信息（ContactPersonDetailInformationModel）
 *
 *  @return 是否成功
 */
- (BOOL)insertContactDetail:(NSArray *)array;
/**
 *  删除所有联系人 For Launchr
 */
- (void)deleteAllContact;
/**
 *  删除所有联系人
 *
 *  @param completion 删除完成后
 */
- (void)deleteAllContactCompletion:(void (^)())completion;

@end
