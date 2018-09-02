//
//  Step.h
//  HealthManagerDoctorDemo
//
//  Created by yinqaun on 16/1/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpTaskProgressDelegate.h"

typedef enum EStepErrorCode
{
    StepError_None,
    StepError_NetworkInvalid,
    StepError_InvalidParam,
    StepError_NetworkRequestError,
    StepError_NetwordDataError,
    StepError_PathNoFound,
    StepError_CacheOverdue,
    StepError_ReadDataError,
}EStepErrorCode;


@interface Step : NSObject
{
    id _stepResult;
}

@property (nonatomic) EStepErrorCode stepError;
@property (nonatomic, readonly) id stepResult;
@property (nonatomic, assign) NSString* stepErrorMessage;
@property (nonatomic, assign) int tag;

@property (nonatomic, weak) id<HttpTaskProgressDelegate> progressDelegate;

- (EStepErrorCode) runStep;
@end
