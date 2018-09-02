//
//  RoundsTemplateDetailViewController.m
//  HMDoctor
//
//  Created by yinquan on 16/9/5.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "RoundsTemplateDetailViewController.h"
#import "RoundsTemplateModel.h"
#import "ClientHelper.h"
#import "HMSEPatientGroupChatViewController.h"

@interface RoundsTemplateDetailViewController ()
<UIWebViewDelegate>
{
    RoundsTemplateWithUserModel* templateModel;
    
//    UIButton* commitButton;
}
@property (nonatomic, readonly) UIWebView* webview;
@end

@implementation RoundsTemplateDetailViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"查房表详情"];
    if (self.paramObject && [self.paramObject isKindOfClass:[RoundsTemplateWithUserModel class]])
    {
        templateModel = (RoundsTemplateWithUserModel*) self.paramObject;
    }
    
    [self createWebview];
    

}

- (void)createWebview
{
    _webview = [[UIWebView alloc] init];
    
    [self.view addSubview:_webview];
    
    [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [_webview showWaitView];
    [_webview setDelegate:self];
    [_webview.scrollView setShowsVerticalScrollIndicator:NO];
    [_webview sizeToFit];
    [_webview scalesPageToFit];
    
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    //&flag=1 带使用按钮
    NSString *requestUrl = [NSString stringWithFormat:@"%@/newc/pingg/pinggb_detail.htm?vType=YS&moudleId=%ld&userId=%@&staffUserId=%ld&flag=1",kZJKHealthDataBaseUrl, templateModel.templateId, templateModel.targetUserId,staff.userId];
    
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [webView showWaitView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView closeWaitView];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [webView closeWaitView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[[request URL] absoluteString]stringByRemovingPercentEncoding];
    
    if ([requestString isEqualToString:@"exithtml5://HTML5.exit"])
    {
        [self backToPatientDetailController];
        //        UIViewController *viewCtl = self.navigationController.viewControllers[2];
        //
        //        [self.navigationController popToViewController:viewCtl animated:YES];
        
        return NO;
    }
    return YES;
}

//返回到患者详情界面
- (void) backToPatientDetailController
{
    NSArray* vcList = self.navigationController.viewControllers;
    UIViewController* vcPatient = nil;
    
    for (UIViewController* controller in vcList)
    {
        if ([controller isKindOfClass:[HMSEPatientGroupChatViewController class]]) {
            vcPatient = controller;
            break;
        }

    }
    
    if (vcPatient)
    {
        [self.navigationController popToViewController:vcPatient animated:YES];
    }
}

@end
