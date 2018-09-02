//
//  PathHelper.m
//  HMClient
//
//  Created by yinquan on 17/1/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PathHelper.h"

@implementation PathHelper

+ (NSString*) libDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libDir = [paths objectAtIndex:0];
    return libDir;
}

+ (NSString*) cacheDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *libDir = [paths objectAtIndex:0];
    return libDir;
}

+ (void) createDir:(NSString*) dirPath
{
    BOOL dirIsExisted = [[NSFileManager defaultManager] fileExistsAtPath:dirPath];
    if (dirIsExisted)
    {
        return;
    }
    [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (NSString*) userDir:(NSInteger) userId
{
    NSString* userDirName = [NSString stringWithFormat:@"u_%ld", userId];
    NSString* libDir = [self libDir];
    NSString* userDir = [libDir stringByAppendingPathComponent:userDirName];
    [self createDir:userDir];
    return userDir;
}

@end
