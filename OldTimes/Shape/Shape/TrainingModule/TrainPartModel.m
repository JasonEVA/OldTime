//
//  TrainPartModel.m
//  Shape
//
//  Created by jasonwang on 15/11/9.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainPartModel.h"
#import <MJExtension.h>

@implementation TrainPartModel
- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([oldValue isKindOfClass:[NSNull class]] || oldValue == nil) {
        if ([property isKindOfClass:[NSString class]]) {
            oldValue = @"";
        }
    }
    return oldValue;
}

@end
