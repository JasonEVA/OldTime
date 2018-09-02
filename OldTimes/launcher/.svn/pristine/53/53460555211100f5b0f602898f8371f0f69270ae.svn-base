//
//  JapanInputView.m
//  launcher
//
//  Created by williamzhang on 16/4/6.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "JapanInputView.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"
#import "NSString+HandleEmoji.h"

@interface JapanInputView ()

@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property(nonatomic, strong) UITextField  *validCodeTextField;
@property(nonatomic, strong) UITextField  *phoneNumberField;

@property (nonatomic, strong) UIButton *loginButton;
@property(nonatomic, strong) UIButton  *accountBtn;
@property(nonatomic, strong) UIButton  *validCodeBtn;
@property(nonatomic, strong) UIButton  *getValidCodeBtn;

@property(nonatomic, assign) int  timeNumber;

@property(nonatomic, strong) NSTimer  *timer;

@property(nonatomic, copy) LoginActonBlock  myLoginBlock;
@property(nonatomic, copy) GetValidCodeBlcok  myGetValidCodeBlock;

@end

@implementation JapanInputView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor mtc_colorWithHex:0xffffff alpha:0.8];
        [self createFrame];
        self.accountBtn.selected = YES;
    }
    return self;
}


#pragma mark - interfaceMethod
- (void)LoginActionWithBlcok:(LoginActonBlock)blcok
{
    self.myLoginBlock = blcok;
}

- (void)getValidCodeWithBlock:(GetValidCodeBlcok)block
{
    self.myGetValidCodeBlock = block;
}

- (void)startTimer
{
    if (_timeNumber == 0)
    {
        _timeNumber = 60;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    }
}

- (void)recoverKeyboard {
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (NSString *)account  { return self.accountTextField.text; }
- (NSString *)password { return self.passwordTextField.text; }

#pragma mark - eventRespond
- (void)seeMoreAction:(UIButton *)sender
{
    sender.selected ^=1;
    self.passwordTextField.secureTextEntry = !sender.selected;
}

- (void)selectAction:(UIButton *)sender
{
    if (sender.selected) return ;
        sender.selected = YES;
    if (sender == self.accountBtn)
    {
        self.validCodeBtn.selected = !sender.selected;
    }else
    {
        self.accountBtn.selected = !sender.selected;
    }
    
    [self updateConstraints];
}

- (void)timeChangAction
{
    if (_timer) return;
    if (self.myGetValidCodeBlock)
    {
        self.myGetValidCodeBlock(self.validCodeTextField.text);
    }
}

- (void)timeChange
{
    if (_timeNumber > 0) {
        _timeNumber = _timeNumber - 1;
        NSString * string = [NSString stringWithFormat:@"%d秒后重试",_timeNumber];
        [_getValidCodeBtn setTitle:string forState:UIControlStateNormal];
    }else
    {
        [_timer invalidate];
        _timer = nil;
        _timeNumber = 0;
        [_getValidCodeBtn setTitle:@"获取" forState:UIControlStateNormal];
    }
}

- (void)loginAction
{
    if (self.myLoginBlock) {
        self.myLoginBlock(self.accountTextField.text,self.accountBtn.selected?self.passwordTextField.text:nil,self.validCodeTextField.text);
    }
}


#pragma mark - createFrame
- (void)createFrame
{
    [self addSubview:self.accountBtn];
    [self addSubview:self.validCodeBtn];
    [self addSubview:self.accountTextField];
    [self addSubview:self.passwordTextField];
    [self addSubview:self.loginButton];
    [self addSubview:self.validCodeTextField];
    [self addSubview:self.getValidCodeBtn];
    [self addSubview:self.phoneNumberField];
    
    self.accountBtn.hidden = YES;
    self.validCodeBtn.hidden = YES;
    
    [self.accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).dividedBy(2);
//        make.height.equalTo(@44);
        make.height.equalTo(@0);
        make.top.equalTo(self);
        make.left.equalTo(self);
    }];
    [self.validCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountBtn.mas_right);
        make.right.equalTo(self);
        make.centerY.equalTo(self.accountBtn);
        make.height.equalTo(self.accountBtn);
    }];
}

- (void)updateConstraints
{
    [super updateConstraints];
    if (self.accountBtn.selected)
    {
        self.phoneNumberField.hidden = YES;
        self.passwordTextField.hidden = NO;
        self.accountTextField.hidden = NO;
    
        [self.accountTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self.accountBtn.mas_bottom).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.equalTo(@55);
        }];
        
        [self.passwordTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.height.left.equalTo(self.accountTextField);
            make.top.equalTo(self.accountTextField.mas_bottom).offset(20);
        }];
        
        [self.loginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.accountTextField);
            make.bottom.equalTo(self.mas_bottom).offset(-20);
            make.width.equalTo(self.accountTextField);
            make.height.equalTo(@45);
            make.top.equalTo(self.passwordTextField.mas_bottom).offset(20);
        }];
        
//        [self.validCodeTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.height.left.equalTo(self.accountTextField);
//            make.top.equalTo(self.passwordTextField.mas_bottom).offset(20);
//            make.right.equalTo(self.accountTextField).offset(-90);
//        }];
        
//        [self.getValidCodeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.validCodeTextField.mas_right);
//            make.bottom.equalTo(self.validCodeTextField);
//            make.right.equalTo(self.accountTextField);
//            make.height.equalTo(@44);
//        }];
    }else
    {
        self.phoneNumberField.hidden = NO;
        self.passwordTextField.hidden = YES;
        self.accountTextField.hidden = YES;
        
        [self.phoneNumberField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self.accountBtn.mas_bottom).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.equalTo(@55);
        }];
        
//        [self.validCodeTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.height.left.equalTo(self.phoneNumberField);
//            make.top.equalTo(self.phoneNumberField.mas_bottom).offset(20);
//            make.right.equalTo(self.phoneNumberField).offset(-90);
//        }];
//        
//        [self.getValidCodeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.validCodeTextField.mas_right);
//            make.bottom.equalTo(self.validCodeTextField);
//            make.right.equalTo(self.phoneNumberField);
//            make.height.equalTo(@44);
//        }];
    }
}

#pragma mark - Create


- (UITextField *)textFieldWithLeftImageName:(NSString *)imageName{
    UITextField *textField = [UITextField new];
	

	//http://www.jianshu.com/p/1c453fa3be88
	if (IOS_VERSION_9_OR_ABOVE || IOS_VERSION_8_OR_ABOVE) {
		UIView *lineView = [UIView new];
		lineView.backgroundColor = [UIColor minorFontColor];		
		[textField addSubview:lineView];
		[lineView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.bottom.equalTo(textField);
			make.height.equalTo(@1);
		}];
	}

	
    CGSize size = [UIImage imageNamed:imageName].size;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(00, 0, size.width + 20, size.height + 20)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(contentView);
        make.top.left.equalTo(contentView).offset(5);
        make.right.equalTo(contentView).offset(-5);
        make.bottom.equalTo(contentView).offset(-14);
    }];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    textField.leftView = contentView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
        return textField;
}

#pragma mark - Notification
- (void)textFieldTextDidChange:(NSNotification *)notifcation {
	UITextField *textfiled = (UITextField *)notifcation.object;
	NSString *text = [textfiled.text stringByRemovingEmoji];
	if (![text isEqualToString:textfiled.text]) {
		textfiled.text = text;
	}
	
}

#pragma mark - Initializer
- (UITextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [self textFieldWithLeftImageName:@"Login_account"];
        _accountTextField.font = [UIFont mtc_font_30];
        _accountTextField.placeholder = [NSString stringWithFormat:@"%@/WorkHub ID", LOCAL(LOGINCLASS_NAME)];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:_accountTextField];
    }
    return _accountTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [self textFieldWithLeftImageName:@"Login_Lock_black"];//@"login_certification"];
        _passwordTextField.font = [UIFont mtc_font_30];
        _passwordTextField.placeholder = LOCAL(LOGINCLASS_PASSWORD);
        _passwordTextField.secureTextEntry = YES;
        
        CGSize size = [UIImage imageNamed:@"Login_eye_closed"].size;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(00, 0, size.width + 20, size.height + 20)];
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"Login_eye_closed"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"Login_eye_open"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(seeMoreAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
        }];
        _passwordTextField.rightView = view;
        _passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _passwordTextField;
}

- (UITextField *)validCodeTextField
{
    if (!_validCodeTextField)
    {
        _validCodeTextField = [self textFieldWithLeftImageName:@"login_certification"];
        _validCodeTextField.font = [UIFont mtc_font_30];
        _validCodeTextField.placeholder = LOCAL(LOGINCLASS_ENTERVALIDCODE);
		_validCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _validCodeTextField.hidden = YES;
    }
    return _validCodeTextField;
}

- (UITextField *)phoneNumberField
{
    if (!_phoneNumberField)
    {
        _phoneNumberField = [self textFieldWithLeftImageName:@"Login_Phone"];
        _phoneNumberField.font = [UIFont mtc_font_30];
        _phoneNumberField.placeholder = @"请输入手机号";
		_phoneNumberField.keyboardType = UIKeyboardTypePhonePad;
    }
    return _phoneNumberField;
}


- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton new];
        
        [_loginButton setTitle:LOCAL(LOGINCLASS_TITLE) forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeBlue]] forState:UIControlStateNormal];
        _loginButton.titleLabel.textColor = [UIColor whiteColor];
        _loginButton.layer.cornerRadius = 5.0;
        _loginButton.clipsToBounds = YES;
        [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)accountBtn
{
    if (!_accountBtn)
    {
        _accountBtn = [[UIButton alloc] init];
        [_accountBtn setTitle:@"账号登录" forState:UIControlStateNormal];
        [_accountBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1]] forState:UIControlStateNormal];
        [_accountBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor clearColor]] forState:UIControlStateSelected];
        [_accountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_accountBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _accountBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [_accountBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_accountBtn setAdjustsImageWhenHighlighted:NO];
    }
    return _accountBtn;
}

- (UIButton *)validCodeBtn
{
    if (!_validCodeBtn)
    {
        _validCodeBtn = [[UIButton alloc] init];
        [_validCodeBtn setTitle:@"验证码登录" forState:UIControlStateNormal];
        [_validCodeBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1]] forState:UIControlStateNormal];
        [_validCodeBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor clearColor]] forState:UIControlStateSelected];
        [_validCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_validCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _validCodeBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [_validCodeBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_validCodeBtn setAdjustsImageWhenHighlighted:NO];
    }
    return _validCodeBtn;
}

- (UIButton *)getValidCodeBtn
{
    if (!_getValidCodeBtn)
    {
        _getValidCodeBtn = [[UIButton alloc] init];
        [_getValidCodeBtn setTitle:@"获取" forState:UIControlStateNormal];
        [_getValidCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _getValidCodeBtn.layer.borderColor = [UIColor minorFontColor].CGColor;
        _getValidCodeBtn.layer.borderWidth = 1.0;
        _getValidCodeBtn.titleLabel.font = [UIFont mtc_font_30];
        _getValidCodeBtn.layer.cornerRadius = 3;
        _getValidCodeBtn.layer.masksToBounds = YES;
        [_getValidCodeBtn addTarget:self action:@selector(timeChangAction) forControlEvents:UIControlEventTouchUpInside];
        _getValidCodeBtn.hidden = YES;
    }
    return _getValidCodeBtn;
}

@end
