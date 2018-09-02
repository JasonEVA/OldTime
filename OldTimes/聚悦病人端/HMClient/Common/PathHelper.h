//
//  PathHelper.h
//  HMClient
//
//  Created by yinquan on 17/1/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathHelper : NSObject

+ (NSString*) libDir;
+ (NSString*) cacheDir;

+ (void) createDir:(NSString*) dirPath;
//用户目录
+ (NSString*) userDir:(NSInteger) userId;

@end
