//
//  LoginAccountUtil.h
//  HMDoctor
//
//  Created by yinquan on 17/3/2.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoginAccountModel;

@interface LoginAccountUtil : NSObject


/*
 currentLoginAccount
 当前已登录的账号的登录信息
 */
- (LoginAccountModel*) currentLoginAccount;

/*
 appendAccount
 添加并保存登录帐号密码
 */
- (void) appendAccount:(NSString*) name password:(NSString *)password staffName:(NSString*) staffName userPortrait:(NSString*) userPortrait;

/*
 queryAccountList
 查询登录帐号列表
 */
- (NSArray*) queryAccountList;

/*
 deleteAccount
 删除登录账号
 */
- (void) deleteAccount:(NSString*) loginAcct;
@end
