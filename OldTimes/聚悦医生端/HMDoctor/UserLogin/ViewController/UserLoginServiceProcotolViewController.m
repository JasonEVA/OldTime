//
//  UserLoginServiceProcotolViewController.m
//  HMDoctor
//
//  Created by lkl on 16/7/1.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserLoginServiceProcotolViewController.h"
#import "ClientHelper.h"

@interface UserLoginServiceProcotolViewController ()<UIWebViewDelegate>
{
    UIWebView* webview;
}
@end

@implementation UserLoginServiceProcotolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationItem setTitle:@"服务协议"];
    
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
    
    NSString* requestUrl = [NSString stringWithFormat:@"%@/fuwxy_ys.htm", kZJKHealthDataBaseUrl];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
