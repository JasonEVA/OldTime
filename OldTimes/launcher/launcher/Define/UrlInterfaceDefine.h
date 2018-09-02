//
//  UrlInterfaceDefine.h
//  VerusKnight
//
//  Created by William Zhang on 15/1/5.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#ifndef VerusKnight_UrlInterfaceDefine_h
#define VerusKnight_UrlInterfaceDefine_h

/* ——————————————————————————Url———————————————————————————————————————-—— */
#pragma mark -- URL & KEY

/********输出打印描述（依赖DEBUG开关，用于DAL）********/
#ifdef DEBUG
#define PRINT_JSON_OUTPUT(NSString) if (DEBUG) NSLog(@"%@:%@————\n%@",[self description],@"Output",NSString)
#else
#define PRINT_JSON_OUTPUT(NSString)
#endif

/********输入打印描述（依赖DEBUG开关，用于DAL）********/
#ifdef DEBUG
#define PRINT_JSON_INPUT(NSString) if (DEBUG) NSLog(@"%@:%@————\n%@",[self description],@"Input",NSString)
#else
#define PRINT_JSON_INPUT(NSString)
#endif

/********打印方法（依赖DEBUG开关，用于方法设下日志锚点）********/
#ifdef DEBUG
#define PRINT_SELECTOR if (DEBUG) NSLog(@"%@——%@",[self description],NSStringFromSelector(_cmd))
#else
#define PRINT_SELECTOR
#endif


/********普通打印描述（依赖DEBUG开关）********/
#ifdef DEBUG
#define PRINT_STRING(NSString) if (DEBUG) NSLog(@"%@",NSString)
#else
#define PRINT_STRING(NSString)
#endif

#ifdef JAPANMODE// 🇯🇵
static NSString *const la_URLAddress    = @"https://api.workhub.jp";
static NSString *const la_imgURLAddress = @"https://a.workhub.jp";
static NSString *const la_URLWeb        = @"https://www.workhub.jp";
static BOOL isUseGoogel = YES;

#elif JAPANTESTMODE // 🇯🇵测试 mintcode.launchr.jp
static NSString *const la_URLAddress    = @"http://apitest.workhub.jp";
static NSString *const la_imgURLAddress = @"http://atest.workhub.jp";
static NSString *const la_URLWeb        = @"https://wwwtest.workhub.jp";
static BOOL isUseGoogel = YES;
#elif CHINAMODE // 演示专用
static NSString *const la_URLAddress    = @"http://api.mintcode.com";
static NSString *const la_imgURLAddress = @"http://a.mintcode.com";
static NSString *const la_URLWeb        = @"https://www.minteam.mintcode.com";
static BOOL isUseGoogel = NO;
#elif MT        // 自己公司
static NSString *const la_URLAddress    = @"http://api.mintcode.com";
static NSString *const la_imgURLAddress = @"http://a.mintcode.com";
static NSString *const la_URLWeb        = @"https://www.mt.mintcode.com";
static BOOL isUseGoogel = NO;
#elif XIHUMODE  // 西湖
static NSString *const la_URLAddress    = @"http://xhqapi.mintcode.com";
static NSString *const la_imgURLAddress = @"http://xhqa.mintcode.com";
static NSString *const la_URLWeb        = @"https://www.minteam.mintcode.com";
static BOOL isUseGoogel = NO;
#elif HAIGUANMODE // 海关
static NSString *const la_URLAddress    = @"http://60.191.36.201:6002";
static NSString *const la_imgURLAddress = @"http://60.191.36.201:6003";
static NSString *const la_URLWeb        = @"https://www.minteam.mintcode.com";
static BOOL isUseGoogel = NO;

#else           // 内网
static NSString *const la_URLAddress    = @"http://Totoro:6002";
static NSString *const la_imgURLAddress = @"http://Totoro:6003";
static NSString *const la_URLWeb        = @"http://Totoro:6006";
static BOOL isUseGoogel = NO;
#endif

#define URLADDRESS_MINTCODE @"http://www.mintcode.com"       // mintcode网站
#define KEY_UMENG           @"551ceaf7fd98c518d50008b2"      // 友盟Key


/* ——————————————————————————DAL Var————————————————————————————————————————-— */
#pragma mark - DAL Var
static NSString * const  la_token           = @"authToken";
static NSString * const  la_anothername     = @"anotherName";

/* ——————————————————————————Error & Status Describe——————————————————————————-—— */
#pragma mark - Error & Status Describe
#define ERROR_NOCAMERA      @"无摄像头或者不可用"
#define ERROR_CONNETIONG    @"亲，网络不给力哦"
#define ERROR_SAVE          @"出错了，请再试一次"
#define SUCCESS_SAVE        @"保存成功"

#endif
