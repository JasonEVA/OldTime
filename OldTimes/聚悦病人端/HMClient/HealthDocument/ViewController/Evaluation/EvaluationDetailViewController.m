//
//  EvaluationDetailViewController.m
//  HMClient
//
//  Created by lkl on 16/8/22.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "EvaluationDetailViewController.h"
#import "EvaluationListRecord.h"
#import "ClientHelper.h"
#import "HMSwitchView.h"

@interface EvaluationDetailViewController ()<UIWebViewDelegate,TaskObserver,HMSwitchViewDelegate>
{
    EvaluationListRecord *record;
    UIScrollView *scrollview;
    HMSwitchView *docSwitchView;
    
    UserHealtySummaryInfo *summaryInfo;
}
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, copy) NSString *requestUrl;

@property (nonatomic, strong) UILabel *lbTemplateId;
@property (nonatomic, strong) UILabel *lbTemplateName;
@end

@implementation EvaluationDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.navigationItem setTitle:@"评估详情"];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[EvaluationListRecord class]])
    {
        record = (EvaluationListRecord *)self.paramObject;
        self.itemId = record.itemId;
    }

    //1.阶段评估  2.单项评估   3.建档评估
    
    //type=1表示单项详情，type=2 表示阶段性总结 ，type=3阶段性详情
    switch (record.itemType.integerValue)
    {
        case 1:
        {
            // pingg/danxpg_detail.htm?recordId=105858&operatorUserId=10605&type=2
            _requestUrl = [NSString stringWithFormat:@"%@/newc/pingg/danxpg_detail.htm?vType=YH&recordId=%@&type=3", kZJKHealthDataBaseUrl, self.itemId];
            [self createOtherWebview:_requestUrl];
            
            break;
        }
            
        case 2:
        {
            _requestUrl = [NSString stringWithFormat:@"%@/newc/pingg/danxpg_detail.htm?vType=YH&recordId=%@&type=1", kZJKHealthDataBaseUrl, self.itemId];
            [self createOtherWebview:_requestUrl];
            
             break;
        }
           
        case 3:
        {
            
            NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
            [dicPost setValue:self.itemId forKey:@"assessmentReportId"];
            
            [self.view showWaitView];
            [[TaskManager shareInstance] createTaskWithTaskName:@"UserHealtySummaryTask" taskParam:dicPost TaskObserver:self];
            
            [self createSwitchView];
            
            [self setswitchviewSelect:0];
            
            break;
        }
            
            
        default:
            break;
    }
}

- (void)createOtherWebview:(NSString *)requestUrl
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

#pragma mark -- 3.建档评估

- (void)createSwitchView
{
    _lbTemplateId = [[UILabel alloc] init];
    [self.view addSubview:_lbTemplateId];
    [_lbTemplateId setTextColor:[UIColor commonTextColor]];
    [_lbTemplateId setFont:[UIFont font_28]];
    
    [_lbTemplateId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.top.equalTo(self.view).with.offset(8);
        make.height.mas_equalTo(@20);
    }];
    
    _lbTemplateName = [[UILabel alloc] init];
    [self.view addSubview:_lbTemplateName];
    [_lbTemplateName setTextColor:[UIColor commonTextColor]];
    [_lbTemplateName setFont:[UIFont systemFontOfSize:14.0]];
    
    [_lbTemplateName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.top.equalTo(_lbTemplateId.mas_bottom).with.offset(8);
        make.height.mas_equalTo(@20);
    }];
    
    [_lbTemplateId setText:@"档案编号："];
    [_lbTemplateName setText:@"疾病类型："];
    
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 47)];
    [scrollview setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:scrollview];
    [scrollview setShowsHorizontalScrollIndicator:NO];
    
    docSwitchView = [[HMSwitchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, scrollview.frame.size.height)];
    [scrollview addSubview:docSwitchView];
    [docSwitchView setBackgroundColor:[UIColor orangeColor]];
    
    [docSwitchView createCells:@[@"基础评估", @"个人信息", @"检验检查", @"病史信息", @"用药情况"]];
    [scrollview setContentSize:docSwitchView.frame.size];
    [docSwitchView setDelegate:self];
    
}

- (void)createWebview:(NSString *)requestUrl
{
    if (!_webview)
    {
        _webview = [[UIWebView alloc] init];
        
        [self.view addSubview:_webview];
        
        [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.view);
            make.top.equalTo(docSwitchView.mas_bottom);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
        [_webview showWaitView];
        [_webview setDelegate:self];
        [_webview.scrollView setShowsVerticalScrollIndicator:NO];
        [_webview sizeToFit];
        [_webview scalesPageToFit];
    }

    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
}

- (void)setswitchviewSelect:(NSInteger)selectedIndex
{
    switch (selectedIndex)
    {
        case 0:
        {
            //健康评估
            _requestUrl = [NSString stringWithFormat:@"%@/newc/jiankda/jiandpg.htm?vType=YH&assessmentReportId=%@", kZJKHealthDataBaseUrl, self.itemId];
            break;
        }
            
        case 1:
        {
            //个人信息
            _requestUrl = [NSString stringWithFormat:@"%@/newc/jiankda/gerxx.htm?vType=YH&assessmentReportId=%@", kZJKHealthDataBaseUrl, self.itemId];
            break;
        }
            
        case 2:
        {
            //检验检查
            _requestUrl = [NSString stringWithFormat:@"%@/Temp?templateId=%@&templateTypeId=b1aff62da61e4e1abdf61053bbdb4cdd&assessmentReportId=%@", kZJKEvaluationDataBaseUrl, summaryInfo.templateId, self.itemId];
            break;
        }
            
        case 3:
        {
            //病史信息
            _requestUrl = [NSString stringWithFormat:@"%@/illInfo?templateId=%@&templateTypeId=e200b7c09365404298126a8fede68ee5,c7a16bc19c2740a6bbcd48192e041721,af0a21197a56453294d1fc64bf10c0d5&assessmentReportId=%@", kZJKEvaluationDataBaseUrl, summaryInfo.templateId,self.itemId];
            break;
        }
            
        case 4:
        {
            //用药情况
            _requestUrl = [NSString stringWithFormat:@"%@/temp?templateId=%@&templateTypeId=e4f2b8ffaafd4ee99aeabad3db187230&assessmentReportId=%@", kZJKEvaluationDataBaseUrl,summaryInfo.templateId,self.itemId];
            break;
        }
            
        default:
            break;
    }
    
    [self createWebview:_requestUrl];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView *)switchview SelectedIndex:(NSInteger)selectedIndex
{
    [self setswitchviewSelect:selectedIndex];
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

#pragma mark -- TaskObserver

- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void)task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"UserHealtySummaryTask"])
    {
        //NSLog(@"%@",taskResult);
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dicResult = (NSDictionary *)taskResult;

            summaryInfo = [UserHealtySummaryInfo mj_objectWithKeyValues:dicResult];
                
            //设置数据
            [self createData:summaryInfo];
        }
    }

}

- (void)createData:(UserHealtySummaryInfo *)info
{
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ (%@ | %ld)",summaryInfo.userName,summaryInfo.sex,summaryInfo.age]];
    
    [_lbTemplateId setText:[NSString stringWithFormat:@"档案编号：%@",info.healtyRecordId]];
    [_lbTemplateName setText:[NSString stringWithFormat:@"疾病类型：%@",info.templateName]];
}


@end
