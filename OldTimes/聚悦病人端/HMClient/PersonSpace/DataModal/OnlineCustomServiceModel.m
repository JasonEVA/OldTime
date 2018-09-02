//
//  OnlineCustomServiceModel.m
//  HMClient
//
//  Created by Andrew Shen on 16/6/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OnlineCustomServiceModel.h"

@implementation OnlineCustomServiceModel

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
