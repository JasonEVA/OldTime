//
//  HMSendConcernSelectMemberViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2016/12/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMSendConcernSelectMemberViewController.h"
#import "HMSelectPatientThirdEditionMainViewController.h"
#import "NewPatientListInfoModel.h"
@interface HMSendConcernSelectMemberViewController ()
@property (nonatomic, strong) HMSelectPatientThirdEditionMainViewController *selectPatientVC;
@property (nonatomic, copy) ConcernSelectBlock block;
@end

@implementation HMSendConcernSelectMemberViewController

- (instancetype)initWithTitel:(NSString *)titel selectedMember:(NSMutableArray<NewPatientListInfoModel *> *)selectMember {
    if (self = [super init]) {
        self.selectPatientVC = [[HMSelectPatientThirdEditionMainViewController alloc] initWithSendTitel:titel selectedMember:selectMember];
        [self.selectPatientVC setCanSelectAll:YES];
        [self.selectPatientVC setMaxSelectedNum:200];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"选择用户"];
    
    
    [self addChildViewController:self.selectPatientVC ];
    [self.view addSubview:self.selectPatientVC.view];
    //[tvcPatients setIntent:PatientTableIntent_Survey];
    
    [self.selectPatientVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    __weak typeof(self) weakSelf = self;
    [self.selectPatientVC getSelectedPatient:^(NSArray<NewPatientListInfoModel *> *selectedPatients) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.block(selectedPatients);
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
    

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setRightBarButtonItem:self.selectPatientVC.navigationItem.rightBarButtonItem];
}

- (void)acquireSelcetMember:(ConcernSelectBlock)block {
    self.block = block;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
