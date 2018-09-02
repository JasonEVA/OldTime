//
//  ATAudioSessionPlayUtility.m
//  HMClient
//
//  Created by Andrew Shen on 16/5/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ATAudioSessionPlayUtility.h"
#import <AVFoundation/AVFoundation.h>

static SystemSoundID kCustomSoundID = 0;

void VibratePlayComplete(SystemSoundID soundId, void* clientData);

@interface ATAudioSessionPlayUtility()
@property (nonatomic)  BOOL  playing; // <##>
@property (nonatomic, copy)  NSString  *voicePath; // <##>
@end
@implementation ATAudioSessionPlayUtility

+ (ATAudioSessionPlayUtility *)sharedInstance {
    static ATAudioSessionPlayUtility *sharedInstance = nil;;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ATAudioSessionPlayUtility alloc] init];
    });
    return sharedInstance;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSError *error;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
        [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeDefault error:&error];
        [self errorWithEnableAudioPortSpeaker:YES];
        if (error) {
            NSLog(@"-------------->设置音频出错：%@",error.localizedDescription);
        }
        
    }
    return self;
}

/**
 *  根据路径播放声音
 *
 *  @param path 音频路径
 */
- (void)playVoiceWithPath:(NSString *)path {
    if (!self.playing) {
        [self beginPlayVoice:path];
    }
    else {
        if (![path isEqualToString:self.voicePath]) {
            [self endPlayVoice];
            [self beginPlayVoice:path];
        }
        else {
            [self endPlayVoice];
        }
    }
}

- (void)stopAllVoiceGreeting {
    [self endPlayVoice];
}

#pragma mark - Private Method

- (void)beginPlayVoice:(NSString *)path {
    self.voicePath = path;
    if (path) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)([NSURL fileURLWithPath:path]), &kCustomSoundID);
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        AudioServicesAddSystemSoundCompletion(kCustomSoundID, NULL, NULL, VibratePlayComplete, (__bridge void*)self);
        AudioServicesPlaySystemSound(kCustomSoundID);
        self.playing = YES;
    }
    else {
        NSLog(@"-------------->资源错误");
    }

}

- (void)endPlayVoice {
    AudioServicesRemoveSystemSoundCompletion(kCustomSoundID);
    AudioServicesDisposeSystemSoundID(kCustomSoundID);
    self.playing = NO;
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

// 是否外放
- (NSError *)errorWithEnableAudioPortSpeaker:(BOOL)enableSpeaker {
    
    NSError *error;
    
    AVAudioSessionPortOverride override = enableSpeaker ? AVAudioSessionPortOverrideSpeaker : AVAudioSessionPortOverrideNone;
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:override error:&error];
    
    if (error) {
        NSLog(@"-------------->切换麦克风失败:%@",error.localizedDescription);
    }
    return error;
    
}

@end

// 播放回调
void VibratePlayComplete(SystemSoundID soundId, void* clientData)
{
    AudioServicesRemoveSystemSoundCompletion(kCustomSoundID);
    AudioServicesDisposeSystemSoundID(kCustomSoundID);
    [ATAudioSessionPlayUtility sharedInstance].playing = NO;
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}