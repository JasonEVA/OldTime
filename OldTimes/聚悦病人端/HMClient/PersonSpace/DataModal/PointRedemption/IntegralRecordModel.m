//
//  IntegralRecordModel.m
//  HMClient
//
//  Created by yinquan on 2017/7/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "IntegralRecordModel.h"

@implementation IntegralRecordModel

@end

@implementation IntegralMonthRecordModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"userIntegerDetailsVOS" : [IntegralRecordModel class]};
}

- (void) combineMonthModel:(IntegralMonthRecordModel*) monthModel
{
    if (!monthModel) {
        return ;
    }
    NSMutableArray* detailRecords = [NSMutableArray arrayWithArray:self.userIntegerDetailsVOS];
    [monthModel.userIntegerDetailsVOS enumerateObjectsUsingBlock:^(IntegralRecordModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
        __block BOOL isExisted = NO;
        [detailRecords enumerateObjectsUsingBlock:^(IntegralRecordModel* exitedModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (exitedModel.id == model.id) {
                isExisted = YES;
                *stop = isExisted;
            }
        }];
        
        if (!isExisted) {
            [detailRecords addObject:model];
        }
    }];
    
    self.userIntegerDetailsVOS = detailRecords;
}
@end

@implementation IntegralSourceRecordModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"results" : [IntegralRecordModel class]};
}

@end
