//
//  NewApplyFormBaseModel.h
//  launcher
//
//  Created by williamzhang on 16/4/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  表单基类

#import <Foundation/Foundation.h>

static NSString *const Form_Dict_inputType = @"inputType";
static NSString *const Form_Dict_labelText = @"labelText";
static NSString *const Form_Dict_required  = @"required";
static NSString *const Form_Dict_selected  = @"selected";
static NSString *const Form_Dict_key       = @"key";
static NSString *const Form_Dict_rule       = @"rule";

typedef NS_ENUM(NSUInteger, Form_inputType) {
    Form_inputType_unknown = 0,
    Form_inputType_textInput,
    Form_inputType_textArea,
    Form_inputType_singleChoose,
    Form_inputType_multiChoose,
    Form_inputType_timePoint,
    Form_inputType_timeSlot,
    Form_inputType_requiredPeopleChoose,
    Form_inputType_ccPeopleChoose,
    Form_inputType_approvePeriod,  //审批期限
    Form_inputType_file,
    Coustom_inputtype_Switch
};

@interface NewApplyFormBaseModel : NSObject

@property (nonatomic, readonly) NSDictionary *originalDictionary;

@property (nonatomic, assign) Form_inputType inputType;
@property (nonatomic, strong) NSString *labelText;
@property (nonatomic, assign) BOOL required;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, copy) NSString *rule;

- (instancetype)initWithDict:(NSDictionary *)dict;
/// 仅在model内部使用 必须继承
- (NSString *)handleInputType:(NSDictionary *)dict;

// ************** use for request **************//
- (NSDictionary *)formData;
- (id)formDataValue;
// ************** use for request **************//

/// 清理try_inputDetail
- (void)removeTryAction;

/// 详情时的数据
@property (nonatomic, strong) id inputDetail;
/// 存储新建、编辑时的数据
@property (nonatomic, strong) id try_inputDetail;

@end
