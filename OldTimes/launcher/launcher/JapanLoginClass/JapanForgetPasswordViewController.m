//
//  JapanForgetPasswordViewController.m
//  launcher
//
//  Created by williamzhang on 16/4/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "JapanForgetPasswordViewController.h"
#import "SendForgetPwdEmailRequest.h"
#import "AccountValidatorRequest.h"
#import "BaseInputTableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"

@interface JapanForgetPasswordViewController () <BaseRequestDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *progressImageView;
@property (nonatomic, strong) BaseInputTableViewCell *accountInputView;

@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UIButton *resendButton;

@property (nonatomic, strong) NSString *emailString;

@end

@implementation JapanForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LOCAL(REGISTER_EMAIL_FIND);
    self.view.backgroundColor = [UIColor grayBackground];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"userInfo_backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(clickToDismiss)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.left.right.equalTo(self.view);
    }];
    
    {
        [self.contentView addSubview:self.progressImageView];
        [self.progressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(30);
        }];
    
        [self.contentView addSubview:self.accountInputView];
        [self.accountInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.progressImageView.mas_bottom).offset(30);
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(@45);
        }];
    }
    
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.contentView.mas_bottom).offset(25);
        make.height.equalTo(@45);
    }];
}

#pragma mark - Private Method
- (void)nextStep {
    self.emailLabel.text = self.emailString;
    [self.accountInputView removeConstraints:self.accountInputView.constraints];
    
    {
        // add new UI
        [self.contentView addSubview:self.emailLabel];
        [self.contentView addSubview:self.descriptionLabel];
        [self.contentView addSubview:self.resendButton];
        
        [self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.progressImageView.mas_bottom).offset(25);
        }];
        
        [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.emailLabel.mas_bottom).offset(12);
            make.left.equalTo(self.contentView).offset(50);
            make.right.equalTo(self.contentView).offset(-50);
        }];
        
        [self.resendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.descriptionLabel.mas_bottom).offset(25);
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-20);
        }];
    }
    
    [UIView animateWithDuration:0.0 animations:^{
        
        [self.progressImageView setImage:[UIImage imageNamed:@"forgetPwd_email_done"]];
        
        self.accountInputView.alpha = 0;
        [self.contentView layoutIfNeeded];
        [self.nextButton setTitle:LOCAL(REGISTER_LOGIN_BACK) forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [self.accountInputView removeFromSuperview];
        _accountInputView = nil;
    }];
}

- (void)serverSendMailIdentifer:(NSInteger)identifer {
    [self.view endEditing:YES];
    [self postLoading];
    
    NSString *email = self.emailString;
    
    AccountValidatorRequest *request = [[AccountValidatorRequest alloc] initWithDelegate:self identifier:identifer];
    [request requestWithAccount:email];
}

- (BOOL)checkEmailAccount {
    if (![self.emailString length]) {
        return NO;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self.emailString];
}

#pragma mark - Button Click
- (void)clickToSendMail:(UIButton *)sender {
    
    if (sender.tag != 0) {
        [self clickToDismiss];
        return;
    }
    
    self.emailString = [self.accountInputView txtFd].text;
    
    if (![self checkEmailAccount]) {
        [self postError:LOCAL(REGISTER_EMAIL_ERROR)];
        return;
    }
    
    [self serverSendMailIdentifer:wz_defaultIdentifier];
}

- (void)clickToDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickToResendMail {
    [self serverSendMailIdentifer:0];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([request isKindOfClass:[AccountValidatorRequest class]]) {
        AccountValidatorResponse *aResponse = (AccountValidatorResponse *)response;
        
        SendForgetPwdEmailRequest *sendRequest = [[SendForgetPwdEmailRequest alloc] initWithDelegate:self identifier:request.identifier];
        [sendRequest requestWithEmail:self.emailString validateToken:aResponse.validatorToken validateCode:aResponse.validatorCode];
    }
    
    else if ([request isKindOfClass:[SendForgetPwdEmailRequest class]]) {
        [self hideLoading];
        self.nextButton.tag ++;
        
        if (request.identifier == wz_defaultIdentifier) {
            [self nextStep];
        }
        else {
            [self postSuccess];
        }
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - Initializer
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIImageView *)progressImageView {
    if (!_progressImageView) {
        UIImage *image = [UIImage imageNamed:@"forgetPwd_email_empty"];
        _progressImageView = [[UIImageView alloc] initWithImage:image];
    }
    return _progressImageView;
}

- (BaseInputTableViewCell *)accountInputView {
    if (!_accountInputView) {
        _accountInputView = [[BaseInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _accountInputView.textLabel.text = LOCAL(ME_MAIL);
        _accountInputView.txtFd.placeholder = LOCAL(REGISTER_EMAIL);
    }
    return _accountInputView;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton new];
        [_nextButton setTitle:LOCAL(REGISTER_EMAIL_FIND_SEND) forState:UIControlStateNormal];
        [_nextButton.titleLabel setFont:[UIFont mtc_font_30]];
        [_nextButton setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeBlue]] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(clickToSendMail:) forControlEvents:UIControlEventTouchUpInside];
        
        _nextButton.layer.cornerRadius = 5;
        _nextButton.clipsToBounds = YES;
    }
    return _nextButton;
}

- (UILabel *)emailLabel {
    if (!_emailLabel) {
        _emailLabel = [UILabel new];
        _emailLabel.font = [UIFont mtc_font_26];
        _emailLabel.textColor = [UIColor blackColor];
    }
    return _emailLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [UILabel new];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.font = [UIFont mtc_font_28];
        _descriptionLabel.textColor = [UIColor mediumFontColor];
        _descriptionLabel.text = LOCAL(REGISTER_EMAIL_FIND_SEND_DESCRIPTION);
    }
    return _descriptionLabel;
}

- (UIButton *)resendButton {
    if (!_resendButton) {
        _resendButton = [UIButton new];
        _resendButton.titleLabel.font = [UIFont mtc_font_30];
        [_resendButton setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
        [_resendButton setTitle:LOCAL(REGISTER_EMAIL_FIND_RESEND) forState:UIControlStateNormal];
        [_resendButton addTarget:self action:@selector(clickToResendMail) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resendButton;
}

@end

@implementation JapanNaviForgetPasswordViewController

- (instancetype)init {
    JapanForgetPasswordViewController *rootVC = [[JapanForgetPasswordViewController alloc] init];
    if (self = [super initWithRootViewController:rootVC]) {
        self.navigationBar.barTintColor = [UIColor themeBlue];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                     NSFontAttributeName:[UIFont systemFontOfSize:18]}];
        self.navigationBar.tintColor = [UIColor whiteColor];
    }
    return self;
}

@end