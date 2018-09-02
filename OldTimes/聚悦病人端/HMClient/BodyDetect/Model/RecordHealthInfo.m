//
//  RecordHealthInfo.m
//  HMClient
//
//  Created by lkl on 16/5/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "RecordHealthInfo.h"

@implementation RecordHealthInfo

@end

@implementation HealthPlanRecord

@end

@implementation DeviceDetectRecord


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.kpiCode forKey:@"kpiCode"];
    [encoder encodeObject:self.kpiName forKey:@"kpiName"];
    [encoder encodeObject:self.alertContent forKey:@"alertContent"];
    [encoder encodeObject:self.isShow forKey:@"isShow"];
    [encoder encodeObject:self.relationId forKey:@"relationId"];
    [encoder encodeObject:self.sort forKey:@"sort"];
    [encoder encodeObject:self.userId forKey:@"userId"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.kpiCode = [decoder decodeObjectForKey:@"kpiCode"];
        self.kpiName = [decoder decodeObjectForKey:@"kpiName"];
        self.alertContent = [decoder decodeObjectForKey:@"alertContent"];
        self.isShow = [decoder decodeObjectForKey:@"isShow"];
        self.relationId = [decoder decodeObjectForKey:@"relationId"];
        self.sort = [decoder decodeObjectForKey:@"sort"];
        self.userId = [decoder decodeObjectForKey:@"userId"];
    }
    return  self;
}

@end