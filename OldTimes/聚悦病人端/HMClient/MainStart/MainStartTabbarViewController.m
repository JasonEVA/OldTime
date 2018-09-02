//
//  MainStartTabbarViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MainStartTabbarViewController.h"
#import "MainStartViewController.h"
#import "HealthCenterStartViewController.h"
#import "HealthDiscoveryViewController.h"
#import "PersonSpaceStartViewController.h"
#import "SecondEditionServiceStartViewController.h"

#import "HMBaseNavigationViewController.h"
#import "MainTabbarView.h"
#import "InitializationHelper.h"
#import "ServiceTeamConversationViewController.h"
#import "HMClientGroupChatModel.h"
#import "ActionStatutManager.h"
#import "HMInteractor.h"
#import "HMPersonSpaceSecondEditionViewController.h"
#import "HMPersonSpaceNavigationController.h"
#import "SEMainStartViewController.h"
#import "HMSEHealthPlanMainViewController.h"
#import "HMClientSessionListViewController.h"

@interface MainStartTabbarViewController ()
<MainTabbarDelegate,TaskObserver>
{
    MainTabbarView* mainTabbar;
}
@property (nonatomic) NSInteger teamStaffId;
@property (nonatomic, retain) NSNumber* numTeamId;
@property (nonatomic, retain) NSArray* staffs;
@property (nonatomic, readonly) NSString* teamName;
@end

@implementation MainStartTabbarViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self setHidesBottomBarWhenPushed:YES];
    [self initControllers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryUnReadMessage) name:MTBadgeCountChangedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self initControllers];
    
    if (!mainTabbar)
    {
        //自定义Tabbar
        CGRect rtTabbar = self.tabBar.bounds;
        //[self.tabBar removeFromSuperview];
        self.tabBar.tintColor = [UIColor whiteColor];
        self.tabBar.barTintColor = [UIColor whiteColor];
        
        mainTabbar = [[MainTabbarView alloc]initWithFrame:rtTabbar];
        [self.tabBar addSubview:mainTabbar];
        //[mainTabbar setBottom:self.view.bottom];
        [mainTabbar setDelegate:self];
    }

}

- (void) queryUnReadMessage
{
    InitializationHelper* helper = [InitializationHelper defaultHelper];
    if (helper.userHasService && ![helper userHasDispatchService] &&[UserServicePrivilegeHelper userHasPrivilege:ServicePrivile_Conversation]) {
        
        [[MessageManager share] getMessageListCompletion:^(NSArray *arrayList) {
            if (arrayList.count == 0) {
                return;
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                // 患者部分
                NSPredicate *predicatePatient = [NSPredicate predicateWithFormat:@"_tag = %@ AND _countUnread > 0",im_doctorPatientGroupTag];
                NSArray <ContactDetailModel *>*arrayPatient =[arrayList filteredArrayUsingPredicate:predicatePatient];
                
                __block NSInteger allUnreadCount = 0;
                
                [arrayPatient enumerateObjectsUsingBlock:^(ContactDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    allUnreadCount += obj._countUnread;
                }];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [mainTabbar showBadge:allUnreadCount];
                });
            });
            
            
        }];
        
        [[MessageManager share] queryAllUnreadMessageCountCompletion:^(NSInteger countUnreadMsg) {
            // 设置AppIcon未读角标设置
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:countUnreadMsg];
        }];

        
    }
}

- (void) initControllers
{
    
    NSArray* vcList = self.viewControllers;
    if (vcList && 0 < vcList.count) {
        return;
    }
    
    SEMainStartViewController* vcMainStart = [[SEMainStartViewController alloc]init];
    UINavigationController* nvcMainStart = [[HMBaseNavigationViewController alloc]initWithRootViewController:vcMainStart];
    [nvcMainStart.tabBarItem setTitle:@"首页"];
    
    HMSEHealthPlanMainViewController* vcHealthCenter = [[HMSEHealthPlanMainViewController alloc]init];
    UINavigationController* nvcHealthCenter = [[HMBaseNavigationViewController alloc]initWithRootViewController:vcHealthCenter];
    [nvcHealthCenter.tabBarItem setTitle:@"健康计划"];
   

    SecondEditionServiceStartViewController* vcHealthService = [[SecondEditionServiceStartViewController alloc]init];
    UINavigationController* nvcHealthDiscovery = [[HMBaseNavigationViewController alloc]initWithRootViewController:vcHealthService];
    [nvcHealthDiscovery.tabBarItem setTitle:@"健康服务"];
    
    HMPersonSpaceSecondEditionViewController* vcPersonSpace = [[HMPersonSpaceSecondEditionViewController alloc]init];
    UINavigationController* nvcPersonSpace = [[HMBaseNavigationViewController alloc]initWithRootViewController:vcPersonSpace];
    [nvcPersonSpace setHidesBottomBarWhenPushed:YES];
    [nvcPersonSpace.tabBarItem setTitle:@"我的"];
    
    HMClientSessionListViewController *sessionListVC = [HMClientSessionListViewController new];
    UINavigationController* sessionListNavVC = [[HMBaseNavigationViewController alloc]initWithRootViewController:sessionListVC];
    [nvcHealthCenter.tabBarItem setTitle:@"会话列表"];
    
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    
    [self setViewControllers:@[nvcMainStart, nvcHealthCenter, nvcHealthDiscovery, nvcPersonSpace,sessionListNavVC]];
    
    
}

- (void) setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    
    if (!selectedIndex) { //点击首页tab刷新服务权限
        //刷新用户服务
        [[TaskManager shareInstance] createTaskWithTaskName:@"CheckUserServiceTask" taskParam:nil TaskObserver:self];
    }

    [[ActionStatutManager shareInstance] addActionStatusWithPageName:NSStringFromClass([self class])];
    if (mainTabbar)
    {
        [mainTabbar setSelectedIndex:selectedIndex];
    }
    
    UINavigationController* nvcSelect = self.selectedViewController;
    if ([nvcSelect isKindOfClass:[UINavigationController class]])
    {
        [nvcSelect popToRootViewControllerAnimated:NO];
    }
}

#pragma mark - MainTabbarDelegate
- (void) tabbarSelected:(NSInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex];
}
- (void)tabbarMainSelect {
    [mainTabbar setSelectedIndex:4];
    [self setSelectedIndex:4];
//    [self JWGoToChatVC];
}

- (void)JWGoToChatVC {
    
    InitializationHelper* helper = [InitializationHelper defaultHelper];
    if (helper.userHasService && ![helper userHasDispatchService]) {
        if ([UserServicePrivilegeHelper userHasPrivilege:ServicePrivile_Conversation] ) {
            [mainTabbar setSelectedIndex:4];
            [self setSelectedIndex:4];
        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"订购服务套餐后，将可以随时与专家团队进行图文和语音交流" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"查看套餐" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceStartViewController" ControllerObject:nil];
                
            }]];
            
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            UIViewController *topMostViewController = keyWindow.rootViewController;
            [topMostViewController presentViewController:alert animated:YES completion:nil];
            
        }
    }
    else if (!helper.userHasService && ![helper userHasDispatchService]) {
        [self showAlertMessage:@"您还没有购买服务"];
    }
    else if (!helper.userHasService && [helper userHasDispatchService]) {
        [self showAlertMessage:@"正在给您分配专属医生，请稍后再试"];
    }
    else {
        return;
    }
}

- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage{
    if (errorMessage.length > 0) {
        [self showAlertMessage:errorMessage];
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
    
}


@end
