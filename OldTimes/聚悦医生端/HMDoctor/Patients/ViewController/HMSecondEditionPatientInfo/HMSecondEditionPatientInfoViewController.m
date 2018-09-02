//
//  HMSecondEditionPatientInfoViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2016/11/24.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMSecondEditionPatientInfoViewController.h"
#import "HMSecondEditionFreePatientInfoViewController.h"
#import "HMSecondEditionPationInfoModel.h"
#import "HMSecondEditionPaidPatientInfoViewController.h"

@interface HMSecondEditionPatientInfoViewController ()<TaskObserver>
@property (nonatomic, strong) HMSecondEditionPationInfoModel *model;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, readwrite)  BOOL  needRequestUserInfo; // <##>

@end

@implementation HMSecondEditionPatientInfoViewController

- (instancetype)initWithUserID:(NSString *)userID {
    self = [super init];
    if (self) {
        _userId = userID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"基本信息"];
    // Do any additional setup after loading the view.
    self.needRequestUserInfo = YES;
    [self startPatientInfoRequest];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)reloadPatientInfoWithUserID:(NSString *)userID {
    self.userId = userID;
    [self startPatientInfoRequest];
}

#pragma mark - Private Method
- (void)startPatientInfoRequest {
    if (!self.userId || self.userId.length == 0) {
        return;
    }
    //获取患者的服务
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:self.userId forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceStaffTeamTask" taskParam:dicPost TaskObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addFreePatientVC {
    HMSecondEditionFreePatientInfoViewController *freeVC = [[HMSecondEditionFreePatientInfoViewController alloc] initWithPatientModel:self.model];
    [self.view addSubview:freeVC.view];
    [self addChildViewController:freeVC];
    [freeVC didMoveToParentViewController:self];
    [freeVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)addPaidParientVC {
    HMSecondEditionPaidPatientInfoViewController *paidVC = [[HMSecondEditionPaidPatientInfoViewController alloc] initWithPatientModel:self.model];
    [self.view addSubview:paidVC.view];
    [self addChildViewController:paidVC];
    [paidVC didMoveToParentViewController:self];
    [paidVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - request Delegate
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError ) {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
}
- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"ServiceStaffTeamTask"])
    {
        NSDictionary* dicResult = (NSDictionary*) taskResult;
        NSNumber* numTeamStaffId = [dicResult valueForKey:@"teamStaffId"];
        if (numTeamStaffId && [numTeamStaffId isKindOfClass:[NSNumber class]])
        {
        }
        
        NSNumber* numTeamId = [dicResult valueForKey:@"teamId"];
        if (numTeamId && [numTeamId isKindOfClass:[NSNumber class]])
        {
            NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
            [dicPost setValue:self.userId forKey:@"userId"];
            [dicPost setValue:numTeamId.description forKey:@"teamId"];
            [[TaskManager shareInstance] createTaskWithTaskName:@"HMSecondEditionPatientInfoRequest" taskParam:dicPost TaskObserver:self];
        }
        
        //获取会话组ID
    }
    
    if ([taskname isEqualToString:@"HMSecondEditionPatientInfoRequest"])
    {
        if (taskResult && [taskResult isKindOfClass:[HMSecondEditionPationInfoModel class]])
        {
            self.needRequestUserInfo = NO;
            
            self.model = (HMSecondEditionPationInfoModel *)taskResult;
            if (self.model.payment - 1) {
                //付费患者
                [self addPaidParientVC];
            }
            else {
                //免费患者
                [self addFreePatientVC];
            }
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
