//
//  HMGetCheckImgListModel.m
//  HMDoctor
//
//  Created by lkl on 2017/3/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMGetCheckImgListModel.h"

@implementation HMImgListModel

@end

@implementation HMGetCheckImgListModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"imgList" : @"HMImgListModel",
             };
}

@end

@implementation CheckItemTypeModel

@end


@implementation CheckItemIndexDetailModel

@end

@implementation CheckIteminsepecJsonDetailModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"checkIndexList" : @"CheckItemIndexDetailModel",
             };
}

@end

@implementation CheckItemDetailModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"imgList" : @"HMImgListModel",
             //@"insepecCheckJsonObject" : @"CheckIteminsepecJsonDetailModel",
             };
}

@end
