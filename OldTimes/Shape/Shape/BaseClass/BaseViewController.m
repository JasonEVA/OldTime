//
//  BaseViewController.m
//  MintTeam
//
//  Created by William Zhang on 15/7/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"
#import "TTLoadingView.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"

@interface BaseViewController () <TTLoadingViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) TTLoadingView *loadingView;

@end

@implementation BaseViewController

+ (UIViewController *)presentingVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
//    [self setExtendedLayoutIncludesOpaqueBars:NO];
    
    [self.view setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];

    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideLoading];
}

- (void)dealloc
{
    NSLog(@"-------------->%s,%s,%d",__FUNCTION__,__FILE__,__LINE__);

}

#pragma mark - Interface Method

- (BOOL)isLoading {
    return _loadingView && !_loadingView.hidden;
}



#pragma mark - privite methods

// 返回网络请求的错误类型
- (NSString *)getPostError:(NSInteger)errorCode
{
    NSString *errorReason;
    switch (errorCode)
    {
    }
    return errorReason;
}

#pragma mark - TTLoadingView Success
- (void)postSuccess
{
    [self.loadingView postSuccess];
}

- (void)postSuccess:(NSString *)message
{
    [self.loadingView postSuccess:message];
}

- (void)postSuccess:(NSString *)message overTime:(NSTimeInterval)second
{
    [self.loadingView postSuccess:message overTime:second];
}

#pragma mark - TTLoadingView Error
- (void)postErrorFromNumber:(NSInteger)errorNumber {
    NSString *errorMsg = [self getPostError:errorNumber];
    [self postError:errorMsg];
}

- (void)postError:(NSString *)message {
    [self.loadingView postError:message];
}

- (void)postError:(NSString *)message duration:(CGFloat)duration
{
    [self.loadingView postError:message duration:duration];
}

- (void)postError:(NSString *)message detailMessage:(NSString *)detailMessage duration:(CGFloat)duration
{
    [self.loadingView postError:message detailMessage:detailMessage duration:duration];
}

#pragma mark - TTLoadingView Loading
- (void)postProgress:(float)progress {
    [self.loadingView postProgress:progress];
}

- (void)postLoading {
    [self.loadingView postLoading];
}

- (void)postLoading:(NSString *)message {
    [self.loadingView postLoading:message];
}

- (void)postLoading:(NSString *)title message:(NSString *)message {
    [self.loadingView postLoading:title message:message];
}

- (void)postLoading:(NSString *)title message:(NSString *)message overTime:(NSTimeInterval)second {
    [self.loadingView postLoading:title message:message overTime:second];
}


#pragma mark - TTLoadingView Hide
- (void)hideLoading {
    if (self.loadingView)
    {
        [self.loadingView hide:NO];
        [self TTLoadingViewDelgateCallHubWasHidden];
    }
}

#pragma mark - TTLoadingView Delegate
- (void)TTLoadingViewDelgateCallHubWasHidden {
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
        self.loadingView.delegate = nil;
        _loadingView = nil;
    }
}

#pragma mark - Initializer
- (TTLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[TTLoadingView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_loadingView];
        [self.view bringSubviewToFront:_loadingView];
        _loadingView.delegate = self;
    }
    return _loadingView;
}


@end
