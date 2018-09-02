//
//  InitializeAdvertiseViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/6/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "InitializeAdvertiseViewController.h"

@interface InitializeAdvertiseViewController ()
{
    NSInteger timeCount;
    NSTimer* countDownTimer;
}

@property (nonatomic, readonly) AdvertiseInfo* advertiseInfo;
@property (nonatomic, readonly) UIImageView* advertiseImageView;
@property (nonatomic, readonly) UIButton* timeButton;

@end

@implementation InitializeAdvertiseViewController

@synthesize advertiseInfo = _advertiseInfo;
@synthesize timeButton = _timeButton;
@synthesize advertiseImageView = _advertiseImageView;

+ (void) showInParentViweController:(UIViewController*) parentViewController
                      advertiseInfo:(AdvertiseInfo*) advertiseInfo
{
    if (!parentViewController || !advertiseInfo) {
        return;
    }
    InitializeAdvertiseViewController* initializeAdvertiseViewController = [[InitializeAdvertiseViewController alloc] initWithAdvertiseInfo:advertiseInfo];
    [parentViewController addChildViewController:initializeAdvertiseViewController];
    [parentViewController.view addSubview:initializeAdvertiseViewController.view];
    
    [initializeAdvertiseViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(parentViewController.view);
    }];
}

- (void) dealloc
{
    if (countDownTimer) {
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
}

- (id) initWithAdvertiseInfo:(AdvertiseInfo*) advertise
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _advertiseInfo = advertise;
    }
    return self;
}

- (void) loadView
{
    UIControl* control = [[UIControl alloc] init];
    [control setBackgroundColor:[UIColor whiteColor]];
    [self setView:control];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.advertiseInfo)
    {
        __weak typeof(self) weakSelf = self;
         // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
        // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
        [self.advertiseImageView sd_setImageWithURL:[NSURL URLWithString:self.advertiseInfo.imgUrlBig] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error)
            {
                [weakSelf startCountDown];
            }
        }];
        timeCount = self.advertiseInfo.playTime;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.advertiseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(58, 28));
        make.top.equalTo(self.view).with.offset(50);
        make.right.equalTo(self.view).with.offset(-15);
    }];
}

- (void) startCountDown
{
    [self.timeButton addTarget:self action:@selector(entryMainPage) forControlEvents:UIControlEventTouchUpInside];
    [(UIControl*)self.view addTarget:self action:@selector(initAdvertiseClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownHandle) userInfo:nil repeats:YES];
    /*
    countDownTimer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (timeCount > 0) {
            [self.timeButton setTitle:[NSString stringWithFormat:@"%lds 跳过", timeCount--] forState:UIControlStateNormal];
        }
        else
        {
            //倒计时结束，进入首页
            [self entryMainPage];
        }
        
    }];
    */
}

- (void) countDownHandle
{
    if (timeCount > 0) {
        [self.timeButton setTitle:[NSString stringWithFormat:@"%lds 跳过", (long)timeCount--] forState:UIControlStateNormal];
    }
    else
    {
        //倒计时结束，进入首页
        [self entryMainPage];
    }
    
}

- (void) entryMainPage
{
    if (countDownTimer) {
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
    [[HMViewControllerManager defaultManager] entryMainStart];
    
}

- (void) initAdvertiseClicked:(id) sender
{
    NSMutableDictionary* routerDictionary = [NSMutableDictionary dictionary];
    if (self.advertiseInfo.linkUrl) {
        [routerDictionary setValue:self.advertiseInfo.linkUrl forKey:@"routerUrl"];
    }
    
    [[RemoteNoticationHelper defaultHelper] setAlertInfo:routerDictionary];
    [self entryMainPage];
}

#pragma mark - settingAndGetting
- (UIImageView*) advertiseImageView
{
    if (!_advertiseImageView) {
        _advertiseImageView = [[UIImageView alloc] init];
        [self.view addSubview:_advertiseImageView];
    }
    return _advertiseImageView;
}

- (UIButton*) timeButton
{
    if (!_timeButton) {
        _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_timeButton];
        [_timeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_timeButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        _timeButton.layer.cornerRadius = 14;
        _timeButton.layer.masksToBounds = YES;
        [_timeButton setBackgroundImage:[UIImage rectImage:CGSizeMake(58, 28) Color:[UIColor commonTranslucentColor]] forState:UIControlStateNormal];
    }
    return _timeButton;
}
@end
