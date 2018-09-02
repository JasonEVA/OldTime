//
//  MissionSingleSelectViewController.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/25.
//  Copyright © 2016年 yinquan. All rights reserved.
//  新建任务 选人VC

#import "HMBaseViewController.h"

@class ServiceGroupMemberModel;

typedef void(^SelectPeopleHandler)(NSArray *selectedPeople, NSString *teamIDs);

@interface MissionSingleSelectViewController : HMBaseViewController

@property (nonatomic, copy)  NSString  *staffID; // <##>

- (instancetype)initWithSelectedPeople:(NSArray *)selectedPeople patientSelect:(BOOL)patientSelect;

- (void)addSelectedPeopleNoti:(SelectPeopleHandler)completionHandler;
@end
