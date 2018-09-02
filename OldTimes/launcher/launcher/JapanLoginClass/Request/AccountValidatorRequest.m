//
//  AccountValidatorRequest.m
//  launcher
//
//  Created by williamzhang on 16/4/13.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "AccountValidatorRequest.h"
#import "NSDictionary+SafeManager.h"

@implementation AccountValidatorRequest

- (NSString *)api {return @"/Base-Module/EmailValidator"; }
- (NSString *)type { return @"PUT"; }

- (void)requestWithAccount:(NSString *)account {
    self.params[@"uEmail"]            = account;
    self.params[@"uValidatorToken"]   = [self createRandomCodeForLength:28];
    self.params[@"uValidatorType"]    = @2;
    self.params[@"uValidatorCode"]    = [self createRandomCodeForLength:30];
    self.params[@"uValidatorMinutes"] = @1;
    
    [self requestData];
}

- (NSString *)createRandomCodeForLength:(NSInteger)length {
    NSArray *arrayString = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z"];
    
    NSString *result = @"";
    for (NSInteger i = 0; i < length; i ++) {
        NSInteger random = arc4random() % [arrayString count];
        result = [result stringByAppendingString:[arrayString objectAtIndex:random]];
    }
    
    return result;
}

- (BaseResponse *)prepareResponse:(id)data {
    AccountValidatorResponse *response = [AccountValidatorResponse new];
    
    response.validatorToken = [data valueStringForKey:@"uValidatorToken"];
    response.validatorCode  = [data valueStringForKey:@"uValidatorCode"];
    
    return response;
}

@end

@implementation AccountValidatorResponse
@end