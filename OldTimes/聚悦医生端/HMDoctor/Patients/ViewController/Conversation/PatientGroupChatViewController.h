//
//  PatientGroupChatViewController.h
//  HMDoctor
//
//  Created by yinqaun on 16/5/27.
//  Copyright © 2016年 yinquan. All rights reserved.
// （自2.12版本开始废弃）

#import "ChatBaseViewController.h"

@class PatientInfo;
@interface PatientGroupChatViewController : ChatBaseViewController

@property (nonatomic, assign)  BOOL  showServiceEnd; // <##>
- (void)configPatientInfo:(PatientInfo *)patientInfo;
- (void)patientGroupHideChatInputView:(BOOL)hide;
@end
