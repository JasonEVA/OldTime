//
//  LookAttachmentViewController.m
//  launcher
//
//  Created by Lars Chen on 15/10/27.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "LookAttachmentViewController.h"
#import <Masonry.h>

@interface LookAttachmentViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation LookAttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithFilePath:(NSString *)filePath
{
    if (self = [super init])
    {
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    
    return self;
}

- (instancetype)initWithWebUrl:(NSString *)urlString
{
    if (self = [super init])
    {
        NSURL *webpageUrl;
        
        if ([urlString hasPrefix:@"http://"] || [urlString hasPrefix:@"https://"]) {
            webpageUrl = [NSURL URLWithString:urlString];
        } else {
            webpageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", urlString]];
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:webpageUrl];
        [self.webView loadRequest:request];
    }
    
    return self;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
    [self RecordToDiary:[NSString stringWithFormat:@"查看附件失败Error : %@",error]];
}

#pragma mark - Init UI
- (UIWebView *)webView
{
    if (!_webView)
    {
        _webView = [UIWebView new];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
    }
    
    return _webView;
}

@end

