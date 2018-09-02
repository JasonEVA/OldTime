//
//  UserLoginViewController.m
//  HMDoctor
//
//  Created by yinquan on 16/4/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "UserLoginViewController.h"
#import "ForgetPasswordIDCardViewController.h"
#import "UserLoginServiceProcotolViewController.h"
#import "ClientHelper.h"
#import "LoginView.h"
#import "LoginAccount.h"
#import "UserLoginAccountTableViewController.h"
#import "LoginAccountTableViewCell.h"

#define ServiceAlertTag 0x4008

@interface UserLoginViewController ()
<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,
TaskObserver>
{
    CGFloat keyboardHeight;
    LoginView *loginview;
    UIImageView *ivBottomLine;
    UILabel* lbProtocol;
    UIButton* protocolBtn;
    
    UIWebView* webview;
    
    UILabel *versionsLb;
    
    NSString* loginacct;
    NSString* loginpwd;
    
    NSArray* accountList;
    UITableView* switchAccountTableView;
}
@property (nonatomic, strong) UIImageView *ivBottom;
@end

@implementation UserLoginViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LoginAccountUtil* util = [[LoginAccountUtil alloc] init];
    accountList = [util queryAccountList];
    
    [self createControls];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void) createControls
{
    LoginAccountUtil* util = [[LoginAccountUtil alloc] init];
    LoginAccountModel* accountModel = [util currentLoginAccount];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    loginview = [[LoginView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:loginview];
    loginview.scrollEnabled = YES;
    
    [loginview.closeControl addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventAllTouchEvents];
    
    _ivBottom = [[UIImageView alloc] init];
    [_ivBottom setImage:[UIImage imageNamed:@"bottom_doctor"]];
    [self.view addSubview:_ivBottom];
    
    lbProtocol = [[UILabel alloc] init];
    [self.view addSubview:lbProtocol];
    [lbProtocol setText:@"登录即表示您同意"];
    [lbProtocol setFont:[UIFont systemFontOfSize:14]];
    [lbProtocol setTextColor:[UIColor whiteColor]];
    
    protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:protocolBtn];
    [protocolBtn setTitle:@"聚悦健康服务协议" forState:UIControlStateNormal];
    [protocolBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [protocolBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [protocolBtn addTarget:self action:@selector(protocolBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    ivBottomLine = [[UIImageView alloc]init];
    [self.view addSubview:ivBottomLine];
    [ivBottomLine setBackgroundColor:[UIColor whiteColor]];
    
    [loginview.forgetPasswordButton addTarget:self action:@selector(forgetPasswordButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [loginview.loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [loginview.tfPassword setDelegate:self];
    [loginview.switchAccountButton addTarget:self action:@selector(switchAccountButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    versionsLb = [[UILabel alloc] init];
    [self.view addSubview:versionsLb];
    [versionsLb setText:HMVersions];
    [versionsLb setFont:[UIFont systemFontOfSize:14]];
    [versionsLb setTextColor:[UIColor whiteColor]];
    
    [self subviewsLayout];
    
//    NSString* loginAcct = [[UserInfoHelper defaultHelper] loginAcct];
    if (accountModel)
    {
        NSString* loginAcct = accountModel.loginAccount;
        NSString* loginPwd = accountModel.loginPassword;
        [loginview.tfUserName setText:loginAcct];
        [loginview.tfPassword setText:loginPwd];
    }
    else
    {
        NSString* loginAcct = [[UserInfoHelper defaultHelper] loginAcct];
        [loginview.tfUserName setText:loginAcct];
    }
//    if (loginAcct && 0 < loginAcct.length)
//    {
//        [loginview.tfUserName setText:loginAcct];
//    }
}

- (void) subviewsLayout
{
    [_ivBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_offset(@100);
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
    
    [versionsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(lbProtocol.mas_bottom).offset(2);
    }];
}

- (void) closeControlClicked:(id) sender
{
    [self closeSwitchAccountTableView];
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

#pragma mark - 切换登录账号
- (void) switchAccountButtonClicked:(id) sender
{
    if (![sender isKindOfClass:[UIButton class]])
    {
        return;
    }
    UIButton* switchButton = (UIButton*) sender;
    CGRect buttonFrame = [self.view convertRect:switchButton.frame fromView:switchButton];
    NSLog(@"buttonFrame.bottom %f", buttonFrame.origin.y);
    CGFloat tableTop = buttonFrame.origin.y + buttonFrame.size.height;
    [self showSwitchAccountTableView:tableTop];
    
}

- (void) showSwitchAccountTableView:(CGFloat) tableTop
{
    NSInteger accountMaxCount = 0;
    if (accountList)
    {
        accountMaxCount = accountList.count;
        if (accountMaxCount > 4)
        {
            accountMaxCount = 4;
        }
    }
    
    if (accountMaxCount == 0) {
        //没有记录登录账号，返回
        return;
    }
    if (!switchAccountTableView)
    {
        switchAccountTableView = [[UITableView alloc] initWithFrame:CGRectMake(15, tableTop, kScreenWidth - 30, 45 * accountMaxCount) style:UITableViewStylePlain];
        [switchAccountTableView setDataSource:self];
        [switchAccountTableView setDelegate:self];
        [self.view addSubview:switchAccountTableView];
    }
}

- (void) closeSwitchAccountTableView
{
    if (switchAccountTableView) {
        [switchAccountTableView removeFromSuperview];
        switchAccountTableView = nil;
    }
}

- (void)protocolBtnClick
{
    UserLoginServiceProcotolViewController* vcServiceProcotol = [[UserLoginServiceProcotolViewController alloc] init];
    [self.navigationController pushViewController:vcServiceProcotol animated:YES];
}

- (void)loginButtonClicked:(id) sender
{
    loginacct = loginview.tfUserName.text;
    if (!loginacct || 4 > loginacct.length || 18 < loginacct.length)
    {
        [self showAlertMessage:@"请输入4～18位登录名。"];
        return;
    }
    
    loginpwd = loginview.tfPassword.text;
    if (!loginpwd || 4 > loginpwd.length || 18 < loginpwd.length)
    {
        [self showAlertMessage:@"请输入4～18位登录密码。"];
        return;
    }
    
    NSMutableDictionary* dicParam = [NSMutableDictionary dictionary];
    [dicParam setValue:loginacct forKey:@"logonAcct"];
    [dicParam setValue:loginpwd forKey:@"password"];
    
    [self.view showWaitView:@"用户登录中..."];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserLoginTask" taskParam:dicParam TaskObserver:self];
}

- (void)forgetPasswordButtonClicked
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"现在不支持修改密码，修改密码请联系客服" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打客服", nil];
    [alert setTag:ServiceAlertTag];
    [alert show];
    /*ForgetPasswordIDCardViewController* vcForgetPsd = [[ForgetPasswordIDCardViewController alloc]init];
    [self.navigationController pushViewController:vcForgetPsd animated:YES];*/
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ServiceAlertTag)
    {
        if (buttonIndex == 1)
        {
            // 直接拨号，拨号完成后会停留在通话记录中
            /*NSURL *url = [NSURL URLWithString:@"tel://4008332616"];
            [[UIApplication sharedApplication] openURL:url];*/
            
            // 可以回来，注：不要将webView添加到self.view，如果添加会遮挡原有的视图
            if (webview == nil) {
                webview = [[UIWebView alloc] init];
            }
            //    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
            //    [self.view addSubview:_webView];
            
            NSURL *url = [NSURL URLWithString:@"tel://4008332616"];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            [webview loadRequest:request];
        }
    }
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

#pragma mark - UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    if (accountList) {
        return accountList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoginAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoginAccountTableViewCell"];
    if (!cell)
    {
        cell = [[LoginAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoginAccountTableViewCell"];
    }
    // Configure the cell...
    LoginAccountModel* model = accountList[indexPath.row];
    [cell setLoginAccountModel:model];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginAccountModel* accountModel = accountList[indexPath.row];
    NSString* loginAcct = accountModel.loginAccount;
    NSString* loginPwd = accountModel.loginPassword;
    [loginview.tfUserName setText:loginAcct];
    [loginview.tfPassword setText:loginPwd];
    
    [self closeSwitchAccountTableView];
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
    
    if ([taskname isEqualToString:@"UserLoginTask"])
    {
        //获取登录医生的权限
        StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
        
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.userId] forKey:@"userId"];
        [[TaskManager shareInstance] createTaskWithTaskName:@"StaffPrivilegeTask" taskParam:dicPost TaskObserver:self];
        
        return;
    }
    
    if ([taskname isEqualToString:@"StaffPrivilegeTask"])
    {
        // 获取医生快速入组权限
        StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];

        NSMutableDictionary* dicParam = [NSMutableDictionary dictionary];
        [dicParam setValue:[NSString stringWithFormat:@"%ld", staff.userId] forKey:@"userId"];
        [[TaskManager shareInstance] createTaskWithTaskName:@"HMGetUserInGroupPermissionRequest" taskParam:dicParam TaskObserver:self];
        
    }
    
    if ([taskname isEqualToString:@"HMGetUserInGroupPermissionRequest"])
    {
        //需要保存登录帐号和密码
        LoginAccountUtil* util = [[LoginAccountUtil alloc] init];
        StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
        [util appendAccount:loginacct password:loginpwd staffName:staff.staffName userPortrait:staff.staffIcon];
        [[HMViewControllerManager defaultManager] entryMainStart];

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
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuccessNotificationName object:nil];
        }
                
//        [[HMViewControllerManager defaultManager] entryMainStart];
        //[self closeView];
    }
    
    
}


@end
