//
//  NewCalendarWeeksEventRequest.h
//  launcher
//
//  Created by TabLiu on 16/3/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
//  获取日程列表

#import "BaseRequest.h"

typedef enum{
    Request_Type_INIT = 0,
    Request_Type_NEXT = 1,
    Request_Type_ON = 2,
}Request_Type;

@interface NewCalendarWeeksEventRequest : BaseRequest

@property (nonatomic,assign) Request_Type requestType;
- (void)eventListWithStartDate:(NSDate *)start endDate:(NSDate *)endDate userLoginName:(NSString *)loginName;

@end

@interface NewCalendarWeeksEventResponse : BaseResponse

@property (nonatomic,strong) NSMutableArray * dataArray;

@end

