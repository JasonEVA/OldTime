//
//  HealthEducationShareSelectionPatientViewController.m
//  HMDoctor
//
//  Created by yinquan on 17/1/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthEducationShareSelectionPatientViewController.h"
#import "HMSelectPatientThirdEditionMainViewController.h"
#import "HMSecondEditionEducationShareRequest.h"
#import "IMNewsModel.h"
#import "NewPatientListInfoModel.h"

@interface HealthEducationShareSelectionPatientViewController ()<TaskObserver>
@property (nonatomic, strong) HMSelectPatientThirdEditionMainViewController *selectPatientVC;
@end

@implementation HealthEducationShareSelectionPatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"选择用户"];
    
    self.selectPatientVC = [[HMSelectPatientThirdEditionMainViewController alloc] initWithSendTitel:@"发送" selectedMember:nil];
    [self addChildViewController:self.selectPatientVC ];
    [self.view addSubview:self.selectPatientVC.view];
    //[tvcPatients setIntent:PatientTableIntent_Survey];
    
    [self.selectPatientVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    __weak typeof(self) weakSelf = self;
    [self.selectPatientVC getSelectedPatient:^(NSArray<NewPatientListInfoModel *> *selectedPatients) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (0 == selectedPatients.count)
        {
            [strongSelf showAlertMessage:@"请选择用户。"];
            return;
        }
        else {
            NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
            
            StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
            [dicPost setValue:[NSString stringWithFormat:@"%ld",curStaff.userId] forKey:@"userId"];
            [dicPost setValue:[NSString stringWithFormat:@"%ld",strongSelf.classId] forKey:@"classId"];
            NSMutableArray *arr = [NSMutableArray array];
            [selectedPatients enumerateObjectsUsingBlock:^(NewPatientListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dict = @{@"teamId":obj.teamId,@"userId":[NSString stringWithFormat:@"%ld",obj.userId]};
                [arr addObject:dict];
            }];
            [dicPost setValue:arr forKey:@"teamUsers"];
            
            [[TaskManager shareInstance] createTaskWithTaskName:@"HMSecondEditionEducationShareRequest" taskParam:dicPost TaskObserver:strongSelf];
            [strongSelf.view showWaitView];

        }
        
    }];
    
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"健康计划－健康课堂-分享选人"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setRightBarButtonItem:self.selectPatientVC.navigationItem.rightBarButtonItem];
}

#pragma mark - TaskObserver
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
    [self.view closeWaitView];

    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"HMSecondEditionEducationShareRequest"])
    {
        __weak typeof(self) weakSelf = self;
        [self showAlertMessage:@"发送成功" clicked:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}


@end
