//
//  HMNoticeWindowSharePatientViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/7/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMNoticeWindowSharePatientViewController.h"
#import "HMSelectPatientThirdEditionMainViewController.h"
#import "NewPatientListInfoModel.h"

@interface HMNoticeWindowSharePatientViewController ()<TaskObserver>
@property (nonatomic, strong) HMSelectPatientThirdEditionMainViewController *selectPatientVC;

@end

@implementation HMNoticeWindowSharePatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"选择用户"];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    [self.navigationItem setLeftBarButtonItem:left];
    
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
            [dicPost setValue:strongSelf.notId forKey:@"notesId"];
            NSMutableArray *arr = [NSMutableArray array];
            [selectedPatients enumerateObjectsUsingBlock:^(NewPatientListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dict = @{@"teamId":obj.teamId,@"userId":[NSString stringWithFormat:@"%ld",obj.userId]};
                [arr addObject:dict];
            }];
            [dicPost setValue:arr forKey:@"teamUsers"];
            
            [[TaskManager shareInstance] createTaskWithTaskName:@"HMShareNoticeToPatientRequest" taskParam:dicPost TaskObserver:strongSelf];
            [strongSelf.view showWaitView];
            
        }
        
    }];

}

- (void)leftClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if ([taskname isEqualToString:@"HMShareNoticeToPatientRequest"])
    {
        __weak typeof(self) weakSelf = self;
        [self showAlertMessage:@"发送成功" clicked:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
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
