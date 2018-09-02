//
//  RecallMessageRequest.h
//  launcher
//
//  Created by williamzhang on 16/1/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  回撤消息Request

#import "IMBaseBlockRequest.h"

@class MessageBaseModel;

@interface RecallMessageRequest : IMBaseBlockRequest

+ (void)recallMessage:(MessageBaseModel *)message completion:(IMBaseResponseCompletion)completion;

@end
