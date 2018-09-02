//
//  BodyDetectStartTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyDetectStartTableViewController.h"
#import "BodyDetectStartTableViewCell.h"
#import "RecordHealthInfo.h"

typedef enum : NSUInteger {
    DeviceDetectSection,
    HealthDetectSection,
    DetectSectionCount,
}BodyDetectSection;

typedef enum : NSUInteger {
    BodyDetect_BloodPressure,
    BodyDetect_ECG,             //心电
    BodyDetect_BodyWeight,
    BodyDetect_BloodSugar,
    BodyDetect_BloodFat,
    BodyDetect_BloodOxygenation,    //血氧
    BodyDetect_UrineVolume,         //尿量
    BodyDetect_Breath,
    BodyDetectIndexCount,
} BodyDetectIndex;

@interface BodyDetectStartTableViewController ()<TaskObserver>
{
    NSArray* healthPlanItems;
    NSArray *testRecordItems;
}
@end

@implementation BodyDetectStartTableViewController

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    [self.tableView showWaitView];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserTestRecoderHealthyTask" taskParam:nil TaskObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case DeviceDetectSection:
            return testRecordItems.count;
            break;
            
        case HealthDetectSection:
            return healthPlanItems.count;
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return DetectSectionCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case DeviceDetectSection:
        {
            DeviceDetectRecord *testRecord = [testRecordItems objectAtIndex:indexPath.row];
            return !kStringIsEmpty(testRecord.alertContent) ? 60 * kScreenScale : 45 * kScreenScale;
            break;
        }
            
        case HealthDetectSection:
        {
            HealthPlanRecord *record = [healthPlanItems objectAtIndex:indexPath.row];
            return !kStringIsEmpty(record.healthyContent) ? 60 * kScreenScale : 45 * kScreenScale;
            break;
        }
            
        default:
            break;
    }
    

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case DeviceDetectSection:
        {
            DeviceDetectRecord *testRecord = [testRecordItems objectAtIndex:indexPath.row];
            //testRecord.alertContent = @"dfjadsajfld";
            if (testRecord.alertContent && testRecord.alertContent.length > 0)
            {
                BodyDetectStartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BodyDetectStartTableViewCell"];
                if (!cell)
                {
                    cell = [[BodyDetectStartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BodyDetectStartTableViewCell"];
                }

                [cell setDetectName:[NSString stringWithFormat:@"测%@",testRecord.kpiName]];
                [cell setDetectRecord:testRecord.alertContent];
                [cell setImageCode:testRecord.kpiCode];
                
                return cell;
                
            }else
            {
                BodyDetectOtherStartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BodyDetectOtherStartTableViewCell"];
                if (!cell)
                {
                    cell = [[BodyDetectOtherStartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BodyDetectOtherStartTableViewCell"];
                }
                
                [cell setDetectName:[NSString stringWithFormat:@"测%@",testRecord.kpiName]];
                [cell setImageCode:testRecord.kpiCode];
                
                return cell;
            }
            
        }
            break;
            
        case HealthDetectSection:
        {
            HealthPlanRecord *record = [healthPlanItems objectAtIndex:indexPath.row];
            
            if (record.healthyContent && record.healthyContent.length > 0)
            {
                BodyDetectStartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BodyDetectStartTableViewCell"];
                if (!cell)
                {
                    cell = [[BodyDetectStartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BodyDetectStartTableViewCell"];
                }
                
                [cell setDetectRecord:record.healthyContent];
                [cell setDetectName:record.healthyName];
                [cell setImageCode:record.code];
                
                return cell;
            }
            else
            {
                BodyDetectOtherStartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BodyDetectOtherStartTableViewCell"];
                if (!cell)
                {
                    cell = [[BodyDetectOtherStartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BodyDetectOtherStartTableViewCell"];
                }
                
                [cell setDetectName:record.healthyName];
                [cell setImageCode:record.code];
                
                return cell;
            }
        }
            break;
            
        default:
            break;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        //设备监测
        case DeviceDetectSection:
        {

            DeviceDetectRecord *testRecord = [testRecordItems objectAtIndex:indexPath.row];
            NSString *kpiCode = testRecord.kpiCode;
            
            if ([kpiCode isEqualToString:@"XY"]){
                //测血压
                [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测血压"];
                [HMViewControllerManager createViewControllerWithControllerName:@"BodyPressureDetectStartViewController" ControllerObject:nil];
               
            }else if([kpiCode isEqualToString:@"TZ"]){
                //测体重
                [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测体重"];
                [HMViewControllerManager createViewControllerWithControllerName:@"BodyWeightDetectStartViewController" ControllerObject:nil];
                
            }else if([kpiCode isEqualToString:@"XD"]){
                //测心电
                [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测心电"];
                [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectStartViewController" ControllerObject:nil];
                
            }else if([kpiCode isEqualToString:@"XT"]){
                //测血糖
                [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测血糖"];
                [HMViewControllerManager createViewControllerWithControllerName:@"BloodSugarDetectStartViewController" ControllerObject:nil];
                
            }else if([kpiCode isEqualToString:@"XZ"]){
                //测血脂
                [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测血脂"];
                [HMViewControllerManager createViewControllerWithControllerName:@"BloodFatDetectStartViewController" ControllerObject:nil];
                
            }else if([kpiCode isEqualToString:@"NL"]){
                //测尿量
                [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测尿量"];
                [HMViewControllerManager createViewControllerWithControllerName:@"UrineVolumeDetectStartViewController" ControllerObject:nil];
                
            }
            else if([kpiCode isEqualToString:@"HX"]){
                //测呼吸
                [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测呼吸"];
                [HMViewControllerManager createViewControllerWithControllerName:@"BreathingDetectStartViewController" ControllerObject:nil];
                
            }
            else if([kpiCode isEqualToString:@"OXY"]){
                //测血氧
                [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测血氧"];
                [HMViewControllerManager createViewControllerWithControllerName:@"BloodOxygenDetectStartViewController" ControllerObject:nil];
            }
            else if([kpiCode isEqualToString:@"TEM"]){
                //测体温
                [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测体温"];
                [HMViewControllerManager createViewControllerWithControllerName:@"BodyTemperatureDetectStartViewController" ControllerObject:nil];
            }
            
            else if([kpiCode isEqualToString:@"FLSZ"]){
                //测峰流速值
                [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测峰流速值"];
                [HMViewControllerManager createViewControllerWithControllerName:@"PEFDetectStartViewController" ControllerObject:nil];
            }
            
            else if([kpiCode isEqualToString:@"XL"]){
                //测心率
                [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测心率"];
                [HMViewControllerManager createViewControllerWithControllerName:@"HeartRateDetectStartViewController" ControllerObject:nil];
            }
    
        }
            break;
        
        //健康记录
        case HealthDetectSection:
        {
            HealthPlanRecord *planRecord = [healthPlanItems objectAtIndex:indexPath.row];
            if (!planRecord.code || 0 == planRecord.code.length)
            {
                break;
            }
            
            if ([planRecord.code isEqualToString:@"SURVEY"])
            {
                //记随访 SurveyPlansListViewController
                [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－记随访"];
                [HMViewControllerManager createViewControllerWithControllerName:@"SurveyRecordsStartViewController" ControllerObject:nil];
                break;
            }
            if ([planRecord.code isEqualToString:@"NUTRITION"])
            {
                //记饮食
                [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－记饮食"];
                [HMViewControllerManager createViewControllerWithControllerName:@"SENuritionDietRecordsStartViewController" ControllerObject:nil];
                break;
            }
            if ([planRecord.code isEqualToString:@"SPORTS"])
            {
                //记运动
                [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－记运动"];
                [HMViewControllerManager createViewControllerWithControllerName:@"RecordSportsExecuteViewController" ControllerObject:nil];

                 break;
            }
            if ([planRecord.code isEqualToString:@"MENTALITY"])
            {
                //记心情
                [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－记心情"];
                [HMViewControllerManager createViewControllerWithControllerName:@"PsychologyPlanStartViewController" ControllerObject:nil];
                break;
            }
            if ([planRecord.code isEqualToString:@"DRUGS"])
            {
                //记用药
                [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－记用药"];
                NSString* dateString = [[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd"];
                [HMViewControllerManager createViewControllerWithControllerName:@"MedicationPlanViewStartController" ControllerObject:dateString];
                break;
            }

            
        }
            break;
            
            
        default:
            break;
    }
    
}



#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView closeWaitView];
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
    
    if ([taskname isEqualToString:@"UserTestRecoderHealthyTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            healthPlanItems = [(NSMutableDictionary*) taskResult valueForKey:@"healthPlan"];
            testRecordItems = [(NSMutableDictionary*) taskResult valueForKey:@"testRecord"];
//            [testRecordItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                DeviceDetectRecord *model = (DeviceDetectRecord *)obj;
//                if ([model.kpiCode isEqualToString:@"XL"]) {
//                    model.kpiName = @"心电";
//                }
//            }];
            [self.tableView reloadData];
        }
    }
}




@end
