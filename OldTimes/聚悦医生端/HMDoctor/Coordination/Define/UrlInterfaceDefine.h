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
