//
//  ApplyGetReceiveListModel.m
//  launcher
//
//  Created by Dee on 15/9/6.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyGetReceiveListModel.h"
#import "NSDictionary+SafeManager.h"
#import "UnifiedUserInfoManager.h"
#import "JSONKitUtil.h"
#import <DateTools.h>
#import "NSDate+String.h"

static NSString* const showId              = @"SHOW_ID";
static NSString* const A_Title             = @"A_TITLE";
static NSString* const T_Show_Id           = @"T_SHOW_ID";
static NSString* const T_Name             = @"T_NAME";
static NSString* const A_Approve           = @"A_APPROVE";
static NSString* const A_ApproveName       = @"A_APPROVE_NAME";
static NSString* const A_CC                = @"A_CC";
static NSString* const A_CC_name           = @"A_CC_NAME";
static NSString* const C                   = @"c";
static NSString* const A_Approve_path      = @"A_APPROVE_PATH";
static NSString* const A_Approve_path_name = @"A_APPROVE_PATH_NAME";
static NSString* const A_Is_Urgent         = @"A_IS_URGENT";
static NSString* const A_Backup            = @"A_BACKUP";
static NSString* const A_Status            = @"A_STATUS";
static NSString* const Last_Update_time    = @"LAST_UPDATE_TIME";
static NSString* const A_Start_time        = @"A_START_TIME";
static NSString* const A_End_time          = @"A_END_TIME";
static NSString* const A_Deadline          = @"A_DEADLINE";
static NSString* const A_Fee               = @"A_FEE";
static NSString* const Create_user         = @"CREATE_USER";
static NSString* const Create_user_name    = @"CREATE_USER_NAME";
static NSString* const Create_Time         = @"CREATE_TIME";
static NSString* const Is_Process          = @"IS_PROCESS";
static NSString* const IS_TIMESLOT_ALL_DAY = @"IS_TIMESLOT_ALL_DAY";
static NSString* const IS_DEADLINE_ALL_DAY = @"IS_DEADLINE_ALL_DAY";
static NSString* const IS_CAN_APPROVE      = @"IS_CAN_APPROVE";
static NSString* const IS_CAN_MODIFY       = @"IS_CAN_MODIFY";
static NSString* const IS_CAN_DELETE       = @"IS_CAN_DELETE";
static NSString* const IS_HAVEFILE         = @"HAS_FILE";
static NSString* const IS_HAVECOMMENT      = @"HAS_COMMENT";

static NSString* const HAS_COMMENT = @"HAS_COMMENT";

static NSString* const USER_NAME = @"USER_NAME";
static NSString* const USER      = @"USER";
static NSString *const A_APPROVE = @"A_APPROVE";

static NSString *const A_readStatus = @"readStatus";
static NSString *const aDeadLineKey = @"key4";
static NSString *const aDefaultKey = @"key";

@implementation ApplyGetReceiveListModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        //数值类型需要转换
        self.SHOW_ID             = [dict valueStringForKey:showId];
        self.A_TITLE             = [dict valueStringForKey:A_Title];
        self.T_SHOW_ID           = [dict valueStringForKey:T_Show_Id];
        self.T_NAME              = [dict valueStringForKey:T_Name];
        self.A_APPROVE           = [dict valueStringForKey:A_Approve];
        self.A_APPROVE_NAME      = [dict valueStringForKey:A_ApproveName];
        self.A_CC                = [dict valueStringForKey:A_CC];
        self.A_CC_NAME           = [dict valueStringForKey:A_CC_name];
        self.C                   = [dict valueStringForKey:C];
        self.A_APPROVE_PATH      = [dict valueStringForKey:A_Approve_path];
        self.A_APPROVE_PATH_NAME = [dict valueStringForKey:A_Approve_path_name];
        self.A_IS_URGENT         = [[dict valueNumberForKey:A_Is_Urgent] integerValue];
        self.A_BACKUP            = [dict valueStringForKey:A_Backup];
        self.A_STATUS            = [dict valueStringForKey:A_Status];
        self.LAST_UPDATE_TIME    = [[dict valueNumberForKey:Last_Update_time] longLongValue];
        self.A_START_TIME        = [[dict valueNumberForKey:A_Start_time] longLongValue];
        self.A_END_TIME          = [[dict valueNumberForKey:A_End_time] longLongValue];

        self.A_FEE               = [[dict valueNumberForKey:A_Fee] doubleValue];
        self.CREATE_USER         = [dict valueStringForKey:Create_user];
        self.CREATE_USER_NAME    = [dict valueStringForKey:Create_user_name];
        self.CREATE_TIME         = [[dict valueNumberForKey:Create_Time] longLongValue];
        self.IS_PROCESS          = [[dict valueNumberForKey:Is_Process] integerValue];
        self.IS_TIMESLOT_ALL_DAY = [[dict valueNumberForKey:IS_TIMESLOT_ALL_DAY] integerValue];
        self.IS_CAN_APPROVE      = [[dict valueNumberForKey:IS_CAN_APPROVE] intValue];
        self.IS_CAN_MODIFY       = [[dict valueNumberForKey:IS_CAN_MODIFY] intValue];
        self.IS_CAN_DELETE       = [[dict valueNumberForKey:IS_CAN_DELETE] intValue];
        self.IS_HAVEFILE         = [[dict valueNumberForKey:IS_HAVEFILE] intValue];
        self.IS_HAVECOMMENT      = [[dict valueNumberForKey:IS_HAVECOMMENT] intValue];
        self.HAS_COMMENT         = [[dict valueNumberForKey:HAS_COMMENT] intValue];
        self.Unreadmsg = NO;
        
        self.T_WORKFLOW_ID      = [dict valueStringForKey:@"T_WORKFLOW_ID"];
        self.A_APPROVE_TRIGGERS = [dict valueArrayForKey:@"A_APPROVE_TRIGGERS"];
        self.A_FORM_DATA        = [dict valueStringForKey:@"A_FORM_DATA"];
		if (dict[A_Deadline]) {
			self.A_DEADLINE = [[dict valueNumberForKey:A_Deadline] longLongValue];
		} else {
			self.A_DEADLINE = [self getDeadLineValueWithFormData:self.A_FORM_DATA];
		}
		
		if (dict[IS_DEADLINE_ALL_DAY]) {
			self.IS_DEADLINE_ALL_DAY = [[dict valueNumberForKey:IS_DEADLINE_ALL_DAY] intValue];
		} else {
			self.IS_DEADLINE_ALL_DAY = [self getIsDeadLineAllDayWithDeadLineTime:self.A_DEADLINE];
		}
		
//		if (self.A_DEADLINE != 0) {
//			NSLog(@"%@- %ld-%@", self.A_TITLE, self.IS_DEADLINE_ALL_DAY, [NSDate dateWithTimeIntervalSince1970:self.A_DEADLINE/1000]);
//		}
		
        if ([self.CREATE_USER isEqualToString:[[UnifiedUserInfoManager share] userShowID]]) {
            self.apply_type = applytype_out;
        }
        else {
            NSRange range = [self.A_CC rangeOfString:[[UnifiedUserInfoManager share] userShowID]];
            if (range.location != NSNotFound) {
                self.apply_type = applytype_cc;
            }
        }
        
        if (self.apply_type == applytype_in) {
            if ([self.A_STATUS isEqualToString:@"IN_PROGRESS"] || [self.A_STATUS isEqualToString:@"WAITING"]) {
                self.ShowRightbtns = YES;
            }            
        }
    }
    return self;
}

#pragma mark - Interface Method
- (NSString *)getFormattedCreatTime
{
	if (self.CREATE_TIME <= 0) {
		return @"";
	}
	
	NSString *str = @"";
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.CREATE_TIME/1000];
	NSDate *today = [NSDate date];
	
	
	if (date.year == today.year && date.month == today.month && date.day == today.day)
	{
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"HH:mm"];
		//        str = [NSString stringWithFormat:@"%@%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY),[df stringFromDate:date]];
		str = [NSString stringWithFormat:@"%@",[df stringFromDate:date]];
	}
	else
	{
		str = [NSString stringWithFormat:@"%ld/%ld",date.month,date.day];
	}

	if ([str hasPrefix:@"1970"]) {
		str = @"";
	}
	return str;
}

- (NSString *)getFormattedDeadLineTime
{
	if (self.A_DEADLINE <= 0) {
		return @"";
	}
	
	BOOL isAllDay = (BOOL)self.IS_DEADLINE_ALL_DAY;
	long long time = self.A_DEADLINE;
	
	NSString *str;
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
	NSDate *today = [NSDate date];
	
	NSArray *arr = [[NSArray alloc] initWithObjects:LOCAL(CALENDAR_SCHEDULEBYWEEK_SUNDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_MONDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_TUESTDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_WEDNESDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_THURSDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_FRIDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_SATURDAY),nil];
	
	if (date.year == today.year && date.month == today.month && date.day == today.day)
	{
		
		str = [NSString stringWithFormat:@"%@%@%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY), isAllDay ? @"" : date.getClockTime, LOCAL(APPLY_DEADLINE_INFO)];
	}
	else if (date.year == today.year)
	{
		
		str = [NSString stringWithFormat:@"%ld/%ld(%@)%@",date.month,date.day,[arr objectAtIndex:date.weekday -1], isAllDay ? @"" : date.getClockTime];
	}
	else
	{
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		if (isAllDay) {
			[df setDateFormat:@"yyyy/MM/dd"];
		} else {
			[df setDateFormat:@"yyyy/MM/dd HH:mm"];
		}
		
		str = [NSString stringWithFormat:@"%@", [df stringFromDate:date]];
	}
	if ([str hasPrefix:@"1970"]) {
		str = @"";
	}
	return str;
}

#pragma mark - Private Method
- (BOOL)getIsDeadLineAllDayWithDeadLineTime:(long long)deadLine {
	if (!deadLine) {
		return NO;
	}
	
	NSDate *deadLineDate = [NSDate dateWithTimeIntervalSince1970:deadLine];
	return (deadLineDate.hour == 0 && deadLineDate.minute == 0 && deadLineDate.second == 0);
	
}

/**
 *  兼容旧数据,从表单中获取deadlineTime
 */
- (long long)getDeadLineValueWithFormData:(NSString *)formData {
	NSArray *dictArray = [formData mtc_objectFromJSONString];
	__block long long result = 0;
	
	[dictArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([dict[aDefaultKey] isEqualToString:aDeadLineKey]) {
			id deadLineValue = dict[@"value"];
			if (deadLineValue) {
				if ([deadLineValue isKindOfClass:[NSString class]]) {
//					NSLog(@"%s,%@", __FUNCTION__, deadLineValue);
				}
				
				if ([deadLineValue isKindOfClass:[NSDictionary class]]) {
					result = [deadLineValue[@"deadline"] longLongValue];
					*stop = YES;
				}
			}
		}
	}];
	
	return result;	
}

- (NSString *)getNameFormDic:(NSDictionary *)dict withKey:(NSString *)key isName:(BOOL)isname;
{
    NSArray *TempArr = [dict valueArrayForKey:key];
    NSString *tempStr = nil;
    NSString *name = nil;
    NSMutableArray *contentArr = [NSMutableArray array];
    for (NSDictionary *dic in TempArr)
    {
        if (isname) name = [dic objectForKey:USER_NAME];
        if (!isname) name = [dic objectForKey:USER];
        [contentArr addObject:name];
    }
    tempStr = [self appendStrWithArr:contentArr];
    return tempStr;
}

- (NSString *)appendStrWithArr:(NSArray *)arr
{
    NSString *tempStr = @"";
    NSInteger i = 0;
    for (NSString *str in arr)
    {
        tempStr = [tempStr stringByAppendingString:str];
        if (i != arr.count - 1)
        {
            tempStr = [tempStr stringByAppendingString:@"●"];
        }
        i++;
    }
    return tempStr;
}
@end
