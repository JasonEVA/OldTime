//
//  LoginResultModel.m
//  Shape
//
//  Created by Andrew Shen on 15/10/19.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "LoginResultModel.h"
#import <MJExtension/MJExtension.h>

@implementation LoginResultModel

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([oldValue isKindOfClass:[NSNull class]] || oldValue == nil) {
        if ([property isKindOfClass:[NSString class]]) {
            oldValue = @"";
        }
    }
    return oldValue;
}
@end
