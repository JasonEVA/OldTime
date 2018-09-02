//
//  MeTrainHistoryListModel.m
//  Shape
//
//  Created by jasonwang on 15/11/16.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeTrainHistoryListModel.h"
#import <MJExtension.h>
#import "MeTrainHistoryDetailModel.h"

@implementation MeTrainHistoryListModel
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
    return @{@"pageItems" : [MeTrainHistoryDetailModel class]};
}
@end
