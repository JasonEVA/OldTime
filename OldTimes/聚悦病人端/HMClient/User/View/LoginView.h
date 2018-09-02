//
//  LoginView.h
//  LongInViewController
//
//  Created by lkl on 16/9/10.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserLoginTextFiled : UITextField

@end

@interface LoginView : UIScrollView

@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *forgetPasswordButton;

@property (nonatomic, strong) UserLoginTextFiled *tfUserName;
@property (nonatomic, strong) UserLoginTextFiled *tfPassword;


@end
