//
//  ApplyEditApplyRequest.m
//  launcher
//
//  Created by Dee on 15/9/6.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyEditApplyRequest.h"
#import "ApplicationAttachmentModel.h"
#import "NewApplyFormBaseModel.h"
#import <MJExtension/MJExtension.h>
#import "NSString+ApplyFeeHandle.h"
static NSString *const A_Title              = @"aTitle";
static NSString *const T_Show_Id            = @"tShowId";
static NSString *const A_CC                 = @"aCc";
static NSString *const A_CC_Name            = @"aCcName";
static NSString *const A_APPROVE            = @"aApprove";
static NSString *const A_APPROVE_Name       = @"aApproveName";
static NSString *const A_Start_Time         = @"aStartTime";
static NSString *const A_End_Time           = @"aEndTime";
static NSString *const A_Fee                = @"A_FEE";
static NSString *const A_Is_Urgent          = @"aIsUrgent";
static NSString *const A_Deadline           = @"aDeadLine";
static NSString *const A_BackUp             = @"aBackup";
static NSString *const A_showID             = @"showId";
static NSString *const A_Is_TimeLot_All_Day = @"IS_TIMESLOT_ALL_DAY";
static NSString *const A_Deadline_All_Day   = @"isDeadlineAllDay";
static NSString *const A_fileShowIds        = @"fileShowIds";

static NSString *const A_Form               = @"aForm";
static NSString *const A_Form_Id            = @"formId";
static NSString *const A_Form_Data          = @"aFormData";
static NSString *const M_Method_type        = @"methodType";
static NSString *const T_WorkflowId         = @"tWorkflowId";

@implementation ApplyEditApplyRequest

- (NSString *)api  { return @"/Approve-Module/Approve/PostV2";}
- (NSString *)type { return @"POST";}

- (void)editApplyWithModel:(ApplyDetailInformationModel *)model applyType:(ApplyeType)type;
{
    self.params[A_Title]              = model.try_A_TITLE?:@"";
    self.params[A_showID]             = model.SHOW_ID?:@"";
    self.params[T_Show_Id]            = model.T_SHOW_ID?:@"";
    self.params[A_APPROVE]            = model.try_A_APPROVE ?:@"";
    self.params[A_APPROVE_Name]       = model.try_A_APPROVE_NAME ?:@"";
    self.params[A_CC]                 = model.try_A_CC?:@"";
    self.params[A_CC_Name]            = model.try_A_CC_NAME?:@"";

    self.params[A_Start_Time]         = [NSNumber numberWithLongLong:model.try_A_START_TIME ]?:[NSNull null];
    self.params[A_End_Time]           = [NSNumber numberWithLongLong:model.try_A_END_TIME ]?:[NSNull null];
    
    self.params[A_Fee]                = @(model.try_A_FEE)?:@"";
    self.params[A_Is_Urgent]          = model.try_A_IS_URGENT > 0 ?@(1):@(0);
    
    self.params[A_Deadline]           = model.try_A_DEADLINE>0 ? @(model.try_A_DEADLINE):[NSNull null];
    
    self.params[A_BackUp]             = model.try_A_BACKUP?:@"";
    self.params[A_Is_TimeLot_All_Day] = @(model.try_IS_TIMESLOT_ALL_DAY)?:@"";
    self.params[A_Deadline_All_Day]   = @(model.try_IS_DEADLINE_ALL_DAY);
    
    self.params[M_Method_type]        = @"Put";
    self.params[A_Form]               = model.A_MESSAGE_FORM;
    self.params[A_Form_Data]          = [self handleFromModel:model applyType:type];
    self.params[A_Form_Id]            = model.A_FORM_INSTANCE_ID;
    self.params[T_WorkflowId]         = model.T_WORKFLOW_ID;
    
    NSArray *attachmentArray = model.try_attachMentArray;
    NSMutableArray *attachShowId = [NSMutableArray array];
    
    for (ApplicationAttachmentModel *attachment in attachmentArray) {
        [attachShowId addObject:attachment.showId];
    }
    
    self.params[A_fileShowIds] = attachShowId;
    
    [self requestData];
}

- (NSString *)handleFromModel:(ApplyDetailInformationModel *)model applyType:(ApplyeType)type
{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i <=  6; i++) {
        NSString *key = [NSString stringWithFormat:@"key%d",i];
        NSMutableDictionary  *dict = [NSMutableDictionary new];
        NSString *valueStr = @"value";
        NSString *keyStr = @"key";
        [dict setValue:key forKey:keyStr];
        switch (i) {
            case 0:
            {
                
                [dict setValue:model.try_A_TITLE forKey:valueStr];
            }
                break;
            case 1:
            {
                if (type == k_Apply_Vocapation) {
                    
                    NSMutableDictionary *innerDict = [NSMutableDictionary dictionary];
                    [innerDict setValue:model.try_A_END_TIME > 0?@(model.try_A_END_TIME):[NSNull null] forKey:@"endTime"];
                    [innerDict setValue:model.try_A_START_TIME > 0 ?@(model.try_A_START_TIME):[NSNull null] forKey:@"startTime"];
                    [innerDict setValue:@(model.try_IS_TIMESLOT_ALL_DAY) forKey:@"isTimeSlotAllDay"];
                    [dict setValue:innerDict forKey:valueStr];
                    
                }else{
                    [dict setValue:[NSString generateCustomeMoneyTextWithCurrentText:[[NSNumber numberWithDouble:model.try_A_FEE] stringValue]] forKey:valueStr];
                }
                
            }
                break;
            case 2:
           
            case 3:
        
            case 5:
            {
                 [dict setValue:@"" forKey:valueStr];
                
            }
                break;
            case 4:
            {
                NSMutableDictionary *tempdict = [NSMutableDictionary dictionary];
                [tempdict setValue:model.try_A_DEADLINE>0?@(model.try_A_DEADLINE):[NSNull null] forKey:@"deadline"];
                [tempdict setValue:@(model.try_IS_DEADLINE_ALL_DAY) forKey:@"isDeadLineAllDay"];
                [dict setValue:tempdict forKey:valueStr];
            }
                break;
            case 6:
            {
                if (![model.try_A_BACKUP isEqualToString:@""] && model.try_A_BACKUP != nil) {
                    [dict setValue:model.try_A_BACKUP forKey:valueStr];
                }
            }
                break;

            default:
                break;
        }
        [tempArr addObject:dict];
    }
    return  [tempArr mj_JSONString];
}

@end
