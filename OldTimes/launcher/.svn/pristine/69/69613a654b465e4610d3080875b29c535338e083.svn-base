//
//  JapanRegisterRequest.h
//  launcher
//
//  Created by williamzhang on 16/4/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@interface JapanRegisterResponse : BaseResponse

@property (nonatomic, strong) NSString *companyShowId;
@property (nonatomic, strong) NSString *companyCode;
@property (nonatomic, strong) NSString *companyName;

@property (nonatomic, strong) NSString *userShowId;
@property (nonatomic, strong) NSString *userTrueName;
@property (nonatomic, strong) NSString *token;

@end

@interface JapanRegisterRequest : BaseRequest

- (void)registerCompanyCode:(NSString *)companyCode
                companyName:(NSString *)companyName
                    account:(NSString *)account
                   password:(NSString *)password
                   userName:(NSString *)userName;


@end
