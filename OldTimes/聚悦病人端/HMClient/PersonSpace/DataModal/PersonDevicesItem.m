//
//  PersonDevicesItem.m
//  HMClient
//
//  Created by lkl on 2017/4/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PersonDevicesItem.h"

@implementation PersonDevicesItem

+ (NSDictionary *)objectClassInArray{
    return @{
             @"devices" : @"PersonDevicesDetail",
             };
}

@end

@implementation PersonDevicesDetail

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@",_deviceName];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.deviceIcon forKey:@"deviceIcon"];
    [aCoder encodeObject:self.deviceName forKey:@"deviceName"];
    [aCoder encodeObject:self.deviceNickName forKey:@"deviceNickName"];
    [aCoder encodeObject:self.deviceCode forKey:@"deviceCode"];
    [aCoder encodeInteger:self.isDefaultNum forKey:@"isDefaultNum"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.deviceIcon = [aDecoder decodeObjectForKey:@"deviceIcon"];
        self.deviceName = [aDecoder decodeObjectForKey:@"deviceName"];
        self.deviceNickName = [aDecoder decodeObjectForKey:@"deviceNickName"];
        self.deviceCode = [aDecoder decodeObjectForKey:@"deviceCode"];
        self.isDefaultNum = [aDecoder decodeIntegerForKey:@"isDefaultNum"];
    }
    return self;
}

@end
