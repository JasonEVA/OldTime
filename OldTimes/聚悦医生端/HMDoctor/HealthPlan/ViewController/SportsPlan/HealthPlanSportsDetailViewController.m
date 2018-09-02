//
//  HealthPlanSportsDetailViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/29.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSportsDetailViewController.h"
#import "HealthPlanSportDetailView.h"

#import "HealthPlanSportTimePickerViewController.h"
#import "HealthPlanSportsStrengthPickerViewController.h"
#import "HealthPlanRecommandSportTypeView.h"

#import "HealthPlanSportsMoudleListViewController.h"
#import "HealthPlanSportsTypesSelectedViewController.h"

@interface HealthPlanSportsDetailViewController ()

@property (nonatomic, strong) NSString* status;

@property (nonatomic, strong) HealthPlanDetailSectionModel* detailModel;
@property (nonatomic, strong) HealthPlanDetCriteriaModel* criteriaModel;

@property (nonatomic, strong) HealthPlanSportTimeControl* sportTimeControl;
@property (nonatomic, strong) HealthPlanSportStrengthControl* strengthControl;
@property (nonatomic, strong) HealthPlanSportTypesControl* typeControl;
@property (nonatomic, strong) HealthPlanRecommandSportTypeView* recommandSportsTypesView;
@end

@implementation HealthPlanSportsDetailViewController

- (id) initWithDetailModel:(HealthPlanDetailSectionModel*) detailModel
                    status:(NSString*) status
                    
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _detailModel = detailModel;
        _criteriaModel = [self.detailModel.criterias firstObject];
        _status = status;
        

        [self.navigationItem setTitle:self.detailModel.title];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self layoutElements];
    
    [self.sportTimeControl setHealthPlanDetCriteriaModel:self.criteriaModel];
    [self.sportTimeControl addTarget:self action:@selector(sportTimeControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.strengthControl setHealthPlanDetCriteriaModel:self.criteriaModel];
    [self.strengthControl addTarget:self action:@selector(sportStrengthControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.typeControl addTarget:self action:@selector(sportsTypeControlClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) viewDidAppear:(BOOL)animated
{
    BOOL staffPrivilege = [HealthPlanUtil staffHasEditPrivilege:self.status];
    if (!staffPrivilege) {
        return;
    }
    
    UIBarButtonItem* moudleButton = [[UIBarButtonItem alloc] initWithTitle:@"模板" style:UIBarButtonItemStylePlain target:self action:@selector(moudleButtonClicked:)];

    UINavigationItem* topNavigationItem = [HMViewControllerManager topMostController].navigationItem;
    [topNavigationItem setRightBarButtonItem:moudleButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

#pragma mark control click event
- (void) sportTimeControlClicked:(id) sender
{
    BOOL staffPrivilege = [HealthPlanUtil staffHasEditPrivilege:self.status];
    if (!staffPrivilege) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [HealthPlanSportTimePickerViewController showWithSportTime:self.criteriaModel.sportsTimes pickHandle:^(NSString *sportTime) {
        if (!weakSelf) {
            return ;
        }
        
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.criteriaModel.sportsTimes = sportTime;
        
        [strongSelf.sportTimeControl setHealthPlanDetCriteriaModel:self.criteriaModel];
        
        [HealthPlanUtil postEditNotification];
    }];
}

- (void) sportStrengthControlClicked:(id) sender
{
    BOOL staffPrivilege = [HealthPlanUtil staffHasEditPrivilege:self.status];
    if (!staffPrivilege) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [HealthPlanSportsStrengthPickerViewController showWithExerciseIntensity:self.criteriaModel.exerciseIntensity pickHandle:^(NSString *exerciseIntensity) {
        if (!weakSelf) {
            return ;
        }
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.criteriaModel.exerciseIntensity = exerciseIntensity;
        NSArray* strengthSuggests = @[@"轻柔", @"低强", @"稍强"];
        strongSelf.criteriaModel.suggest = strengthSuggests[exerciseIntensity.integerValue - 1];
        
        [strongSelf.strengthControl setHealthPlanDetCriteriaModel:strongSelf.criteriaModel];
        [HealthPlanUtil postEditNotification];
        
    }];
}

- (void) sportsTypeControlClicked:(id) sender
{
    BOOL staffPrivilege = [HealthPlanUtil staffHasEditPrivilege:self.status];
    if (!staffPrivilege) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [HealthPlanSportsTypesSelectedViewController showWithSportsTypes:self.criteriaModel.sportType selectHandle:^(NSArray *sportsTypes) {
        if (!weakSelf) {
            return ;
        }
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.criteriaModel.sportType = sportsTypes;
        
        [strongSelf.recommandSportsTypesView setSportsTypes:sportsTypes];
        [HealthPlanUtil postEditNotification];
    }];
}

- (void) moudleButtonClicked:(id) sender
{
    //选择运动模版
    __weak typeof(self) weakSelf = self;
    
    HealthPlanSportsMoudleListViewController* templateListViewController = [[HealthPlanSportsMoudleListViewController alloc] initWithSelectHandle:^(HealthPlanDetCriteriaModel *criteriaModel) {
        if (!weakSelf) {
            return ;
        }
        
        __strong typeof(self) strongSelf = weakSelf;
        
        strongSelf.detailModel.criterias = @[criteriaModel];
        strongSelf.criteriaModel = criteriaModel;
        
        [strongSelf.sportTimeControl setHealthPlanDetCriteriaModel:self.criteriaModel];
        [strongSelf.strengthControl setHealthPlanDetCriteriaModel:strongSelf.criteriaModel];
        [strongSelf.recommandSportsTypesView setSportsTypes:strongSelf.criteriaModel.sportType];
        
        [HealthPlanUtil postEditNotification];
    }];
    
    HMBaseNavigationViewController* templateNavigationController = [[HMBaseNavigationViewController alloc] initWithRootViewController:templateListViewController];
    [self.navigationController presentViewController:templateNavigationController animated:YES completion:nil];
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
        _recommandSportsTypesView = [[HealthPlanRecommandSportTypeView alloc] initWithSportsTypes:self.criteriaModel.sportType];
        [self.view addSubview:_recommandSportsTypesView];
    }
    return _recommandSportsTypesView;
}
@end
