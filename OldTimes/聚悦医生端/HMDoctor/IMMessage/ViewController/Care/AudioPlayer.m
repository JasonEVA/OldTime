//
//  AudioPlayer.m
//  HealthMgrDoctor
//
//  Created by lkl on 16/1/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AudioPlayer.h"

static AudioPlayer *defaultAudioPlayer = nil;

@interface AudioPlayer()<AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;
}
@end

@implementation AudioPlayer

+ (id) shareInstance
{
    if (!defaultAudioPlayer)
    {
        defaultAudioPlayer = [[AudioPlayer alloc]init];
    }
    
    return defaultAudioPlayer;
}

- (void) playAudioPath:(NSString*) path
{
    if (audioPlayer && [audioPlayer isPlaying])
    {
        [audioPlayer stop];
    }
    if (audioPlayer)
    {
        audioPlayer = nil;
    }
    
    NSError *error;
    NSURL* audioUrl = [NSURL fileURLWithPath:path];
    audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:audioUrl error:&error];
    
    if (error)
    {
        NSLog(@"error:%@",[error description]);
        return;
    }
    
    [audioPlayer setDelegate:self];
    audioPlayer.numberOfLoops = 0;
    
    BOOL isPlay = [audioPlayer play];
    NSLog(@"play success %d", isPlay);
}

- (void) playAudioData:(NSData*) data callBack:(playStop)block
{
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];

    NSError* error;
    [audioSession setCategory:AVAudioSessionCategoryPlayback error: &error];
    [audioSession setActive:YES error: &error];
    
    if (audioPlayer && [audioPlayer isPlaying])
    {
        [audioPlayer stop];
    }
    if (audioPlayer)
    {
        audioPlayer = nil;
    }

    audioPlayer=[[AVAudioPlayer alloc]initWithData:data error:&error];
    [audioPlayer setVolume:1];
    if (error)
    {
        NSLog(@"error:%@",[error description]);
        return;
    }
    
    [audioPlayer setDelegate:self];
    audioPlayer.numberOfLoops = 0;

    BOOL isPlay = [audioPlayer play];
    NSLog(@"播放状态 %d", isPlay);
    [self setBlock:block];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [audioPlayer stop];
    audioPlayer = nil;
    if (_block) {
        _block();
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    
    NSLog(@"解码错误！");
    
    [audioPlayer stop];
    audioPlayer = nil;
    if (_block) {
        _block();
    }
    
}

/* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player NS_DEPRECATED_IOS(2_2, 8_0)
{
    NSLog(@"audioPlayerBeginInterruption");
}

/* audioPlayerEndInterruption:withOptions: is called when the audio session interruption has ended and this player had been interrupted while playing. */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags NS_DEPRECATED_IOS(6_0, 8_0)
{
    NSLog(@"audioPlayerEndInterruption  111");
}



- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags NS_DEPRECATED_IOS(4_0, 6_0)
{
    NSLog(@"audioPlayerEndInterruption 222");
}

/* audioPlayerEndInterruption: is called when the preferred method, audioPlayerEndInterruption:withFlags:, is not implemented. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player NS_DEPRECATED_IOS(2_2, 6_0)
{
    NSLog(@"audioPlayerEndInterruption 3333");
}


@end
