//
//  ServiceGroupMemberModel.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ServiceGroupMemberModel.h"

@implementation ServiceGroupMemberModel

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
