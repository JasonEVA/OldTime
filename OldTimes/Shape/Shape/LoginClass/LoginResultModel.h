//
//  LoginResultModel.h
//  Shape
//
//  Created by Andrew Shen on 15/10/19.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//  用户登录信息

#import <Foundation/Foundation.h>

@interface LoginResultModel : NSObject

@property (nonatomic, copy)  NSString  *userName; // 用户名
@property (nonatomic, copy)  NSString  *token; // 用户token
@property (nonatomic, copy)  NSString  *phone; // 手机号
@end
