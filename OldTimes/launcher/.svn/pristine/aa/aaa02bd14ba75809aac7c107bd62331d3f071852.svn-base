//
//  MessageBaseModel+Private.h
//  MintcodeIM
//
//  Created by williamzhang on 16/3/24.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <MintcodeIM/MintcodeIM.h>

@interface MessageBaseModel (Private)

/// 历史消息初始化
- (instancetype)initWithDict:(NSDictionary *)dict;

/// 为发送消息做初始化
- (instancetype)initWithMsgId:(long long)msgId From:(NSString *)fromName To:(NSString *)toName Info:(NSString *)info Content:(NSString *)content MemberList:(NSString *)memberList Cid:(long long)cid CreateDate:(long long)createDate Type:(Msg_type)type;

@end
