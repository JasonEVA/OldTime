//
//  NewPrescribeSelectPatientViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/1/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "NewPrescribeSelectPatientViewController.h"
#import "HMSelectPatientThirdEditionMainViewController.h"
#import "NewPatientListInfoModel.h"

@interface NewPrescribeSelectPatientViewController ()
@property (nonatomic, strong) HMSelectPatientThirdEditionMainViewController *selectPatientVC;

@end

@implementation NewPrescribeSelectPatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"选择用户(单选)"];
    
    self.selectPatientVC = [[HMSelectPatientThirdEditionMainViewController alloc] initWithSendTitel:@"确定" selectedMember:nil];
    [self.selectPatientVC setMaxSelectedNum:1];
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
            NewPatientListInfoModel *model = selectedPatients.firstObject;
             [HMViewControllerManager createViewControllerWithControllerName:@"PrescribeStartViewController" ControllerObject:[model convertToPatientInfo]];
           
        }
        
    }];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setRightBarButtonItem:self.selectPatientVC.navigationItem.rightBarButtonItem];
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
