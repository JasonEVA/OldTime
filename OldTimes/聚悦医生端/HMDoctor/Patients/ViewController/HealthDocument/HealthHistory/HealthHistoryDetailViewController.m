//
//  HealthHistoryDetailViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//
#import "ClientHelper.h"

#import "HealthHistoryDetailViewController.h"
#import "HealthHistoryItem.h"

@interface HealthHistoryDetailViewController ()
<UIWebViewDelegate>
{
    UIWebView* webview;
}
@end

@implementation HealthHistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    webview = [[UIWebView alloc]init];
    [self.view addSubview:webview];
    
    [self subviewLayout];
    if (self.paramObject && [self.paramObject isKindOfClass:[HealthHistoryItem class]])
    {
        HealthHistoryItem* history = (HealthHistoryItem*) self.paramObject;
        [self.navigationItem setTitle:history.docuType];
        
        NSString *str;
        if (!kStringIsEmpty(history.StoragePath)) {
            str = history.StoragePath;
        }
        else{
            str = [NSString stringWithFormat:@"%@/jkda/jksInfo.htm?docuRegId=%@&storageId=%@&orgName=%@&docuType=%@&consoletype=1",kZJKHealthDataBaseUrl,history.docuRegID,history.storageID,history.visitOrgTitle,history.docuType];
        }
        
        NSString *encodedStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedStr]];
        [webview showWaitView];
        [webview setDelegate:self];
        [webview loadRequest:request];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) subviewLayout
{
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.view);
        make.bottom.and.right.equalTo(self.view);
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIWebViewDelegate

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

@end
