//
//  HMNoticeWindowShareToWorkViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/7/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMNoticeWindowShareToWorkViewController.h"
#import "HMSelectContactsViewController.h"
#import "ContactInfoModel.h"
#import "DoctorContactDetailModel.h"

@interface HMNoticeWindowShareToWorkViewController ()<TaskObserver>
@property (nonatomic, strong) HMSelectContactsViewController *selectPatientVC;
@property (nonatomic, strong) UILabel *rightLb;
@end

@implementation HMNoticeWindowShareToWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"选择工作组"];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    [self.navigationItem setLeftBarButtonItem:left];
    __weak typeof(self) weakSelf = self;
    self.selectPatientVC = [[HMSelectContactsViewController alloc] initWithSelectedPeople:nil completion:^(NSArray *selectedPeople) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        [strongSelf.rightLb setText:[NSString stringWithFormat:@"发送(%lu)",(unsigned long)self.selectPatientVC.selectedPeople.count]];

    }];
    
    [self addChildViewController:self.selectPatientVC ];
    [self.view addSubview:self.selectPatientVC.view];
    //[tvcPatients setIntent:PatientTableIntent_Survey];
    
    [self.selectPatientVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.rightLb  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [self.rightLb setText:[NSString stringWithFormat:@"发送(%lu)",(unsigned long)self.selectPatientVC.selectedPeople.count]];
    [self.rightLb setTextColor:[UIColor whiteColor]];
    [self.rightLb setTextAlignment:NSTextAlignmentRight];
    [self.rightLb setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightClick)];
    [self.rightLb addGestureRecognizer:tap];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.rightLb]];
    // Do any additional setup after loading the view.
}
- (void)leftClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightClick {
    if (!self.selectPatientVC.selectedPeople.count) {
        [self showAlertMessage:@"至少选择一个发送对象"];
        return;
    }
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",curStaff.userId] forKey:@"userId"];
    [dicPost setValue:self.notId forKey:@"notesId"];
    NSMutableArray *arr = [NSMutableArray array];
    [self.selectPatientVC.selectedPeople enumerateObjectsUsingBlock:^(ContactInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ContactDetailModel *model = [obj convertToContactDetailModel];
        [arr addObject:model._target];
    }];
    [dicPost setValue:arr forKey:@"imGroupIds"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMShareNoticeToWorkRequest" taskParam:dicPost TaskObserver:self];
    [self.view showWaitView];
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
    
    if ([taskname isEqualToString:@"HMShareNoticeToWorkRequest"])
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
