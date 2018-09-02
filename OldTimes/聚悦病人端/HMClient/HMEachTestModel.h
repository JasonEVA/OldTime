//
//  HMEachTestModel.h
//  HMClient
//
//  Created by jasonwang on 2017/6/9.
//  Copyright © 2017年 YinQ. All rights reserved.
//  监测计划每组数据model

#import <Foundation/Foundation.h>

@interface HMEachTestModel : NSObject
@property (nonatomic) NSInteger status;   // 0绿 1黄
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *testResult;
@property (nonatomic, copy) NSString *szy;   // 血压才用到
@property (nonatomic, copy) NSString *ssy;   // 血压才用到
@property (nonatomic, copy) NSString *testValue; // 血压才不用到
@property (nonatomic, copy) NSString *kpiCode;  //用于尿量区分日夜   “NL_SUB_DAY”   "NL_SUB_NIGHT"
@property (nonatomic) NSInteger timeStage;   // 峰流速值专用字段  早 0  晚 1 其他 2

// 自己加的方便数据处理  by-Jason
@property (nonatomic) BOOL isMorning;
@property (nonatomic, copy) NSValue *pointValue;

@end
