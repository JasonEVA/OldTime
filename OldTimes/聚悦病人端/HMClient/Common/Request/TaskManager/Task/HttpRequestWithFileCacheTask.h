//
//  HttpRequestWithFileCacheTask.h
//  HMClient
//
//  Created by yinquan on 17/1/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "Task.h"

@interface HttpRequestWithFileCacheTask : Task

@property (nonatomic, retain) NSString* cachePath;
@property (nonatomic, assign) NSInteger cacheTime;
@end
