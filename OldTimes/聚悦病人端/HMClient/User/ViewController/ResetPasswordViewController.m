//
//  ResetPasswordViewController.m
//  HMClient
//
//  Created by lkl on 16/4/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "ResetPasswordInputView.h"

@interface ResetPasswordViewController ()
<TaskObserver>
{
    ResetPasswordInputView* oriPwdInputView;            //原密码
    ResetPasswordInputView* pwdInputView;               //新密码
    ResetPasswordInputView* pwdConfirmInputView;        //新密码确认
    
    UIButton *resetButton;
}
@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.navigationItem setTitle:@"修改密码"];
    [self initContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initContentView
{
    //CGRect rtTable = self.view.bounds;
    
    oriPwdInputView = [[ResetPasswordInputView alloc]init];
    [self.view addSubview:oriPwdInputView];
    [oriPwdInputView setName:@"原密码:"];
    [oriPwdInputView setPlaceholder:@"请输入6-16位字母或数字密码"];
    
    pwdInputView = [[ResetPasswordInputView alloc]init];
    [self.view addSubview:pwdInputView];
    [pwdInputView setName:@"新密码:"];
    [pwdInputView setPlaceholder:@"请输入6-16位字母或数字密码"];
    
    pwdConfirmInputView = [[ResetPasswordInputView alloc]init];
    [self.view addSubview:pwdConfirmInputView];
    [pwdConfirmInputView setName:@"重复密码:"];
    [pwdConfirmInputView setPlaceholder:@"请重复输入密码"];
    
    
    resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:resetButton];
    
    [resetButton setTitle:@"确定修改" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resetButton setBackgroundColor:[UIColor mainThemeColor]];
    [resetButton.titleLabel setFont:[UIFont font_34]];
    [resetButton addTarget:self action:@selector(resetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [resetButton.layer setCornerRadius:5];
    [resetButton.layer setMasksToBounds:YES];
    
    [self subviewLayout];
}

- (void) subviewLayout
{
    [oriPwdInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(14);
        make.height.mas_equalTo(@50);
        make.left.and.right.equalTo(self.view);
    }];
    
    [pwdInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oriPwdInputView.mas_bottom).with.offset(4);
        make.height.mas_equalTo(@50);
        make.left.and.right.equalTo(self.view);
    }];
    
    [pwdConfirmInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdInputView.mas_bottom).with.offset(4);
        make.height.mas_equalTo(@50);
        make.left.and.right.equalTo(self.view);
    }];
    
    [resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(pwdConfirmInputView.mas_bottom).with.offset(40);
        make.right.equalTo(self.view).with.offset(-13);
        make.height.mas_equalTo(45);
    }];
}

- (void)resetButtonClicked:(UIButton*)sender
{
    [oriPwdInputView resignFirstResponder];
    [pwdInputView resignFirstResponder];
    [pwdConfirmInputView resignFirstResponder];
    
    NSString* oriPwd = oriPwdInputView.tfPassowrd.text;
    NSString* newPwd = pwdInputView.tfPassowrd.text;
    NSString* pwdConfirm = pwdConfirmInputView.tfPassowrd.text;
    
    if (!oriPwd || 6 > oriPwd.length || 20 < oriPwd.length)
    {
        [self showAlertMessage:@"请输入6-16位字母或数字原始密码。"];
        return;
    }
    if (!newPwd || 6 > newPwd.length || 20 < newPwd.length)
    {
        [self showAlertMessage:@"请输入6-16位字母或数字新密码。"];
        return;
    }
    
    if (!pwdConfirm || 6 > pwdConfirm.length || 20 < pwdConfirm.length)
    {
        [self showAlertMessage:@"请输入6-16位字母或数字密码确认。"];
        return;
    }
    
    if (![newPwd isEqualToString:pwdConfirm]) {
        [self showAlertMessage:@"您输入的新密码与密码确认不一致，请重新输入您的密码，或重新确认您的密码。"];
        return;
    }
    
    //
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    [dicPost setValue:oriPwd forKey:@"oldPassword"];
    [dicPost setValue:newPwd forKey:@"newPassword"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", curUser.userId] forKey:@"userId"];
    [self.view showWaitView:@"修改登录密码"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserResetPasswordTask" taskParam:dicPost TaskObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
    
    if ([taskname isEqualToString:@"UserResetPasswordTask"])
    {
        [self showAlertMessage:@"修改密码成功" clicked:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

@end
