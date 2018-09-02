//
//  TaskManager.m
//  HealthManagerDoctorDemo
//
//  Created by yinqaun on 16/1/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "TaskManager.h"

@implementation TaskObserverItem

@synthesize delegate = _delegate;

- (id) initWithObserver:(id<TaskObserver>) observer
{
    self= [super init];
    if (self && observer)
    {
        [self setDelegate:observer];
    }
    return self;
}

@end

static TaskManager* defaultTaskManager = nil;

@interface TaskManager ()
{
    NSMutableDictionary* dicTasks;
    NSMutableDictionary* dicObservices;
    
    NSOperationQueue* qImmediate;
    NSOperationQueue* qLimited;
}
@end


@implementation TaskManager

+ (TaskManager*) shareInstance
{
    if (!defaultTaskManager)
    {
        defaultTaskManager = [[TaskManager alloc]init];
    }
    return defaultTaskManager;
}

+ (NSString*) tasknameWithTaskId:(NSString*) taskId
{
    if (!taskId || 0 == taskId.length)
    {
        return nil;
    }
    
    NSDictionary* dicTaskId = [NSDictionary JSONValue:taskId];
    if (!dicTaskId || ![dicTaskId isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    
    NSString* taskname = [dicTaskId valueForKey:@"taskname"];
    if (taskname && [taskname isKindOfClass:[NSString class]] && 0 < taskname.length)  {
        return taskname;
    }
    
    return nil;
}

+ (id) taskparamWithTaskId:(NSString*) taskId
{
    if (!taskId || 0 == taskId.length)
    {
        return nil;
    }
    
    NSDictionary* dicTaskId = [NSDictionary JSONValue:taskId];
    if (!dicTaskId || ![dicTaskId isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    
    id param = [dicTaskId valueForKey:@"param"];
    if (!param || [param isEqual:[NSNull null]])
    {
        return nil;
    }
    return param;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        dicTasks = [NSMutableDictionary dictionary];
        dicObservices = [NSMutableDictionary dictionary];
        
        qImmediate = [[NSOperationQueue alloc]init];
        qLimited = [[NSOperationQueue alloc]init];
        [qLimited setMaxConcurrentOperationCount:5];
    }
    return self;
}

- (Task*) createTaskWithTaskName:(NSString*) taskname
                       taskParam:(NSDictionary*) taskParam
                    TaskObserver:(id<TaskObserver>) observer
{
    if (!taskname || 0 == taskname.length)
    {
        return nil;
    }
    
    NSMutableDictionary* dicTaskId = [NSMutableDictionary dictionary];
    [dicTaskId setValue:taskname forKey:@"taskname"];
    if (taskParam)
    {
        [dicTaskId setValue:taskParam forKey:@"param"];
    }
    
    //NSString* taskId = [[NSString alloc] initWithData:[dicTaskId objectJsonString] encoding:NSUTF8StringEncoding];
    NSString* taskId = [dicTaskId objectJsonString];
    
    Task* task = [dicTasks valueForKey:taskId];
    if (task)
    {
        [self addTaskObserver:observer TaskId:taskId];
        return task;
    }

    Class taskclass = NSClassFromString(taskname);
    if (!taskclass)
    {
        return nil;
    }
    task = [[taskclass alloc]initWithTaskId:taskId];
    
    [self addTaskObserver:observer TaskId:taskId];
    [dicTasks setValue:task forKey:taskId];
    
    [self runTask:task];
    return task;
}

- (Task*) createTaskWithTaskName:(NSString*) taskname
                       taskParam:(NSDictionary*) taskParam
                        extParam:(id) extParam
                    TaskObserver:(id<TaskObserver>) observer
{
    if (!taskname || 0 == taskname.length)
    {
        return nil;
    }
    
    NSMutableDictionary* dicTaskId = [NSMutableDictionary dictionary];
    [dicTaskId setValue:taskname forKey:@"taskname"];
    if (taskParam)
    {
        [dicTaskId setValue:taskParam forKey:@"param"];
    }
    
    //NSString* taskId = [[NSString alloc] initWithData:[dicTaskId objectJsonString] encoding:NSUTF8StringEncoding];
    NSString* taskId = [dicTaskId objectJsonString];
    
    Task* task = [dicTasks valueForKey:taskId];
    if (task)
    {
        [self addTaskObserver:observer TaskId:taskId];
        return task;
    }
    
    Class taskclass = NSClassFromString(taskname);
    if (!taskclass)
    {
        return nil;
    }
    task = [[taskclass alloc]initWithTaskId:taskId ExtParam:extParam];
    
    [self addTaskObserver:observer TaskId:taskId];
    [dicTasks setValue:task forKey:taskId];
    
    [self runTask:task];
    return task;
}

- (void) runTask:(Task*) task
{
    if (!task)
    {
        return;
    }
    //NSOperation* operate = [NSOperation alloc]ini
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:task
                                                                           selector:@selector(runTask)
                                                                             object:nil];
    [qImmediate addOperation:operation];
}

- (void) addTaskObserver:(id<TaskObserver>) observer TaskId:(NSString*) taskId
{
    if (!taskId || !observer)
    {
        return;
    }
    
    NSMutableArray* observers = [dicObservices valueForKey:taskId];
    if (!observers)
    {
        observers = [NSMutableArray array];
        [dicObservices setValue:observers forKey:taskId];
    }
    
    for (TaskObserverItem* item in observers)
    {
        if (observer == item.delegate)
        {
            return;
        }
    }
    
    TaskObserverItem* observerItem = [[TaskObserverItem alloc]initWithObserver:observer];
    [observers addObject:observerItem];
}





- (void) onTaskPostResult:(NSDictionary*) dicResult
{
    if (!dicResult)
    {
        return;
    }
    NSString* taskId = [dicResult valueForKey:kTaskIdKey];
    id result = [dicResult valueForKey:kTaskResultKey];
    
    [self task:taskId Result:result];
}

//- (void) onTaskPostProgress:(NSDictionary*) dicProgress
//{
//    if (!dicProgress)
//    {
//        return;
//    }
//    NSString* taskId = [dicProgress valueForKey:kTaskIdKey];
//    NSNumber* numPosted = [dicProgress valueForKey:kTaskPostedBytesKey];
//    NSNumber* numTotal = [dicProgress valueForKey:kTaskTotalBytesKey];
//    
//    [self task:taskId PostedByte:numPosted.integerValue TotalBytes:numTotal.integerValue];
//}

- (void) onTaskFinished:(NSString*) taskId
{
    NSLog(@"onTaskFinished..%@", taskId);
    if (!taskId)
    {
        return;
    }
    
    Task* task = [dicTasks valueForKey:taskId];
    EStepErrorCode taskErr = StepError_None;
    NSString* taskErrMsg = nil;
    
    if (task)
    {
        taskErr = task.taskError;
        taskErrMsg = task.taskErrorMessage;
    }
    NSMutableArray* observices = nil;
    if (!dicObservices)
    {
        goto END;
    }
    
    observices = [dicObservices valueForKey:taskId];
    
    if (!observices || 0 == observices.count)
    {
        goto END;
    }
    
    for (TaskObserverItem* item in observices)
    {
        id<TaskObserver> observer = item.delegate;
        if ( observer && [observer respondsToSelector:@selector(task:FinishError:ErrorMessage:)])
        {
            [observer task:taskId FinishError:taskErr ErrorMessage:taskErrMsg];
        }
    }
    
    
END:
    [dicObservices removeObjectForKey:taskId];
    [dicTasks removeObjectForKey:taskId];
}


- (void) removeTaskObserver:(NSString*) taskId
{
    
}

- (void) task:(NSString*) taskId Result:(id)taskResult
{
    if (!taskId)
    {
        return;
    }
    
    NSMutableArray* observices = [dicObservices valueForKey:taskId];
    if (!observices || 0 == observices.count)
    {
        return;
    }
    
    for (TaskObserverItem* item in observices)
    {
        id<TaskObserver> observer = item.delegate;
        if (observer && [observer respondsToSelector:@selector(task:Result:)])
        {
            [observer task:taskId Result:taskResult];
        }
    }
}

@end
