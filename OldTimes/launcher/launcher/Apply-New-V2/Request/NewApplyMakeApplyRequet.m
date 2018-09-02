//
//  NewApplyMakeApplyRequet.m
//  launcher
//
//  Created by Dee on 16/8/12.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  创建审批，用于替换之前的NewApplyCreateV2Request

#import "NewApplyMakeApplyRequet.h"
#import "NewApplyAllFormModel.h"
#import "NewApplyFormBaseModel.h"
#import "ContactPersonDetailInformationModel.h"
#import "NSDictionary+SafeManager.h"
#import <MJExtension.h>
#import "ApplicationAttachmentModel.h"
static NSString const *t_ShowID             = @"tShowId";
static NSString const *a_Title              = @"aTitle";
static NSString const *t_Workflow           = @"tWorkflowId";
static NSString const *a_Approve            = @"aApprove";
static NSString const *a_ApproveName        = @"aApproveName";
static NSString const *a_Cc                 = @"aCc";
static NSString const *a_CcName             = @"aCcName";
static NSString const *a_IsUrgent           = @"aIsUrgent";
static NSString const *a_FileShowIds        = @"fileShowIds";
static NSString const *m_MethodType         = @"methodType";
static NSString const *a_FormData           = @"aFormData";
static NSString const *a_Form               = @"aForm";
static NSString const *a_IsDeadlineAllDay   = @"isDeadlineAllDay";
static NSString const *a_Deadline           = @"aDeadline";
static NSString const *a_FormId             = @"formId";


static NSString *const NewForm_showingName = @"showingName";
static NSString *const NewForm_modelArray  = @"modelArray";

static NSString *const NewForm_deadLine = @"deadline";
static NSString *const NewForm_isDeadLineAllDay = @"isDeadLineAllDay";

static NSString *const NewForm_startTime = @"startTime";
static NSString *const NewForm_isTimeLoftAllDay = @"isTimeSlotAllDay";
static NSString *const NewForm_endTime = @"endTime";


@implementation NewApplyMakeApplyRequet

- (NSString *)api  { return @"/Approve-Module/Approve/PutV2"; }
- (NSString *)type { return @"PUT"; }

- (void)createApplyWithApplyShowID:(NSString *)applyShowId
                        workflowId:(NSString *)workflowId
                    dateModelArray:(NewApplyAllFormModel *)formModel
                          isUrgent:(BOOL)isurgent
{
    self.params[a_IsUrgent] = isurgent?@(1):@(0);
    self.params[a_Form] = formModel.formStr;
    self.params[a_FormId] = formModel.formId;
    self.params[a_FileShowIds] = @[];
    self.params[t_ShowID] = applyShowId;
    self.params[m_MethodType] = @"Put";
    NSMutableArray *formDataArray = [NSMutableArray array];
    
    for (NewApplyFormBaseModel *obj in formModel.arrFormModels) {
        
        //只取第一个文本输入框的内容标题
        //title
        if (obj.inputType == Form_inputType_textInput || obj.inputType == Form_inputType_textArea) {
            [self setTitle:obj.try_inputDetail];
        }
        
        //审批人
        if (obj.inputType == Form_inputType_requiredPeopleChoose) {
            self.params[a_Approve] = [self getShowIDFromArray:[obj.try_inputDetail valueArrayForKey:NewForm_modelArray]];
            self.params[a_ApproveName] = [obj.try_inputDetail valueStringForKey:NewForm_showingName];
        }
        
        //抄送
        if (obj.inputType == Form_inputType_ccPeopleChoose) {
            self.params[a_Cc] = [self getShowIDFromArray:[obj.try_inputDetail valueArrayForKey:NewForm_modelArray]];
            self.params[a_CcName] = [obj.try_inputDetail valueStringForKey:NewForm_showingName];
        }
        
        //审批期限
        if (obj.inputType == Form_inputType_approvePeriod) {
            BOOL isWholeDay = [obj.try_inputDetail valueBoolForKey:NewForm_isDeadLineAllDay];
            [self setDeadLienAllDay:isWholeDay];
            //紧急状态下不显示 审批期限
            if (isurgent) {
                self.params[a_Deadline] = [NSNull null];
                obj.try_inputDetail = [NSNull null];
            }else
            {
                NSNumber *dealLine = obj.try_inputDetail[NewForm_deadLine];
                self.params[a_Deadline] =  dealLine == 0 || dealLine == nil?[NSNull null]:dealLine;
            }
            //如果可以选择不填的时候
            if (obj.try_inputDetail == nil) {
                obj.try_inputDetail = [NSNull null];
                self.params[a_Deadline] = [NSNull null];
            }
        }
        
        //在非必需情况下，设置默认的数据
        if (obj.inputType == Form_inputType_timeSlot) {
            if (obj.try_inputDetail == nil) {
                obj.try_inputDetail = @{NewForm_startTime:[NSNull null],NewForm_endTime:[NSNull null],NewForm_isTimeLoftAllDay:@(1)};
            }
        }else if(obj.inputType  == Form_inputType_timePoint){
            if (obj.try_inputDetail == nil) {
                obj.try_inputDetail = @{NewForm_startTime:[NSNull null],NewForm_isTimeLoftAllDay:@(1)};
            }
        }
        
        
        //formData 处理
        if (obj.try_inputDetail) {
            //审批抄送人单独放在表单外部
            if (obj.inputType == Form_inputType_ccPeopleChoose || obj.inputType == Form_inputType_requiredPeopleChoose) {
                continue;
            }
            //文件类型处理
            if (obj.inputType == Form_inputType_file) {
                NSMutableArray *attachArray = [NSMutableArray array];
                for (ApplicationAttachmentModel *fileModel in obj.try_inputDetail) {
                    [attachArray addObject:fileModel.showId];
                }
                obj.try_inputDetail = attachArray;
                self.params[a_FileShowIds] = attachArray;
                continue;
            }
            
            if (obj.inputType == Form_inputType_singleChoose) {
                NSArray *objArray = obj.try_inputDetail;
                if (objArray.count) {
                    obj.try_inputDetail = objArray[0];
                }
            }
            
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
            [tempDict setValue:obj.key forKey:@"key"];
            [tempDict setValue:obj.try_inputDetail forKey:@"value"];
            [formDataArray addObject:tempDict];
        }

    }
    
    self.params[a_FormData] = [formDataArray mj_JSONString] ;
    
    [self requestData];
}

- (void)setTitle:(NSString *)title
{
    if (self.params[a_Title] == nil ) {
        self.params[a_Title] = title;
    }
}

- (void)setDeadLienAllDay:(BOOL)isWholeDay
{
    if (self.params[a_IsDeadlineAllDay] == nil) {
        self.params[a_IsDeadlineAllDay] = isWholeDay?@(1):@(0);
    }
}

//对showid进行拼接
- (NSString *)getShowIDFromArray:(NSArray *)modelArray
{
    NSString *tempStr = @"";
    for (int i = 0; i< modelArray.count; i++) {
        ContactPersonDetailInformationModel *model = modelArray[i];
        tempStr = [tempStr stringByAppendingString:model.show_id];
        if (i != [modelArray count] - 1) {
         tempStr = [tempStr stringByAppendingString:@"●"];
        }
    }
    return tempStr;
}

- (BaseResponse *)prepareResponse:(id)data
{
    NewApplyMakeApplyResponse *response = [[NewApplyMakeApplyResponse alloc] init];
    return response;
}

@end


@implementation NewApplyMakeApplyResponse;


@end
