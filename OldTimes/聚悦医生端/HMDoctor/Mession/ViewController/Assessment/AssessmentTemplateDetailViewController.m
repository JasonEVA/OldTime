//
//  AssessmentTemplateDetailViewController.m
//  HMDoctor
//
//  Created by lkl on 16/8/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AssessmentTemplateDetailViewController.h"
#import "AssessmentMessionModel.h"
#import "ClientHelper.h"
#import "HMSEPatientGroupChatViewController.h"

@interface AssessmentTemplateDetailViewController ()<UIWebViewDelegate>
{
    AssessmentTemplateModel *templateModel;
}
@property (nonatomic, strong)UIWebView *webview;
@property (nonatomic, strong)UIButton *useButton;

@property (nonatomic, assign)NSInteger templateId;
//患者id
@property (nonatomic, copy)NSString *patientUserId;

@end

@implementation AssessmentTemplateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"评估表详情"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[AssessmentTemplateModel class]])
    {
        templateModel = (AssessmentTemplateModel *)self.paramObject;
        _templateId = templateModel.templateId;
        _patientUserId = templateModel.patientUserId;
    }
    
    [self createWebview];
}

- (void)createWebview
{
    /*_useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_useButton];
    [_useButton setBackgroundColor:[UIColor mainThemeColor]];
    [_useButton setTitle:@"使用" forState:UIControlStateNormal];
    [_useButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_useButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_useButton addTarget:self action:@selector(useButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.bottom.equalTo(self.view).with.offset(-10);
        make.height.mas_equalTo(@40);
    }];*/
    
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
    NSString *requestUrl = [NSString stringWithFormat:@"%@/newc/pingg/pinggb_detail.htm?vType=YS&moudleId=%ld&userId=%@&staffUserId=%ld&flag=1",kZJKHealthDataBaseUrl, _templateId, _patientUserId,staff.userId];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
