//
//  HMFEPatientListEnum.h
//  HMDoctor
//
//  Created by jasonwang on 2017/10/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//  第四版患者列表枚举

#ifndef HMFEPatientListEnum_h
#define HMFEPatientListEnum_h
typedef NS_ENUM(NSUInteger, HMFEPatientListViewType) {
    HMFEPatientListViewType_Free,      // 免费用户
    HMFEPatientListViewType_Package,   // 收费套餐
    HMFEPatientListViewType_Single,    // 收费单项
    HMFEPatientListViewType_Group,     // 集团用户
}; // 视图类型

#endif /* HMFEPatientListEnum_h */
