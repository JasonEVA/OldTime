//
//  HealthNoteDetailViewController.m
//  HMClient
//
//  Created by lkl on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthNoteDetailViewController.h"
#import "HealthNoteItem.h"
#import "ClientHelper.h"
#import "HMBottomShotView.h"
#import "HealthNotesShareSelectPatientViewController.h"
#import "IMNewsModel.h"
#import "NSString+URLEncod.h"



@interface HealthNoteDetailViewController ()<UIWebViewDelegate>
{
    NSString* notesId;
}
@property (nonatomic, strong) IMNewsModel *newsModel;
@property (nonatomic, strong) HMBottomShotView *shotView;
@property (nonatomic, strong) UIView *maskView;
@end

@implementation HealthNoteDetailViewController

- (instancetype)initWithNewsModel:(IMNewsModel *)model {
    if (self = [super init]) {
        self.newsModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"详情"];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_share"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    NSString* requestUrl = @"";
    if (self.paramObject && [self.paramObject isKindOfClass:[HealthNoteItem class]])
    {
        HealthNoteItem* item = (HealthNoteItem*)self.paramObject;
        notesId = [NSString stringWithFormat:@"%ld",item.notesId];
        requestUrl = [NSString stringWithFormat:@"%@/jkxjDetail.htm?vType=YH&notesId=%@", kZJKHealthDataBaseUrl, notesId];
        self.newsModel = [IMNewsModel new];
        self.newsModel.newsTitle = item.notesTitle;
        self.newsModel.newsDescription = item.notesSummary;
        self.newsModel.newsPicUrl = item.image;
        self.newsModel.newsUrl = requestUrl;
        self.newsModel.notesID = [NSString stringWithFormat:@"%ld",item.notesId];
    }
    else {
        requestUrl = self.newsModel.newsUrl;
        NSDictionary *dict= [requestUrl analysisParameter];
        self.newsModel.notesID = [dict valueForKey:@"notesId"];
    }
    
    UIWebView* webview = [[UIWebView alloc]init];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [webview showWaitView];
    [webview setDelegate:self];
    [webview.scrollView setShowsVerticalScrollIndicator:NO];
    [webview sizeToFit];
    [webview scalesPageToFit];
    
    
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideClick)];
    [self.maskView addGestureRecognizer:tap];


}
- (void)hideClick {
    [UIView animateWithDuration:0.2 animations:^{
        [self.shotView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 170)];
    }];
    [self.maskView removeFromSuperview];
    [self.shotView removeFromSuperview];
}

- (void)rightClick {
    [self.navigationController.view addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
    [self.navigationController.view addSubview:self.shotView];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.shotView setFrame:CGRectMake(0, ScreenHeight - 170, ScreenWidth, 170)];
    }];
    
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


- (HMBottomShotView *)shotView {
    if (!_shotView) {
        _shotView = [HMBottomShotView new];
        [_shotView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 170)];
        __weak typeof(self) weakSelf = self;
        [_shotView btnClick:^(NSInteger tag) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [_shotView setBackgroundColor:[UIColor clearColor]];
            
            [strongSelf hideClick];
            if (tag) {
                //医患群
                HealthNotesShareSelectPatientViewController *VC = [HealthNotesShareSelectPatientViewController new];
                VC.newsModel = strongSelf.newsModel;
                 [strongSelf.navigationController pushViewController:VC animated:YES];
            }
        }];
    }
    return _shotView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [UIView new];
        [_maskView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
        [_maskView setUserInteractionEnabled:YES];
    }
    return _maskView;
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
