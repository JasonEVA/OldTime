//
//  SendForgetPwdEmailRequest.h
//  launcher
//
//  Created by williamzhang on 16/4/13.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  发送忘记密码邮件request

#import "BaseRequest.h"

@interface SendForgetPwdEmailRequest : BaseRequest

- (void)requestWithEmail:(NSString *)email validateToken:(NSString *)token validateCode:(NSString *)code;

@end
