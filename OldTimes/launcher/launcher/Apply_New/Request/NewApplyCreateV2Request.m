//
//  NewApplyCreateV2Request.m
//  launcher
//
//  Created by williamzhang on 16/4/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyCreateV2Request.h"
#import "ContactPersonDetailInformationModel.h"
#import "NewApplyAllFormModel.h"
#import "NewApplyFormBaseModel.h"
#import "NewApplyFormTextInputModel.h"
#import "NewApplyFormPeopleModel.h"
#import "ApplicationAttachmentModel.h"
#import <MJExtension/MJExtension.h>
#import "ApplyDetailInformationModel.h"

static NSString *const NewApplyCreateV2RequestADeadline = @"aDeadline";
static NSString *const NewApplyCreateV2RequestIsDeadlineAllDay = @"isDeadlineAllDay";

@implementation NewApplyCreateV2Request

- (NSString *)api  { return @"/Approve-Module/Approve/PutV2"; }
- (NSString *)type { return @"PUT"; }

- (void)approveNewWithApproveShowId:(NSString *)approveShowId
                         workflowId:(NSString *)workflowId
                             formId:(NSString *)formId
                              model:(NewApplyAllFormModel *)model

{
    [self approveNewWithApproveShowId:approveShowId workflowId:workflowId formId:formId model:model isUrgent:0 ];
}

- (void)approveNewWithApproveShowId:(NSString *)approveShowId
                         workflowId:(NSString *)workflowId
                             formId:(NSString *)formId
                              model:(NewApplyAllFormModel *)model
                           isUrgent:(NSInteger)isUrgent
{
    self.params[@"aIsUrgent"] = @(isUrgent);
    self.params[@"tShowId"]     = approveShowId;
    self.params[@"tWorkflowId"] = workflowId;
    self.params[@"formId"]      = formId;
    NSMutableArray *formDataArray = [NSMutableArray array];
    
    NSString *title = nil;
    
    BOOL secondTextInput = NO;
    NewApplyFormBaseModel *secondTextInputModel;
    NewApplyFormBaseModel *timeModel;
    NewApplyFormBaseModel *singleChooseModel;
    NewApplyFormBaseModel *multiChooseModel;
    
    for (NewApplyFormBaseModel *subModel in model.arrFormModels) {
        
        if (!subModel.try_inputDetail) {
            continue;
        }
        
        if ([subModel formData]) {
            [formDataArray addObject:[subModel formData]];
        }
        
        if (!title && [subModel isKindOfClass:[NewApplyFormTextInputModel class]]) {
            title = subModel.try_inputDetail;
        }
        
        
        if ([subModel isKindOfClass:[NewApplyFormPeopleModel class]]) {
            NSMutableArray *arrayName   = [NSMutableArray array];
            NSMutableArray *arrayShowId = [NSMutableArray array];
            
            for (ContactPersonDetailInformationModel *model in subModel.try_inputDetail[NewForm_modelArray]) {
                [arrayName addObject:model.u_true_name];
                [arrayShowId addObject:model.show_id];
            }
            
            if (subModel.inputType == Form_inputType_requiredPeopleChoose) {
                self.params[@"aApprove"]     = [arrayShowId componentsJoinedByString:@"●"];
                self.params[@"aApproveName"] = [arrayName componentsJoinedByString:@"●"];
            }
            else {
                self.params[@"aCc"]     = [arrayShowId componentsJoinedByString:@"●"];
                self.params[@"aCcName"] = [arrayName componentsJoinedByString:@"●"];
            }
        }
        
        if (subModel.inputType == Form_inputType_file) {
            NSMutableArray *attachArray = [NSMutableArray array];
            for (ApplicationAttachmentModel *model in subModel.try_inputDetail) {
                [attachArray addObject:model.showId];
            }
            
            self.params[@"fileShowIds"] = attachArray;
        }
        
        if (subModel.inputType == Form_inputType_singleChoose && !singleChooseModel) {
            singleChooseModel = subModel;
        }
        else if (subModel.inputType == Form_inputType_multiChoose && !multiChooseModel) {
            multiChooseModel = subModel;
        }
        else if ((subModel.inputType == Form_inputType_timePoint ||
                 subModel.inputType == Form_inputType_timeSlot  ||
                 subModel.inputType == Form_inputType_approvePeriod) && !timeModel)
        {
            timeModel = subModel;
        }
        else if ([subModel isKindOfClass:[NewApplyFormTextInputModel class]]) {
            if (!secondTextInput) {
                secondTextInput = YES;
                continue;
            }
            
            if (!secondTextInputModel) secondTextInputModel = subModel;
        }
    }
    
//    NSMutableArray *aFormArray = [NSMutableArray array];
//    if (secondTextInputModel) [aFormArray addObject:secondTextInputModel.originalDictionary];
//    if (timeModel)            [aFormArray addObject:timeModel.originalDictionary];
//    if (singleChooseModel)    [aFormArray addObject:singleChooseModel.originalDictionary];
//    if (multiChooseModel)     [aFormArray addObject:multiChooseModel.originalDictionary];
    if ([model.formStr isKindOfClass:[NSString class]]) {
        self.params[@"aForm"] = model.formStr;
    }else
    {
        self.params[@"aForm"] = [model.formStr mj_JSONString];
    }
    
    
    self.params[@"aFormData"] = [formDataArray mj_JSONString];
    
    self.params[@"aTitle"] = title;
    
    [self requestData];
}

- (void)configureApproveDeadlineTime:(long long)deadlineTime isWholeDay:(BOOL)isWholeDay {
	
	self.params[NewApplyCreateV2RequestADeadline] = deadlineTime > 0 ? @(deadlineTime) : [NSNull null];
	self.params[NewApplyCreateV2RequestIsDeadlineAllDay] = @(isWholeDay);
}

@end
