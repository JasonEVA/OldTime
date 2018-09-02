//
//  HMScreeningInventoryViewController.m
//  HMDoctor
//
//  Created by lkl on 2017/3/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMScreeningInventoryViewController.h"
#import "ClientHelper.h"

@interface HMScreeningInventoryViewController ()<UIWebViewDelegate>
{
    NSString *useId;
    NSString *admissionId;
}
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation HMScreeningInventoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"健康风险筛查表"];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSMutableDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)self.paramObject;
        useId = [dic objectForKey:@"userId"];
        admissionId = [dic objectForKey:@"admissionId"];
    }
    
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/newc/zyda/jksc_detail.htm?vType=YS&userId=%@&admissionId=%@",kZJKHealthDataBaseUrl,useId,admissionId]];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
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

- (UIWebView *)webView{
    if (!_webView){
        _webView = [[UIWebView alloc] init];
        [_webView setDelegate:self];
        [_webView.scrollView setShowsVerticalScrollIndicator:NO];
        [_webView sizeToFit];
        [_webView scalesPageToFit];
    }
    return _webView;
}
@end
