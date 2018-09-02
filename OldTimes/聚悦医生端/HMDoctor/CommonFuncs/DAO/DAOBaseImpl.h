//
//  DAOBaseImpl.h
//  HMDoctor
//
//  Created by Andrew Shen on 2017/1/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//  数据实现基类

#import <Foundation/Foundation.h>
#import <FMDB/FMDatabaseQueue.h>

@interface DAOBaseImpl : NSObject

@property (nonatomic, strong, readonly)  FMDatabaseQueue  *DBQueue; // <##>
@property (nonatomic, readonly)  dispatch_queue_t  DBActionQueue; // <##>

- (instancetype)initWithDBQueue:(FMDatabaseQueue *)DBQueue DBActionQueue:(dispatch_queue_t)DBActionQueue;

@end
