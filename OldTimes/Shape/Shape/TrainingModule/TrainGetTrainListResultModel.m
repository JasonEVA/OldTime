//
//  TrainGetTrainListResultModel.m
//  Shape
//
//  Created by jasonwang on 15/11/4.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainGetTrainListResultModel.h"
#import <MJExtension.h>

@implementation TrainGetTrainListResultModel
- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([oldValue isKindOfClass:[NSNull class]] || oldValue == nil) {
        if ([property isKindOfClass:[NSString class]]) {
            oldValue = @"";
        }
    }
    return oldValue;
}

@end
