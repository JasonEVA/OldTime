//
//  HMSuperviseEachPointModel.h
//  HMClient
//
//  Created by jasonwang on 2017/7/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMSuperviseEachPointModel : NSObject
@property (nonatomic) NSInteger status;     // 1 有症状 0 无症状
@property (nonatomic, copy) NSString *testValue;
@property (nonatomic, copy) NSString *subKpiCode;
@property (nonatomic, copy) NSString *testResult;
@property (nonatomic, copy) NSString *testTimeName;
@property (nonatomic, copy) NSString *timestage;
@property (nonatomic) long long timeStamp;
@property (nonatomic) NSInteger timeStage;   // 峰流速值专用字段  早 0  晚 1 其他 2

@end
