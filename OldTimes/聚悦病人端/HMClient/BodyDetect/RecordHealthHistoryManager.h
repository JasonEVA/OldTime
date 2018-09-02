//
//  RecordHealthHistoryManager.h
//  HMClient
//
//  Created by jasonwang on 2016/12/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//  管理本地上一次提交的健康记录数值manager

#import <Foundation/Foundation.h>

@interface RecordHealthHistoryManager : NSObject

+ (instancetype)sharedInstance;

- (void)saveWithHealthType:(NSString *)type number:(id)number;

- (NSString *)getHealthTypeNumberWithType:(NSString *)type;

- (NSArray *)getHealthTypeArrayWithType:(NSString *)type;

@end
