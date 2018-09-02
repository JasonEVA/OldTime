//
//  SetMessageReadRequest.h
//  launcher
//
//  Created by Lars Chen on 15/9/23.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "IMBaseRequest.h"

@interface SetMessageReadResponse : IMBaseResponse

/// 成功已读信息 [msgId]
@property (nonatomic, readonly) NSArray *readedMessages;

@property (nonatomic, copy) NSString *sessionName;

@end

@interface SetMessageReadRequest : IMBaseRequest

@property (nonatomic, strong) NSArray *arrReadedMessage;

/**
 *  标记已读
 *
 *  @param messages    已读数组（messageBaseModel）
 *  @param seesionName 会话名
 */
- (void)readedMessage:(NSArray *)messages sessionName:(NSString *)sessionName;

@end

