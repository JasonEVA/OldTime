//
//  ServiceInfo.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ServiceInfo.h"

@implementation ServiceInfo
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"desc" : @"description"
             };
}

- (BOOL) isGoods
{
    BOOL isGoods = NO;
    if (self.classify != 5) {
        return isGoods;
    }
    isGoods = (self.subClassify == 0);
    
    return isGoods;
}

@end

@implementation ServiceDetailOption

@end

@implementation ServiceDetailData

+ (NSDictionary *)objectClassInArray{
    return @{
             @"isMustYes" : @"ServiceDetailOption",
             @"isMustNo" : @"ServiceDetailOption"
             };
}
@end

@implementation ServicePayWay

@end

@implementation ServiceDetail

@synthesize selectMust;

+ (NSDictionary *)objectClassInArray{
    return @{
             @"isMustYes" : @"ServiceDetailOption",
             @"isMustNo" : @"ServiceDetailOption",
             @"selectMust": @"ServiceDetailOption",
             @"payWayList":@"ServicePayWay"
             };
}

- (NSString*) comboName
{
    if (_data)
    {
        return _data.comboName;
    }
    return nil;
}

- (NSString*) img
{
    if (_data)
    {
        return _data.img;
    }
    return nil;
}

- (NSString*) mainProviderName
{
    if (_data)
    {
        return _data.mainProviderName;
    }
    return nil;
}

- (NSString*) mainProviderDes
{
    if (_data)
    {
        return _data.mainProviderDes;
    }
    return nil;
}

- (NSString*) comboBillWayName
{
    if (_data)
    {
        return _data.comboBillWayName;
    }
    return nil;
}

- (NSInteger) comboBillWayNum
{
    if (_data)
    {
        return _data.comboBillWayNum;
    }
    return 0;
}

- (float) salePrice
{
    if (_data)
    {
        return _data.salePrice;
    }
    return 0;
}

- (float) rebate
{
    if (_data)
    {
        return _data.rebate;
    }
    return 0;
}

- (float) markPrice
{
    if (_data)
    {
        return _data.markPrice;
    }
    return 0;
}

- (NSArray*) isMustYes
{
    if (_data)
    {
        return _data.isMustYes;
    }
    return nil;
}

- (NSArray*) isMustNo
{
    if (_data)
    {
        return _data.isMustNo;
    }
    return nil;
}

- (NSString*) productDes
{
    if (_data)
    {
        return _data.productDes;
    }
    return nil;
}

@end
