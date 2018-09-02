//
//  HMSuperviseEnum.h
//  HMClient
//
//  Created by jasonwang on 2017/7/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#ifndef HMSuperviseEnum_h
#define HMSuperviseEnum_h

typedef NS_ENUM(NSUInteger, SESuperviseType) {
    
    SESuperviseType_Common = 0,     // 普通样式
    
    SESuperviseType_Pressure = 1,     // 血压
    
    SESuperviseType_Histogram = 2,     // 柱状图
    
    SESuperviseType_PeakVelocity = 3,     // 峰流速值
    
    SESuperviseType_BloodGlucose = 4     // 血糖
    
};

typedef NS_ENUM(NSUInteger, SESuperviseScreening) {
    
    SESuperviseScreening_Default = 0,     // 默认
    
    SESuperviseScreening_Day = 1,     // 日均
    
    SESuperviseScreening_Week = 2,     // 周均
    
    SESuperviseScreening_Month = 3     // 月均
    
    
};

#endif /* HMSuperviseEnum_h */
