//
//  HealthReportDetailViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthReportDetailViewController.h"
#import "HealthReport.h"
#import "ClientHelper.h"
#import "NewSiteMessageHealthReportModel.h"

@interface HealthReportDetailViewController ()
<UIWebViewDelegate>
{
//    HealthReport* report;
    NewSiteMessageHealthReportModel *healthReportModel;
    NSString* healthyReportId;
    UIWebView* webview;
    NSString *requestUrlStr;
}
@end

@implementation HealthReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    //健康报告
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]]){
//        if ( [self.paramObject isKindOfClass:[HealthReport class]]) {
//            report = (HealthReport*)self.paramObject;
//            healthyReportId = report.healthyReportId;
//        }
        [self.navigationItem setTitle:@"健康报告"];
        healthyReportId = self.paramObject;
        requestUrlStr = [NSString stringWithFormat:@"%@/dealWithHealthyReport.htm?vType=YH&healthyReportId=%@&staffUserId=%ld",kZJKHealthDataBaseUrl, healthyReportId ,curUser.userId];
    }
        
    if (self.paramObject && [self.paramObject isKindOfClass:[NewSiteMessageHealthReportModel class]]) {
        healthReportModel = self.paramObject;
        
        //健康报告
        if ([healthReportModel.type isEqualToString:@"healthyReportDetPage"]) {
            [self.navigationItem setTitle:@"健康报告"];
            requestUrlStr = [NSString stringWithFormat:@"%@/dealWithHealthyReport.htm?vType=YH&healthyReportId=%@&staffUserId=%ld",kZJKHealthDataBaseUrl, healthReportModel.healthyReportId ,curUser.userId];
        }
        
        //饮食评估报告  饮食记录
        if ([healthReportModel.type isEqualToString:@"dietDetailPage"]) {
            [self.navigationItem setTitle:healthReportModel.msgTitle];
            requestUrlStr = healthReportModel.jumpUrl;
        }
    }
    
    [self createWebViewWithRequestUrl:requestUrlStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createWebViewWithRequestUrl:(NSString *)requestUrl
{
    if (webview)
    {
        return;
    }
    
    webview = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];

    NSString *encodedStr = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedStr]];
    [webview showWaitView];
    [webview setDelegate:self];
    [webview loadRequest:request];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [webView closeWaitView];
    //修改健康报告已读状态
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:healthyReportId forKey:@"healthyReportId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthReportReadedMarkTask" taskParam:dicPost TaskObserver:nil];
}

@end
