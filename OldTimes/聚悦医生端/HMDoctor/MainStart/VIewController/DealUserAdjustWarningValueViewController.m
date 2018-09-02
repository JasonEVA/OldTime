//
//  DealUserAdjustWarningValueViewController.m
//  HMDoctor
//
//  Created by lkl on 16/8/9.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "DealUserAdjustWarningValueViewController.h"
#import "UserAlertInfo.h"
#import "ClientHelper.h"
#import "MainStartAlertTableViewController.h"
#import "HMSEPatientGroupChatViewController.h"

@interface DealUserAdjustWarningValueViewController ()<UIWebViewDelegate>
{
    UIWebView *webview;
    UserAlertInfo *alertInfo;
}
@end

@implementation DealUserAdjustWarningValueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (self.paramObject && [self.paramObject isKindOfClass:[UserAlertInfo class]])
    {
        alertInfo = (UserAlertInfo*)self.paramObject;
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%@预警值",alertInfo.testName]];
    }
    
    webview = [[UIWebView alloc]init];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/jkjh_warning.htm?vType=YS&type=TZYJZ&userId=%ld&kpiCode=%@&staffUserId=%ld&testResulId=%@&doWay=",kZJKHealthDataBaseUrl, alertInfo.userId ,alertInfo.kpiCode ,staff.userId,alertInfo.testResulId];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [webview showWaitView];
    [webview setDelegate:self];
    [webview loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //
    NSString *requestString = [[[request URL] absoluteString]stringByRemovingPercentEncoding];
    
    if ([requestString isEqualToString:@"exithtml5://HTML5.exit"])
    {
        //[self.navigationController popViewControllerAnimated:YES];
        [self backToMainStartAlertTableViewController];
        return NO;
    }
    return YES;
}

//返回到预警界面
- (void) backToMainStartAlertTableViewController
{
    NSArray* vcList = self.navigationController.viewControllers;
    
    [vcList enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, BOOL * _Nonnull stop) {
        //会话消息--预警处理
        if ([controller isKindOfClass:[MainStartAlertStartViewController class]] && [[vcList objectAtIndex:idx+1] isKindOfClass:[HMSEPatientGroupChatViewController class]]) {
            [self.navigationController popToViewController:[vcList objectAtIndex:idx+1] animated:YES];
            *stop = YES;
        }
        else{
            if ([controller isKindOfClass:[MainStartAlertStartViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                *stop = YES;
            }
        }
        
    }];
    
//    for (UIViewController* controller in vcList)
//    {
//        if ([controller isKindOfClass:[MainStartAlertStartViewController class]]) {
//            vcPatient = controller;
//            break;
//        }
//    }
//    if (vcPatient)
//    {
//        [self.navigationController popToViewController:vcPatient animated:YES];
//    }
}


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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
