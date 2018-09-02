//
//  JapanPasswordLoginViewController.m
//  launcher
//
//  Created by williamzhang on 16/4/6.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "JapanPasswordLoginViewController.h"
#import "JapanForgetPasswordViewController.h"
#import "JapanRegisterViewController.h"
#import "UnifiedUserInfoManager.h"
#import "UnifiedLoginManager.h"
#import <DateTools/DateTools.h>
#import "CompanyListRequest.h"
#import "LALoginRequest.h"
#import "LALoginResultModel.h"
#import "CompanyModel.h"
#import "NSString+Manager.h"
#import "SettingModel.h"
#import <Masonry/Masonry.h>
#import "JapanInputView.h"
#import "AppDelegate.h"
#import "MyDefine.h"

#define MOVE_OFFSET -110

@interface JapanPasswordLoginViewController () <BaseRequestDelegate>

@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, strong) JapanInputView *inputView;

@property(nonatomic, strong) UIButton  *forgetPsdBtn;

@property(nonatomic, strong) UIButton  *registBtn;

@property(nonatomic, strong) UILabel  *editionLabel;

@property (nonatomic, strong) MASConstraint *centerYConstraint;

@end

@implementation JapanPasswordLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initComponents];
}

- (void)initComponents
{
    UIImageView *backgroundImageView  =[[UIImageView alloc] init];
    backgroundImageView.image = [UIImage imageNamed:@"login_BgView"];
    
    backgroundImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [backgroundImageView addGestureRecognizer:tap];
    
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.view);
        self.centerYConstraint = make.centerY.equalTo(self.view);
    }];
   
    //logo
    [backgroundImageView addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundImageView).offset(40);
        make.width.equalTo(@121);
        make.height.equalTo(@136);
        make.centerX.equalTo(backgroundImageView);
    }];
    [backgroundImageView addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(28);
        make.left.equalTo(backgroundImageView).offset(25);
        make.right.equalTo(backgroundImageView).offset(-25);
        make.centerY.equalTo(backgroundImageView).priorityLow();
    }];
    
    [backgroundImageView addSubview:self.forgetPsdBtn];
    [self.forgetPsdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputView).offset(7);
		
		if (IOS_DEVICE_4) {
			make.top.equalTo(self.inputView.mas_bottom).offset(5);
		} else {
			make.top.equalTo(self.inputView.mas_bottom).offset(28);
		}
    }];
    
    [backgroundImageView addSubview:self.registBtn];
    [self.registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputView).offset(-7);
        make.centerY.equalTo(self.forgetPsdBtn);
    }];
    
    [backgroundImageView addSubview:self.editionLabel];
    [self.editionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundImageView);
		
		if (IOS_DEVICE_4) {
			make.bottom.equalTo(self.view).offset(-5);
		} else {
			make.bottom.equalTo(self.view).offset(-10);
		}
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Private Method
- (void)checkInfomationWithAccount:(NSString *)account password:(NSString *)password {
    if (![NSString checkValuableWithString:account]) {
        [self postError:LOCAL(LOGINCLASS_ERROR1)];
        return;
    }
    
    if (![password length]) {
        [self postError:LOCAL(LOGINCLASS_ERROR2)];
        return;
    }
    
    // 净化用户名
    NSString *accountString = [NSString removeBlankInString:account OnlyMarginal:NO];
    CompanyListRequest *request = [[CompanyListRequest alloc] initWithDelegate:self];
    [request getCompanyListWithLoginName:accountString password:password];
    
    [self postLoading];
}

#pragma mark - eventRepond
- (void)findPsdAction
{
    JapanNaviForgetPasswordViewController *VC = [[JapanNaviForgetPasswordViewController alloc] init];
    [self presentViewController:VC animated:YES completion:nil];
}

- (void)registAction
{
    JapanNaviRegisterViewController *VC = [[JapanNaviRegisterViewController alloc] init];
    [self presentViewController:VC animated:YES completion:nil];
}

- (void)dismissKeyboard {
    [self.inputView recoverKeyboard];
}

#pragma mark - Keyborad Change
/** 开始移动（textField开始编辑） */
- (void)beginMoveOffsetEditingBegin:(BOOL)isBegin
{
    if (!(IOS_DEVICE_5 || IOS_DEVICE_4))
    {
        return;
    }
    
    CGFloat offset = !isBegin ? 0.0 : MOVE_OFFSET;
    self.centerYConstraint.offset = offset;

    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    [self beginMoveOffsetEditingBegin:YES];;
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [self beginMoveOffsetEditingBegin:NO];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([request isKindOfClass:[CompanyListRequest class]]) {
        NSArray *companyList = [(id)response companyList];
        
        AppDelegate *aDelegate = [UIApplication sharedApplication].delegate;
        aDelegate.controllerManager.companyList = companyList;
        
        CompanyModel *companyModel = [companyList firstObject];
        
        UnifiedUserInfoManager *userInfo = [UnifiedUserInfoManager share];
        
        [userInfo saveAccount:[NSString removeBlankInString:self.inputView.account OnlyMarginal:NO]];
        [userInfo savePassword:self.inputView.password];
        
        if ([companyList count] == 1) {
            // 只有1个公司，直接走登录
            [self postLoading];
            
            [userInfo setCompanyCode:companyModel.code];
            [userInfo setCompanyShowID:companyModel.showId];
            [userInfo setCompanyName:companyModel.name];
            
            LALoginRequest *request = [[LALoginRequest alloc] initWithDelegate:self];
            [request loginName:[NSString removeBlankInString:self.inputView.account OnlyMarginal:NO] password:self.inputView.password];
        }
        else {
            SettingModel *settingModel = [[UnifiedLoginManager share] findDataModelWithLoginName:[[UnifiedUserInfoManager share] getAccountWithEncrypt:YES]];
            if (settingModel && [settingModel.graphicPassword length]) {
                settingModel.isLogin = @YES;
                [[UnifiedLoginManager share] insertData:settingModel];
                
                [aDelegate.controllerManager showCompany];
            }
            
            else {
                [aDelegate.controllerManager showGraphicSetting];
            }
            
            [self hideLoading];
        }
    }
    
    if ([response isKindOfClass:[LALoginResponse class]]) {
        LALoginResultModel *resultModel = [(LALoginResponse *)response resultModel];
        
        [[UnifiedUserInfoManager share] setUserShowID:resultModel.userShowId];
        [[UnifiedUserInfoManager share] setUserName:resultModel.userTrueName];
        [[UnifiedUserInfoManager share] setLoginName:resultModel.userName];
        [[UnifiedUserInfoManager share] setAuthToken:resultModel.lastLoginToken];
        
        // sqlLogin －－ 数据库登录
        // 首先获取本地数据库的数据
        SettingModel *settingModel = [[UnifiedLoginManager share] findDataModelWithLoginName:[[UnifiedUserInfoManager share] getAccountWithEncrypt:YES]];
        AppDelegate *aDelegate = [UIApplication sharedApplication].delegate;
        if (settingModel && [settingModel.graphicPassword length]) {
            settingModel.isLogin = @YES;
            [[UnifiedLoginManager share] insertData:settingModel];
            
            [aDelegate.controllerManager showHome];
        }
        else {
            [aDelegate.controllerManager showGraphicSetting];
        }
        [self hideLoading];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - Initializer
- (UIImageView *)logoImageView
{
    if (!_logoImageView)
    {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"WorkHub"];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logoImageView;
}

- (JapanInputView *)inputView
{
    if (!_inputView)
    {
        _inputView = [[JapanInputView alloc] init];
        _inputView.layer.cornerRadius = 4;
        _inputView.layer.masksToBounds = YES;
        
        __weak typeof(self) weakSelf = self;
        [_inputView LoginActionWithBlcok:^(NSString *phoneNumber, NSString *password, NSString *validCode) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf checkInfomationWithAccount:phoneNumber password:password];
        }];
        
        //TODO:获取验证码
        [_inputView getValidCodeWithBlock:^(NSString *validcode) {
            
        }];
    }
    return _inputView;
}

- (UIButton *)forgetPsdBtn
{
    if (!_forgetPsdBtn)
    {
        _forgetPsdBtn = [[UIButton alloc] init];
        [_forgetPsdBtn setTitle:LOCAL(LOGINCLASS_FORGETPSD) forState:UIControlStateNormal];
        [_forgetPsdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _forgetPsdBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_forgetPsdBtn addTarget:self action:@selector(findPsdAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _forgetPsdBtn;
}

- (UIButton *)registBtn
{
    if (!_registBtn)
    {
        _registBtn = [[UIButton alloc] init];
        [_registBtn setTitle:LOCAL(REGISTER_ACCOUNT) forState:UIControlStateNormal];
        [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_registBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registBtn;
}

- (UILabel *)editionLabel
{
    if (!_editionLabel)
    {
        _editionLabel = [[UILabel alloc] init];
        _editionLabel.textColor = [UIColor whiteColor];
        _editionLabel.font  = [UIFont systemFontOfSize:8];
        _editionLabel.text  = [NSString stringWithFormat:@"Copyright © %ld WorkHub,Inc. All rights reserved.", [[NSDate date] year]];
    }
    return _editionLabel;
}

@end
