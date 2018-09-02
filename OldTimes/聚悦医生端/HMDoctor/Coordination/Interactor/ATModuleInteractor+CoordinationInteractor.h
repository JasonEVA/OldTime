//
//  ATModuleInteractor+CoordinationInteractor.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/2.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ATModuleInteractor.h"
#import "HMDoctorEnum.h"
#import "ChatIMConfigure.h"

@class SelectContactTabbarView,CoordinationDepartmentModel,DoctorCompletionInfoModel,MessageRelationGroupModel,ContactDetailModel;

@interface ATModuleInteractor (CoordinationInteractor)


// 任务列表
- (void)goTaskList;
// 弹出框具体跳转
- (void)goToAddNewMission;

// 跳转到单聊
- (void)goSingleChatVCWith:(ContactDetailModel *)detailModel chatType:(IMChatType)type;
// 跳转群聊
- (void)goToGroupChatVCWith:(ContactDetailModel *)detailModel chatType:(IMChatType)type;
// 跳转历史记录
- (void)goHistoryListWithUid:(NSString *)uid;
// 医患群跳转历史记录
- (void)goHistoryListWithUid:(NSString *)uid patientUid:(NSString *)patientUid;
// 群名片
- (void)goGroupInfoWith:(NSString *)target;
// 医生名片详情
- (void)goDoctorDetailInfoWithRelationType:(ContactRelationshipType)type model:(id)model;
// 工作圈详情
- (void)goWorkCircleInfoWithUid:(NSString *)uid;

// 创建工作圈,创建工作圈还是添加成员
- (void)goCreateWorkCircleIsCreate:(BOOL)create nonSelectableContacts:(NSArray *)array workCircleID:(NSString *)ID;

// 从群/工作圈中选择
- (void)goCreateWorkCircleFromGroupWithSelectView:(SelectContactTabbarView *)selectView nonSelectableContacts:(NSArray *)array;

// 从群成员中选择
- (void)goGroupContactMemberListWithGroupID:(NSString *)groupID selectView:(SelectContactTabbarView *)selectView nonSelectableContacts:(NSArray *)array singleSelect:(BOOL)singleSelect;

// 添加好友
- (void)goAddFriends;

// 添加好友子页面
- (void)goAddFriendsSubVCWith:(DoctorCompletionInfoModel *)model;

// 编辑分组，
- (void)gofriendsGroupingWithDataList:(NSArray *)dataList Edit:(BOOL)edit;

// 选择分组
- (void)goToSelsctfriendsGroupWithDataList:(NSArray *)dataList Edit:(BOOL)edit delegate:(id)delegate selectModel:(MessageRelationGroupModel *)model;

// 新朋友
- (void)goNewFriendWithContactDetailModel:(ContactDetailModel *)model;

//部门详情
- (void)goToDeptDetailVCWithDeptModel:(CoordinationDepartmentModel *)model;

//联系人页
- (void)goToConactsVC;
//进入健康顾问页面
- (void)goToJKGWChhatVC:(ContactDetailModel *)model list:(NSArray *)list;
//首页跳转tabbar后进入清单页
- (void)goToMissionTypeList;

@end
