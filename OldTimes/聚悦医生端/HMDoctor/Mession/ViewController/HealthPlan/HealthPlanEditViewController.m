//
//  HealthPlanEditViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HealthPlanEditViewController.h"
#import "HealthPlanMessionInfo.h"
#import "ClientHelper.h"
#import "HealthPlanEditJSModel.h"
#import "PatientInfo.h"

@interface HealthPlanEditViewController ()
<UIWebViewDelegate,HealthPlanEditJSModelDelegate>
{
    HealthPlanMessionInfo* planMession;
    StaffPrivilegeJSHelper* privilegeHelper;
    UIWebView* webview;
    
    BOOL helperHasBeenLoaded;
}
@end

@implementation HealthPlanEditViewController

- (void)dealloc {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"健康计划"];
    if (self.paramObject && [self.paramObject isKindOfClass:[HealthPlanMessionInfo class]])
    {
        planMession = (HealthPlanMessionInfo*)self.paramObject;
    }
    privilegeHelper = [StaffPrivilegeJSHelper new];
    [self.navigationItem setHidesBackButton:YES];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (webview) {
        [webview removeFromSuperview];
        webview = nil;
    }
    webview = [[UIWebView alloc]init];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    [self loadWebRequest];
}

- (void) loadWebRequest
{
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    NSString *str = [NSString stringWithFormat:@"%@/userHealthyPlanDetsEdit.htm?vType=YS&staffId=%ld&healthyPlanTempId=%@&healthyPlanId=%ld&id=%ld",kZJKHealthDataBaseUrl, curStaff.staffId, planMession.healthyPlanTempId, planMession.healthyId, planMession.userId];
    
    NSString *encodedStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedStr]];
    [webview showWaitView];
    [webview setDelegate:self];
    [webview loadRequest:request];

}

- (void) reloadWebRequest
{
    [webview removeFromSuperview];
    webview = [[UIWebView alloc]init];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];

    [self loadWebRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backClick {
    if (webview.canGoBack) {
        [webview goBack];
    }
    else {
        if (self.navigationController.childViewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            return;
        }
    }
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[[request URL] absoluteString]stringByRemovingPercentEncoding];
    
    if ([requestString isEqualToString:@"exithtml5://HTML5.exit"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    
    if ([[request.URL lastPathComponent] isEqualToString:@"userHealthyPlanDetsEdit.htm"])
    {
        if (!helperHasBeenLoaded)
        {
            //第一次加载
            helperHasBeenLoaded = YES;
        }
        else
        {
            //数据更新，重新加载
            helperHasBeenLoaded = NO;
            [self performSelector:@selector(reloadWebRequest) withObject:nil afterDelay:0.3];
            return NO;
        }
    }
    
    return YES;
}


- (void) webViewDidStartLoad:(UIWebView *)webView
{

    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"h5_js"] = privilegeHelper;
    privilegeHelper.jsContext = context;
    privilegeHelper.webView = webView;
    context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webview closeWaitView];
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

    //通过模型注入，防止内存泄漏
    HealthPlanEditJSModel *model = [HealthPlanEditJSModel new];
    context[@"HMDoctorJS"] = model;
    model.jsContext = context;
    model.webView = webView;
    [model setDelegate:self];
    context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };

//    context[@"h5_js"] = privilegeHelper;
}

#pragma mark - HealthPlanEditJSModelDelegate
- (void)HealthPlanEditJSModelDelegateCallBack_withUserId:(NSString *)userId healthId:(NSString *)healthId {
    PatientInfo *info = [PatientInfo new];
    info.userId = userId.integerValue;
    info.healthId = healthId;
    info.age = planMession.age;
    info.sex = planMession.sex;
    info.userName = planMession.userName;
    [HMViewControllerManager createViewControllerWithControllerName:@"PrescribeCreateRecipeViewController" ControllerObject:info];

}
@end

@interface HealthPlanMakeViewController ()
<UIWebViewDelegate>
{
    HealthPlanMessionInfo* planMession;
    StaffPrivilegeJSHelper* privilegeHelper;
    BOOL helperHasBeenLoaded;
    UIWebView* webview;
}
@end

@implementation HealthPlanMakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"健康计划"];
    privilegeHelper = [StaffPrivilegeJSHelper new];
    if (self.paramObject && [self.paramObject isKindOfClass:[HealthPlanMessionInfo class]])
    {
        planMession = (HealthPlanMessionInfo*)self.paramObject;
    }
    
    [self.navigationItem setHidesBackButton:YES];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
    webview = [[UIWebView alloc]init];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    NSString* staffRole = [[UserInfoHelper defaultHelper] staffRole];
    
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    NSString *str = [NSString stringWithFormat:@"%@/getHealtyPlanTemplate.htm?vType=YS&healthyPlanTempId=%@&healthyPlanId=%ld&id=%ld&staffId=%ld&staffRole=%@&typeCode=healthy",kZJKHealthDataBaseUrl, planMession.healthyPlanTempId, planMession.healthyId, planMession.userId,curStaff.staffId, staffRole];
    
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

- (void)backClick {
    if (webview.canGoBack) {
        [webview goBack];
    }
    else {
        if (self.navigationController.childViewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            return;
        }
    }
}

- (void) reloadWebRequest:(NSURLRequest *)request
{
    [webview removeFromSuperview];
    webview = [[UIWebView alloc]init];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    [webview showWaitView];
    [webview setDelegate:self];
    [webview loadRequest:request];
    
   
}



#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[[request URL] absoluteString]stringByRemovingPercentEncoding];
    
    if ([requestString isEqualToString:@"exithtml5://HTML5.exit"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        
        return NO;
    }
    //userHealthyPlanDetsEdit.htm
    if ([[request.URL lastPathComponent] isEqualToString:@"userHealthyPlanDetsEdit.htm"])
    {

        
        if (!helperHasBeenLoaded)
        {
            //第一次加载
            helperHasBeenLoaded = YES;
            [self performSelector:@selector(reloadWebRequest:) withObject:request afterDelay:0.3];
            return NO;
        }
        else
        {
            //数据更新，重新加载
            helperHasBeenLoaded = NO;
            
            return YES;
        }
    }
    
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"h5_js"] = privilegeHelper;
    privilegeHelper.jsContext = context;
    privilegeHelper.webView = webView;
    context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    
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
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"h5_js"] = privilegeHelper;
    privilegeHelper.jsContext = context;
    privilegeHelper.webView = webView;
    context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };

}

@end
