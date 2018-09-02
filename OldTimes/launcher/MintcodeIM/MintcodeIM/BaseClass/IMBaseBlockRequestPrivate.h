//
//  IMBaseBlockRequestPrivate.h
//  MintcodeIM
//
//  Created by williamzhang on 16/5/4.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBaseBlockRequestPrivate : NSObject

//+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString
//                          appendParameters:(NSDictionary *)parameters;

+ (NSString *)md5StringFromString:(NSString *)string;

@end
