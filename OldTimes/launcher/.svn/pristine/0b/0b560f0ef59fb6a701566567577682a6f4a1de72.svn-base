//
//  IMLoginDAL.h
//  launcher
//
//  Created by William Zhang on 15/8/27.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  IM 登录DAL

#import "IMBaseBlockRequest.h"

@interface IMLoginResponse : IMBaseResponse

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *uid;

@end

@interface IMLoginDAL : IMBaseBlockRequest

+ (void)loginCompletion:(IMBaseResponseCompletion)completion;

@end
