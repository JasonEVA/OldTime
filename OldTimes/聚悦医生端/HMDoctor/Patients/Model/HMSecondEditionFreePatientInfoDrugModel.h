//
//  HMSecondEditionFreePatientInfoDrugModel.h
//  HMDoctor
//
//  Created by jasonwang on 2016/11/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//  第二版患者基本信息用药model（免费患者）

#import <Foundation/Foundation.h>

@interface HMSecondEditionFreePatientInfoDrugModel : NSObject
@property (nonatomic, copy) NSString *advice;              //医嘱
@property (nonatomic, copy) NSString *drugName;             //药名
@property (nonatomic, copy) NSString *drugSpecifications;   //
@property (nonatomic, copy) NSString *drugsFrequencyName;   //每日一次
@property (nonatomic, copy) NSString *drugsUsageContent;    //口服  一次5片, 每日一次
@property (nonatomic, copy) NSString *drugsUsageName;       //口服
@property (nonatomic, copy) NSString *singleDosage;         //5
@property (nonatomic, copy) NSString *singleUnit;           //片

@end
