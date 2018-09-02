//
//  PersonSetMobileViewController.m
//  HMClient
//
//  Created by yinquan on 2017/8/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PersonSetMobileViewController.h"
#import "ForgetPasswordInputView.h"

@interface PersonSetMobileViewController ()
<TaskObserver>
{
    NSTimer* confirmTimer;
    NSInteger tick;
}
@property (nonatomic, strong) ForgetPasswordInputView* mobileInputView;
@property (nonatomic, strong) ForgetPasswordInputView* verificationCodeInputView;
@property (nonatomic, strong) UIButton* commitButton;

@end

@implementation PersonSetMobileViewController

- (void) dealloc
{
    if (confirmTimer) {
        [confirmTimer invalidate];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"修改手机号"];
    
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self layoutElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) layoutElements
{
    [self.mobileInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@50);
        make.left.top.right.equalTo(self.view);
    }];
    
    [self.verificationCodeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mobileInputView.mas_bottom);
        make.height.mas_equalTo(@50);
        make.left.and.right.equalTo(self.view);
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(self.verificationCodeInputView.mas_bottom).with.offset(40);
        make.right.equalTo(self.view).with.offset(-13);
        make.height.mas_equalTo(45);
    }];
    
}

- (void) sendSecurityCodeButtonClick
{
    NSString* mobile = self.mobileInputView.tfPassowrd.text;
    if (![CommonFuncs mobileIsValid:mobile]) {
        [self showAlertMessage:@"请输入正确手机号。"];
        return;
    }
    //获取手机验证码
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:mobile forKey:@"mobile"];
    [dicPost setValue:@"1" forKey:@"intent"];
    [dicPost setValue:@"ptyh" forKey:@"userTypeCode"];
    [self.verificationCodeInputView.mobileConfirmBtn setEnabled:NO];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserMobileConfirmTask" taskParam:dicPost TaskObserver:self];
}

- (void) startCountDown
{
    if (confirmTimer)
    {
        [confirmTimer invalidate];
        confirmTimer = nil;
    }
    tick = 60;
    //confirmTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(confirmCountDown) userInfo:nil repeats:YES];
    confirmTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(confirmCountDown) userInfo:nil repeats:YES];
}

- (void) confirmCountDown
{
    if (--tick == 0)
    {
        [self.verificationCodeInputView.mobileConfirmBtn setEnabled:YES];
        
        if (confirmTimer)
        {
            [confirmTimer invalidate];
            confirmTimer = nil;
        }
        return;
    }
    else
    {
        [self.verificationCodeInputView.mobileConfirmBtn setEnabled:NO];
        [self.verificationCodeInputView.mobileConfirmBtn setTitle:[NSString stringWithFormat:@"%ld秒后重发", tick] forState:UIControlStateDisabled];
    }
}

- (void) confirmButtonClicked:(id) sender
{
    NSString* mobile = self.mobileInputView.tfPassowrd.text;
    if (![CommonFuncs mobileIsValid:mobile]) {
        [self showAlertMessage:@"请输入正确手机号。"];
        return;
    }
    NSString* confirm = self.verificationCodeInputView.tfPassowrd.text;
    if (!confirm || confirm.length < 4) {
        [self showAlertMessage:@"请输入收到的验证码。"];
        return;
    }
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:mobile forKey:@"mobile"];
    [dicPost setValue:confirm forKey:@"confirm"];
    [dicPost setValue:@"ptyh" forKey:@"userTypeCode"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"BindUserMobileTask" taskParam:dicPost TaskObserver:self];
}


#pragma mark - settingAndGetting
- (ForgetPasswordInputView*) mobileInputView
{
    if (!_mobileInputView) {
        _mobileInputView = [[ForgetPasswordInputView alloc] init];
        [self.view addSubview:_mobileInputView];
        [_mobileInputView setName:@"手机号:"];
        [_mobileInputView setPlaceholder:@"请输入手机号"];
        [_mobileInputView.tfPassowrd setSecureTextEntry:NO];
        _mobileInputView.tfPassowrd.keyboardType = UIKeyboardTypePhonePad;
    }
    return _mobileInputView;
}

- (ForgetPasswordInputView*) verificationCodeInputView
{
    if (!_verificationCodeInputView) {
        _verificationCodeInputView = [[ForgetPasswordInputView alloc] init];
        [self.view addSubview:_verificationCodeInputView];
        [_verificationCodeInputView setName:@"验证码:"];
        [_verificationCodeInputView setPlaceholder:@"请输入手机验证码"];
        _verificationCodeInputView.tfPassowrd.keyboardType = UIKeyboardTypeASCIICapable;
        [_verificationCodeInputView.tfPassowrd setSecureTextEntry:NO];
        [_verificationCodeInputView.mobileConfirmBtn setHidden:NO];
        [_verificationCodeInputView.mobileConfirmBtn addTarget:self action:@selector(sendSecurityCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _verificationCodeInputView;
}

- (UIButton*) commitButton
{
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_commitButton];
        [_commitButton setTitle:@"确定" forState:UIControlStateNormal];
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitButton setBackgroundColor:[UIColor mainThemeColor]];
        [_commitButton.titleLabel setFont:[UIFont font_34]];
        [_commitButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_commitButton.layer setCornerRadius:5];
        [_commitButton.layer setMasksToBounds:YES];
    }
    return _commitButton;
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    //BindUserMobileTask
    if ([taskname isEqualToString:@"BindUserMobileTask"])
    {
//        [self showAlertMessage:@"修改用户手机号成功。"];
        [self showAlertMessage:@"修改用户手机号成功。" clicked:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"UserMobileConfirmTask"])
    {
        NSLog(@"获取验证码....");
        [self startCountDown];
        return;
    }
    
    
    
}

@end
