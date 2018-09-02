//
//  ForgetPasswordViewController.m
//  HMClient
//
//  Created by lkl on 16/6/28.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ForgetPasswordInputView.h"
#import "UserLoginViewController.h"

@interface ForgetPasswordViewController ()<TaskObserver>
{
    UILabel* lbContext;
//    ForgetPasswordInputView* mobileInputView;
    ForgetPasswordInputView* verificationCodeInputView;
    ForgetPasswordInputView* pwdInputView;
    ForgetPasswordInputView* pwdConfirmInputView;
    
    NSTimer* confirmTimer;
    UIButton* confirmBtn;
    NSInteger tick;
}
@end

@implementation ForgetPasswordViewController

- (void) dealloc
{
    if (confirmTimer) {
        [confirmTimer invalidate];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.navigationItem setTitle:@"重置密码"];
    
    [self initContentView];
}

- (void) initContentView
{
    lbContext = [[UILabel alloc] init];
    [self.view addSubview:lbContext];
    [lbContext setFont:[UIFont font_28]];
    [lbContext setTextColor:[UIColor commonLightGrayTextColor]];
    
    NSString* fontStr = [_phoneNum substringWithRange:NSMakeRange(0, 3)];
    NSString* backStr = [_phoneNum substringWithRange:NSMakeRange(7, 4)];
    
    [lbContext setText:[NSString stringWithFormat:@"您绑定的手机号为:%@****%@, 请验证",fontStr,backStr]];

    
    verificationCodeInputView = [[ForgetPasswordInputView alloc]init];
    [self.view addSubview:verificationCodeInputView];
    [verificationCodeInputView setName:@"验证码:"];
    [verificationCodeInputView setPlaceholder:@"请输入手机验证码"];
    verificationCodeInputView.tfPassowrd.keyboardType = UIKeyboardTypeASCIICapable;
    [verificationCodeInputView.tfPassowrd setSecureTextEntry:NO];
    [verificationCodeInputView.mobileConfirmBtn setHidden:NO];
    [verificationCodeInputView.mobileConfirmBtn addTarget:self action:@selector(sendSecurityCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    pwdInputView = [[ForgetPasswordInputView alloc]init];
    [self.view addSubview:pwdInputView];
    [pwdInputView setName:@"密码:"];
    [pwdInputView setPlaceholder:@"请输入6-16位字母或数字密码"];
    
    pwdConfirmInputView = [[ForgetPasswordInputView alloc]init];
    [self.view addSubview:pwdConfirmInputView];
    [pwdConfirmInputView setName:@"重复密码:"];
    [pwdConfirmInputView setPlaceholder:@"请重复输入密码"];
    
    
    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:confirmBtn];
    
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:[UIColor mainThemeColor]];
    [confirmBtn.titleLabel setFont:[UIFont font_34]];
    [confirmBtn addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [confirmBtn.layer setCornerRadius:5];
    [confirmBtn.layer setMasksToBounds:YES];
    
    [self subviewLayout];
}

- (void) subviewLayout
{
    [lbContext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@50);
        make.left.mas_equalTo(12.5);
    }];
    
    [verificationCodeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbContext.mas_bottom);
        make.height.mas_equalTo(@50);
        make.left.and.right.equalTo(self.view);
    }];
    
    [pwdInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verificationCodeInputView.mas_bottom);
        make.height.mas_equalTo(@50);
        make.left.and.right.equalTo(self.view);
    }];
    
    [pwdConfirmInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdInputView.mas_bottom);
        make.height.mas_equalTo(@50);
        make.left.and.right.equalTo(self.view);
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(pwdConfirmInputView.mas_bottom).with.offset(40);
        make.right.equalTo(self.view).with.offset(-13);
        make.height.mas_equalTo(45);
    }];
}

- (void)confirmButtonClicked:(id)sender
{
    NSString* mobileConfirm = verificationCodeInputView.tfPassowrd.text;
    if (!mobileConfirm || 0 == mobileConfirm.length)
    {
        [self showAlertMessage:@"请输入您收到的手机验证码。"];
        return;
    }
    
    NSString* password = pwdInputView.tfPassowrd.text;
    if (!password || 6 > password.length || 20 < password.length)
    {
        [self showAlertMessage:@"请输入6-20位登录密码。"];
        return;
    }
    
    NSString* pwdConfirm = pwdConfirmInputView.tfPassowrd.text;
    if (!pwdConfirm || 6 > pwdConfirm.length || 20 < pwdConfirm.length)
    {
        [self showAlertMessage:@"请输入6-20位登录密码确认。"];
        return;
    }
    
    if(![password isEqualToString:pwdConfirm])
    {
        [self showAlertMessage:@"密码不一致，请重新输入。"];
        return;
    }

    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    
    [dicPost setValue:[NSString stringWithFormat:@"%@",_userId] forKey:@"userId"];
    
    [dicPost setValue:password forKey:@"password"];
    [dicPost setValue:mobileConfirm forKey:@"confirm"];
    
    [self.view showWaitView:@"重置密码"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserModifyPwdTask" taskParam:dicPost TaskObserver:self];
}

- (void)sendSecurityCodeButtonClick
{
    
    //获取手机验证码
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:_phoneNum forKey:@"mobile"];
    [dicPost setValue:@"2" forKey:@"intent"];
    [dicPost setValue:@"ptyh" forKey:@"userTypeCode"];
    [verificationCodeInputView.mobileConfirmBtn setEnabled:NO];
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
        [verificationCodeInputView.mobileConfirmBtn setEnabled:YES];
        
        if (confirmTimer)
        {
            [confirmTimer invalidate];
            confirmTimer = nil;
        }
        return;
    }
    else
    {
        [verificationCodeInputView.mobileConfirmBtn setEnabled:NO];
        [verificationCodeInputView.mobileConfirmBtn setTitle:[NSString stringWithFormat:@"%ld秒后重发", tick] forState:UIControlStateDisabled];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
    
    if ([taskname isEqualToString:@"UserModifyPwdTask"])
    {
        NSString* resetPsdStr = pwdConfirmInputView.tfPassowrd.text;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resetPasswordNoti" object:self userInfo:@{@"nameNoti":resetPsdStr}];
        [self.view showAlertMessage:@"密码重置成功，请登录"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if ([taskname isEqualToString:@"UserMobileConfirmTask"])
    {
        NSLog(@"获取验证码....");
        [self startCountDown];
        return;
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

@end
