//
//  AccountExistRequest.h
//  launcher
//
//  Created by williamzhang on 16/4/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  账号是否存在Request

#import "BaseRequest.h"

@interface AccountExistResponse : BaseResponse

@property (nonatomic, assign) BOOL isExist;

@end

@interface AccountExistRequest : BaseRequest

- (void)accountIsExist:(NSString *)account;

@end
