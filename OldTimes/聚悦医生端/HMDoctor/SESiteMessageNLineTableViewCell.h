//
//  SESiteMessageNLineTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2017/9/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//  第二版站内信N行cell

#import <UIKit/UIKit.h>
@class SiteMessageLastMsgModel;

@interface SESiteMessageNLineTableViewCell : UITableViewCell

// 约诊数据源方法
- (void)fillAppointmentDataWithModel:(SiteMessageLastMsgModel *)model;

// 用户入组数据源方法
- (void)fillServiceOrderDataWithModel:(SiteMessageLastMsgModel *)model;

// 健康计划数据源方法
- (void)fillHealthPlanDataWithModel:(SiteMessageLastMsgModel *)model;

// 建档评估数据源方法
- (void)fillEvaluationDataWithModel:(SiteMessageLastMsgModel *)model;

// 用药建议数据源方法
- (void)fillMedicineSuggestedDataWithModel:(SiteMessageLastMsgModel *)model;

@end
