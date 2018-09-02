//
//  TaskListModel.h
//  launcher
//
//  Created by TabLiu on 16/2/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NONE_NEW    @"NONE"
#define LOW_NEW     @"LOW"
#define MEDIUM_NEW  @"MEDIUM"
#define HIGH_NEW    @"HIGH"
#define WAITING_NEW @"WAITING"
#define FINISH_NEW  @"FINISH"

@interface TaskListModel : NSObject

@property (nonatomic,strong) NSString * showId;         // 任务显示ID
@property (nonatomic,strong) NSString * title ;         // 任务标题
@property (nonatomic,assign) long long  endTime ;       // 任务结束时间
@property (nonatomic, assign) long long startTime;
@property (nonatomic, assign) int isStartTimeAllDay;
@property (nonatomic,assign) int   isEndTimeAllDay ;    // 任务结束时间是否是全天,1=全天,0=非全天
@property (nonatomic,strong) NSString *  userName ;     // 任务参与者
@property (nonatomic,strong) NSString *  userTrueName ; // 任务参与者真实姓名
@property (nonatomic,strong) NSString *  priority ;     // 任务优先级,NONE=无,LOW=低,MEDIUM=中,HIGH=高
@property (nonatomic,strong) NSString *  type ;         // 状态类型,WAITING=待办,FINISH=完成
@property (nonatomic,assign) int  isAnnex ;             // 是否有附件,0=没有,1=有
@property (nonatomic,assign) int  isComment ;           // 是否有评论,0=没有,1=有
@property (nonatomic,assign) int  level ;               // 任务层级,从1开始,1=根任务,2=子任务
@property (nonatomic,strong) NSString *  parentTaskId ; // 父任务显示ID
@property (nonatomic,strong) NSString *  projectId ;    // 项目显示ID
@property (nonatomic,strong) NSString *  projectName ;  // 项目名称
@property (nonatomic,assign) int  finishedTask ;        // 该任务下已完成的任务
@property (nonatomic,assign) int  allTask ;             // 该任务下所有的任务

@property (nonatomic,assign) BOOL notNeedDisplacement;   // 是否需要偏移
@property (nonatomic,assign) BOOL isOpen ;

- (id)initWithDic:(NSDictionary *)dic;
- (BOOL)hasSameParentWithTask:(TaskListModel *)task;
- (BOOL)isChildOfTask:(TaskListModel *)task;
- (BOOL)hasParentTask;
@end
