//
//  HMSomeOneALLHistorySessionViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2017/10/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//  某人所有历史会话列表

#import "HMBasePageViewController.h"
#import "HMFEPatientListEnum.h"
@class NewPatientListInfoModel;

@interface HMSomeOneALLHistorySessionViewController : HMBasePageViewController
- (instancetype)initWithModel:(NewPatientListInfoModel *)model type:(HMFEPatientListViewType)type;

@end
