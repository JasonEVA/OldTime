//
//  SocketManager.h
//  Titans
//
//  Created by Remon Lv on 14-9-10.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  Socket管理(单例)

#import <Foundation/Foundation.h>

@protocol SocketManagerDelegate <NSObject>

/// 收到服务器的消息委托
- (void)SocketManagerCallBack_didReceiveMessage:(id)message;
/// 握手成功
- (void)SocketManagerCallBack_webSocketDidOpen;
/// 握手失败
- (void)SocketManagerCallBack_webSocketDidFailed;

@end

@interface SocketManager : NSObject
@property (nonatomic,weak) id <SocketManagerDelegate> delegate;

/// 单例
+ (SocketManager *)share;
//- (void)destroyMyself;

/** 打开socket
 */
- (void)openSocket;

/** 关闭socket
 */
- (void)closeSocket;

/** 发送消息
 */
- (void)sendMessage:(NSString *)string;
/// 发送ping
- (void)sendPing:(NSString *)pingString;

/** 判断webSocket是否打开
 */
- (BOOL)getSocketIsOpened;


@end
