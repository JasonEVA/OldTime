//
//  FileCacheStep.m
//  HMClient
//
//  Created by yinquan on 17/1/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "FileCacheStep.h"

@implementation FileCacheStep

@synthesize cachePath = _cachePath;
@synthesize cacheTime = _cacheTime;

- (id) initWithFilePath:(NSString*) path
              cacheTime:(NSInteger) cacheTime
{
    self = [super init];
    if (self) {
        _cachePath = path;
        _cacheTime = cacheTime;
    }
    return self;
}

- (EStepErrorCode) runStep
{
    //判断缓存文件是否合法
    if (!_cachePath || _cachePath.length == 0) {
        return StepError_InvalidParam;
    }
    
    //判断文件是否存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:_cachePath]) {
        return StepError_PathNoFound;
    }
    
    _stepResult = [self loadCache];
    
    //判断缓存文件是否过期
    if (self.cacheTime > 0) {
        NSTimeInterval cacheTimeToNow = [self cacheTimeToNow];
        if (cacheTimeToNow > self.cacheTime) {
            //文件已经过期
            return StepError_CacheOverdue;
        }
    }
    
    return StepError_None;
}

- (id) loadCache
{
    id ret = [NSKeyedUnarchiver unarchiveObjectWithFile:self.cachePath];
    return ret;
}

- (NSTimeInterval) cacheTimeToNow
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:self.cachePath error:nil]; ;
    if (!fileAttributes) {
        return 0;
    }
    
    NSDate*  fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
    NSTimeInterval cacheTimeToNow = [[NSDate date] timeIntervalSinceDate:fileModDate];
    
    return cacheTimeToNow;
}


@end
