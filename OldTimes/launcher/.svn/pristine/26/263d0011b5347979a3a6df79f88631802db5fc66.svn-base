//
//  NewMissionDetailModel.h
//  launcher
//
//  Created by jasonwang on 16/2/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//   任务详情model

#import <Foundation/Foundation.h>
#import "NewMissionDetailBaseModel.h"
@interface NewMissionDetailModel :  NewMissionDetailBaseModel

@property (nonatomic,strong) NSString *  projectId ;    // 项目显示ID
@property (nonatomic,strong) NSString * content ;         // 任务内容
@property (nonatomic,strong) NSString *  parentTaskId ; // 父任务显示ID
@property (nonatomic,assign) int  level ;               // 任务层级,从1开始,1=根任务,2=子任务
@property (nonatomic,assign) long long  lastUpdateTime ;       // 上次更新时间
@property (nonatomic,strong) NSString *  projectName ;  // 项目名称

@property (nonatomic, strong) NewMissionDetailBaseModel *parentTask;   //父任务
@property (nonatomic, strong) NSMutableArray *childTasks;    //子任务集合

- (id)initWithDic:(NSDictionary *)dic;

@end
