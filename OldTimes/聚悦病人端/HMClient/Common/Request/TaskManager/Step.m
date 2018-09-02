//
//  Step.m
//  HealthManagerDoctorDemo
//
//  Created by yinqaun on 16/1/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "Step.h"

@implementation Step

@synthesize stepErrorMessage = _stepErrorMessage;
@synthesize stepResult = _stepResult;
@synthesize stepError = _stepError;


- (EStepErrorCode) runStep
{
    return StepError_None;
}

@end
