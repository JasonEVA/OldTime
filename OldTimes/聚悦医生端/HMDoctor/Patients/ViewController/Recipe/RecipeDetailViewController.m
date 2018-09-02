//
//  RecipeDetailViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/28.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "RecipeDetailViewController.h"
#import "ClientHelper.h"

@interface RecipeDetailViewController ()
<UIWebViewDelegate>
{
    NSString* userRecipeId;
    UIWebView* webview;
}
@end

@implementation RecipeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"用药建议详情"];
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]])
    {
        userRecipeId = self.paramObject;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (webview)
    {
        return;
    }
    webview = [[UIWebView alloc] init];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    [webview showWaitView];
    [webview setDelegate:self];
    [webview.scrollView setShowsVerticalScrollIndicator:NO];
    [webview sizeToFit];
    [webview scalesPageToFit];
    
    NSString* requestUrl = [NSString stringWithFormat:@"%@/jkda/showRecipe.htm?vType=YS&userRecipeId=%@", kZJKHealthDataBaseUrl, userRecipeId];
    
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
}

//- (void) viewDidAppear:(BOOL)animated
//{
//    if (webview)
//    {
//        return;
//    }
//    webview = [[UIWebView alloc]initWithFrame:self.view.bounds];
//    [self.view addSubview:webview];
//    
//    [webview showWaitView];
//    [webview setDelegate:self];
//    [webview.scrollView setShowsVerticalScrollIndicator:NO];
//    [webview sizeToFit];
//    [webview scalesPageToFit];
//    
//    NSString* requestUrl = [NSString stringWithFormat:@"%@/jkda/showRecipe.htm?vType=YS&userRecipeId=%@", kZJKHealthDataBaseUrl, userRecipeId];
//    
//    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [webView closeWaitView];
    
}

@end
