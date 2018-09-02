//
//  MessageGroupNoDisturbRequest.h
//  launcher
//
//  Created by williamzhang on 15/12/3.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  群聊免打扰设置request

#import "IMBaseBlockRequest.h"

@interface MessageGroupNoDisturbRequest : IMBaseBlockRequest

/** 填入群房间名称 */
+ (void)noDisturbSessionName:(NSString *)sessionName receiveMode:(NSInteger)receiveMode completion:(IMBaseResponseCompletion)completion;

@end
