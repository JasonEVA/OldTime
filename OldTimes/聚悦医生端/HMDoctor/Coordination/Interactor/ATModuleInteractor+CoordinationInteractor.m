//
//  ATModuleInteractor+CoordinationInteractor.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/2.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ATModuleInteractor+CoordinationInteractor.h"
#import "MissionAddNewMissionViewController.h"
#import "MissionMessageListViewController.h"
#import "CoordinationChatViewController.h"
#import "CreateWorkCircleViewController.h"

#import "GroupInfoViewController.h"

#import "DoctorContactDetailInfoViewController.h"
#import "WorkCircleDetailInfoViewController.h"
#import "CreateWorkCircleFromExistGroupViewController.h"
#import "AddFriendSubViewController.h"
#import "ContactGroupingManagementViewController.h"
#import "NewFriendRequestViewController.h"
#import "GroupMessageHistoryViewController.h"
#import "ChatSingleViewController.h"
#import "NewAddFriendsViewController.h"
#import "DepartmentDetailViewController.h"
#import "ContactsViewController.h"
#import "ChatGroupViewController.h"
#import "CreateWorkCircleBaseViewController.h"
#import "GroupContactMemerListViewController.h"
#import "MissionTypeListViewController.h"
@implementation ATModuleInteractor (CoordinationInteractor)

- (void)goTaskList {
    MissionMessageListViewController *VC  = [[MissionMessageListViewController alloc] init];
    [self PushToChatVC:VC];
}

- (void)goToAddNewMission
{
    MissionAddNewMissionViewController *VC = [[MissionAddNewMissionViewController alloc] initAddNewMission];
    [self pushToVC:VC];
}

- (void)goSingleChatVCWith:(ContactDetailModel *)detailModel chatType:(IMChatType)type {
    ChatSingleViewController *VC  = [[ChatSingleViewController alloc] initWithDetailModel:detailModel];
    VC.chatType = type;
    [self PushToChatVC:VC];
}

- (void)goToGroupChatVCWith:(ContactDetailModel *)detailModel chatType:(IMChatType)type
{
    ChatGroupViewController *VC  = [[ChatGroupViewController alloc] initWithDetailModel:detailModel];
    VC.chatType = type;
    [self PushToChatVC:VC];
}

- (void)goHistoryListWithUid:(NSString *)uid {
    GroupMessageHistoryViewController *VC  = [[GroupMessageHistoryViewController alloc] initWithGroupId:uid];
    [self pushToVC:VC];
}

- (void)goHistoryListWithUid:(NSString *)uid patientUid:(NSString *)patientUid{
    GroupMessageHistoryViewController *VC  = [[GroupMessageHistoryViewController alloc] initWithGroupId:uid patientUid:patientUid];
    [self pushToVC:VC];
}


- (void)goGroupInfoWith:(NSString *)target {
    GroupInfoViewController *VC = [GroupInfoViewController new];
    VC.groupID = target;
    [self pushToVC:VC];
}

// 医生名片详情
- (void)goDoctorDetailInfoWithRelationType:(ContactRelationshipType)type model:(id)model{
    DoctorContactDetailInfoViewController *VC = [[DoctorContactDetailInfoViewController alloc] initWithRelationType:type infoModel:model];
    [self pushToVC:VC];
    
}

// 工作圈详情
- (void)goWorkCircleInfoWithUid:(NSString *)uid {
    WorkCircleDetailInfoViewController *VC  = [[WorkCircleDetailInfoViewController alloc] init];
    VC.workCircleID = uid;
    [self pushToVC:VC];
    
}

// 创建工作圈,创建工作圈还是添加成员
- (void)goCreateWorkCircleIsCreate:(BOOL)create nonSelectableContacts:(NSArray *)array workCircleID:(NSString *)ID{
    CreateWorkCircleBaseViewController *VC  = [[CreateWorkCircleBaseViewController alloc] init];
    VC.create = create;
    VC.workCircleID = ID;
    VC.arrayNonSelectableContacts = array;
    [self pushToVC:VC];
}

// 从群/工作圈中创建工作圈.创建工作圈还是添加成员
- (void)goCreateWorkCircleFromGroupWithSelectView:(SelectContactTabbarView *)selectView nonSelectableContacts:(NSArray *)array  {
    CreateWorkCircleFromExistGroupViewController *VC  = [[CreateWorkCircleFromExistGroupViewController alloc] initWithSelectView:selectView nonSelectableContacts:array];
    [self pushToVC:VC];
}

// 从群成员中选择
- (void)goGroupContactMemberListWithGroupID:(NSString *)groupID selectView:(SelectContactTabbarView *)selectView nonSelectableContacts:(NSArray *)array singleSelect:(BOOL)singleSelect {
    GroupContactMemerListViewController *VC  = [[GroupContactMemerListViewController alloc] initWithGroupID:groupID selectView:selectView nonSelectableContacts:array singleSelect:singleSelect];
    [self pushToVC:VC];
}

// 添加好友
- (void)goAddFriends {
    NewAddFriendsViewController *VC  = [[NewAddFriendsViewController alloc] init];
    [self pushToVC:VC];
}

// 添加好友子页面
- (void)goAddFriendsSubVCWith:(DoctorCompletionInfoModel *)model {
    
    AddFriendSubViewController *VC  = [[AddFriendSubViewController alloc] init];
    VC.doctorInfo = model;
    [self pushToVC:VC];
}

// 编辑分组，
- (void)gofriendsGroupingWithDataList:(NSArray *)dataList Edit:(BOOL)edit {
    ContactGroupingManagementViewController *VC = [ContactGroupingManagementViewController new];
    VC.arrayData = dataList;
    VC.managementStatus = edit;
    [self pushToVC:VC];
}

// 选择分组
- (void)goToSelsctfriendsGroupWithDataList:(NSArray *)dataList Edit:(BOOL)edit delegate:(id)delegate selectModel:(MessageRelationGroupModel *)model
{
    ContactGroupingManagementViewController *VC = [ContactGroupingManagementViewController new];
    [VC setDelegate:delegate];
    [VC setSelectModel:model];
    VC.arrayData = dataList;
    VC.managementStatus = edit;
    [self pushToVC:VC];
}

// 新朋友
- (void)goNewFriendWithContactDetailModel:(ContactDetailModel *)model {
    NewFriendRequestViewController *VC  = [[NewFriendRequestViewController alloc] init];
    VC.target = model._target;
    [self pushToVC:VC];
    
}

//部门详情
- (void)goToDeptDetailVCWithDeptModel:(CoordinationDepartmentModel *)model
{
    DepartmentDetailViewController *VC = [DepartmentDetailViewController new];
    VC.deptModel = model;
    [self pushToVC:VC];
}

//联系人页
- (void)goToConactsVC
{
    ContactsViewController *VC = [ContactsViewController new];
    [self pushToVC:VC];
}
//进入健康顾问页面
- (void)goToJKGWChhatVC:(ContactDetailModel *)model list:(NSArray *)list {
    ChatSingleViewController *VC = [[ChatSingleViewController alloc] initWithDetailModel:model];
    VC.helperList = list;
    VC.isLittleHelper = YES;
    
    [self PushToChatVC:VC];
}
- (void)goToMissionTypeList {
    MissionTypeListViewController *VC = [MissionTypeListViewController new];
    [self PushToChatVC:VC];
}

@end
