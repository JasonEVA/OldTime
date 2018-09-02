//
//  CreateGroupRequest.h
//  launcher
//
//  Created by Lars Chen on 15/9/18.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  创建群组

#import "IMBaseBlockRequest.h"

@interface CreateGroupResponse : IMBaseResponse

@property (nonatomic, strong) NSString *groupUid;

@end

@interface CreateGroupRequest : IMBaseBlockRequest

+ (void)createWithUserIds:(NSArray *)userIds tag:(NSString *)tag completion:(IMBaseResponseCompletion)completion;

@end
