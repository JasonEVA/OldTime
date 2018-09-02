//
//  DealUserAppointmetnTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/30.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "DealUserAppointmetnTask.h"

@implementation DealUserAppointmetnTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postAppointmetnServiceUrl:@"doUserAppoint"];
    return postUrl;
}

@end
