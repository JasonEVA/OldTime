//
//  IMEvaluationDetailViewController.m
//  HMDoctor
//
//  Created by lkl on 16/9/9.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "IMEvaluationDetailViewController.h"
#import "MessageBaseModel+CellSize.h"
#import "ClientHelper.h"

@interface IMEvaluationDetailViewController ()<UIWebViewDelegate>
{
    MessageBaseModelAssessmentFilled *assessmentFilledModel;
}
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, copy) NSString *assessCode;
@property (nonatomic, copy) NSString *recordId;
@end

@implementation IMEvaluationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.navigationItem setTitle:@"评估详情"];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[MessageBaseModelAssessmentFilled class]])
    {
        assessmentFilledModel = (MessageBaseModelAssessmentFilled *)self.paramObject;
        _recordId = assessmentFilledModel.recordId;
        _assessCode = assessmentFilledModel.assessCode;
    }

    if (!_assessCode) {
        
        return;
    }
    
    NSString *requestUrl = nil;
    if ([_assessCode isEqualToString:@"DCPG"]){
        
        //单次评估
        requestUrl = [NSString stringWithFormat:@"%@/newc/pingg/danxpg_detail.htm?vType=YH&recordId=%@&type=1", kZJKHealthDataBaseUrl, _recordId];
        
    }else if ([_assessCode isEqualToString:@"JDXPG"]){

        //阶段性评估
        requestUrl = [NSString stringWithFormat:@"%@/newc/pingg/danxpg_detail.htm?vType=YH&recordId=%@&type=3", kZJKHealthDataBaseUrl, _recordId];
        
    }
    
    [self createWebview:requestUrl];
}

- (void)createWebview:(NSString *)requestUrl
{
    if (!_webview)
    {
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
    }
    
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
