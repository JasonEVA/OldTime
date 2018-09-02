//
//  MainStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MainStartViewController.h"
#import "InitializationHelper.h"
#import "SiteMessageViewController.h"
#import "HealthCenterDoctorGreetingViewController.h"
#import "ScanQRCodeViewController.h"
#import "GetMessageListCount.h"
#import "ATModuleInteractor+NewSiteMessage.h"

@interface MainStartViewController ()<TaskObserver>
{
    UIViewController* vcContent;
    BOOL userHasService;
    //BOOL heightChanged;
    
    UIView* contentView;
}
@property (nonatomic, strong) UIView *redPoint;

@end

@implementation MainStartViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //请求查看是否有医生问候信息
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",curUser.userId] forKey:@"userId"];
    [dicPost setValue:@"1" forKey:@"careWay"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"DoctorGreetingTask" taskParam:dicPost TaskObserver:self];
    
    [self changeContentViewController];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"我的专家团队"];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    userHasService = [self userHasService];
    
    UIImageView * rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_ic_tz"]];
    [rightImage setUserInteractionEnabled:YES];
    [rightImage addSubview:self.redPoint];
    
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightImage.mas_right).offset(-3);
        make.centerY.equalTo(rightImage.mas_top).offset(3);
        make.width.height.equalTo(@12);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoMessageVcAction)];
    [rightImage addGestureRecognizer:tap];
    
    UIBarButtonItem* bbiAlert = [[UIBarButtonItem alloc] initWithCustomView:rightImage];
    [self.navigationItem setRightBarButtonItem:bbiAlert];

    //navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    contentView = [[UIView alloc] init];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    UIButton *scanerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanerButton setFrame:CGRectMake(0, 0, 30, 30)];
    [scanerButton setImage:[UIImage imageNamed:@"icon_scan"] forState:UIControlStateNormal];
    UIBarButtonItem *scanerItem = [[UIBarButtonItem alloc] initWithCustomView:scanerButton];
    self.navigationItem.leftBarButtonItem = scanerItem;
    [scanerButton addTarget:self action:@selector(scanerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString* contentName = [self contentViewControllerName];
    if (vcContent)
    {
        if ([NSStringFromClass([vcContent class]) isEqualToString:contentName])
        {
            return;
        }
        [vcContent.view removeFromSuperview];
        [vcContent removeFromParentViewController];
    }
    
    vcContent = [[NSClassFromString(contentName) alloc]init];
    [self addChildViewController:vcContent];
    [contentView addSubview:vcContent.view];
    [vcContent.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageListCountAction) name:MTBadgeCountChangedNotification object:nil];

}

- (void) changeContentViewController
{
    if (userHasService == [self userHasService]) {
        return;
    }
    userHasService = [self userHasService];
    
    NSString* contentName = [self contentViewControllerName];
    if (vcContent)
    {
        if ([NSStringFromClass([vcContent class]) isEqualToString:contentName])
        {
            return;
        }
        [vcContent.view removeFromSuperview];
        [vcContent removeFromParentViewController];
    }
    
    vcContent = [[NSClassFromString(contentName) alloc]init];
    [self addChildViewController:vcContent];
    [contentView addSubview:vcContent.view];
    [vcContent.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
}

#pragma mark - privateMethod
- (void)scanerButtonClick:(UIButton *)sender
{
//    ScanQRCodeViewController *vc = [[ScanQRCodeViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    [HMViewControllerManager createViewControllerWithControllerName:@"ScanQRCodeViewController" ControllerObject:nil];
}

//进入站内信
- (void)gotoMessageVcAction
{
    [[ATModuleInteractor sharedInstance] gotoNewSiteMessageMainListVC];
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:[NSString stringWithFormat:@"站内信"]];
}

- (BOOL)userHasService
{
    InitializationHelper* helper = [InitializationHelper defaultHelper];
    if (helper.userHasService) {
        return YES;
    }
    return NO;
}
- (void)getMessageListCountAction
{
    //获取推送类型的session，根据未读数判断红点显示
    [[MessageManager share] querySessionDataWithUid:@"PUSH@SYS" completion:^(ContactDetailModel *model) {
        [self.redPoint setHidden:!model._countUnread];
    }];
}


- (NSString*) contentViewControllerName
{
    NSString* classname = @"MainStartWithoutServiceTableViewController";
    if ([self userHasService])
    {
        //#import "MainStartWithServiceTableViewController.h"
        classname = @"MainStartWithServiceTableViewController";
        
    }
    return classname;
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
            NSArray* greetingList = (NSArray *)taskResult;
            
            if (greetingList.count <= 0)
            {
                return;
            }
            HealthCenterDoctorGreetingViewController *vcDoctorGreeting = [[HealthCenterDoctorGreetingViewController alloc] init];
            vcDoctorGreeting.greetingsList = greetingList;
            [self.view.window.rootViewController presentViewController:vcDoctorGreeting animated:YES completion:nil];
        }
    }
}

- (UIView *)redPoint {
    if (!_redPoint) {
        _redPoint = [UIView new];
        [_redPoint setBackgroundColor:[UIColor redColor]];
        [_redPoint.layer setCornerRadius:6];
        [_redPoint.layer setBorderColor:[[UIColor colorWithHexString:@"ffffff"] CGColor]];
        [_redPoint.layer setBorderWidth:1];
        [_redPoint setHidden:YES];
    }
    return _redPoint;
}

@end
