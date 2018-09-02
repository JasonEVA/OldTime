//
//  ByteHexString.m
//  BlueToothDemo
//
//  Created by yinquan on 17/4/5.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "ByteHexString.h"

@implementation ByteHexString

+(NSString *) parseByte2HexString:(NSData *) data

{
    Byte* bytes = (Byte*)[ data bytes];
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    
    int i = 0;
    
    if(bytes)
    {
        //while (bytes[i] != '\0')
        for (int index = 0; index < [data length]; ++index)
        {
            NSString *hexByte = [NSString stringWithFormat:@"%X",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
            {
                [hexStr appendFormat:@"0%@", hexByte];
            }
            else
            {
                [hexStr appendFormat:@"%@", hexByte];
                
            }
            i++;
        }
        
    }
    
    return hexStr;
    
}


+ (NSData *) dataFromHexString:(NSString *)hexString
{ //
    
    int bufLen = (int)[hexString length] / 2 ;
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr] ;
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSData* dataRet = [NSData dataWithBytes:myBuffer length:bufLen];
    free(myBuffer);
    return dataRet;
}

@end

@implementation NSData (HexString)

- (NSString *) hexString
{
    NSString* hexString = [ByteHexString parseByte2HexString:self];
    return hexString;
}

@end
