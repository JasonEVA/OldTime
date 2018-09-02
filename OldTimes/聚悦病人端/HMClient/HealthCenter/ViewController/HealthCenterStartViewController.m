//
//  HealthCenterStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthCenterStartViewController.h"
#import "HealthCenterDetectViewController.h"
#import "InitializationHelper.h"
#import "HealthCenterDoctorGreetingViewController.h"

@interface HealthCenterStartViewController ()<TaskObserver>
{
    HealthCenterDetectViewController* vcDetect;
    UIViewController* vcContent;
    NSArray* greetingList;
}
@end

@implementation HealthCenterStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationItem setTitle:@"健康计划"];
    
    [self createDetectController];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    self.edgesForExtendedLayout = UIRectEdgeNone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //请求查看是否有医生问候信息
    /*NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",curUser.userId] forKey:@"userId"];
    [dicPost setValue:@"1" forKey:@"careWay"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"DoctorGreetingTask" taskParam:dicPost TaskObserver:self];
    
    HealthCenterDoctorGreetingViewController *vcDoctorGreeting = [[HealthCenterDoctorGreetingViewController alloc] init];
    
    [self.view.window.rootViewController presentViewController:vcDoctorGreeting animated:YES completion:nil];*/
    
    [self createCenterContentController];
}

- (void) createDetectController
{
    vcDetect = [[HealthCenterDetectViewController alloc]initWithNibName:nil bundle:nil];
    [self addChildViewController:vcDetect];
    [self.view addSubview:vcDetect.view];
    
    [vcDetect.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@145);
    }];
}



- (BOOL) userHasService
{
    InitializationHelper* helper = [InitializationHelper defaultHelper];
    if (helper.userHasService) {
        return YES;
    }
    return NO;
}

- (NSString*) contentControllerClassName
{
    //HealthCenterContentWithoutServiceViewController
    NSString* classname = @"UIViewController";
    if (![self userHasService])
    {
        classname = @"HealthCenterContentWithoutServiceViewController";
    }
    else
    {
        classname = @"HealthCenterContentWithServiceViewController";
    }
    return classname;
}

- (void) createCenterContentController
{
    NSString* contentClassName = [self contentControllerClassName];
    if (vcContent)
    {
        if ([vcContent isKindOfClass:NSClassFromString(contentClassName)])
        {
            return;
        }
        
        [vcContent.view removeFromSuperview];
        [vcContent removeFromParentViewController];
    }
    
    vcContent = [[NSClassFromString(contentClassName) alloc]init];
    [self addChildViewController:vcContent];
    [self.view addSubview:vcContent.view];
    [vcContent.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(vcDetect.view.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
}

#pragma mark TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
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
    
    if ([taskname isEqualToString:@"DoctorGreetingTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            greetingList = (NSArray *)taskResult;
            
            if (greetingList.count <= 0)
            {
                return;
            }
            HealthCenterDoctorGreetingViewController *vcDoctorGreeting = [[HealthCenterDoctorGreetingViewController alloc] init];
            
            [self.view.window.rootViewController presentViewController:vcDoctorGreeting animated:YES completion:nil];
        }
    }
}


@end
