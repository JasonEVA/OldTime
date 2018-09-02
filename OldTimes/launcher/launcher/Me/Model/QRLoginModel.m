//
//  QRLoginModel.m
//  launcher
//
//  Created by williamzhang on 15/11/13.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "QRLoginModel.h"
#import "NSData+AES256.h"

@implementation QRLoginModel

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"QRId":@"id"};
}

- (NSString *)realId {
    return [NSData AES256DecryptWithCiphertext:self.QRId withKey:KindQRCode];
}

- (NSString *)realURL {
    return [NSData AES256DecryptWithCiphertext:self.url withKey:KindQRCode];
}

@end
