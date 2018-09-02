//
//  HMFEAllPatientListViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/10/27.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMFEAllPatientListViewController.h"
#import "NewPatientListViewController.h"
#import "HMFEPatientListSearchResultViewController.h"

@interface HMFEAllPatientListViewController ()
@property (nonatomic, strong) NewPatientListViewController *patientListVC;

@end

@implementation HMFEAllPatientListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"筛选用户"];
    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchClick)];
    
    [self.navigationItem setRightBarButtonItem:search];
    
    
    [self.view addSubview:self.patientListVC.view];
    [self.patientListVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    [self addChildViewController:self.patientListVC];
    [self.patientListVC didMoveToParentViewController:self];
    
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)searchClick {
        HMFEPatientListSearchResultViewController *resultVC = [HMFEPatientListSearchResultViewController new];
    
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:resultVC];
        [self presentViewController:nav animated:YES completion:nil];
}

- (NewPatientListViewController *)patientListVC {
    if (!_patientListVC) {
        _patientListVC = [[NewPatientListViewController alloc] initWithPatientFilterViewType:PatientFilterViewTypeAll];
    }
    return _patientListVC;
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
