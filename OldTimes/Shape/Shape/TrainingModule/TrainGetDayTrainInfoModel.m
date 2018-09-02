//
//  TrainGetDayTrainInfoModel.m
//  Shape
//
//  Created by jasonwang on 15/11/12.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainGetDayTrainInfoModel.h"
#import <MJExtension.h>
#import "TrainActionListModel.h"

@implementation TrainGetDayTrainInfoModel
- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([oldValue isKindOfClass:[NSNull class]] || oldValue == nil) {
        if ([property isKindOfClass:[NSString class]]) {
            oldValue = @"";
        }
    }
    return oldValue;
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"actionList" : [TrainActionListModel class]};
}
@end
