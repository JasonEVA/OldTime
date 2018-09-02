//
//  GraphicSetViewController.m
//  launcher
//
//  Created by William Zhang on 15/7/29.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "GraphicSetViewController.h"
#import "UnifiedUserInfoManager.h"
#import "UnifiedLoginManager.h"
#import "GraphicLockSmallView.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "GraphicLockView.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"
#import <Masonry.h>
#import "AppDelegate.h"
#import "SettingModel.h"
#import "UIImage+Manager.h"

@interface GraphicSetViewController () <GraphicLockViewDelegate>

@property (nonatomic, strong) GraphicLockView      *lockView;
@property (nonatomic, strong) GraphicLockSmallView *smallView;

/** 提示 */
@property (nonatomic, strong) UILabel *lbPrompt;

/** 第一次密码 */
@property (nonatomic, strong) NSArray *arrFirstPwd;

@property (nonatomic, assign) BOOL isSecond;

@end

@implementation GraphicSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LOCAL(GESTURELOGIN_TITLE);
    
    self.view.backgroundColor = [UIColor themeBlue];
    
    self.navigationController.navigationBar.barTintColor = [UIColor mtc_colorWithHex:0x4db8ff];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage mtc_imageColor:[UIColor mtc_colorWithHex:0x4db8ff]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                    NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"userInfo_backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(clickToBack)];
    
    [self initComponents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage mtc_imageColor:[UIColor whiteColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}
- (void)initComponents
{
    [self.view addSubview:self.smallView];
    [self.view addSubview:self.lbPrompt];
    
    // 放置九宫格容器，更好的调整九宫格位置
    UIView *contentView = [[UIView alloc] init];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbPrompt.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [contentView addSubview:self.lockView];
    
    [self initConstraints];
}

- (void)initConstraints
{
    [self.smallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(40);
        make.width.height.equalTo(@34);
    }];
    
    [self.lbPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.smallView.mas_bottom).offset(35);
    }];
    
    [self.lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.lockView.mas_height);
        make.centerX.equalTo(self.lockView.superview);
        make.centerY.equalTo(self.lockView.superview).offset(20);
        make.width.lessThanOrEqualTo(@250);
        
        make.bottom.lessThanOrEqualTo(self.view).offset(-20);
        make.width.height.equalTo(self.lockView.superview).with.priorityLow();
    }];
}

#pragma mark - Button Click
- (void)clickToBack {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Private Method
- (BOOL)checkPassword:(NSArray *)password
{
    if (password.count < 4)
    {
        [self promptColor:[UIColor themeRed] text:LOCAL(GESTURELOGIN_PROMPT1)];
        return YES;
    }
    else
    {
        self.isSecond = YES;
        [self promptColor:[UIColor whiteColor] text:LOCAL(GESTURELOGIN_PROMPT2)];
        self.arrFirstPwd = [NSArray arrayWithArray:password];
        return NO;
    }
}

/** 提示信息 */
- (void)promptColor:(UIColor *)color text:(NSString *)text
{
    self.lbPrompt.textColor = color;
    self.lbPrompt.text = text;
}

- (void)setbackinfo
{
    self.lbPrompt.textColor = [UIColor whiteColor];
    self.lbPrompt.text = LOCAL(GESTURELOGIN_PROMPT5);
}

#pragma mark - GraphicLockView Delegate
- (void)GraphicLockViewDelegateCallBack_touchUpWithPassword:(NSArray *)password
{
//    if (self.isSecond)
//    {
//        [self.smallView setPassword:password withIsSecond:self.isSecond];
//    }
//    else
//    {
        [self.smallView setPassword:password];
//    }
    
}

- (BOOL)GraphicLockViewDelegateCallBack_finishWithPassword:(NSArray *)password
{
    if (!self.arrFirstPwd)
    {
        self.lockView.isSecond = NO;
        return [self checkPassword:password];
    }
    
    if (![self.arrFirstPwd isEqualToArray:password])
    {
        self.arrFirstPwd = nil;
        [self.smallView setPassword:password withIsSecond:YES];
        [UIView animateWithDuration:1 animations:^{
            
        } completion:^(BOOL finished)
        {
//            [self.lockView clearColorAndSelectedButton];
        }];
        [self performSelector:@selector(setbackinfo) withObject:nil afterDelay:1.2];
        self.lockView.isSecond = YES;
        [self promptColor:[UIColor themeRed] text:LOCAL(GESTURELOGIN_PROMPT4)];
        return YES;
    }
    
    // 正确！！完美！
    // 将数组转为字符串并保存手势密码
    
    NSString *strPassword = [password componentsJoinedByString:@""];
    [self promptColor:[UIColor whiteColor] text:LOCAL(GESTURELOGIN_PROMPT3)];
    
    // 存储密码
    NSString *loginName = [[UnifiedUserInfoManager share] getAccountWithEncrypt:YES];
    SettingModel *settingModel = [[UnifiedLoginManager share] findDataModelWithLoginName:loginName];
    if (!settingModel)
    {
        settingModel = [SettingModel MR_createEntity];
        settingModel.loginName = loginName;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    settingModel.graphicPassword = strPassword;
    
    if (self.isChangeKey)
    {
        settingModel.isLogin = @YES;
        [[UnifiedLoginManager share] insertData:settingModel];
        [self.navigationController popViewControllerAnimated:NO];
        return NO;
    }
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [self RecordToDiary:@"修改手势密码成功"];
    if ([app.controllerManager.companyList count] == 1) {
        settingModel.isLogin = @YES;
        [[UnifiedLoginManager share] insertData:settingModel];
        [app.controllerManager performSelector:@selector(showHome) withObject:nil afterDelay:0.2];
    } else {
        [app.controllerManager performSelector:@selector(showCompany) withObject:nil afterDelay:0.2];
    }
    return NO;
}

#pragma mark - Initializer
- (GraphicLockView *)lockView {
    if (!_lockView) {
        _lockView = [[GraphicLockView alloc] init];
        _lockView.delegate = self;
    }
    return _lockView;
}

- (GraphicLockSmallView *)smallView {
    if (!_smallView) {
        _smallView = [[GraphicLockSmallView alloc] init];
    }
    return _smallView;
}

- (UILabel *)lbPrompt {
    if (!_lbPrompt) {
        _lbPrompt = [[UILabel alloc] init];
        _lbPrompt.textColor = [UIColor whiteColor];
        _lbPrompt.font = [UIFont systemFontOfSize:15];
        _lbPrompt.text = LOCAL(GESTURELOGIN_PROMPT);
    }
    return _lbPrompt;
}
@end