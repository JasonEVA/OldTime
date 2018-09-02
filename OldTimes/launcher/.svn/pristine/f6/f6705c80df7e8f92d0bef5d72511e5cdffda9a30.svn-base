//
//  WebViewController.m
//  launcher
//
//  Created by williamzhang on 15/11/12.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "WebViewController.h"
#import <NJKWebViewProgress/NJKWebViewProgressView.h>
#import <NJKWebViewProgress/NJKWebViewProgress.h>
#import <AFNetworking/AFNetworking.h>
#import <Masonry/Masonry.h>

@interface WebViewController () <UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;

@property (nonatomic, readonly) NSString *url;
@property (nonatomic, readonly) BOOL     shouldDownload;

@end

@implementation WebViewController

- (instancetype)initWithURL:(NSString *)url {
    return [self initWithURL:url shouldDownload:NO];
}

- (instancetype)initWithURL:(NSString *)url shouldDownload:(BOOL)shouldDownload {
    self = [super init];
    if (self) {
        _url = url;
        _shouldDownload = shouldDownload;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self isRootViewController]) {
        [self showLeftItemWithSelector:@selector(dismissVC)];
    }
    
    if (self.shouldDownload) {
        [self downloadFile];
        return;
    }
    
    [self showWebViewWithURL:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController.navigationBar addSubview:self.progressView];
    if ([self isRootViewController]) {
        [self leftItemNumber:0];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}

- (BOOL)isRootViewController {
    return [self.navigationController.viewControllers firstObject] == self;
}

#pragma mark - Private Method
- (void)downloadFile {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *url = [[NSURL alloc] initWithString:self.url];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *temporaryPath = NSTemporaryDirectory();
        temporaryPath = [temporaryPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:temporaryPath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [self showWebViewWithURL:filePath];
    }];
    
    [task resume];
    NSProgress *progress;
    [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)showWebViewWithURL:(NSURL *)filePath {
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    if (self.shouldDownload) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:filePath]];
        return;
    }
    
    NSURL *url = [self canOpenURL];
    if (url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        return;
    }
    
    [self.webView loadHTMLString:self.url baseURL:nil];
}

- (NSURL *)canOpenURL {
    NSURL *url = [NSURL URLWithString:self.url];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        return url;
    }
    
    return nil;
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        NSProgress *progress = (NSProgress *)object;
        [self.progressView setProgress:progress.fractionCompleted animated:YES];
    }
}

#pragma mark - NJKWebViewProgress Delegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [self.progressView setProgress:progress animated:YES];
    if ([self canOpenURL] == nil || self.shouldDownload) {
        [self.progressView setProgress:1 animated:YES];
    }
}

#pragma mark - Initializer
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self.progressProxy;
    }
    return _webView;
}

- (NJKWebViewProgressView *)progressView {
    if (!_progressView) {
        CGFloat progressBarHeight = 2.0;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _progressView;
}

- (NJKWebViewProgress *)progressProxy {
    if (!_progressProxy) {
        _progressProxy = [NJKWebViewProgress new];
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
    }
    return _progressProxy;
}

@end
