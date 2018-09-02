//
//  ByteHexString.h
//  BlueToothDemo
//
//  Created by yinquan on 17/4/5.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ByteHexString : NSObject

+ (NSString *) parseByte2HexString:(NSData *) data;
+ (NSData *) dataFromHexString:(NSString *)hexString;

@end

@interface NSData (HexString)

- (NSString *) hexString;

@end
