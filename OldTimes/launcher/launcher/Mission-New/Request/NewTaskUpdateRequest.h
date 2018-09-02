//
//  NewTaskUpdateRequest.h
//  launcher
//
//  Created by TabLiu on 16/2/21.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"
#import "NewMissionDetailModel.h"

@interface NewTaskUpdateRequest : BaseRequest

@property (nonatomic,strong) NSString  *    showId;   // 任务显示id  必填
@property (nonatomic,strong) NSString  *    pShowId;  //项目显示ID  必填
@property (nonatomic,strong) NSString  *    tTitle;// 任务标题  必填
@property (nonatomic,strong) NSString  *    tContent;//  任务内容 选填
@property (nonatomic,assign) long long      tStartTime;// 任务开始时间 选填
@property (nonatomic,assign) long long      tEndTime;//   任务结束时间 选填
@property (nonatomic,assign) int            isStartTimeAllDay;// 开始时间是否全天 选填，1=是，0=否，默认0
@property (nonatomic,assign) int            isEndTimeAllDay;// 结束时间是否全天 选填，1=是，0=否，默认0
@property (nonatomic,strong) NSString  *    tUser;//      任务参与者 必填
@property (nonatomic,strong) NSString  *    tUserName;//      任务参与者 必填
@property (nonatomic,strong) NSString  *    tPriority;//  任务优先级 必填 NONE=无,LOW=低,MEDIUM=中,HIGH=高，默认为NON
@property (nonatomic,assign) int            tRemindType;// 提醒类型 选填，0:不提醒,
//全天：100:5分钟前,101:10分钟前, 102:15分钟前,103:半小时前,104:一小时前,105:两小时前.106:当天.107:两天前,108:一星期前，默认0
//非全天：200:当天,201:一天前,202:两天前,203:一星期前，默认0
@property (nonatomic,strong) NSArray *      fileShowIds ;// 附件showId集合 选填
- (void)editTaskModel:(NewMissionDetailModel *)detailModel editDitionary:(NSDictionary *)editDict;
@end


@interface NewTaskUpdateResponse : BaseResponse

@end