//
//  NSURLRequest+IgnoreSSL.m
//  HMClient
//
//  Created by jasonwang on 2016/11/22.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NSURLRequest+IgnoreSSL.h"

@implementation NSURLRequest (IgnoreSSL)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end
