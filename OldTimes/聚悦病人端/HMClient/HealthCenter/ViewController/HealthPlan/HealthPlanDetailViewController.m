//
//  HealthPlanDetailViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/28.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthPlanDetailViewController.h"
#import "HealthPlanInfo.h"
#import "ClientHelper.h"

@interface HealthPlanDetailViewController ()
<UIWebViewDelegate>
{
    HealthPlanInfo* healthPlan;
    UIWebView* webview;
}
@end

@implementation HealthPlanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"健康计划"];
    if (self.paramObject && [self.paramObject isKindOfClass:[HealthPlanInfo class]])
    {
        healthPlan = (HealthPlanInfo*) self.paramObject;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!healthPlan)
    {
        return;
    }
    if (!webview)
    {
        webview = [[UIWebView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:webview];
        
        [webview showWaitView];
        [webview setDelegate:self];
        [webview.scrollView setShowsVerticalScrollIndicator:NO];
        [webview sizeToFit];
        [webview scalesPageToFit];
        
        NSString* requestUrl = [NSString stringWithFormat:@"%@/userHealthyPlanDets.htm?vType=YH&id=%@&healthyPlanId=%@", kZJKHealthDataBaseUrl, healthPlan.userId, healthPlan.healthyPlanId];
        //NSString* requestUrl = [NSString stringWithFormat:@"http://10.0.0.117:7003/jkjh_gw_hzlb.htm?staffId=2022222&staffRole=adviser"];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
    }
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [webView closeWaitView];
    
}
@end
