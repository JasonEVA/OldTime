//
//  LoginViewController.m
//  Shape
//
//  Created by jasonwang on 15/10/14.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "LoginViewController.h"
#import "Masonry.h"
#import "BaseNavigationViewController.h"
#import "TrainTargetViewController.h"
#import "UIColor+Hex.h"
#import "RegisterRequestDAL.h"
#import "GetCodeRequestDAL.h"
#import "LoginRequestDAL.h"
#import "MyDefine.h"
#import "unifiedUserInfoManager.h"
#import "UIButton+EX.h"
#import "UITextField+EX.h"
#import "LoginInputView.h"
#import "MeGetUserInfoRequest.h"
#import <MagicalRecord/MagicalRecord.h>
#import "DBUnifiedManager.h"
#import "MeGetCityListRequest.h"
#import "MeCityListModel.h"
#import "TrainGetTrainToolRequest.h"
#import "TrainGetPartRequest.h"


#define FONT1 12
#define FONT2 14
#define ICON_W 14

static NSString *const backImage = @"login_backView";
static NSString *const phoneIcon = @"login_phone";
static NSString *const lockIcon = @"login_lock";
static NSString *const cancelIcon = @"login_cancel";
static NSString *const logoIcon = @"login_logo";
static NSString *const nikeIcon = @"login_nikename";

typedef NS_ENUM(NSInteger, buttonTag) {
    loginTag = 1000,
    registerTag
    
};

@interface LoginViewController ()<UITextFieldDelegate,BaseRequestDelegate,UIScrollViewDelegate,LoginInputViewDelegate>
//背景
@property (nonatomic, strong) UIImageView *bkView;    //背景图
@property (nonatomic, strong) UIImageView *iconView;  //LOGO
@property (nonatomic, strong) UIButton *closeBtn;     //关闭按钮
@property (nonatomic, strong) UIView *selectedLine1;  //被选中显示的线条
@property (nonatomic, strong) UIView *selectedLine2;  //同上
@property (nonatomic, strong) UIButton *loginSelectBtn;     //登录选项卡
@property (nonatomic, strong) UIButton *registerSelectBtn; //注册选项卡
//登录

@property (nonatomic, strong) LoginInputView *phoneView;    //手机号
@property (nonatomic, strong) LoginInputView *passwordView;    //密码
@property (nonatomic, strong) UIButton *loginBtn;     //登录按钮
@property (nonatomic, strong) UIScrollView *downView;
//注册

@property (nonatomic, strong) UIButton *getTextBtn;     //获取验证码
@property (nonatomic, strong) LoginInputView *verificationView;   //验证码

@property (nonatomic, strong) LoginInputView *nikeNameView;   //昵称

@property (nonatomic, strong) LoginInputView *selectView;   //当前选中编辑的View

@property (nonatomic) BOOL isLogin;                   //是否为登陆页面

@property (nonatomic, copy) NSString *codeToken;      //验证码Token
//倒计时
@property (nonatomic) NSInteger secondsCoundDown;
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, copy)   NSMutableString *time;

@property (nonatomic, strong) UITapGestureRecognizer *tapTouch;
@property (nonatomic, strong) UITapGestureRecognizer *closeTouch;

@property (nonatomic, copy) NSMutableArray *provinceArr;
@property (nonatomic, copy) NSMutableArray *cityArr;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLogin = YES;
    [self.nikeNameView setHidden:YES];
    [self.verificationView setHidden:YES];

    [self initComponent];
    [self.view needsUpdateConstraints];
    [self startRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self killTimer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self resignFirstRsp];
}

#pragma mark - private method

- (void)resignFirstRsp
{
    //隐藏键盘
    [self.passwordView.textField resignFirstResponder];
    [self.phoneView.textField resignFirstResponder];
    [self.verificationView.textField resignFirstResponder];
    [self.nikeNameView.textField resignFirstResponder];
    //将之前选中框置为非高亮
    [self.selectView setStatus:NO];

    
}
//检查数据完整性
- (BOOL)isDataCompletion
{
    bool isOK = NO;
    if (self.isLogin) {
        if (self.phoneView.textField.text.length > 0 && self.passwordView.textField.text.length > 0) {
            isOK = YES;
        }
    }
    else
    {
        if (self.phoneView.textField.text.length > 0 && self.passwordView.textField.text.length > 0 && self.verificationView.textField.text.length > 0 && self.nikeNameView.textField.text.length > 0) {
            isOK = YES;
        }

    }
    
    return isOK;
}

//倒计时方法，
- (void)timeFireMethod
{
    self.secondsCoundDown --;
    //更新按钮倒计时时间
    self.time = [NSMutableString stringWithFormat:@"(%lds)后重发",(long)self.secondsCoundDown];
    [self.getTextBtn setTitle:self.time forState:UIControlStateDisabled];
    
    if (self.secondsCoundDown == 0) {
        [self killTimer];
    }
    
    //NSLog(@"%ld",(long)self.secondsCoundDown);
    
    
}

- (void)killTimer
{
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
    //设置按钮可点击
    [self.getTextBtn setEnabled:YES];
    
    [self.getTextBtn setTitle:@"获取验证码" forState:UIControlStateDisabled];
}

- (void)startRequest
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        NSLog(@"第一次启动");
        //获取训练器械列表
        TrainGetTrainToolRequest *toolRequest = [[TrainGetTrainToolRequest alloc]init];
        [toolRequest requestWithDelegate:self];
        //获取训练部位列表
        TrainGetPartRequest *partRequest = [[TrainGetPartRequest alloc]init];
        [partRequest requestWithDelegate:self];
        
    }else{
        NSLog(@"不是第一次启动");
    }

}
#pragma mark - event Respons
//关闭选项
- (void)closeClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//登录注册选项相应
- (void)selectClick:(UIButton *)button
{
    [self resignFirstRsp];
    //清空输入框
    [self.phoneView.textField setText:@""];
    [self.passwordView.textField setText:@""];
    [self.verificationView.textField setText:@""];
    [self.nikeNameView.textField setText:@""];
    //点击登录按钮时
    if (button.tag == loginTag) {
        self.isLogin = YES;

        //取消选中框
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [self.loginSelectBtn setSelected:YES];
        [self.loginSelectBtn setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
        [self.registerSelectBtn setSelected:NO];
        [self.registerSelectBtn setBackgroundColor:[UIColor themeBackground_373737]];
        //隐藏不需要控件
        [self.selectedLine1 setHidden:NO];
        [self.selectedLine2 setHidden:YES];
        [self.nikeNameView setHidden:YES];
        [self.verificationView setHidden:YES];
        
        [self killTimer];
    }
    //点击注册
    else if (button.tag == registerTag)
    {
        self.isLogin = NO;
        //重设图标

        //重设提示语
        [self.loginBtn setTitle:@"完成" forState:UIControlStateNormal];
        [self.loginSelectBtn setSelected:NO];
        [self.loginSelectBtn setBackgroundColor:[UIColor themeBackground_373737]];
        [self.registerSelectBtn setSelected:YES];
        [self.registerSelectBtn setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
        //隐藏不需要控件
        [self.selectedLine1 setHidden:YES];
        [self.selectedLine2 setHidden:NO];
        [self.verificationView setHidden:NO];
        [self.nikeNameView setHidden:NO];
    }
    [self.view setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
}
//登录完成按钮监听
- (void)loginClick
{
    [self postLoading];
    if([self isDataCompletion])
    {
        if (self.isLogin) {
            //登录按钮监听
            NSLog(@"点击登录了");
            LoginRequestDAL *request = [[LoginRequestDAL alloc]init];
            [request prepareRequest];
            request.phone = self.phoneView.textField.text;
            request.password = self.passwordView.textField.text;
            [request requestWithDelegate:self];
        }
        else
        {
            //注册完成按钮监听
            NSLog(@"点击完成了");
            //发出网络请求
            RegisterRequestDAL *request = [[RegisterRequestDAL alloc]init];
            [request prepareRequest];
            request.name = self.nikeNameView.textField.text;
            request.phone = self.phoneView.textField.text;
            request.password = self.passwordView.textField.text;
            request.code = self.verificationView.textField.text;
            request.codeToken = self.codeToken;
            [request requestWithDelegate:self];
        }
    }
    else
    {
        [self postError:@"信息不完整" duration:1];
        
    }
}
//获取验证码监听
- (void)getTestClick
{
    if (self.phoneView.textField.text.length > 0) {
        
        //设置按钮不可点击
        [self.getTextBtn setEnabled:NO];
        //设置计时器
        self.secondsCoundDown = 60;
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        //发出网络请求
        GetCodeRequestDAL *request = [[GetCodeRequestDAL alloc] init];
        [request prepareRequest];
        request.phone = self.phoneView.textField.text;
        [request requestWithDelegate:self];
    }
    else
    {
        [self postError:@"请输入手机号" duration:1];
    }
    
    
}
#pragma mark - LoginInputViewDelegate

//开始编辑时，移动页面
- (void)LoginInputViewDelegateCallBack_statrEditing:(LoginInputView *)view
{
    CGRect frame = view.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0) + self.view.frame.size.height * 0.363 + 30;//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    //将之前的选中框置为非高亮
    [self.selectView setStatus:NO];
    self.selectView = view;
    //将当前的选中框置为非高亮
    [self.selectView setStatus:YES];

}
//编辑结束，页面恢复
- (void)LoginInputViewDelegateCallBack_endEditing:(LoginInputView *)view
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame=self.view.frame;
        frame.origin.y=0;
        self.view.frame=frame;
        
    }];
    
}


#pragma mark - initComponent
- (void)initComponent
{
    [self.view addSubview:self.bkView];
    [self.bkView addSubview:self.iconView];
    [self.bkView addSubview:self.closeBtn];
    [self.bkView addSubview:self.downView];
    [self.downView addSubview:self.loginSelectBtn];
    [self.downView addSubview:self.registerSelectBtn];
    [self.loginSelectBtn addSubview:self.selectedLine1];
    [self.registerSelectBtn addSubview:self.selectedLine2];
    [self.downView addSubview:self.phoneView];
    [self.downView addSubview:self.passwordView];
    [self.downView addSubview:self.loginBtn];
    [self.verificationView addSubview:self.getTextBtn];
    [self.downView addSubview:self.verificationView];
    [self.downView addSubview:self.nikeNameView];

}


#pragma mark - updateViewConstraints

- (void)updateViewConstraints
{
    [self.bkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(self.view.frame.size.height * 0.363);
//        make.height.equalTo(self.view).multipliedBy(0.637);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(32);
        make.height.width.mas_equalTo(16);
        make.right.equalTo(self.view).offset(-22);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(80);
    }];
    
    [self.loginSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.downView);
        make.height.mas_equalTo(49);
        make.width.equalTo(self.registerSelectBtn);
    }];
    
    [self.registerSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.downView);
        make.height.width.equalTo(self.loginSelectBtn);
        make.left.equalTo(self.loginSelectBtn.mas_right);
        make.width.equalTo(self.downView).multipliedBy(0.5);
    }];
    
    [self.selectedLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.loginSelectBtn);
        make.height.mas_equalTo(4);
    }];
    
    [self.selectedLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.registerSelectBtn);
        make.height.mas_equalTo(4);
    }];
    

    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height_44);
        make.left.equalTo(self.view).offset(49);
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(self.loginSelectBtn.mas_bottom).offset(30);
    }];


    if (self.isLogin) {//登录布局
        
        [self.passwordView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height_44);
            make.left.equalTo(self.view).offset(49);
            make.right.equalTo(self.view).offset(-30);
            make.top.equalTo(self.phoneView.mas_bottom).offset(10);
        }];
        }
    else
    {//注册布局
        
        [self.nikeNameView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height_44);
            make.left.equalTo(self.view).offset(49);
            make.right.equalTo(self.view).offset(-30);
            make.top.equalTo(self.phoneView.mas_bottom).offset(10);
        }];

        
        [self.verificationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height_44);
            make.left.equalTo(self.view).offset(49);
            make.right.equalTo(self.view).offset(-30);
            make.top.equalTo(self.nikeNameView.mas_bottom).offset(10);
        }];
        [self.passwordView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height_44);
            make.left.equalTo(self.view).offset(49);
            make.right.equalTo(self.view).offset(-30);
            make.top.equalTo(self.verificationView.mas_bottom).offset(10);
        }];

        [self.getTextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.verificationView).offset(-7);
            make.top.equalTo(self.verificationView).offset(7);
            make.width.mas_equalTo(90);
        }];

    }
    [self.loginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(49);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(height_44);
        make.top.equalTo(self.passwordView.mas_bottom).offset(20);
    }];
    
    [self.downView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.loginBtn).offset(50);
    }];

    [super updateViewConstraints];
}



#pragma mark - init UI

- (UIScrollView *)downView
{
    if (!_downView) {
        _downView = [[UIScrollView alloc]init];
        [_downView setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
        [_downView addGestureRecognizer:self.tapTouch];
        [_downView setScrollEnabled:YES];
        [_downView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 100)];
        [_downView setShowsVerticalScrollIndicator:NO];
        [_downView setShowsHorizontalScrollIndicator:NO];
        [_downView setDelegate:self];
        [_downView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _downView;
}
- (UIImageView *)bkView
{
    if (!_bkView) {
        _bkView = [[UIImageView alloc] init];
        [_bkView setImage:[UIColor switchToImageWithColor:[UIColor colorLightBlack_2e2e2e] size:CGSizeMake(1, 1)]];
        [_bkView setUserInteractionEnabled:YES];
        [_bkView addGestureRecognizer:self.closeTouch];
    }
    return _bkView;
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        [_iconView setImage:[UIImage imageNamed:@"login_icon"]];
    }
    return _iconView;
}


- (UIView *)selectedLine1
{
    if (!_selectedLine1) {
        _selectedLine1 = [[UIView alloc]init];
        [_selectedLine1 setBackgroundColor:[UIColor themeOrange_ff5d2b]];
    }
    return _selectedLine1;
}

- (UIView *)selectedLine2
{
    if (!_selectedLine2) {
        _selectedLine2 = [[UIView alloc]init];
        [_selectedLine2 setBackgroundColor:[UIColor themeOrange_ff5d2b]];
        [_selectedLine2 setHidden:YES];
    }
    return _selectedLine2;
}

- (LoginInputView *)phoneView
{
    if (!_phoneView) {
        _phoneView = [[LoginInputView alloc]initWithImageName:@"login_phone_disable" hightLightImgName:@"login_phone" placeHoderText:@"手机号"];
        [_phoneView setDelegate:self];
        [_phoneView.textField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    return _phoneView;
}

- (LoginInputView *)passwordView
{
    if (!_passwordView) {
        _passwordView = [[LoginInputView alloc]initWithImageName:@"login_lock_disable" hightLightImgName:@"login_lock" placeHoderText:@"密码"];
        [_passwordView setDelegate:self];
        [_passwordView.textField setSecureTextEntry:YES];
    }
    return _passwordView;
}


- (UIButton *)loginSelectBtn
{
    if (!_loginSelectBtn) {
        _loginSelectBtn = [UIButton setBntData:_loginSelectBtn backColor:[UIColor colorLightBlack_2e2e2e] backImage:nil title:@"登录" titleColorNormal:[UIColor whiteColor] titleColorSelect:[UIColor themeOrange_ff5d2b] font:nil tag:loginTag  isSelect:YES];
        [_loginSelectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginSelectBtn;
}

- (UIButton *)registerSelectBtn
{
    if (!_registerSelectBtn) {
        _registerSelectBtn = [UIButton setBntData:_registerSelectBtn backColor:[UIColor themeBackground_373737] backImage:nil title:@"注册" titleColorNormal:[UIColor whiteColor] titleColorSelect:[UIColor themeOrange_ff5d2b] font:nil tag:registerTag isSelect:NO];
        [_registerSelectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerSelectBtn;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:cancelIcon] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [UIButton setBntData:_loginBtn backColor:nil backImage:[UIColor switchToImageWithColor:[UIColor themeOrange_ff5d2b] size:CGSizeMake(1, 1)] title:@"登录" titleColorNormal:[UIColor whiteColor] titleColorSelect:nil font:nil tag:1 isSelect:NO];
       [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}


- (UIButton *)getTextBtn
{
    if (!_getTextBtn) {
        _getTextBtn = [UIButton setBntData:_getTextBtn backColor:[UIColor colorLightBlack_2e2e2e] backImage:nil title:@"获取验证码" titleColorNormal:[UIColor whiteColor] titleColorSelect:nil font:[UIFont systemFontOfSize:FONT2] tag:1 isSelect:NO];
        [_getTextBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_getTextBtn addTarget:self action:@selector(getTestClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getTextBtn;
}





- (LoginInputView *)verificationView
{
    if (!_verificationView) {
        _verificationView = [[LoginInputView alloc]initWithImageName:@"login_lock_disable" hightLightImgName:@"login_lock" placeHoderText:@"验证码"];
        [_verificationView setDelegate:self];
        [_verificationView.textField setKeyboardType:UIKeyboardTypeNumberPad];
        
    }
    return _verificationView;
}



- (LoginInputView *)nikeNameView
{
    if (!_nikeNameView) {
        _nikeNameView = [[LoginInputView alloc]initWithImageName:@"login_nikename_disable" hightLightImgName:@"login_nikename" placeHoderText:@"昵称"];
        [_nikeNameView setDelegate:self];
    }
    return _nikeNameView;
}

- (NSString *)codeToken
{
    if (!_codeToken) {
        _codeToken = [[NSString alloc]init];
    }
    return _codeToken;
}

- (NSMutableString *)time
{
    if (!_time) {
        _time = [[NSMutableString alloc] init];
    }
    return _time;
}

- (UITapGestureRecognizer *)tapTouch
{
    if (!_tapTouch) {
        _tapTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignFirstRsp)];
    }
    return _tapTouch;
}

- (UITapGestureRecognizer *)closeTouch
{
    if (!_closeTouch) {
        _closeTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeClick)];
    }
    return _closeTouch;
}

- (NSMutableArray *)provinceArr
{
    if (!_provinceArr) {
        _provinceArr = [[NSMutableArray alloc]init];
    }
    return _provinceArr;
}

- (NSMutableArray *)cityArr
{
    if (!_cityArr) {
        _cityArr = [[NSMutableArray alloc]init];
    }
    return _cityArr;
}
#pragma mark  request --> 代理

-(void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    NSLog(@"请求成功");
    if ([response isKindOfClass:[GetCodeResponse class]]) {
        GetCodeResponse *result = (GetCodeResponse *)response;
        self.codeToken = result.codeToken;
    }
    else if ([response isKindOfClass:[RegisterResponse class]])
    {
        [self hideLoading];

        RegisterResponse *result = (RegisterResponse *)response;

        // 保存登录结果信息
        [[unifiedUserInfoManager share] saveLoginResultModel:result.loginModel];
        
        // 创建数据库
        [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[NSString stringWithFormat:@"/%@/Shape.Sqlite",result.loginModel.phone]];

        // 存储体脂率
        NSString *fatRange = [[unifiedUserInfoManager share] calculateFatRange];
        [[DBUnifiedManager share] saveFatRange:fatRange];
        
        //弹出训练设置页面
        TrainTargetViewController *targetVC = [[TrainTargetViewController alloc] init];

        BaseNavigationViewController *base = [[BaseNavigationViewController alloc] initWithRootViewController:targetVC];
        [self presentViewController:base animated:YES completion:nil];
    } else if ([response isKindOfClass:[LoginResponse class]]) {
        LoginResponse *result = (LoginResponse *)response;
        // 保存登录结果信息
        [[unifiedUserInfoManager share] saveLoginResultModel:result.resultModel];
        
        // 创建数据库
        [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[NSString stringWithFormat:@"/%@/Shape.Sqlite",result.resultModel.phone]];
        
        // 获取个人信息
        MeGetUserInfoRequest *request = [[MeGetUserInfoRequest alloc]init];
        [request prepareRequest];
        [request requestWithDelegate:self];
          

    } else if ([response isKindOfClass:[MeGetUserInfoResponse class]]) {
        [self hideLoading];
        MeGetUserInfoResponse *result = (MeGetUserInfoResponse *)response;
        // 保存到本地
        [[unifiedUserInfoManager share] saveUserInfoData:result.userInfoMogdel];
        // 显示home页
        [[NSNotificationCenter defaultCenter] postNotificationName:n_showHome object:nil];
    }

}

- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response
{   [self hideLoading];
    [self postError:response.message];
    NSLog(@"请求失败");
}
@end