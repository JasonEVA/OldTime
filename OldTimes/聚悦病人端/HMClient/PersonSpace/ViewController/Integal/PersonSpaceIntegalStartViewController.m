//
//  PersonSpaceIntegalStartViewController.m
//  HMClient
//  我的积分首页
//  Created by yinquan on 2017/7/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PersonSpaceIntegalStartViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "IntegalStartHeaderView.h"
#import "IntegralStartOperateView.h"
#import "IntergralDetailHeaderView.h"
#import "IntegralModel.h"
#import "PersonSpaceIntegralRecordsTableViewController.h"
#import "IntegralSourceListViewController.h"
#import "PersonSpaceIntegralSourceReocrdsTableViewController.h"
#import "IntegralModel.h"

@interface PersonSpaceIntegalStartViewController ()
<TaskObserver, IntegralStartOperateViewDelegate>

@property (nonatomic, strong) IntegalStartHeaderView* integalHeaderView;
@property (nonatomic, strong) IntegralStartOperateView* operateView;
@property (nonatomic, strong) IntergralDetailHeaderView* detailHeaderView;
@property (nonatomic, strong) UITableViewController* recordsTableVeiwController;

@property (nonatomic, assign) NSInteger selectedSourceId;

@end

@implementation PersonSpaceIntegalStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setFd_prefersNavigationBarHidden:YES];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.integalHeaderView.backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadIntegralSummary];
    
    [self.detailHeaderView.chooseControl addTarget:self action:@selector(showIntegralSourceListViewController) forControlEvents:UIControlEventTouchUpInside];
//    [self.detailHeaderView.chooseControl setBackgroundColor:[UIColor redColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showIntegralSourceListViewController
{
     __weak typeof(self) weakSelf = self;
    
    [IntegralSourceListViewController showWithIntegralSourceChooseBlock:^(NSInteger sourceId, NSString *sourceName) {
        [weakSelf chooseSource:sourceId sourceName:sourceName];
    } selectedSourceId:self.selectedSourceId];
}

- (void) chooseSource:(NSInteger) sourceId sourceName:(NSString*) sourceName
{
    if (sourceId == self.selectedSourceId) {
        return;
    }
    [self.detailHeaderView.chooseControl setTitle:sourceName];
    [self setSelectedSourceId:sourceId];
    
    if (sourceId > 0) {
        if ([self.recordsTableVeiwController isKindOfClass:[PersonSpaceIntegralRecordsTableViewController class]])
        {
            [self.recordsTableVeiwController.tableView removeFromSuperview];
            [self.recordsTableVeiwController removeFromParentViewController];
            
            _recordsTableVeiwController = [[PersonSpaceIntegralSourceReocrdsTableViewController alloc] initWithSourceId:sourceId];
            [self.view addSubview: _recordsTableVeiwController.tableView];
            [self addChildViewController:_recordsTableVeiwController];
            
            [_recordsTableVeiwController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.top.equalTo(self.detailHeaderView.mas_bottom);
            }];
        }
        else
        {
            PersonSpaceIntegralSourceReocrdsTableViewController* recordsTableViewController = (PersonSpaceIntegralSourceReocrdsTableViewController*)self.recordsTableVeiwController;
            [recordsTableViewController setSourceId:sourceId];
        }
    }
    else
    {
        if ([self.recordsTableVeiwController isKindOfClass:[PersonSpaceIntegralSourceReocrdsTableViewController class]])
        {
            [self.recordsTableVeiwController.tableView removeFromSuperview];
            [self.recordsTableVeiwController removeFromParentViewController];
            
            _recordsTableVeiwController = [[PersonSpaceIntegralRecordsTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.view addSubview: _recordsTableVeiwController.tableView];
            [self addChildViewController:_recordsTableVeiwController];
            
            [_recordsTableVeiwController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.top.equalTo(self.detailHeaderView.mas_bottom);
            }];
        }
        else
        {
            
        }
    }
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.integalHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(@182);
    }];
    
    [self.operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.integalHeaderView.mas_bottom);
        make.height.mas_equalTo(@80);
    }];
    
    [self.detailHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.operateView.mas_bottom).with.offset(10);
        make.height.mas_equalTo(@51);
    }];
    
    [self.recordsTableVeiwController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.detailHeaderView.mas_bottom);
    }];
}

- (void) loadIntegralSummary
{
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"IntegralSummaryTask" taskParam:nil TaskObserver:self];
    

}

- (void) backButtonClicked:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - settingAndGetting
- (IntegalStartHeaderView*) integalHeaderView
{
    if (!_integalHeaderView) {
        _integalHeaderView = [[IntegalStartHeaderView alloc] init];
        [self.view addSubview:_integalHeaderView];
        
    }
    return _integalHeaderView;
}

- (IntegralStartOperateView*) operateView
{
    if (!_operateView)
    {
        _operateView = [[IntegralStartOperateView alloc] init];
        [self.view addSubview:_operateView];
        [_operateView setDelegate:self];
    }
    return _operateView;
}

- (IntergralDetailHeaderView*) detailHeaderView
{
    if (!_detailHeaderView)
    {
        _detailHeaderView = [[IntergralDetailHeaderView alloc] init];
        [self.view addSubview:_detailHeaderView];
    }
    return _detailHeaderView;
}

- (UITableViewController*) recordsTableVeiwController
{
    if (!_recordsTableVeiwController) {
        _recordsTableVeiwController = [[PersonSpaceIntegralRecordsTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self addChildViewController:_recordsTableVeiwController];
        [self.view addSubview:_recordsTableVeiwController.tableView];
    }
    return _recordsTableVeiwController;
}

#pragma mark - IntegralStartOperateViewDelegate
- (void) operateButtonClicked:(IntegralStartOperateIndex) operateIndex
{
    switch (operateIndex) {
        case IntegralStartOperate_Rule:
        {
            //积分等级规则
            [HMViewControllerManager createViewControllerWithControllerName:@"PersonIntegralRoleViewController" ControllerObject:nil];
            break;
        }
        case IntegralStartOperate_Strategy:
        {
            //积分攻略
            [HMViewControllerManager createViewControllerWithControllerName:@"PersonIntegralStrategyViewController" ControllerObject:nil];
            break;

        }
        case IntegralStartOperate_Mall:
        {
            [self showAlertMessage:@"技术员正在努力研究这块未知领地。"];
            break;
        }
        default:
            break;
    }
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
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
    if ([taskname isEqualToString:@"IntegralSummaryTask"]) {
        if (taskResult && [taskResult isKindOfClass:[IntegralSummaryModel class]])
        {
            IntegralSummaryModel* model = (IntegralSummaryModel*) taskResult;
            [self.integalHeaderView setIntegralSummaryModel:model];
        }
    }
}
@end
