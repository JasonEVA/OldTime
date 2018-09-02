//
//  HMSessionListInteractor.m
//  HMClient
//
//  Created by jasonwang on 2017/10/19.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSessionListInteractor.h"
#import "HMClientGroupChatModel.h"
#import "ServiceTeamConversationViewController.h"

@interface HMSessionListInteractor ()<TaskObserver>
@property (nonatomic) NSInteger teamStaffId;
@property (nonatomic, retain) NSNumber* numTeamId;
@property (nonatomic, retain) NSArray* staffs;
@property (nonatomic, readonly) NSString* teamName;
@property (nonatomic, strong) UIViewController *fatherVC;
@property (nonatomic, copy) NSString *IMGroupId;
@end
@implementation HMSessionListInteractor

+ (instancetype)sharedInstance {
    static HMSessionListInteractor *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HMSessionListInteractor alloc] init];
    });
    return sharedInstance;
}

- (void)goToSessionList {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UITabBarController *controller = (UITabBarController *)rootViewController;
    UINavigationController *navi = controller.selectedViewController;
    [navi popToRootViewControllerAnimated:NO];
    controller.selectedIndex = 4;
    
}

- (void)gotoChatVCWithFatherVC:(UIViewController *)fatherVC IMGroupId:(NSString *)IMGroupId{
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceStaffTeamTask" taskParam:nil TaskObserver:self];
    [fatherVC.view showWaitView];
    self.fatherVC = fatherVC;
    self.IMGroupId = IMGroupId;
    
}

- (void)gotoBuyService {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UITabBarController *controller = (UITabBarController *)rootViewController;
    UINavigationController *navi = controller.selectedViewController;
    [navi popToRootViewControllerAnimated:NO];
    controller.selectedIndex = 2;
}



#pragma mark - TaskObserver
- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage{
    if (errorMessage.length > 0) {
        [self.fatherVC.view closeWaitView];
        [self.fatherVC showAlertMessage:errorMessage];
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self.fatherVC.view closeWaitView];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"ServiceStaffTeamTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            NSNumber* numTeamId = [dicResult valueForKey:@"teamId"];
            if (numTeamId && [numTeamId isKindOfClass:[NSNumber class]])
            {
                [self setNumTeamId:numTeamId];
            }
            NSNumber* numTeamStaffId = [dicResult valueForKey:@"teamStaffId"];
            if (numTeamStaffId && [numTeamStaffId isKindOfClass:[NSNumber class]])
            {
                self.teamStaffId = numTeamStaffId.integerValue;
            }
            NSArray* items = [dicResult valueForKey:@"list"];
            if (items && [items isKindOfClass:[NSArray class]])
            {
                [self setStaffs:items];
            }
            
            NSString* teamName = [dicResult valueForKey:@"teamName"];
            if (teamName && [teamName isKindOfClass:[NSString class]])
            {
                _teamName = teamName;
            }
            
            HMClientGroupChatModel *model = [[HMClientGroupChatModel alloc] init];
            model.staffs = self.staffs;
            model.numTeamId = self.numTeamId;
            model.grouptargetId = self.IMGroupId;
            model.teamStaffId = self.teamStaffId;
            model.teamName = self.teamName;
            //            [HMViewControllerManager createViewControllerWithControllerName:@"ServiceTeamConversationViewController" ControllerObject:model];
            ServiceTeamConversationViewController *VC = [[ServiceTeamConversationViewController alloc] initWithChatModel:model];
            
            [self.fatherVC.navigationController pushViewController:VC animated:YES];
        }
    }

}
@end
