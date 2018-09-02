//
//  PasswordLoginViewController.m
//  launcher
//
//  Created by William Zhang on 15/7/27.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "PasswordLoginViewController.h"
#import "UnifiedLoginManager.h"
#import "UnifiedUserInfoManager.h"
#import "UIImage+Manager.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "AppDelegate.h"
#import "SettingModel.h"
#import <NSDate+DateTools.h>
#import "Category.h"
#import "CompanyListRequest.h"
#import "LALoginRequest.h"
#import "LALoginResultModel.h"
#import "CompanyModel.h"
#import "MixpanelMananger.h"
#import "BaseNavigationController.h"
#import "WebViewController.h"
#import "JapanRegisterViewController.h"

#define HEAD_W       103
#define LEADING_TXFD 60
#define MOVE_OFFSET  -110.0

@interface PasswordLoginViewController () <UITextFieldDelegate, BaseRequestDelegate>

/** 背景图 */
@property (nonatomic, strong) UIImageView *imgViewBG;

@property (nonatomic, strong) UIImageView *imgViewHead;


@property(nonatomic, strong) UILabel *subTitleLbl;
/** ☁️ */
@property(nonatomic, strong) UIImageView *cloudView;

/** 信息输入 */
@property (nonatomic, strong) UITextField *txfdName;
@property (nonatomic, strong) UITextField *txfdPwd;

@property (nonatomic, strong) UIButton *btnLogin;

@property(nonatomic, strong) UIButton *forgetPswBtn;
//✉️
@property(nonatomic, strong) UIImageView  *eveLopIcon;
//下划线
@property(nonatomic, strong) UIView  *emailUnderLine;
//🔒
@property(nonatomic, strong) UIImageView  *psdIcon;
//🔒的下划线
@property(nonatomic, strong) UIView  *psdUnderLine;
//眼睛
@property(nonatomic, strong) UIButton  *eyeBtn;

@property(nonatomic, strong) UILabel  *appEditionLbl;

/** 试用申请 */
@property (nonatomic, strong) UIButton *applyButton;

// Data
/** 背景图的约束 */
@property (nonatomic, strong) MASConstraint *centerYConstraint;
/** 移动偏移量 */
@property (nonatomic, assign) CGFloat moveOffset;

@end

@implementation PasswordLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initComponents];
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

- (void)initComponents
{
    // 背景图
    [self.view addSubview:self.imgViewBG];
    
    // 头像
    [self.imgViewBG addSubview:self.imgViewHead];
    [self.imgViewBG addSubview:self.subTitleLbl];
    //☁️
    [self.imgViewBG addSubview:self.cloudView];
    
    [self.imgViewBG addSubview:self.txfdName];
    [self.imgViewBG addSubview:self.txfdPwd];
    
    [self.imgViewBG addSubview:self.btnLogin];
    //信封
    [self.imgViewBG addSubview:self.eveLopIcon];
    //锁
    [self.imgViewBG addSubview:self.psdIcon];
    //邮箱下方的下划线
    [self.imgViewBG addSubview:self.emailUnderLine];
    //密码下方的下划线
    [self.imgViewBG addSubview:self.psdUnderLine];
    //👀
    [self.imgViewBG addSubview:self.eyeBtn];
    
    [self.imgViewBG addSubview:self.appEditionLbl];
    
    [self.imgViewBG addSubview:self.applyButton];
    
    [self.imgViewBG addSubview:self.forgetPswBtn];
    
    [self initConstraints];
}

- (void)initConstraints
{
    // 背景图
    [self.imgViewBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.right.equalTo(self.view);
        make.height.equalTo(self.view);
        self.centerYConstraint = make.centerY.equalTo(self.view);
    }];
    
    //logo
    
    [self.imgViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imgViewBG);
        make.top.equalTo(self.imgViewBG).offset(104);
    }];
    
    [self.subTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imgViewBG);
        make.top.equalTo(self.imgViewHead.mas_bottom);
    }];
    //☁️
    [self.cloudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imgViewBG);
        make.left.right.equalTo(self.imgViewBG);
        if (!IOS_DEVICE_6Plus) {
            make.bottom.equalTo(self.imgViewBG).offset(90);
        }
        else {
            make.bottom.equalTo(self.imgViewBG).offset(10);
        }
        
    }];
    
    [self.txfdName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgViewBG).offset(-100);
        make.left.equalTo(self.imgViewBG).offset(80);
        make.height.equalTo(@48);
        make.right.equalTo(self.imgViewBG).offset(-50);
    }];
    
    [self.txfdPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.txfdName);
        make.right.equalTo(self.imgViewBG).offset(-70);
        if (IOS_DEVICE_4)
        {
            make.top.equalTo(self.emailUnderLine).offset(20);
        }else
        {
            make.top.equalTo(self.emailUnderLine).offset(40);
        }
        
        make.height.equalTo(self.txfdName);
    }];
    //信封
    
    [self.emailUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.txfdName);
        make.left.equalTo(self.imgViewBG).offset(50);
        make.right.equalTo(self.imgViewBG).offset(-50);
        make.height.equalTo(@1);
    }];
    [self.eveLopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.emailUnderLine);
        make.centerY.equalTo(self.txfdName);
    }];
    
    //锁下方的下划线
    [self.psdUnderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.txfdPwd);
        make.left.equalTo(self.imgViewBG).offset(50);
        make.right.equalTo(self.imgViewBG).offset(-50);
        make.height.equalTo(@1);
    }];
    
    //锁
    [self.psdIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.psdUnderLine);
        make.centerY.equalTo(self.txfdPwd);
    }];
    
    [self.eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.psdUnderLine);
        make.centerY.equalTo(self.txfdPwd);
    }];
    
    [self.btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.centerX.equalTo(self.imgViewBG);
        if (IOS_DEVICE_4)
        {
            make.centerY.equalTo(self.imgViewBG).offset(55);
        }else
        {
            make.centerY.equalTo(self.imgViewBG).offset(100);
        }
        
        make.height.equalTo(@48);
    }];
    
    [self.applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imgViewBG);
        make.top.equalTo(self.btnLogin.mas_bottom).offset(20);
    }];
    
    [self.forgetPswBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.psdUnderLine);
        make.top.equalTo(self.psdUnderLine.mas_bottom).offset(2);
    }];
    
    [self.appEditionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imgViewBG);
        make.bottom.equalTo(self.imgViewBG).offset(-15);
    }];
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:2 animations:^{
        //位置
        [self.cloudView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (!IOS_DEVICE_6Plus) {
                make.bottom.equalTo(self.imgViewBG).offset(60);
            }
            else {
                make.bottom.equalTo(self.imgViewBG).offset(5);
            }
        }];
        [self.imgViewHead mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgViewBG).offset(80);
        }];
        self.imgViewHead.alpha = 1;
        self.subTitleLbl.alpha = 1;
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            //位置
            [self.cloudView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (!IOS_DEVICE_6Plus) {
                    make.bottom.equalTo(self.imgViewBG).offset(80);
                }
                else {
                    make.bottom.equalTo(self.imgViewBG).offset(10);
                }
            }];
            [self.imgViewHead mas_updateConstraints:^(MASConstraintMaker *make) {
                if (IOS_DEVICE_4) {
                    make.top.equalTo(self.imgViewBG).offset(25);
                }
                else {
                    make.top.equalTo(self.imgViewBG).offset(65);
                }
            }];
            

            self.eveLopIcon.alpha = 1;
            self.txfdName.alpha = 1;
            self.txfdPwd.alpha = 1;
            self.psdIcon.alpha = 1;
            self.psdUnderLine.alpha = 1;
            self.emailUnderLine.alpha = 1;
            self.eyeBtn.alpha = 1;
            self.btnLogin.alpha = 1;
            self.forgetPswBtn.alpha = 1;
#ifndef CHINAMODE
            
            self.applyButton.alpha = 1;
#endif
            [self.view layoutIfNeeded];
        }];
    }];
}

#pragma mark - Button Click
- (void)clickToLogin
{
    //按钮暴力点击防御
    [self.btnLogin mtc_deterClickedRepeatedly];
    
    [self recoverKeyboard];
    
    if (![self checkInformation]) {
        return;
    }
    
    // 净化用户名
    NSString *strUser = [NSString removeBlankInString:_txfdName.text OnlyMarginal:NO];
    [self.txfdName setText:strUser];
    
    CompanyListRequest *request = [[CompanyListRequest alloc] initWithDelegate:self];
    [request getCompanyListWithLoginName:strUser password:self.txfdPwd.text];
    
    [self postLoading];
    [MixpanelMananger track:@"login"];
}

- (void)clickToForgetPsw {
    [self.forgetPswBtn mtc_deterClickedRepeatedly];
    [self openWeb:@"http://passport.mintcode.com/companyuser/forgetpassword?code=mt"];
//    [self openWeb:@"https://www.launchr.jp/companyuser/forgetpassword"];
}

- (void)showOrHidePsdActions {
    self.txfdPwd.secureTextEntry ^=1;
}

- (void)clickToApplyTrial {
#ifdef DEBUG
    JapanNaviRegisterViewController *VC = [[JapanNaviRegisterViewController alloc ] init];
    [self presentViewController:VC animated:YES completion:nil];
    return;
#endif
    // 试用申请
    //按钮暴力点击防御
    [self.applyButton mtc_deterClickedRepeatedly];
    
    [self openWeb:@"https://www.launchr.jp/companyuser/register"];
}

- (void)showValidHUD {
    [self postError:@"身份验证过期，请重新登陆" duration:1.5];
}

#pragma mark - private Method
- (void)openWeb:(NSString *)url {
    WebViewController *webVC = [[WebViewController alloc] initWithURL:url];

    BaseNavigationController *naviVC = [[BaseNavigationController alloc] initWithRootViewController:webVC];
    [self presentViewController:naviVC animated:YES completion:nil];
}


- (void)recoverKeyboard {
    [_txfdName resignFirstResponder];
    [_txfdPwd resignFirstResponder];
}


- (UIImageView *)createImageView:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [[UIImageView alloc] initWithImage:image];
}

- (void)viewAnimate
{
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

/** 检查信息 */
- (BOOL)checkInformation {
    NSString *error;
    if (![NSString checkValuableWithString:self.txfdName.text]) {
        error= LOCAL(LOGINCLASS_ERROR1);
    }
    else if (![self.txfdPwd text].length) {
        error = LOCAL(LOGINCLASS_ERROR2);
    }
    else {
        return YES;
    }
    
    [self postError:error];
    return NO;
}

/** 开始移动（textField开始编辑） */
- (void)beginMoveOffsetEditingBegin:(BOOL)isBegin
{
    if (!(IOS_DEVICE_5 || IOS_DEVICE_4))
    {
        return;
    }
    
    CGFloat offset = isBegin ? 0.0 : MOVE_OFFSET;
    if (self.moveOffset == offset)
    {
        self.moveOffset = isBegin ? MOVE_OFFSET : 0.0;
        self.centerYConstraint.offset = self.moveOffset;
        [self viewAnimate];
    }
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
        
        [userInfo saveAccount:self.txfdName.text];
        [userInfo savePassword:self.txfdPwd.text];
        
        if ([companyList count] == 1) {
            // 只有1个公司，直接走登录
            [self postLoading];
            
            [userInfo setCompanyCode:companyModel.code];
            [userInfo setCompanyShowID:companyModel.showId];
            [userInfo setCompanyName:companyModel.name];
            
            LALoginRequest *request = [[LALoginRequest alloc] initWithDelegate:self];
            [request loginName:[NSString removeBlankInString:_txfdName.text OnlyMarginal:NO] password:self.txfdPwd.text];
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
        
        // sqlLogin
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
    [self RecordToDiary:errorMessage];
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    
    if (textField == self.txfdPwd)
    {
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        self.btnLogin.enabled = toBeString.length;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.btnLogin.enabled = self.txfdPwd.text.length;
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField == self.txfdPwd) {
        self.btnLogin.enabled = NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
#pragma mark - Initializer

- (UIImageView *)cloudView
{
    if (!_cloudView)
    {
        UIImage *image = [UIImage imageNamed:@"login_cloud"];
        _cloudView = [[UIImageView alloc] initWithImage:image];
        if (!IOS_DEVICE_6Plus) {
            [_cloudView setContentMode:UIViewContentModeScaleAspectFit];
        }
    }
    return _cloudView;
}

- (UIImageView *)imgViewBG {
    if (!_imgViewBG) {
        
        UIImage *image = [UIImage mtc_imageColor:[UIColor themeBlue] size:self.view.frame.size];
        _imgViewBG = [[UIImageView alloc] initWithImage:image];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recoverKeyboard)];
        [_imgViewBG addGestureRecognizer:tapGesture];
        _imgViewBG.userInteractionEnabled = YES;
    }
    return _imgViewBG;
}

- (UIImageView *)imgViewHead {
    if (!_imgViewHead) {
        _imgViewHead = [self createImageView:@"login_logo_only"];
        _imgViewHead.alpha = 0;
        [_imgViewHead setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _imgViewHead;
}


- (UITextField *)txfdName {
    if (!_txfdName) {
        _txfdName = [[UITextField alloc] init];
        _txfdName.textColor = [UIColor whiteColor];
        _txfdName.font = [UIFont systemFontOfSize:15];
        _txfdName.placeholder = [NSString stringWithFormat:@"%@/Launchr ID", LOCAL(LOGINCLASS_NAME)];
        [_txfdName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _txfdName.tag = 0;
        _txfdName.returnKeyType = UIReturnKeyDone;
        _txfdName.delegate = self;
        _txfdName.clearButtonMode = YES;
        _txfdName.alpha = 0;
    }
    return _txfdName;
}

- (UITextField *)txfdPwd {
    if (!_txfdPwd) {
        _txfdPwd = [[UITextField alloc] init];
        _txfdPwd.textColor = [UIColor whiteColor];
        _txfdPwd.font = [UIFont systemFontOfSize:15];
        _txfdPwd.placeholder = LOCAL(LOGINCLASS_PASSWORD);
        [_txfdPwd setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _txfdPwd.tag = 1;
        _txfdPwd.returnKeyType = UIReturnKeyDone;
        
        _txfdPwd.clearButtonMode = YES;
        _txfdPwd.secureTextEntry = YES;
        _txfdPwd.delegate = self;
        _txfdPwd.alpha = 0;
    }
    return _txfdPwd;
}

- (UIButton *)btnLogin {
    if (!_btnLogin) {
        _btnLogin = [[UIButton alloc] init];
        _btnLogin.layer.cornerRadius = 5.0;
        _btnLogin.clipsToBounds = YES;
        [_btnLogin setTitle:LOCAL(LOGINCLASS_TITLE) forState:UIControlStateNormal];
        [_btnLogin setBackgroundImage:[UIImage mtc_imageColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_btnLogin addTarget:self action:@selector(clickToLogin) forControlEvents:UIControlEventTouchUpInside];
        _btnLogin.enabled = NO;
        _btnLogin.layer.borderColor = [UIColor whiteColor].CGColor;
        _btnLogin.layer.borderWidth = 1.0;
        _btnLogin.layer.cornerRadius = 3;
        _btnLogin.layer.masksToBounds = YES;
        _btnLogin.alpha = 0;
    }
    return _btnLogin;
}

- (UIButton *)forgetPswBtn
{
    if (!_forgetPswBtn)
    {
        _forgetPswBtn = [[UIButton alloc] init];
        _forgetPswBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _forgetPswBtn.alpha = 0;
        [_forgetPswBtn setTitle:LOCAL(LOGINCLASS_FORGETPSD)  forState:UIControlStateNormal];
        [_forgetPswBtn setTintColor:[UIColor whiteColor]];
        [_forgetPswBtn addTarget:self action:@selector(clickToForgetPsw) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPswBtn;
}

//✉️
- (UIImageView *)eveLopIcon
{
    if (!_eveLopIcon)
    {
        _eveLopIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_envelope"]];
        _eveLopIcon.alpha = 0;
    }
    return _eveLopIcon;
}

//下划线
- (UIView *)emailUnderLine
{
    if (!_emailUnderLine)
    {
        _emailUnderLine = [[UIView alloc] init];
        _emailUnderLine.backgroundColor = [UIColor whiteColor];
        _emailUnderLine.alpha = 0;
    }
    return _emailUnderLine;
}

//🔒
- (UIImageView *)psdIcon
{
    if (!_psdIcon)
    {
        _psdIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_lock"]];
        _psdIcon.alpha = 0;
    }
    return _psdIcon;
}

//下划线

- (UIView *)psdUnderLine
{
    if (!_psdUnderLine)
    {
        _psdUnderLine = [[UIView alloc] init];
        _psdUnderLine.backgroundColor = [UIColor whiteColor];
        _psdUnderLine.alpha = 0;
    }
    return _psdUnderLine;
}

- (UIButton *)eyeBtn
{
    if (!_eyeBtn)
    {
        _eyeBtn = [[UIButton alloc] init];
        [_eyeBtn setImage:[UIImage imageNamed:@"login_eye_normal"] forState:UIControlStateNormal];
        [_eyeBtn setImage:[UIImage imageNamed:@"login_eye_highlight"] forState:UIControlStateHighlighted];
        [_eyeBtn addTarget:self action:@selector(showOrHidePsdActions) forControlEvents:UIControlEventTouchUpInside];
        _eyeBtn.alpha = 0;
    }
    return _eyeBtn;
}

- (UILabel *)appEditionLbl
{
    if (!_appEditionLbl)
    {
        _appEditionLbl = [[UILabel alloc] init];
        _appEditionLbl.text = [NSString stringWithFormat:@"Copyright © %ld mintcode, Inc. All Rights Reserved", [[NSDate date] year]];
        _appEditionLbl.textColor = [UIColor mtc_colorWithHex:0xc2c2c2];
        _appEditionLbl.font = [UIFont systemFontOfSize:9.0f];
    }
    return _appEditionLbl;
}

- (UILabel *)subTitleLbl
{
    if (!_subTitleLbl)
    {
        _subTitleLbl = [[UILabel alloc] init];
        _subTitleLbl.text = LOCAL(LOGINCLASS_DESCRIPTION);
        _subTitleLbl.textColor = [UIColor whiteColor];
        _subTitleLbl.font = [UIFont systemFontOfSize:10];
        _subTitleLbl.alpha = 0;
    }
    return _subTitleLbl;
}

- (UIButton *)applyButton {
    if (!_applyButton) {
        _applyButton = [UIButton new];
        NSAttributedString *attriStr = [[NSAttributedString alloc] initWithString:LOCAL(LOGINCLASS_APPLYTRIAL)
                                                                       attributes:@{
                                                                                    NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                                                                                    NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                    NSFontAttributeName:[UIFont systemFontOfSize:15]
                                                                                    }];
        [_applyButton setAttributedTitle:attriStr forState:UIControlStateNormal];
        [_applyButton addTarget:self action:@selector(clickToApplyTrial) forControlEvents:UIControlEventTouchUpInside];
        _applyButton.alpha = 0;
    }
    return _applyButton;
}

@end
