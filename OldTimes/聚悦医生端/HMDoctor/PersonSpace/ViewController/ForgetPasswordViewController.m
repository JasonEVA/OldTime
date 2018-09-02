//
//  ForgetPasswordViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/28.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ForgetPasswordInputView.h"

@interface ForgetPasswordViewController ()<TaskObserver>
{
    ForgetPasswordInputView* verificationCodeInputView;
    ForgetPasswordInputView* pwdInputView;
    ForgetPasswordInputView* pwdConfirmInputView;
    
    NSTimer* confirmTimer;
    UIButton* confirmBtn;
    NSInteger tick;
}
@end

@implementation ForgetPasswordViewController

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
    verificationCodeInputView = [[ForgetPasswordInputView alloc]init];
    [self.view addSubview:verificationCodeInputView];
    [verificationCodeInputView setName:@"验证码:"];
    [verificationCodeInputView setPlaceholder:@"请输入手机收到的验证码"];
    [verificationCodeInputView.tfPassowrd setSecureTextEntry:NO];
    
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
    [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [confirmBtn addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [confirmBtn.layer setCornerRadius:5];
    [confirmBtn.layer setMasksToBounds:YES];
    
    [self subviewLayout];
}

- (void) subviewLayout
{
    [verificationCodeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(14);
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
        NSLog(@"%@",taskResult);
        [self.view showAlertMessage:@"密码重置成功，请登录"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}


#pragma mark - TaskObserver
/*- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    if (taskId)
    {
        NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
        if (!taskname && 0 < taskname.length) {
            return;
        }
        if ([taskname isEqualToString:@"UserModifyPwdTask"])
        {
            [self.view showAlertMessage:@"密码修改成功，请登录"];
            [self.view endEditing:YES];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
}*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
