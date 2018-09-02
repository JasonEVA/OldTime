//
//  TeamInfo.m
//  HMClient
//
//  Created by yinqaun on 16/5/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "TeamInfo.h"

@implementation TeamInfo

@end

@implementation TeamDetail

+ (NSDictionary *)objectClassInArray{
    return @{
             @"orgTeamDet" : @"StaffInfo",
             @"services":@"ServiceInfo"
             };
}
@end
