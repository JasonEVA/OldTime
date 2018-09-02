//
//  HealthPlanSportsTypesSelectedViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/30.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSportsTypesSelectedViewController.h"
#import "HealthPlanSportsTypeSelectView.h"

@interface HealthPlanSportsTypesSelectedViewController ()
<TaskObserver>
@property (nonatomic, strong) NSMutableArray* selectedSportsTypes;
@property (nonatomic, strong) NSMutableArray* unselectedSportsTypes;

@property (nonatomic, strong) HealthPlanSportsTypesSelecteHandle selectHandle;

@property (nonatomic, strong) HealthPlanSportsTypeSelectView* sportsTypesSelectView;
@property (nonatomic, strong) UIToolbar* toolBar;
@end

@implementation HealthPlanSportsTypesSelectedViewController

+ (void) showWithSportsTypes:(NSArray*) sportsTypes
                selectHandle:(HealthPlanSportsTypesSelecteHandle) selectHandle
{
    HealthPlanSportsTypesSelectedViewController* selectViewController = [[HealthPlanSportsTypesSelectedViewController alloc] initWithSportsTypes:sportsTypes selectHandle:selectHandle];
    
    UIViewController* topMostController = [HMViewControllerManager topMostController];
    [topMostController addChildViewController:selectViewController];
    [topMostController.view addSubview:selectViewController.view];
    [selectViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topMostController.view);
    }];

}

- (id) initWithSportsTypes:(NSArray*) sportsTypes
              selectHandle:(HealthPlanSportsTypesSelecteHandle) selectHandle
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _selectedSportsTypes = [NSMutableArray arrayWithArray:sportsTypes];
        _selectHandle = selectHandle;
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
    [self loadSportsTypes];
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

- (void) loadSportsTypes
{
    //HealthPlanSportsTypesTask
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanSportsTypesTask" taskParam:nil TaskObserver:self];
}

- (void) layoutElements
{
    [self.sportsTypesSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(@25);
    }];
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.sportsTypesSelectView.mas_top);
    }];
}

- (void) confirmButtonClicked:(id) sender
{
    NSArray* types = self.sportsTypesSelectView.selectedSportsTyes;
    if (self.selectHandle) {
        self.selectHandle(types);
    }

    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - settingAndGetting
- (HealthPlanSportsTypeSelectView*)sportsTypesSelectView
{
    if (!_sportsTypesSelectView) {
        _sportsTypesSelectView = [[HealthPlanSportsTypeSelectView alloc] init];
        [self.view addSubview:_sportsTypesSelectView];
    }
    return _sportsTypesSelectView;
}

- (UIToolbar*) toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] init];
        [self.view addSubview:_toolBar];
        [_toolBar setBackgroundColor:[UIColor whiteColor]];
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [space setTitle:@"选择推荐运动"];
        
        UIBarButtonItem* confirmBBI = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButtonClicked:)];
        [_toolBar setItems:@[space, confirmBBI]];
    }
    return _toolBar;
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
    if ([taskname isEqualToString:@"HealthPlanSportsTypesTask"])
    {
        [self.sportsTypesSelectView setSelectedSportsTypes:self.selectedSportsTypes unselectedSportsTyes:self.unselectedSportsTypes];
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
    if ([taskname isEqualToString:@"HealthPlanSportsTypesTask"])
    {
        if ([taskResult isKindOfClass:[NSArray class]])
        {
            _unselectedSportsTypes = [NSMutableArray array];
            
            NSArray* sportsTypes = (NSArray*) taskResult;
            
            [sportsTypes enumerateObjectsUsingBlock:^(HealthSportTypeModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
                __block BOOL isSelected = NO;
                [self.selectedSportsTypes enumerateObjectsUsingBlock:^(HealthSportTypeModel* selectedmodel, NSUInteger idx, BOOL * _Nonnull existedstop) {
                    if ([model.sportsTypeId isEqualToString:selectedmodel.sportsTypeId])
                    {
                        isSelected = YES;
                        *existedstop = YES;
                        return ;
                    }
                    
                    
                }];
                if (!isSelected) {
                    [_unselectedSportsTypes addObject:model];
                }
                
            }];
        }
    }
}

@end
