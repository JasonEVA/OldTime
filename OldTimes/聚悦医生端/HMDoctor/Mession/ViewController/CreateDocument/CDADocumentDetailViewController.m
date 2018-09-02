//
//  CDADocumentDetailViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/25.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CDADocumentDetailViewController.h"
#import "ClientHelper.h"

@interface CDADocumentDetailViewController ()
<UIWebViewDelegate>
{
    
}

@property (nonatomic, readonly) UIWebView* webview;
@end

@implementation CDADocumentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.paramObject && [self.paramObject isKindOfClass:[CreateDocumetnTemplateTypeModel class]])
    {
        _templateTypeModel = (CreateDocumetnTemplateTypeModel*) self.paramObject;
    }
    
    _webview = [[UIWebView alloc]init];
    [self.view addSubview:_webview];
    [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    [_webview setDelegate:self];
    
    [self.navigationItem setTitle:self.templateTypeModel.surveyMoudleName];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadDocumentInfoWeb];
}

- (void) loadDocumentInfoWeb
{
    
    NSString* urlString = [self documentInfoUrlString];
    if (!urlString)
    {
        return;
    }
    [self.view showWaitView];
    NSURL* webUrl = [NSURL URLWithString:urlString];
    [self.webview loadRequest:[NSURLRequest requestWithURL:webUrl]];
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

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.view closeWaitView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[[request URL] absoluteString]stringByRemovingPercentEncoding];
    
    if ([requestString isEqualToString:@"exithtml5://HTML5.exit"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}


@end

@implementation CDAFillAssessmentDocumentDetailViewController



//http://localhost:9090/cy/newc/jiankda/jiandpg_edit.htm?userGeneralModelRecordId=${userGeneralModelRecordId}&userId=${userId}&operatorUserId=${operatorUserId}&againFlag=0

- (NSString*) documentInfoUrlString
{
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    NSString* webUrlString = [NSString stringWithFormat:@"%@/newc/jiankda/jiandpg_edit.htm?vType=YS&userGeneralModelRecordId=%@&userId=%ld&operatorUserId=%ld&againFlag=0", kZJKHealthDataBaseUrl, self.templateTypeModel.recordId, self.templateTypeModel.userId,staff.userId];
    
    
    return webUrlString;
}

@end

@implementation CDAFilledAssessmentDocumentDetailViewController



//http://localhost:9090/cy/newc/jiankda/jiandpg_detail.htm??userGeneralModelRecordId=${userGeneralModelRecordId!}&userId=${userId!}&operatorUserId=${operatorUserId!}&againFlag=0

- (NSString*) documentInfoUrlString
{
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    NSString* webUrlString = [NSString stringWithFormat:@"%@/newc/jiankda/jiandpg_detail.htm?vType=YS&userGeneralModelRecordId=%@&userId=%ld&operatorUserId=%ld&againFlag=0", kZJKHealthDataBaseUrl, self.templateTypeModel.recordId, self.templateTypeModel.userId,staff.userId];
    NSString* operateCode = nil;
    switch (self.templateTypeModel.dataType)
    {
        case 1:
        {
            //一般建档评估
            operateCode = kPrivilegeNormalAssessOperate;
        }
            break;
        case 2:
        {
            //治疗风险评估
            operateCode = kPrivilegeTreatAssessOperate;
        }
            break;
        case 3:
        {
            //并发症风险评估
            operateCode = kPrivilegeComplicationAssessOperate;
        }
            break;
        default:
            break;
    }
    BOOL privilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:self.status OperateCode:operateCode];
    if (privilege)
    {
        webUrlString = [webUrlString stringByAppendingString:@"&flag=1"];
    }
    else
    {
        webUrlString = [webUrlString stringByAppendingString:@"&flag=0"];
    }
    return webUrlString;
}

@end
