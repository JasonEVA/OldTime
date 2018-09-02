//
//  AudioRecord.m
//  HMDoctor
//
//  Created by lkl on 16/6/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AudioRecord.h"
#import <AVFoundation/AVFoundation.h>
#import "CareVoiceRecordVolumeView.h"

@interface AudioRecord ()
<AVAudioRecorderDelegate>
{
    AVAudioSession* audioSession;
    AVAudioRecorder* audioRecorder;   //录制对象
    
    NSTimer *recordvolumetimer;
    CareVoiceRecordVolumeView *audiovolumeview;
    NSDate *startTime;
}


@end

@implementation AudioRecord

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        audioSession = [AVAudioSession sharedInstance];
    }
    return self;
}

- (NSString*) cacheDir
{
    NSArray *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *cachePath = [cache objectAtIndex:0] ;
    return cachePath;
}

- (void) startRecord
{
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    startTime = [NSDate date];
    
    NSDictionary *settings = @{AVFormatIDKey: @(kAudioFormatLinearPCM),
                               AVSampleRateKey: @8000.00f,
                               AVNumberOfChannelsKey: @1,
                               AVLinearPCMBitDepthKey: @16,
                               AVLinearPCMIsNonInterleaved: @NO,
                               AVLinearPCMIsFloatKey: @NO,
                               AVLinearPCMIsBigEndianKey: @NO};
    
    //保存文件
    NSString* tmpFilePath = [[self cacheDir] stringByAppendingPathComponent:@"audiorecord.wav"];
    NSURL* urlFile = [NSURL fileURLWithPath:tmpFilePath];
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:urlFile settings:settings error:nil];
    
    [audioRecorder setDelegate:self];
    audioRecorder.meteringEnabled=YES;
    [audioRecorder prepareToRecord];
    
    [audioRecorder record];
    
    //开始监听录音音量
    if (recordvolumetimer)
    {
        [recordvolumetimer invalidate];
        recordvolumetimer = nil;
    }
    recordvolumetimer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
}

- (void) stopRecord
{
    NSDate* endDate = [NSDate date];
    NSTimeInterval tiDuration = [endDate timeIntervalSinceDate:startTime];
    self.duration = (int) tiDuration;
    
    audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:NO error:nil];
    
    [audioRecorder stop];
    
    audioRecorder = nil;
    if (recordvolumetimer)
    {
        [recordvolumetimer invalidate];
        recordvolumetimer = nil;
    }
    
}


-(void)audioPowerChange
{
    [audioRecorder updateMeters];//更新测量值
    //float power= [audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    //NSLog(@"audioPowerChange volume = %f", power);
    
    //CGFloat progress=(1.0/160.0)*(power+160.0) * 100;
    //[self.audioPower setProgress:progress];

}



@end

