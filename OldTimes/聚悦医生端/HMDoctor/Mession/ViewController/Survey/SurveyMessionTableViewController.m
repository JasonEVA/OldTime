//
//  SurveyMessionTableViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "SurveyMessionTableViewController.h"
#import "HMSwitchView.h"
#import "SurveyMessionTableViewCell.h"
#import "ATModuleInteractor+PatientChat.h"

#define kSurveyPageSize            20

@interface SurveyMessionStartViewController ()
<UISearchBarDelegate,
HMSwitchViewDelegate>
{
    HMSwitchView* switchview;
    UISearchBar* searchbar;
    
    UITabBarController* tabbarController;
}
@end

@interface SurveyMessionTableViewController ()
<TaskObserver>
{
    NSInteger totalCount;
    NSMutableArray* surveyRecordItems;
}

@property (nonatomic, readonly) NSInteger type;

- (id) initWithSurveyType:(NSInteger) type;
@end

@implementation SurveyMessionStartViewController


- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.navigationItem setTitle:@"随访"];
    [self createSwitchView];
    [self createTabbar];
}

- (void) createSwitchView
{
    switchview = [[HMSwitchView alloc]init];
    [self.view addSubview:switchview];
    [switchview setDelegate:self];
    
    [switchview createCells:@[@"待处理", @"全部"]];
    [switchview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@50);
    }];
}

- (void) createSearchBar
{
    searchbar = [[UISearchBar alloc]init];
    [self.view addSubview:searchbar];
    
    [searchbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(switchview.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@45);
    }];
    [searchbar setReturnKeyType:UIReturnKeySearch];
    [searchbar setPlaceholder:@"请输入姓名搜索"];
    [searchbar setBackgroundImage:[UIImage imageColor:[UIColor colorWithHexString:@"f0f0f0"] size:CGSizeMake(1, 1) cornerRadius:0]];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchbar resignFirstResponder];
}



- (void) createTabbar
{
    tabbarController = [[UITabBarController alloc]init];
    [self addChildViewController:tabbarController];
    //待处理
    
    SurveyMessionTableViewController* tvcUndealed = [[SurveyMessionTableViewController alloc]initWithSurveyType:1];
    //全部
    SurveyMessionTableViewController* tvcAllMession = [[SurveyMessionTableViewController alloc]initWithSurveyType:0];
    [tabbarController setViewControllers:@[tvcUndealed, tvcAllMession]];
    [self.view addSubview:tabbarController.view];
    [tabbarController.tabBar setHidden:YES];
    [tabbarController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(switchview.mas_bottom);
    }];

}

#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView *)switchview SelectedIndex:(NSUInteger)selectedIndex
{
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:selectedIndex>0?@"工作台－随访－全部":@"工作台－随访－待处理"];
    if (tabbarController)
    {
        [tabbarController setSelectedIndex:selectedIndex];
    }
}
@end



@implementation SurveyMessionTableViewController

- (id) initWithSurveyType:(NSInteger) type
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadSurveyItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadSurveyItems
{
    if (self.type == 1)
    {
        BOOL replay = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeSurveyMode Status:1 OperateCode:kPrivilegeReplyOperate];
        if (!replay)
        {
            [self showBlankView];
            return;
        }
    }
    
    NSInteger rows = kSurveyPageSize;
    if (surveyRecordItems && 0 < surveyRecordItems.count)
    {
        rows = surveyRecordItems.count;
    }
    
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    [dicPost setValue:@[@"1"] forKey:@"surveyTypes"];
    [dicPost setValue:[NSNumber numberWithInteger:_type] forKey:@"type"];
    [dicPost setValue:[NSNumber numberWithLong:0] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithLong:rows] forKey:@"rows"];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.userId] forKey:@"staffUserId"];
    [self.tableView.superview showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"SurveyRecordTask" taskParam:dicPost TaskObserver:self];
}

- (void) loadMoreSurveyItem
{
    NSDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:@[@"1"] forKey:@"surveyTypes"];
    if (surveyRecordItems)
    {
        [dicPost setValue:[NSNumber numberWithLong:surveyRecordItems.count] forKey:@"startRow"];
    }
    
    [dicPost setValue:[NSNumber numberWithLong:kSurveyPageSize] forKey:@"rows"];
    
    [dicPost setValue:[NSNumber numberWithInteger:_type] forKey:@"type"];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.userId] forKey:@"staffUserId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"SurveyRecordTask" taskParam:dicPost TaskObserver:self];
}



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (surveyRecordItems) {
        return surveyRecordItems.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SurveyRecord* record = surveyRecordItems[indexPath.row];
    return record.status ? 150 : 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SurveyMessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SurveyMessionTableViewCell"];
    if (!cell)
    {
        cell = [[SurveyMessionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SurveyMessionTableViewCell"];
    }
    // Configure the cell...
    SurveyRecord* record = surveyRecordItems[indexPath.row];
    [cell setSurveyRecord:record];
    [cell.replyButton setTag:indexPath.row + 0x2100];
    [cell.replyButton addTarget:self action:@selector(replyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.archiveButton setTag:indexPath.row + 0x2101];
    [cell.archiveButton addTarget:self action:@selector(archiveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SurveyRecord *record = [surveyRecordItems objectAtIndex:indexPath.row];
    if (0 == record.status)
    {
        //患者还没有填写
        return;
    }
    
    BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeSurveyMode Status:record.status OperateCode:kPrivilegeViewOperate];
    if (!viewPrivilege)
    {
        //判断是否拥有查看随访权限
        [self showAlertMessage:@"您的帐号没有此功能权限。"];
        return;
    }
    
    [HMViewControllerManager createViewControllerWithControllerName:@"SurveyRecordDatailViewController" ControllerObject:record];
}

- (void) replyButtonClicked:(id) sender
{
    UIButton* replyButton = (UIButton*) sender;
    NSInteger replyRow = replyButton.tag - 0x2100;
    SurveyRecord* record = surveyRecordItems[replyRow];
    
    BOOL replyPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeSurveyMode Status:record.status OperateCode:kPrivilegeReplyOperate];
    if (!replyPrivilege)
    {
        //判断是否拥有查看随访权限
        [self showAlertMessage:@"您的帐号没有此功能权限。"];
        return;
    }
    
    [HMViewControllerManager createViewControllerWithControllerName:@"SurveyRecordDatailViewController" ControllerObject:record];
}

//跳转档案详情
- (void)archiveButtonClicked:(UIButton *) sender
{
    NSInteger replyRow = sender.tag - 0x2101;
    SurveyRecord* record = surveyRecordItems[replyRow];
    //2017-10-31版本 界面修改调整 byJason
    [[ATModuleInteractor sharedInstance] goToPatientInfoDetailWithUid:[NSString stringWithFormat:@"%ld",(long)record.userId]];
}

- (void) surveyRecordListLoaded:(NSArray*) surveyItems
{
    surveyRecordItems = [NSMutableArray arrayWithArray:surveyItems];
    [self.tableView reloadData];
    
    if (surveyRecordItems.count >= totalCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData ];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSurveyItem)];
    }
    
}

- (void)moreSurveyRecordListLoaded:(NSArray*) surveyItems
{
    if (!surveyRecordItems)
    {
        surveyRecordItems = [NSMutableArray array];
    }
    [surveyRecordItems addObjectsFromArray:surveyItems];
    [self.tableView reloadData];
    
    if (surveyRecordItems.count >= totalCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData ];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSurveyItem)];
    }
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView.superview closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
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
    
    if ([taskname isEqualToString:@"SurveyRecordTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            
            NSNumber* numCount = [dicResult valueForKey:@"count"];
            if (numCount && [numCount isKindOfClass:[NSNumber class]])
            {
                totalCount = numCount.integerValue;
            }
            
            NSArray *Items = [dicResult valueForKey:@"list"];
            
            NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
            NSNumber* numStart = [dicParam valueForKey:@"startRow"];
            if (numStart && [numStart isKindOfClass:[NSNumber class]] && 0 < numStart.integerValue)
            {
                //加载
                [self moreSurveyRecordListLoaded:Items];
                return;
            }
            else
            {
                [self surveyRecordListLoaded:Items];
            }
        }
    }
    
}


@end
