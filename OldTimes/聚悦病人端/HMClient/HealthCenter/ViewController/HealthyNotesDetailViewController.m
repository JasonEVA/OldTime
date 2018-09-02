//
//  HealthyNotesDetailViewController.m
//  HMClient
//
//  Created by yinquan on 16/12/26.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthyNotesDetailViewController.h"
#import "HealthEducationItem.h"
#import "ClientHelper.h"
#import "IMNewsModel.h"
#import "HMInteractor.h"

@interface HealthyNotesDetailViewController ()
<UIWebViewDelegate>
{
    UIWebView* webview;
    NSString* notesId;
    NSString* requestUrl;
    
}

@property (nonatomic, strong) IMNewsModel *newsModel;
@end

@implementation HealthyNotesDetailViewController

//从推送进入详情
- (instancetype)initWithNotsID:(NSString *)notsID {
    notesId = notsID;
    IMNewsModel *model = [IMNewsModel new];
    model.notesID = notsID;
    return [self initWithNewsModel:model];
}

- (instancetype)initWithNewsModel:(IMNewsModel *)model {
    if (self = [super init]) {
        self.newsModel = model;
        notesId = model.notesID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    webview = [[UIWebView alloc] init];
    [self.view addSubview:webview];
    [self.navigationItem setTitle:@"详情"];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[HealthNotesItem class]])
    {
        HealthNotesItem* item = (HealthNotesItem*)self.paramObject;
        notesId = [NSString stringWithFormat:@"%ld",item.notesId];
        NSString* notesTitle = item.notesTitle;
        [self.navigationItem setTitle:notesTitle];
        
        requestUrl = [NSString stringWithFormat:@"%@/jkxjDetail.htm?vType=YH&notesId=%@", kZJKHealthDataBaseUrl, notesId];
    }
    else if(self.newsModel) {
        requestUrl = self.newsModel.newsUrl;

    }

    
    if (!requestUrl || requestUrl.length == 0)
    {
        return;
    }
    
    [webview showWaitView];
    [webview setDelegate:self];
    [webview.scrollView setShowsVerticalScrollIndicator:NO];
    [webview sizeToFit];
    [webview scalesPageToFit];
    
    
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- webViewDelegate
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [webView closeWaitView];
    
}
@end
