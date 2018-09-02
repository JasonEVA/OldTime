//
//  GetUnreadSessionRequest.h
//  launcher
//
//  Created by Lars Chen on 15/10/30.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  获取聊天会话列表

#import "IMBaseBlockRequest.h"

/// 默认拉取的数量
extern NSInteger unReadSessionGetCount;

@interface GetUnreadSessionResponse : IMBaseResponse

/// 待新增的contactModel
@property (nonatomic, strong) NSMutableArray *arrContactModel;
/// 待删除的contactModel._target
@property (nonatomic, strong) NSArray *deleteContactModel;
/// 服务器当前时间戳
@property (nonatomic, assign) long long maxMsgId;

@end

@interface GetUnreadSessionBlockRequest : IMBaseBlockRequest

+ (void)getSessionCompletion:(void (^)(GetUnreadSessionResponse *response, BOOL success))completion;

@end