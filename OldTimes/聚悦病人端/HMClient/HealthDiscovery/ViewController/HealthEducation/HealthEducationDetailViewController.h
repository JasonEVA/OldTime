//
//  HealthEducationDetailViewController.h
//  HMClient
//
//  Created by yinquan on 16/12/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMBasePageViewController.h"

@class IMNewsModel;

@interface HealthEducationDetailViewController : HMBasePageViewController

//通过IM消息卡片进入详情
- (instancetype)initWithNewsModel:(IMNewsModel *)model;
//从推送进入详情
- (instancetype)initWithNotsID:(NSString *)notsID;

@end
