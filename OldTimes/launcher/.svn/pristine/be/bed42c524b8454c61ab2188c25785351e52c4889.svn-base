//
//  ATHttpConfig.h
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#ifndef ATHttpConfig_h
#define ATHttpConfig_h

typedef NS_ENUM(NSInteger, CCReturnCode) {
    
    AF_Fail =  1100,
    AF_Success = 1000,
    AF_TOKENERROR = 1103, /** 授权Token无效 */
    
    Return_OK = 0,
    
    //sign up 500起步
    SignUp_INVALID_PHONE = 501,
    SignUp_PHONE_ALREADY_REGISTERED = 502,
    SignUp_PASSWORD_ALREADY_SET = 503,
    SignUp_REQUEST_TOO_FREQUENT = 504,//发送验证码频繁，需要等待
    SignUp_INVALID_AUTHENTICODE = 505,
    SignUp_EXPIRED_AUTHENTICODE = 506,
    SignUp_ERROR_INPUT_AUTHENTICODE = 507,
    SignUp_FAILED_REGISTER = 508,
    SignUp_INVALID_GENDER = 509,
    SignUp_INVALID_TOKEN = 510,
    SignUp_INVALID_PASSWORD = 511,
    SignUp_TOKEN_ALREADY_REGISTERED = 512,
    SignUp_INVALID_NICKNAME = 513,
    SignUp_INVALID_USAGE = 514,
    SignUp_PHONE_NOT_REGISTERED = 515,
    SignUp_ACTION_FAILED = 516,
    SignUp_AUTH_FAILED = 517,
    SignUp_INVALID_DEVICE_KEY = 518,
    SignUp_DEVICEKEY_LOGINOK = 520,//Device Key验证通过，返回UserProfile和UserConfig
    
    //login 600起步
    Login_INVALID_USERNAME = 601,
    Login_INVALID_PASSWORD = 602,
    Login_USER_NOT_EXISTS = 603,
    Login_USERNAME_PASSWORD_NOT_MATCH = 604,
    Login_INVALID_PHONE = 605,
    Login_INVALID_AUTHENTICODE = 606,
    Login_AUTHENTICODE_EXPIRED = 607,
    Login_DEVICEKEY_INVALID = 608,
    Login_DEVICEKEY_NOT_LOGINED = 609,//该设备没有用户登录过
    Login_DEVICEKEY_NOT_SAME    = 610,//现在的device key和最近一次登录device key不匹配
    Login_BANNED                = 612,//后台被Ban超过五次时会限制登录。账号被封禁
    Login_DEVICEKEY_NOT_LIMITED = 613,//:注册账号未超过限制，进入注册流程
    Login_DEVICE_SIGNUP_OVERLIMIT = 615,//(设备注册用户数超过限制)
    Login_DEVICE_BANNED           = 616, //设备被封禁
    
    //checkPassword
    CheckPwd_PASSWORD_NOT_SET = 521,
    
    SYSTEM_ERROR = -1
};




#define ATDEBUG 1

#if ATDEBUG

#define URLADDRESS @"http://120.26.39.122:91/api"   // 测试地址


#else

#define URLADDRESS @"http://120.26.39.122:91/api"      //Product


#endif

#endif /* ATHttpConfig_h */
