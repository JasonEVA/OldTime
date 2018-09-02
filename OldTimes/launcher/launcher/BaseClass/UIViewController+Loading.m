//
//  UIViewController+Loading.m
//  launcher
//
//  Created by williamzhang on 15/11/24.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "UIViewController+Loading.h"
#import <Masonry/Masonry.h>
#import "TTLoadingView.h"
#import "MyDefine.h"
#import <objc/runtime.h>

#import "ChatSingleViewController.h"
#import "ChatGroupViewController.h"

@interface UIViewController (loadingView) <TTLoadingViewDelegate>

@property (nonatomic, strong) TTLoadingView *loadingView;

@end

@implementation UIViewController (loadingView)

- (TTLoadingView *)loadingView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLoadingView:(TTLoadingView *)loadingView {
    objc_setAssociatedObject(self, @selector(loadingView), loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - TTLoadingView Delegate
- (void)TTLoadingViewDelgateCallHubWasHidden {
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
        self.loadingView.delegate = nil;
        self.loadingView = nil;
    }
}

@end

@implementation UIViewController (Loading)

- (BOOL)loadingUserInteractionEnabled {
    id value = objc_getAssociatedObject(self, _cmd);
    return value ? [value boolValue] : YES;
}

- (void)setLoadingUserInteractionEnabled:(BOOL)loadingUserInteractionEnabled {
    objc_setAssociatedObject(self, @selector(loadingUserInteractionEnabled), @(loadingUserInteractionEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isLoading {
    return self.loadingView && !self.loadingView.hidden;
}

- (void)configureLoading {
    if (!self.loadingView) {
        self.loadingView = [[TTLoadingView alloc] initWithFrame:self.view.bounds];
        self.loadingView.delegate = self;
        self.loadingView.userInteractionEnabled = self.loadingUserInteractionEnabled;
        [self.view addSubview:self.loadingView];
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
        }];
    }
    
    [self.loadingView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.navigationController.navigationBarHidden) {
            make.top.equalTo(self.view);
        }
        
        make.top.equalTo(self.view).offset(-64);
    }];
    
    [self.view bringSubviewToFront:self.loadingView];
}

#pragma mark - TTLoadingView Success
- (void)postSuccess                     { [self postSuccess:@""];}
- (void)postSuccess:(NSString *)message { [self postSuccess:message overTime:TipNormalOverTime];}
- (void)postSuccess:(NSString *)message overTime:(NSTimeInterval)second {
    [self configureLoading];
    [self.loadingView postSuccess:message overTime:second];
}

#pragma mark - TTLoadingView Error
- (void)postError:(NSString *)message                            { [self postError:message detailMessage:@"" duration:TipNormalOverTime];}
- (void)postError:(NSString *)message duration:(CGFloat)duration { [self postError:message detailMessage:@"" duration:duration];}
- (void)postError:(NSString *)message detailMessage:(NSString *)detailMessage duration:(CGFloat)duration {
    [self configureLoading];
    if (![message length]) {
        message = LOCAL(ERROROTHER);
    }
    
    [self.loadingView postError:message detailMessage:detailMessage duration:duration];
}

#pragma mark - TTLoadingView Loading
- (void)postProgress:(float)progress {
    [self.loadingView postProgress:progress];
}

- (void)postLoadingBackgroundColor:(UIColor *)color {
    [self postLoading];
    self.loadingView.backgroundColor = color;
}

- (void)postLoading                                               { [self postLoading:@""];}
- (void)postLoading:(NSString *)message                           { [self postLoading:message message:@""];}
- (void)postLoading:(NSString *)title message:(NSString *)message { [self postLoading:title message:message overTime:TipLoadingOverTime];}
- (void)postLoading:(NSString *)title message:(NSString *)message overTime:(NSTimeInterval)second {
    [self configureLoading];
    [self.loadingView postLoading:title message:message overTime:second];
}


#pragma mark - TTLoadingView Hide
- (void)hideLoading {
    if (self.loadingView) {
        [self.loadingView hide:NO];
        [self TTLoadingViewDelgateCallHubWasHidden];
    }
}

@end
