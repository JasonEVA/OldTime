//
//  NSString+TaskStringFormat.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/14.
//  Copyright © 2016年 yinquan. All rights reserved.
//  任务字符串格式化

#import <Foundation/Foundation.h>

@interface NSString (TaskStringFormat)

// 将@"|"分隔的String转为顿号分隔的String
- (NSString *)hm_formatCuttingLineStringSeparatedByPeriodString;

// 将@"|"分隔的String转为数组
- (NSArray *)hm_convertCuttingLineStringToArrayComponentsSeparatedByPeriodString;
@end
