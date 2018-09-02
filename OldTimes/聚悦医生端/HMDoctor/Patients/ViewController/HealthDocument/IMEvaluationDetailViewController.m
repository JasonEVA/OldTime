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
#import "AdmissionAssessSummaryModel.h"

@interface IMEvaluationDetailViewController ()<UIWebViewDelegate>
{
    MessageBaseAssessmentModel* assessmentFilledModel;
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
    
    if (self.paramObject && [self.paramObject isKindOfClass:[MessageBaseAssessmentModel class]])
    {
        assessmentFilledModel = (MessageBaseAssessmentModel *)self.paramObject;
        _recordId = assessmentFilledModel.recordId;
        _assessCode = assessmentFilledModel.assessCode;
    }

    //从在院档案-并发症评估跳转
    if (self.paramObject && [self.paramObject isKindOfClass:[BfzResultListModel class]]) {
        BfzResultListModel *model = (BfzResultListModel *)self.paramObject;
        _recordId = model.recordId;
        _assessCode = @"DCPG";
    }
    
    if (!_assessCode) {
        
        return;
    }
    
    NSString *requestUrl = nil;
    if ([_assessCode isEqualToString:@"DCPG"]){
        
        //单次评估
        requestUrl = [NSString stringWithFormat:@"%@/newc/pingg/danxpg_detail.htm?vType=YS&recordId=%@&type=1", kZJKHealthDataBaseUrl, _recordId];
        
    }else if ([_assessCode isEqualToString:@"JDXPG"]){

        //阶段性评估
        NSInteger type = 3;
        BOOL editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAssessmentMode Status:assessmentFilledModel.status OperateCode:kPrivilegeEditOperate];
        if (editPrivilege)
        {
            type = 2;
        }
        requestUrl = [NSString stringWithFormat:@"%@/newc/pingg/danxpg_detail.htm?vType=YS&recordId=%@&type=%ld", kZJKHealthDataBaseUrl, _recordId, type];
        
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
            make.left.and.right.equalTo(self.view);
            make.top.and.bottom.equalTo(self.view);
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
