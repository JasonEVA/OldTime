//
//  MessageMergeForwardRequest.h
//  MintcodeIM
//
//  Created by williamzhang on 16/3/28.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  消息转发request

#import "IMBaseBlockRequest.h"

@class MessageBaseModel;

@interface MessageMergeForwardRequest : IMBaseBlockRequest

/**
 *  消息转发
 *
 *  @param messages     消息数组
 *  @param title        标题 （xx的聊天记录）
 *  @param toUsers      待发送对象
 *  @param isMerge      合并还是逐条发送（暂时接口没有这个，之后加）
 *  @param completion   委托完成回调
 */
+ (void)forwardMessages:(NSArray <MessageBaseModel *>*)messages
                  title:(NSString *)title
                toUsers:(NSArray *)toUsers
                isMerge:(BOOL)isMerge
             completion:(IMBaseResponseCompletion)completion;

@end
