//
//  MainStartAlertTableViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/2.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MainStartAlertTableViewController.h"
#import "MainStartUesrAlertTableViewCell.h"
#import "DealUesrAlertViewController.h"
#import "DealUserWarningViewController.h"
#import "DetectRecord.h"
#import "HMSwitchView.h"
#import "ATModuleInteractor+PatientChat.h"
#import "PatientInfo.h"
#import "HMThirdEditionPatientViewController.h"

@interface MainStartAlertStartViewController ()<HMSwitchViewDelegate>
{
//    MainStartAlertTableViewController* tvcAlert;
    UITabBarController* tabbarController;
    HMSwitchView *switchview;
}
@property (nonatomic, assign)NSInteger alertStatus;

@end

#define kMainStartAlertPageSize     20
#define   HEALTHYWARMINGNOTIFICATION    @"healthyWarmingNotification"

@interface MainStartAlertTableViewController ()
<TaskObserver>
{
    NSMutableArray* alertItems;
    NSInteger totalCount;
}
@property (nonatomic, strong) UserAlertInfo *dealUserInfo;
- (id) initWithDoStatus:(NSInteger) doStatus;


@property (nonatomic, readonly)NSInteger alertStatus;

@end

@implementation MainStartAlertStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"预警"];
    
    [self createSwitchView];
   [self createTabbar];
    
}

#pragma mark - Initialize
- (void) createSwitchView
{
    switchview = [[HMSwitchView alloc]init];
    [self.view addSubview:switchview];
    [switchview createCells:@[@"待处理", @"全部"]];
    [switchview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@47);
    }];
    [switchview setDelegate:self];
    
    
}

- (void) createTabbar
{
    tabbarController = [[UITabBarController alloc]init];
    [self addChildViewController:tabbarController];
    
    MainStartAlertTableViewController* tvcUndealed = [[MainStartAlertTableViewController alloc]initWithDoStatus:0];
    MainStartAlertTableViewController* tvcAllStatus = [[MainStartAlertTableViewController alloc]initWithDoStatus:1];
    [tabbarController setViewControllers:@[tvcUndealed, tvcAllStatus]];
    [self.view addSubview:tabbarController.view];
    [tabbarController.tabBar setHidden:YES];
    
    [tabbarController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(switchview.mas_bottom);
    }];
}

#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSUInteger) selectedIndex
{
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:selectedIndex>0?@"工作台－预警－全部":@"工作台－预警－待处理"];
    if (tabbarController) {
        [tabbarController setSelectedIndex:selectedIndex];
    }
}

@end



@implementation MainStartAlertTableViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id) initWithDoStatus:(NSInteger) doStatus
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _alertStatus = doStatus;
    }
    return self;
}

- (void)viewDidLoad{

    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAlertList) name:HEALTHYWARMINGNOTIFICATION object:nil];

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
    //刷新列表
    [self loadAlertList];
}

- (void)reloadAlertList {
    [alertItems removeAllObjects];
    totalCount = 0;
    [self loadAlertList];
}


- (void) loadAlertList
{
    if (0 == self.alertStatus)
    {
        BOOL processPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeWarmMode Status:self.alertStatus OperateCode:kPrivilegeProcessOperate];
        if (!processPrivilege )
        {
            
            [self showBlankView];
            return;
        }
    }
    
    NSInteger startRows = 0;
    NSInteger rows = kMainStartAlertPageSize;
    
    if (alertItems.count > rows)
    {
        rows = alertItems.count;
    }
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:startRows] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
//   [dicPost setValue:[NSNumber numberWithInteger:_alertStatus] forKey:@"doStatus"];
    if (_alertStatus == 0) {
        [dicPost setValue:[NSNumber numberWithInteger:_alertStatus] forKey:@"doStatus"];
    }
    
    [self.tableView showWaitView];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserAlertListTask" taskParam:dicPost TaskObserver:self];
}

- (void) loadMoreAlertItems
{
    NSInteger startRows = 0;
    NSInteger rows = kMainStartAlertPageSize;
    if (alertItems.count > 0)
    {
        startRows = alertItems.count;
    }
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:startRows] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    
    if (_alertStatus == 0) {
        [dicPost setValue:[NSNumber numberWithInteger:_alertStatus] forKey:@"doStatus"];
    }
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserAlertListTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) alertItemsLoaded:(NSArray*)items
{
    [alertItems addObjectsFromArray:items];
//    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (alertItems)
    {
        return alertItems.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserAlertInfo* alert = alertItems[indexPath.row];
    if (alert.doStatus != 0 && [alert.doWay isEqualToString:@"其他方式"]){
        return 200;
    }
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserAlertInfo* alert = alertItems[indexPath.row];
    if (alert.doStatus != 0) {
        MainStartUesrAlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainStartUesrAlertTableViewCell"];
        if (!cell)
        {
            cell = [[MainStartUesrAlertTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainStartUesrAlertTableViewCell"];
        }
        // Configure the cell...
//        UserAlertInfo* alert = alertItems[indexPath.row];
        [cell setUserAlert:alert];
        
        [cell.userAlertView.archiveButton setTag:(0x1501 + indexPath.row)];
        [cell.userAlertView.archiveButton addTarget:self action:@selector(archiveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else{
        MainStartUesrAlertUndealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainStartUesrAlertUndealTableViewCell"];
        if (!cell){
            cell = [[MainStartUesrAlertUndealTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainStartUesrAlertUndealTableViewCell"];
        }
        
        [cell setUserAlert:alert];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.undealView.statusbutton setTag:(0x1500 + indexPath.row)];
        [cell.undealView.statusbutton addTarget:self action:@selector(statusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.userAlertView.archiveButton setTag:(0x1501 + indexPath.row)];
        [cell.userAlertView.archiveButton addTarget:self action:@selector(archiveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.undealView.contactBtn setTag:(0x1502 + indexPath.row)];
        [cell.undealView.contactBtn addTarget:self action:@selector(contactBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }

    
    return nil;
}

//跳转档案详情
- (void)archiveButtonClicked:(UIButton *) sender
{
    NSInteger tagIndex = sender.tag - 0x1501;
    UserAlertInfo* alert = alertItems[tagIndex];
    //2017-10-31版本 界面修改调整 by Jason
    HMThirdEditionPatientViewController* baseInfoViewController = [[HMThirdEditionPatientViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",(long)alert.userId]];
    [self.navigationController pushViewController:baseInfoViewController animated:YES];
    
}

//跳转到IM界面
- (void)contactBtnClick:(UIButton *)sender
{
    NSInteger tagIndex = sender.tag - 0x1502;
    UserAlertInfo* alert = alertItems[tagIndex];
    if (0 > tagIndex || tagIndex >= alertItems.count) {
        return;
    }
    self.dealUserInfo = alert;
    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:alert.testResulId forKey:@"testResulId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"DoContactPatientTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    [footerview setBackgroundColor:[UIColor clearColor]];
    return footerview;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserAlertInfo* alert = alertItems[indexPath.row];
    if (!alert.kpiCode || 0 == alert.kpiCode.length)
    {
        return;
    }
    
    //判断是否存在查看权限
    BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeWarmMode Status:alert.doStatus OperateCode:kPrivilegeViewOperate];
    if (!viewPrivilege)
    {
        //没有查看权限，不能查看
        return;
    }
    
    DetectRecord* record = [[DetectRecord alloc]init];
    [record setTestDataId:alert.sourceTestDataId];
    
    if ([alert.sourceKpiCode isEqualToString:@"XY"])
    {
        //血压 跳转到血压监测结果页面
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureResultContentViewController" ControllerObject:record];
        return;
    }
    if ([alert.sourceKpiCode isEqualToString:@"XD"])
    {
        //心率 跳转到心电监测详情页面
        [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectResultContentViewController" ControllerObject:record];
        return;
    }
    if ([alert.sourceKpiCode isEqualToString:@"TZ"])
    {
        //体重 跳转到体重监测结果页面
        [HMViewControllerManager createViewControllerWithControllerName:@"BodyWeightResultContentViewController" ControllerObject:record];
        return;
    }
    if ([alert.sourceKpiCode isEqualToString:@"XT"])
    {
        //血糖 跳转到血糖监测结果页面
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodSugarDetectResultViewController" ControllerObject:record];
        return;
    }
    if ([alert.sourceKpiCode isEqualToString:@"XZ"])
    {
        //血脂 跳转到血脂监测结果页面
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodFatDetectResultViewController" ControllerObject:record];
        return;
    }
    if ([alert.sourceKpiCode isEqualToString:@"OXY"])
    {
        //血痒 跳转到血痒监测结果页面
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodOxygenResultContentViewController" ControllerObject:record];
        return;
    }
    if ([alert.sourceKpiCode isEqualToString:@"HX"])
    {
        //呼吸 跳转到呼吸监测结果页面
        [HMViewControllerManager createViewControllerWithControllerName:@"BreathingDetectResultViewController" ControllerObject:record];
        return;
    }
}

- (void) statusButtonClicked:(id) sender
{
    if (![sender isKindOfClass:[UIButton class]])
    {
        return;
    }
    UIButton* button = (UIButton*) sender;
    NSInteger row = button.tag - 0x1500;
    if (0 > row || row >= alertItems.count) {
        return;
    }
    
    UserAlertInfo* alert = alertItems[row];
    if (!alert.testResulId)
    {
        return;
    }
    
    //判断是否存在处理权限
    BOOL processPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeWarmMode Status:alert.doStatus OperateCode:kPrivilegeProcessOperate];
    if (!processPrivilege)
    {
        //没有处理权限
        return;
    }
    
    //处理预警
    [HMViewControllerManager createViewControllerWithControllerName:@"DealUserWarningViewController" ControllerObject:alert];
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView.superview closeWaitView];
    if (alertItems.count < totalCount)
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAlertItems)];
    }
    else
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    [self.tableView reloadData];
    if (StepError_None != taskError) {
        [self showAlertMessage:errorMessage];
        
    }
    
    if (0 == totalCount || (alertItems && alertItems.count == 0))
    {
        [self showBlankView];
    }
    else
    {
        [self closeBlankView];
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length) {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
    if (dicParam && [dicParam isKindOfClass:[NSDictionary class]])
    {
        NSNumber* numStart = [dicParam valueForKey:@"startRow"];
        if (numStart && [numStart isKindOfClass:[NSNumber class]] && 0 == numStart.integerValue)
        {
            alertItems = [NSMutableArray array];
        }
    }
    
    if ([taskname isEqualToString:@"UserAlertListTask"]) {
        if ([taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*)taskResult;
            NSNumber* numCount = [dicResult valueForKey:@"count"];
            NSArray* list = [dicResult valueForKey:@"list"];
            
            if (numCount && [numCount isKindOfClass:[NSNumber class]])
            {
                totalCount = numCount.integerValue;
            }
            
            if (list && [list isKindOfClass:[NSArray class]])
            {
                [self alertItemsLoaded:list];
            }
        }
    }

    if ([taskname isEqualToString:@"DoContactPatientTask"]) {
        PatientInfo *JWPatientModel = [self.dealUserInfo convertToPatientInfo];
        [[ATModuleInteractor sharedInstance] goToPatientInfoDetailWithUid:[NSString stringWithFormat:@"%ld",(long)JWPatientModel.userId]];
    }

}

@end
