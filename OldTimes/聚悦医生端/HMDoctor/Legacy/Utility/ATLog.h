//
//  ATLog.h
//  ArthasBaseAppStructure
//
//  Created by Andrew Shen on 16/2/26.
//  Copyright © 2016年 Andrew Shen. All rights reserved.
//  日志打印，输入

#import <Foundation/Foundation.h>

#define ATLOGPRINT(xx, ...)   \
if([ATLog logEnableStatus] ) {\
NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); \
}

#define ATLog(xx, ...)  ATLOGPRINT(xx, ##__VA_ARGS__)

@interface ATLog : NSObject

+ (void)configLogEnable:(BOOL)enable;
+ (BOOL)logEnableStatus;
+ (void)uploadLogFile;
@end
