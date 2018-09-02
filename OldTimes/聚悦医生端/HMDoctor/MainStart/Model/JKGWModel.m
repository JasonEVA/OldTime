//
//  JKGWModel.m
//  HMDoctor
//
//  Created by jasonwang on 16/7/18.
//  Copyright © 2016年 yinquan. All rights reserved.
//  健康顾问Model

#import "JKGWModel.h"

@implementation JKGWModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSString class]) {
        if (oldValue == nil || oldValue == [NSNull null] || oldValue == NULL) {
            return @"";
        }
        
        if ([oldValue isEqualToString:@"(null)"]) {
            return @"";
        }
    }
    
    return oldValue;
}
@end
