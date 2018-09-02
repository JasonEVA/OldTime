//
//  HealthReportViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HealthReportViewController.h"
#import "ClientHelper.h"
#import "UIBarButtonItem+BackExtension.h"
#import "HMSwitchView.h"
#import "HealthReportTableViewController.h"

@interface HealthReportWebViewController ()
<UIWebViewDelegate>
{
    UIWebView* webview;
}
@end

@implementation HealthReportWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"健康报告"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageNamed:@"back.png" targe:self action:@selector(backUp:)];
    
    webview = [[UIWebView alloc]init];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    //NSString* staffRole = [[UserInfoHelper defaultHelper] staffRole];
    
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSString *str = [NSString stringWithFormat:@"%@/jkbg_hzlb.htm?vType=YS&staffUserId=%ld",kZJKHealthDataBaseUrl, curStaff.userId];

    NSString *encodedStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedStr]];
    [webview showWaitView];
    [webview setDelegate:self];
    [webview loadRequest:request];
}


- (void)backUp:(UIBarButtonItem *)btn
{
    //[self popViewControllerAnimated:YES];
    if ([webview canGoBack])
    {
        [webview goBack];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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

typedef enum : NSUInteger {
    HealthRepor_UnDealed,       //待处理
    HealthRepor_AllStatus,      //全部
    
} HealthReportSwitchIndex;

@interface HealthReportStartViewController ()
<HMSwitchViewDelegate>
{
    HMSwitchView* switchview;
    //HealthReportTableViewController* tvcReports;
    UITabBarController* tabbarController;
}
@end

@implementation HealthReportStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"健康报告"];
    [self createSwitchView];
    [self createTababrController];
    if (UMSDK_isOn) {
        [MobClick event:UMCustomEvent_EnterWorkDesk_HealthReport];
    }
}

- (void) createSwitchView
{
    switchview = [[HMSwitchView alloc]init];
    [self.view addSubview:switchview];
    [switchview createCells:@[@"待处理", @"全部"]];
    [switchview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@47);
    }];
    [switchview setDelegate:self];
}

- (void) createTababrController
{
    tabbarController = [[UITabBarController alloc]init];
    [self addChildViewController:tabbarController];
    
    HealthReportTableViewController* tvcUndealed = [[HealthReportTableViewController alloc]initWithStatusList:[self reportDealStatusList]];
    HealthReportTableViewController* tvcAllStatus = [[HealthReportTableViewController alloc]initWithStatusList:nil];
    [tabbarController setViewControllers:@[tvcUndealed, tvcAllStatus]];
    [self.view addSubview:tabbarController.view];
    [tabbarController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(switchview.mas_bottom);
    }];
    
    [tabbarController.tabBar setHidden:YES];
}

- (NSArray*) reportDealStatusList
{
    NSMutableArray* dealStatusList = [NSMutableArray array];
    for (NSInteger status = 1; status <= 4; ++status)
    {
        BOOL editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeHealthReportMode Status:status OperateCode:kPrivilegeEditOperate];
        if (editPrivilege) {
            [dealStatusList addObject:[NSString stringWithFormat:@"%ld", status]];
        }
    }
    return dealStatusList;
}

#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView *)switchview SelectedIndex:(NSUInteger)selectedIndex
{
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:selectedIndex>0?@"工作台－健康报告－全部":@"工作台－健康报告－已填写"];
    if (tabbarController) {
        [tabbarController setSelectedIndex:selectedIndex];
    }
}

@end
