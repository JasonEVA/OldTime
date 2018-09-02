//
//  HMPatientGroupForwardViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/1/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMPatientGroupForwardViewController.h"

#import "HMSelectPatientThirdEditionMainViewController.h"
#import "NewPatientListInfoModel.h"
#import <MintcodeIMKit/MintcodeIMKit.h>

@interface HMPatientGroupForwardViewController ()
@property (nonatomic, strong) HMSelectPatientThirdEditionMainViewController *selectPatientVC;
@property (nonatomic, copy) NSArray<MessageBaseModel *> *messages;
@end

@implementation HMPatientGroupForwardViewController

- (instancetype)initWithMessages:(NSArray<MessageBaseModel *> *)messages {
    if (self = [super init]) {
        self.messages = messages;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"选择用户"];
    self.selectPatientVC = [[HMSelectPatientThirdEditionMainViewController alloc] initWithSendTitel:@"发送" selectedMember:nil];
    
    [self addChildViewController:self.selectPatientVC ];
    [self.view addSubview:self.selectPatientVC.view];
    //[tvcPatients setIntent:PatientTableIntent_Survey];
    
    [self.selectPatientVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    [self.selectPatientVC getSelectedPatient:^(NSArray<NewPatientListInfoModel *> *selectedPatients) {
        __block NSMutableArray *tempArr = [NSMutableArray array];
        [selectedPatients enumerateObjectsUsingBlock:^(NewPatientListInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ContactDetailModel *model = [ContactDetailModel new];
            model._target = obj.imGroupId;
            [tempArr addObject:model];
        }];
        __weak typeof(self) weakSelf = self;
        [[MessageManager share] forwardMergeMessages:self.messages title:@"" toUsers:tempArr isMerge:NO completion:^(BOOL success) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (success) {
                NSLog(@"-------------->forward success");
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }
            else {
                [strongSelf at_postError:@"转发失败"];
            }
        }];

    }];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setRightBarButtonItem:self.selectPatientVC.navigationItem.rightBarButtonItem];
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
