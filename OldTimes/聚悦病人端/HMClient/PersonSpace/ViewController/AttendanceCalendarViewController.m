//
//  AttendanceCalendarViewController.m
//  HMClient
//
//  Created by yinquan on 2017/7/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "AttendanceCalendarViewController.h"

@interface AttendanceCalendarViewController ()
<TaskObserver>
{
    NSArray* attendanceModels;
}
@end

@implementation AttendanceCalendarViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString* monthString = [self.monthDate formattedDateWithFormat:@"yyyy-MM-01"];
    
    [self loadPointRedemptionRecords:monthString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadPointRedemptionRecords:(NSString*) monthString
{
    [super loadPointRedemptionRecords:monthString];
    
    NSMutableDictionary* postDictionary = [NSMutableDictionary dictionary];
    [postDictionary setValue:@1 forKey:@"type"];
    UserInfo* currentUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld", currentUser.userId] forKey:@"userId"];
//    NSString* dateString = [[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd"];
    [postDictionary setValue:monthString forKey:@"date"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"PointRedemptionMonthlyRecordTask" taskParam:postDictionary TaskObserver:self];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    if ([taskname isEqualToString:@"PointRedemptionMonthlyRecordTask"])
    {
        if (taskError != StepError_None) {
            [self showAlertMessage:errorMessage];
            return;
        }
        
        NSString* monthString = [self.monthDate formattedDateWithFormat:@"yyyy-MM"];
        
        [self setMonthlyPointRecordModels:attendanceModels];
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    if ([taskname isEqualToString:@"PointRedemptionMonthlyRecordTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* models = (NSArray*) taskResult;
//            [self setMonthlyPointRecordModels:models];
            attendanceModels = models;
        }
        
    }
}
@end
