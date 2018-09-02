//
//  NewCalendarWeeksModel.h
//  launcher
//
//  Created by TabLiu on 16/3/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
//  日程的相关信息

#import <Foundation/Foundation.h>

@interface NewCalendarWeeksModel : NSObject

@property (nonatomic,strong) NSString * createUser ;  // 创建人用户名
@property (nonatomic,strong) NSString * createUserName ; // 创建人真实姓名
@property (nonatomic,assign) long long  endTime;   // 结束时间
@property (nonatomic,assign) int  isAllDay;        // 是否是整天
@property (nonatomic,assign) BOOL isAllowSearch ;  // 是否允许搜索
@property (nonatomic,assign) int  isCancel;        // 是否取消,0=否,1=是,2=全部(默认)
@property (nonatomic,assign) int  isImportant ;    // 是否重要日程,0=否,1=是
@property (nonatomic,assign) BOOL  isVisible ;      // 是否仅自己可见
@property (nonatomic,strong) NSString * laty ;     // 纬度
@property (nonatomic,strong) NSString * lngx ;     // 经度
@property (nonatomic,strong) NSString * place ;    // 地点
@property (nonatomic,strong) NSString * relateId ; // 关联ID,如日程关联的会议ID
@property (nonatomic,assign) int  repeatType      ;//
@property (nonatomic,strong) NSString * showId ;   // 日程ID
@property (nonatomic,strong) NSString * type ;     // event=事件,event_sure=待定事件,meeting=会议 company_festival (公司)节假日 statutory_festival 法定节假日
@property (nonatomic,strong) NSString * title ;    // 日程标题
@property (nonatomic,assign) long long  startTime; // 开始时间

/** 自行添加的参数,与服务器无关 : 当非全天,切跨天时 值为YES,当全天处理 */
@property (nonatomic,assign) BOOL pretendIsAllDay;
@property (nonatomic,assign) long long scheduleDuration;

- (id)initWithDIC:(NSDictionary *)dic;


@end
