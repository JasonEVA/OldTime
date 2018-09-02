//
//  Task.m
//  HealthManagerDoctorDemo
//
//  Created by yinqaun on 16/1/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "Task.h"

@implementation Task
@synthesize taskError = _taskError;
@synthesize taskErrorMessage = _taskErrorMessage;
@synthesize taskResult = _taskResult;


- (id)initWithTaskId:(NSString*) taskId
{
    self = [super init];
    if (self)
    {
        _taskId = [NSString stringWithFormat:@"%@", taskId];
        NSDictionary* dicTaskId = [NSDictionary JSONValue:taskId];
        id param = [dicTaskId valueForKey:@"param"];
        if (param)
        {
            taskParam = param;
        }
    }
    return self;
}

- (id)initWithTaskId:(NSString*) taskId ExtParam:(id) aExtParam
{
    self = [super init];
    if (self)
    {
        _taskId = [NSString stringWithFormat:@"%@", taskId];
        NSDictionary* dicTaskId = [NSDictionary JSONValue:taskId];
        id param = [dicTaskId valueForKey:@"param"];
        if (param)
        {
            taskParam = param;
            //extParam = aExtParam;
        }
        if (aExtParam)
        {
            _extParam = aExtParam;
        }
        
    }
    return self;
}

- (Step*)createFristStep
{
    return nil;
}

- (Step*)createNextStep
{
    return nil;
}

- (Step*)createNextWithError
{
    return nil;
}

- (void)makeTaskResult
{
    _taskResult = currentStep.stepResult;
}

- (void)main
{
    [self runTask];
}

- (void)runTask
{
    _taskError = StepError_None;
    currentStep = [self createFristStep];
    while (currentStep)
    {
        _taskError = [currentStep runStep];
        if (StepError_None == _taskError)
        {
            [self makeTaskResult];
            currentStep = [self createNextStep];
            continue;
        }
        
        _taskError = currentStep.stepError;
        _taskErrorMessage = currentStep.stepErrorMessage;
        
        currentStep = [self createNextWithError];
    }
    
    if (StepError_None == _taskError)
    {
        [self postTaskResult];
    }
    
    [self postTaskFinish];
}

- (void) postTaskResult
{
    NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
    [dicResult setValue:self.taskId forKey:kTaskIdKey];
    [dicResult setValue:self.taskResult forKey:kTaskResultKey];
    
    TaskManager* taskMgr = [TaskManager shareInstance];
    [taskMgr performSelectorOnMainThread:@selector(onTaskPostResult:) withObject:dicResult waitUntilDone:YES];
}

- (void) postTaskFinish
{
    TaskManager* taskMgr = [TaskManager shareInstance];
    [taskMgr performSelectorOnMainThread:@selector(onTaskFinished:) withObject:_taskId waitUntilDone:YES];
}

- (void) postTaskProgress:(NSInteger) posted Total:(NSInteger) total
{
    TaskManager* taskMgr = [TaskManager shareInstance];
    NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
    [dicResult setValue:self.taskId forKey:kTaskIdKey];
    [dicResult setValue:[NSNumber numberWithInteger:posted] forKey:kTaskPostedBytesKey];
    [dicResult setValue:[NSNumber numberWithInteger:total] forKey:kTaskTotalBytesKey];
    [taskMgr performSelectorOnMainThread:@selector(onTaskPostProgress:) withObject:dicResult waitUntilDone:YES];
}

@end
