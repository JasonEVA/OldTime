//
//  PatientBaseInfoViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientBaseInfoViewController.h"
#import "PatientInfo.h"
#import "ClientHelper.h"

@interface PatientBaseInfoViewController ()
<UIWebViewDelegate>
{
    PatientInfo* patient;
    UIWebView* webview;
}
@end

@implementation PatientBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"基本信息"];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[PatientInfo class]])
    {
        patient = (PatientInfo*) self.paramObject;
    }
    
    webview = [[UIWebView alloc]init];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [webview showWaitView];
    [webview setDelegate:self];
    [webview.scrollView setShowsVerticalScrollIndicator:NO];
    [webview sizeToFit];
    [webview scalesPageToFit];
    
    NSString* url = [NSString stringWithFormat:@"%@/jkda/basicInfo.htm?vType=YS&userId=%ld", kZJKHealthDataBaseUrl , patient.userId];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- webViewDelegate
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [webView closeWaitView];
    
}

@end
