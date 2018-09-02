//
//  ATModuleInteractor+PatientChat.m
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ATModuleInteractor+PatientChat.h"
#import "HMSEPatientDetailInfoViewController.h"
#import "HMSEPatientGroupChatViewController.h"

@implementation ATModuleInteractor (PatientChat)

- (void)goToPatientInfoDetailWithUid:(NSString *)userId {
     HMSEPatientDetailInfoViewController *VC = [[HMSEPatientDetailInfoViewController alloc] initWithUserId:userId];
    [self pushToVC:VC];
}

- (void)goToSEPatientChatWithContactDetailModel:(ContactDetailModel *)model {
    HMSEPatientGroupChatViewController *chatVC = [[HMSEPatientGroupChatViewController alloc] initWithDetailModel:model];
    chatVC.chatType = IMChatTypePatientChat;
    [self pushToVC:chatVC];
}

- (void)goPatientListVCWithPatientFilterViewType:(PatientFilterViewType)viewType {
    NSLog(@"=-=-=-=-=-=-=-=已废弃方法");
}

@end
