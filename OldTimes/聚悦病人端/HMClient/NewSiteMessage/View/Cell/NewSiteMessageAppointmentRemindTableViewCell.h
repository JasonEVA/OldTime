//
//  NewSiteMessageAppointmentRemindTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2016/11/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//  约诊提醒cell

#import <UIKit/UIKit.h>
#import "SiteMessageLastMsgModel.h"

@class NewSiteMessageHealthPlanModel;
@interface NewSiteMessageAppointmentRemindTableViewCell : UITableViewCell

// 健康计划数据源方法
- (void)fillHealthPlanDataWithModel:(SiteMessageLastMsgModel *)model;
// 健康报告数据源方法
- (void)fillHealReportWithModel:(SiteMessageLastMsgModel *)model;

// 健康评估数据源方法
- (void)fillAssessWithModel:(SiteMessageLastMsgModel *)model;

// 约诊数据源方法
- (void)fillAppointWithModel:(SiteMessageLastMsgModel *)model;
@end
