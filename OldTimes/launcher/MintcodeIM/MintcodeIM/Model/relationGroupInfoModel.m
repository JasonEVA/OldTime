//
//  relationGroupInfoModel.m
//  MintcodeIM
//
//  Created by kylehe on 16/3/29.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "relationGroupInfoModel.h"
#import "NSDictionary+IMSafeManager.h"
static NSString *const relationGroupId = @"relationGroupId";
static NSString *const appName         = @"appName";
static NSString *const relationGroupName  = @"relationGroupName";
static NSString *const defaultNameFlag = @"defaultNameFlag";
static NSString *const createDate  = @"createDate";

@implementation relationGroupInfoModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.relationGroupId = [dict im_valueNumberForKey:relationGroupId];
        self.appName         = [dict im_valueStringForKey:appName];
        self.relationGroupName = [dict im_valueStringForKey:relationGroupName];
        self.defaultNameFlag = [dict im_valueNumberForKey:defaultNameFlag];
        self.creataDate  = [dict im_valueNumberForKey:createDate];
    }
    return self;
}


@end
