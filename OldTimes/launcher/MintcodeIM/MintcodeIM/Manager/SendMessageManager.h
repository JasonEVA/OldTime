//
//  SendMessageManager.h
//  launcher
//
//  Created by Lars Chen on 16/1/29.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  发送消息统一管理

#import <Foundation/Foundation.h>

@class MessageBaseModel;

@interface SendMessageManager : NSObject

@property (nonatomic, readonly) NSMutableDictionary *dictFirstHistoryRequest; // 聊天进入拉历史去重数组

+ (SendMessageManager *)share;

/**
 *  发送消息
 *
 *  @param message      消息model
 *  @param socketString 消息model对应的socket格式(JSONString)
 */
- (void)sendMessage:(MessageBaseModel *)message socketString:(NSString *)socketString;

/// 发送消息成功
- (void)sendMessageSuccess;

/// 重新开始,有必要的话
- (void)reStart;

@end
