//
//  NSString+ApplyFeeHandle.h
//  launcher
//
//  Created by Simon on 7/21/16.
//  Copyright © 2016 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ApplyFeeHandle)

+ (NSString *)generateCustomeMoneyTextWithCurrentText:(NSString *)currentText;

+ (double)generateMoneyWithCustomeMoneyText:(NSString *)text;
/**
 *  用于过滤除数字外的其它符号
 *
 *  @return 字符串格式
 */
+ (NSString *)filterStrWithCustomeMoneyStrText:(NSString *)text;

@end
