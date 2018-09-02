//
//  NewApplyFormPeriodModel.m
//  launcher
//
//  Created by williamzhang on 16/4/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyFormPeriodModel.h"
#import "NSDictionary+SafeManager.h"
@implementation NewApplyFormPeriodModel

- (NSString *)handleInputType:(NSDictionary *)dict {
    NSString *inputType = [super handleInputType:dict];
    
    if ([inputType isEqualToString:@"ApprovePeriod"]) {
        self.inputType = Form_inputType_approvePeriod;
    }
    
    return inputType;
}

- (id)formDataValue {
    if (!self.try_inputDetail) {
        return nil;
    }
    BOOL number = NO;
    long long deadlinde = 0;
    if ([self.try_inputDetail isKindOfClass:[NSDictionary class]]) {
         number =  [self.try_inputDetail valueBoolForKey:@"isDeadLineAllDay"];
         deadlinde = [[self.try_inputDetail valueForKey:@"deadline"] timeIntervalSince1970] * 1000;
    }else
    {
        deadlinde = [self.try_inputDetail timeIntervalSince1970] *1000;
    }
    
    return @{NewForm_deadline:deadlinde > 0?@(deadlinde):[NSNull null],NewForm_isDeadLineAllDay:[NSNumber numberWithInteger:number]};
}

@end
