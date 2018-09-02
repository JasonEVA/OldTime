//
//  AppApprovalModel.m
//  launcher
//
//  Created by Andrew Shen on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "AppApprovalModel.h"
#import <MJExtension/MJExtension.h>
#import "NSDictionary+SafeManager.h"
#import "NewApplyFormBaseModel.h"
#import "NewApplyFormPeriodModel.h"

@implementation AppApprovalModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSString class]) {
        if (oldValue == nil || oldValue == [NSNull null] || oldValue == NULL) {
            return @"";
        }
    }
    
    if ([property.name isEqualToString:@"approvalFormData"]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSDictionary *subDict in oldValue) {
            if (![[subDict valueStringForKey:@"key"] length]) {
                continue;
            }
            dict[[subDict valueStringForKey:@"key"]] = subDict[@"value"];
        }
        
        return dict;
    }
    
    if ([property.name isEqualToString:@"approvalForm"]) {
        NewApplyAllFormModel *model = [[NewApplyAllFormModel alloc] initWithArray:oldValue];
        return model;
    }
    
    return oldValue;
}

- (NSArray<NewApplyFormBaseModel *> *)sortedForChatUI {
    NSMutableArray *array = [NSMutableArray array];
    
    for (NewApplyFormBaseModel *model in self.approvalForm.arrFormModels) {
        if (model.inputType == Form_inputType_requiredPeopleChoose ||
            model.inputType == Form_inputType_ccPeopleChoose) {
            continue;
        }
        
        if (model.inputType == Form_inputType_file) {
            continue;
        }
        
        id value = [self.approvalFormData valueDictonaryForKey:model.key];
        
        if (model.inputType == Form_inputType_textInput ||
            model.inputType == Form_inputType_textArea)
        {
            if (![value isKindOfClass:NSString.class]) {
                continue;
            }
            
            if (![value length]) {
                continue;
            }
        }
        
        if (model.inputType == Form_inputType_timePoint ||
            model.inputType == Form_inputType_approvePeriod)
        {
            NSDate *date;
            if (model.inputType == Form_inputType_approvePeriod && [value isKindOfClass:[NSDictionary class]]) {
                date = [value valueDateForKey:NewForm_deadline];
            } else {
                if ([value isKindOfClass:[NSDictionary class]]) {
                    date = [value valueDateForKey:@"startTime"];
                }else
                {
                    date = [self.approvalFormData valueDateForKey:model.key];
                }
                
            }
            
            if ([date timeIntervalSince1970] == 0) {
                continue;
            }
        }
        
        [array addObject:model];
    }
    
    return [array copy];
}

@end
