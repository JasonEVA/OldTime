//
//  HealthBaseInfoStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/30.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthBaseInfoStartViewController.h"
#import "ClientHelper.h"

@interface HealthBaseInfoStartViewController ()
<UIWebViewDelegate>
{
    UIWebView* webview;
}
@end

@implementation HealthBaseInfoStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"基本信息"];
    
    webview = [[UIWebView alloc]init];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [webview showWaitView];
    [webview setDelegate:self];
    [webview.scrollView setShowsVerticalScrollIndicator:NO];
    [webview sizeToFit];
    [webview scalesPageToFit];
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    NSString* url = [NSString stringWithFormat:@"%@/jkda/basicInfo.htm?vType=YH&userId=%ld", kZJKHealthDataBaseUrl , curUser.userId];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark- webViewDelegate
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [webView closeWaitView];
    
}


@end
