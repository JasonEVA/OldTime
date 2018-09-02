//
//  NewApplyFormChooseModel.m
//  launcher
//
//  Created by williamzhang on 16/4/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyFormChooseModel.h"
#import "NSDictionary+SafeManager.h"

@implementation NewApplyFormChooseModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super initWithDict:dict];
    if (self) {
        _chooseArray = [dict valueArrayForKey:@"data"];
    }
    return self;
}

- (NSString *)handleInputType:(NSDictionary *)dict {
    NSString *inputType = [super handleInputType:dict];
    
    if ([inputType isEqualToString:@"RadioButton"]) {
        self.inputType = Form_inputType_singleChoose;
    }
    else if ([inputType isEqualToString:@"CheckBox"]) {
        self.inputType = Form_inputType_multiChoose;
    }
    
    return inputType;
}

- (id)formDataValue {
    if (![self.try_inputDetail firstObject]) {
        return nil;
    }
    
    if (self.inputType == Form_inputType_singleChoose) {
        return [self.try_inputDetail firstObject];
    }
    
    return self.try_inputDetail;
}

@end
