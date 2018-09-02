//
//  NewCalendarWeeksListModel.m
//  launcher
//
//  Created by TabLiu on 16/3/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarWeeksListModel.h"
#import "DateTools.h"
#import "NewCalendarWeeksModel.h"
#import "MyDefine.h"
#import "NSDate+MsgManager.h"

@interface NewCalendarWeeksListModel ()

@property (nonatomic,strong) NSMutableDictionary * weeksStrDic ;

@end

@implementation NewCalendarWeeksListModel

- (id)init
{
    self = [super init];
    if (self) {
        _calendarArray = [NSMutableArray array];
        _allDayArray = [NSMutableArray array];
        _notAllDayArray = [NSMutableArray array];
    }
    return self;
}

- (void)setDayAndWeek
{
    self.NO_Day = [NSString stringWithFormat:@"%ld",self.srartTime.day];
    self.NO_Weeks = [self.weeksStrDic objectForKey:[NSString stringWithFormat:@"%ld",self.srartTime.weekday - 1]];
}

- (void)addModel:(id)model
{
    NewCalendarWeeksModel * model1 = (NewCalendarWeeksModel *)model;
    if (model1.isAllDay) {
        [self.allDayArray addObject:model];
    }else {
        [self.notAllDayArray addObject:model];
    }
}
- (void)calendarRank
{
    
    if (self.allDayArray.count) {
        [self.calendarArray addObjectsFromArray:[self rank:self.allDayArray]];
    }
    if (self.notAllDayArray.count) {
        [self.calendarArray addObjectsFromArray:[self rank:self.notAllDayArray]];
    }
}
- (NSMutableArray *)rank:(NSMutableArray *)array
{
    NSInteger num = [array count];
    for(int i = 0 ; i < num-1 ; i++)
    {
        for(int j = i +1; j < num ; j++)
        {
            NewCalendarWeeksModel * model1 = [array objectAtIndex:i];
            NewCalendarWeeksModel * model2 = [array objectAtIndex:j];
            if (model1.startTime > model2.startTime) { // 1 的开始时间晚于2的,把2排到前面
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    return array;
}


- (NSMutableDictionary *)weeksStrDic
{
    if (!_weeksStrDic) {
        _weeksStrDic = [NSMutableDictionary dictionary];
        [_weeksStrDic setValue:LOCAL(CALENDAR_SCHEDULEBYWEEK_MONDAY) forKey:[NSString stringWithFormat:@"%d",1]];
        [_weeksStrDic setValue:LOCAL(CALENDAR_SCHEDULEBYWEEK_TUESTDAY) forKey:[NSString stringWithFormat:@"%d",2]];
        [_weeksStrDic setValue:LOCAL(CALENDAR_SCHEDULEBYWEEK_WEDNESDAY) forKey:[NSString stringWithFormat:@"%d",3]];
        [_weeksStrDic setValue:LOCAL(CALENDAR_SCHEDULEBYWEEK_THURSDAY) forKey:[NSString stringWithFormat:@"%d",4]];
        [_weeksStrDic setValue:LOCAL(CALENDAR_SCHEDULEBYWEEK_FRIDAY) forKey:[NSString stringWithFormat:@"%d",5]];
        [_weeksStrDic setValue:LOCAL(CALENDAR_SCHEDULEBYWEEK_SATURDAY) forKey:[NSString stringWithFormat:@"%d",6]];
        [_weeksStrDic setValue:LOCAL(CALENDAR_SCHEDULEBYWEEK_SUNDAY) forKey:[NSString stringWithFormat:@"%d",0]];
    }
    return _weeksStrDic;
}

- (NSString *)strDate
{
    return [NSDate calendarFormaterWithTimeIntervalWith:[self.endTime timeIntervalSince1970] * 1000];
//    return [self strWithDate:self.endTime];
}
- (NSString *)strWithDate:(NSDate *)date
{
    NSString * year = [NSString stringWithFormat:@"%ld年",(long)date.year];
    NSString * month = [NSString stringWithFormat:@"%ld月",(long)date.month];
    NSString * day = [NSString stringWithFormat:@"%ld日",(long)date.day];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"] forKeys:@[@2,@3,@4,@5,@6,@7,@1]];
    NSString * week = [NSString stringWithFormat:@"%@",[dict objectForKey:@(date.weekday)]];
//    NSString * week = [NSString stringWithFormat:@"星期%ld",date.weekday];
    return [NSString stringWithFormat:@"%@%@%@%@",year,month,day,week];
}


@end
