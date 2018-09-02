//
//  HMFastInGroupViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/4/21.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMFastInGroupViewController.h"
#import "FastInGroupJSModel.h"
#import "ClientHelper.h"

@interface HMFastInGroupViewController ()<UIWebViewDelegate,FastInGroupJSModelDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) JSContext *context;

@end

@implementation HMFastInGroupViewController
- (void)dealloc {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor mainThemeColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    [self.navigationItem setHidesBackButton:YES];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    UIBarButtonItem *leftCloseBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(popVC)];
    [self.navigationItem setLeftBarButtonItems:@[leftBtn,leftCloseBtn]];

    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.delegate = self;
    NSString *urlStr = [NSString stringWithFormat:@"%@/html/inGroup/login.html?vType=YH&",kZKSRZBaseUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    // Do any additional setup after loading the view.
}
- (void)backClick {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)popVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealWithJS:(UIWebView *)webView {
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //通过模型注入，防止内存泄漏
    FastInGroupJSModel *model = [FastInGroupJSModel new];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)FastInGroupJSModelDelegateCallBack_getTitel:(NSString *)titel {
    [self setTitle:titel];
}

- (void)FastInGroupJSModelDelegateCallBack_goAddRecord:(NSString *)userId{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController dismissViewControllerAnimated:NO completion:^{
            [HMViewControllerManager createViewControllerWithControllerName:@"BodyDetectStartViewController" ControllerObject:userId];
        }];
    });
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
