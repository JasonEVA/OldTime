//
//  HealthEducationListTask.h
//  HMClient
//
//  Created by lkl on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SingleHttpRequestTask.h"
#import "HttpRequestWithFileCacheTask.h"

@interface HealthEducationColumeTask : HttpRequestWithFileCacheTask

@end

@interface HealthEducationListTask : SingleHttpRequestTask

@end

@interface HealthEducationListWithPlanTypeTask : SingleHttpRequestTask

@end
