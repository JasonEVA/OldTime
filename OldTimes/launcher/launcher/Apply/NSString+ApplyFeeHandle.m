//
//  NSString+ApplyFeeHandle.m
//  launcher
//
//  Created by Simon on 7/21/16.
//  Copyright © 2016 William Zhang. All rights reserved.
//

#import "NSString+ApplyFeeHandle.h"

@implementation NSString (ApplyFeeHandle)

+ (double)generateMoneyWithCustomeMoneyText:(NSString *)text {
	NSString *result =  [text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
	result = [result stringByReplacingOccurrencesOfString:@"," withString:@""];
	return [result doubleValue];
}

+ (NSString *)filterStrWithCustomeMoneyStrText:(NSString *)text {
    NSString *result =  [text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"," withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"." withString:@""];
    return result;
}

+ (NSString *)generateCustomeMoneyTextWithCurrentText:(NSString *)currentText {
	
	NSString *text = [currentText stringByReplacingOccurrencesOfString:@"￥" withString:@""];
	NSString *intMoney = [[text componentsSeparatedByString:@"."] firstObject];
	
	NSRange dotRange = [text rangeOfString:@"."];
	NSString *floatMoney = @"";
	if (dotRange.location != NSNotFound) {
		floatMoney = [text substringFromIndex:dotRange.location+1];
	}
	
	intMoney = [intMoney stringByReplacingOccurrencesOfString:@"," withString:@""];
	
	NSMutableString *resultMoney = [NSMutableString stringWithString:intMoney];
	
	if (intMoney.length >= 4) {
		[resultMoney insertString:@"," atIndex:(intMoney.length-3)];
		
		if (intMoney.length >= 7) {
			[resultMoney insertString:@"," atIndex:(intMoney.length-6)];
		}
		
		if (intMoney.length >= 10) {
			[resultMoney insertString:@"," atIndex:(intMoney.length-9)];
		}
		
		if (intMoney.length >= 13) {
			[resultMoney insertString:@"," atIndex:(intMoney.length-12)];
		}

		
	} else {
		
	}
	
	NSString *result = @"";
	if (dotRange.location != NSNotFound && ![floatMoney isEqualToString:@""]) {
		result = [NSString stringWithFormat:@"￥%@.%@", resultMoney, floatMoney];
	} else if (dotRange.location != NSNotFound) {
		result = [NSString stringWithFormat:@"￥%@.", resultMoney];
	} else {
		result = [NSString stringWithFormat:@"￥%@", resultMoney];
	}
	
	return result;
}

@end
