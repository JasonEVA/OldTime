//
//  NSDate+StringFromToday.h
//  HMViewMgrDemo
//
//  Created by yinqaun on 16/3/31.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (StringFromToday)

+ (NSDate*) dateFromStandardDateTimeString:(NSString*) dateString;
+ (NSDate*) dateFromeStandardDateString:(NSString*) dateString;

- (NSString*) datetimeStringWithStandardFormat;
- (NSString*) dateStringWithStandardFormat;
- (NSString*) timeStringWithStandardFormat;


@end
