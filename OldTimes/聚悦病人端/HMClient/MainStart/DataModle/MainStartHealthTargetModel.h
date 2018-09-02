//
//  MainStartHealthTargetModel.h
//  HMClient
//
//  Created by Andrew Shen on 2016/11/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//  首页目标model

#import <Foundation/Foundation.h>

@interface MainStartHealthTargetModel : NSObject

@property (nonatomic, strong)  NSString  *rootKpiCode; // 大类监测编码
@property (nonatomic, strong)  NSString  *subKpiName; // 子类监测名称
@property (nonatomic, strong)  NSString  *subKpiCode; // 子类监测编码
@property (nonatomic, strong)  NSString  *itemStartValue; // 监测项原始值-开始值
@property (nonatomic, strong)  NSString  *itemEndValue; // 监测项原始值-结束值
@property (nonatomic, strong)  NSString  *unit; // 监测项单位
@property (nonatomic, strong)  NSString  *targetValue; // 期望值-范围启始值
@property (nonatomic, strong)  NSString  *targetMaxValue; // 期望值-范围最大值
@property (nonatomic, strong)  NSString  *testValue; // 实际用户监测结果

@property (nonatomic, copy) NSString *defaultTestTime; // 测量时间
@end
