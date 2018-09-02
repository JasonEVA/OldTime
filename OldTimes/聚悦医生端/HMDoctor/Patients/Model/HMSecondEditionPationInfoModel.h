//
//  HMSecondEditionPationInfoModel.h
//  HMDoctor
//
//  Created by jasonwang on 2016/11/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMSecondEditionPatientBaseUserInfoModel.h"
#import "HMSecondEditionFreePatientInfoModel.h"
#import "HMSecondEditionPaidPatientInfoModel.h"

@interface HMSecondEditionPationInfoModel : NSObject
@property (nonatomic, strong) HMSecondEditionPatientBaseUserInfoModel *userInfo;//基本信息
@property (nonatomic, strong) HMSecondEditionFreePatientInfoModel *freeAdmission;//免费患者
@property (nonatomic, strong) HMSecondEditionPaidPatientInfoModel *paidAdmissionData;//收费患者
@property (nonatomic) NSInteger payment;     //是否付费       1免费 2收费
@property (nonatomic) NSInteger hasData;
@end
