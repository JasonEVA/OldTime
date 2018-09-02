//
//  DoctorTeamListTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DoctorTeamListTableViewController.h"
#import "DoctorTeamOrgDeptSelectView.h"

#import "HosipitalSelectViewController.h"
#import "DepartmentSelectViewController.h"

#import "DoctorTeamTableViewCell.h"

#define kTeamListPageSize           20


@interface DoctorTeamListStartViewController ()
<HosipitalSelectDelegate,
DepartmentSelectDelegate>
{
    DoctorTeamOrgDeptSelectView* selectview;
    UIViewController* vcTableContent;
    NSInteger selectedOrgId;
    NSInteger selectedDeptId;
    
    DoctorTeamListTableViewController* tvcTeams;
}
@end

@interface DoctorTeamListTableViewController ()
<TaskObserver>
{
    NSMutableArray* teamItems;
    NSInteger selectedOrgId;
    NSInteger selectedDeptId;
    
    NSInteger totalCount;
}

- (void) setSelectedOrgId:(NSInteger) orgId;
- (void) setSelectedDeptId:(NSInteger) depId;
@end

@implementation DoctorTeamListStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"名医团队"];
    
    //创建搜索按钮
    UIBarButtonItem* bbiSearch = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_image"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBarButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:bbiSearch];

    selectview = [[DoctorTeamOrgDeptSelectView alloc]init];
    [self.view addSubview:selectview];
    [selectview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@44);
    }];
    
    [selectview.orgSelectCell addTarget:self action:@selector(orgselectcellClicked:) forControlEvents:UIControlEventTouchUpInside];
    [selectview.deptSelectCell addTarget:self action:@selector(deptselectcellClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    vcTableContent = [[UIViewController alloc]initWithNibName:nil bundle:nil];
    [self addChildViewController:vcTableContent];
    [self.view addSubview:vcTableContent.view];
    [vcTableContent.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(selectview.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    tvcTeams = [[DoctorTeamListTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [vcTableContent addChildViewController:tvcTeams];
    [vcTableContent.view addSubview:tvcTeams.tableView];
    [tvcTeams.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(vcTableContent.view);
        make.top.and.bottom.equalTo(vcTableContent.view);
    }];
}

- (void) searchBarButtonClicked:(id) sender
{
    //搜索按钮点击事件 SearchServiceStartViewController
    [HMViewControllerManager createViewControllerWithControllerName:@"SearchServiceStartViewController" ControllerObject:nil];
}

- (void) orgselectcellClicked:(id) sender
{
    [HosipitalSelectViewController showInParentController:vcTableContent Delegate:self];
}

- (void) deptselectcellClicked:(id) sender
{
    if (0 == selectedOrgId)
    {
        [self showAlertMessage:@"请先选择医院"];
        return;
    }
    [DepartmentSelectViewController showInParentController:vcTableContent Delegate:self OrgId:selectedOrgId];
}

#pragma mark - HosipitalSelectDelegate
- (void) hosipitalSelected:(HosipitalInfo *)hosipital
{
    if (!hosipital)
    {
        return;
    }
    [selectview.orgSelectCell setSelectedName:hosipital.orgShortName];
    selectedOrgId = hosipital.orgId;
    [selectview.deptSelectCell setSelectedName:@"全部科室"];
    selectedDeptId = 0;
    
    [tvcTeams setSelectedOrgId:selectedOrgId];
}


- (void) departmentSelected:(DepartmentInfo *)department
{
    if (!department)
    {
        return;
    }
    [selectview.deptSelectCell setSelectedName:department.depName];
    selectedDeptId = department.depId;
    
    [tvcTeams setSelectedDeptId:selectedDeptId];
}

@end



@implementation DoctorTeamListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self loadTeamList];
}

- (void) loadTeamList
{
    totalCount = 0;
    teamItems = [NSMutableArray array];
    [self.tableView reloadData];
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    if (0 < selectedOrgId)
    {
        [dicPost setValue:[NSString stringWithFormat:@"%ld", selectedOrgId] forKey:@"orgId"];
    }
    if (0 < selectedDeptId)
    {
        [dicPost setValue:[NSString stringWithFormat:@"%ld", selectedDeptId] forKey:@"depId"];
    }
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kTeamListPageSize] forKey:@"rows"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"TeamListTask" taskParam:dicPost TaskObserver:self];
}

- (void) loadMoreRecords
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    if (0 < selectedOrgId)
    {
        [dicPost setValue:[NSString stringWithFormat:@"%ld", selectedOrgId] forKey:@"orgId"];
    }
    if (0 < selectedDeptId)
    {
        [dicPost setValue:[NSString stringWithFormat:@"%ld", selectedDeptId] forKey:@"depId"];
    }
    
    [dicPost setValue:[NSNumber numberWithInteger:kTeamListPageSize] forKey:@"rows"];
    [dicPost setValue:[NSNumber numberWithInteger:teamItems.count] forKey:@"startRow"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"TeamListTask" taskParam:dicPost TaskObserver:self];
}

- (void) setSelectedOrgId:(NSInteger) orgId
{
    selectedDeptId = 0;
    selectedOrgId = orgId;
    [self loadTeamList];
}

- (void) setSelectedDeptId:(NSInteger) depId
{
    selectedDeptId = depId;
    [self loadTeamList];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) teamItemsLoaded:(NSArray*) items
{
    teamItems = [NSMutableArray arrayWithArray:items];
    [self.tableView reloadData];
    
}

- (void) moreTeamItemsLoaded:(NSArray*) items
{
    if (!teamItems)
    {
        teamItems = [NSMutableArray array];
    }
    [teamItems addObjectsFromArray:items];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (teamItems)
    {
        return teamItems.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 0.5)];
    [footer setBackgroundColor:[UIColor commonBackgroundColor]];
    return footer;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DoctorTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoctorTeamTableViewCell"];
    if (!cell)
    {
        cell = [[DoctorTeamTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DoctorTeamTableViewCell"];
    }
    // Configure the cell...
    TeamInfo* team = teamItems[indexPath.row];
    [cell setTeamInfo:team];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamInfo* team = teamItems[indexPath.row];
    //TeamDetailViewController
    [HMViewControllerManager createViewControllerWithControllerName:@"TeamDetailViewController" ControllerObject:team];
}


- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView.mj_footer endRefreshing];
    if (StepError_None != taskError) {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    if (teamItems.count >= totalCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRecords)];
    }
    
    if (0 == teamItems.count) {
        [self showBlankView];
    }
    else
    {
        [self closeBlankView];
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    
    if (!taskname || 0 == taskname)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"TeamListTask"]) {
        NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
        if (dicParam && [dicParam isKindOfClass:[NSDictionary class]])
        {
            NSNumber* numStart = [dicParam valueForKey:@"startRow"];
            if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
            {
                NSDictionary* dicResult = (NSDictionary*) taskResult;
                if (dicResult && [dicResult isKindOfClass:[NSDictionary class]])
                {
                    NSNumber* numCount = [dicResult valueForKey:@"count"];
                    NSArray* lstTeams = [dicResult valueForKey:@"list"];
                    if (numCount && [numCount isKindOfClass:[NSNumber class]])
                    {
                        totalCount = numCount.integerValue;
                    }
                    
                    
                    if (lstTeams && [lstTeams isKindOfClass:[NSArray class]])
                    {
                        if (!numStart || 0 == numStart.integerValue) {
                            [self teamItemsLoaded:lstTeams];
                        }
                        else
                        {
                            [self moreTeamItemsLoaded:lstTeams];
                        }
                        
                    }
                }
            }
        }
    }
}

@end
