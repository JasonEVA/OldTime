//
//  RoundsUnFilledDetailViewController.m
//  HMClient
//
//  Created by lkl on 16/9/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "RoundsUnFilledDetailViewController.h"
#import "ClientHelper.h"

@interface RoundsUnFilledDetailViewController ()
<UIWebViewDelegate>
{
    NSString* recordId;
}
@property (nonatomic, strong) UIWebView *webview;
@end

@implementation RoundsUnFilledDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"填写查房"];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]])
    {
        recordId = (NSString*) self.paramObject;
    }
    
    _webview = [[UIWebView alloc]init];
    [self.view addSubview:_webview];
    
    [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [_webview showWaitView];
    [_webview setDelegate:self];
    [_webview.scrollView setShowsVerticalScrollIndicator:NO];
    [_webview sizeToFit];
    [_webview scalesPageToFit];
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/jkda/jkda_sfjl_bj.htm?vType=YH&recordId=%@&userId=%ld", kZJKHealthDataBaseUrl,recordId ,curUser.userId];
//
//    NSString *requestUrl = [NSString stringWithFormat:@"%@/newc/pingg/pinggb_edit.htm?vType=YH&recordId=%@&userId=%ld", kZJKHealthDataBaseUrl,recordId ,curUser.userId];
    
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- webViewDelegate
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [webView closeWaitView];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[[request URL] absoluteString]stringByRemovingPercentEncoding];
    
    if ([requestString isEqualToString:@"exithtml5://HTML5.exit"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}

@end
