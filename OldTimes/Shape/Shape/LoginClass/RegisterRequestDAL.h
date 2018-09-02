//
//  RegisterRequestDAL.h
//  Shape
//
//  Created by jasonwang on 15/10/19.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//  注册接口

#import "BaseRequest.h"
#import "LoginResultModel.h"


@interface RegisterRequestDAL : BaseRequest
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *codeToken;

@end


@interface RegisterResponse : BaseResponse
@property (nonatomic, strong) LoginResultModel *loginModel;
@end