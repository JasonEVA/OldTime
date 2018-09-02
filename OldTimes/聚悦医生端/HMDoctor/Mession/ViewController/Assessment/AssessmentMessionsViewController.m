//
//  AssessmentMessionsViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/29.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AssessmentMessionsViewController.h"
#import "HMSwitchView.h"
#import "AssessmentMessionTableViewCell.h"

static NSInteger AssessmentMessionListPageSize = 20;


@interface AssessmentMessionsTableViewController : UITableViewController
<TaskObserver>
{
    NSMutableArray* assessmentMessions;
    NSInteger totalCount;
    
}
@property (nonatomic, readonly) NSArray* statusList;

- (id) initWithStatusLsit:(NSArray*) statusList;
@end


@interface AssessmentMessionsViewController ()
<HMSwitchViewDelegate,
TaskObserver>
{
    HMSwitchView* switchview;
    
    UITabBarController* tabbarController;
}
@end

@implementation AssessmentMessionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"评估"];
    
    [self createSwitchView];
    [self createTabbarController];
    if (UMSDK_isOn) {
        [MobClick event:UMCustomEvent_EnterWorkDesk_Assessment];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self unDealStatusList].count == 0) {
        return;
    }
    //获取已填写的评估数量
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    [dicPost setValue:[self unDealStatusList] forKey:@"statusList"];

    [[TaskManager shareInstance] createTaskWithTaskName:@"AssessmentMessionCountTask" taskParam:dicPost TaskObserver:self];
    
    
}

#pragma mark - Initialize
- (void) createSwitchView
{
    switchview = [[HMSwitchView alloc]init];
    [self.view addSubview:switchview];
    [switchview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self.view);
        make.height.mas_equalTo(@49);
    }];
    
    [switchview setDelegate:self];
    
    [switchview createCells:@[@"已填写", @"全部"]];
}

- (void) createTabbarController
{
    tabbarController = [[UITabBarController alloc]init];
    [self addChildViewController:tabbarController];
    AssessmentMessionsTableViewController* tvcUnDealed = [[AssessmentMessionsTableViewController alloc]initWithStatusLsit:[self unDealStatusList]];
    AssessmentMessionsTableViewController* tvcAllStatus = [[AssessmentMessionsTableViewController alloc]initWithStatusLsit:nil];
    [tabbarController setViewControllers:@[tvcUnDealed, tvcAllStatus]];
    [self.view addSubview:tabbarController.view];
    [tabbarController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(switchview.mas_bottom);
    }];
    [tabbarController.tabBar setHidden:YES];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSArray*) unDealStatusList
{
    NSMutableArray* statusList = [NSMutableArray array];
    BOOL editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAssessmentMode Status:1 OperateCode:kPrivilegeEditOperate];
   if (editPrivilege)
//    if (YES)
    {
        [statusList addObject:@"1"];
    }
    return statusList;
}

#pragma mark - HMSwitchViewDelegate

- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSUInteger) selectedIndex
{
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:selectedIndex>0?@"工作台－评估－全部":@"工作台－评估－已填写"];
    if (tabbarController)
    {
        [tabbarController setSelectedIndex:selectedIndex];
    }
}

#pragma mark TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    
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
    
    if ([taskname isEqualToString:@"AssessmentMessionCountTask"])
    {
        //获取到已填写的评估总数
        if (taskResult && [taskResult isKindOfClass:[NSNumber class]])
        {
            if (switchview)
            {
                NSNumber* numCount = (NSNumber*)taskResult;
                [switchview setCellTitle:[NSString stringWithFormat:@"已填写(%ld)", numCount.integerValue] index:0];
            }
        }
    }
}

@end



@implementation AssessmentMessionsTableViewController

- (id) initWithStatusLsit:(NSArray*) statusList;
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        _statusList = statusList;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadAssessmentMessions];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (assessmentMessions)
    {
        return assessmentMessions.count;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssessmentMessionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AssessmentMessionTableViewCell"];
    if (!cell)
    {
        cell = [[AssessmentMessionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AssessmentMessionTableViewCell"];
    }
    
    AssessmentMessionModel* messionModel = assessmentMessions[indexPath.row];
    [cell setAssessmentMession:messionModel];
    [cell.summaryButton setTag:0x100 + indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //总结按钮是否显示
    [cell.summaryButton addTarget:self action:@selector(summaryAssessmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssessmentMessionModel* messionModel = assessmentMessions[indexPath.row];
    BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAssessmentMode Status:messionModel.status OperateCode:kPrivilegeViewOperate];
    if (!viewPrivilege)
    {
        //没有查看权限
        return;
    }
    //跳转查看评估详情界面 PeriodAssessmentDetailViewController
    NSDictionary* dicModel = [messionModel mj_keyValues];
    AssessmentRecordModel* recordModel = [AssessmentRecordModel mj_objectWithKeyValues:dicModel];
    HMBasePageViewController* vcDetail = [HMViewControllerManager createViewControllerWithControllerName:@"AssessmentDetailViewController" ControllerObject:recordModel];
    [vcDetail.navigationItem setTitle:@"阶段评估报告"];
}

- (void) summaryAssessmentButtonClicked:(id) sender
{
    UIButton* button = (UIButton*) sender;
    NSInteger row = button.tag - 0x100;
    AssessmentMessionModel* messionModel = assessmentMessions[row];
    
    BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAssessmentMode Status:messionModel.status OperateCode:kPrivilegeViewOperate];
    if (!viewPrivilege)
    {
        //没有查看权限
        return;
    }
    //跳转查看评估详情界面 PeriodAssessmentDetailViewController
    NSDictionary* dicModel = [messionModel mj_keyValues];
    AssessmentRecordModel* recordModel = [AssessmentRecordModel mj_objectWithKeyValues:dicModel];
    HMBasePageViewController* vcDetail = [HMViewControllerManager createViewControllerWithControllerName:@"AssessmentSummaryViewController" ControllerObject:recordModel];
    [vcDetail.navigationItem setTitle:@"阶段评估报告"];
}


- (void) loadAssessmentMessions
{
    if (_statusList && _statusList.count == 0)
    {
        [self showBlankView];
        return;
    }
    NSInteger rows = AssessmentMessionListPageSize;
    if (assessmentMessions && assessmentMessions.count>0)
    {
        if (rows > assessmentMessions.count)
        {
            rows = assessmentMessions.count;
        }
        [assessmentMessions removeAllObjects];
        
    }
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    if (self.statusList)
    {
        [dicPost setValue:self.statusList forKey:@"statusList"];
    }
    [self.tableView.superview showWaitView];
    //创建获取评估任务列表任务 AssessmentMessionListTask
    [[TaskManager shareInstance] createTaskWithTaskName:@"AssessmentMessionListTask" taskParam:dicPost TaskObserver:self];
}

- (void) loadMoreAssessmentMessions
{
    NSInteger startRow = 0;
    if (assessmentMessions)
    {
        startRow = assessmentMessions.count;
    }
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    [dicPost setValue:[NSNumber numberWithInteger:startRow] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:AssessmentMessionListPageSize] forKey:@"rows"];
    if (self.statusList)
    {
        [dicPost setValue:self.statusList forKey:@"statusList"];
    }
    //创建获取评估任务列表任务
    [[TaskManager shareInstance] createTaskWithTaskName:@"AssessmentMessionListTask" taskParam:dicPost TaskObserver:self];
}

- (void) assessmentMessionsLoaded:(NSArray*) items
{
    assessmentMessions = [NSMutableArray arrayWithArray:items];
    [self.tableView reloadData];
}

- (void) moreAssessmentMessionsLoaded:(NSArray*) items
{
    if (!assessmentMessions)
    {
        assessmentMessions = [NSMutableArray array];
    }
    
    [assessmentMessions addObjectsFromArray:items];
    [self.tableView reloadData];
    
}

#pragma mark TaskObserver
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
    
    NSDictionary* dicPost = [TaskManager taskparamWithTaskId:taskId];
    if (dicPost && [dicPost isKindOfClass:[NSDictionary class]])
    {
        NSNumber* numStartRow = [dicPost valueForKey:@"startRow"];
        if (numStartRow && [numStartRow isKindOfClass:[NSNumber class]] && numStartRow.integerValue == 0)
        {
            [self.tableView.superview closeWaitView];
        }
        if (totalCount <= assessmentMessions.count)
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            [self.tableView.mj_footer endRefreshing];
        }

    }
    
    if (totalCount > assessmentMessions.count)
    {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAssessmentMessions)];
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
    
    
    if ([taskname isEqualToString:@"AssessmentMessionListTask"])
    {
        NSDictionary* dicPost = [TaskManager taskparamWithTaskId:taskId];
        if (!taskResult || ![taskResult isKindOfClass:[NSDictionary class]])
        {
            return;
        }
        NSDictionary* dicResult = (NSDictionary*) taskResult;
        NSNumber* numCount = [dicResult valueForKey:@"count"];
        NSArray* list = [dicResult valueForKey:@"list"];
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            totalCount = numCount.integerValue;
        }
        
        if (!list || ![list isKindOfClass:[NSArray class]])
        {
            return;
        }
        
        if (dicPost && [dicPost isKindOfClass:[NSDictionary class]])
        {
            NSNumber* numStartRow = [dicPost valueForKey:@"startRow"];
            if (numStartRow && [numStartRow isKindOfClass:[NSNumber class]] && numStartRow.integerValue == 0)
            {
                [self assessmentMessionsLoaded:list];
            }
            else
            {
                [self moreAssessmentMessionsLoaded:list];
                
            }
        }

    }
}

- (BOOL) statusListIsCurrentStatus:(NSArray*) statusItems
{
    BOOL isCurrent = NO;
    if (!statusItems || 0 == self.statusList) {
        return YES;
    }
    
    if (statusItems && self.statusList)
    {
        if (statusItems.count != self.statusList.count)
        {
            return isCurrent;
        }
        
        for (id obj in statusItems)
        {
            if (![obj isKindOfClass:[NSNumber class]]) {
                return isCurrent;
            }
            NSNumber* numStatus = (NSNumber*) obj;
            BOOL isExistedStatus = NO;
            for (NSNumber* numCurStatus in self.statusList)
            {
                if (numStatus.integerValue == numCurStatus.integerValue)
                {
                    isExistedStatus = YES;
                    break;
                }
            }
            if (!isExistedStatus) {
                return isCurrent;
            }
        }
        
        isCurrent = YES;
    }
    
    return isCurrent;
}
@end
