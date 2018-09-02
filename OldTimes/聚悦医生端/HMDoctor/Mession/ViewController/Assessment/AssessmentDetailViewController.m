//
//  AssessmentDetailViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AssessmentDetailViewController.h"
#import "ClientHelper.h"

@interface AssessmentDetailViewController ()
<UIWebViewDelegate>

@end

@implementation AssessmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.paramObject && [self.paramObject isKindOfClass:[AssessmentRecordModel class]])
    {
        _assessmentRecord = (AssessmentRecordModel*)self.paramObject;
    
    }
    _webview = [[UIWebView alloc]init];
    [self.view addSubview:_webview];
    [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    [_webview setDelegate:self];
    [self loadDetail];
}

- (void) loadDetail
{
    [self.view showWaitView];
    NSString* urlString = [self assessmentDetailWebUrl];
    if (!urlString)
    {
        return;
    }
    NSURL* webUrl = [NSURL URLWithString:urlString];
    [_webview loadRequest:[NSURLRequest requestWithURL:webUrl]];
}

- (NSString*) assessmentDetailWebUrl
{
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSString* webUrl = [NSString stringWithFormat:@"%@/newc/pingg/danxpg_detail.htm?vType=YS&recordId=%@&operatorUserId=%ld&type=3", kZJKHealthDataBaseUrl, _assessmentRecord.assessmentReportId, staff.userId];
    return webUrl;
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

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.view showWaitView];
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    StaffPrivilegeJSHelper* privilegeHelper = [StaffPrivilegeJSHelper new];
    context[@"h5_js"]=privilegeHelper;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view closeWaitView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.view closeWaitView];
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

@interface AssessmentSummaryViewController ()
{
    
}

@end

@implementation AssessmentSummaryViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"阶段评估报告"];
}

- (NSString*) assessmentDetailWebUrl
{
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSString* webUrl = [NSString stringWithFormat:@"%@/newc/pingg/danxpg_detail.htm?vType=YS&recordId=%@&operatorUserId=%ld&type=2", kZJKHealthDataBaseUrl, self.assessmentRecord.assessmentReportId, staff.userId];
    return webUrl;
}

@end
