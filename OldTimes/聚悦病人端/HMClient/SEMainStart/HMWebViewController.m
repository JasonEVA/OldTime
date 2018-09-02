//
//  HMWebViewController.m
//  HMClient
//
//  Created by JasonWang on 2017/5/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMWebViewController.h"

@interface HMWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *titelString;

@end

@implementation HMWebViewController

- (instancetype)initWithUrlString:(NSString *)urlString titelString:(NSString *)titelString{
    if (self = [super init]) {
        self.urlString = urlString;
        self.titelString = titelString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]])
    {
        self.urlString = self.paramObject;
    }
    
    [self.navigationItem setTitle:self.titelString];
//    [self.navigationController.navigationBar setTranslucent:YES];

    [self.navigationItem setHidesBackButton:YES];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    UIBarButtonItem *leftCloseBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(popVC)];
    [self.navigationItem setLeftBarButtonItems:@[leftBtn,leftCloseBtn]];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}

- (void)backClick {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
    else {
        [self .navigationController popViewControllerAnimated:YES];
    }
}

- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 3
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    // 2
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //商城详情单独处理 by YinQ  at 2017.10.26
    NSArray* pathComponents = request.URL.pathComponents;
    if ([[pathComponents lastObject] isEqualToString:@"detail.htm"])
    {
        NSDictionary* queryDictionary = [request.URL dictionaryWithQuery];
        if (queryDictionary)
        {
            NSString* upId = [queryDictionary valueForKey:@"upId"];
            if (upId && [upId isPureInt])
            {
                //跳转到详情界面 SecondEditionServiceDetailViewController
                [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceDetailViewController" ControllerObject:upId];
            }
        }
        
        return NO;
    }
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
