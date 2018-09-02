//
//  TaskManager.h
//  HealthManagerDoctorDemo
//
//  Created by yinqaun on 16/1/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@protocol TaskObserver <NSObject>

@optional
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage;
- (void) task:(NSString*) taskId PostProgress:(NSInteger) postedUnit Total:(NSInteger) totalUnit;
- (void) task:(NSString *)taskId Result:(id) taskResult;

@end

@interface TaskObserverItem : NSObject
{
    
}
@property (nonatomic, weak) id<TaskObserver> delegate;
@end


@interface TaskManager : NSObject
{
    
}

+ (TaskManager*) shareInstance;

- (Task*) createTaskWithTaskName:(NSString*) taskname
                       taskParam:(NSDictionary*) taskParam
                    TaskObserver:(id<TaskObserver>) observer;

- (Task*) createTaskWithTaskName:(NSString*) taskname
                       taskParam:(NSDictionary*) taskParam
                        extParam:(id) extParam
                    TaskObserver:(id<TaskObserver>) observer;

+ (NSString*) tasknameWithTaskId:(NSString*) taskId;
+ (id) taskparamWithTaskId:(NSString*) taskId;
@end
