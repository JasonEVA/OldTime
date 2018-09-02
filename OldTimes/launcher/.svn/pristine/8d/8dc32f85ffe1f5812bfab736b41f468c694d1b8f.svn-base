//
//  UIViewController+Loading.m
//  NCDoctor
//
//  Created by SimonMiao on 16/7/3.
//  Copyright © 2016年 SimonMiao. All rights reserved.
//

#import "UIViewController+ATLoading.h"
#import "CCLoadingView.h"
#import "CCInfoView.h"
#import "ATStaticInfoView.h"

#import <objc/runtime.h>

@interface UIViewController (ATloadingView)  <CCLoadingDelegate>

@property (nonatomic, strong) CCLoadingView *loadingView;
@property (nonatomic, strong) CCInfoView *noContentWarningView;
@property (nonatomic, strong) CCInfoView *netErrorWarningView;

@property (nonatomic, strong) ATStaticInfoView *nostaticContentWarningView;

@property (nonatomic, assign)   CGFloat         yOffset;

@end

@implementation UIViewController (ATloadingView)

- (CCLoadingView *)loadingView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLoadingView:(CCLoadingView *)loadingView {
        objc_setAssociatedObject(self, @selector(loadingView), loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CCInfoView *)noContentWarningView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNoContentWarningView:(CCInfoView *)noContentWarningView {
    objc_setAssociatedObject(self, @selector(noContentWarningView), noContentWarningView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ATStaticInfoView *)nostaticContentWarningView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNostaticContentWarningView:(ATStaticInfoView *)nostaticContentWarningView {
    objc_setAssociatedObject(self, @selector(nostaticContentWarningView), nostaticContentWarningView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



- (CCInfoView *)netErrorWarningView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNetErrorWarningView:(CCInfoView *)netErrorWarningView {
    objc_setAssociatedObject(self, @selector(netErrorWarningView), netErrorWarningView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)yOffset {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setYOffset:(CGFloat)yOffset {
    objc_setAssociatedObject(self, @selector(yOffset), @(yOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - CCLoadingDelegate
- (void)hudWasHidden {
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
        self.loadingView.delegate = nil;
        self.loadingView = nil;
    }
}

@end

@implementation UIViewController (ATLoading)

/**
#pragma mark - loading method
- (void)setPostYOffset:(int)offset
{
    self.yOffset = offset;
    
}


- (void)postSuccess:(NSString *)message{
    [self postMessage:message];
}
- (void)postSuccess:(NSString *)message overTime:(NSTimeInterval)second{
    [self checkCreateLoading];
    [self.loadingView postMessage:message overTime:second];
}

- (void)postMessage:(NSString *)message{
    [self checkCreateLoading];
    
    self.loadingView.HUD.yOffset = self.yOffset;
    [self.loadingView postMessage:message];
}

- (void)postError:(NSString *)message duration:(CGFloat)duration{
    
    
    [self checkCreateLoading];
    [self.loadingView postError:message duration:duration];
}

- (void)postError:(NSString *)message{
    
    [self postError:message duration:TipNormalOverTime];
    
}

- (void)postNetworkError
{
    [self postError:@"网络错误"];//CCLocalizedString(@"common.networkerror")
}
- (void)postLoadingWithMessage:(NSString *)message{
        [self checkCreateLoading];
        [self.loadingView postLoading:message];
//    [self gifLoadingView];
    //    [self.gifLoadingView startGIF];
//    CCLog(@"******message********:%@",message);
}

- (void)postLoadingWithMessage:(NSString *)message overTime:(NSTimeInterval)second{
    [self checkCreateLoading];
    [self.loadingView postLoading:message overTime:second];
}

- (void)postLoadingWithTitle:(NSString *)title message:(NSString*)message {
    [self checkCreateLoading];
    [self.loadingView postLoading:title message:message];
}

- (void)postLoadingWithTitle:(NSString *)title message:(NSString*)message overTime:(NSTimeInterval)second {
    [self checkCreateLoading];
    [self.loadingView postLoading:title message:message overTime:second];
}

- (void)postWaiting {
    [self postLoadingWithMessage:NSLocalizedString(@"common.pleasewait", @"Please Wait...")];
}
*/

- (void)checkCreateLoading
{
    if (!self.loadingView) {
        self.loadingView = [[CCLoadingView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.loadingView];
        [self.view bringSubviewToFront:self.loadingView];
        self.loadingView.delegate = self;
    }
}

- (void)hideLoading{
    if (self.loadingView) {
        [self.loadingView hide:NO];
        [self.loadingView removeFromSuperview];
        self.loadingView.delegate = nil;
        self.loadingView = nil;
    }
//    [self hideGifLoadingView];
}

- (void)showNoContentWarningView{
    if (!self.noContentWarningView) {
        self.noContentWarningView = [[CCInfoView alloc] initWithImage:[UIImage imageNamed:@"img_common_warning_noContent"] andMessage:@"暂无记录"];
        self.noContentWarningView.frame = self.view.bounds;
        [self.view addSubview:self.noContentWarningView];
        [self.view bringSubviewToFront:self.noContentWarningView];
    }
}

- (void)showNoContentWarningView:(CGRect)frame {

    if (!self.nostaticContentWarningView) {
        self.nostaticContentWarningView = [[ATStaticInfoView alloc] initWithImage:[UIImage imageNamed:@"img_common_warning_noContent"] andMessage:@"暂无记录"];
        self.nostaticContentWarningView.frame = frame;
        [self.view addSubview:self.nostaticContentWarningView];
        
        [self.view bringSubviewToFront:self.nostaticContentWarningView];
//
    }

}


- (void)hideNoContentWarningView{
    if (self.noContentWarningView) {
        [self.noContentWarningView removeFromSuperview];
        self.noContentWarningView = nil;
    }
    
    if (self.nostaticContentWarningView) {
        [self.nostaticContentWarningView removeFromSuperview];
        self.nostaticContentWarningView = nil;
    }
}

- (void)showNetworkErrorWarningView{
    if (!self.netErrorWarningView) {
        self.netErrorWarningView = [[CCInfoView alloc] initWithImage:[UIImage imageNamed:@"img_common_warning_noNetwork"] andMessage:@"断线了"];
        self.netErrorWarningView.frame = self.view.bounds;
        [self.view addSubview:self.netErrorWarningView];
        [self.view bringSubviewToFront:self.netErrorWarningView];
    }
}

- (void)hideNetworkErrorWarningView{
    if (self.netErrorWarningView) {
        [self.netErrorWarningView removeFromSuperview];
        self.netErrorWarningView = nil;
    }
}


@end
