//
//  MainConsoleFunctionModel.m
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "MainConsoleFunctionModel.h"

@implementation MainConsoleFunctionModel

MJCodingImplementation

@end

@implementation MainConsoleFunctionRetModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"functionList" : [MainConsoleFunctionModel class]
             };
}

- (NSString*) staffRoleString
{
    if (!self.staffRole && self.staffRole.length == 0) {
        return nil;
    }
    
    if ([self.staffRole isEqualToString:@"JKGW"])
    {
        return @"健康顾问";
    }
    else if ([self.staffRole isEqualToString:@"YS"])
    {
        return @"医生";
    }
    else if ([self.staffRole isEqualToString:@"YXGW"])
    {
        return @"医学顾问";
    }
    else if ([self.staffRole isEqualToString:@"GAGLS"])
    {
        return @"个案管理师";
    }
    else if ([self.staffRole isEqualToString:@"ZZYS"])
    {
        return @"主管医生";
    }
    else if ([self.staffRole isEqualToString:@"SXZJ"])
    {
        return @"首席专家";
    }
    else if ([self.staffRole isEqualToString:@"YYS"])
    {
        return @"营养师";
    }
    else if ([self.staffRole isEqualToString:@"KFS"])
    {
        return @"康复师";
    }
    else if ([self.staffRole isEqualToString:@"XLYS"])
    {
        return @"心理医生";
    }
    else if ([self.staffRole isEqualToString:@"YAOSHI"])
    {
        return @"药师";
    }
    return nil;
}

@end
