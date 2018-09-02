//
//  EvaluationUnFilledDetailViewController.m
//  HMClient
//
//  Created by lkl on 16/9/8.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "EvaluationUnFilledDetailViewController.h"
#import "ClientHelper.h"

@interface EvaluationUnFilledDetailViewController ()
<UIWebViewDelegate>
{
    NSString* recordId;
}
@property (nonatomic, strong) UIWebView *webview;
@end

@implementation EvaluationUnFilledDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"填写评估"];
    
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
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/newc/pingg/pinggb_edit.htm?vType=YH&recordId=%@&userId=%ld", kZJKHealthDataBaseUrl,recordId ,curUser.userId];
    
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
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
