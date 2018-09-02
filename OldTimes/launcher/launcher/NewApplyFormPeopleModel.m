//
//  NewApplyFormPeopleModel.m
//  launcher
//
//  Created by williamzhang on 16/4/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyFormPeopleModel.h"
#import "NSDictionary+SafeManager.h"

@implementation NewApplyFormPeopleModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super initWithDict:dict];
    if (self) {
        _single = [dict valueBoolForKey:@"single"];
    }
    return self;
}

- (NSString *)handleInputType:(NSDictionary *)dict {
    NSString *inputType = [super handleInputType:dict];
    
    if ([inputType isEqualToString:@"ApprovePerson"]) {
        self.inputType = Form_inputType_requiredPeopleChoose;
    }
    else if ([inputType isEqualToString:@"CCPerson"]) {
        self.inputType = Form_inputType_ccPeopleChoose;
    }
    
    return inputType;
}

@end
