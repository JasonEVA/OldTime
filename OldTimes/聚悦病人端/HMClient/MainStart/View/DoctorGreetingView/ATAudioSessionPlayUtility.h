//
//  ATAudioSessionPlayUtility.h
//  HMClient
//
//  Created by Andrew Shen on 16/5/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//  声音播放工具类

#import <Foundation/Foundation.h>

@interface ATAudioSessionPlayUtility : NSObject

+ (ATAudioSessionPlayUtility *)sharedInstance;

/**
 *  根据路径播放声音
 *
 *  @param path 音频路径
 */
- (void)playVoiceWithPath:(NSString *)path;

/**
 *  停止所有语音问候
 */
- (void)stopAllVoiceGreeting;
@end
