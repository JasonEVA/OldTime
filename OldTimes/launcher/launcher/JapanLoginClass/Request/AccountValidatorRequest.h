//
//  AccountValidatorRequest.h
//  launcher
//
//  Created by williamzhang on 16/4/13.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  新增邮件验证器request 用于找回密码

#import "BaseRequest.h"

@interface AccountValidatorRequest : BaseRequest

- (void)requestWithAccount:(NSString *)account;

@end

@interface AccountValidatorResponse : BaseResponse

@property (nonatomic, strong) NSString *validatorToken;
@property (nonatomic, strong) NSString *validatorCode;

@end