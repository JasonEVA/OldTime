//
//  NewApplyAllFormModel.m
//  launcher
//
//  Created by 马晓波 on 16/4/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyAllFormModel.h"
#import "NSDictionary+SafeManager.h"
#import "NewApplyFormBaseModel.h"
#import "MyDefine.h"
@implementation NewApplyAllFormModel

- (instancetype)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        _arrFormModels = [NSMutableArray array];
        
        for (NSDictionary *dict in array) {
            NSString *inputType = [dict valueStringForKey:@"inputType"];
            
            NSString *classString = [[self inputTypeDictionary] objectForKey:inputType];
            Class aClass = NSClassFromString(@"NewApplyFormBaseModel");
            if (classString) {
                aClass = NSClassFromString(classString);
            }
            
            NewApplyFormBaseModel *model = [(NewApplyFormBaseModel *)[aClass alloc] initWithDict:dict];
            [self.arrFormModels addObject:model];
        }
    }
    return self;
}

- (instancetype)initWithSortingArray:(NSArray *)array
{
    if (self = [super init]) {
        _arrFormModels = [NSMutableArray array];
        
        for (NSDictionary *dict in array) {
            NSString *inputType = [dict valueStringForKey:@"inputType"];
            
            NSString *classString = [[self inputTypeDictionary] objectForKey:inputType];
            Class aClass = NSClassFromString(@"NewApplyFormBaseModel");
            if (classString) {
                aClass = NSClassFromString(classString);
            }
            
            NewApplyFormBaseModel *model = [(NewApplyFormBaseModel *)[aClass alloc] initWithDict:dict];
            [self.arrFormModels addObject:model];
        }
        [self sortForCreateUI];
    }
    return self;
}

- (NSDictionary *)inputTypeDictionary {
    return @{
             @"TextInput":@"NewApplyFormTextInputModel",
             @"TextArea":@"NewApplyFormTextInputModel",
             
             @"RadioButton":@"NewApplyFormChooseModel",
             @"CheckBox":@"NewApplyFormChooseModel",
             
             @"Time":@"NewApplyFormTimeModel",
             
             @"File":@"NewApplyFormFileModel",
             
             @"ApprovePerson":@"NewApplyFormPeopleModel",
             @"CCPerson":@"NewApplyFormPeopleModel",
             
             @"ApprovePeriod":@"NewApplyFormPeriodModel"
             };
}

- (void)sortForCreateUI
{
    NSMutableArray *array1 = [NSMutableArray array]; //标题
    NSMutableArray *array2 = [NSMutableArray array]; //时间／金额
    NSMutableArray *array3 = [NSMutableArray array]; //审批或者抄送
    NSMutableArray *array4 = [NSMutableArray array]; //多选或者单选
    NSMutableArray *array5 = [NSMutableArray array]; //审批期限
    NSMutableArray *array6 = [NSMutableArray array]; //文件／备注
    
    for (NewApplyFormBaseModel *model in self.arrFormModels) {
        switch (model.inputType) {
            case Form_inputType_textArea: //标题
                //备注添加到最后
                if ([model.labelText isEqualToString:@"备注"] || [model.labelText isEqualToString:@"备注"]) {
                    [array6 addObject:model];
                }else{
                    [array1 addObject:model];
                }
                break;
            case Form_inputType_textInput:          //金额 ／ 时间
            case Form_inputType_timeSlot:
            case Form_inputType_timePoint:
            {
                [array2 addObject:model];
            }
                break;
            case Form_inputType_ccPeopleChoose:     //审批或者抄送
            case Form_inputType_requiredPeopleChoose:
                [array3 addObject:model];
                break;
            case Form_inputType_multiChoose:        //多选或者单选
            case Form_inputType_singleChoose:
                [array4 addObject:model];
                break;
                
                
            case Form_inputType_approvePeriod:      //审批期限 － 数组只存放审批期限
                [array5 addObject:model];
                
                break;
                
            case Form_inputType_file:               //文件
                [array6 addObject:model];
                break;
            default:
                break;
        }
    }
    
    NSMutableArray *result = [NSMutableArray array];
    if ([array1 count]) [result addObject:array1];
    if ([array2 count]) [result addObject:array2];
    if ([array3 count]) [result addObject:array3];
    if ([array4 count]) [result addObject:array4];
    if ([array5 count]) {
        if (array5.count == 1) {  //&& [[array5[0] labelText] isEqualToString:@"期限"]
            NewApplyFormBaseModel *tempModel = [[NewApplyFormBaseModel alloc] init];
            tempModel.labelText = LOCAL(APPLY_ADD_PRIORITY_TITLE);
            tempModel.inputType = Coustom_inputtype_Switch;
            [array5 insertObject:tempModel atIndex:0];
        }
        [result addObject:array5];
    }
    if ([array6 count]) [result addObject:array6];
    
    self.showFormModels = result;
}


//为了详情
- (void)sortForUI {
    NSMutableArray *array1 = [NSMutableArray array]; // 放textInput
    NSMutableArray *array2 = [NSMutableArray array]; // choose
    NSMutableArray *array3 = [NSMutableArray array]; // time
    NSMutableArray *array4 = [NSMutableArray array]; // people file
    
    for (NewApplyFormBaseModel *model in self.arrFormModels) {
        switch (model.inputType) {
            case Form_inputType_textArea:
            case Form_inputType_textInput:
				if (model.inputDetail) {
					[array1 addObject:model];
				}
                break;
            case Form_inputType_multiChoose:
            case Form_inputType_singleChoose:
                [array2 addObject:model];
                break;
            case Form_inputType_timeSlot:
            case Form_inputType_timePoint:
            case Form_inputType_approvePeriod:
				if (model.inputDetail) {
					[array3 addObject:model];
				}
                break;
            case Form_inputType_ccPeopleChoose:
            case Form_inputType_requiredPeopleChoose:
            case Form_inputType_file:
                [array4 addObject:model];
                break;
            default:
                break;
        }
    }
    
    NSMutableArray *result = [NSMutableArray arrayWithObject:@[]];
    if ([array1 count]) [result addObject:array1];
    if ([array2 count]) [result addObject:array2];
    if ([array3 count]) [result addObject:array3];
    if ([array4 count]) [result addObject:array4];
    
    // 第一个放着为了自定义画面
    self.showFormModels = result;
}

@end
