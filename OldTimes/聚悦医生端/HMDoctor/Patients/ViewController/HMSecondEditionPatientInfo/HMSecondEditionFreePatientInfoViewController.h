//
//  HMSecondEditionFreePatientInfoViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2016/11/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//  第二版患者基本信息页（免费患者）

#import "HMBaseViewController.h"
@class HMSecondEditionPationInfoModel;
@interface HMSecondEditionFreePatientInfoViewController : HMBaseViewController
- (instancetype)initWithPatientModel:(HMSecondEditionPationInfoModel *)model;
@end
