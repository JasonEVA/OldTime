//
//  GetCodeRequestDAL.h
//  Shape
//
//  Created by jasonwang on 15/10/19.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//  获取验证码接口

#import "BaseRequest.h"



@interface GetCodeRequestDAL : BaseRequest
@property (nonatomic, copy) NSString *phone;

@end

@interface GetCodeResponse : BaseResponse
@property (nonatomic, copy) NSString *codeToken;  // 返回的验证码Token

@end