//
//  StreamRecordViewController.m
//  DemoAVFoundationCamera
//
//  Created by William Zhang on 15/6/12.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "StreamRecordViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MintcodeIM/MintcodeIM.h>
#import <Masonry/Masonry.h>
#import "MovieRecorder.h"

#define PROGRESS_UPDATE_FREQUENCY   0.05
#define RECORD_MAXTIME  15

typedef NS_ENUM( NSInteger, StreamWriterRecordingStatus )
{
    StreamWriterRecordingStatusIdle = 0,
    StreamWriterRecordingStatusStartingRecording,
    StreamWriterRecordingStatusRecording,
    StreamWriterRecordingStatusStoppingRecording,
}; // internal state machine

@interface StreamRecordViewController () <AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, MovieRecorderDelegate>
/** 相机拍摄预览图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
/** 录影 */
@property (nonatomic, strong) UIButton                   *btnRecord;
@property (nonatomic, strong) UIView                     *viewContainer;

@property (nonatomic, strong) AVCaptureSession    *captureSession;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@property (nonatomic, strong) AVCaptureConnection *audioConnection;
@property (nonatomic, strong) AVCaptureDevice     *videoDevice;

@property (nonatomic, strong) NSDictionary *videoCompressionSettings;
@property (nonatomic, strong) NSDictionary *audioCompressionSettings;

@property (nonatomic, retain) __attribute__((NSObject)) CMFormatDescriptionRef outputVideoFormatDescription;
@property (nonatomic, retain) __attribute__((NSObject)) CMFormatDescriptionRef outputAudioFormatDescription;

@property (nonatomic        ) dispatch_queue_t  sessionQueue;
@property (nonatomic        ) dispatch_queue_t  videoDataOutputQueue;

@property (nonatomic, assign) StreamWriterRecordingStatus recordingStatus;
@property (nonatomic, assign) UIBackgroundTaskIdentifier streamRecordRunningTask;

@property (nonatomic, readwrite) AVCaptureVideoOrientation videoOrientation;

@property (nonatomic, assign) BOOL running;

@property (nonatomic, strong) MovieRecorder *recorder;

@property (nonatomic, strong) NSString *sessionPreset;

// 录制长短
@property (nonatomic, strong) NSTimer *timerRecord;

@property (nonatomic, strong) UIProgressView *progressLeft;
@property (nonatomic, strong) UIProgressView *progressRight;
/** 录制时长 */
@property (nonatomic, assign) CGFloat recordDuration;
/** 超时 */
@property (nonatomic, getter=isTimeOut) BOOL timeOut;
@property (nonatomic, strong) NSURL *fileURLPath;
/** 录制禁止旋转 */
@property (nonatomic, assign) BOOL enableRotation;

@end

@implementation StreamRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:self.viewContainer];
    [self.view addSubview:self.btnRecord];
    [self.view addSubview:self.progressLeft];
    [self.view addSubview:self.progressRight];
    [self initConstraints];
    self.sessionQueue = dispatch_queue_create("com.apple.session", DISPATCH_QUEUE_SERIAL);
    
    self.videoDataOutputQueue = dispatch_queue_create("com.apple.sample.video", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(self.videoDataOutputQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    
    self.streamRecordRunningTask = UIBackgroundTaskInvalid;
    
    [self setupCaptureSession];
    
    self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.captureVideoPreviewLayer.connection.videoOrientation = (AVCaptureVideoOrientation)[UIApplication sharedApplication].statusBarOrientation;
    
    [self.viewContainer.layer addSublayer:self.captureVideoPreviewLayer];
    
    [self.captureSession startRunning];
    
//    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(changeData) userInfo:nil repeats:YES];
//    [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(changeAudio) userInfo:nil repeats:YES];
}

- (void)initConstraints
{
    [self.viewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.btnRecord.mas_top);
    }];
    
    [self.btnRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.progressLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.btnRecord);
        make.width.equalTo(self.btnRecord).dividedBy(2.0).offset(1);
    }];
    
    [self.progressRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnRecord);
        make.width.top.equalTo(self.progressLeft);
    }];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.captureVideoPreviewLayer setFrame:self.viewContainer.bounds];
}

#pragma mark - Test
- (void)changeAudio
{
    static NSInteger time = 0;
    
    NSMutableDictionary *dictTmp = [NSMutableDictionary dictionaryWithDictionary:self.audioCompressionSettings];
    
    switch (time) {
        case 0:
            [dictTmp setObject:@(1) forKey:AVNumberOfChannelsKey];
            break;
        case 2:
            [dictTmp setObject:@(2) forKey:AVNumberOfChannelsKey];
            break;
            break;
        default:
            break;
    }
    
    self.audioCompressionSettings = dictTmp;
    NSLog(@"%@",self.audioCompressionSettings);
    [self clickToRecord];
    time ++;
}

- (void)changeData
{
    static NSInteger time = 1;
    
    NSString *strTmp;
    switch (time)
    {
        case 0:
            strTmp = AVCaptureSessionPreset1280x720;
            break;
        case 1:
            strTmp = AVCaptureSessionPreset1920x1080;
            break;
        case 2:
            strTmp = AVCaptureSessionPreset352x288;
            break;
        case 3:
            strTmp = AVCaptureSessionPreset640x480;
            break;
        case 4:
            strTmp = AVCaptureSessionPresetHigh;
            break;
        case 5:
            strTmp = AVCaptureSessionPresetiFrame1280x720;
            break;
        case 6:
            strTmp = AVCaptureSessionPresetiFrame960x540;
            break;
        case 7:
            strTmp = AVCaptureSessionPresetInputPriority;
            break;
        case 8:
            strTmp = AVCaptureSessionPresetLow;
            break;
        case 9:
            strTmp = AVCaptureSessionPresetMedium;
            break;
        default:
            break;
    }
    
    if ([self.captureSession canSetSessionPreset:strTmp])
    {
        [self.captureSession setSessionPreset:strTmp];
        self.sessionPreset = strTmp;
    }
    
    time ++;
    [self clickToRecord];
}
#pragma mark - Private Method
// 获取摄像头
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)postion
{
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras)
    {
        if ([camera position] == postion)
        {
            return camera;
        }
    }
    return nil;
}

- (AVCaptureDevice *)frontCamera
{
    return [self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera
{
    return [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
}

- (NSString *)getTitle:(NSString *)title {
    NSString *documentsFile = [[MsgFilePathMgr share] getMessageDirNamePathWithUid:self.strUid];
    NSString *str = [title stringByReplacingOccurrencesOfString:documentsFile withString:@""];
    return str;
}

- (void)setupCaptureSession
{
    if (_captureSession){
        return;
    }
    self.captureSession = [[AVCaptureSession alloc] init];
    
    /** Audio */
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioIn = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:nil];
    if ([self.captureSession canAddInput:audioIn])
    {
        [self.captureSession addInput:audioIn];
    }
    
    AVCaptureAudioDataOutput *audioOut = [[AVCaptureAudioDataOutput alloc] init];
    dispatch_queue_t audioCaptureQueue = dispatch_queue_create("com.apple.sample.audio", DISPATCH_QUEUE_SERIAL);
    [audioOut setSampleBufferDelegate:self queue:audioCaptureQueue];
    
    if ([self.captureSession canAddOutput:audioOut])
    {
        [self.captureSession addOutput:audioOut];
    }
    self.audioConnection = [audioOut connectionWithMediaType:AVMediaTypeAudio];
    
    /** Video */
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.videoDevice = videoDevice;
    AVCaptureDeviceInput *videoIn = [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:nil];
    if ([self.captureSession canAddInput:videoIn])
    {
        [self.captureSession addInput:videoIn];
    }
    
    AVCaptureVideoDataOutput *videoOut = [[AVCaptureVideoDataOutput alloc] init];
    videoOut.videoSettings = @{ (id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
    [videoOut setSampleBufferDelegate:self queue:self.videoDataOutputQueue];
    
    // RosyWriter records videos and we prefer not to have any dropped frames in the video recording.
    // By setting alwaysDiscardsLateVideoFrames to NO we ensure that minor fluctuations in system load or in our processing time for a given frame won't cause framedrops.
    // We do however need to ensure that on average we can process frames in realtime.
    // If we were doing preview only we would probably want to set alwaysDiscardsLateVideoFrames to YES.
    [videoOut setAlwaysDiscardsLateVideoFrames:NO];
    
    if ([self.captureSession canAddOutput:videoOut]) {
        [self.captureSession addOutput:videoOut];
    }
    
    self.videoConnection = [videoOut connectionWithMediaType:AVMediaTypeVideo];
    
    self.captureSession.sessionPreset = self.sessionPreset;
    CMTime frameDuration = CMTimeMake(1, 30);
    
    NSError *error = nil;
    if ([videoDevice lockForConfiguration:&error]) {
        videoDevice.activeVideoMaxFrameDuration = frameDuration;
        videoDevice.activeVideoMinFrameDuration = frameDuration;
        [videoDevice unlockForConfiguration];
    }
    else {
        NSLog( @"videoDevice lockForConfiguration returned error %@", error );
    }
    
    self.videoCompressionSettings = @{AVVideoCodecKey:AVVideoCodecH264,
                                      AVVideoWidthKey:@(1920),
                                      AVVideoHeightKey:@(1080),
                                      AVVideoCompressionPropertiesKey:@{AVVideoProfileLevelKey:AVVideoProfileLevelH264BaselineAutoLevel,
                                                                        AVVideoAllowFrameReorderingKey:@NO,
                                                                        AVVideoExpectedSourceFrameRateKey:@15
                                                                        }
                                      };
//    self.audioCompressionSettings = [audioOut recommendedAudioSettingsForAssetWriterWithOutputFileType:AVFileTypeQuickTimeMovie];
    self.audioCompressionSettings = @{AVFormatIDKey:@(kAudioFormatMPEG4AAC),
                                      AVNumberOfChannelsKey:@(2),
                                      AVSampleRateKey:@(44100.0)
                                      };
 //   NSLog(@"%@",self.audioCompressionSettings);
    self.videoOrientation = self.videoConnection.videoOrientation;
}

/** 刷新录制进度条 */
- (void)updateProgress
{
    self.recordDuration += PROGRESS_UPDATE_FREQUENCY;
    
    CGFloat percentage = self.recordDuration / RECORD_MAXTIME;
    // 更新进度条
    [self.progressLeft setProgress:percentage animated:YES];
    [self.progressRight setProgress:(1 - percentage) animated:YES];
    
    // 录制时间最大时结束录制
    if (self.recordDuration >= RECORD_MAXTIME)
    {
        [self clickToRecordUpInside];
        [self setTimeOut:YES];
        NSLog(@"maxTime");
    }
}

#pragma mark - Button Click
/** 录像 */
- (void)clickToRecord
{
    if (!self.recorder) {
        self.enableRotation = NO;
        [self.btnRecord setTitle:@"录制中" forState:UIControlStateNormal];
        NSString *filePath = [[MsgFilePathMgr share] newFileWithType:@"mp4" sessionPreset:self.sessionPreset uid:self.strUid];
        NSURL *urlFile = [[NSURL alloc] initFileURLWithPath:filePath];
        
        self.fileURLPath = [urlFile copy];
        
        [self setTitle:@"视频"];
        
        MovieRecorder *recorder = [[MovieRecorder alloc] initWithURL:urlFile];
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        CGAffineTransform videoTransform = [self transformFromVideoBufferOrientationToOrientation:(AVCaptureVideoOrientation)orientation withAutoMirroring:NO];
        
        [recorder addVideoTrackWithSourceFormatDescription:self.outputVideoFormatDescription transform:videoTransform settings:self.videoCompressionSettings];
        [recorder addAudioTrackWithSourceFormatDescription:self.outputAudioFormatDescription settings:self.audioCompressionSettings];
        
        dispatch_queue_t callbackQueue = dispatch_queue_create( "com.apple.sample.capturepipeline.recordercallback", DISPATCH_QUEUE_SERIAL ); // guarantee ordering of callbacks with a serial queue
        [recorder setDelegate:self callbackQueue:callbackQueue];
        self.recorder = recorder;
        
        [recorder prepareToRecord]; // asynchronous, will call us back with recorderDidFinishPreparing: or recorder:didFailWithError: when done
        self.recordingStatus = StreamWriterRecordingStatusStartingRecording;
        [self setTimeOut:NO];
    }
    else
    {
        self.enableRotation = YES;
        [self.btnRecord setTitle:@"录制" forState:UIControlStateNormal];
        [self.recorder finishRecording];
        self.recordingStatus = StreamWriterRecordingStatusStoppingRecording;
        self.recorder = nil;
        
        NSLog(@"%@",self.fileURLPath);
    }
}

- (void)clickToRecordDown
{
    NSLog(@"down");
    if (!self.recorder)
    {
        [self clickToRecord];
        self.timerRecord = [NSTimer scheduledTimerWithTimeInterval:PROGRESS_UPDATE_FREQUENCY target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        [self.timerRecord fire];
        self.recordDuration = 0;
    }
}

- (void)clickToRecordUpInside
{
    NSLog(@"upinside");
    if (self.recorder)
    {
        if (self.recordingStatus == StreamWriterRecordingStatusRecording)
        {
            NSLog(@"stop");
            [self clickToRecord];
        }
        else
        {
            NSLog(@"delete");
            self.recorder = nil;
            self.recordingStatus = StreamWriterRecordingStatusIdle;
            [self.btnRecord setTitle:@"录制" forState:UIControlStateNormal];
            
            [[NSFileManager defaultManager] removeItemAtURL:self.fileURLPath error:nil];
            self.fileURLPath = nil;
        }
    }
    
    
    if (self.timerRecord)
    {
        [self.timerRecord invalidate];
        self.timerRecord = nil;
    }
    [self.progressLeft setProgress:0.0 animated:YES];
    [self.progressRight setProgress:1.0 animated:YES];
}

- (void)clickToRecordUpOutside
{
    [self clickToRecordUpInside];
}

#pragma mark - MovieRecord Delegate
- (void)movieRecorderDidFinishPreparing:(MovieRecorder *)recorder
{
    NSLog(@"开始准备录制。。。");
    @synchronized(self)
    {
        self.recordingStatus = StreamWriterRecordingStatusRecording;
    }
}

- (void)movieRecorderDidFinishRecording:(MovieRecorder *)recorder
{
    NSLog(@"录制结束。。。");
    
    @synchronized(self)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.recorder = nil;
            self.recordingStatus = StreamWriterRecordingStatusIdle;
            
            [self.navigationController popViewControllerAnimated:YES];
            
            if ([self.delegate respondsToSelector:@selector(StreamRecordViewControllerDelegateCallBack_FinishRecordingVideo)])
            {
                [self.delegate StreamRecordViewControllerDelegateCallBack_FinishRecordingVideo];
            }
        });
    }
}

- (void)movieRecorder:(MovieRecorder *)recorder didFailWithError:(NSError *)error
{
    NSLog(@"录制错误。。。%@",error);
    @synchronized(self)
    {
        self.recorder = nil;
        self.recordingStatus = StreamWriterRecordingStatusIdle;
    };
}

#pragma mark Utilities

// Auto mirroring: Front camera is mirrored; back camera isn't
- (CGAffineTransform)transformFromVideoBufferOrientationToOrientation:(AVCaptureVideoOrientation)orientation withAutoMirroring:(BOOL)mirror
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // Calculate offsets from an arbitrary reference orientation (portrait)
    CGFloat orientationAngleOffset = angleOffsetFromPortraitOrientationToOrientation( orientation );
    CGFloat videoOrientationAngleOffset = angleOffsetFromPortraitOrientationToOrientation( self.videoOrientation );
    
    // Find the difference in angle between the desired orientation and the video orientation
    CGFloat angleOffset = orientationAngleOffset - videoOrientationAngleOffset;
    transform = CGAffineTransformMakeRotation( angleOffset );
    
    if ( _videoDevice.position == AVCaptureDevicePositionFront )
    {
        if ( mirror ) {
            transform = CGAffineTransformScale( transform, -1, 1 );
        }
        else {
            if ( UIInterfaceOrientationIsPortrait( orientation ) ) {
                transform = CGAffineTransformRotate( transform, M_PI );
            }
        }
    }
    
    return transform;
}

static CGFloat angleOffsetFromPortraitOrientationToOrientation(AVCaptureVideoOrientation orientation)
{
    CGFloat angle = 0.0;
    
    switch ( orientation )
    {
        case AVCaptureVideoOrientationPortrait:
            angle = 0.0;
            break;
        case AVCaptureVideoOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case AVCaptureVideoOrientationLandscapeRight:
            angle = -M_PI_2;
            break;
        case AVCaptureVideoOrientationLandscapeLeft:
            angle = M_PI_2;
            break;
        default:
            break;
    }
    
    return angle;
}

#pragma mark - AVCaptureVideoDataOutputSampleBuffer Delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
    if (connection == self.videoConnection)
    {
        self.outputVideoFormatDescription = formatDescription;
        
        @synchronized(self) {
            if (self.recordingStatus == StreamWriterRecordingStatusRecording)
            {
                [self.recorder appendVideoSampleBuffer:sampleBuffer];
            }
        }
    }
    else if (connection == self.audioConnection)
    {
        self.outputAudioFormatDescription = formatDescription;
        
        @synchronized(self) {
            if (self.recordingStatus == StreamWriterRecordingStatusRecording)
            {
                [self.recorder appendAudioSampleBuffer:sampleBuffer];
            }
        }
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"丢弃了");
}

#pragma mark - Init
- (UIView *)viewContainer
{
    if (!_viewContainer)
    {
        _viewContainer = [[UIView alloc] init];
    }
    return _viewContainer;
}

- (UIButton *)btnRecord
{
    if (!_btnRecord)
    {
        _btnRecord = [[UIButton alloc] init];
        [_btnRecord setTitle:@"录制" forState:UIControlStateNormal];
        [_btnRecord addTarget:self action:@selector(clickToRecordDown) forControlEvents:UIControlEventTouchDown];
        [_btnRecord addTarget:self action:@selector(clickToRecordUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_btnRecord addTarget:self action:@selector(clickToRecordUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _btnRecord;
}

- (NSString *)sessionPreset {
    if (!_sessionPreset) {
        _sessionPreset = AVCaptureSessionPreset352x288;
    }
    return _sessionPreset;
}

- (UIProgressView *)progressLeft {
    if (!_progressLeft) {
        _progressLeft = [[UIProgressView alloc] init];
        [_progressLeft setProgressTintColor:[UIColor whiteColor]];
        [_progressLeft setTrackTintColor:[UIColor greenColor]];
    }
    return _progressLeft;
}

- (UIProgressView *)progressRight {
    if (!_progressRight) {
        _progressRight = [[UIProgressView alloc] init];
        [_progressRight setProgressTintColor:[UIColor greenColor]];
        [_progressRight setTrackTintColor:[UIColor whiteColor]];
        [_progressRight setProgress:1.0];
    }
    return _progressRight;
}

@end
