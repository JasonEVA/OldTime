//
//  BodyDetectSysConvertUtil.m
//  HMDoctor
//
//  Created by lkl on 2017/8/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "BodyDetectSysConvertUtil.h"

@implementation BodyDetectSysConvertUtil

//  十进制转二进制字符串
+ (NSString *)binaryStringWithInt:(int)value
{
    NSMutableString *string = [NSMutableString string];
    for (NSInteger i = 0; i < sizeof(int)*4; i++)
    {
        [string insertString:(value & 1)? @"1": @"0" atIndex:0];
        value /= 2;
    }
    
    return string;
}

//  二进制转十进制 返回int
+ (int)toDecimalSystemWithBinarySystem:(NSString *)binary
{
    int ll = 0 ;
    int  temp = 0 ;
    for (int i = 0; i < binary.length; i ++)
    {
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    return ll;
}

//十进制转二进制 （返回二进制长度）
+ (NSString *)decimalTOBinary:(uint16_t)tmpid backLength:(int)length
{
    NSString *a = @"";
    while (tmpid)
    {
        a = [[NSString stringWithFormat:@"%d",tmpid%2] stringByAppendingString:a];
        if (tmpid/2 < 1)
        {
            break;
        }
        tmpid = tmpid/2 ;
    }
    
    if (a.length <= length)
    {
        NSMutableString *b = [[NSMutableString alloc]init];;
        for (int i = 0; i < length - a.length; i++)
        {
            [b appendString:@"0"];
        }
        
        a = [b stringByAppendingString:a];
    }
    
    return a;
    
}

//字节转string
+ (NSData *)dataByteHexString:(NSString *)hexString
{
    if (!hexString||hexString.length == 0)
    {
        return nil;
    }
    NSUInteger len = hexString.length;
    
    NSData *src = [BodyDetectSysConvertUtil dataFromHexString:hexString];
    char *srcBytes = (char *)malloc(src.length);
    bzero(srcBytes,src.length);
    memcpy(srcBytes,src.bytes,src.length);
    
    char *myBuffer = (char *)malloc(15);
    bzero(myBuffer,15);
    if (len<14) {
        myBuffer[0] = len;
    }else{
        myBuffer[0] = 14;
    }
    
    for (int i = 1; i<len+1; i++)
    {
        myBuffer[i] = srcBytes[i-1];
    }
    
    NSData *data = [[NSData alloc] initWithBytes:myBuffer length:15];
    return data;
}

//data转string
+ (NSData *) dataFromHexString:(NSString *)hexString
{
    int bufLen = (int)[hexString length] / 2 ;
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2)
    {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr] ;
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSData* dataRet = [NSData dataWithBytes:myBuffer length:bufLen];
    
    return dataRet;
}

@end

