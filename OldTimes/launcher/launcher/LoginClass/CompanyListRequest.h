//
//  CompanyListRequest.h
//  launcher
//
//  Created by williamzhang on 15/11/5.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  获取公司列表Request

#import "BaseRequest.h"

@interface CompanyListResponse : BaseResponse

/** 存储CompanyModel */
@property (nonatomic, strong) NSArray *companyList;

@end

@interface CompanyListRequest : BaseRequest

- (void)getCompanyListWithLoginName:(NSString *)loginName password:(NSString *)password;

@end
