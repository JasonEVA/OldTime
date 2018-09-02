//
//  MT_logSwitch.h
//  launcher
//
//  Created by Dee on 16/7/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MT_Log(format,...) CustomLog(__FUNCTION__,__LINE__,format,##__VA_ARGS__)


/**
 *  自定义log
 *
 *  @param func       方法名
 *  @param lineNumber 行号
 *  @param format     输出内容
 *  @param ...        个数可变的log参数
 */
void CustomLog(const char *func, int lineNumber, NSString *format, ...);


@interface MT_logSwitch : NSObject

+ (void)setLogEnable:(BOOL)flag;

+ (BOOL)logEnable;
@end
