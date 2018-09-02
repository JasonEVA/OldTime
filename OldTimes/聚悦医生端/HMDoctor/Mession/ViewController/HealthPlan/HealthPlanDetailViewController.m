//
//  HealthPlanDetailViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HealthPlanDetailViewController.h"
#import "HealthPlanMessionInfo.h"
#import "ClientHelper.h"

@interface HealthPlanDetailViewController ()
<UIWebViewDelegate>
{
    HealthPlanMessionInfo* planMession;
    UIWebView* webview;
}
@end

@implementation HealthPlanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"健康计划"];
    if (self.paramObject && [self.paramObject isKindOfClass:[HealthPlanMessionInfo class]])
    {
        planMession = (HealthPlanMessionInfo*)self.paramObject;
    }
    
    webview = [[UIWebView alloc]init];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    //NSString *str = [NSString stringWithFormat:@"%@/userHealthyPlanDets.htm?healthyPlanId=%ld&id=%ld",kZJKHealthDataBaseUrl, planMession.healthyId ,planMession.userId];
    NSString *str = [NSString stringWithFormat:@"%@/userHealthyPlanDets.htm?vType=YS&id=%ld",kZJKHealthDataBaseUrl, planMession.userId];
    if (0 != planMession.healthyId)
    {
        str = [str stringByAppendingFormat:@"&healthyPlanId=%ld", planMession.healthyId];
    }
    NSString *encodedStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedStr]];
    [webview showWaitView];
    [webview setDelegate:self];
    [webview loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [webview closeWaitView];
    if ([error code] == NSURLErrorCancelled)
    {
        return;
    }
    [self showAlertMessage:[NSString stringWithFormat:@"%@",error]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webview closeWaitView];
}

@end
