//
//  NewMissionAddMissionViewController.h
//  launcher
//
//  Created by jasonwang on 16/2/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//   新建任务界面

#import "BaseViewController.h"
#import "NewMissionMainViewController.h"
#import "NewMissionDetailModel.h"
@class ProjectModel;

typedef void(^showTypeblock)(NSInteger, ProjectModel *);


typedef enum{
    Time_Type_Today = 0,    // 今天
    Time_Type_Tomorrow = 1, // 明天
    Time_Type_NO = 2,       // 无
}Time_Type;// 开始时间


@interface NewMissionAddMissionViewController : BaseViewController
/** 父任务showId */
@property (nonatomic, copy) NSString *parentTaskShowId;
@property (nonatomic) VCkind myVCkind;
//新建子任务
- (instancetype)initWithCreatSubMission:(NSString *)mainMissionTitel mainMissionShowID:(NSString *)mainMissionShowID mainMissionPrjectShowID:(NSString *)mainMissionPrjectShowID;
//新建主任务
- (instancetype)initWithCreatMainMission;
// 初始化 选中项目
- (void)setProjectName:(NSString *)name ShowId:(NSString *)showID;
//编辑任务
- (instancetype)initWithEditMissionWithShowID:(NSString *)showID;

- (void)setShowTypeblock:(showTypeblock)block;

- (void)setTimeType:(Time_Type)type;

@property (nonatomic, strong) showTypeblock backblock;
//从聊天界面传来的model，方便继续填写
@property(nonatomic, strong) NSMutableDictionary  *missionDict;
@end
