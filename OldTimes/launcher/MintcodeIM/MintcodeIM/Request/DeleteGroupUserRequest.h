//
//  DeleteGroupUserRequest.h
//  launcher
//
//  Created by Andrew Shen on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  删除成员(包括自己)

#import "IMBaseBlockRequest.h"

@interface DeleteGroupUserRequest : IMBaseBlockRequest

+ (void)deleteGroupSessionName:(NSString *)sessionName memeberId:(NSString *)memeberId completion:(IMBaseResponseCompletion)completion;

@end
