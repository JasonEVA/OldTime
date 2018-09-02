//
//  RoundsDetailViewController.m
//  HMDoctor
//
//  Created by yinquan on 16/9/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "RoundsDetailViewController.h"

#import "ClientHelper.h"
#import "PatientInfo.h"
#import "ATModuleInteractor+PatientChat.h"
#import "HMNewConcernSendViewController.h"
#import "UIBarButtonItem+BackExtension.h"

@interface RoundsDetailViewController ()
<UIWebViewDelegate>
{
    UIWebView* webviwe;
}

@property (nonatomic, strong) UIButton *addBnt;
@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic, strong) UIImageView *JWAlterView;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) filledSuccessBlock block;
@end

@implementation RoundsDetailViewController

- (instancetype)initWithModel:(RoundsMessionModel *)model isFilled:(BOOL)isFilled
{
    self = [super init];
    if (self) {
        _messionModel = model;
        if (isFilled) {
            // 已填写
            StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
            
            NSString* webUrl = [NSString stringWithFormat:@"%@/newc/pingg/danxpg_detail.htm?vType=YS&recordId=%@&operatorUserId=%ld", kZJKHealthDataBaseUrl, _messionModel.surveyId, staff.userId];
            self.urlString = webUrl;
        }
        else {
            // 未填写
             NSString* webUrl = [NSString stringWithFormat:@"%@/newc/pingg/pinggb_edit.htm?vType=YS&recordId=%@&userId=%ld", kZJKHealthDataBaseUrl, self.messionModel.surveyId, self.messionModel.userId];
            self.urlString = webUrl;
        }
        
        if (self.messionModel.moudleName && self.messionModel.moudleName.length) {
            [self.navigationItem setTitle:_messionModel.moudleName];

        }
        else {
            if (isFilled) {
                [self.navigationItem setTitle:@"查房详情"];

            }
            else {
                [self.navigationItem setTitle:@"填写查房"];

            }
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageNamed:@"back.png" targe:self action:@selector(backUp:)];

      webviwe = [[UIWebView alloc]init];
    [self.view addSubview:webviwe];
    [webviwe setDelegate:self];
    [webviwe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    [self loadDetail];
    
    [self addConfig];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadDetail
{
    [self.view showWaitView];
    NSString* urlString = self.urlString;
    if (!urlString)
    {
        return;
    }
    NSURL* webUrl = [NSURL URLWithString:urlString];
    [webviwe loadRequest:[NSURLRequest requestWithURL:webUrl]];
}

- (void)backUp:(UIBarButtonItem *)btn
{
    //[self popViewControllerAnimated:YES];
    if ([webviwe canGoBack])
    {
        [webviwe goBack];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)addConfig {
    [self.view addSubview:self.addBnt];
    [self.addBnt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    
    [self.addBnt addSubview:self.addImageView];
    [self.addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.addBnt);
    }];
    
    [self.view addSubview:self.JWAlterView];
    
    [self.JWAlterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.addBnt.mas_top).offset(20);
        make.right.equalTo(self.addBnt.mas_left).offset(20);
    }];
    
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_patient"]];
    [self.JWAlterView addSubview:image1];
    [image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.JWAlterView).offset(20);
        make.left.equalTo(self.JWAlterView).offset(20);
    }];
    
    UIButton *contactPatientBtn = [[UIButton alloc] init];
    [contactPatientBtn setTitle:@"联系患者" forState:UIControlStateNormal];
    [contactPatientBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [contactPatientBtn setTag:0];
    [contactPatientBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [contactPatientBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.JWAlterView addSubview:contactPatientBtn];
    [contactPatientBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(image1);
        make.left.equalTo(image1.mas_right).offset(10);
    }];
    
    
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_solicitude"]];
    [self.JWAlterView addSubview:image2];
    [image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.JWAlterView).offset(-20);
        make.left.equalTo(self.JWAlterView).offset(20);
    }];
    
    UIButton *concentPatientBtn = [[UIButton alloc] init];
    [concentPatientBtn setTitle:@"发送关怀" forState:UIControlStateNormal];
    [concentPatientBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [concentPatientBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [concentPatientBtn setTag:1];
    [concentPatientBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.JWAlterView addSubview:concentPatientBtn];
    [concentPatientBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(image2);
        make.left.equalTo(image2.mas_right).offset(10);
    }];
    

    
    

}

- (void)addClick:(UIButton *)btn {
    btn.selected ^= 1;
    [UIView animateWithDuration:0.2 animations:^{
        self.addImageView.transform = CGAffineTransformMakeRotation(btn.selected ? - M_PI/4 : 0);
    } completion:^(BOOL finished) {
        [self.JWAlterView setHidden:!btn.selected];
    }];
}

- (void)btnClick:(UIButton *)btn {
    [self addClick:self.addBnt];
    
    if (btn.tag) {
        // 关怀
        PatientInfo *info = [PatientInfo new];
        info.userId = _messionModel.userId;
        info.userName = _messionModel.userName;
        
        HMNewConcernSendViewController *VC = [[HMNewConcernSendViewController alloc] initWithSelectMember:@[info] text:@"" isSendToGroup:NO];
        [self.navigationController pushViewController:VC animated:YES];

    }
    else {
        // 联系患者
        RoundsMessionModel* mession = _messionModel;

        //2017-10-31版本 界面修改调整 by Jason
        [[ATModuleInteractor sharedInstance] goToPatientInfoDetailWithUid:[NSString stringWithFormat:@"%ld",(long)mession.userId]];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)fillFinish:(filledSuccessBlock)block {
    self.block = block;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.view showWaitView];
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    StaffPrivilegeJSHelper* privilegeHelper = [StaffPrivilegeJSHelper new];
    context[@"h5_js"]=privilegeHelper;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view closeWaitView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.view closeWaitView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[[request URL] absoluteString]stringByRemovingPercentEncoding];
    
    if ([requestString isEqualToString:@"exithtml5://HTML5.exit"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.block) {
            self.block();
        }
        return NO;
    }
    return YES;
}

- (UIButton *)addBnt {
    if (!_addBnt) {
        _addBnt  = [[UIButton alloc] init];
        [_addBnt setImage:[UIImage imageNamed:@"ic_add_back"] forState:UIControlStateNormal];
        [_addBnt addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBnt;
}

- (UIImageView *)addImageView {
    if (!_addImageView) {
        _addImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_add"]];
    }
    return _addImageView;
}

- (UIImageView *)JWAlterView {
    if (!_JWAlterView) {
        _JWAlterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rectangle"]];
        [_JWAlterView setHidden:YES];
        [_JWAlterView setUserInteractionEnabled:YES];
    }
    return _JWAlterView;
}
@end
