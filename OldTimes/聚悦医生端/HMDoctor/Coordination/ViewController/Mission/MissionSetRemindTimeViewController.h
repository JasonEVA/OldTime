//
//  MissionSetRemindTimeViewController.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/14.
//  Copyright © 2016年 yinquan. All rights reserved.
//  选择提醒时间

#import "HMBaseViewController.h"
typedef void (^MissionSetRemindTimeViewControllerBlock)(MissionTaskRemindType remindType);

@interface MissionSetRemindTimeViewController : HMBaseViewController
- (void)remineTimeDidSelect:(MissionSetRemindTimeViewControllerBlock)selectBlock;
@end
