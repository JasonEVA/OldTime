//
//  NewGetTaskListRequest.h
//  launcher
//
//  Created by TabLiu on 16/2/16.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
// 获取任务列表

#import "BaseRequest.h"

@interface NewGetTaskListRequest : BaseRequest

@property (nonatomic,strong) NSNumber * pageIndex ;// 第几页
@property (nonatomic,strong) NSNumber * pageSize ; // 选填,默认10条
@property (nonatomic,strong) NSNumber * Type ;// 任务列表类型,默认0=搜索,1=今天,2=明天,3=无开始时间,4=参与者为我所有任务,5=发送者为我的所有任务,7=项目列表
@property (nonatomic,assign) long long  time ; // 客户端当前时间(类型为1,2,4时该字段必填,类型为0的时候无效字段) 影响到类型为4的排序问题,所以需要精确到准确的时间
@property (nonatomic,strong) NSString * projectId ; // 选填
@property (nonatomic,strong) NSString * statusType ;//选填，WAITING=待办, FINISH =’已完成’

@property (nonatomic,strong) NSString * searchKey ;

- (void)search;

@property (nonatomic,assign) BOOL isSearch ;

@end

@interface NewGetTaskListResponse : BaseResponse

@property (nonatomic,strong) NSMutableArray * dataArray ;
@property (nonatomic,strong) NSMutableArray * pastArray ;

@property (nonatomic,strong) NSMutableDictionary * subtaskDict ;


@property (nonatomic,strong) NSMutableArray         *  NO_overdue_Array; // 非过期 或者 结果列表(其他)
@property (nonatomic,strong) NSMutableArray         *  overdue_Array; //过期
@property (nonatomic,strong) NSMutableDictionary    *  child_dict ; // 子任务
@property (nonatomic,assign) BOOL  needDividDueTask ;
- (void)dealWithData:(id)data;


@end
