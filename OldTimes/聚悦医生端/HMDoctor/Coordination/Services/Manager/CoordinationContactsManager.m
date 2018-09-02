//
//  CoordinationContactsManager.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/5/10.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CoordinationContactsManager.h"
#import "ContactInfoModel.h"
#import "ChatIMConfigure.h"

@implementation CoordinationContactsManager

+ (CoordinationContactsManager *)sharedManager {
    static CoordinationContactsManager *sharedManageer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManageer = [[CoordinationContactsManager alloc] init];
    });
    return sharedManageer;
}


/**
 *  获取联系人分组
 *
 *  @param includeChatGroup 是否包含群
 *  @return 联系人分组数组
 */
- (NSArray *)getContatsGroupingNamesIncludeChatGroup:(BOOL)includeChatGroup {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[MessageManager share] queryRelationGroups]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"defaultNameFlag != 2"];
    [arr filterUsingPredicate:predicate];
    if (includeChatGroup) {
        MessageRelationGroupModel *model = [MessageRelationGroupModel new];
        model.relationGroupId = -100;
        model.relationGroupName = @"专家组";
        model.isDefault = YES;
        MessageRelationGroupModel *model2 = [MessageRelationGroupModel new];
        model2.relationGroupId = -200;
        model2.relationGroupName = @"工作圈";
        model2.isDefault = YES;
        [arr insertObjects:@[model,model2] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
    }
    return arr;
}

/**
 *  根据groupID获取群组信息
 *
 *  @param groupID 群ID
 *
 *  @return 群信息
 */
- (MessageRelationGroupModel *)getGroupInfoWithGroupID:(long)groupID {
    NSArray *arr = [[MessageManager share] queryRelationGroups];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationGroupId == %ld",groupID];
    NSArray *result = [arr filteredArrayUsingPredicate:predicate];
    if (result) {
        return result.firstObject;
    }
    return nil;
}

/**
 *  获取某一分组下的所有好友
 *
 *  @param relationGroupId 分组ID
 *
 *  @return 好友数组
 */
- (void)getContactsWithWithRelationGroup:(long)relationGroupId completion:(ContactsCompletionHandler)completion {
    if (relationGroupId == -100) {
        // 专家组
        [self getSuperGroupsDataWithCompletion:^(long groupID, NSArray *contacts) {
            completion(groupID, contacts);
        }];
    }
    else if (relationGroupId == -200) {
        // 工作圈
        
        [self getNormalGroupsDataWithCompletion:^(long groupID, NSArray *contacts) {
            completion(relationGroupId,contacts);
        }];
    }
    else {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[[MessageManager share] queryRelationInfoWithRelationGroup:relationGroupId]];
        completion(relationGroupId,arr);
    }
}

// 群组
- (void)getSuperGroupsDataWithCompletion:(ContactsCompletionHandler)completion {
    [[MessageManager share] getSuperGroupListFromChache:NO completion:^(BOOL success, NSArray<SuperGroupListModel *> *modelArray) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tag != %@",im_doctorPatientGroupTag];
        NSArray *arraySuperGroup = [modelArray filteredArrayUsingPredicate:predicate];
        completion(-100 ,arraySuperGroup);
    }];
}

// 讨论组
- (void)getNormalGroupsDataWithCompletion:(ContactsCompletionHandler)completion {
    [[MessageManager share] loadGroupListFromCache:NO completion:^(NSArray<UserProfileModel *> *groupList, BOOL success) {
        completion(-200, groupList);
    }];
}

@end
