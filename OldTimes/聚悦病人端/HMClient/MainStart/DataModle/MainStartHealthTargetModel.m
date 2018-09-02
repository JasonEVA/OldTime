//
//  MainStartHealthTargetModel.m
//  HMClient
//
//  Created by Andrew Shen on 2016/11/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MainStartHealthTargetModel.h"

@implementation MainStartHealthTargetModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSString class]) {
        if (oldValue == nil || oldValue == [NSNull null] || oldValue == NULL) {
            return @"";
        }
        
        if ([oldValue isKindOfClass:[NSString class]] && [oldValue isEqualToString:@"(null)"]) {
            return @"";
        }
    }
    return oldValue;
}

@end
