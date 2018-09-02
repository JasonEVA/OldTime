//
//  ApplyAddNewApplyRequest.m
//  launcher
//
//  Created by Dee on 15/9/5.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyAddNewApplyRequest.h"
#import "NSDictionary+SafeManager.h"
#import "ApplicationAttachmentModel.h"

static NSString *const A_Title          = @"A_TITLE";
static NSString *const A_ShowTypeID     = @"T_SHOW_ID";
static NSString *const A_Approve        = @"A_APPROVE";
static NSString *const A_Approve_name   = @"A_APPROVE_NAME";
static NSString *const A_CC             = @"A_CC";
static NSString *const A_CC_Name        = @"A_CC_NAME";
static NSString *const A_Strat_Time     = @"A_START_TIME";
static NSString *const A_End_Time       = @"A_END_TIME";
static NSString *const A_Fee            = @"A_FEE";
static NSString *const A_Is_Urgent      = @"A_IS_URGENT";
static NSString *const A_Deadline       = @"A_DEADLINE";
static NSString *const A_DeadlineAllDay = @"IS_DEADLINE_ALL_DAY";
static NSString *const A_Backup         = @"A_BACKUP";

static NSString *const A_ShowID             = @"SHOW_ID";
static NSString *const A_CreateUserName     = @"CREATE_USER_NAME";
static NSString *const A_CreateTime         = @"CREATE_TIME";
static NSString *const A_Is_TimeLot_All_Day = @"IS_TIMESLOT_ALL_DAY";
static NSString *const fileShowIds          = @"fileShowIds";

@implementation ApplyAddNewApplyRequest
- (void)applyAddNewApplyWithModel:(ApplyDetailInformationModel *)model {
    self.params[A_Title]              = model.try_A_TITLE?:@"";
    self.params[A_ShowTypeID]         = model.T_SHOW_ID?:@"";
    self.params[A_Approve]            = model.try_A_APPROVE?:@"";
    self.params[A_Approve_name]       = model.try_A_APPROVE_NAME?:@"";
    self.params[A_CC]                 = model.try_A_CC?:@"";
    self.params[A_CC_Name]            = model.try_A_CC_NAME?:@"";
    
    self.params[A_Strat_Time]         = [NSNumber numberWithLongLong:model.try_A_START_TIME]?:@"";
    self.params[A_End_Time]           = [NSNumber numberWithLongLong:model.try_A_END_TIME]?:@"";
    self.params[A_Fee]                = @(model.try_A_FEE)?:@"";
    self.params[A_Is_Urgent]          = @(model.try_A_IS_URGENT);
    self.params[A_Deadline]           = @(model.try_A_DEADLINE)?:@"";
    self.params[A_Backup]             = model.try_A_BACKUP?:@"";
    self.params[A_Is_TimeLot_All_Day] = @(model.try_IS_TIMESLOT_ALL_DAY)?:@"";
    self.params[A_DeadlineAllDay]     = @(model.try_IS_DEADLINE_ALL_DAY)?:@"";
    
    NSArray *attachmentArray = model.try_attachMentArray;
    NSMutableArray *attachShowId = [NSMutableArray array];
    for (ApplicationAttachmentModel *attachment in attachmentArray) {
        [attachShowId addObject:attachment.showId];
    }
    self.params[fileShowIds] = attachShowId;
    
    [self requestData];
}

- (NSString *)type
{
    return @"PUT";
}

- (NSString *)api
{
    return @"/Approve-Module/Approve";
}

- (BaseResponse *)prepareResponse:(id)data
{
    ApplyAddNewApplyResponse *response = [ApplyAddNewApplyResponse new];
    
    response.showId         = [data valueStringForKey:A_ShowID];
    response.createUserName = [data valueStringForKey:A_CreateUserName];
    response.createTime     = [data valueDateForKey:A_CreateTime];
    
    return response;
}

@end

@implementation ApplyAddNewApplyResponse

@end