//
//  ATModuleInteractor+MissionInteractor.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/2.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ATModuleInteractor.h"

@class MissionDetailModel;
@class TaskTypeTitleAndCountModel;
@class NewMissionGroupModel;

typedef void (^MissionInteractorBlock)(MissionTaskRemindType remindType);
typedef void(^SelectPeopleHandler)(NSArray *selectedPeople,NSString *teamIDs);

@interface ATModuleInteractor (MissionInteractor)

// 新建任务
- (void)goToAddNewMissionVC;

// 新建草稿
- (void)goToNewDraftMissionVCWithData:(MissionDetailModel *)model;

//任务详情
- (void)goToMissionDetailVCWithModel:(MissionDetailModel *)model;
//从任务列表进入详情页
- (void)goToMissionDetailVCFromModelID:(MissionDetailModel *)model;
- (void)goToMissionMainListVC;

- (void)goToSelectRemineTimeVCWithRemindType:(MissionInteractorBlock)seleceBlock;

//新建任务 选择参与人
- (void)goToSelectParticipatorVCWithSelectedPeople:(NSArray *)selectedPeople completionSelectedPeople:(SelectPeopleHandler)completionHandler;

// 新建任务 选择患者
- (void)goToSelectPatientVCWithSelectedPeople:(NSArray *)selectedPeople staffID:(NSString *)staffID completionSelectedPeople:(SelectPeopleHandler)completionHandler;

//编辑任务
- (void)goToEditMissionWithModel:(MissionDetailModel *)model;
//跳转任务分类页（清单）
- (void)goToMissionTypeListVC;
//第二版任务列表跳转-通过类型
- (void)goToNewMissionMainListVCWithModel:(TaskTypeTitleAndCountModel *)model;
//第二版任务列表跳转-通过服务群
- (void)goToMissionMainListWithTeamModel:(NewMissionGroupModel *)model;
//第二版任务跳转团队成员列表
- (void)goToTeamMemberListVCWithTeamID:(NSString *)teamID;
@end
