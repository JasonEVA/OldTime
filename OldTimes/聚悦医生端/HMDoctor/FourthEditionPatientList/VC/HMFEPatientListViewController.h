//
//  HMFEPatientListViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2017/10/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//  第四版患者列表😓 （收费套餐，收费单项，免费患者公用）

#import "HMBasePageViewController.h"
#import "HMFEPatientListEnum.h"

@interface HMFEPatientListViewController : HMBasePageViewController
- (instancetype)initWithType:(HMFEPatientListViewType)type;

@end
