//
//  SEDoctorSiteMessageItemViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2017/9/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//  第二版医生端站内信各个项目界面

#import "HMBasePageViewController.h"
@class SiteMessageSecondEditionMainListModel;
@interface SEDoctorSiteMessageItemViewController : HMBasePageViewController
- (instancetype)initWithSiteType:(SiteMessageSecondEditionMainListModel *)model;
@end
