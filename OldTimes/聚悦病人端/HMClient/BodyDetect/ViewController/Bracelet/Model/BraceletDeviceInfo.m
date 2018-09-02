//
//  BraceletDeviceInfo.m
//  HMClient
//
//  Created by lkl on 2017/9/22.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BraceletDeviceInfo.h"

@implementation BraceletDeviceInfo

@end

@implementation BraceletConnectDeviceInfo

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.data_from forKey:@"data_from"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.data_from = [aDecoder decodeObjectForKey:@"data_from"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
    }
    return self;
}

@end
