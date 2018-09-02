//
//  LoginRequestDAL.h
//  Shape
//
//  Created by jasonwang on 15/10/19.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//  登陆接口

#import "BaseRequest.h"
#import "LoginResultModel.h"


@interface LoginRequestDAL : BaseRequest
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@end


@interface LoginResponse : BaseResponse
@property (nonatomic, strong) LoginResultModel *resultModel;

@end