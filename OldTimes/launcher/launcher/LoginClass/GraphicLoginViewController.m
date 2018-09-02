//
//  GraphicLoginViewController.m
//  launcher
//
//  Created by William Zhang on 15/7/28.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "GraphicLoginViewController.h"
#import "UnifiedUserInfoManager.h"
#import "UnifiedLoginManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <Masonry/Masonry.h>
#import "GraphicLockView.h"
#import "Category.h"
#import "AppDelegate.h"
#import "SettingModel.h"
#import "AvatarUtil.h"
#import "MyDefine.h"

#define HEAD_D 65   // 头像直径

@interface GraphicLoginViewController () <GraphicLockViewDelegate>

@property (nonatomic, strong) UIImageView *imgViewHead;

@property (nonatomic, strong) UIButton *btnForgetPwd;
@property (nonatomic, strong) UIButton *btnOtherWay;

@property (nonatomic, strong) UILabel *lbName;
/** 提示标签 */
@property (nonatomic, strong) UILabel *lbPrompt;

@property (nonatomic, strong) GraphicLockView *lockView;

/** 最多尝试次数（5） */
@property (nonatomic, assign) NSInteger inputTime;

@property (nonatomic, copy) void (^dismissBlock)();

@end

@implementation GraphicLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor themeBlue];
    
    // 头像背景
    UIView *viewHeadBG = [UIView new];
    viewHeadBG.backgroundColor = [UIColor whiteColor];
    viewHeadBG.layer.cornerRadius = (HEAD_D + 5) / 2;
    [self.view addSubview:viewHeadBG];
    [viewHeadBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@(HEAD_D + 5));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(80);
    }];
    
    [viewHeadBG addSubview:self.imgViewHead];
    [self.imgViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@HEAD_D);
        make.center.equalTo(viewHeadBG);
    }];
    
    [self initComponents];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTouchIdPasswordView) name:MTWilShowFingerPrintNotification object:nil];
//    [self showTouchIdPasswordView];
}

- (void)initComponents
{
    self.inputTime = 5;
    
    [self.view addSubview:self.lbName];
    [self.view addSubview:self.lbPrompt];
    
    [self.view addSubview:self.btnForgetPwd];
    [self.view addSubview:self.btnOtherWay];
    
    // 手势解锁content，更好确定手势位置
    UIView *contentView = [[UIView alloc] init];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbPrompt.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.btnForgetPwd.mas_top);
    }];
    [contentView addSubview:self.lockView];
    
    [self initConstraints];
    [self setNameAndHead];
}

- (void)initConstraints
{
    [self.lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.imgViewHead.mas_bottom).offset(15);
    }];
    [self.lbPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.lbName.mas_bottom).offset(5);
    }];
    
    [self.lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.lockView.mas_height);
        make.centerX.equalTo(self.lockView.superview);
        make.centerY.equalTo(self.lockView.superview).offset(20);
        make.width.lessThanOrEqualTo(@250);

        // 横竖自动适配大小
        make.bottom.lessThanOrEqualTo(self.btnForgetPwd.mas_top);
        make.width.height.equalTo(self.lockView.superview).priorityLow();
    }];

    [self.btnForgetPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10);
        make.left.equalTo(self.view).offset(10);
    }];
    [self.btnOtherWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.btnForgetPwd);
        make.right.equalTo(self.view).offset(-10);
    }];
}

- (void)setDismissBlock:(void (^)())dismissBlock
{
    self.dismissBlock = dismissBlock;
}


- (void)setNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTouchIdPasswordView) name:MTWilShowFingerPrintNotification object:nil];
}

#pragma mark - Private Method
- (void)setNameAndHead
{
    UnifiedUserInfoManager *userInfoManager = [UnifiedUserInfoManager share];
    self.lbName.text = [userInfoManager userName];

	avatarRemoveCache([UnifiedUserInfoManager share].userShowID);
    [self.imgViewHead sd_setImageWithURL:avatarURL(avatarType_150, [userInfoManager userShowID]) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"]];
}

// 手势验证页面发送的指纹验证委托

- (BOOL)showTouchIdPasswordView
{
    // 判断是否支持指纹验证
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    BOOL supportTouchId = [myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError];
    
    // 如果支持指纹验证
    if (supportTouchId)
    {
        NSString *myLocalizedReasonString = LOCAL(FINGERPRINT_IDENTIFICATION);
        //        [myContext setLocalizedFallbackTitle:@"手势认证"];
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError *error) {
            
            // 尼玛太坑了呀，这个block回调居然罕见地不在主线程里，害我搞半天，shit!!!
            dispatch_async(dispatch_get_main_queue(), ^{
                // 验证结果
                if (success)
                {
                    [self showHome];
                }
                else
                {
                    /*
                     NSString *strError = @"";
                     switch (error.code)
                     {
                     case LAErrorUserCancel:
                     strError = @"用户取消了验证";
                     break;
                     
                     case LAErrorAuthenticationFailed:
                     strError = @"指纹验证失败";
                     break;
                     
                     case LAErrorPasscodeNotSet:
                     strError = @"用户还未设置指纹";
                     break;
                     
                     case LAErrorSystemCancel:
                     strError = @"系统取消了验证";
                     break;
                     
                     case LAErrorUserFallback:
                     strError = @"用户选择了输入密码";
                     break;
                     
                     default:
                     strError = @"You cannot access to private content!";
                     break;
                     }
                     PRINT_STRING(strError);
                     */
                }
            });
        }];
    }
    return supportTouchId;
}

- (void)showHome {
    AppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
    if (self.isForVerify) {
        [aDelegate.controllerManager dissGestureVerify];
    } else {
        [aDelegate.controllerManager showHome];
    }
    
    //  PS:3DTouch点击进入解锁之后通知处理 其他地方没用到
    if (self.dismissBlock)
    {
        self.dismissBlock();
        self.dismissBlock = nil;
    }
}
/** ❌提示 */
- (void)promptErrorMessage:(NSString *)errorMsg
{
    self.lbPrompt.textColor = [UIColor themeRed];
    self.lbPrompt.text = errorMsg;
}

/** 摇晃提示 */
- (void)shakePrompt
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat currentTx = self.lbPrompt.transform.tx;
    
    animation.duration = 0.5;
    animation.values = @[ @(currentTx), @(currentTx + 10), @(currentTx-8), @(currentTx + 8), @(currentTx -5), @(currentTx + 5), @(currentTx) ];
    animation.keyTimes = @[ @(0), @(0.225), @(0.425), @(0.6), @(0.75), @(0.875), @(1) ];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.lbPrompt.layer addAnimation:animation forKey:@"prompt"];
}

- (void)clearGesture
{
    NSString *loginName = [[UnifiedUserInfoManager share] getAccountWithEncrypt:YES];
    SettingModel *settingModel = [[UnifiedLoginManager share] findDataModelWithLoginName:loginName];
    if (settingModel)
    {
        settingModel.isLogin = @NO;
        settingModel.graphicPassword = @"";
        [[UnifiedLoginManager share] insertData:settingModel];
    }
}

#pragma mark - Button Click
- (void)clickToForgetPwd
{
    [self clearGesture];
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [appdelegate.controllerManager showPasswordLogin];
}

- (void)clickToOtherWay
{
    if ([self showTouchIdPasswordView]) {
        return;
    }
    
    [self clickToForgetPwd];
}

#pragma mark - GraphicLockView Delegate
- (BOOL)GraphicLockViewDelegateCallBack_finishWithPassword:(NSArray *)password
{
    NSString *strPassword = [password componentsJoinedByString:@""];

    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    NSString *loginName = [[UnifiedUserInfoManager share] getAccountWithEncrypt:YES];
    SettingModel *settingModel = [[UnifiedLoginManager share] findDataModelWithLoginName:loginName];
    if (settingModel && [settingModel.graphicPassword isEqualToString:strPassword])
    {
        [self showHome];
        return NO;
    }
    
    if (self.inputTime > 1)
    {
        self.inputTime --;
        [self promptErrorMessage:[NSString stringWithFormat:LOCAL(GESTURELOGIN_WRONG),(long)self.inputTime]];
        [self shakePrompt];
        return YES;
    }
    else
    {
        [self promptErrorMessage:LOCAL(GESTURELOGIN_WRONG2)];
        [self clearGesture];
        
        [app.controllerManager performSelector:@selector(showPasswordLogin) withObject:nil afterDelay:0.5];
    }
    
    return YES;
}

#pragma mark - Device Motion Events Notify
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [self showTouchIdPasswordView];
    }
}

#pragma mark - Create
- (UIButton *)createButtonName:(NSString *)name selector:(SEL)selector
{
    UIButton *button = UIButton.new;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:name forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - Initializer
- (UIImageView *)imgViewHead {
    if (!_imgViewHead) {
        UIImage *image = [UIImage imageNamed:@"contact_default_headPic"];
        _imgViewHead = [[UIImageView alloc] initWithImage:image];
        _imgViewHead.layer.cornerRadius = HEAD_D * 0.5;
        _imgViewHead.layer.masksToBounds = YES;
    }
    return _imgViewHead;
}

- (UIButton *)btnForgetPwd {
    if (!_btnForgetPwd) {
        _btnForgetPwd = [self createButtonName:LOCAL(GESTURELOGIN_FORGET) selector:@selector(clickToForgetPwd)];
    }
    return _btnForgetPwd;
}

- (UIButton *)btnOtherWay {
    if (!_btnOtherWay) {
        _btnOtherWay = [self createButtonName:LOCAL(GESTURELOGIN_OTHERWAY) selector:@selector(clickToOtherWay)];
    }
    return _btnOtherWay;
}

- (UILabel *)lbName {
    if (!_lbName) {
        _lbName = UILabel.new;
        _lbName.font = [UIFont systemFontOfSize:17];
        _lbName.textColor = [UIColor whiteColor];
    }
    return _lbName;
}

- (UILabel *)lbPrompt {
    if (!_lbPrompt) {
        _lbPrompt = UILabel.new;
        _lbPrompt.font = [UIFont systemFontOfSize:12];
        _lbPrompt.textColor = [UIColor mtc_colorWithR:238 g:75 b:79];
    }
    return _lbPrompt;
}

- (GraphicLockView *)lockView {
    if (!_lockView) {
        _lockView = [[GraphicLockView alloc] init];
        _lockView.delegate = self;
    }
    return _lockView;
}

@end
