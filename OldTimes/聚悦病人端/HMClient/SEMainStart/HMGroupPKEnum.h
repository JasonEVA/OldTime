//
//  HMGroupPKEnum.h
//  HMClient
//
//  Created by jasonwang on 2017/8/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#ifndef HMGroupPKEnum_h
#define HMGroupPKEnum_h

static NSString *const upLoadWeightSuccessNotification =  @"upLoadWeightSuccessNotification";

typedef NS_ENUM(NSUInteger, HMGroupPKScreening) {
    
    
    HMGroupPKScreening_Day = 0,      // 日均
    
    HMGroupPKScreening_Week = 1,     // 周均
    
    HMGroupPKScreening_Month = 2     // 月均
    
    
};

typedef NS_ENUM(NSUInteger, HMGroupPKTableType) {
    
    
    HMGroupPKTableType_gas = 0,      // 节省汽油
    
    HMGroupPKTableType_heat = 1,     // 消耗热量
    
    HMGroupPKTableType_fat = 2,      // 累计甩脂
    
    HMGroupPKTableType_praise = 3    // 收获赞

};

typedef NS_ENUM(NSUInteger, HMGroupPKSetTatgetWeightStep) {
    
    
    HMGroupPKSetTatgetWeightStep_oneHeight = 1,         // 第一步 身高
    
    HMGroupPKSetTatgetWeightStep_twoNowWeight = 2,      // 第二步 当前体重
    
    HMGroupPKSetTatgetWeightStep_threeTargetWeight = 3, // 第三步 理想体重
    
};

typedef NS_ENUM(NSUInteger, HMGroupWeightPKTimeType) {
    
    HMGroupWeightPKTimeType_thirtyDays = 0,      // 近30天

    HMGroupWeightPKTimeType_fifteenDays = 1,     // 近15天
    
    
    
};



#endif /* HMGroupPKEnum_h */
