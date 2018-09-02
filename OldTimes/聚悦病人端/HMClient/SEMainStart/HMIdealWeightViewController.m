//
//  HMIdealWeightViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/8/9.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMIdealWeightViewController.h"
#import "JWAnnularProgressView.h"
#import "HMSetNewTargetWeightViewController.h"
#import "HMTZMainDiagramDataModel.h"

#define PROGRESSHEIGHT     (ScreenWidth - 150)

@interface HMIdealWeightViewController ()<TaskObserver>

@property (nonatomic, strong) JWAnnularProgressView *progressView;
@property (nonatomic, strong) UILabel *fromTargetLb;
@property (nonatomic, strong) UILabel *targetWeightTitelLb;
@property (nonatomic, strong) UILabel *targetWeightValueLb;
@property (nonatomic, strong) UIButton *setNewTargetBtn;
@property (nonatomic, strong) HMTZMainDiagramDataModel *model;

@end

@implementation HMIdealWeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"理想体重"];
    [self.view addSubview:self.progressView];

    [self.view addSubview:self.fromTargetLb];
    [self.progressView addSubview:self.targetWeightValueLb];
    [self.progressView addSubview:self.targetWeightTitelLb];
    [self.view addSubview:self.setNewTargetBtn];
    
    [self.fromTargetLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.progressView.mas_top).offset(-34);
    }];
    
    [self.targetWeightValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.progressView);
        make.centerY.equalTo(self.progressView).offset(5);
    }];
    
    [self.targetWeightTitelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.progressView);
        make.bottom.equalTo(self.targetWeightValueLb.mas_top);
    }];
    
    [self.setNewTargetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.progressView.mas_bottom).offset(45);
        make.width.equalTo(@222);
        make.height.equalTo(@40);
    }];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startGetTZMainDiagramDataRequest];
}

- (void)startGetTZMainDiagramDataRequest {
    
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    [self at_postLoading];
    [[TaskManager shareInstance]createTaskWithTaskName:@"HMGetTZMainDiagramDataRequest" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnClick {
    HMSetNewTargetWeightViewController *VC = [[HMSetNewTargetWeightViewController alloc] initWithType:HMGroupPKSetTatgetWeightStep_oneHeight nowWeight:0];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)configVC {
    CGFloat off = self.model.nowTz.floatValue - self.model.aimValue.floatValue;
    if (off <= 0) {
        [self.fromTargetLb setText:@"恭喜你达到理想体重，真棒！"];
    }
    else {
        [self.fromTargetLb setText:[NSString stringWithFormat:@"离理想体重还差%.1fkg",(off)]];
    }
    NSString *targetString = [NSString stringWithFormat:@"%.1f",self.model.aimValue.floatValue];
    [self.targetWeightValueLb setAttributedText:[NSAttributedString getAttributWithString:[NSString stringWithFormat:@"%@kg",targetString] UnChangePart:@"kg" changePart:[NSString stringWithFormat:@"%@",targetString] changeColor:[UIColor mainThemeColor] changeFont:[UIFont systemFontOfSize:(72 * (ScreenWidth / 400))]]];
    
    CGFloat x = 0;
    if ((self.model.JWInitValue.floatValue - self.model.aimValue.floatValue) <= 0) {
        x = 0;
    }
    else {
        x = (self.model.nowTz.floatValue - self.model.aimValue.floatValue) / (self.model.JWInitValue.floatValue - self.model.aimValue.floatValue);
    }
    
    x = MIN(1.0, MAX(x, 0));

    [self.progressView configAnnularWithProgress:1-x];

    
}
#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    
    if (StepError_None != taskError)
    {
        [self at_hideLoading];
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self at_hideLoading];
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"HMGetTZMainDiagramDataRequest"]) {
        self.model = (HMTZMainDiagramDataModel *)taskResult;
        [self configVC];
    }
    
}


- (JWAnnularProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[JWAnnularProgressView alloc] initWithFrame:CGRectMake(((ScreenWidth - PROGRESSHEIGHT)/2) , ((ScreenHeight - PROGRESSHEIGHT)/2-50), PROGRESSHEIGHT, PROGRESSHEIGHT) circularWidth:5 circularBackColor:[UIColor colorWithHexString:@"f0f0f0"] circularProgressColor:[UIColor mainThemeColor] backColor:[UIColor clearColor]];
    }
    return _progressView;
}

- (UILabel *)fromTargetLb {
    if (!_fromTargetLb) {
        _fromTargetLb = [UILabel new];
        [_fromTargetLb setFont:[UIFont systemFontOfSize:16]];
        [_fromTargetLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_fromTargetLb setText:@"离理想体重还差5kg"];
    }
    return _fromTargetLb;
}

- (UILabel *)targetWeightTitelLb {
    if (!_targetWeightTitelLb) {
        _targetWeightTitelLb = [UILabel new];
        [_targetWeightTitelLb setFont:[UIFont systemFontOfSize:16]];
        [_targetWeightTitelLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_targetWeightTitelLb setText:@"理想体重"];
    }
    return _targetWeightTitelLb;
}

- (UILabel *)targetWeightValueLb {
    if (!_targetWeightValueLb) {
        _targetWeightValueLb = [UILabel new];
        [_targetWeightValueLb setFont:[UIFont systemFontOfSize:17]];
        [_targetWeightValueLb setTextColor:[UIColor mainThemeColor]];
        [_targetWeightValueLb setText:@"50kg"];
    }
    return _targetWeightValueLb;
}

- (UIButton *)setNewTargetBtn {
    if (!_setNewTargetBtn) {
        _setNewTargetBtn = [UIButton new];
        [_setNewTargetBtn.layer setBorderColor:[UIColor mainThemeColor].CGColor];
        [_setNewTargetBtn.layer setBorderWidth:1];
        [_setNewTargetBtn.layer setCornerRadius:2];
        [_setNewTargetBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_setNewTargetBtn setTitle:@"设置新的目标" forState:UIControlStateNormal];
        [_setNewTargetBtn setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [_setNewTargetBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setNewTargetBtn;
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
