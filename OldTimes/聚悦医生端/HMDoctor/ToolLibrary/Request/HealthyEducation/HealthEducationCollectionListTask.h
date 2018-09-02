//
//  HealthEducationCollectionListTask.h
//  HMDoctor
//
//  Created by yinquan on 17/1/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SingleHttpRequestTask.h"

@interface HealthEducationCollectionListTask : SingleHttpRequestTask

@end

//检查是否已经收藏
@interface CheckUserClassHasCollectTask : SingleHttpRequestTask

@end

@interface addCollectTask : SingleHttpRequestTask

@end

@interface cancelCollectTask : SingleHttpRequestTask

@end

