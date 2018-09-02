//
//  AppScheduleModel.m
//  launcher
//
//  Created by Andrew Shen on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "AppScheduleModel.h"
#import <MJExtension/MJExtension.h>

@implementation AppScheduleModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSString class]) {
        if (oldValue == nil || oldValue == [NSNull null] || oldValue == NULL) {
            return @"";
        }
    }
    return oldValue;
}

@end
