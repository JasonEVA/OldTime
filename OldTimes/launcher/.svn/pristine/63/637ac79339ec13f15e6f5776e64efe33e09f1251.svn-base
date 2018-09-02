//
//  NewMissionDetailBaseModel.h
//  launcher
//
//  Created by jasonwang on 16/2/19.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarLaunchrModel.h"
#import "ProjectSearchDefine.h"

@interface NewMissionDetailBaseModel : NSObject
@property (nonatomic,strong) NSString * showId;         // 任务显示ID
@property (nonatomic,strong) NSString * title ;         // 任务标题
@property (nonatomic,assign) long long  startTime ;       // 任务开始时间
@property (nonatomic,assign) long long  endTime ;       // 任务结束时间
@property (nonatomic,strong) NSString *  userName ;     // 任务参与者
@property (nonatomic,strong) NSString *  userTrueName ; // 任务参与者真实姓名
@property (nonatomic) MissionTaskPriority   priority ;     // 任务优先级,NONE=无,LOW=低,MEDIUM=中,HIGH=高
@property (nonatomic) calendar_remindType remindType;             // 提醒类型  0:不提醒,
//全天：100:5分钟前,101:10分钟前, 102:15分钟前,103:半小时前,104:一小时前,105:两小时前.106:当天.107:两天前,108:一星期前
//非全天：200:当天,201:一天前,202:两天前,203:一星期前

@property (nonatomic,assign) long long  remindTime ;       // 提醒时间
@property (nonatomic,assign) int  isComment ;           // 是否有评论,0=没有,1=有
@property (nonatomic,assign) int  isAnnex ;             // 是否有附件,0=没有,1=有
@property (nonatomic) whiteBoardStyle  type ;         // 状态类型,WAITING=待办,FINISH=完成
@property (nonatomic,strong) NSString *  createUser ;  // 创建人
@property (nonatomic,strong) NSString *  createUserName ;  // 创建人姓名
@property (nonatomic,assign) int   isStartTimeAllDay ;    // 任务开始时间是否是全天,1=全天,0=非全天
@property (nonatomic,assign) int   isEndTimeAllDay ;    // 任务结束时间是否是全天,1=全天,0=非全天
/** 附件 */
@property (nonatomic, strong) NSMutableArray *attachMentArray;
/** 分配人员 */
@property (nonatomic, strong) NSMutableArray *personArray;
- (id)initWithDic:(NSDictionary *)dic;
@end
