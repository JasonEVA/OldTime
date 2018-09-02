//
//  SurveyMoudleDetailViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "SurveyMoudleDetailViewController.h"
#import "SurveyRecord.h"
#import "ClientHelper.h"

@interface SurveyMoudleDetailViewController ()
<UIWebViewDelegate>
{
    UIWebView* webview;
}

@property (nonatomic, readonly) SurveryMoudle* surveyMoudle;
@end

@implementation SurveyMoudleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"模版预览"];
    if (self.paramObject && [self.paramObject isKindOfClass:[SurveryMoudle class]])
    {
        _surveyMoudle = (SurveryMoudle*)self.paramObject;
    }

    if (_surveyMoudle && _surveyMoudle.surveyMoudleName)
    {
        [self.navigationItem setTitle:_surveyMoudle.surveyMoudleName];
    }
    
    webview = [[UIWebView alloc]init];
    [self.view addSubview:webview];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    [webview setDelegate:self];
    
    [self loadMoudlePreview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadMoudlePreview
{
    //http://localhost:9090/cy/newc/jkda/jkda_sfjl_preview.htm?vType=YS&moudleId=43
    NSString* previewUrlString = [NSString stringWithFormat:@"%@/newc/jkda/jkda_sfjl_preview.htm?vType=YS&moudleId=%ld",kZJKHealthDataBaseUrl, _surveyMoudle.surveyMoudleId];
    
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:previewUrlString]]];
    
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
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.view showWaitView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view closeWaitView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.view closeWaitView];
}

@end
