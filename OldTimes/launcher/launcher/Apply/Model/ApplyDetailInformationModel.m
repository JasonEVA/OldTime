//
//  ApplyDetailInformationModel.m
//  launcher
//
//  Created by Conan Ma on 15/9/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyDetailInformationModel.h"
#import "ContactPersonDetailInformationModel.h"
#import "NSDictionary+SafeManager.h"
#import "NewApplyFormBaseModel.h"
#import "NewApplyFormPeopleModel.h"
#import "NewApplyFormTimeModel.h"
#import "NewApplyFormPeriodModel.h"
#import "JSONKitUtil.h"
#import <MJExtension/MJExtension.h>
#import <DateTools.h>
#import "MyDefine.h"
#import "NSDate+Date.h"
#import "NSDictionary+SafeManager.h"
static NSString* const showId       = @"SHOW_ID";
static NSString* const A_Title      = @"A_TITLE";
static NSString* const T_Show_Id    = @"T_SHOW_ID";
static NSString* const T_name       = @"T_NAME";
static NSString* const A_Approve    = @"A_APPROVE";
static NSString* const A_ApproveName   =@"A_APPROVE_NAME";
static NSString* const A_CC         = @"A_CC";
static NSString* const A_CC_name    = @"A_CC_NAME";
static NSString* const C            = @"c";
static NSString* const A_Approve_path = @"A_APPROVE_PATH";
static NSString* const A_Approve_path_name = @"A_APPROVE_PATH_NAME";
static NSString* const A_Is_Urgent  = @"A_IS_URGENT";
static NSString* const A_Backup     = @"A_BACKUP";
static NSString* const A_Status     = @"A_STATUS";
static NSString* const Last_Update_time = @"LAST_UPDATE_TIME";
static NSString* const A_Start_time = @"A_START_TIME";
static NSString* const A_End_time   = @"A_END_TIME";
static NSString* const A_Deadline   = @"A_DEADLINE";
static NSString* const A_Fee        = @"A_FEE";
static NSString* const Create_user  = @"CREATE_USER";
static NSString* const Create_user_name  = @"CREATE_USER_NAME";
static NSString* const Create_Time = @"CREATE_TIME";
static NSString* const Is_Process = @"IS_PROCESS";
static NSString* const IS_TIMESLOT_ALL_DAY = @"IS_TIMESLOT_ALL_DAY";
static NSString* const IS_DEADLINE_ALL_DAY = @"IS_DEADLINE_ALL_DAY";
static NSString* const IS_CAN_APPROVE = @"IS_CAN_APPROVE";
static NSString* const IS_CAN_MODIFY = @"IS_CAN_MODIFY";
static NSString* const IS_CAN_DELETE = @"IS_CAN_DELETE";
static NSString* const pageIndex = @"pageIndex";
static NSString* const pageSize = @"pageSize";
static NSString* const timeStamp = @"timeStamp";
static NSString* const fileShowIds = @"fileShowIds";
static NSString* const IS_HAVECOMMENT = @"HAS_COMMENT";

static NSString* const USER_NAME = @"USER_NAME";
static NSString* const USER      = @"USER";
static NSString *const A_APPROVE = @"A_APPROVE";
static NSString *const A_HAS_FILE = @"HAS_FILE";

@interface ApplyDetailInformationModel ()

@property (nonatomic, strong) NSMutableDictionary *dictTry;

@end

@implementation ApplyDetailInformationModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        //数值类型需要转换
        self.SHOW_ID             = [dict valueStringForKey:showId];
        self.A_TITLE             = [dict valueStringForKey:A_Title];
        self.T_SHOW_ID           = [dict valueStringForKey:T_Show_Id];
        self.T_NAME              = [dict valueStringForKey:T_name];
        self.A_APPROVE           = [dict valueStringForKey:A_Approve];
        self.A_APPROVE_NAME      = [dict valueStringForKey:A_ApproveName];
        self.A_CC                = [dict valueStringForKey:A_CC];
        self.A_CC_NAME           = [dict valueStringForKey:A_CC_name];
        self.C                   = [dict valueStringForKey:C];
        self.A_APPROVE_PATH      = [dict valueMutableArrayForKey:A_Approve_path];
        self.A_APPROVE_PATH_NAME = [dict valueStringForKey:A_Approve_path_name];
        self.A_IS_URGENT         = [[dict valueNumberForKey:A_Is_Urgent] integerValue];
        self.A_BACKUP            = [dict valueStringForKey:A_Backup];
        self.A_STATUS            = [dict valueStringForKey:A_Status];
        self.LAST_UPDATE_TIME    = [[dict valueNumberForKey:Last_Update_time] longLongValue];
        self.A_START_TIME        = [[dict valueNumberForKey:A_Start_time] longLongValue];
        self.A_END_TIME          = [[dict valueNumberForKey:A_End_time] longLongValue];
        self.A_DEADLINE          = [[dict valueNumberForKey:A_Deadline] longLongValue];
        self.A_FEE               = [[dict valueNumberForKey:A_Fee] doubleValue];
        self.CREATE_USER         = [dict valueStringForKey:Create_user];
        self.CREATE_USER_NAME    = [dict valueStringForKey:Create_user_name];
        self.CREATE_TIME         = [[dict valueNumberForKey:Create_Time] longLongValue];
        self.IS_PROCESS          = [[dict valueNumberForKey:Is_Process] integerValue];
        self.IS_TIMESLOT_ALL_DAY = [[dict valueNumberForKey:IS_TIMESLOT_ALL_DAY] integerValue];
        self.IS_DEADLINE_ALL_DAY = [[dict valueNumberForKey:IS_DEADLINE_ALL_DAY] integerValue];
        self.IS_CAN_APPROVE      = [[dict valueNumberForKey:IS_CAN_APPROVE] integerValue];
        self.IS_CAN_MODIFY       = [[dict valueNumberForKey:IS_CAN_MODIFY] integerValue];
        self.IS_CAN_DELETE       = [[dict valueNumberForKey:IS_CAN_DELETE] integerValue];
        self.has_files           = [[dict valueNumberForKey:A_HAS_FILE] integerValue];
        self.IS_HAVECOMMENT      = [[dict valueNumberForKey:IS_HAVECOMMENT] intValue];
        
        self.T_WORKFLOW_ID      = [dict valueStringForKey:@"T_WORKFLOW_ID"];
        self.A_APPROVE_TRIGGERS = [dict valueArrayForKey:@"A_APPROVE_TRRIGGERS"];
        self.A_FORM_INSTANCE_ID = [dict valueStringForKey:@"A_FORM_INSTANCE_ID"];
        self.A_MESSAGE_FORM     = [dict valueStringForKey:@"A_MESSAGE_FORM"];
    }
    return self;
}

- (instancetype)initWithDictEdit:(NSDictionary *)dict
{
    if (self = [super init])
    {
        //数值类型需要转换
        self.SHOW_ID             = [dict valueStringForKey:showId];
        self.A_TITLE             = [dict valueStringForKey:A_Title];
        self.T_SHOW_ID           = [dict valueStringForKey:T_Show_Id];
        self.T_NAME              = [dict valueStringForKey:T_name];
        self.A_APPROVE           = [dict valueStringForKey:A_Approve];
        self.A_CC                = [self getNameFormDic:dict withKey:A_CC isName:NO];
        self.A_CC_NAME           = [self getNameFormDic:dict withKey:A_CC isName:YES];
        self.A_APPROVE           = [self getNameFormDic:dict withKey:A_APPROVE isName:NO];
        self.A_APPROVE_NAME      = [self getNameFormDic:dict withKey:A_APPROVE isName:YES];
        self.C                   = [dict valueStringForKey:C];
        self.A_APPROVE_PATH      = [dict valueMutableArrayForKey:A_Approve_path];
        self.A_APPROVE_PATH_NAME = [dict valueStringForKey:A_Approve_path_name];
        self.A_IS_URGENT         = [[dict valueNumberForKey:A_Is_Urgent] integerValue];
        self.A_BACKUP            = [dict valueStringForKey:A_Backup];
        self.A_STATUS            = [dict valueStringForKey:A_Status];
        self.LAST_UPDATE_TIME    = [[dict valueNumberForKey:Last_Update_time] longLongValue];
        self.A_START_TIME        = [[dict valueNumberForKey:A_Start_time] longLongValue];
        self.A_END_TIME          = [[dict valueNumberForKey:A_End_time] longLongValue];
        self.A_DEADLINE          = [[dict valueNumberForKey:A_Deadline] longLongValue];
        self.A_FEE               = [[dict valueNumberForKey:A_Fee] integerValue];
        self.CREATE_USER         = [dict valueStringForKey:Create_user];
        self.CREATE_USER_NAME    = [dict valueStringForKey:Create_user_name];
        self.CREATE_TIME         = [[dict valueNumberForKey:Create_Time] longLongValue];
        self.IS_PROCESS          = [[dict valueNumberForKey:Is_Process] integerValue];
        self.IS_TIMESLOT_ALL_DAY = [[dict valueNumberForKey:IS_TIMESLOT_ALL_DAY] integerValue];
        self.IS_DEADLINE_ALL_DAY = [[dict valueNumberForKey:IS_DEADLINE_ALL_DAY] integerValue];
        self.IS_CAN_APPROVE      = [[dict valueNumberForKey:IS_CAN_APPROVE] intValue];
        self.IS_CAN_MODIFY       = [[dict valueNumberForKey:IS_CAN_MODIFY] intValue];
        self.IS_CAN_DELETE       = [[dict valueNumberForKey:IS_CAN_DELETE] intValue];
        self.has_files           = [[dict valueNumberForKey:A_HAS_FILE] integerValue];
        self.IS_HAVECOMMENT      = [[dict valueNumberForKey:IS_HAVECOMMENT] intValue];
        
        self.T_WORKFLOW_ID      = [dict valueStringForKey:@"T_WORKFLOW_ID"];
        self.A_APPROVE_TRIGGERS = [dict valueArrayForKey:@"A_APPROVE_TRRIGGERS"];
        self.A_FORM_INSTANCE_ID = [dict valueStringForKey:@"A_FORM_INSTANCE_ID"];
        self.A_MESSAGE_FORM     = [dict valueStringForKey:@"A_MESSAGE_FORM"];
        self.formDataJSONString = [dict valueStringForKey:@"A_FORM_DATA"];
        
    }
    return self;
}


- (void)handleValues {
    NSArray *formDataArray = [self.formDataJSONString mtc_objectFromJSONString];
    
    NSMutableDictionary *formDataDictionary = [NSMutableDictionary dictionary];
    for (NSDictionary *dict in formDataArray) {
        NSString *key = dict[@"key"];
        id value = dict[@"value"];
        if (key) {
            formDataDictionary[key] = value;
        }
    }
    
    [self.allFormModel.arrFormModels enumerateObjectsUsingBlock:^(NewApplyFormBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = formDataDictionary[obj.key];
        
        if ([obj isKindOfClass:[NewApplyFormPeopleModel class]])
        {
            [self handlePeople:obj];
            return;
        }
        
        if ([obj isKindOfClass:[NewApplyFormTimeModel class]]) {

            if (obj.inputType == Form_inputType_timeSlot) {
                NSDate *start = [value valueDateForKey:NewForm_startTime];
                NSDate *end   = [value valueDateForKey:NewForm_endTime];
                if ([value valueForKey:NewForm_startTime] == [NSNull null] || [[value valueForKey:NewForm_startTime] isKindOfClass:[NSString class]] || [value valueForKey:NewForm_startTime] == nil) {
                    obj.inputDetail = @{NewForm_startTime:[NSNull null],NewForm_endTime:[NSNull null], NewForm_isTimeSlotAllDay:[value valueForKey:NewForm_isTimeSlotAllDay] ?: @(0)};

                }
                else {
                    if (start && end) {
                        obj.inputDetail = @{NewForm_startTime:start,NewForm_endTime:end, NewForm_isTimeSlotAllDay:[value valueForKey:NewForm_isTimeSlotAllDay] ?: @(0)};
                    }
                }
            }
            else  if (obj.inputType == Form_inputType_timePoint) {  //时间点
                if ([value valueForKey:NewForm_startTime] == [NSNull null]|| [value valueForKey:NewForm_startTime] == nil|| [[value valueForKey:NewForm_startTime] isKindOfClass:[NSString class]]) {
                     obj.inputDetail = @{NewForm_startTime:[NSNull null],NewForm_isTimeSlotAllDay:[NSNumber numberWithBool:@(1)]};
                }
                else {
                    if ([value isKindOfClass:[NSDictionary class]] && [value count] > 1) {
                        NSDate *startDate = [value valueDateForKey:@"startTime"];
                        BOOL isWholeDay = [value valueBoolForKey:NewForm_isTimeSlotAllDay];
                        obj.inputDetail = @{NewForm_startTime:startDate,NewForm_isTimeSlotAllDay:[NSNumber numberWithBool:isWholeDay]};
                    }
                    else if ([value isKindOfClass:[NSNumber class]]){
                        NSDate *date = [NSDate getDate:value];
                        obj.inputDetail = @{NewForm_startTime:date};
                    }
                }
            }
            return;
        }
        
        if ([obj isKindOfClass:[NewApplyFormPeriodModel class]]) {
			NSDate *deadLine = nil;
            id dicValue = [value valueForKey:@"deadline"];
			if (self.A_IS_URGENT > 0) {
				obj.inputDetail = nil;				
			}
            else if ([value isKindOfClass:[NSDictionary class]]) {
                if ( dicValue == [NSNull null] ) {
                    obj.inputDetail = nil;
                }
                else if ([dicValue isKindOfClass:[NSNumber class]]){
                    if ([dicValue integerValue] == 0 || dicValue == [NSNull null]) {
                        obj.inputDetail = nil;
					} else {
						obj.inputDetail = value;
					}
                }
				
            }
            else if ([value isKindOfClass:[NSNumber class]]) {
                deadLine = [NSDate dateWithTimeIntervalSince1970:[value longLongValue] / 1000];
                obj.inputDetail = [deadLine timeIntervalSince1970] > 0 ? deadLine : nil;
            }else if (value == [NSNull null])
            {
                obj.inputDetail = nil;
            }
            return;
        }
		
		/**
		 *  清除审批内容的value,防止与详情界面的Title内容重复显示.
		 */
		if (value && [value isKindOfClass:[NSString class]] && [value isEqualToString:self.A_TITLE] && [obj.key isEqualToString:@"key0"]) {
			value = nil;
		}
		
        obj.inputDetail = value;
    }];
    
    [self.allFormModel sortForUI];
}


#pragma mark - Private Method
- (void)handlePeople:(NewApplyFormBaseModel *)model {
    NSArray *nameArray;
    NSArray *showIdArray;

    NSString *showingName;
    
    if (model.inputType == Form_inputType_ccPeopleChoose) {
        nameArray   = [self.A_CC_NAME componentsSeparatedByString:@"●"];
        showIdArray = [self.A_CC componentsSeparatedByString:@"●"];
        showingName = self.A_CC_NAME;
    } else {
        nameArray   = [self.A_APPROVE_NAME componentsSeparatedByString:@"●"];
        showIdArray = [self.A_APPROVE componentsSeparatedByString:@"●"];
        showingName = self.A_APPROVE_NAME;
    }
    
    NSMutableArray *modelArray       = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [nameArray count]; i ++) {
        NSString *name   = [nameArray objectAtIndex:i];
        NSString *showId = [showIdArray objectAtIndex:i];
        if ([showId length] && [name length]) {
            ContactPersonDetailInformationModel *personModel = [ContactPersonDetailInformationModel new];
            personModel.show_id     = showId;
            personModel.u_true_name = name;
            [modelArray addObject:personModel];
        }
    }

    NSDictionary *resultDict = @{NewForm_showingName:showingName,
                                 NewForm_modelArray:modelArray};
    model.inputDetail = resultDict;
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
    if ([key isEqualToString:A_APPROVE] && isname)
    {
        [self.arrAproveNameList addObjectsFromArray:contentArr];
    }
    else if ([key isEqualToString:A_CC] && isname)
    {
        [self.arrCCNameList addObjectsFromArray:contentArr];
    }
    else if ([key isEqualToString:A_APPROVE] && !isname)
    {
        [self.arrAproveList addObjectsFromArray:contentArr];
    }
    else if ([key isEqualToString:A_CC] && !isname)
    {
        [self.arrCCList addObjectsFromArray:contentArr];
    }
    tempStr = [self appendStrWithArr:contentArr];
    return tempStr;
}

- (NSString *)appendStrWithArr:(NSArray *)arr {
    return [arr componentsJoinedByString:@"●"];
}

#pragma mark - Interface Method
/**
 *  将审批期限日期进行格式化返回固定的时间格式
 */
- (NSString *)getFormattedDeadLineTime
{
	if (self.A_DEADLINE <= 0) {
		return @"";
	}
	
	BOOL isAllday = self.IS_DEADLINE_ALL_DAY;
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.A_DEADLINE/1000];
	NSString *str = @"";
	NSDate *today = [NSDate date];
	
	if (date.year == today.year && date.month == today.month && date.day == today.day && !isAllday)
	{
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"HH:mm"];
		str = [NSString stringWithFormat:@"%@%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY),[df stringFromDate:date]];
	} else if (isAllday) {
		str = [NSString stringWithFormat:@"%ld%@%ld%@",date.month,LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH),date.day,LOCAL(CALENDAR_SCHEDULEBYWEEK_DAY)];
	} else /*if (date.year == today.year)*/
	{
		str = [NSString stringWithFormat:@"%ld%@%ld%@ %02ld:%02ld",date.month,LOCAL(CALENDAR_SCHEDULEBYWEEK_MONTH),date.day,LOCAL(CALENDAR_SCHEDULEBYWEEK_DAY),date.hour,date.minute];
	}
	//    else
	//    {
	//        NSDateFormatter *df = [[NSDateFormatter alloc] init];
	//        [df setDateFormat:@"yyyy/MM/dd HH:mm"];
	//        str = [NSString stringWithFormat:@"%@",[df stringFromDate:date]];
	//    }
	if ([str hasPrefix:@"1970"]) {
		str = @"";
	}
	return str;
}

/**
 *  将创建审批的时间格式化,返回特定的时间格式
 */
- (NSString *)getFormattedCreateTime
{
	if (self.CREATE_TIME <= 0) {
		return @"";
		
	}
	
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.CREATE_TIME/1000];
	NSString *str = @"";
	NSDate *today = [NSDate date];
	
	if (date.year == today.year && date.month == today.month && date.day == today.day)
	{
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"HH:mm"];
		str = [NSString stringWithFormat:@"%@%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY),[df stringFromDate:date]];
	}
	else /*if (date.year == today.year)*/
	{
		str = [NSString stringWithFormat:@"%ld/%ld %ld:%ld",date.month,date.day,date.hour,date.minute];
	}
	//    else
	//    {
	//        NSDateFormatter *df = [[NSDateFormatter alloc] init];
	//        [df setDateFormat:@"yyyy/MM/dd HH:mm"];
	//        str = [NSString stringWithFormat:@"%@",[df stringFromDate:date]];
	//    }
	if ([str hasPrefix:@"1970"]) {
		str = @"";
	}

	return str;
}

// ************** 编辑新建使用 重写get set **************//
- (void)removeAllAction {
    [self.dictTry removeAllObjects];
    self.dictTry = nil;
}
- (void)refreshAction {
    NSArray *allKeys = [self.dictTry allKeys];
    for (NSString *key in allKeys) {
        id value = [self.dictTry valueForKey:key];
        if ([key isEqualToString:A_Title]) {
            self.A_TITLE = value;
        }
        else if ([key isEqualToString:A_APPROVE]) {
            self.A_APPROVE = value;
        }
        else if ([key isEqualToString:A_ApproveName]) {
            self.A_APPROVE_NAME = value;
        }
        else if  ([key isEqualToString:A_CC]) {
            self.A_CC = value;
        }
        else if ([key isEqualToString:A_CC_name]) {
            self.A_CC_NAME = value;
        }
        else if ([key isEqualToString:A_Is_Urgent]) {
            self.A_IS_URGENT = [value integerValue];
        }
        else if ([key isEqualToString:A_Backup]) {
            self.A_BACKUP = value;
        }
        else if ([key isEqualToString:A_Start_time]) {
            self.A_START_TIME = [value longLongValue];
        }
        else if ([key isEqualToString:A_End_time]) {
            self.A_END_TIME = [value longLongValue];
        }
        else if ([key isEqualToString:A_Deadline]) {
            self.A_DEADLINE = [value longLongValue];
        }
        else if ([key isEqualToString:A_Fee]) {
            self.A_FEE = [value integerValue];
        }
        else if ([key isEqualToString:@"attachment"]) {
            self.attachMentArray = value;
        }
        else if ([key isEqualToString:IS_DEADLINE_ALL_DAY]) {
            self.IS_DEADLINE_ALL_DAY = [value integerValue];
        }
        else if ([key isEqualToString:IS_TIMESLOT_ALL_DAY]) {
            self.IS_TIMESLOT_ALL_DAY = [value integerValue];
        }
    }
    
    [self removeAllAction];
}

- (NSString *)try_A_TITLE {
    id value = [self.dictTry valueForKey:A_Title];
    return value ?: self.A_TITLE;
}

- (void)setTry_A_TITLE:(NSString *)try_A_TITLE {
    [self.dictTry setObject:try_A_TITLE forKey:A_Title];
}

- (NSString *)try_A_APPROVE {
    id value = [self.dictTry valueForKey:A_APPROVE];
    return value ?: self.A_APPROVE;
}

- (void)setTry_A_APPROVE:(NSString *)try_A_APPROVE {
    [self.dictTry setObject:try_A_APPROVE forKey:A_APPROVE];
}

- (NSString *)try_A_APPROVE_NAME {
    id value = [self.dictTry valueForKey:A_ApproveName];
    return value ?: self.A_APPROVE_NAME;
}

- (void)setTry_A_APPROVE_NAME:(NSString *)try_A_APPROVE_NAME {
    [self.dictTry setObject:try_A_APPROVE_NAME forKey:A_ApproveName];
}

- (NSString *)try_A_CC {
    id value = [self.dictTry valueForKey:A_CC];
    return value ?: self.A_CC;
}

- (void)setTry_A_CC:(NSString *)try_A_CC {
    [self.dictTry setObject:try_A_CC forKey:A_CC];
}

- (NSString *)try_A_CC_NAME {
    id value = [self.dictTry valueForKey:A_CC_name];
    return value ?: self.A_CC_NAME;
}

- (void)setTry_A_CC_NAME:(NSString *)try_A_CC_NAME {
    [self.dictTry setObject:try_A_CC_NAME forKey:A_CC_name];
}

- (NSInteger)try_A_IS_URGENT {
    id value = [self.dictTry valueForKey:A_Is_Urgent];
    return value ? [value integerValue] : self.A_IS_URGENT;
}

- (void)setTry_A_IS_URGENT:(NSInteger)try_A_IS_URGENT {
    [self.dictTry setObject:@(try_A_IS_URGENT) forKey:A_Is_Urgent];
}

- (NSString *)try_A_BACKUP {
    id value = [self.dictTry valueForKey:A_Backup];
    return value ?: self.A_BACKUP;
}

- (void)setTry_A_BACKUP:(NSString *)try_A_BACKUP {
    [self.dictTry setObject:try_A_BACKUP forKey:A_Backup];
}

- (long long)try_A_START_TIME {
    id value = [self.dictTry valueForKey:A_Start_time];
    return value ? [value longLongValue] : self.A_START_TIME;
}

- (void)setTry_A_START_TIME:(long long)try_A_START_TIME {
    [self.dictTry setObject:@(try_A_START_TIME) forKey:A_Start_time];
}

- (long long)try_A_END_TIME {
    id value = [self.dictTry valueForKey:A_End_time];
    return value ? [value longLongValue] : self.A_END_TIME;
}

- (void)setTry_A_END_TIME:(long long)try_A_END_TIME {
    [self.dictTry setObject:@(try_A_END_TIME) forKey:A_End_time];
}

- (long long)try_A_DEADLINE {
    id value = [self.dictTry valueForKey:A_Deadline];
    return value ? [value longLongValue] : self.A_DEADLINE;
}

- (void)setTry_A_DEADLINE:(long long)try_A_DEADLINE {
    [self.dictTry setObject:@(try_A_DEADLINE) forKey:A_Deadline];
}

- (double)try_A_FEE {
    id value = [self.dictTry valueForKey:A_Fee];
    return value ? [value doubleValue] : self.A_FEE;
}

- (void)setTry_A_FEE:(double)try_A_FEE {
    [self.dictTry setObject:@(try_A_FEE) forKey:A_Fee];
}

- (NSMutableArray *)try_attachMentArray {
    id value = [self.dictTry valueForKey:@"attachment"];
    return value ?: self.attachMentArray;
}

- (void)setTry_attachMentArray:(NSMutableArray *)try_attachMentArray {
    if (try_attachMentArray) {
        [self.dictTry setObject:try_attachMentArray forKey:@"attachment"];
    }
    
}

- (NSInteger)try_IS_DEADLINE_ALL_DAY {
    id value = [self.dictTry valueForKey:IS_DEADLINE_ALL_DAY];
    return value ? [value integerValue] : self.IS_DEADLINE_ALL_DAY;
}

- (void)setTry_IS_DEADLINE_ALL_DAY:(NSInteger)try_IS_DEADLINE_ALL_DAY {
    [self.dictTry setObject:@(try_IS_DEADLINE_ALL_DAY) forKey:IS_DEADLINE_ALL_DAY];
}

- (NSInteger)try_IS_TIMESLOT_ALL_DAY {
    id value = [self.dictTry valueForKey:IS_TIMESLOT_ALL_DAY];
    return value ? [value integerValue] : self.IS_TIMESLOT_ALL_DAY;
}

- (void)setTry_IS_TIMESLOT_ALL_DAY:(NSInteger)try_IS_TIMESLOT_ALL_DAY {
    [self.dictTry setObject:@(try_IS_TIMESLOT_ALL_DAY) forKey:IS_TIMESLOT_ALL_DAY];
}

// ************** 编辑新建使用 重写get set **************//


#pragma mark - init
- (NSMutableArray *)attachMentArray
{
    if (!_attachMentArray)
    {
        _attachMentArray = [[NSMutableArray alloc] init];
    }
    return _attachMentArray;
}

- (NSMutableArray *)arrAproveNameList
{
    if (!_arrAproveNameList)
    {
        _arrAproveNameList = [[NSMutableArray alloc] init];
    }
    return _arrAproveNameList;
}

- (NSMutableArray *)arrCCNameList
{
    if (!_arrCCNameList)
    {
        _arrCCNameList = [[NSMutableArray alloc] init];
    }
    return _arrCCNameList;
}

- (NSMutableArray *)arrAproveList
{
    if (!_arrAproveList)
    {
        _arrAproveList = [[NSMutableArray alloc] init];
    }
    return _arrAproveList;
}

- (NSMutableArray *)arrCCList
{
    if (!_arrCCList)
    {
        _arrCCList = [[NSMutableArray alloc] init];
    }
    return _arrCCList;
}

- (NSMutableDictionary *)dictTry {
    if (!_dictTry) {
        _dictTry = [NSMutableDictionary dictionary];
    }
    return _dictTry;
}

- (NSMutableArray *)A_APPROVE_PATH
{
    if (!_A_APPROVE_PATH)
    {
        _A_APPROVE_PATH = [[NSMutableArray alloc] init];
    }
    return _A_APPROVE_PATH;
}
@end


