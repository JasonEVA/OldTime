//
//  LifeStyleRecordsViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/28.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "LifeStyleRecordsViewController.h"
#import "ClientHelper.h"

@interface LifeStyleRecordsViewController ()
<UIWebViewDelegate>
{
    NSString* userId;
    UIWebView* webview;
}
@end

@implementation LifeStyleRecordsViewController

- (id) initWithUserId:(NSString*) aUserId
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        userId = aUserId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (webview || !userId || userId.length == 0)
    {
        return;
    }
    [self p_loadWebView];
}

- (void)refreshDataWithUserID:(NSString *)userID {
    userId = userID;
    [self p_loadWebView];
}

- (void)p_loadWebView {
    webview = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webview];
    
    [webview showWaitView];
    [webview setDelegate:self];
    [webview.scrollView setShowsVerticalScrollIndicator:NO];
    [webview sizeToFit];
    [webview scalesPageToFit];
    
    NSString* requestUrl = [NSString stringWithFormat:@"%@/liferecord.htm?vType=YS&userId=%@", kZJKHealthDataBaseUrl, userId];
    
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [webView closeWaitView];
    
}

@end
