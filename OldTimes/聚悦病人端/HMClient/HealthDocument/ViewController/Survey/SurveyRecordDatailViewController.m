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
    SurveyRecord* record;
}
@end

@implementation SurveyRecordDatailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (self.paramObject && [self.paramObject isKindOfClass:[SurveyRecord class]])
    {
        record = (SurveyRecord*)self.paramObject;
        [self.navigationItem setTitle:record.surveyMoudleName];
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
    
    if (record.fillTime && 0 < record.fillTime.length)
    {
        [self createSurveyRecordFilledTable];
        
    }else
    {
        [self createSurveyRecordNotFilledTable];
    }

}

- (void) createSurveyRecordFilledTable
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/jkda/jkda_sfjl.htm?vType=YH&recordId=%@",kZJKHealthDataBaseUrl, record.surveyId];

    [surveyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
}

- (void) createSurveyRecordNotFilledTable
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/jkda/jkda_sfjl_bj.htm?vType=YH&recordId=%@&userId=%@", kZJKHealthDataBaseUrl,record.surveyId,record.userId];

    [surveyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
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
        //        UIViewController *viewCtl = self.navigationController.viewControllers[2];
        //
        //        [self.navigationController popToViewController:viewCtl animated:YES];
        
        return NO;
    }
    return YES;
}

@end
