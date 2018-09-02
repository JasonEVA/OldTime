//
//  AppendDetectPickerViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/23.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "AppendDetectPickerViewController.h"

@interface AppendDetectPickerViewController ()
<TaskObserver, UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSArray* kpiList;
}

@property (nonatomic, strong) UIPickerView* pickerView;
@property (nonatomic, strong) UIToolbar* confirmBar;
@property (nonatomic, retain) NSArray* existedKpiList;
@property (nonatomic, strong) AppendDetectHandle handle;
@end

@implementation AppendDetectPickerViewController

+ (void) showWithExistKpiList:(NSArray*) existedKpiList
                       handle:(AppendDetectHandle) handle
{
    AppendDetectPickerViewController* pickerViewController = [[AppendDetectPickerViewController alloc] initWithExistedKpiList:existedKpiList handle:handle];
    UIViewController* topMostViewController = [HMViewControllerManager topMostController];
    [topMostViewController addChildViewController:pickerViewController];
    [topMostViewController.view addSubview:pickerViewController.view];
    
    [pickerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topMostViewController.view);
    }];

}

- (id) initWithExistedKpiList:(NSArray*) existedKpiList
                       handle:(AppendDetectHandle) handle
{
    self = [super init];
    if (self) {
        _existedKpiList = existedKpiList;
        _handle = handle;
    }
    return self;
}

- (void) loadView
{
    UIControl* closeControl = [[UIControl alloc] init];
    [closeControl setBackgroundColor:[UIColor commonTranslucentColor]];
    [closeControl addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventAllTouchEvents];
    [self setView:closeControl];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutElements];
    
    [self loadDetectKpi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void) closeControlClicked:(id) sender
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void) loadDetectKpi
{
    //HealthPlanAllDetectTask
    UserInfo* user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:[NSString stringWithFormat:@"%ld", user.userId] forKey:@"userId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanAllDetectTask" taskParam:paramDict TaskObserver:self];
}

#pragma mark - Control Click Event
- (void) confirmButtonClicked:(id) sender
{
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    DetectKPIModel* kpiModel = kpiList[row];
    
    if (self.handle) {
        self.handle(kpiModel);
    }
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (kpiList) {
        return kpiList.count;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    DetectKPIModel* kpiModel = kpiList[row];
    return kpiModel.kpiName;
    
}

//- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    DetectKPIModel* kpiModel = kpiList[row];
//    
//    if (self.handle) {
//        self.handle(kpiModel);
//    }
//    
//    [self.view removeFromSuperview];
//    [self removeFromParentViewController];
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
    if (taskError != StepError_None) {
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    if ([taskname isEqualToString:@"HealthPlanAllDetectTask"])
    {
        if (kpiList.count > 0)
        {
            [self.pickerView reloadComponent:0];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
        }
    }
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
    if ([taskname isEqualToString:@"HealthPlanAllDetectTask"])
    {
        if ([taskResult isKindOfClass:[NSArray class]]) {
            NSArray* models = (NSArray*) taskResult;
            NSMutableArray* kpiModels = [NSMutableArray array];
            
            [models enumerateObjectsUsingBlock:^(DetectKPIModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
                __block BOOL isExisted = NO;
                [self.existedKpiList enumerateObjectsUsingBlock:^(DetectKPIModel* existedmodel, NSUInteger idx, BOOL * _Nonnull existedstop) {
                    if ([existedmodel.kpiCode isEqualToString:model.kpiCode])
                    {
                        isExisted = YES;
                        *existedstop = YES;
                        return ;
                    }
                }];
                if (!isExisted) {
                    [kpiModels addObject:model];
                }
            }];
        
            kpiList = kpiModels;
        }
    }
}
@end
