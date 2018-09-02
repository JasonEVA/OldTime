//
//  NewMissionGroupModel.m
//  HMDoctor
//
//  Created by jasonwang on 16/8/4.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "NewMissionGroupModel.h"

@implementation NewMissionGroupModel

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
