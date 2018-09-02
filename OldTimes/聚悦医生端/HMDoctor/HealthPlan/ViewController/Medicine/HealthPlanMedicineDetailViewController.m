//
//  HealthPlanMedicineDetailViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/9/14.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanMedicineDetailViewController.h"
#import "HealthPlanMedicineCurrentRecipeTableViewController.h"
#import "PrescribeStartViewController.h"
#import "PatientInfo.h"
#import "HMSwitchView.h"

@interface HealthPlanMedicineDetailViewController ()
<HMSwitchViewDelegate>
{
    
}
@property (nonatomic, retain) NSString* userId;
@property (nonatomic, retain) HealthPlanDetailSectionModel* detailModel;

@property (nonatomic, strong) HMSwitchView* switchView;
@property (nonatomic, strong) UITabBarController* tabbarController;

@property (nonatomic, strong) HealthPlanMedicineCurrentRecipeTableViewController* recipeTableViewController;
@property (nonatomic, strong) PrescribeStartTableViewController* recordsTableViewController;

@end

@implementation HealthPlanMedicineDetailViewController

- (id) initWithUserId:(NSString*) userId detailModel:(HealthPlanDetailSectionModel*) detailModel
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _userId = userId;
        _detailModel = detailModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutElements];
    
    [self.tabbarController setViewControllers:@[self.recipeTableViewController, self.recordsTableViewController]];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BOOL staffPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreatePrescriptionMode Status:0xFF OperateCode:kPrivilegeProcessOperate];;
    if (!staffPrivilege) {
        return;
    }
    
    UIBarButtonItem* appendButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(appendDetectButtonClicked:)];
    UINavigationItem* topNavigationItem = [HMViewControllerManager topMostController].navigationItem;
    [topNavigationItem setRightBarButtonItem:appendButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) layoutElements
{
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.top.equalTo(self.view);
       make.height.mas_equalTo(@49);
    }];
    
    [self.tabbarController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.switchView.mas_bottom);
    }];
}

- (void) appendDetectButtonClicked:(id) sender
{
    //开处方
    PatientInfo* patient = [[PatientInfo alloc] init];
    patient.userId = self.userId.integerValue;
    
    [HMViewControllerManager createViewControllerWithControllerName:@"PrescribeStartViewController" ControllerObject:patient];
}


#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSUInteger) selectedIndex
{
    [self.tabbarController setSelectedIndex:selectedIndex];
}

#pragma mark - settingAndGetting
- (HMSwitchView*) switchView
{
    if (!_switchView) {
        _switchView = [[HMSwitchView alloc] init];
        [self.view addSubview:_switchView];
        
        [_switchView createCells:@[@"当前用药", @"用药建议记录"]];
        [_switchView setDelegate:self];
    }
    return _switchView;
}

- (UITabBarController*) tabbarController
{
    if (!_tabbarController) {
        _tabbarController = [[UITabBarController alloc] init];
        [self addChildViewController:_tabbarController];
        [self.view addSubview:_tabbarController.view];
    }
    return _tabbarController;
}

- (HealthPlanMedicineCurrentRecipeTableViewController*) recipeTableViewController
{
    if (!_recipeTableViewController) {
        _recipeTableViewController = [[HealthPlanMedicineCurrentRecipeTableViewController alloc] initWithUserId:self.userId detailModel:self.detailModel];
        
    }
    return _recipeTableViewController;
}

- (PrescribeStartTableViewController*) recordsTableViewController
{
    if (!_recordsTableViewController) {
        PatientInfo* patientInfo = [[PatientInfo alloc] init];
        patientInfo.userId = self.userId.integerValue;
        
        _recordsTableViewController = [[PrescribeStartTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [_recordsTableViewController setPatientinfo:patientInfo];
        
    }
    return _recordsTableViewController;
}
@end
