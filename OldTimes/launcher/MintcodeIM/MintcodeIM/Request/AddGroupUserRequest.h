//
//  AddGroupUserRequest.h
//  launcher
//
//  Created by Andrew Shen on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  增加群成员

#import "IMBaseBlockRequest.h"

@interface AddGroupUserRequest : IMBaseBlockRequest

/// 增加群成员
+ (void)sessionName:(NSString *)sessionName addUserIds:(NSArray *)userIds completion:(IMBaseResponseCompletion)completion;

@end
