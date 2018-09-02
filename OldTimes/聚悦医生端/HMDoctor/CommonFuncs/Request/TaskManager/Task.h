//
//  Task.h
//  HealthManagerDoctorDemo
//
//  Created by yinqaun on 16/1/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Step.h"

#define kTaskIdKey      @"TaskId"
#define kTaskResultKey  @"TaskResult"

#define kTaskPostedBytesKey      @"postedbytes"
#define kTaskTotalBytesKey  @"totalbytes"

@interface Task : NSObject
{
@protected
    Step* currentStep;
    
    EStepErrorCode _taskError;
    NSString* _taskErrorMessage;
    id taskParam;
    NSString* taskQuery;
    id _taskResult;
}


@property (nonatomic, retain) id extParam;

@property (nonatomic, readonly) NSString* taskId;
@property (nonatomic, readonly) EStepErrorCode taskError;
@property (nonatomic, readonly) NSString* taskErrorMessage;
@property (nonatomic, readonly) id taskResult;

- (id) initWithTaskId:(NSString*) taskId;

- (id) initWithTaskId:(NSString*) taskId ExtParam:(id) extParam;

- (void) runTask;

- (void) postTaskResult;
//- (void) postTaskProgress:(NSInteger) posted Total:(NSInteger) total;
- (void) makeTaskResult;
@end
