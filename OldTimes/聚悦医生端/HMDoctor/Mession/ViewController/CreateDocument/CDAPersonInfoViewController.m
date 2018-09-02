//
//  CDAPersonInfoViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/24.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CDAPersonInfoViewController.h"
#import "ClientHelper.h"



@interface CDADocumentInfoViewController ()
<UIWebViewDelegate>

@property (nonatomic, readonly) UIWebView* webview;
@end

@implementation CDADocumentInfoViewController

- (id) initWithAssessmentReportId:(NSString*) assessmentReportId
                       templateId:(NSString*) templateId
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        
        _assessmentReportId = assessmentReportId;
        _templateId = templateId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _webview = [[UIWebView alloc]init];
    [self.view addSubview:_webview];
    [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    [_webview setDelegate:self];

    [self loadDocumentInfoWeb];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadDocumentInfoWeb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setTemplateId:(NSString*) templateId
{
    _templateId = templateId;
    [self loadDocumentInfoWeb];
    
}

- (void) loadDocumentInfoWeb
{
    [self.view showWaitView];
    NSString* urlString = [self documentInfoUrlString];
    if (!urlString)
    {
        return;
    }
    if ([_webview isLoading])
    {
        [_webview stopLoading];
    }
    
    NSString *webUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* webUrl = [NSURL URLWithString:webUrlString];
    
    [_webview loadRequest:[NSURLRequest requestWithURL:webUrl]];
}

- (NSString*) documentInfoUrlString
{
    return nil;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view closeWaitView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.view closeWaitView];
}

@end

@implementation CDAPersonInfoViewController

- (NSString*) documentInfoUrlString
{
    NSString* webUrlString = [NSString stringWithFormat:@"%@/newc/jiankda/gerxx.htm?assessmentReportId=%@&vType=YS", kZJKHealthDataBaseUrl, self.assessmentReportId];
    return webUrlString;
}


@end

@implementation CDAExamineViewController

- (NSString*) documentInfoUrlString
{
    NSString* webUrlString = [NSString stringWithFormat:@"%@?templateId=%@&templateTypeId=b1aff62da61e4e1abdf61053bbdb4cdd&assessmentReportId=%@", [NSString stringWithFormat:@"%@/Temp", kZJKEvaluationDataBaseUrl], self.templateId, self.assessmentReportId];
    return webUrlString;
}

@end

@implementation CDAMedicalHistoryViewController

- (NSString*) documentInfoUrlString
{
    
    NSString* webUrlString = [NSString stringWithFormat:@"%@?templateId=%@&templateTypeId=e200b7c09365404298126a8fede68ee5,c7a16bc19c2740a6bbcd48192e041721,af0a21197a56453294d1fc64bf10c0d5&assessmentReportId=%@", [NSString stringWithFormat:@"%@/illInfo", kZJKEvaluationDataBaseUrl], self.templateId, self.assessmentReportId];
    return webUrlString;
}
@end

@implementation CDAMedicationViewController

- (NSString*) documentInfoUrlString
{
    NSString* webUrlString = [NSString stringWithFormat:@"%@?templateId=%@&templateTypeId=e4f2b8ffaafd4ee99aeabad3db187230&assessmentReportId=%@", [NSString stringWithFormat:@"%@/Temp", kZJKEvaluationDataBaseUrl], self.templateId, self.assessmentReportId];
    return webUrlString;
}

@end

@implementation CDAAssessmentReportDetailViewController

- (NSString*) documentInfoUrlString
{
    NSString* webUrlString = [NSString stringWithFormat:@"%@/newc/jiankda/jiandpg.htm?assessmentReportId=%@&vType=YS", kZJKHealthDataBaseUrl, self.assessmentReportId];
    return webUrlString;
}

@end

