//
//  AppointmentTableViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/30.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AppointmentTableViewController.h"
#import "HMSwitchView.h"
#import "UserAppointmentTableViewCell.h"
#import "ATModuleInteractor+PatientChat.h"
#import "HMThirdEditionPatientViewController.h"

#define kAppointmentPageSize        20

@interface AppointmentStartViewController ()
<HMSwitchViewDelegate>
{
    HMSwitchView* switchview;
    UITabBarController* tabbarController;
    
    AppointmentTableViewController* tvcAppointments;
}
@end

@interface AppointmentTableViewController ()
<TaskObserver>
{
    NSInteger totalCount;
    NSMutableArray* appoints;
    
    AppointmentInfo* dealAppointment;
}

@property (nonatomic, readonly) NSArray* statusList;

- (id) initWithStatusList:(NSArray*) statusList;

@end

@implementation AppointmentStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"约诊"];
    [self createSwitchView];
    
    [self createTabbarController];
    if (UMSDK_isOn) {
        [MobClick event:UMCustomEvent_EnterWorkDesk_Appointment];
    }
}

- (void) createSwitchView
{
    switchview = [[HMSwitchView alloc]init];
    [self.view addSubview:switchview];
    
    //是否拥有处理约诊权限
    BOOL dealPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAppointmentMode Status:1 OperateCode:kPrivilegeProcessOperate];
    //是否拥有确认约诊权限
    BOOL confirmPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAppointmentMode Status:2 OperateCode:kPrivilegeConfirmOperate];
    NSArray* switchTitles = nil;
    switchTitles = @[@"待处理", @"全部"];
    if (dealPrivilege)
    {
        switchTitles = @[@"待处理", @"全部"];
    }
    
    if (confirmPrivilege)
    {
        switchTitles = @[@"待就诊", @"全部"];
    }
    [switchview createCells:switchTitles];
    [switchview setDelegate:self];
    
    [switchview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@49);
    }];
}

- (NSArray*) appointmentDealTableStatus
{
    NSMutableArray* statusList = [NSMutableArray array];
    //是否拥有处理约诊权限
    BOOL dealPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAppointmentMode Status:1 OperateCode:kPrivilegeProcessOperate];
    
    //是否拥有确认约诊权限
    BOOL confirmPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAppointmentMode Status:2 OperateCode:kPrivilegeConfirmOperate];

    if (dealPrivilege) {
        [statusList addObject: @"1"];
    }
    if (confirmPrivilege)
    {
        [statusList addObject: @"2"];;
    }

    return statusList;
}

- (NSArray*) appointmentDealedTableStatus
{
    NSMutableArray* statusList = [NSMutableArray array];
    for (NSInteger status = 1; status <=7; ++status)
    {
        BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAppointmentMode Status:status OperateCode:kPrivilegeViewOperate];
        if (viewPrivilege)
        {
            [statusList addObject:[NSString stringWithFormat:@"%ld", status]];
        }
    }
    return statusList;
}

- (void) createTabbarController
{
    tabbarController = [[UITabBarController alloc]init];
    [self addChildViewController:tabbarController];
    
    AppointmentTableViewController* tvcUnDealAppointments = [[AppointmentTableViewController alloc] initWithStatusList:[self appointmentDealTableStatus]];
    [tvcUnDealAppointments setStaffRole:@"doctor"];
    
    AppointmentTableViewController* tvcAllStatusAppointments = [[AppointmentTableViewController alloc] initWithStatusList:nil];
    [tabbarController setViewControllers:@[tvcUnDealAppointments, tvcAllStatusAppointments]];
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
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:selectedIndex>0?@"工作台－约诊－全部":@"工作台－约诊－待处理"];
    if (tabbarController)
    {
        [tabbarController setSelectedIndex:selectedIndex];
    }
}

@end



@implementation AppointmentTableViewController

- (id) initWithStatusList:(NSArray *)statusList
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _statusList = statusList;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    [self loadAppointments];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) loadAppointments
{
    if (_statusList && 0 == _statusList.count)
    {
        [self showBlankView];
        return;
    }
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    
    
    NSInteger rows = kAppointmentPageSize;
    if (appoints && 0 < appoints.count)
    {
        rows = appoints.count;
    }
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    if (_statusList)
    {
        [dicPost setValue:_statusList forKey:@"statusList"];
    }
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    if (self.staffRole)
    {
        [dicPost setValue:self.staffRole forKey:@"staffRole"];
    }
    
    if (curStaff)
    {
        [dicPost setValue:[NSString stringWithFormat:@"%ld", curStaff.staffId] forKey:@"staffId"];
    }
    [self.tableView.superview showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserAppointmentListTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (appoints)
    {
        return appoints.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 146;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppointmentInfo* appointment = appoints[indexPath.row];
    NSString* cellClassName = [self cellClassName:appointment];
    
    UserAppointmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
    if (!cell)
    {
        cell = [[NSClassFromString(cellClassName) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClassName];
    }
    
    [cell setAppointmentInfo:appointment];
    [cell.dealbutton setTag:0x2500 + indexPath.row];
    [cell.dealbutton addTarget:self action:@selector(dealButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.archiveButton setTag:0x2501 + indexPath.row];
    [cell.archiveButton addTarget:self action:@selector(archiveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (NSString*) cellClassName:(AppointmentInfo*) appointment
{
    NSString* cellClassName = @"UserAppointmentTableViewCell";
    //UserDealedAppointmentTableViewCell
    switch (appointment.status)
    {
        case 1:
        {
            cellClassName = @"UserUnDealedAppointmentTableViewCell";
            break;
        }
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        {
            cellClassName = @"UserDealedAppointmentTableViewCell";
            break;
        }
        default:
            break;
    }
    return cellClassName;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppointmentInfo* appointment = appoints[indexPath.row];
    if (1 == appointment.status)
    {
        [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentDetailViewController" ControllerObject:appointment];
        return;
    }
    //判断是否存在约诊查看权限
    BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAppointmentMode Status:appointment.status OperateCode:kPrivilegeViewOperate];
    if (!viewPrivilege)
    {
        //没有查看权限
        return;
    }
    [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentDetailViewController" ControllerObject:appointment];
}

//跳转档案详情
- (void)archiveButtonClicked:(UIButton *) sender
{
    NSInteger clickedRow = sender.tag - 0x2501;
    AppointmentInfo* appointment = appoints[clickedRow];
    
    //2017-10-31版本 界面修改调整 by Jason
    HMThirdEditionPatientViewController* baseInfoViewController = [[HMThirdEditionPatientViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",(long)appointment.userId]];
    [self.navigationController pushViewController:baseInfoViewController animated:YES];
    
}

- (void) dealButtonClicked:(id) sender
{
    UIButton* clickedButton = (UIButton*) sender;
    NSInteger clickedRow = clickedButton.tag - 0x2500;
    AppointmentInfo* appointment = appoints[clickedRow];
    switch (appointment.status)
    {
        case 1:
        {
            //待处理，顾问进行处理
            BOOL processPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAppointmentMode Status:appointment.status OperateCode:kPrivilegeProcessOperate];
            if (!processPrivilege)
            {
                //没有处理权限
                return;
            }
            //跳转详情即可处理
            [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentDetailViewController" ControllerObject:appointment];
            break;
        }
        case 2:
        {
            //待处理，顾问进行处理
            [self confirmAppointmentButtonClicked:appointment];
            break;
        }
            
        default:
            break;
    }
 }


- (void) appointmentListLoaded:(NSArray*) items
{
    if (!appoints)
    {
        appoints = [NSMutableArray array];
    }
    
    [appoints addObjectsFromArray:items];
    [self.tableView reloadData];
    
    
    if (appoints.count < totalCount)
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAppointmetns)];
    }
    else
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
}



- (void) loadMoreAppointmetns
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    NSInteger startRow = 0;
    if (appoints)
    {
        startRow = appoints.count;
    }
    [dicPost setValue:[NSNumber numberWithInteger:startRow] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kAppointmentPageSize] forKey:@"rows"];
    if (_statusList)
    {
        [dicPost setValue:_statusList forKey:@"statusList"];
    }
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    if (curStaff)
    {
        [dicPost setValue:[NSString stringWithFormat:@"%ld", curStaff.staffId] forKey:@"staffId"];
    }
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserAppointmentListTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - UserAppointmentTableViewCellDelegate

- (void) confirmAppointmentButtonClicked:(AppointmentInfo*) appoint;
{
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    dealAppointment = appoint;
    if (staff.staffId != appoint.staffId)
    {
        //不是指定给我的。
        [self showAlertMessage:@"对不起，您没有该权限。"];
        return;
    }
    BOOL confirmPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAppointmentMode Status:appoint.status OperateCode:kPrivilegeConfirmOperate];
    if (!confirmPrivilege)
    {
        [self showAlertMessage:@"对不起，您没有该权限。"];
        return;
    }
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:@"是否确认该用户已就诊？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setTag:0x1000];
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0x1000 == alertView.tag) {
        NSLog(@"clickedButtonAtIndex %ld", buttonIndex);
        if (1 == buttonIndex)
        {
            //TODO：确认就诊 DealUserAppointmetnTask
            //AppointmentDetail* detail = tvcAppointmentDetail.detail;
            NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
            StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
            [dicPost setValue:[NSString stringWithFormat:@"%ld", curStaff.userId] forKey:@"doUserId"];
            [dicPost setValue:[NSString stringWithFormat:@"%ld", dealAppointment.appointId] forKey:@"appointId"];
            [dicPost setValue:@"Q" forKey:@"status"];
            [[self.tableView superview]showWaitView];
            [[TaskManager shareInstance] createTaskWithTaskName:@"DealUserAppointmetnTask" taskParam:dicPost TaskObserver:self];
        }
    }
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [[self.tableView superview] closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
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
    if ([taskname isEqualToString:@"DealUserAppointmetnTask"])
    {
        //刷新列表
        [self loadAppointments];
    }
    
    if (0 == totalCount)
    {
        [self showBlankView];
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
    
    NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
    if (dicParam && [dicParam isKindOfClass:[NSDictionary class]])
    {
        NSNumber* numStart = [dicParam valueForKey:@"startRow"];
        if (numStart && [numStart isKindOfClass:[NSNumber class]] && 0 == numStart.integerValue)
        {
            appoints = [NSMutableArray array];
        }
    }
    
    if ([taskname isEqualToString:@"UserAppointmentListTask"])
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
            [self appointmentListLoaded:list];
        }
        
    }
}

@end
