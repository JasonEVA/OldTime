//
//  HMNoticeWindowViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/7/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMNoticeWindowViewController.h"
#import "ClientHelper.h"
#import "HMDoctorNoticeWindowJSModel.h"
#import "HMNoticeWindowSharePatientViewController.h"
#import "HMBaseNavigationViewController.h"
#import "HMNoticeWindowShareToWorkViewController.h"

#define TYPE_IOS    @"HMDoctorType_iOS"    // 区分iOS样式
@interface HMNoticeWindowViewController ()<UIWebViewDelegate,HMDoctorNoticeWindowJSModelDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) JSContext *context;
@property (nonatomic, copy) NSString *url;

@end

@implementation HMNoticeWindowViewController

- (instancetype)initWithUrl:(NSString *)urlString {
    if (self = [super init]) {
        self.url = urlString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.delegate = self;
    [self.webView setAllowsInlineMediaPlayback:NO];
    _webView.mediaPlaybackRequiresUserAction = YES;

    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    
    NSString *webUrl = @"";
    if (self.url && self.url.length) {
        webUrl = [NSString stringWithFormat:@"%@&type=%@",self.url,TYPE_IOS];
    }
    else {
        webUrl = [NSString stringWithFormat:@"%@/ggc/ggc.htm?userId=%ld&type=%@",kZJKHealthDataBaseUrl,(long)user.userId,TYPE_IOS];

    }
    NSURL *url = [NSURL URLWithString:webUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
//    self.webView.scrollView setbs
    // Do any additional setup after loading the view.
}
- (void)dealWithJS:(UIWebView *)webView {
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //通过模型注入，防止内存泄漏
    HMDoctorNoticeWindowJSModel *model = [HMDoctorNoticeWindowJSModel new];
    [model setDelegate:self];
    self.context[@"HMDoctorJS"] = model;
    model.jsContext = self.context;
    model.webView = self.webView;
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 3
    [self dealWithJS:webView];

}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    // 2
    [self dealWithJS:webView];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 1
    return YES;
}

#pragma mark HMDoctorNoticeWindowJSModelDelegate
- (void)HMDoctorNoticeWindowJSModelDelegateCallBack_SendClick:(SendType)type noteId:(NSString *)noteId {
    switch (type) {
        case SendType_Work:
        {
            // 工作组
            
            HMNoticeWindowShareToWorkViewController *VC = [HMNoticeWindowShareToWorkViewController new];

            VC.notId = noteId;
            HMBaseNavigationViewController *navVC = [[HMBaseNavigationViewController alloc] initWithRootViewController:VC];
            
            [self presentViewController:navVC animated:YES completion:nil];
            break;
        }
        case SendType_Patitent:
        {
            // 医患群
            HMNoticeWindowSharePatientViewController *VC = [HMNoticeWindowSharePatientViewController new];
            VC.notId = noteId;
            HMBaseNavigationViewController *navVC = [[HMBaseNavigationViewController alloc] initWithRootViewController:VC];
            
            [self presentViewController:navVC animated:YES completion:nil];
            break;
        }
        case Back:
        {
            //返回
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
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

@end
