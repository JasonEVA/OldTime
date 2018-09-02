//
//  HealthEducationTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthEducationStartViewController.h"
#import "HealthyEducationListTableViewController.h"

#import "HealthEducationStartBottomView.h"
#import "HealthEducationItem.h"
#import "HMSwitchView.h"

@interface HealthEducationStartViewController ()
<TaskObserver, HMSwitchViewDelegate>
{
    
}


@property (nonatomic, readonly) HealthEducationStartBottomView* bottomView;
@property (nonatomic, readonly) UIScrollView* switchScrollView;
@property (nonatomic, readonly) NSArray* educationColumes;
@property (nonatomic, readonly) HMSwitchView* switchView;

@property (nonatomic, readonly) UITabBarController* tabbarController;

@end

@implementation HealthEducationStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"健康课堂"];
    
    //创建搜索按钮
    UIBarButtonItem* bbiSearch = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_image"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBarButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:bbiSearch];
    
    _bottomView = [[HealthEducationStartBottomView alloc] init];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(@45);
    }];
    [self.bottomView showTopLine];
    
    _switchScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_switchScrollView];
    [self.switchScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(@47);
    }];
    
    [self loadEducationColumes];
}

- (void) searchBarButtonClicked:(id) sender
{
    //跳转到搜索界面 HealthEducationSearchViewController
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationSearchViewController" ControllerObject:nil];
    
}

- (void) loadEducationColumes
{
    [self.view showWaitView];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:@"Y" forKey:@"isDoctorType"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthyEducationColumesTask" taskParam:dicPost TaskObserver:self];
}

- (void) educationColumesLoaded:(NSArray*) columes
{
    if (!columes || columes.count == 0) {
        return;
    }
    
    _educationColumes = columes;
    NSMutableArray* columeTitles = [NSMutableArray array];
    [self.educationColumes enumerateObjectsUsingBlock:^(HealthyEducationColumeModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
        [columeTitles addObject:model.typeName];
    }];
    
    CGFloat switchWidth = kScreenWidth;
    if (columes.count > 4)
    {
        switchWidth = (kScreenWidth/4) * columes.count;
    }
    _switchView = [[HMSwitchView alloc]initWithFrame:CGRectMake(0, 0, switchWidth, 47)];
    [self.switchScrollView addSubview:_switchView];
    [self.switchView setDelegate:self];
    [self.switchScrollView setContentSize:CGSizeMake(switchWidth, 47)];
    
    [self.switchView createCells:columeTitles];
    
    //    [self.switchView setSelectedIndex:self.educationColumes.count - 1];
    
    [self createEducationListTable];
    
    [self.tabbarController setSelectedIndex:0];
}

- (void) createEducationListTable
{
    if (_tabbarController)
    {
        [_tabbarController removeFromParentViewController];
        [_tabbarController.view removeFromSuperview];
        _tabbarController = nil;
    }
    
    _tabbarController = [[UITabBarController alloc] init];
    [self addChildViewController:self.tabbarController];
    [self.view addSubview:self.tabbarController.view];
    
    [self.tabbarController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.switchScrollView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.tabbarController.tabBar setHidden:YES];
    
    //[self.educationListTableViewController setColumeId:0];
    NSMutableArray* tableViewControllers = [NSMutableArray array];
    for (HealthyEducationColumeModel* columeModel in _educationColumes) {
        HealthyEducationListTableViewController* tableViewController = [[HealthyEducationListTableViewController alloc] initWithColumeId:columeModel.classProgramTypeId];
        [tableViewControllers addObject:tableViewController];
    }
    
    [self.tabbarController setViewControllers:tableViewControllers];
}

#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSUInteger) selectedIndex
{
    [self.tabbarController setSelectedIndex:selectedIndex];
    
}
#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (taskError != StepError_None)
    {
        [self showAlertMessage:errorMessage];
        return;
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
    
    if ([taskname isEqualToString:@"HealthyEducationColumesTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* columes = (NSArray*) taskResult;
            [self educationColumesLoaded:columes];
        }
    }
}
@end

