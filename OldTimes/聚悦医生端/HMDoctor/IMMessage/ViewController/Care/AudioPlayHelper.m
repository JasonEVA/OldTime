//
//  AudionPlayHelper.m
//  HMClient
//
//  Created by lkl on 16/6/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AudioPlayHelper.h"

static AudioPlayHelper* defaultAudioPlayerHelper = nil;

@interface AudioPlayHelper ()
<AVAudioPlayerDelegate>
{
    AVAudioPlayer* _player;
}
@end

@implementation AudioPlayHelper

+ (id) shareInstance
{
    if (!defaultAudioPlayerHelper)
    {
        defaultAudioPlayerHelper = [[AudioPlayHelper alloc]init];
    }
   
    return defaultAudioPlayerHelper;
}

- (BOOL)isPlaying {
    return _player.playing;
}

- (void) playAudioPath:(NSString*) path
{
    if (_player && [_player isPlaying])
    {
        [_player stop];
    }
    if (_player)
    {
        _player = nil;
    }
   
    NSError *error;
    NSURL* audioUrl = [NSURL fileURLWithPath:path];
    _player=[[AVAudioPlayer alloc]initWithContentsOfURL:audioUrl error:&error];
    
    if (error)
    {
        NSLog(@"error:%@",[error description]);
        return;
    }

    [_player setDelegate:self];
    //audioPlayer.volume=1;
    _player.numberOfLoops = 0;
    
    
    //准备播放
    //BOOL isPrepare = [audioPlayer prepareToPlay];
    //NSLog(@"isPrepare url %@ success %d", url.absoluteString, isPrepare);
    
    //[self performSelector:@selector(playAudio) withObject:nil afterDelay:1.0];
    BOOL isPlay = [_player play];
    NSLog(@"play success %d", isPlay);
}

- (void) playAudioData:(NSData*) data callBack:(playStop)block
{
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    //Setup the audioSession for playback and record.
    //We could just use record and then switch it to playback leter, but
    //since we are going to do both lets set it up once.
    NSError* error;
    [audioSession setCategory:AVAudioSessionCategoryPlayback error: &error];
    //Activate the session
    [audioSession setActive:YES error: &error];
    
    if (_player && [_player isPlaying])
    {
        [_player stop];
    }
    if (_player)
    {
        _player = nil;
    }
    
    //NSError *error;
    //NSURL* audioUrl = [NSURL fileURLWithPath:path];
    _player=[[AVAudioPlayer alloc]initWithData:data error:&error];
    [_player setVolume:1];
    if (error)
    {
        NSLog(@"error:%@",[error description]);
        return;
    }
    
    [_player setDelegate:self];
    //audioPlayer.volume=1;
    _player.numberOfLoops = 0;
    
    
    //准备播放
    //BOOL isPrepare = [audioPlayer prepareToPlay];
    //NSLog(@"isPrepare url %@ success %d", url.absoluteString, isPrepare);
    
    //[self performSelector:@selector(playAudio) withObject:nil afterDelay:1.0];
    BOOL isPlay = [_player play];
    NSLog(@"play success %d", isPlay);
    [self setBlock:block];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [_player stop];
    _player = nil;
    if (_block) {
        _block();
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    
    NSLog(@"解码错误！");
    
    [_player stop];
    _player = nil;
    if (_block) {
        _block();
    }
    
}

- (void)stopPlay {
    if (!_player || ![_player isPlaying]) {
        return;
    }
    [_player stop];
    _player = nil;
}

@end
