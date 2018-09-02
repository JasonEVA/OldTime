//
//  DAOBaseImpl.m
//  HMDoctor
//
//  Created by Andrew Shen on 2017/1/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "DAOBaseImpl.h"


@implementation DAOBaseImpl

@synthesize DBQueue = _DBQueue;
- (instancetype)initWithDBQueue:(FMDatabaseQueue *)DBQueue DBActionQueue:(dispatch_queue_t)DBActionQueue
{
    self = [super init];
    if (self) {
        _DBQueue = DBQueue;
        _DBActionQueue = DBActionQueue;
    }
    return self;
}
@end
