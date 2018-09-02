//
//  SocketManager.m
//  Titans
//
//  Created by Remon Lv on 14-9-10.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "SocketManager.h"
#import "MsgDefine.h"
#import "MsgUserInfoMgr.h"
#import "NSData+AES.h"
#import "SRWebSocket.h"
#import "IMConfigure.h"

@interface SocketManager()<SRWebSocketDelegate>
{
    SRWebSocket *_webSocket;        // socket
    BOOL _isOpen;                   // 标记socket已经打开
}

@end
@implementation SocketManager


// 单例
+ (SocketManager *)share
{
    static SocketManager *socketManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socketManager = [[SocketManager alloc] init];
    });
    return socketManager;

}

- (void)destroyMyself
{
    // 关闭socket
    [self closeSocket];
    [_webSocket setDelegate:nil];
    _webSocket = nil;
    [self setDelegate:nil];
}

// 与服务器握手
- (instancetype)init
{
    if (self = [super init])
    {
        // 注册监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(destroyMyself) name:MTWebsocketLogoutNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTWebsocketLogoutNotification object:nil];
}

// 创建新的webSocket
- (void)openSocket
{
    // 连接socket
    if (_webSocket != nil)
    {
        [_webSocket setDelegate:nil];
        _webSocket = nil;
    }

    // 老版本使用cookie header加密，现在都使用ssl加密
//    NSHTTPCookie *protocol = [NSHTTPCookie cookieWithProperties:@{@"Security":@"aes"}];
    NSArray *protocols = nil; // @[protocol];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[MsgUserInfoMgr share] getWsIp]]];
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:request
                                               protocols:protocols
                          allowsUntrustedSSLCertificates:YES];
    _webSocket.delegate = self;
    [_webSocket open];
}

// 关闭socket
- (void)closeSocket
{
    [_webSocket close];
    _isOpen = NO;
}
// 发送消息
- (void)sendMessage:(NSString *)string
{
    if (_isOpen)
    {
        NSString *sendMessage = @"";
        if ([[MsgUserInfoMgr share] getEncryptKey].length > 0)
        {
            // 加密-Andrew
            sendMessage = [NSData AES256EncryptWithContent:string key:[[MsgUserInfoMgr share] getEncryptKey]];
        }
        else
        {
            sendMessage = string;
        }
        [_webSocket send:sendMessage];
    }
}

- (void)sendPing:(NSString *)pingString {
    if (!_isOpen) {
        return;
    }
    
    NSString *encryptKey = [[MsgUserInfoMgr share] getEncryptKey];
    
    if ([encryptKey length] > 0) {
        // 加密
        pingString = [NSData AES256EncryptWithContent:pingString key:encryptKey];
    }
    
    [_webSocket sendPing:[pingString dataUsingEncoding:NSUTF8StringEncoding]];
}

/** 判断webSocket是否打开
  */
- (BOOL)getSocketIsOpened
{
    return _isOpen;
}

#pragma mark - SRWebSocketDelegate
// 握手成功
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    // 标记打开
    _isOpen = YES;
    
    PRINT_STRING(@"SocketDidOpen!");
    
    // 处理GUID
    [self handleGuidIfNeedFromWebSocket:webSocket];
    
    // 告诉委托方可以发送消息了
    if ([self.delegate respondsToSelector:@selector(SocketManagerCallBack_webSocketDidOpen)])
    {
        [self.delegate SocketManagerCallBack_webSocketDidOpen];
    }
}

// 握手失败
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    // 标记未打开
    _isOpen = NO;
    _webSocket = nil;
    
    NSString *strTmp = [NSString stringWithFormat:@"SocketDidFailWithError:%@",[error description]];
    PRINT_STRING(strTmp);
    
    // 告诉委托方，socket异常，该处理了
    if ([self.delegate respondsToSelector:@selector(SocketManagerCallBack_webSocketDidFailed)])
    {
        [self.delegate SocketManagerCallBack_webSocketDidFailed];
    }
}

// 关闭
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{    
    // 标记未打开
    _isOpen = NO;
    _webSocket = nil;
    
    NSString *strTmp = [NSString stringWithFormat:@"SocketDidCloseWithCode:%ld Reason:%@",(long)code,reason];
    PRINT_STRING(strTmp);
}

/// 收到pong
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {

    // NOOP  TODO 解析LOGINKEEP
    NSString *str = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    if (str == nil && pongPayload) {
        [self closeSocket];
        return;
    }
    
    [self webSocket:webSocket didReceiveMessage:str];
}

// 收到服务器的消息
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSString *receiveMessage = @"";
    if ([[MsgUserInfoMgr share] getEncryptKey].length > 0)
    {
        // 解密-Andrew
        receiveMessage = [NSData AES256DecryptWithContent:(NSString *)message key:[[MsgUserInfoMgr share] getEncryptKey]];
    }
    else
    {
        receiveMessage = message;
    }
    // 将数据委托出去
    if ([self.delegate respondsToSelector:@selector(SocketManagerCallBack_didReceiveMessage:)])
    {
        [self.delegate SocketManagerCallBack_didReceiveMessage:receiveMessage];
    }
}

// 获得websocket返回头里的加解密guid
/*
加密连接使用方式
1、如果需要加密 握手的时候 加一行信息：Security: aes\r\n
2、然后从返回的 Security-Guid 中 取得 [guid]格式的 的随机码 如：96ec86d2-9552-4355-b642-65fdd2c779f0
3、然后把 96ec86d2-9552-4355-b642-65fdd2c779f0 先获取gtf8格式的byte, 后转成base64格式,取前16位作为加解密的key 如.net代码：string aesKey=Convert.ToBase64String(Encoding.UTF8.GetBytes(guid), Base64FormattingOptions.None).Substring(0,16);
4、把消息'json'格式的内容用aes加密,而不是所有消息体， key是 aesKey 向量是 { 0xC, 1, 0xB, 3, 0x5B, 0xD, 5, 4, 0xF, 7, 9, 0x17, 1, 0xA, 6, 8 }
5、得到消息的原有json内容用 des 解密
 */
- (void)handleGuidIfNeedFromWebSocket:(SRWebSocket *)webSocket
{
    // 获得加密GUID
    NSString *guid = CFBridgingRelease(CFHTTPMessageCopyHeaderFieldValue(webSocket.receivedHTTPHeaders, CFSTR("Security-Guid")));
    if ([guid length] > 0) {
        NSString *encryptKey = [self formateEncryptKeyWithGuid:guid];
        [[MsgUserInfoMgr share] saveEncyptKey:encryptKey];
    }
}

/* 格式化加解密guid为key,
然后把 96ec86d2-9552-4355-b642-65fdd2c779f0 先获取gtf8格式的byte, 后转成base64格式,取前16位作为加解密的key 如.net代码：string aesKey=Convert.ToBase64String(Encoding.UTF8.GetBytes(guid), Base64FormattingOptions.None).Substring(0,16);
 */
- (NSString *)formateEncryptKeyWithGuid:(NSString *)encryptGuid
{
    NSData *data = [encryptGuid dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *fullKey = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"解密Key:%@",fullKey);
    NSString *decodeKey = [fullKey substringWithRange:NSMakeRange(0, 16)];
    NSLog(@"解密Key:%@",decodeKey);
    if (decodeKey.length > 0)
    {
        return decodeKey;
    }
    return @"";
}

@end
