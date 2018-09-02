//
//  HealthPlanSportTemplateDetailViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/29.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSportTemplateDetailViewController.h"

#import "HealthPlanSportDetailView.h"
#import "HealthPlanRecommandSportTypeView.h"

@interface HealthPlanSportTemplateDetailViewController ()
<TaskObserver>

@property (nonatomic, strong) HealthPlanTemplateModel* templateModel;
//@property (nonatomic, readonly) HealthPlanDetailSectionModel* healthPlanDetModel;
@property (nonatomic, strong) HealthPlanDetCriteriaModel* criteriaModel;

@property (nonatomic, strong) HealthPlanSubTemplateSelectHandle selectHandle;

@property (nonatomic, strong) HealthPlanSportTimeControl* sportTimeControl;
@property (nonatomic, strong) HealthPlanSportStrengthControl* strengthControl;
@property (nonatomic, strong) HealthPlanSportTypesControl* typeControl;
@property (nonatomic, strong) HealthPlanRecommandSportTypeView* recommandSportsTypesView;

@property (nonatomic, strong) UIView* commitView;
@property (nonatomic, strong) UIButton* commitButton;

@end

@implementation HealthPlanSportTemplateDetailViewController

- (id) initWithHealthPlanTemplateModel:(HealthPlanTemplateModel*) templateModel
                          selectHandle:(HealthPlanSubTemplateSelectHandle) selectHandle
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _templateModel = templateModel;
        _selectHandle = selectHandle;
    }
    return self;
}

- (NSDictionary*) controllerParamDictionary
{
    NSMutableDictionary* paramDictionary = [NSMutableDictionary dictionary];
    if (_templateModel.id && _templateModel.id.length > 0) {
        [paramDictionary setValue:_templateModel.id forKey:@"templateId"];
    }
    return paramDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.templateModel.name;
    
    [self layoutElements];
    
    [self loadTemplateDetail];

    [self.sportTimeControl setEnabled:NO];
    [self.strengthControl setEnabled:NO];
    [self.typeControl setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadTemplateDetail
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:self.templateModel.id forKey:@"subHealthyPlanTempId"];
    [dicPost setValue:@"sports" forKey:@"typeCode"];
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanTemplateDetailTask" taskParam:dicPost TaskObserver:self];
}

- (void) layoutElements
{
    [self.sportTimeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(@39);
    }];
    
    [self.strengthControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(@39);
        make.top.equalTo(self.sportTimeControl.mas_bottom);
    }];
    
    [self.typeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(@39);
        make.top.equalTo(self.strengthControl.mas_bottom);
    }];
    
    [self.recommandSportsTypesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.typeControl.mas_bottom);
    }];
    
    [self.commitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@58.5);
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.commitView).insets(UIEdgeInsetsMake(10, 12.5, 10, 12.5));
    }];
}

#pragma mark - control click event
- (void) commitButtonClicked:(id) sender
{
    if (self.selectHandle && self.criteriaModel) {
        self.selectHandle(self.criteriaModel);
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark settingAndGetting
- (HealthPlanSportTimeControl*) sportTimeControl
{
    if (!_sportTimeControl) {
        _sportTimeControl = [[HealthPlanSportTimeControl alloc] init];
        [self.view addSubview:_sportTimeControl];
    }
    return _sportTimeControl;
}

- (HealthPlanSportStrengthControl*) strengthControl
{
    if (!_strengthControl) {
        _strengthControl = [[HealthPlanSportStrengthControl alloc] init];
        [self.view addSubview:_strengthControl];
    }
    return _strengthControl;
}

- (HealthPlanSportTypesControl*) typeControl
{
    if (!_typeControl) {
        _typeControl = [[HealthPlanSportTypesControl alloc] init];
        [self.view addSubview:_typeControl];
    }
    return _typeControl;
}

- (HealthPlanRecommandSportTypeView*) recommandSportsTypesView
{
    if (!_recommandSportsTypesView) {
        _recommandSportsTypesView = [[HealthPlanRecommandSportTypeView alloc] init];
        [self.view addSubview:_recommandSportsTypesView];
    }
    return _recommandSportsTypesView;
}

- (UIView*) commitView
{
    if (!_commitView) {
        _commitView = [[UIView alloc] init];
        [self.view addSubview:_commitView];
        [_commitView setBackgroundColor:[UIColor whiteColor]];
    }
    return _commitView;
}

- (UIButton*) commitButton
{
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commitView addSubview:_commitButton];
        
        [_commitButton setTitle:@"使用此模板" forState:UIControlStateNormal];
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_commitButton setBackgroundImage:[UIImage rectImage:CGSizeMake(120, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        _commitButton.layer.cornerRadius = 4;
        _commitButton.layer.masksToBounds = YES;
        
        [_commitButton addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
    
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
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
    
    if ([taskname isEqualToString:@"HealthPlanTemplateDetailTask"])
    {
        [self.sportTimeControl setHealthPlanDetCriteriaModel:self.criteriaModel];
        [self.strengthControl setHealthPlanDetCriteriaModel:self.criteriaModel];
        [self.recommandSportsTypesView setSportsTypes:self.criteriaModel.sportType];
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
    if ([taskname isEqualToString:@"HealthPlanTemplateDetailTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* criteriaModels = (NSArray*) taskResult;
            _criteriaModel = criteriaModels.firstObject;
            
            
        }
    }
}

@end
