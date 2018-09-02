//
//  MeTrainHistoryDetailModel.m
//  Shape
//
//  Created by jasonwang on 15/11/16.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeTrainHistoryDetailModel.h"
#import <MJExtension.h>
@implementation MeTrainHistoryDetailModel
- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([oldValue isKindOfClass:[NSNull class]] || oldValue == nil) {
        if ([property isKindOfClass:[NSString class]]) {
            oldValue = @"";
        }
    }
    return oldValue;
}

@end
