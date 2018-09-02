//
//  SecondEditionServiceDetailViewController.m
//  HMClient
//
//  Created by yinquan on 2017/6/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "SecondEditionServiceDetailViewController.h"

#import "ServiceShareViewController.h"
#import "UIBarButtonItem+BackExtension.h"
#import "ClientHelper.h"


@interface SecondEditionServiceDetailViewController ()
<UIWebViewDelegate,
TaskObserver>
{
    ServiceInfo* serviceInfo;
    ServiceDetail* serviceDetail;
    
    HMWebViewJSHelper* orderJsHelper;
}
@property (nonatomic, readonly) UIWebView* webview;

@end

@implementation SecondEditionServiceDetailViewController

@synthesize webview = _webview;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"服务详情"];
    serviceInfo = [[ServiceInfo alloc] init];
    
    orderJsHelper = [[HMWebViewJSHelper alloc] init];
    [orderJsHelper setController:self];
    
    if (self.paramObject)
    {
        if ([self.paramObject isKindOfClass:[NSString class]]) {
            NSString* upId = (NSString*)self.paramObject;
            [serviceInfo setUpId:upId.integerValue];
            //http://test.joyjk.com/shop/jkglsc/newc/app
            NSString* urlString = [NSString stringWithFormat:@"%@/fwx/detail.htm?upId=%@&fromapp=Y",kBaseShopUrl, upId];
            
            UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
            if (curUser && curUser.userId > 0) {
                urlString = [urlString stringByAppendingFormat:@"&userId=%ld", curUser.userId];
            }
            
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL* startUrl = [NSURL URLWithString:urlString];
            [self.webview loadRequest:[NSURLRequest requestWithURL:startUrl]];
            
            [self loadServiceDetail];
        }
        
        if ([self.paramObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* paramDictionary = (NSDictionary*)self.paramObject;
            NSString* upId = [paramDictionary valueForKey:@"upId"];
            if (!upId || ![upId isPureInt] || upId.integerValue == 0) {
                return;
            }
            [serviceInfo setUpId:upId.integerValue];
            NSString* recommendUserId = [paramDictionary valueForKey:@"recommendUserId"];
            if (!recommendUserId || ![recommendUserId isPureInt] || recommendUserId.integerValue == 0) {
                return;
            }
            
            NSString* urlString = [NSString stringWithFormat:@"%@/fwx/detail.htm?upId=%@&fromapp=Y",kBaseShopUrl, upId];
            
            UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
            if (curUser && curUser.userId > 0) {
                urlString = [urlString stringByAppendingFormat:@"&userId=%ld&recommendUserId=%@", curUser.userId, recommendUserId];
            }
            
            urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL* startUrl = [NSURL URLWithString:urlString];
            [self.webview loadRequest:[NSURLRequest requestWithURL:startUrl]];
            
            [self loadServiceDetail];
        }
    }
    
    //TODO:替换back方法
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageNamed:@"back.png" targe:self action:@selector(backUp)];

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void) loadServiceDetail
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", serviceInfo.upId] forKey:@"upId"];
//    [self.tableView.superview showWaitView];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceDetailTask" taskParam:dicPost TaskObserver:self];
}

- (void) backUp
{
    if ([self.webview canGoBack])
    {
        [self.webview goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - settingAndGetting
- (UIWebView*) webview
{
    if (!_webview) {
        _webview = [[UIWebView alloc] init];
        [self.view addSubview:_webview];
        [_webview setDelegate:self];
        [_webview.scrollView setShowsVerticalScrollIndicator:NO];
        [_webview sizeToFit];
        [_webview scalesPageToFit];
    }
    return _webview;
}



#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    

}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
//    [self createShareButton];
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

    context[@"h5_js"]=orderJsHelper;

}

#pragma mark - ShareService
- (void) createShareButton
{
    //分享按钮
    UIButton* shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"ic_share"]
                 forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareBarButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    shareButton.frame = CGRectMake(0, 0, 22, 20);
    
    UIBarButtonItem* shareBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    [self.navigationItem setRightBarButtonItem:shareBarButton];
}

- (void) shareBarButtonClicked:(id) sender
{
    [ServiceShareViewController showInParentController:self ServiceInfo:serviceInfo];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
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
    if ([taskname isEqualToString:@"ServiceDetailTask"]) {
        if (taskResult && [taskResult isKindOfClass:[ServiceDetail class]])
        {
            serviceDetail = (ServiceDetail*) taskResult;
            serviceDetail.UP_ID = serviceInfo.upId;
            serviceInfo.salePrice = serviceDetail.salePrice;
            serviceInfo.productName = serviceDetail.comboName;
            [orderJsHelper setServiceDetail:serviceDetail];
            [self createShareButton];
        }
    }
}
@end
