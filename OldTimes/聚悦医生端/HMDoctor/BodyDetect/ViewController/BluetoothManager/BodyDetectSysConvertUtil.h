//
//  BodyDetectSysConvertUtil.h
//  HMDoctor
//
//  Created by lkl on 2017/8/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BodyDetectSysConvertUtil : NSObject

//  十进制转二进制字符串
+ (NSString *)binaryStringWithInt:(int)value;

//  二进制转十进制
+ (int)toDecimalSystemWithBinarySystem:(NSString *)binary;

//十进制转二进制 （可以设置返回的二进制长度）
+ (NSString *)decimalTOBinary:(uint16_t)tmpid backLength:(int)length;

//字节转string
+ (NSData *)dataByteHexString:(NSString *)hexString;

//data转string
+ (NSData *) dataFromHexString:(NSString *)hexString;

@end
