//
//  UserRegisterViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/28.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserRegisterViewController.h"

@interface UserRegisterTextField : UITextField



@end

@implementation UserRegisterTextField

- (CGRect) placeholderRectForBounds:(CGRect)bounds
{
    CGRect rect = bounds;
    rect.origin.x += 12;
    rect.size.width -= 24;
    return rect;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = bounds;
    rect.origin.x += 12;
    rect.size.width -= 24;
    return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = bounds;
    rect.origin.x += 12;
    rect.size.width -= 24;
    return rect;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect rect = bounds;
    rect.origin.x = bounds.size.width - 100;
    rect.size.width = 100;
    rect.origin.y = 2;
    rect.size.height -= 4;
    return rect;
}

@end

@interface UserRegisterViewController ()
<UITextFieldDelegate,
TaskObserver>
{
    CGFloat keyboardHeight;
    
    UIControl* closeControl;
    
    UITextField* tfIDCard;
    UITextField* tfPassword;
    UITextField* tfPwdConfirm;
    UITextField* tfMobile;
    UITextField* tfMobileConfirm;
    
    UIButton* confirmButton;
    
    UIButton* registerButton;
    UILabel* lbLicence;
    
    UITextField* editingField;
    UIButton* licenseButton;
    
    NSTimer* confirmTimer;
    NSInteger tick;
}
@end

@implementation UserRegisterViewController

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if (confirmTimer)
    {
        [confirmTimer invalidate];
        confirmTimer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationItem setTitle:@"注册"];
    
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    closeControl = [[UIControl alloc]initWithFrame:self.view.bounds];
    [self.view addSubview: closeControl];
    [closeControl setBackgroundColor:[UIColor commonBackgroundColor]];
    [closeControl setHeight:(self.view.height - 66)];
    
    tfIDCard = [[UserRegisterTextField alloc]init];
    [tfIDCard setFont:[UIFont font_30]];
    [closeControl addSubview:tfIDCard];
    [tfIDCard setPlaceholder:@"请输入身份证号"];
    [tfIDCard setBackgroundColor:[UIColor whiteColor]];
    [tfIDCard setKeyboardType:UIKeyboardTypeASCIICapable];
    
    tfPassword = [[UserRegisterTextField alloc]init];
    [tfPassword setFont:[UIFont font_30]];
    [closeControl addSubview:tfPassword];
    [tfPassword setPlaceholder:@"请输入密码（6-20位）"];
    [tfPassword setBackgroundColor:[UIColor whiteColor]];
    [tfPassword setKeyboardType:UIKeyboardTypeASCIICapable];
    [tfPassword setSecureTextEntry:YES];
    
    tfPwdConfirm = [[UserRegisterTextField alloc]init];
    [tfPwdConfirm setFont:[UIFont font_30]];
    [closeControl addSubview:tfPwdConfirm];
    [tfPwdConfirm setPlaceholder:@"请在次输入密码（6-20位）"];
    [tfPwdConfirm setBackgroundColor:[UIColor whiteColor]];
    [tfPwdConfirm setKeyboardType:UIKeyboardTypeASCIICapable];
    [tfPwdConfirm setSecureTextEntry:YES];
    
    tfMobile = [[UserRegisterTextField alloc]init];
    [tfMobile setFont:[UIFont font_30]];
    [closeControl addSubview:tfMobile];
    [tfMobile setPlaceholder:@"请输入手机号"];
    [tfMobile setBackgroundColor:[UIColor whiteColor]];
    [tfMobile setKeyboardType:UIKeyboardTypeNumberPad];
    
    tfMobileConfirm = [[UserRegisterTextField alloc]init];
    [tfMobileConfirm setFont:[UIFont font_30]];
    [closeControl addSubview:tfMobileConfirm];
    [tfMobileConfirm setPlaceholder:@"请输入验证码"];
    [tfMobileConfirm setBackgroundColor:[UIColor whiteColor]];
    [tfMobileConfirm setKeyboardType:UIKeyboardTypeASCIICapable];
    
    confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setFrame:CGRectMake(0, 0, 96, 38)];
    //[tfMobile addSubview:confirmButton];
    [confirmButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 44) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [confirmButton.layer setCornerRadius:2.5];
    [confirmButton.layer setMasksToBounds:YES];
    [confirmButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:[UIFont font_30]];
    [confirmButton addTarget:self action:@selector(mobileConfirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [tfMobile setRightView:confirmButton];
    [tfMobile setRightViewMode:UITextFieldViewModeAlways];
    
    for (UIView* subview in [closeControl subviews])
    {
        if (![subview isKindOfClass:[UITextField class]])
        {
            continue;
        }
        
        UITextField* tfSub = (UITextField*) subview;
        [tfSub setDelegate:self];
        [tfSub setReturnKeyType:UIReturnKeyDone];
        [tfSub setClearButtonMode:UITextFieldViewModeWhileEditing];
    }
    
    registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 44) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [closeControl addSubview:registerButton];
    [registerButton.layer setCornerRadius:2.5];
    [registerButton.layer setMasksToBounds:YES];
    [registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton.titleLabel setFont:[UIFont font_30]];
    [registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    lbLicence = [[UILabel alloc]init];
    [lbLicence setBackgroundColor:[UIColor clearColor]];
    [lbLicence setFont:[UIFont font_24]];
    [lbLicence setTextColor:[UIColor commonLightGrayTextColor]];
    [lbLicence setText:@"我已阅读并同意聚悦健康"];
    [closeControl addSubview:lbLicence];
    
    licenseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [licenseButton setTitle:@"注册协议" forState:UIControlStateNormal];
    [licenseButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
    [licenseButton.titleLabel setFont:[UIFont font_24]];
    [closeControl addSubview:licenseButton];
    
    [self subviewLayout];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) subviewLayout
{
    [tfIDCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(closeControl).with.offset(15);
        make.left.equalTo(closeControl);
        make.right.equalTo(closeControl);
        make.height.mas_equalTo(42);
    }];
    
    [tfPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tfIDCard.mas_bottom).with.offset(4);
        make.left.equalTo(closeControl);
        make.right.equalTo(closeControl);
        make.height.mas_equalTo(42);
    }];
    
    [tfPwdConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tfPassword.mas_bottom).with.offset(4);
        make.left.equalTo(closeControl);
        make.right.equalTo(closeControl);
        make.height.mas_equalTo(42);
    }];
    
    [tfMobile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tfPwdConfirm.mas_bottom).with.offset(4);
        make.left.equalTo(closeControl);
        make.right.equalTo(closeControl);
        make.height.mas_equalTo(42);
    }];
    
    [tfMobileConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tfMobile.mas_bottom).with.offset(4);
        make.left.equalTo(closeControl);
        make.right.equalTo(closeControl);
        make.height.mas_equalTo(42);
    }];
    

    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(closeControl).with.offset(12);
        make.right.equalTo(closeControl).with.offset(-12);
        make.top.equalTo(tfMobileConfirm.mas_bottom).with.offset(22);
        make.height.mas_equalTo(@45);
    }];
    
    [lbLicence mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(closeControl).with.offset(12);
        make.top.equalTo(registerButton.mas_bottom).with.offset(9);
        make.height.mas_equalTo(@25);
    }];
    
    [licenseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbLicence.mas_right);
        make.top.equalTo(lbLicence);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@60);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) mobileConfirmButtonClicked:(id) sender
{
    for (UIView* subview in [closeControl subviews])
    {
        if (![subview isKindOfClass:[UITextField class]])
        {
            continue;
        }
        
        UITextField* tfSub = (UITextField*) subview;
        [tfSub resignFirstResponder];
    }
    
    NSString* mobile = tfMobile.text;
    if (![CommonFuncs mobileIsValid:mobile])
    {
        [self showAlertMessage:@"请输入正确的手机号码。"];
        return;
    }
    
    //获取手机验证码 UserMobileConfirmTask
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:mobile forKey:@"mobile"];
    [dicPost setValue:@"1" forKey:@"intent"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserMobileConfirmTask" taskParam:dicPost TaskObserver:self];
}

- (void) registerButtonClicked:(id) sender
{
    NSString* mobile = tfMobile.text;
    if (![CommonFuncs mobileIsValid:mobile])
    {
        [self showAlertMessage:@"请先进行手机号的验证。"];
        return;
    }
    
    NSString* idCard = tfIDCard.text;
    if (![CommonFuncs validateIDCardNumber:idCard]) {
        [self showAlertMessage:@"您输入的身份证号不正确，请输入正确的身份证号。"];
        return;
    }
    
    NSString* password = tfPassword.text;
    if (!password || 6 > password.length || 20 < password.length)
    {
        [self showAlertMessage:@"请输入6-20位登录密码。"];
        return;
    }
    
    NSString* pwdConfirm = tfPwdConfirm.text;
    if (!pwdConfirm || 6 > pwdConfirm.length || 20 < pwdConfirm.length)
    {
        [self showAlertMessage:@"请输入6-20位登录密码确认。"];
        return;
    }
    
    if(![password isEqualToString:pwdConfirm])
    {
        [self showAlertMessage:@"您再次输入的密码和密码不一致, 请重新输入您的登录密码，或再次确认您的登录密码。"];
        return;
    }
    
    NSString* mobileConfirm = tfMobileConfirm.text;
    if (!mobileConfirm || 0 == mobileConfirm.length)
    {
        [self showAlertMessage:@"请输入您收到的手机验证码。"];
        return;
    }
    
    //UserRegisterTask
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:idCard forKey:@"idCard"];
    [dicPost setValue:mobile forKey:@"mobile"];
    [dicPost setValue:password forKey:@"password"];
    [dicPost setValue:mobileConfirm forKey:@"confirm"];
    
    [self.view showWaitView:@"注册新用户"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserRegisterTask" taskParam:dicPost TaskObserver:self];
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
        [confirmButton setEnabled:YES];
        
        if (confirmTimer)
        {
            [confirmTimer invalidate];
            confirmTimer = nil;
        }
        return;
    }
    else
    {
        [confirmButton setEnabled:NO];
        [confirmButton setTitle:[NSString stringWithFormat:@"%ld秒后重发", tick] forState:UIControlStateDisabled];
    }
}

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    keyboardHeight = keyboardSize.height;
    ///keyboardWasShown = YES;
    
    if (editingField)
    {
        CGFloat offsetHeight = closeControl.height - 32 - (keyboardHeight + editingField.bottom);
        if (offsetHeight > 0) {
            offsetHeight = 0;
        }
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
        
        closeControl.frame = CGRectMake(0.0f, offsetHeight, closeControl.width, closeControl.height);//64-216
        
        [UIView commitAnimations];
    }
    
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    keyboardHeight = 0;
    // keyboardWasShown = NO;

    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    closeControl.frame = CGRectMake(0.0f, 0.0f, closeControl.width, closeControl.height);//64-216
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing %f", textField.bottom);
    editingField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    
    if (taskId)
    {
        NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
        if (!taskname && 0 < taskname.length) {
            return;
        }
        if ([taskname isEqualToString:@"UserMobileConfirmTask"])
        {
            NSLog(@"获取验证码....");
            [self startCountDown];
            return;
        }
        if ([taskname isEqualToString:@"UserRegisterTask"])
        {
            NSLog(@"用户注册.....");
            [[HMViewControllerManager defaultManager] entryMainPage];
            return;
        }
    }
}

@end
