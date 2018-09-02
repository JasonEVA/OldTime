//
//  ATModuleInteractor+MissionInteractor.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/2.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ATModuleInteractor+MissionInteractor.h"
#import "MissionAddNewMissionViewController.h"
#import "MissionDetailViewController.h"
#import "MissionMainListViewController.h"
#import "MissionSetRemindTimeViewController.h"
#import "MissionSingleSelectViewController.h"
#import "MissionDetailModel.h"
#import "MissionTypeListViewController.h"
#import "NewMissionMainListViewController.h"
#import "TaskTypeTitleAndCountModel.h"
#import "NewMissionGroupModel.h"
#import "NewMissionTeamMemberListViewController.h"

@implementation ATModuleInteractor (MissionInteractor)

// NewMission
- (void)goToAddNewMissionVC
{
    MissionAddNewMissionViewController *VC = [[MissionAddNewMissionViewController alloc]initAddNewMission];
    [self pushToVC:VC];
}

// 新建草稿
- (void)goToNewDraftMissionVCWithData:(MissionDetailModel *)model {
    MissionAddNewMissionViewController *VC = [[MissionAddNewMissionViewController alloc] initEditMissionWithModel:model];
    [self pushToVC:VC];
    
}


- (void)goToMissionDetailVCWithModel:(MissionDetailModel *)model
{
    MissionDetailViewController *VC = [[MissionDetailViewController alloc]initWithMissionModel:model];
    [self pushToVC:VC];
}

- (void)goToMissionDetailVCFromModelID:(MissionDetailModel *)model
{
    MissionDetailViewController *VC = [[MissionDetailViewController alloc] initWIthMissionID:model];
    [self pushToVC:VC];
}

// MissionMainList
- (void)goToMissionMainListVC
{
    MissionMainListViewController *VC = [MissionMainListViewController new];
    [self pushToVC:VC];
}

// AddRemindTime
- (void)goToSelectRemineTimeVCWithRemindType:(MissionInteractorBlock)seleceBlock
{
    MissionSetRemindTimeViewController *VC = [MissionSetRemindTimeViewController new];
    [VC remineTimeDidSelect:^(MissionTaskRemindType remindType) {
        seleceBlock(remindType);
    }];
    [self pushToVC:VC];
}

//选择参与人
- (void)goToSelectParticipatorVCWithSelectedPeople:(NSArray *)selectedPeople completionSelectedPeople:(SelectPeopleHandler)completionHandler
{
    MissionSingleSelectViewController *VC = [[MissionSingleSelectViewController alloc] initWithSelectedPeople:selectedPeople patientSelect:NO];
    [VC addSelectedPeopleNoti:^(NSArray *selectedPeople,NSString *teamIDs) {
        completionHandler(selectedPeople,teamIDs);
    }];
    [self pushToVC:VC];
}

//选择患者
- (void)goToSelectPatientVCWithSelectedPeople:(NSArray *)selectedPeople staffID:(NSString *)staffID completionSelectedPeople:(SelectPeopleHandler)completionHandler
{
    MissionSingleSelectViewController *VC = [[MissionSingleSelectViewController alloc] initWithSelectedPeople:selectedPeople patientSelect:YES];
    VC.staffID = staffID;
    [VC addSelectedPeopleNoti:^(NSArray *selectedPeople,NSString *teamIDs) {
        completionHandler(selectedPeople,teamIDs);
    }];
    [self pushToVC:VC];
}

//编辑任务
- (void)goToEditMissionWithModel:(MissionDetailModel *)model
{
    MissionAddNewMissionViewController *VC = [[MissionAddNewMissionViewController alloc]initEditMissionWithModel:model];
    [self pushToVC:VC];
    
}

- (void)goToMissionTypeListVC {
    MissionTypeListViewController *VC = [MissionTypeListViewController new];
    [self pushToVC:VC];
}
- (void)goToNewMissionMainListVCWithModel:(TaskTypeTitleAndCountModel *)model {
    NewMissionMainListViewController *VC = [[NewMissionMainListViewController alloc] initWithTypeModel:model];
    [self pushToVC:VC];
}
- (void)goToMissionMainListWithTeamModel:(NewMissionGroupModel *)model {
    NewMissionMainListViewController *VC = [[NewMissionMainListViewController alloc] initWithTeamModel:model];
    [self pushToVC:VC];
}
- (void)goToTeamMemberListVCWithTeamID:(NSString *)teamID {
    NewMissionTeamMemberListViewController *VC = [[NewMissionTeamMemberListViewController alloc] initWithTeamID:teamID];
    [self pushToVC:VC];
}
@end
