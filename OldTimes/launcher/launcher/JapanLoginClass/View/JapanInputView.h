//
//  JapanInputView.h
//  launcher
//
//  Created by williamzhang on 16/4/6.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GetValidCodeBlcok)(NSString *validcode);

typedef void(^LoginActonBlock)(NSString *phoneNumber, NSString *password, NSString *validCode);

@interface JapanInputView : UIView

@property (nonatomic, readonly) NSString *account;
@property (nonatomic, readonly) NSString *password;

//登录
- (void)LoginActionWithBlcok:(LoginActonBlock)blcok;
//获取验证码
- (void)getValidCodeWithBlock:(GetValidCodeBlcok)block;
//开始计时
- (void)startTimer;

- (void)recoverKeyboard;

@end
