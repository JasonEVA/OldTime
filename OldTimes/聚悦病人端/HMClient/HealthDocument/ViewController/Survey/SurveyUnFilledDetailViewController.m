//
//  SurveyUnFilledDetailViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SurveyUnFilledDetailViewController.h"
#import "ClientHelper.h"

@interface SurveyUnFilledDetailViewController ()
<UIWebViewDelegate>
{
    UIWebView *surveyWebView;
    NSString* recordId;
}
@property (nonatomic, copy) NSString *IMGroupId;
@end

@implementation SurveyUnFilledDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"填写随访"];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSString class]])
    {
        recordId = (NSString*) self.paramObject;
    }
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSArray class]])
    {
        NSArray *tempArr = (NSArray*) self.paramObject;
        recordId = tempArr.firstObject;
        self.IMGroupId = tempArr.lastObject;
    }
    
    surveyWebView = [[UIWebView alloc]init];
    [self.view addSubview:surveyWebView];
    
    [surveyWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [surveyWebView showWaitView];
    [surveyWebView setDelegate:self];
    [surveyWebView.scrollView setShowsVerticalScrollIndicator:NO];
    [surveyWebView sizeToFit];
    [surveyWebView scalesPageToFit];
    [surveyWebView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    NSString *requestUrl = @"";
    if (self.IMGroupId && self.IMGroupId.length) {
       requestUrl = [NSString stringWithFormat:@"%@/jkda/jkda_sfjl_bj.htm?vType=YH&recordId=%@&userId=%ld&toImGroupId=%@", kZJKHealthDataBaseUrl,recordId ,curUser.userId,self.IMGroupId];
    }
    else {
        requestUrl = [NSString stringWithFormat:@"%@/jkda/jkda_sfjl_bj.htm?vType=YH&recordId=%@&userId=%ld", kZJKHealthDataBaseUrl,recordId ,curUser.userId];

    }
    
    [surveyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- webViewDelegate
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [webView closeWaitView];
    
}

@end
