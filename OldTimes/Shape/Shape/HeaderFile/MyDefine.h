//
//  MyDefine.h
//  Shape
//
//  Created by Andrew Shen on 15/10/14.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#ifndef MyDefine_h
#define MyDefine_h
#import "NotifyDefine.h"
#import "UrlInterfaceDefine.h"
#import "UIStandardDefine.h"

/********输出打印描述（依赖DEBUG开关，用于DAL）********/
#ifdef DEBUG
#define PRINT_JSON_OUTPUT(NSString) if (DEBUG) NSLog(@"%@:%@————\n%@",[self description],@"Output",NSString)
#else
#define PRINT_JSON_OUTPUT(NSString)
#endif

/********输入打印描述（依赖DEBUG开关，用于DAL）********/
#ifdef DEBUG
#define PRINT_JSON_INPUT(NSString,URL) if (DEBUG) NSLog(@"%@:%@————\n%@\n%@",[self description],@"Input",URL,NSString)
#else
#define PRINT_JSON_INPUT(NSString,URL)
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

#endif /* MyDefine_h */
