//
//  LoginView.m
//  LongInViewController
//
//  Created by lkl on 16/9/10.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "LoginView.h"

#define ServiceAlertTag 0x0001

@interface UserLoginTextFiled ()

@end

@implementation UserLoginTextFiled

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, (self.height - 20)/2, 20, 20);
    
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.size.height, 0, bounds.size.width - bounds.size.height - 10, bounds.size.height);
}

- (CGRect) editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.size.height, 0, bounds.size.width - bounds.size.height - 10, bounds.size.height);
}

- (CGRect) placeholderRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.size.height, 0, bounds.size.width - bounds.size.height - 10, bounds.size.height);
}

@end

@interface LoginView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIControl *closeControl;
@property (nonatomic, strong) UIImageView *ivImage;
@property (nonatomic, strong) UIImageView *ivLogo;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIWebView *webview;

@end

@implementation LoginView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithSubviews];
    }
    return self;
}

- (void)initWithSubviews
{
    _closeControl = [[UIControl alloc] initWithFrame:self.bounds];
    [self addSubview:_closeControl];
    [_closeControl addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventAllTouchEvents];
    
    _ivImage = [[UIImageView alloc]init];
    [_ivImage setImage:[UIImage imageNamed:@"icon_h"]];
    [_closeControl addSubview:_ivImage];
    
    _ivLogo = [[UIImageView alloc]init];
    [_ivLogo setImage:[UIImage imageNamed:@"logo_client"]];
    [_closeControl addSubview:_ivLogo];
    
    _tfUserName = [[UserLoginTextFiled alloc] init];
    [_tfUserName setLeftViewMode:UITextFieldViewModeAlways];
    [_tfUserName setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_closeControl addSubview:_tfUserName];
    [_tfUserName setBackgroundColor:[UIColor whiteColor]];
    [_tfUserName setPlaceholder:@"输入身份证号码或手机号"];
    [_tfUserName setFont:[UIFont font_32]];
    [_tfUserName setTextColor:[UIColor commonTextColor]];
    [_tfUserName setKeyboardType:UIKeyboardTypeASCIICapable];
    [_tfUserName setReturnKeyType:UIReturnKeyDone];
    [_tfUserName setDelegate:self];
    [_tfUserName showBottomLine];
    
    [_tfUserName setKeyboardType:UIKeyboardTypeASCIICapable];
    _tfUserName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _tfUserName.autocorrectionType = UITextAutocorrectionTypeNo;
    
    UIImageView* ivKeyboard = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [ivKeyboard setImage:[UIImage imageNamed:@"iconfont-shenfenzheng"]];
    [_tfUserName setLeftView:ivKeyboard];
    
    _tfPassword = [[UserLoginTextFiled alloc] init];
    [_tfPassword setLeftViewMode:UITextFieldViewModeAlways];
    [_tfPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_closeControl addSubview:_tfPassword];
    [_tfPassword setBackgroundColor:[UIColor whiteColor]];
    [_tfPassword setPlaceholder:@"输入密码"];
    [_tfPassword setTextColor:[UIColor commonTextColor]];
    [_tfPassword setFont:[UIFont font_32]];
    [_tfPassword setSecureTextEntry:YES];
    [_tfPassword setReturnKeyType:UIReturnKeyJoin];
    [_tfPassword setAdjustsFontSizeToFitWidth:YES];
    [_tfPassword setMinimumFontSize:14];
    [_tfPassword setDelegate:self];
    [_tfPassword showBottomLine];
    
    _forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeControl addSubview:_forgetPasswordButton];
    [_forgetPasswordButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [_forgetPasswordButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_forgetPasswordButton.titleLabel setFont:[UIFont font_28]];
    [_forgetPasswordButton showBottomLine];
    
    UIImageView* ivPassowrd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [_tfPassword setLeftView:ivPassowrd];
    [ivPassowrd setImage:[UIImage imageNamed:@"Lock-0"]];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeControl addSubview:_loginButton];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:[UIColor mainThemeColor]];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton.titleLabel setFont:[UIFont font_34]];
    [_loginButton.layer setCornerRadius:23.0f];
    [_loginButton.layer setMasksToBounds:YES];
    [_loginButton addTarget:self action:@selector(logonButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeControl addSubview:_registerButton];
    [_registerButton setTitle:@"用户注册" forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
    [_registerButton.titleLabel setFont:[UIFont font_26]];
    [_registerButton addTarget:self action:@selector(userRegisterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self subViewLayout];
}

- (void)subViewLayout
{
    [_ivImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(ObjHeight(20));
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(ObjWidth(120), ObjWidth(120)));
    }];
    
    [_ivLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ivImage.mas_bottom).with.offset(ObjHeight(7.5));
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(ObjWidth(120), ObjHeight(40)));
    }];
    
    [_tfUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ivLogo.mas_bottom).with.offset(ObjHeight(55));
        make.left.equalTo(self).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth-60, ObjHeight(42)));
    }];
    
    [_tfPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfUserName.mas_bottom).with.offset(ObjHeight(25));
        make.left.equalTo(self).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth-60-OBJWidth(85), ObjHeight(42)));
        
    }];
    
    [_forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_tfPassword);
        make.left.equalTo(_tfPassword.mas_right);
        make.right.equalTo(self).with.offset(-30);
        make.height.mas_equalTo(ObjHeight(42));
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tfPassword.mas_bottom).with.offset(ObjHeight(40));
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(ObjWidth(200), 42));
    }];
    
    [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginButton.mas_bottom).with.offset(ObjHeight(30));
        make.centerX.equalTo(self);
    }];
    
}


- (void) closeControlClicked:(id) sender
{
    [self closeKeyboard];
    
}

- (void) closeKeyboard
{
    NSArray* subviews = [_closeControl subviews];
    for (UIView* subview in subviews) {
        if ([subview isKindOfClass:[UITextField class]])
        {
            UITextField* tf = (UITextField*) subview;
            [tf resignFirstResponder];
        }
    }
}

- (void)userRegisterButtonClicked:(UIButton *)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"聚悦健康暂未开放注册，请联系客服完成注册" delegate:self cancelButtonTitle:@"暂不注册" otherButtonTitles:@"拨打客服", nil];
    [alert setTag:ServiceAlertTag];
    [alert show];
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
            if (_webview == nil) {
                _webview = [[UIWebView alloc] init];
            }
            //    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
            //    [self.view addSubview:_webView];
            
            NSURL *url = [NSURL URLWithString:@"tel://4008332616"];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            [_webview loadRequest:request];
        }
    }
}


- (void)logonButtonClicked:(UIButton *)sender
{
    [self closeKeyboard];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyDone)
    {
        [textField resignFirstResponder];
    }
    
    return NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
