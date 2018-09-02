//
//  GetHistoryMessageRequest.h
//  launcher
//
//  Created by Lars Chen on 15/10/30.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  打开聊天框获取历史消息

#import "IMBaseBlockRequest.h"

@interface GetHistoryMessageResponse : IMBaseResponse

/// 最老的在上面
@property (nonatomic, strong) NSMutableArray *arrMsgBaseModel;

@end

@interface GetHistoryMessageRequest : IMBaseRequest

@property (nonatomic, strong) NSString *strUid;
@property (nonatomic) NSInteger limit;      // 返回总数 最少拿3条
@property (nonatomic) long long endTimestamp;

@end

@interface GetHistoryMessageBlockRequest : IMBaseBlockRequest

+ (void)sessionName:(NSString *)sessionName MessageCount:(NSInteger)messageCount endTimestamp:(long long)endTimestamp completion:(IMBaseResponseCompletion)completion;

@end