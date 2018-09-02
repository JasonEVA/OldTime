//
//  Step.h
//  HealthManagerDoctorDemo
//
//  Created by yinqaun on 16/1/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum EStepErrorCode
{
    StepError_None,
    StepError_NetworkInvalid,
    StepError_InvalidParam,
    StepError_NetworkRequestError,
    StepError_NetwordDataError,
    
}EStepErrorCode;

@interface Step : NSObject
{
    id _stepResult;
}

@property (nonatomic) EStepErrorCode stepError;
@property (nonatomic, readonly) id stepResult;
@property (nonatomic, assign) NSString* stepErrorMessage;
@property (nonatomic, assign) int tag;

- (EStepErrorCode) runStep;
@end
