//
//  SurveyRecordDatailViewController.m
//  HMClient
//
//  Created by lkl on 16/5/26.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SurveyRecordDatailViewController.h"
#import "ClientHelper.h"

@interface SurveyRecordDatailViewController ()<TaskObserver,UIWebViewDelegate>
{
    UIWebView *surveyWebView;
}
@end

@implementation SurveyRecordDatailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (self.paramObject && [self.paramObject isKindOfClass:[SurveyRecord class]])
    {
        _record = (SurveyRecord*)self.paramObject;
    }
    if (_record.surveyMoudleName && 0 < _record.surveyMoudleName.length)
    {
        [self.navigationItem setTitle:self.record.surveyMoudleName];
    }
    else
    {
        [self.navigationItem setTitle:@"随访详情"];
    }
    
    
    surveyWebView = [[UIWebView alloc]init];
    [self.view addSubview:surveyWebView];
    
    [surveyWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [surveyWebView showWaitView];
    [surveyWebView setDelegate:self];
    [surveyWebView.scrollView setShowsVerticalScrollIndicator:NO];
    [surveyWebView sizeToFit];
    [surveyWebView scalesPageToFit];
    
    //判断是否拥有回复随访的权限
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    BOOL replyPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeSurveyMode Status:self.record.status OperateCode:kPrivilegeReplyOperate];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/jkda/jkda_sfjl.htm?vType=YS&recordId=%@&staffId=%ld",kZJKHealthDataBaseUrl, self.record.surveyId, staff.staffId];
    if (replyPrivilege)
    {
        //拥有回复随访权限
    }
    [surveyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
}



- (void) createSurveyRecordFilledTable
{
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/jkda/jkda_sfjl.htm?vType=YS&recordId=%@&staffId=%ld",kZJKHealthDataBaseUrl, self.record.surveyId, staff.staffId];
//    NSString *requestUrl = [NSString stringWithFormat:@"%@/jkda/jkda_sfjl_bj.htm?vType=YS&recordId=%@&userId=%@", kZJKHealthDataBaseUrl,self.record.surveyId,self.record.userId];
    [surveyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
}

- (void) createSurveyRecordNotFilledTable
{
//    NSString *requestUrl = [NSString stringWithFormat:@"%@/jkda/jkda_sfjl_bj.htm?vType=YS&recordId=%@&userId=%@", kZJKHealthDataBaseUrl,self.record.surveyId,self.record.userId];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/jkda/jkda_sfjl.htm?vType=YS&recordId=%@&staffId=%ld",kZJKHealthDataBaseUrl, self.record.surveyId, staff.staffId];
    [surveyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
}



#pragma mark- webViewDelegate

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

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    StaffPrivilegeJSHelper* privilegeHelper = [StaffPrivilegeJSHelper new];
    context[@"h5_js"]=privilegeHelper;
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [webView closeWaitView];

    
}



@end
