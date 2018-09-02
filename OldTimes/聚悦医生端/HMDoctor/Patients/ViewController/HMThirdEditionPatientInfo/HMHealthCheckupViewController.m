//
//  HMHealthCheckupViewController.m
//  HMDoctor
//
//  Created by lkl on 2017/3/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMHealthCheckupViewController.h"
#import "ClientHelper.h"
#import "HealthyEdcucationJSHelper.h"

@interface HMHealthCheckupViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *admissionId;
@property (nonatomic, readonly) HealthyEdcucationJSHelper* jsHelper;
@end

@implementation HMHealthCheckupViewController

- (instancetype)initWithUserID:(NSString *)userID admissionId:(NSString *)admissionId
{
    self = [super init];
    if (self) {
        _userId = userID;
        _admissionId = admissionId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor orangeColor]];
    
    _jsHelper = [[HealthyEdcucationJSHelper alloc] init];
    [self.jsHelper setController:self];

    
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self refreshData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createDateChanged:) name:@"OnlineArchivesDateChangedNotification" object:nil];
}

- (void)createDateChanged:(NSNotification *)notification
{
    self.admissionId = [notification object];
    [self refreshData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshData{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/newc/zyda/zyda_tgjc.htm?vType=YS&admissionId=%@&type=1",kZJKHealthDataBaseUrl,_admissionId]];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [webView showWaitView];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [webView closeWaitView];
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"h5_js"] = self.jsHelper;
}

- (UIWebView *)webView{
    if (!_webView){
        _webView = [[UIWebView alloc] init];
        [_webView setDelegate:self];
        [_webView.scrollView setShowsVerticalScrollIndicator:NO];
        [_webView sizeToFit];
        [_webView scalesPageToFit];
    }
    return _webView;
}

@end
