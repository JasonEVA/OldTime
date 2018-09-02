//
//  MainStartMessionTableViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/4/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MainStartMessionTableViewController.h"

#import "MainStartMessionTableViewCell.h"
#import "StaffMessionStatistics.h"
#import "ATModuleInteractor+CoordinationInteractor.h"

@interface StaffMessionStatistics (TableCellIcon)

- (NSString*) tableCellIconName;
@end

@implementation StaffMessionStatistics (TableCellIcon)

- (NSString*) tableCellIconName
{
    NSString* iconName = nil;
    if (!self.taskCode || 0 == self.taskCode.length)
    {
        return iconName;
    }
    
    if ([self.taskCode isEqualToString:@"testAlert"])
    {
        //预警
        iconName = @"img_main_mession_warning";
    }
    if ([self.taskCode isEqualToString:@"archives"])
    {
        //建档
        iconName = @"img_main_mession_establish";
    }
    if ([self.taskCode isEqualToString:@"evaluate"])
    {
        //评估
        iconName = @"img_main_mession_assess";
    }
    if ([self.taskCode isEqualToString:@"rounds"])
    {
        //评估
        iconName = @"img_main_mession_rounds";
    }
    if ([self.taskCode isEqualToString:@"survey"])
    {
        //随访
        iconName = @"img_main_mession_survey";
    }
    if ([self.taskCode isEqualToString:@"appoint"])
    {
        //约诊
        iconName = @"img_main_mession_appoint";
    }
    if ([self.taskCode isEqualToString:@"workTask"])
    {
        //协同
        iconName = @"img_main_mession_coordination";
    }
    if ([self.taskCode isEqualToString:@"healthyPlan"])
    {
        //健康计划
        iconName = @"img_main_mession_plan";
    }
    if ([self.taskCode isEqualToString:@"healthyReport"])
    {
        //健康报告
        iconName = @"img_main_mession_report";
    }
    if ([self.taskCode isEqualToString:@"userSchedule"])
    {
        //自定义
        iconName = @"img_main_mession_custom";
    }
    return iconName;
}

@end

@interface MainStartMessionTableViewController ()
<TaskObserver>
{
    NSArray* messionStatisticList;
}
@end

/*
typedef enum : NSUInteger {
    MessionTable_Alert,             //预警
    MessionTable_Document,          //建档
    MessionTable_Assessment,        //评估
    MessionTable_Survey,            //随访
    MessionTable_Appoint,           //约诊
    MessionTable_Coordination,      //协调任务
    MessionTable_Plan,              //健康计划
    MessionTable_Report,            //健康报告
    MessionTable_Custom,            //自定义任务
    MainStartMessionTableIndexCount,
} MainStartMessionTableIndex;

 */
@implementation MainStartMessionTableViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startStaffMessionStatisticsTask) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //StaffMessionStatisticsTask
    [self startStaffMessionStatisticsTask];
}

- (void)startStaffMessionStatisticsTask {
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"StaffMessionStatisticsTask" taskParam:dicPost TaskObserver:self];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return MainStartMessionTableIndexCount;
    if (messionStatisticList)
    {
        return messionStatisticList.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StaffMessionStatistics* statistics = messionStatisticList[indexPath.row];
    NSString* cellClass = [self cellClassName:statistics];
    MainStartMessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClass];
    if (!cell)
    {
        cell = [[NSClassFromString(cellClass) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClass];
    }
    
    // Configure the cell...
    
    [cell setMessionType:statistics.taskName Icon:[UIImage imageNamed:[statistics tableCellIconName]]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setMessionComment:@""];
    if (statistics)
    {
//        [cell setMessionComment:[statistics messionStatisticString]];
        [cell setMessionComment:statistics.numInfo];
    }
    return cell;
}

- (NSString*) cellClassName:(StaffMessionStatistics*) statistics
{
    NSString* cellClassName = @"MainStartMessionTableViewCell";
    if (!statistics.taskCode || 0 == statistics.taskCode.length)
    {
        return cellClassName;
    }
    if ([statistics.taskCode isEqualToString:@"testAlert"])
    {
        cellClassName = @"MainStartWarningMessionTableViewCell";
    }
    return cellClassName;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaffMessionStatistics* statistics = messionStatisticList[indexPath.row];
    
    if (!statistics.taskCode || 0 == statistics.taskCode.length)
    {
        return;
    }
    
    if ([statistics.taskCode isEqualToString:@"testAlert"])
    {
        //预警
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－预警"];
        [HMViewControllerManager createViewControllerWithControllerName:@"MainStartAlertStartViewController" ControllerObject:nil];
    }
    if ([statistics.taskCode isEqualToString:@"archives"])
    {
        //建档
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－建档"];
        [HMViewControllerManager createViewControllerWithControllerName:@"CreateDocumentStartViewController" ControllerObject:nil];
    }
    if ([statistics.taskCode isEqualToString:@"evaluate"])
    {
        //评估
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－评估"];
        [HMViewControllerManager createViewControllerWithControllerName:@"AssessmentMessionsViewController" ControllerObject:nil];
    }
    //
    if ([statistics.taskCode isEqualToString:@"rounds"])
    {
        //查房
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－查房"];
        [HMViewControllerManager createViewControllerWithControllerName:@"SERoundsMainViewController" ControllerObject:nil];
    }
    if ([statistics.taskCode isEqualToString:@"survey"])
    {
        //随访
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－随访"];
        [HMViewControllerManager createViewControllerWithControllerName:@"SurveyMessionStartViewController" ControllerObject:nil];
    }
    if ([statistics.taskCode isEqualToString:@"appoint"])
    {
        //约诊
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－约诊"];
        [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentStartViewController" ControllerObject:nil];
    }
    if ([statistics.taskCode isEqualToString:@"workTask"])
    {
        //协同
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－协同任务"];
        [[ATModuleInteractor sharedInstance] goTaskList];
    }
    if ([statistics.taskCode isEqualToString:@"healthyPlan"])
    {
        //健康计划
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－健康计划"];
        [HMViewControllerManager createViewControllerWithControllerName:@"HealthPlanMessionStartViewController" ControllerObject:nil];
    }
    if ([statistics.taskCode isEqualToString:@"healthyReport"])
    {
        //健康报告
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－健康报告"];
        [HMViewControllerManager createViewControllerWithControllerName:@"HealthReportStartViewController" ControllerObject:nil];
    }
    if ([statistics.taskCode isEqualToString:@"userSchedule"])
    {
        //自定义
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－自定义"];
        [HMViewControllerManager createViewControllerWithControllerName:@"CustomTaskViewController" ControllerObject:nil];
    }
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError) {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    [self.tableView reloadData];
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
    if ([taskname isEqualToString:@"StaffMessionStatisticsTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            messionStatisticList = (NSArray*) taskResult;
        }
    }
}
@end
