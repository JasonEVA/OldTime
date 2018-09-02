//
//  MessageVoipModel.h
//  MintcodeIM
//
//  Created by williamzhang on 16/5/5.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  消息实时语音Model

#import <Foundation/Foundation.h>

/**
 *  实时语音状态
 */
typedef NS_ENUM(NSUInteger, MTVoipState) {
    /// 发送方取消视频
    MTVoipStateVideoCancel = 1,
    /// 接收方拒绝视频
    MTVoipStateVideoRefuse,
    /// 完成视频通话
    MTVoipStateVideoFinish,
    
    /// 发送发取消语音
    MTVoipStateAudioCancel,
    /// 接收方拒绝语音
    MTVoipStateAudioRefuse,
    /// 完成语音通话
    MTVoipStateAudioFinish
};

@interface MessageVoipModel : NSObject

@property (nonatomic, assign) NSInteger videoLength;
@property (nonatomic, assign) NSInteger audioLength;

@property (nonatomic, strong) NSString *fromUid;
@property (nonatomic, strong) NSString *toUid;

@property (nonatomic, readonly) MTVoipState state;

@end
