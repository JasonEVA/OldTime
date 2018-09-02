//
//  NewApplyFormTextInputModel.m
//  launcher
//
//  Created by williamzhang on 16/4/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyFormTextInputModel.h"
#import "NSDictionary+SafeManager.h"

@implementation NewApplyFormTextInputModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super initWithDict:dict];
    if (self) {
        _placeholder = [dict valueStringForKey:@"placeholder"];
    }
    return self;
}

- (NSString *)handleInputType:(NSDictionary *)dict {
    NSString *inputType = [super handleInputType:dict];
    if ([inputType isEqualToString:@"TextInput"]) {
        self.inputType = Form_inputType_textInput;
    }
    else if ([inputType isEqualToString:@"TextArea"]) {
        self.inputType = Form_inputType_textArea;
    }
    return inputType;
}

- (id)formDataValue {
    return self.try_inputDetail;
}

@end
