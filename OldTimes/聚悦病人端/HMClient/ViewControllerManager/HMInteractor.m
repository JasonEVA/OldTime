//
//  HMInteractor.m
//  HMClient
//
//  Created by jasonwang on 2016/10/11.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMInteractor.h"
#import "HMClientGroupChatModel.h"
#import "ServiceTeamConversationViewController.h"
#import "HMBaseNavigationViewController.h"

@interface HMInteractor ()<TaskObserver>
@property (nonatomic) NSInteger teamStaffId;
@property (nonatomic, retain) NSNumber* numTeamId;
@property (nonatomic, retain) NSArray* staffs;
@property (nonatomic, readonly) NSString* teamName;

@property (nonatomic, strong) UIViewController *fatherVC;

@end

@implementation HMInteractor

+ (instancetype)sharedInstance {
    static HMInteractor *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HMInteractor alloc] init];
    });
    return sharedInstance;
}

- (void)gotoChatVCWithFatherVC:(UIViewController *)fatherVC{
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceStaffTeamTask" taskParam:nil TaskObserver:self];
    [fatherVC.view showWaitView];
    self.fatherVC = fatherVC;

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
                NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
                [dicPost setValue:[NSString stringWithFormat:@"%ld", numTeamId.integerValue] forKey:@"teamId"];
                
                [[TaskManager shareInstance] createTaskWithTaskName:@"TeamImGroupIdTask" taskParam:dicPost TaskObserver:self];
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
        }
    }
    else if ([taskname isEqualToString:@"TeamImGroupIdTask"])
    {
        [self.fatherVC.view closeWaitView];
        if (taskResult && [taskResult isKindOfClass:[NSString class]])
        {
            NSString* targetId = (NSString*) taskResult;
            if (!targetId || targetId.length == 0) {
                [self.fatherVC showAlertMessage:@"获取群UID为空,请联系管理员"];
                NSLog(@"获取群UID为空");
                return;
            }
            
            NSString *grouptargetId = (NSString*) taskResult;
            
            
            
            HMClientGroupChatModel *model = [[HMClientGroupChatModel alloc] init];
            model.staffs = self.staffs;
            model.numTeamId = self.numTeamId;
            model.grouptargetId = grouptargetId;
            model.teamStaffId = self.teamStaffId;
            model.teamName = self.teamName;
//            [HMViewControllerManager createViewControllerWithControllerName:@"ServiceTeamConversationViewController" ControllerObject:model];
            ServiceTeamConversationViewController *VC = [[ServiceTeamConversationViewController alloc] initWithChatModel:model];
            HMBaseNavigationViewController *navi = [[HMBaseNavigationViewController alloc] initWithRootViewController:VC];

            [self.fatherVC presentViewController:navi animated:YES completion:nil];
            
            
        }
        
    }
}

@end
