//
//  RecipeDetailViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/27.
//  Copyright © 2016年 YinQ. All rights reserved.
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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (webview)
    {
        return;
    }
    webview = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webview];
    
    [webview showWaitView];
    [webview setDelegate:self];
    [webview.scrollView setShowsVerticalScrollIndicator:NO];
    [webview sizeToFit];
    [webview scalesPageToFit];
    
    NSString* requestUrl = [NSString stringWithFormat:@"%@/jkda/showRecipe.htm?vType=YH&userRecipeId=%@", kZJKHealthDataBaseUrl, userRecipeId];
    
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [webView closeWaitView];
    
}

@end
