//
//  LoginView.h
//  HMDoctor
//
//  Created by lkl on 16/9/10.
//  Copyright © 2016年 yinquan. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@interface UserLoginTextFiled : UITextField

@end

@interface LoginView : UIScrollView

@property (nonatomic, strong) UIControl *closeControl;

@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton* switchAccountButton;    //切换帐号按钮
@property (nonatomic, strong) UIButton *forgetPasswordButton;

@property (nonatomic, strong) UserLoginTextFiled *tfUserName;
@property (nonatomic, strong) UserLoginTextFiled *tfPassword;


@end
