//
//  CommonFuncs.h
//  HMClient
//
//  Created by yinqaun on 16/4/28.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSString+NumberString.h"

@interface CommonFuncs : NSObject

+ (BOOL) mobileIsValid:(NSString*) mobile;

//验证身份证号是否合法
+ (BOOL)validateIDCardNumber:(NSString *)value;

+ (BOOL) isInteger:(float) fValue;

+ (NSString*) picUrlPerfix;
@end
