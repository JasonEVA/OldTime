//
//  PersonCommitIDCardViewController.m
//  HMClient
//
//  Created by yinquan on 2017/8/9.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PersonCommitIDCardViewController.h"

@interface PersonCommitIDCardView : UIView


@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) UIButton* closeButton;
@property (nonatomic, strong) UILabel* idcardLabel;
@property (nonatomic, strong) UITextField* idcardTextField;
@property (nonatomic, strong) UIButton* commitButton;

@end

@implementation PersonCommitIDCardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(45);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.centerY.equalTo(self.headerView);
        make.right.equalTo(self.headerView).offset(-15);
    }];
    
    [self.idcardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(15);
        make.left.equalTo(self).offset(15);
        make.width.equalTo(self).offset(-30);
    }];
    
    [self.idcardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idcardLabel.mas_bottom).offset(15);
        make.left.equalTo(self.idcardLabel);
        make.width.equalTo(self).offset(-30);
        make.height.mas_equalTo(@32);
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idcardTextField.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(155, 45));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-15);
    }];
}

#pragma mark - settingAndGetting
- (UIView*) headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        [self addSubview:_headerView];
        
        [_headerView setBackgroundColor:[UIColor mainThemeColor]];
    }
    return _headerView;
}

- (UIButton*) closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.headerView addSubview:_closeButton];
        
        [_closeButton setImage:[UIImage imageNamed:@"close_button_icon"] forState:UIControlStateNormal];
        [_closeButton setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    }
    return _closeButton;
}

- (UILabel*) idcardLabel
{
    if (!_idcardLabel) {
        _idcardLabel = [[UILabel alloc] init];
        [self addSubview:_idcardLabel];
        [_idcardLabel setTextColor:[UIColor commonTextColor]];
        [_idcardLabel setFont:[UIFont systemFontOfSize:15]];
        [_idcardLabel setNumberOfLines:0];
        UserInfo* curUser = [UserInfoHelper defaultHelper].currentUserInfo;
        NSString* idcardText = [NSString stringWithFormat:@"尊敬的%@用户,您好!\n健康管理服务要求实名认证,请输入您的身份证号码进行认证。", curUser.userName];
//        [_idcardLabel setText:idcardText];
        [_idcardLabel setText:idcardText lineSpacing:5];
    }
    return _idcardLabel;
}

- (UITextField*) idcardTextField
{
    if (!_idcardTextField) {
        _idcardTextField = [[UITextField alloc] init];
        [self addSubview:_idcardTextField];
        [_idcardTextField setFont:[UIFont systemFontOfSize:15]];
        [_idcardTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        
        _idcardTextField.layer.borderWidth = 1;
        _idcardTextField.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        _idcardTextField.layer.cornerRadius = 4;
        _idcardTextField.layer.masksToBounds = YES;
        _idcardTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _idcardTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _idcardTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        UserInfo* curUser = [UserInfoHelper defaultHelper].currentUserInfo;
        NSString* placeholderText = [NSString stringWithFormat:@"请输入%@的身份证号码", curUser.userName];
        [_idcardTextField setPlaceholder:placeholderText];
    }

    return _idcardTextField;
}

- (UIButton*) commitButton
{
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_commitButton];
        [_commitButton setTitle:@"立即认证" forState:UIControlStateNormal];
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_commitButton setBackgroundImage:[UIImage rectImage:CGSizeMake(200, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        
        _commitButton.layer.cornerRadius = 4;
        _commitButton.layer.masksToBounds = YES;
    }
    return _commitButton;
}

@end

@interface PersonCommitIDCardViewController ()
<TaskObserver>
@property (nonatomic, strong) CommitIDCardHandleBlock handleBlock;
@property (nonatomic, strong) PersonCommitIDCardView* commitView;

- (id) initWithCommitIDCardHandleBlock:(CommitIDCardHandleBlock) handleBlock;
@end

@implementation PersonCommitIDCardViewController

+ (void) showWithHandleBlock:(CommitIDCardHandleBlock) handleBlock
{
    PersonCommitIDCardViewController* commitViewController = [[PersonCommitIDCardViewController alloc] initWithCommitIDCardHandleBlock:handleBlock];
    UIViewController* rootViewController = [HMViewControllerManager defaultManager].tvcRoot;
    [rootViewController addChildViewController:commitViewController];
    [rootViewController.view addSubview:commitViewController.view];
    [commitViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootViewController.view);
    }];
    
}

- (id) initWithCommitIDCardHandleBlock:(CommitIDCardHandleBlock) handleBlock
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _handleBlock = handleBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonTranslucentColor]];
    [self layoutElements];
    
    [self.commitView.closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.commitView.commitButton addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) layoutElements
{
    [self.commitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-275);
        make.width.equalTo(self.view).offset(-25);
    }];
}

- (void) closeCommitView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}



#pragma mark - Button Event
- (void) closeButtonClicked:(id) sender
{
    [self closeCommitView];
}

- (void) commitButtonClicked:(id) sender
{
    NSString* idCardText = self.commitView.idcardTextField.text;
    if (!idCardText || idCardText.length == 0) {
        [self showAlertMessage:@"请输入身份证号。"];
        return;
    }
    
    if (![CommonFuncs validateIDCardNumber:idCardText]) {
        [self showAlertMessage:@"请输入身份证号。"];
        return;
    }
    
    //提交身份证号以验证。
    [self.view showWaitView];
    NSMutableDictionary* paramDictionary = [NSMutableDictionary dictionary];
    [paramDictionary setValue:idCardText forKey:@"idCard"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"BindUserIdCardTask" taskParam:paramDictionary TaskObserver:self];
}

#pragma mark - settingAndGetting
- (PersonCommitIDCardView*) commitView
{
    if (!_commitView) {
        _commitView = [[PersonCommitIDCardView alloc] init];
        [self.view addSubview:_commitView];
    }
    return _commitView;
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (taskError != StepError_None) {
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
    if ([taskname isEqualToString:@"BindUserIdCardTask"])
    {
        //重新获取用户信息，以更新用户信息
        [[TaskManager shareInstance] createTaskWithTaskName:@"UserInfoTask" taskParam:nil TaskObserver:self];
    }
    if ([taskname isEqualToString:@"UserInfoTask"])
    {
        [self.view closeWaitView];
        if (self.handleBlock) {
            self.handleBlock();
        }
        [self closeCommitView];
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
}

@end
