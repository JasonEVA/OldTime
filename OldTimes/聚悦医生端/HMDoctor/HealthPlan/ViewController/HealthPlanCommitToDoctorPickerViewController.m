//
//  HealthPlanCommitToDoctorPickerViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/9/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanCommitToDoctorPickerViewController.h"

@interface HealthPlanCommitToDoctorPickerViewController ()
<TaskObserver, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray* staffModels;
}

@property (nonatomic, strong) HealthPlanSubmitDoctorPickHandle pickHandle;
@property (nonatomic, strong) NSString* userId;

@property (nonatomic, strong) UIPickerView* pickerView;
@property (nonatomic, strong) UIToolbar* confirmBar;

@end

@implementation HealthPlanCommitToDoctorPickerViewController

+ (void) showWithUserId:(NSString*) userId
                 handle:(HealthPlanSubmitDoctorPickHandle) handle
{
    HealthPlanCommitToDoctorPickerViewController* pickViewController = [[HealthPlanCommitToDoctorPickerViewController alloc] initWithUserId:userId handle:handle];
    UIViewController* topMostViewController = [HMViewControllerManager topMostController];
    
    if ([topMostViewController isKindOfClass:[UIAlertController class]]) {
        //保护性代码，
        return;
    }
    [topMostViewController addChildViewController:pickViewController];
    [topMostViewController.view addSubview:pickViewController.view];
    [pickViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topMostViewController.view);
    }];

}

- (id) initWithUserId:(NSString*) useId
               handle:(HealthPlanSubmitDoctorPickHandle) handle
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _userId = useId;
        _pickHandle = handle;
    }
    return self;
}

- (void) loadView
{
    UIControl* closeControl = [[UIControl alloc] init];
    [closeControl setBackgroundColor:[UIColor commonTranslucentColor]];
    [self setView:closeControl];
    [closeControl addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventAllTouchEvents];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutElements];
    
    [self loadStaffList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) closeControlClicked:(id) sender
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void) layoutElements
{
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.confirmBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pickerView.mas_top);
        make.left.right.equalTo(self.view);
    }];
}

- (void) loadStaffList
{
    [self.view showWaitView];
    StaffInfo* staff = [[UserInfoHelper defaultHelper]currentStaffInfo];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", (long)staff.staffId] forKey:@"staffId"];
    [dicPost setValue:self.userId forKey:@"userId"];
    NSString* privilegeKey = [NSString stringWithFormat:@"%@_2_%@", kPrivilegeHealthPlanMode, kPrivilegeConfirmOperate];
    [dicPost setValue:privilegeKey forKey:@"functionCode"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"GetUserTeamStaffByFunctionCodeTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - Control Click Event
- (void) confirmButtonClicked:(id) sender
{
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    StaffTeamDoctorModel* model = staffModels[row];
    if (self.pickHandle) {
        self.pickHandle(model);
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (staffModels) {
        return staffModels.count;
    }
    return 0;
}

#pragma mark - UIPickerViewDataSource
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    StaffTeamDoctorModel* model = staffModels[row];
    return model.staffName;
}

//- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    StaffTeamDoctorModel* model = staffModels[row];
//    if (self.pickHandle) {
//        self.pickHandle(model);
//    }
//    [self.view removeFromSuperview];
//    [self removeFromParentViewController];
//
//}

#pragma mark - settingAndGetting

- (UIPickerView*) pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        [self.view addSubview:_pickerView];
        [_pickerView setBackgroundColor:[UIColor whiteColor]];
        [_pickerView setDataSource:self];
        [_pickerView setDelegate:self];
    }
    return _pickerView;
}

- (UIToolbar*) confirmBar
{
    if (!_confirmBar) {
        _confirmBar = [[UIToolbar alloc] init];
        [self.view addSubview:_confirmBar];
        
        [_confirmBar setBackgroundColor:[UIColor whiteColor]];
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem* confirmBBI = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButtonClicked:)];
        [_confirmBar setItems:@[space, confirmBBI]];
    }
    return _confirmBar;
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (taskError != StepError_None) {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    [self.pickerView reloadComponent:0];
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"GetUserTeamStaffByFunctionCodeTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            staffModels = taskResult;
        }
    }
}
@end
