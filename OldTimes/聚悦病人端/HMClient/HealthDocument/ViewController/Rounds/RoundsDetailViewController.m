//
//  RoundsDetailViewController.m
//  HMClient
//
//  Created by lkl on 16/9/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "RoundsDetailViewController.h"
#import "ClientHelper.h"

@interface RoundsDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) UIWebView *webview;

@end

@implementation RoundsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.navigationItem setTitle:@"查房详情"];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]])
    {
        _itemId = (NSString *)self.paramObject;
    }
    
    _webview = [[UIWebView alloc] init];
    [self.view addSubview:_webview];
    
    [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_webview showWaitView];
    [_webview setDelegate:self];
    [_webview.scrollView setShowsVerticalScrollIndicator:NO];
    [_webview sizeToFit];
    [_webview scalesPageToFit];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/jkda/jkda_sfjl.htm?vType=YH&recordId=%@", kZJKHealthDataBaseUrl,_itemId];
    
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [webView showWaitView];
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    HMWebViewJSHelper* privilegeHelper = [HMWebViewJSHelper new];
    context[@"h5_js"]=privilegeHelper;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView closeWaitView];
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
