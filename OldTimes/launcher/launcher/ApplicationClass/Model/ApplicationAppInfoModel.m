//
//  ApplicationAppInfoModel.m
//  launcher
//
//  Created by 马晓波 on 16/3/24.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ApplicationAppInfoModel.h"

@implementation ApplicationAppInfoModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSString class]) {
        if (oldValue == nil || oldValue == [NSNull null] || oldValue == NULL) {
            return @"";
        }
    }
    return oldValue;
}
@end
