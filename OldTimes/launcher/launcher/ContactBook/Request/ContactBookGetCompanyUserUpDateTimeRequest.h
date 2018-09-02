//
//  ContactBookGetCompanyUserUpDateTimeRequest.h
//  launcher
//
//  Created by TabLiu on 16/3/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
//  获取某一层🐔- 成员的更新时间戳

#import "BaseRequest.h"

@interface ContactBookGetCompanyUserUpDateTimeRequest : BaseRequest

@property (nonatomic,strong) NSString * deptId;

@end


@interface ContactBookGetCompanyUserUpDateTimeResponse: BaseResponse

@property (nonatomic,strong) NSDictionary * dict;
@property (nonatomic,strong) NSString * deptId;

@end