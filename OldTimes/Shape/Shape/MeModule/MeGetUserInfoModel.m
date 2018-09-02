//
//  MeGetUserInfoModel.m
//  Shape
//
//  Created by jasonwang on 15/10/23.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeGetUserInfoModel.h"
#import <MJExtension/MJExtension.h>
@implementation MeGetUserInfoModel

- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([oldValue isKindOfClass:[NSNull class]] || oldValue == nil) {
        if ([property isKindOfClass:[NSString class]]) {
            oldValue = @"";
        }
    }
    return oldValue;
}
@end
