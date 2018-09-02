//
//  HMPingAnPayAddCardViewController.m
//  HMClient
//
//  Created by jasonwang on 2016/11/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMPingAnPayAddCardViewController.h"
//#import "HMPingAnPayJSModel.h"
#import "HMPingAnPayParmsModel.h"
//#import "NSURLRequest+IgnoreSSL.h"

@interface HMPingAnPayAddCardViewController ()<UIWebViewDelegate,HMPingAnPayJSModelDlegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) JSContext *context;
@property (nonatomic) BOOL authenticated;
@property (nonatomic, strong) NSURLRequest *request;
@end

@implementation HMPingAnPayAddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"绑定银行卡"];
    self.webView = [[UIWebView alloc]init];
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.webView setDelegate:self];
    [self.webView sizeToFit];
    [self.webView scalesPageToFit];
    
    NSURL* url = [NSURL URLWithString:self.model.openCardUrl];
    self.request = [NSURLRequest requestWithURL:url] ;
    [self.webView loadRequest:self.request];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.delegate respondsToSelector:@selector(HMPingAnPayAddCardViewControllerDelegateCallBack_reLoadCardList)]) {
        [self.delegate HMPingAnPayAddCardViewControllerDelegateCallBack_reLoadCardList];
    }

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //通过模型注入，防止内存泄漏
    HMWebViewJSHelper *model = [HMWebViewJSHelper new];
    model.parmsModel = self.model;
    self.context[@"ClientJSImpl_iOS"] = model;
    model.jsContext = self.context;
    model.webView = self.webView;
    [model setDelegate:self];
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
//- (void)HMPingAnPayJSModelDlegateCallBack_jsonString:(NSString *)jsonString {
//    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.ClientJSImpl.getOrigParams(%@);",jsonString]];
//}
# pragma mark - HMPingAnPayJSModelDlegate
- (void)HMPingAnPayJSModelDlegateCallBack_pop {
    [self.navigationController popViewControllerAnimated:YES];
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
