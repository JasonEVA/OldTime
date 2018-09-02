//
//  NSString+URLTranscoding.m
//  launcher
//
//  Created by Simon on 16/7/1.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NSString+URLTranscoding.h"

@implementation NSString (URLTranscoding)

-(NSString *)mtc_URLDecodedString
{
	NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
	
	return decodedString;
}

- (NSString *)mtc_URLEncodedString
{
	NSString *encodedString = (NSString *)
	CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
															  (CFStringRef)self,
															  (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
															  NULL,
															  kCFStringEncodingUTF8));
	return encodedString;
}

@end
