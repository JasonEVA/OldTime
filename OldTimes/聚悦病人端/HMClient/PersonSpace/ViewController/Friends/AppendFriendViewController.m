//
//  AppendFriendViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppendFriendViewController.h"

@interface AppendFriendInputCell : UIView
{
    UILabel* lbName;
}
@property (nonatomic, readonly) UITextField* tfValue;

@end

@implementation AppendFriendInputCell

- (id) initWithName:(NSString*) aName
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        lbName = [[UILabel alloc]init];
        [self addSubview:lbName];
        [lbName setText:aName];
        [lbName setFont:[UIFont font_28]];
        [lbName setTextColor:[UIColor commonGrayTextColor]];
        [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
        }];
        
        
        _tfValue = [[UITextField alloc]init];
        [self addSubview:_tfValue];
        
        [_tfValue setFont:[UIFont font_30]];
        [_tfValue setTextColor:[UIColor blackColor]];
        [_tfValue mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.equalTo(self).with.offset(-12.5);
            make.left.equalTo(lbName.mas_right).with.offset(5);
            make.height.mas_equalTo(32);
            make.centerY.equalTo(self);
        }];
        
        [_tfValue setReturnKeyType:UIReturnKeyDone];
        
        [self showBottomLine];
    }
    
    return self;
}

@end

@interface AppendFriendViewController ()
<UITextFieldDelegate,
TaskObserver>
{
    AppendFriendInputCell* relationCell;
    AppendFriendInputCell* nameCell;
    AppendFriendInputCell* loginCell;
    AppendFriendInputCell* pwdCell;
}
@end

@implementation AppendFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"添加亲友"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [self createCells];
    
    UIButton* appendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:appendButton];
    [appendButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [appendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [appendButton setTitle:@"添加" forState:UIControlStateNormal];
    [appendButton.titleLabel setFont:[UIFont font_30]];
    appendButton.layer.cornerRadius = 2.5;
    appendButton.layer.masksToBounds = YES;
    
    [appendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.bottom.equalTo(self.view).with.offset(-10);
        make.height.mas_equalTo(@45);
    }];
    
    [appendButton addTarget:self action:@selector(appendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createCells
{
    UIView* lineview = [[UIView alloc]init];
    [self.view addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_offset(0.5);
        make.top.equalTo(self.view).with.offset(10);
    }];
    
    relationCell = [[AppendFriendInputCell alloc]initWithName:@"亲友关系:"];
    [self.view addSubview:relationCell];
    [relationCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(lineview.mas_bottom);
        make.height.mas_equalTo(@50);
    }];
    [relationCell.tfValue setDelegate:self];
    
    nameCell = [[AppendFriendInputCell alloc]initWithName:@"亲友姓名:"];
    [self.view addSubview:nameCell];
    [nameCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(relationCell.mas_bottom);
        
        make.height.mas_equalTo(@50);
    }];
    [nameCell.tfValue setDelegate:self];
    
    loginCell = [[AppendFriendInputCell alloc]initWithName:@"亲友的账号:"];
    [self.view addSubview:loginCell];
    [loginCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(nameCell.mas_bottom);
        make.height.mas_equalTo(@50);
    }];
    [loginCell.tfValue setDelegate:self];
    
    pwdCell = [[AppendFriendInputCell alloc]initWithName:@"亲友的密码:"];
    [self.view addSubview:pwdCell];
    [pwdCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(loginCell.mas_bottom);
        make.height.mas_equalTo(@50);
    }];
    
    [pwdCell.tfValue setDelegate:self];
    [pwdCell.tfValue setSecureTextEntry:YES];
}

- (void) appendButtonClicked:(id) sender
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    
    NSString* relationStr = relationCell.tfValue.text;
    if (!relationStr || 0 == relationStr.length) {
        [self showAlertMessage:@"请输入亲友与您的关系。"];
        return;
    }
    [dicPost setValue:relationStr forKey:@"relativeName"];
    
    NSString* nameStr = nameCell.tfValue.text;
    if (!nameStr || 0 == nameStr.length) {
        [self showAlertMessage:@"请输入亲友的姓名。"];
        return;
    }
    [dicPost setValue:nameStr forKey:@"relativeFriendName"];
    
    NSString* loginStr = loginCell.tfValue.text;
    if (!loginStr || 0 == loginStr.length) {
        [self showAlertMessage:@"请输入亲友的账号。"];
        return;
    }
    [dicPost setValue:loginStr forKey:@"relativeUserLogonAcc"];
    
    NSString* pwdStr = pwdCell.tfValue.text;
    if (!pwdStr || 0 == pwdStr.length) {
        [self showAlertMessage:@"请输入亲友的登录密码。"];
        return;
    }
    [dicPost setValue:pwdStr forKey:@"relativeUserLogonPwd"];
    //添加好友 AddUserFriendRelativeTask
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"AddUserFriendRelativeTask" taskParam:dicPost TaskObserver:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

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
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"AddUserFriendRelativeTask"])
    {
        //添加亲友成功，跳转到亲友列表界面
        [HMViewControllerManager createViewControllerWithControllerName:@"FriendsStartViewController" ControllerObject:nil];
    }

    
}

@end
