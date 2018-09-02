//
//  LoginAccountModel.h
//  HMDoctor
//
//  Created by yinquan on 17/3/2.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginAccountModel : NSObject

@property (nonatomic, retain) NSString* loginAccount;
@property (nonatomic, retain) NSString* loginPassword;
@property (nonatomic, retain) NSString* staffName;
@property (nonatomic, retain) NSString* userPortrait;   //用户头像
@property (nonatomic, assign) NSInteger login;

@end
