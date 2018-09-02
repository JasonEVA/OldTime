//
//  CreateRelationGroupRequest.h
//  MintcodeIM
//
//  Created by williamzhang on 16/5/3.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  创建好友分组

#import "IMBaseBlockRequest.h"
#import "MessageRelationGroupModel.h"

@interface CreateRelationGroupResponse : IMBaseResponse

@property (nonatomic, strong) MessageRelationGroupModel *groupModel;

@end

@interface CreateRelationGroupRequest : IMBaseBlockRequest

+ (void)createGroupName:(NSString *)groupName completion:(IMBaseResponseCompletion)completion;

@end
