//
//  UserLoginViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserLoginViewController.h"
#import "UserRegisterViewController.h"
#import "ForgetPasswordIDCardViewController.h"
//#import "ForgetPasswordViewController.h"

#import "UserLoginServiceProcotolViewController.h"
#import "LoginView.h"
#import "InitializeViewController.h"
#import "AppDelegate.h"
#import "InitializationHelper.h"
//#import "HMPhoneNumberUtil.h"

@interface UserLoginViewController ()
<UITextFieldDelegate,
TaskObserver,InitializeHelperDelegate>
{
    CGFloat keyboardHeight;
    LoginView *loginview;
    UIImageView *ivBottomLine;

    UILabel* lbProtocol;
    UIButton* protocolBtn;
}
@property (nonatomic, strong) UIImageView *ivBottom;
@end

@implementation UserLoginViewController

- (void)dealloc
{
    [[NSNotificationCenter  defaultCenter] removeObserver:self  name:@"resetPasswordNoti" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createControls];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passwodResetChange:) name:@"resetPasswordNoti" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)passwodResetChange:(NSNotification*)notification
{
    NSDictionary *nameDictionary = [notification userInfo];
    
    loginview.tfPassword.text = [nameDictionary objectForKey:@"nameNoti"];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createControls
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    loginview = [[LoginView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:loginview];
    loginview.scrollEnabled = YES;
    
    _ivBottom = [[UIImageView alloc] init];
    [_ivBottom setImage:[UIImage imageNamed:@"bottom_client"]];
    [self.view addSubview:_ivBottom];
    
    lbProtocol = [[UILabel alloc] init];
    [self.view addSubview:lbProtocol];
    [lbProtocol setText:@"登录即表示您同意"];
    [lbProtocol setFont:[UIFont font_28]];
    [lbProtocol setTextColor:[UIColor whiteColor]];
    
    protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:protocolBtn];
    [protocolBtn setTitle:@"聚悦健康服务协议" forState:UIControlStateNormal];
    [protocolBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [protocolBtn.titleLabel setFont:[UIFont font_28]];
    [protocolBtn addTarget:self action:@selector(protocolBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    ivBottomLine = [[UIImageView alloc]init];
    [self.view addSubview:ivBottomLine];
    [ivBottomLine setBackgroundColor:[UIColor whiteColor]];
    
    [loginview.forgetPasswordButton addTarget:self action:@selector(forgetPasswordButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [loginview.loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [loginview.tfPassword setDelegate:self];
    
    [self subviewsLayout];
    
    NSString* loginAcct = [[UserInfoHelper defaultHelper] loginAcct];
    if (loginAcct && 0 < loginAcct.length)
    {
        [loginview.tfUserName setText:loginAcct];
    }
}

- (void) subviewsLayout
{
    [_ivBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_offset(ObjHeight(100));
    }];
    
    [lbProtocol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.offset(-60);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
        make.height.mas_equalTo(@25);
    }];
    
    [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbProtocol.mas_right);
        make.top.equalTo(lbProtocol);
        make.height.mas_equalTo(@25);
    }];
    
    [ivBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(protocolBtn);
        make.bottom.equalTo(protocolBtn.mas_bottom).with.offset(-2);
        make.height.mas_equalTo(@1);
    }];
}

- (void)protocolBtnClick
{
    UserLoginServiceProcotolViewController* vcServiceProcotol = [[UserLoginServiceProcotolViewController alloc] init];
    [self.navigationController pushViewController:vcServiceProcotol animated:YES];
}

- (void) keyboardWillHide:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    keyboardHeight = 0;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    loginview.frame = CGRectMake(0, 0, loginview.width, loginview.height);//64-216
    [UIView commitAnimations];
}

- (void) keyboardWillShow:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    keyboardHeight = keyboardSize.height;
    
    if (loginview.loginButton)
    {
        CGFloat offsetHeight = loginview.height - 32 - (keyboardHeight + loginview.loginButton.bottom);
        
        if (offsetHeight > 0) {
            
            offsetHeight = 0;
        }
        
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //将视图的Y坐标向上移动
        loginview.frame = CGRectMake(0, offsetHeight, loginview.width, loginview.height);//64-216
        
        [UIView commitAnimations];
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

- (void)loginButtonClicked:(id) sender
{
    NSString* loginacct = loginview.tfUserName.text;
    BOOL acctValid = [self validateLoginAccount];
    if (!acctValid)
    {
        [self showAlertMessage:@"请输入身份证号或手机号。"];
        return;
    }
    
    NSString* loginpwd = loginview.tfPassword.text;
    if (!loginpwd || 6 > loginpwd.length || 18 < loginpwd.length)
    {
        [self showAlertMessage:@"请输入6～18位登录密码。"];
        return;
    }
    
    NSMutableDictionary* dicParam = [NSMutableDictionary dictionary];
    [dicParam setValue:loginacct forKey:@"logonAcct"];
    [dicParam setValue:loginpwd forKey:@"password"];
    
    [self.view showWaitView:@"用户登录中..."];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserLoginTask" taskParam:dicParam TaskObserver:self];
}

- (BOOL) validateLoginAccount
{
    BOOL valid = NO;
    NSString* loginacct = loginview.tfUserName.text;
    if (!loginacct || loginacct.length == 0) {
        
        return valid;
    }
    NSInteger acctLenght = loginacct.length;
    switch (acctLenght) {
        case 11:
        {
            //验证是否是手机号
            valid = [CommonFuncs mobileIsValid:loginacct];
            break;
        }
        case 15:
        case 18:
        {
            //验证是否是身份证号
            valid = [CommonFuncs validateIDCardNumber:loginacct];
            break;
        }
        default:
            break;
    }
    
    return valid;
}

/*- (void) registerButtonClicked:(id) sender
{
    UserRegisterViewController* vcRegister = [[UserRegisterViewController alloc]init];
    [self.navigationController pushViewController:vcRegister animated:YES];
}*/
- (void)forgetPasswordButtonClicked
{
    ForgetPasswordIDCardViewController* vcForgetPsd = [[ForgetPasswordIDCardViewController alloc]init];
    vcForgetPsd.idCard = loginview.tfUserName.text;
//    ForgetPasswordViewController* forgetPwdVC = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:vcForgetPsd animated:YES];
}

#pragma mark -- textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyDone)
    {
        [textField resignFirstResponder];
    }
    
    if (textField.returnKeyType == UIReturnKeyJoin)
    {
        [self loginButtonClicked:nil];
    }
    
    return NO;
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
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
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"UserLoginTask"] && StepError_None != taskError)
    {
        //跳转到启动页面
        InitializeViewController* vcInit = [[InitializeViewController alloc]initWithNibName:nil bundle:nil];
        AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;;
        [app.window setRootViewController:vcInit];
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"UserLoginTask"])
    {
        //保存用户信息和医生信息
        if (taskResult)
        {
//            InitializationHelper* initHelper = [InitializationHelper defaultHelper];
//            [initHelper setDelegate:self];
//            [initHelper startInitialize];
            AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            
            InitializeViewController* vcInit = [[InitializeViewController alloc]initWithNibName:nil bundle:nil];
            [app.window setRootViewController:vcInit];
        }
        
        //[self closeView];
    }
}

- (void) initializeError:(NSInteger) errorCode
                 Message:(NSString*) errMsg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:errMsg preferredStyle:UIAlertControllerStyleAlert];
    //添加确定
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        exit(0);
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end

