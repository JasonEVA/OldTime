//
//  DeviceDetectGuidePageViewController.m
//  HMClient
//
//  Created by lkl on 16/6/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DeviceDetectGuidePageViewController.h"
#import "ClientHelper.h"

@interface DeviceDetectGuidePageViewController ()<UIWebViewDelegate>

@end

@implementation DeviceDetectGuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]])
    {
        NSString *code = (NSString*)self.paramObject;
        
        NSString *navigationTitle;
        NSString *path;
        
        if ([code isEqualToString:@"XDY_HLF"]){
            navigationTitle = @"hellofit心电仪使用流程";
            path = @"/yindy/xindy2.htm";
        }
        else if([code isEqualToString:@"XDY_HPY"]){
            navigationTitle = @"好朋友心电仪使用流程";
            path = @"/yindy/xindy.htm";
        }
        else if([code isEqualToString:@"XTY_BJ"]){
            navigationTitle = @"百捷血糖仪使用流程";
            path = @"/yindy/xuety.htm";
        }
        else if([code isEqualToString:@"XTY_QS"]){
            navigationTitle = @"强生血糖仪使用流程";
            path = @"/yindy/xuety2.htm";
        }
        else if([code isEqualToString:@"XYJ_YRN"]){
            navigationTitle = @"优瑞恩血压计使用流程";
            path = @"/yindy/xueyj.htm";
        }
        else if([code isEqualToString:@"XYJ_YY"]){
            navigationTitle = @"鱼跃血压计使用流程";
            path = @"/yindy/xueyj2.htm";
        }
        else if([code isEqualToString:@"XYJ_MBB"]){
            navigationTitle = @"脉搏波血压计使用流程";
            path = @"/yindy/xueyj2.htm";
        }
        else if([code isEqualToString:@"XYY_BR"]){
            navigationTitle = @"血氧仪使用流程";
            path = @"/yindy/xueyy.htm";
        }
        else{
            navigationTitle = @"";
            path = @"";
        }
        
        [self.navigationItem setTitle:navigationTitle];
        NSString *requestUrl = [NSString stringWithFormat:@"%@%@?vType=YS",kZJKHealthDataBaseUrl,path];
        [self openGuidePageRequestUrl:requestUrl];
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) openGuidePageRequestUrl:(NSString *)url
{
    UIWebView* guidePagewebView = [[UIWebView alloc]init];
    [self.view addSubview:guidePagewebView];
    
    [guidePagewebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [guidePagewebView showWaitView];
    [guidePagewebView setDelegate:self];
    [guidePagewebView.scrollView setShowsVerticalScrollIndicator:NO];
    [guidePagewebView sizeToFit];
    [guidePagewebView scalesPageToFit];
    
    [guidePagewebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark- webViewDelegate
- (void) webViewDidFinishLoad:(UIWebView *)webView
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
