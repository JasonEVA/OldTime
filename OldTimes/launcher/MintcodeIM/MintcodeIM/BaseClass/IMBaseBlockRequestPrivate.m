//
//  IMBaseBlockRequestPrivate.m
//  MintcodeIM
//
//  Created by williamzhang on 16/5/4.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "IMBaseBlockRequestPrivate.h"
#import <CommonCrypto/CommonDigest.h>

@implementation IMBaseBlockRequestPrivate

//+ (NSString *)urlParametersStringFromParameters:(NSDictionary *)parameters {
//    NSMutableString *urlParametersString = [[NSMutableString alloc] initWithString:@""];
//    if (parameters && parameters.count > 0) {
//        for (NSString *key in parameters) {
//            NSString *value = parameters[key];
//            value = [NSString stringWithFormat:@"%@", value];
//            value = [self urlEncode:value];
//            [urlParametersString appendFormat:@"&%@=%@", key, value];
//        }
//    }
//    return urlParametersString;
//}
//
//+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSDictionary *)parameters {
//    NSString *filteredUrl = originUrlString;
//    NSString *paraUrlString = [self urlParametersStringFromParameters:parameters];
//    if (paraUrlString && paraUrlString.length > 0) {
//        if ([originUrlString rangeOfString:@"?"].location != NSNotFound) {
//            filteredUrl = [filteredUrl stringByAppendingString:paraUrlString];
//        } else {
//            filteredUrl = [filteredUrl stringByAppendingFormat:@"?%@", [paraUrlString substringFromIndex:1]];
//        }
//        return filteredUrl;
//    } else {
//        return originUrlString;
//    }
//}
//
//+ (NSString *)urlEncode:(NSString *)str {
//    //different library use slightly different escaped and unescaped set.
//    //below is copied from AFNetworking but still escaped [] as AF leave them for Rails array parameter which we don't use.
//    //https://github.com/AFNetworking/AFNetworking/pull/555
//    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)str, CFSTR("."), CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
//    return result;
//}

+ (NSString *)md5StringFromString:(NSString *)string {
    if(string == nil || [string length] == 0)
        return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

@end
