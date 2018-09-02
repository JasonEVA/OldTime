//
//  ATModuleInteractor+PatientChat.h
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ATModuleInteractor.h"
#import "NewPatientListViewController.h"

@class ContactDetailModel,PatientInfo;

@interface ATModuleInteractor (PatientChat)

// 跳转到患者信息页，2.12.0开始除session列表外的会话跳转都先跳转到此页面
- (void)goToPatientInfoDetailWithUid:(NSString *)userId;

// 从IM model直接跳转会话页
- (void)goToSEPatientChatWithContactDetailModel:(ContactDetailModel *)model;


- (void)goPatientListVCWithPatientFilterViewType:(PatientFilterViewType)viewType;
@end
