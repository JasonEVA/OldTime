//
//  OrderedServiceModel.m
//  JYHMUser
//
//  Created by yinquan on 16/11/14.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "OrderedServiceModel.h"

@implementation OrderedServiceModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"dets" : @"UserServiceDet",
             };
}

+ (instancetype)mj_objectWithKeyValues:(id)keyValues
{
    OrderedServiceModel* model = [super mj_objectWithKeyValues:keyValues];
    [model.dets enumerateObjectsUsingBlock:^(UserServiceDet* det, NSUInteger idx, BOOL * _Nonnull stop) {
        det.classify = model.classify;
        det.beginTime = model.beginTime;
        det.endTime = model.endTime;
        det.upId = model.upId;
    }];
    return model;
}

- (BOOL) isGoods
{
    if (self.classify != 5) {
        return NO;
    }
    UserServiceDet* firstDet = [self.dets firstObject];
    if (!firstDet) {
        return NO;
    }
    return (firstDet.subClassify == 0);
}

- (BOOL) isBasicService
{
    return self.classify == 3;
}
@end

@implementation UserServiceDet

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"desc" : @"description"
             };
}


@end
