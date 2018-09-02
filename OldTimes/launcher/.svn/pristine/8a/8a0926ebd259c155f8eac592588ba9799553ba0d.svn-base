//
//  QRLoginViewController.m
//  launcher
//
//  Created by williamzhang on 15/11/12.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "QRLoginViewController.h"
#import "QRCodeLoginRequest.h"
#import <Masonry/Masonry.h>
#import "UIImage+Manager.h"
#import "QRLoginModel.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"

@interface QRLoginViewController () <BaseRequestDelegate>

@property (nonatomic, strong) QRLoginModel *model;

@end

@implementation QRLoginViewController

- (instancetype)initWithId:(NSString *)showId {
    self = [super init];
    if (self) {
        self.model = [QRLoginModel mj_objectWithKeyValues:showId];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LOCAL(QR_SCAN);
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationController.navigationBar.barTintColor = [UIColor themeBlue];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    QRCodeLoginRequest *request = [[QRCodeLoginRequest alloc] initWithDelegate:self identifier:1];
    [request login:self.model action:QRCodeType_scan];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *macImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mac-machine"]];
    
    [self.view addSubview:macImageView];
    [macImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(80);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = LOCAL(QR_WEB_LOGIN);
    titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(macImageView.mas_bottom).offset(30);
    }];
    
    UIButton *loginButton = [UIButton new];
    [loginButton setTitle:LOCAL(LOGINCLASS_TITLE) forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeBlue]] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(clickToLogin) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(13);
        make.right.equalTo(self.view).offset(-13);
        make.height.equalTo(@45);
        make.top.equalTo(titleLabel.mas_bottom).offset(82);
    }];
    
    UIButton *cancelButton = [UIButton new];
    [cancelButton setTitle:LOCAL(QR_CANCEL_LOGIN) forState:UIControlStateNormal];

    [cancelButton setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancelButton addTarget:self action:@selector(clickToCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(loginButton.mas_bottom).offset(42);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Button Click
- (void)clickToLogin {
    [self postLoading];
    QRCodeLoginRequest *request = [[QRCodeLoginRequest alloc] initWithDelegate:self];
    [request login:self.model action:QRCodeType_login];
}

- (void)clickToCancel {
    QRCodeLoginRequest *request = [[QRCodeLoginRequest alloc] initWithDelegate:self identifier:1];
    [request login:self.model action:QRCodeType_cancel];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if (request.identifier != wz_defaultIdentifier) {
        return;
    }
    [self postSuccess];
    
    [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@NO afterDelay:1];
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

@end
