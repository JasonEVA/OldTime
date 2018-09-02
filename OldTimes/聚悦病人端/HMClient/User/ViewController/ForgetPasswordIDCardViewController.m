//
//  ForgetPasswordIDCardViewController.m
//  HMClient
//
//  Created by lkl on 16/6/29.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ForgetPasswordIDCardViewController.h"
#import "ForgetPasswordViewController.h"

@interface ForgetPasswordIDCardViewController ()<TaskObserver>
{
    UIButton* nextButton;
    UITextField* tfIDCard;
    
    NSString* phoneNum;
}
@end

@implementation ForgetPasswordIDCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.navigationItem setTitle:@"重置密码"];
    
    [self initContentView];
}

- (void)initContentView
{
    tfIDCard = [[UITextField alloc]init];
    [tfIDCard setFont:[UIFont font_30]];
    [self.view addSubview:tfIDCard];
    [tfIDCard setPlaceholder:@"请输入身份证号或手机号"];
    [tfIDCard setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tfIDCard setBackgroundColor:[UIColor whiteColor]];
    [tfIDCard setKeyboardType:UIKeyboardTypeASCIICapable];
    
    tfIDCard.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tfIDCard.autocorrectionType = UITextAutocorrectionTypeNo;

    
    if ([CommonFuncs validateIDCardNumber:_idCard]){
        [tfIDCard setText:_idCard];
    }
    
    [tfIDCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(14);
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.height.mas_equalTo(42);
    }];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextButton];
    
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setBackgroundColor:[UIColor mainThemeColor]];
    [nextButton.titleLabel setFont:[UIFont font_34]];
    [nextButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [nextButton.layer setCornerRadius:5];
    [nextButton.layer setMasksToBounds:YES];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tfIDCard.mas_left);
        make.top.equalTo(tfIDCard.mas_bottom).with.offset(40);
        make.right.equalTo(tfIDCard.mas_right);
        make.height.mas_equalTo(45);
    }];
}

- (void)nextButtonClicked:(UIButton *)sender
{
    NSString* idCard = tfIDCard.text;
    
    if ([CommonFuncs mobileIsValid:idCard])
    {
        //输入手机号
        [self loadUserIdByMobile:idCard];
        return;
    }
    
    if ([CommonFuncs validateIDCardNumber:idCard]) {
        //输入为身份证号
        [self loadUserIdByIDCard:idCard];
        return;
    }
    
    [self showAlertMessage:@"请输入正确的身份证号或手机号。"];
    return;
    /*
    if (![CommonFuncs validateIDCardNumber:idCard]) {
        [self showAlertMessage:@"请输入正确的身份证号。"];
        return;
    }
    
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    [dicPost setValue:tfIDCard.text forKey:@"idCard"];
    [dicPost setValue:@"1" forKey:@"type"];
    
    [[TaskManager shareInstance]createTaskWithTaskName:@"UserMobileByIdCardTask" taskParam:dicPost TaskObserver:self];
     */
}

- (void) loadUserIdByMobile:(NSString*) mobile
{
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    [dicPost setValue:mobile forKey:@"mobile"];
//    [dicPost setValue:@"1" forKey:@"type"];
    
    [[TaskManager shareInstance]createTaskWithTaskName:@"UserMobileByMobileTask" taskParam:dicPost TaskObserver:self];

}

- (void) loadUserIdByIDCard:(NSString*) idCard
{
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    [dicPost setValue:idCard forKey:@"idCard"];
    [dicPost setValue:@"1" forKey:@"type"];
    
    [[TaskManager shareInstance]createTaskWithTaskName:@"UserMobileByIdCardTask" taskParam:dicPost TaskObserver:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if ([taskname isEqualToString:@"UserMobileByIdCardTask"] ||
        [taskname isEqualToString:@"UserMobileByMobileTask"])
    {
        NSLog(@"%@",taskResult);
        phoneNum = [taskResult valueForKey:@"mobile"];
        NSString* userId = [taskResult valueForKey:@"userId"];
        
        if (![CommonFuncs mobileIsValid:phoneNum])
        {
            [self.view showAlertMessage:@"绑定的手机号为空,无法修改密码!"];
            return;
        }
        
        ForgetPasswordViewController* vcForgetPassword = [[ForgetPasswordViewController alloc] init];
        vcForgetPassword.userId = userId;
        vcForgetPassword.phoneNum = phoneNum;
        [self.navigationController pushViewController:vcForgetPassword animated:YES];
    }

}


@end
