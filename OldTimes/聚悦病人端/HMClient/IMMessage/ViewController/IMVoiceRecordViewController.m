//
//  IMVoiceRecordViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/26.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "IMVoiceRecordViewController.h"
#import "IMVoiceRecordVolumeView.h"
#import <AVFoundation/AVFoundation.h>
#import <MintcodeIMKit/MintcodeIMKit.h>

@interface IMVoiceRecordViewController ()
<AVAudioRecorderDelegate>
{
    NSString* targetId;
    IMVoiceRecordVolumeView* volumeView;
    AVAudioSession *_audioSession;
    AVAudioRecorder* audioRecorder;
    NSTimer* recordvolumetimer;
    NSDate* startTime;
    NSString* wavPath;
}
@end

@implementation IMVoiceRecordViewController

- (void) dealloc
{
    if (recordvolumetimer)
    {
        [recordvolumetimer invalidate];
        recordvolumetimer = nil;
    }
}

- (id) initWithTargetId:(NSString*) tid
{
    self = [super init];
    if (self)
    {
        targetId = tid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2]];
    
    volumeView = [[IMVoiceRecordVolumeView alloc]init];
    [self.view addSubview:volumeView];
    [volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(@110);
        make.height.mas_equalTo(@125);
    }];
    _audioSession = [AVAudioSession sharedInstance];
    
    [self startRecordVoice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) startRecordVoice
{
    //开始录音
    NSError * error = nil;
    
    [_audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if(error)
    {
        return;
    }
    
    [_audioSession setActive:YES error:&error];
    if(error)
    {
        return;
    }
    
    NSMutableDictionary * recordSetting = [NSMutableDictionary dictionary];
    
    //设置录音格式  AVFormatIDKey == WAV
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:8000] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMedium] forKey:AVEncoderAudioQualityKey];
    
    //然后直接把文件保存成.wav就好了
    
    long long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *strDate = [NSString stringWithFormat:@"%lld",timeStamp];
    
    // 得到路径
    wavPath = [[MsgFilePathMgr share] getMessageDirFilePathWithFileName:strDate extension:extension_wav uid:targetId];
    
    //NSString* tmpFilePath = [[AudioRecordHelper cacheDir] stringByAppendingPathComponent:@"audiorecord.wav"];
    NSURL* urlFile = [NSURL fileURLWithPath:wavPath];
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:urlFile settings:recordSetting error:nil];
    
    [audioRecorder setDelegate:self];
    audioRecorder.meteringEnabled=YES;
    [audioRecorder prepareToRecord];
    startTime = [NSDate date];
    [audioRecorder record];
    
    //开始监听录音音量
    if (recordvolumetimer)
    {
        [recordvolumetimer invalidate];
        recordvolumetimer = nil;
    }
    recordvolumetimer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
}

- (NSString*) stopRecord
{
    [_audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioRecorder stop];
    [_audioSession setActive:NO error:nil];
    
    audioRecorder = nil;
    if (recordvolumetimer)
    {
        [recordvolumetimer invalidate];
        recordvolumetimer = nil;
    }
    
    NSDate* endDate = [NSDate date];
    NSTimeInterval tiDuration = [endDate timeIntervalSinceDate:startTime];
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if (tiDuration < 1.0)
    {
        //太短了，重新录音
        return nil;
    }
    return wavPath;
}

- (void) audioPowerChange
{
    //更新测量值
    [audioRecorder updateMeters];
    ////取得第一个通道的音频，注意音频强度范围时-160到0
    float power= [audioRecorder averagePowerForChannel:0];

    CGFloat progress=(1.0/160.0)*(power+160.0)*100;
    NSLog(@"--%f",progress);
    if (volumeView)
    {
        [volumeView setSoundBrick:progress];
    }
}

@end
