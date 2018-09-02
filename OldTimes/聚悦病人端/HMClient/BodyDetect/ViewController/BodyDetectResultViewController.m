//
//  BodyDetectResultViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/9.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyDetectResultViewController.h"
#import "BodyDetectStartViewController.h"
#import "UIBarButtonItem+BackExtension.h"
#import "BloodPressureThreeDetectViewController.h"

@interface BodyDetectResultViewController ()
<TaskObserver>
{

}
@property (nonatomic, strong) UIViewController* vcPatient;
@end

@implementation BodyDetectResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.paramObject && [self.paramObject isKindOfClass:[DetectRecord class]])
    {
        detectRecord = (DetectRecord*) self.paramObject;
        recordId = detectRecord.testDataId;
        
    }

}

#pragma mark - Interface Method


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSString* taskname = [self resultTaskName];
    if (taskname)
    {
        //创建任务，获取检测结果数据
        if (recordId && [recordId isKindOfClass:[NSString class]] && 0 < recordId.length)
        {
            NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
            [dicPost setValue:recordId forKey:@"testDataId"];
            
            [self.view showWaitView];
            [[TaskManager shareInstance] createTaskWithTaskName:taskname taskParam:dicPost TaskObserver:self];
        }
    }
    
}

- (NSString*) resultTaskName
{
    return nil;
}

- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
    }
    
    
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length) {
        return;
    }
    
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:[self resultTaskName]])
    {
        if (taskResult && [taskResult isKindOfClass:[DetectResult class]])
        {
            detectResult = taskResult;
            userId = detectResult.userId;
            [self detectResultLoaded:detectResult];
        }
        
    }
}

- (BOOL) userIsSelf
{
    if (0 == userId)
    {
        return NO;
    }
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    return (curUser.userId == userId);
}

- (void) detectResultLoaded:(DetectResult*) result
{
    
}

@end
