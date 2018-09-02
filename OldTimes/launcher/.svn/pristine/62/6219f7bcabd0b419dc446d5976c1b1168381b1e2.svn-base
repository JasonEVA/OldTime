//
//  TTLoadingView.m
//  launcher
//
//  Created by William Zhang on 15/7/24.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "TTLoadingView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <Masonry/Masonry.h>

#if defined(JAPANMODE) || defined(JAPANTESTMODE)
#define WZ_LOADING_TIME 2.5
#else
#define WZ_LOADING_TIME 0.77
#endif

@interface TTLoadingView () <MBProgressHUDDelegate>

@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, getter=isLoading) BOOL loading;

@property (nonatomic, strong) UIImageView *loadingImageView;

@end

@implementation TTLoadingView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initComponents];
        self.frame = [[UIScreen mainScreen] bounds];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initComponents];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)initComponents
{
    [self addSubview:self.HUD];
    [self initConstraints];
}

- (void)initConstraints {
    [self.HUD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)dealloc {
    self.HUD.delegate = nil;
    self.delegate = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(overTimerCallBack) object:nil];
}

#pragma mark - Success
- (void)postSuccess:(NSString *)message overTime:(NSTimeInterval)second {
    if (self.mute) {
        return;
    }
    
    self.loading = NO;
    
    UIImage *msgImg = [UIImage imageNamed:@"HUD_Success"];
    UIImageView *msgImgView = [[UIImageView alloc] initWithImage:msgImg];
    self.HUD.customView = msgImgView;
    self.HUD.mode = MBProgressHUDModeCustomView;
    self.HUD.color = [UIColor blackColor];
    self.HUD.detailsLabelText = message;
    self.HUD.detailsLabelFont = [UIFont systemFontOfSize:16];
    [self.HUD show:YES];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(overTimerCallBack) object:nil];
    [self performSelector:@selector(overTimerCallBack) withObject:nil afterDelay:second];
}

#pragma mark - Error
- (void)postError:(NSString *)message detailMessage:(NSString *)detailMessage duration:(CGFloat)duration {
    if (self.mute) {
        return;
    }
    
    self.loading = NO;
    // 无文字不显示
    if (![message length] && ![detailMessage length]) {
        [self hide:NO];
        return;
    }
    
    self.HUD.customView = nil;
    self.HUD.mode = MBProgressHUDModeCustomView;
    self.HUD.color = [UIColor blackColor];
    
    if (!detailMessage.length) {
        detailMessage = message;
    }
    
    self.HUD.detailsLabelText = detailMessage;
    self.HUD.detailsLabelFont = [UIFont systemFontOfSize:16];
    [self.HUD show:YES];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(overTimerCallBack) object:nil];
    [self performSelector:@selector(overTimerCallBack) withObject:nil afterDelay:duration];
}

#pragma mark - Loading
- (void)postProgress:(float)progress {
    if (self.mute) {
        return;
    }
    
    self.HUD.color = [UIColor blackColor];
    self.HUD.mode = MBProgressHUDModeAnnularDeterminate;
    self.HUD.progress = progress;
    [self.HUD show:YES];
}

- (void)postLoading {
    [self postLoading:@""];
}

- (void)postLoading:(NSString *)message {
    [self postLoading:message message:@""];
}

- (void)postLoading:(NSString *)title message:(NSString *)message {
    [self postLoading:title message:message overTime:TipLoadingOverTime];
}

- (void)postLoading:(NSString *)title message:(NSString *)message overTime:(NSTimeInterval)second {
    if (self.mute) {
        return;
    }
    
    if (self.isLoading && [self.HUD.labelText isEqualToString:message]) {
        return;
    }
    
    self.loading = YES;
    self.HUD.customView = self.loadingImageView;
    self.HUD.color = [UIColor clearColor];
    
    self.loadingImageView.animationRepeatCount = 100000;
    self.loadingImageView.animationDuration = WZ_LOADING_TIME;
    [self.loadingImageView startAnimating];
    
    self.HUD.mode = MBProgressHUDModeCustomView;
    self.HUD.labelText = title;
    self.HUD.detailsLabelText = message;
    [self.HUD show:YES];
    [self performSelector:@selector(overTimerCallBack) withObject:nil afterDelay:second];
}

#pragma mark - Hide
- (void)hide:(BOOL)animated {
    self.loading = NO;
    [self.HUD hide:animated];
    self.delegate = nil;
    
    if (_loadingImageView) {
        [_loadingImageView stopAnimating];
        _loadingImageView = nil;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(overTimerCallBack) object:nil];
}

- (void)overTimerCallBack {
    [self hide:NO];
}

#pragma mark - MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    if (self.delegate && [self.delegate respondsToSelector:@selector(TTLoadingViewDelgateCallHubWasHidden)]) {
        [self.delegate TTLoadingViewDelgateCallHubWasHidden];
    }
}

#pragma mark - Initializer
- (MBProgressHUD *)HUD {
    if (!_HUD) {
        _HUD = [[MBProgressHUD alloc] initWithView:self];
        _HUD.animationType = MBProgressHUDAnimationFade;
        _HUD.delegate = self;
        _HUD.mode = MBProgressHUDModeText;
    }
    return _HUD;
}

- (UIImageView *)loadingImageView {
    if (!_loadingImageView) {
        _loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
        _loadingImageView.animationImages = [self loadingImages];
    }
    return _loadingImageView;
}

- (NSArray *)loadingImages {
#if defined(JAPANMODE) || defined(JAPANTESTMODE)
    return @[[UIImage imageNamed:@"loading_japan_1"],
             [UIImage imageNamed:@"loading_japan_2"],
             [UIImage imageNamed:@"loading_japan_3"],
             [UIImage imageNamed:@"loading_japan_4"],
             [UIImage imageNamed:@"loading_japan_5"],
             [UIImage imageNamed:@"loading_japan_6"],
             [UIImage imageNamed:@"loading_japan_7"],
             [UIImage imageNamed:@"loading_japan_8"],
             [UIImage imageNamed:@"loading_japan_9"],
             [UIImage imageNamed:@"loading_japan_10"],
             [UIImage imageNamed:@"loading_japan_11"],
             [UIImage imageNamed:@"loading_japan_12"],
             [UIImage imageNamed:@"loading_japan_13"],
             [UIImage imageNamed:@"loading_japan_14"],
             [UIImage imageNamed:@"loading_japan_15"],
             [UIImage imageNamed:@"loading_japan_16"],
             [UIImage imageNamed:@"loading_japan_17"],
             [UIImage imageNamed:@"loading_japan_16"],
             [UIImage imageNamed:@"loading_japan_15"],
             [UIImage imageNamed:@"loading_japan_14"],
             [UIImage imageNamed:@"loading_japan_13"],
             [UIImage imageNamed:@"loading_japan_12"],
             [UIImage imageNamed:@"loading_japan_11"],
             [UIImage imageNamed:@"loading_japan_10"],
             [UIImage imageNamed:@"loading_japan_9"],
             [UIImage imageNamed:@"loading_japan_8"],
             [UIImage imageNamed:@"loading_japan_7"],
             [UIImage imageNamed:@"loading_japan_6"],
             [UIImage imageNamed:@"loading_japan_5"],
             [UIImage imageNamed:@"loading_japan_4"],
             [UIImage imageNamed:@"loading_japan_3"],
             [UIImage imageNamed:@"loading_japan_2"],
             [UIImage imageNamed:@"loading_japan_1"]
             ];
#else
    return @[[UIImage imageNamed:@"loading_1"],
             [UIImage imageNamed:@"loading_2"],
             [UIImage imageNamed:@"loading_3"],
             [UIImage imageNamed:@"loading_4"],
             [UIImage imageNamed:@"loading_5"],
             [UIImage imageNamed:@"loading_6"],
             [UIImage imageNamed:@"loading_7"],
             [UIImage imageNamed:@"loading_8"],
             [UIImage imageNamed:@"loading_9"],
             [UIImage imageNamed:@"loading_10"],
             [UIImage imageNamed:@"loading_11"]
             ];
#endif
}

@end
