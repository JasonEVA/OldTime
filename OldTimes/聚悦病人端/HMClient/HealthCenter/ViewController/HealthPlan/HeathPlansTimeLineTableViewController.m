//
//  HeathPlansTimeLineTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HeathPlansTimeLineTableViewController.h"
#import "HealthPlansTimeLineTableHeaderView.h"
#import "HealthCenterPlanTaskTableViewCell.h"
#import "ZJKDatePickerSheet.h"
#import "SurveyRecord.h"
#import "DetectPlanInfo.h"
#import "DetectRecord.h"
#import "EvaluationListRecord.h"

@interface HeathPlansTimeLineTableViewController ()
<TaskObserver, ZJKPickerSheetDelegate>
{
    HealthPlansTimeLineTableHeaderView* headerview;
    NSString* dateString;
    NSArray* planList;
}
@end

@implementation HeathPlansTimeLineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    headerview = [[HealthPlansTimeLineTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    [headerview.dateView addTarget:self action:@selector(dateControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    if (!dateString)
    {
        NSString* dateStr = [[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd"];
        [self setDate:dateStr];
    }
    else
    {
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:dateString forKey:@"dateStr"];
        planList = nil;
        [self.tableView reloadData];
        [[TaskManager shareInstance]createTaskWithTaskName:@"HealthPlanDailyListTask" taskParam:dicPost TaskObserver:self];

    }
}

- (void) dateControlClicked:(id) sender
{
    ZJKDatePickerSheet* datePicker = [[ZJKDatePickerSheet alloc]init];
    
    [datePicker setDelegate:self];
    [datePicker show];
}

- (void) pickersheet:(id)sheet selectedResult:(NSString*) result
{
    [self setDate:result];
}

- (void) setDate:(NSString*) dateStr
{
    dateString = dateStr;
    //HealthPlanDailyListTask
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:dateString forKey:@"dateStr"];
    [[TaskManager shareInstance]createTaskWithTaskName:@"HealthPlanDailyListTask" taskParam:dicPost TaskObserver:self];
    if (headerview)
    {
        [headerview setDateString:dateStr];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (planList)
    {
        return planList.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return headerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlanMessionListItem* planItem = planList[indexPath.row];
    return [planItem cellHeihgt];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthCenterPlanTaskTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HealthCenterPlanTaskTableViewCell"];
    if (!cell)
    {
        cell = [[HealthCenterPlanTaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthCenterPlanTaskTableViewCell"];
    }
    PlanMessionListItem* planItem = planList[indexPath.row];
    [cell setPlanMession:planItem];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (BOOL) dateIsAfterToday
{
    NSDate* planDate = [NSDate dateWithString:dateString formatString:@"yyyy-MM-dd"];
    NSTimeInterval ti = [planDate timeIntervalSinceDate:[NSDate date]];
    if (ti > 0)
    {
        return YES;
    }
    return NO;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlanMessionListItem* planItem = planList[indexPath.row];
    if ([self dateIsAfterToday])
    {
        return;
    }
//    if (0 == planItem.status)
//    {
//        return;
//    }
    NSString* code = planItem.code;
    if (!code || 0 == code.length)
    {
        return;
    }
    
    if ([planItem.status isEqualToString:@"0"])
    {
        //未开始
        return;
    }
    
    if ([code isEqualToString:@"TEST"])
    {
        if ([planItem.status isEqualToString:@"2"])
        {
            //已测量
            NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
            [dicPost setValue:planItem.taskId forKey:@"taskId"];
            [[TaskManager shareInstance] createTaskWithTaskName:@"UserDetectPlanInfoTask" taskParam:dicPost TaskObserver:self];
            return;
        }
        //监测计划 跳转检测界面
        if ([planItem.kpiCode isEqualToString:@"XL"])
        {
            if ([planItem.status isEqualToString:@"3"])
            {
                return;
            }
        }
        [self entryDetectController:planItem.kpiCode TaskId:planItem.taskId];
        return;
    }
    
    if ([code isEqualToString:@"NUTRITION"])
    {
        //营养，记饮食
        [self entryNutrtuin:planItem];
        return;
    }
    if ([code isEqualToString:@"MENTALITY"])
    {
        //心情
        [self entryMentality:planItem];
        return;
    }
    if ([code isEqualToString:@"DRUGS"])
    {
        //用药 MedicationPlanViewStartController
        [HMViewControllerManager createViewControllerWithControllerName:@"MedicationPlanViewStartController" ControllerObject:dateString];
        return;
    }
    if ([code isEqualToString:@"SPORTS"])
    {
        //记运动
        [HMViewControllerManager createViewControllerWithControllerName:@"RecordSportsExecuteViewController" ControllerObject:nil];
    }
    
    if ([code isEqualToString:@"SURVEY"])
    {
        //随访
        SurveyRecord *record = [[SurveyRecord alloc]init];
        [record setSurveyId:planItem.taskId];
        [record setSurveyMoudleName:planItem.taskCon];
        UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
        
        [record setUserId:[NSString stringWithFormat:@"%ld", curUser.userId]];
        if ([planItem.status isEqualToString:@"2"]) {
            //跳转到随访详情
            [record setFillTime:dateString];

        }
        [HMViewControllerManager createViewControllerWithControllerName:@"SurveyRecordDatailViewController" ControllerObject:record];
        return;
        
    }
    if ([code isEqualToString:@"ASSESSMENT"])
    {
        //评估计划
        if ([planItem.status isEqualToString:@"1"] || [planItem.status isEqualToString:@"3"]) {
            //跳转到填写评估 一定是阶段评估
            [HMViewControllerManager createViewControllerWithControllerName:@"EvaluationUnFilledDetailViewController" ControllerObject:[NSString stringWithFormat:@"%@", planItem.taskId]];
        }
        else if ([planItem.status isEqualToString:@"1"]) {
            //跳转到随访详情
            EvaluationListRecord *evaluationRecord = [[EvaluationListRecord alloc] init];
            evaluationRecord.itemId = planItem.taskId;
            evaluationRecord.itemType = @"1";
            [HMViewControllerManager createViewControllerWithControllerName:@"EvaluationDetailViewController" ControllerObject:evaluationRecord];
        }
        return;
    }

    if ([code isEqualToString:@"WARDS"])
    {
        //查房计划
        if ([planItem.status isEqualToString:@"1"] || [planItem.status isEqualToString:@"3"]) {
            //TODO:跳转到填写查房界面
            [HMViewControllerManager createViewControllerWithControllerName:@"RoundsUnFilledDetailViewController" ControllerObject:[NSString stringWithFormat:@"%@", planItem.taskId]];
        }
        else if ([planItem.status isEqualToString:@"1"]) {
            //TODO:跳转到查房表详情界面
            [HMViewControllerManager createViewControllerWithControllerName:@"RoundsDetailViewController" ControllerObject:[NSString stringWithFormat:@"%@", planItem.taskId]];
        }

        return;
    }


}

- (void) entryDetectController:(NSString*) kpiCode
                        TaskId:(NSString*) detectTaskId
{
    if (!kpiCode || 0 == kpiCode.length)
    {
        return;
    }
    NSString* controllerName = nil;
    if ([kpiCode isEqualToString:@"XY"])
    {
        //血压
        controllerName = @"BodyPressureDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"TZ"])
    {
        //体重
        controllerName = @"BodyWeightDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"XT"])
    {
        //血糖
        controllerName = @"BloodSugarDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"XD"])
    {
        //心电
        controllerName = @"ECGDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"XL"])
    {
        //心率
        controllerName = @"HeartRateDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"XZ"])
    {
        //血脂
        controllerName = @"BloodFatDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"OXY"])
    {
        //血氧
        controllerName = @"BloodOxygenDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"NL"])
    {
        //尿量
        controllerName = @"UrineVolumeDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"HX"])
    {
        //呼吸
        controllerName = @"BreathingDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"TEM"])
    {
        //体温
        controllerName = @"BodyTemperatureDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"FLSZ"])
    {
        //峰流速值
        controllerName = @"PEFDetectStartViewController";
    }
    if (!controllerName || 0 == controllerName.length)
    {
        return;
    }
    
    NSMutableDictionary* dicParam = [NSMutableDictionary dictionary];
    [dicParam setValue:detectTaskId forKey:@"taskId"];
    [HMViewControllerManager createViewControllerWithControllerName:controllerName ControllerObject:dicParam];
}

- (void) entryNutrtuin:(PlanMessionListItem*) planItem
{
    [HMViewControllerManager createViewControllerWithControllerName:@"NuritionDietRecordsStartViewController" ControllerObject:dateString];
}

- (void) entryMentality:(PlanMessionListItem*) planItem
{
    if ([planItem.status isEqualToString:@"1"]) {
        //待记录
        //statusColor = [UIColor colorWithHexString:@"FF6666"];
        [HMViewControllerManager createViewControllerWithControllerName:@"PsychologyPlanStartViewController" ControllerObject:nil];
    }
    else if ([planItem.status isEqualToString:@"2"]) {
        //已记录
        [HMViewControllerManager createViewControllerWithControllerName:@"UserMoodRecordsStartViewController" ControllerObject:nil];
    }

}

// 复查权限提醒
- (void) showAlertWithoutServiceMessage
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"您的服务包中不包含约诊服务。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"查看套餐" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //跳转到服务分类
        [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceStartViewController" ControllerObject:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    [self.presentedViewController presentViewController:alert animated:YES completion:nil];
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
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    if ([taskname isEqualToString:@"HealthPlanDailyListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            NSNumber* numExecute = [dicResult valueForKey:@"alertExecute"];
            if (numExecute && [numExecute isKindOfClass:[NSNumber class]])
            {
                NSInteger alertExecute = numExecute.integerValue;
                [headerview setCompletePlansCount:alertExecute];
            }
            
            NSNumber* numCount = [dicResult valueForKey:@"taskCount"];
            if (numCount && [numCount isKindOfClass:[NSNumber class]])
            {
                NSInteger taskCount = numCount.integerValue;
                [headerview setTotalPlansCount:taskCount];
            }
            
            NSArray* items = [dicResult valueForKey:@"list"];
            if (items && [items isKindOfClass:[NSArray class]])
            {
                planList = [NSArray arrayWithArray:(NSArray*)items];
            }
        }

    }
    
    if ([taskname isEqualToString:@"UserDetectPlanInfoTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[DetectPlanInfo class]])
        {
            DetectPlanInfo* planInfo = (DetectPlanInfo*) taskResult;            
            if (planInfo.TEST_ID && 0 < planInfo.TEST_ID.length)
            {
                [self entryDetectResultController:planInfo.TEST_ID KpiCode:planInfo.KPI_CODE SourceKpiCode:planInfo.SOURCE_KPI_CODE];
            }
        }
    }
}

- (void) entryDetectResultController:(NSString*) recordId
                             KpiCode:(NSString*) kpiCode
                       SourceKpiCode:(NSString*) sourceKpiCode
{
    DetectRecord* record = [[DetectRecord alloc]init];
    [record setTestDataId:recordId];
    
    if ([kpiCode isEqualToString:@"XY"])
    {
        //血压
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureResultContentViewController" ControllerObject:record];
        return;
    }
    
    if ([kpiCode isEqualToString:@"XL"])
    {
        //心电
        if (sourceKpiCode)
        {
            if ([sourceKpiCode isEqualToString:@"XY"])
            {
                [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureResultContentViewController" ControllerObject:record];
                return;
            }
        }
        else
        {
            [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectResultContentViewController" ControllerObject:record];
            return;
        }
    }
    
    if ([kpiCode isEqualToString:@"TZ"])
    {
        //体重
        [HMViewControllerManager createViewControllerWithControllerName:@"BodyWeightResultContentViewController" ControllerObject:record];
        return;
    }
    
    if ([kpiCode isEqualToString:@"XT"])
    {
        //血糖
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodSugarDetectResultViewController" ControllerObject:record];
        return;
    }
    
    if ([kpiCode isEqualToString:@"XZ"])
    {
        //血脂
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodFatDetectResultViewController" ControllerObject:record];
        return;
    }
    
    if ([kpiCode isEqualToString:@"OXY"])
    {
        //血氧
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodOxygenResultContentViewController" ControllerObject:record];
        return;
    }
    
    if ([kpiCode isEqualToString:@"HX"])
    {
        //呼吸
        [HMViewControllerManager createViewControllerWithControllerName:@"BreathingDetectResultViewController" ControllerObject:record];
        return;
    }
}
@end
