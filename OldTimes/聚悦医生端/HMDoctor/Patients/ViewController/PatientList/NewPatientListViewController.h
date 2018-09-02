//
//  NewPatientListViewController.h
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//  

#import "HMBaseViewController.h"
#import "PatientListEnum.h"

@interface NewPatientListViewController : HMBaseViewController

- (instancetype)initWithPatientFilterViewType:(PatientFilterViewType)type;

// 刷新列表
- (void)requestPatientsListImmediately:(BOOL)immediately;
@end
