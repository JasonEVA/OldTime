//
//  PathHelper.h
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathHelper : NSObject

+ (NSString*) libDir;
+ (NSString*) cacheDir;

+ (void) createDir:(NSString*) dirPath;
//用户目录
+ (NSString*) userDir:(NSInteger) userId;
//用户缓存目录
+ (NSString*) userCacheDir:(NSInteger) userId;

@end
