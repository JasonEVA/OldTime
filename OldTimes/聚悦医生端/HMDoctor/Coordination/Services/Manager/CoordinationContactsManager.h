//
//  CoordinationContactsManager.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/5/10.
//  Copyright © 2016年 yinquan. All rights reserved.
//  协同联系人管理类

#import <Foundation/Foundation.h>
#import <MintcodeIMKit/MintcodeIMKit.h>

typedef void (^ContactsCompletionHandler)(long groupID, NSArray *contacts);

@interface CoordinationContactsManager : NSObject

+ (CoordinationContactsManager *)sharedManager;

/**
 *  获取联系人分组
 *
 *  @param includeChatGroup 是否包含群
 *  @return 联系人分组数组
 */
- (NSArray *)getContatsGroupingNamesIncludeChatGroup:(BOOL)includeChatGroup;

/**
 *  根据groupID获取群组信息
 *
 *  @param groupID 群ID
 *
 *  @return 群信息
 */
- (MessageRelationGroupModel *)getGroupInfoWithGroupID:(long)groupID;
/**
 *  获取某一分组下的所有好友
 *
 *  @param relationGroupId 分组ID
 *
 *  @return 好友数组
 */
//- (NSArray *)getContactsWithWithRelationGroup:(long)relationGroupId;
- (void)getContactsWithWithRelationGroup:(long)relationGroupId completion:(ContactsCompletionHandler)completion;

// 群组
- (void)getSuperGroupsDataWithCompletion:(ContactsCompletionHandler)completion;

// 讨论组
- (void)getNormalGroupsDataWithCompletion:(ContactsCompletionHandler)completion;

@end
