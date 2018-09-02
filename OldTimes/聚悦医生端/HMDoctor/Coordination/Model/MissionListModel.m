//
//  MissionListModel.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionListModel.h"
#import "MissionDetailModel.h"

@implementation MissionListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"history" : [MissionDetailModel class],
             @"records" : [MissionDetailModel class]
             };
}

@end
