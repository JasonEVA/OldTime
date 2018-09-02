//
//  NewSiteMessageItemListAdapater.h
//  HMClient
//
//  Created by jasonwang on 2016/10/31.
//  Copyright © 2016年 YinQ. All rights reserved.
//  新版站内信各项目adapater

#import "ATTableViewAdapter.h"
#import "NewSiteMessageMonitorRemindedTableViewCell.h"
#import "NewSiteMessageAllMonitorRemindedTableViewCell.h"
#import "NewSiteMessageTemindReviewTableViewCell.h"
#import "NewSiteMessageMedicationRemindTableViewCell.h"
#import "NewSiteMessageAppointmentRemindTableViewCell.h"
#import "NewSiteMessageSystemTableViewCell.h"
#import "NewSiteMessageTextTableViewCell.h"
#import "NewSiteMessageRoundsTableViewCell.h"
#import "NewSiteMessageLeftImageTableViewCell.h"
#import "NewChatLeftVoiceTableViewCell.h"
#import "NewSiteMessageDoctorCareTableViewCell.h"
#import "NewSiteMessageHealthClassTableViewCell.h"

#import "NewSiteMessageMonitorRemindModel.h"
#import "NewSiteMessageAllMonitorRemindModel.h"
#import "NewSiteMessageTemindReviewModel.h"
#import "NewSiteMessageMedicationRemindModel.h"
#import "NewSiteMessageAppointmentRemindModel.h"
#import "NewSiteMessageSystemModel.h"
#import "NewSiteMessageHealthPlanModel.h"
#import "NewSiteMessageDoctorCareModel.h"
#import "SiteMessageLastMsgModel.h"
#import "NewSiteMessageHealthReportModel.h"
#import "NewSiteMessageDoctorConcernModel.h"
#import "NewSiteMessageAssessModel.h"
#import "NewSiteMessageAppointmentRemindModel.h"
#import "NewSiteMessageHealthClassModel.h"

#import "AudioPlayHelper.h"
#import "NewSiteMessageMessageTypeENUM.h"
#import "NewSiteSystemTableViewCell.h"
#import "NewSiteMessageCheackModel.h"
#import "NewSiteMessageVisitTableViewCell.h"

typedef NS_ENUM(NSUInteger, newSiteMessageType) {
    
    NewSiteMessageMonitorRemindType,
    
    NewSiteMessageAllMonitorRemindType,
    
    ZOCMachineStateRunning,
    
    ZOCMachineStatePaused
};

typedef void(^AlterClickImage)(NSArray *imageArr,NSInteger selectIndex);

@interface NewSiteMessageItemListAdapater : ATTableViewAdapter
@property (nonatomic, strong) AudioPlayHelper *player;
@property (nonatomic, strong) id lastCell;

- (void)collectImageClick:(AlterClickImage)block;
@end
