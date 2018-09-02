//
//  SurveryStartViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "SurveryStartViewController.h"
#import "HMSelectPatientThirdEditionMainViewController.h"

@interface SurveryStartViewController ()

{
    
    
}
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) HMSelectPatientThirdEditionMainViewController *selectPatientVC;
@end

@implementation SurveryStartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"随访"];
    
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
            [strongSelf confirmBBIClicked:selectedPatients];
        }
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setRightBarButtonItem:self.selectPatientVC.navigationItem.rightBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) confirmBBIClicked:(NSArray *)selectedPatients
{
    
    [HMViewControllerManager createViewControllerWithControllerName:@"SurveyMoudlesStartViewController" ControllerObject:selectedPatients];
}


@end

@implementation InterrogationStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"问诊"];
}

- (void) confirmBBIClicked:(NSArray *)selectedPatients
{

    [HMViewControllerManager createViewControllerWithControllerName:@"InterrogationMoudlesStartViewController" ControllerObject:selectedPatients];
}
@end
