//
//  LALoginRequest.h
//  launcher
//
//  Created by William Zhang on 15/8/20.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  launcher登录请求

#import "BaseRequest.h"

@class LALoginResultModel;

@interface LALoginResponse : BaseResponse

@property (nonatomic, strong) LALoginResultModel *resultModel;

@end

@interface LALoginRequest : BaseRequest

- (void)loginName:(NSString *)loginName password:(NSString *)password;

@end
