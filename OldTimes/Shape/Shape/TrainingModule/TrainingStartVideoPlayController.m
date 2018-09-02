//
//  TrainingStartVideoPlayController.m
//  Shape
//
//  Created by jasonwang on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainingStartVideoPlayController.h"
#import <Masonry.h>
#import "UILabel+EX.h"
#import "UIButton+EX.h"
#import "TrainProgressView.h"
#import "TrainFinishInputView.h"
#import <AVFoundation/AVFoundation.h>
#import "UIColor+Hex.h"
#import "unifiedFilePathManager.h"
#import "VideoPlayerView.h"
#import "TrainActionListModel.h"
#import "TrainFinishTrainRequest.h"

typedef enum : NSUInteger {
    priorTag,
    nextTag,
    controllTag,
} buttonTag;

@interface TrainingStartVideoPlayController()<TrainFinishInputViewDelegate,BaseRequestDelegate>
@property (nonatomic, strong) AVPlayer *player; // 播放器对象
@property (nonatomic, strong)  VideoPlayerView  *container; // 播放器容器
@property (nonatomic, strong)  UIProgressView  *playProgressView; // 播放进度条
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *trainName;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UIButton *controllBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *priorBtn;
@property (nonatomic, strong) TrainProgressView *progressView;
//弹框
@property (nonatomic, strong) TrainFinishInputView *myInputView;
@property (nonatomic)  NSInteger  repeatTimes; // 重复次数
@property (nonatomic)  NSInteger  playedTimes; // 已播放次数
@property (nonatomic)  CGFloat  videoLength; // 视频长度
@property (nonatomic)  NSInteger  currentVideoIndex; // <##>
@end
@implementation TrainingStartVideoPlayController
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initComponent];
    [self.view needsUpdateConstraints];
    [self addNotification];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self removeObserverFromPlayerItem:self.player.currentItem];
    [self removeNotification];
}

-(void)dealloc{
    NSLog(@"-------------->%s,%s,%d",__FUNCTION__,__FILE__,__LINE__);

    [self.player pause];
    [self removeObserverFromPlayerItem:self.player.currentItem];
    [self removeNotification];
}

#pragma mark - updateViewConstraints
- (void)updateViewConstraints
{
    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.374);
    }];
    [self.playProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.container);
        make.height.equalTo(@6);
    }];
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(8);
        make.top.equalTo(self.view).offset(18);
    }];
    
    [self.trainName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container.mas_bottom).offset(50);
        make.centerX.equalTo(self.view);
    }];
    
    [self.time mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trainName.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
    
    [self.controllBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.time.mas_bottom).offset(36);
        make.centerX.equalTo(self.view);
    }];
    
    [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.controllBtn);
        make.right.equalTo(self.view).offset(-55);
    }];
    
    [self.priorBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.controllBtn);
        make.left.equalTo(self.view).offset(55);
    }];
    
    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.height.mas_equalTo(49);
    }];
    
    [self.myInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
        make.height.mas_equalTo(self.view.frame.size.height * 0.54);
        make.width.mas_equalTo(self.view.frame.size.width * 0.77);
    }];
    [super updateViewConstraints];
}


#pragma mark -private method
- (void)initComponent
{
    [self.view addSubview:self.container];
    [self.container addSubview:self.playProgressView];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.trainName];
    [self.view addSubview:self.time];
    [self.view addSubview:self.controllBtn];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.myInputView];
    [self.view addSubview:self.priorBtn];
    self.repeatTimes = 5;
    self.playedTimes = 0;
    self.currentVideoIndex = 0;
    [self isShowBtn];
}

/**
 *  根据视频索引取得AVPlayerItem对象
 *
 *  @param videoIndex 视频顺序索引
 *
 *  @return AVPlayerItem对象
 */
- (AVPlayerItem *)getPlayItem:(NSInteger)videoIndex {
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@".mp4"];

//    NSURL *url=[NSURL fileURLWithPath:path];
    NSURL *url = [NSURL URLWithString:self.arrayActionList[videoIndex].videoUrl];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    return playerItem;
}

- (void)isShowBtn
{
    if (self.currentVideoIndex != 0) {
        [self.priorBtn setHidden:NO];
    } else {
        [self.priorBtn setHidden:YES];
    }
    if (self.currentVideoIndex != self.arrayActionList.count - 1) {
        [self.nextBtn setHidden:NO];
    } else {
        [self.nextBtn setHidden:YES];
        
    }
}

#pragma mark - 通知
/**
 *  添加播放器通知
 */
- (void)addNotification {
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
- (void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");
    if (self.playedTimes < self.repeatTimes) {
        self.playedTimes ++;

        AVPlayerItem *playerItem = [notification object];
        //关键代码
        [playerItem seekToTime:kCMTimeZero];
        
        [self.player play];
        NSLog(@"重播");
    }
}
#pragma mark - 监控
/**
 *  给播放器添加进度更新
 */
- (void)addProgressObserver {
    UIProgressView *progress = self.playProgressView;
    //这里设置每秒执行一次
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time) + self.playedTimes * self.videoLength;
        float total = self.repeatTimes * self.videoLength;
        NSLog(@"当前进度%.2fs.",(current/total));
        if (current) {
            [progress setProgress:(current/total) animated:YES];
        }
    }];
}
/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem {
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem {
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            self.videoLength = CMTimeGetSeconds(playerItem.duration);
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f",totalBuffer);
        //
    }
}
#pragma mark - event Response

// 返回按钮
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 播放暂停按钮
- (void)playButtonClicked {
    [self playAndPauseVideo];
}

// 视频播放暂停
- (void)playAndPauseVideo {
    if (self.player.rate == 0) {
        [self.player play];
        [self.controllBtn setImage:[UIImage imageNamed:@"train_stop"] forState:UIControlStateNormal];
        
    } else {
        [self.player pause];
        [self.controllBtn setImage:[UIImage imageNamed:@"train_play"] forState:UIControlStateNormal];
    }
}

// 上下一个按钮监听
- (void)nextClick:(UIButton *)button
{
    if (button.tag == nextTag) {
        [self switchVideo:YES];
        [self.progressView setMyProgress:0.5];
    } else {
        [self switchVideo:NO];
        [self.progressView setMyProgress:0.0];
    }
    [self isShowBtn];
    
}



// 切换视频
- (void)switchVideo:(BOOL)next {
    if ((next && self.currentVideoIndex == self.arrayActionList.count - 1) || (!next && self.currentVideoIndex == 0)) {
        return;
    }
    // 初始化
    [self.player pause];

    self.repeatTimes = 5;
    self.playedTimes = 0;
    [self.playProgressView setProgress:0 animated:NO];
    
    self.currentVideoIndex = next ? ++ self.currentVideoIndex :-- self.currentVideoIndex ;
    [self removeNotification];
    [self removeObserverFromPlayerItem:self.player.currentItem];
    AVPlayerItem *playerItem = [self getPlayItem:self.currentVideoIndex];
    [self addObserverToPlayerItem:playerItem];
    //切换视频
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self addNotification];
    [self.player play];
    [self.controllBtn setImage:[UIImage imageNamed:@"train_stop"] forState:UIControlStateNormal];

}
#pragma mark - TrainFinishViewDelegate

- (void)TrainFinishInputViewDelegate_callBack
{
    TrainFinishTrainRequest *request = [[TrainFinishTrainRequest alloc]init];
    request.identifier = self.trainID;
    [request requestWithDelegate:self];
    [self postLoading];
}

#pragma mark - request Delegate
- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    [self hideLoading];
    NSLog(@"请求成功");
    [self.myInputView setHidden:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response
{
     NSLog(@"请求失败");
    [self hideLoading];
    [self.myInputView setHidden:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - init UI
- (VideoPlayerView *)container {
    if (!_container) {
        _container = [[VideoPlayerView alloc] initWithPlayer:self.player];
    }
    return _container;
}
- (UIProgressView *)playProgressView {
    if (!_playProgressView) {
        _playProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [_playProgressView setProgressTintColor:[UIColor themeOrange_ff5d2b]];
        [_playProgressView setTrackTintColor:[UIColor colorLightGray_898888]];
    }
    return _playProgressView;
}

- (AVPlayer *)player
{
    if (!_player) {
        AVPlayerItem *playerItem=[self getPlayItem:0];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        [self addProgressObserver];
        [self addObserverToPlayerItem:playerItem];
    }
    return _player;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"train_roundback"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)trainName
{
    if (!_trainName) {
        _trainName = [UILabel setLabel:_trainName text:@"1.腹肌燃烧" font:[UIFont systemFontOfSize:18] textColor:[UIColor whiteColor]];
    }
    return _trainName;
}

- (UILabel *)time
{
    if (!_time) {
        _time = [UILabel setLabel:_time text:@"00:34" font:[UIFont systemFontOfSize:18] textColor:[UIColor whiteColor]];
    }
    return _time;
}
- (UIButton *)controllBtn
{
    if (!_controllBtn) {
        _controllBtn = [[UIButton alloc]init];
        [_controllBtn setImage:[UIImage imageNamed:@"train_play"] forState:UIControlStateNormal];
        [_controllBtn addTarget:self action:@selector(playButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_controllBtn setTag:controllTag];
    }
    return _controllBtn;
}

- (UIButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc]init];
        [_nextBtn setImage:[UIImage imageNamed:@"train_bignext"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setTag:nextTag];
    }
    return _nextBtn;
}

- (UIButton *)priorBtn
{
    if (!_priorBtn) {
        _priorBtn = [[UIButton alloc]init];
        [_priorBtn setImage:[UIImage imageNamed:@"train_bignext"] forState:UIControlStateNormal];
        [_priorBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
        _priorBtn.transform = CGAffineTransformMakeRotation(M_PI);
        [_priorBtn setTag:priorTag];
        //[_priorBtn setHidden:YES];
    }
    return _priorBtn;
}

- (TrainProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[TrainProgressView alloc]init];
    }
    return _progressView;
}
- (TrainFinishInputView *)myInputView
{
    if (!_myInputView) {
        _myInputView = [[TrainFinishInputView alloc]init];
        _myInputView.layer.cornerRadius = 10;
        [_myInputView setDelegate:self];
        [_myInputView setHidden:YES];
    }
    return _myInputView;
}
@end
