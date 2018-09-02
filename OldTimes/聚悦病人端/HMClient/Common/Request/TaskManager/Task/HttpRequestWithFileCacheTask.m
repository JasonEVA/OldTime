//
//  HttpRequestWithFileCacheTask.m
//  HMClient
//
//  Created by yinquan on 17/1/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HttpRequestWithFileCacheTask.h"
#import "FileCacheStep.h"
#import "JsonHttpStep.h"

typedef NS_ENUM(NSUInteger, HttpCacheStepTag) {
    CacheStepTag,
    HttpStepTag,
};

@implementation HttpRequestWithFileCacheTask

- (void) makeCachePath
{
    
}

- (void) makeCacheTime
{
    
}

- (NSString*) postUrl
{
    return nil;
}

- (void) makeTaskParam
{
    
}

- (Step*) createFristStep
{
    [self makeCachePath];
    [self makeCacheTime];
    
    if (_cachePath)
    {
        Step* step = [[FileCacheStep alloc]initWithFilePath:_cachePath cacheTime:self.cacheTime];
        [step setTag:CacheStepTag];
        return step;
    }
    return nil;
}

- (Step*) createNextWithError
{
    NSString* postUrl = [self postUrl];
    if (postUrl)
    {
        JsonHttpStep* step = [[JsonHttpStep alloc]initWithUrl:postUrl Params:taskParam];
        [step setTag:HttpStepTag];
        return step;
    }
    return nil;
}

- (void) makeTaskResult
{
    switch (currentStep.tag) {
        case CacheStepTag:
        {
            //读取缓存
            [self makeCacheTaskResult];
        }
            break;
        case HttpStepTag:
        {
            //网络请求
            [self makeHttpRquestTaskResult];
            [self saveResultToCache];
        }
            break;
            
    }
}

- (void) makeCacheTaskResult
{
    
}

- (void) makeHttpRquestTaskResult
{
    
}

- (void) saveResultToCache
{
    if (!self.taskResult || !self.cachePath) {
        return;
    }
    [NSKeyedArchiver archiveRootObject:self.taskResult toFile:self.cachePath];
}
@end
