//
//  FileCacheStep.h
//  HMClient
//
//  Created by yinquan on 17/1/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "Step.h"

@interface FileCacheStep : Step
{
    NSString* _cachePath;
    NSInteger _cacheTime;
}

- (id) initWithFilePath:(NSString*) path
              cacheTime:(NSInteger) cacheTime;
@property (nonatomic, readonly) NSString* cachePath;
/*
 cacheTime
 缓存文件有效时间，0 缓存永久有效，>0
 */
@property (nonatomic, readonly) NSInteger cacheTime;

@end
