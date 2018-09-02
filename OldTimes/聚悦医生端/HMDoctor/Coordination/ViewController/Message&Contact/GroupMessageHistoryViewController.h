//
//  GroupMessageHistoryViewController.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/27.
//  Copyright © 2016年 yinquan. All rights reserved.
//  群消息记录VC

#import "HMBasePageViewController.h"

@interface GroupMessageHistoryViewController : HMBasePageViewController
- (instancetype)initWithGroupId:(NSString *)groupId;
- (instancetype)initWithGroupId:(NSString *)groupId patientUid:(NSString *)patientUid;
@end
