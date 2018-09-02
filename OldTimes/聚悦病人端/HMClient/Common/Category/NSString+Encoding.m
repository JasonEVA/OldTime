//
//  NSString+Encoding.m
//  HMClient
//
//  Created by lkl on 16/5/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NSString+Encoding.h"

@implementation NSString (Encoding)

- (BOOL)isPureInt
{
    
    NSScanner* scan = [NSScanner scannerWithString:self];
    
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

@end
