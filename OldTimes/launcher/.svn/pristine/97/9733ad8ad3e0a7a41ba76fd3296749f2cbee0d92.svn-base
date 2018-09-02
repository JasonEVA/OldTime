//
//  CreateNewCompanyRequest.h
//  launcher
//
//  Created by williamzhang on 16/4/12.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  创建新团队

#import "BaseRequest.h"

@interface CreateNewCompanyResponse : BaseResponse

@property (nonatomic, strong) NSString *companyShowId;
@property (nonatomic, strong) NSString *companyCode;
@property (nonatomic, strong) NSString *companyName;

@property (nonatomic, strong) NSString *userShowId;
@property (nonatomic, strong) NSString *userTrueName;
@property (nonatomic, strong) NSString *token;

@end

@interface CreateNewCompanyRequest : BaseRequest

- (void)requestCompanyName:(NSString *)companyName companyCode:(NSString *)companyCode userName:(NSString *)userName;

@end
