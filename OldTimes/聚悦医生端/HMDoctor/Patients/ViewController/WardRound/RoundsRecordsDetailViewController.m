//
//  RoundsDetailViewController.m
//  HMDoctor
//
//  Created by lkl on 16/9/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "RoundsRecordsDetailViewController.h"
#import "ClientHelper.h"

@interface RoundsRecordsDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) UIWebView *webview;

@end

@implementation RoundsRecordsDetailViewController

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
    //[_webview setFrame:self.view.bounds];
    [self.view addSubview:_webview];
    
    [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    [_webview showWaitView];
    [_webview setDelegate:self];
    [_webview.scrollView setShowsVerticalScrollIndicator:NO];
    [_webview sizeToFit];
    [_webview scalesPageToFit];
    
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSString* requestUrl = [NSString stringWithFormat:@"%@/newc/pingg/danxpg_detail.htm?vType=YS&recordId=%@&operatorUserId=%ld", kZJKHealthDataBaseUrl, _itemId, staff.userId];
    
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.view showWaitView];
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    StaffPrivilegeJSHelper* privilegeHelper = [StaffPrivilegeJSHelper new];
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
