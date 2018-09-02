//
//  DetectRecordsOverallTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectRecordsOverallTableViewController.h"
#import "DetectRecordsChartTableViewCell.h"
#import "ClientHelper.h"

@interface DetectRecordsOverallTableViewController ()
<TaskObserver>
{
    NSString* userId;
    BOOL hasPregnancyService;
}
@end

@implementation DetectRecordsOverallTableViewController

- (id) initWithUserId:(NSString*) aUserId
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        userId = aUserId;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    
    //获取是否有显示孕期体重
    NSMutableDictionary* paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:@"YQTIZZ" forKey:@"scode"];
    [paramDict setValue:userId forKey:@"userId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"CheckPregnancyServiceTask" taskParam:paramDict TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setTimetype:(DetectTimeType)timetype
{
    _timetype = timetype;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return DetectRecords_TypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if ([self serviceHasDetect:section])
    {
        return 1;
    }
    return 0;
}

- (BOOL) serviceHasDetect:(NSInteger) section
{
    switch (section) {
        case DetectRecords_PregnancyBodyWeight:
        {
            if (hasPregnancyService)
            {
                if (self.timetype != DetectTime_Daily) {
                    return YES;
                }
            }
            return NO;
            break;
        }
        
    }
    return YES;
}

- (CGFloat) footerviewHeight:(NSInteger) section
{
    if (section + 1 == DetectRecords_TypeCount ) {
        return 0.5;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self footerviewHeight:section];
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, [self footerviewHeight:section])];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    return footerview;
}

- (CGFloat) headerviewHeight:(NSInteger) section
{
    if ([self serviceHasDetect:section])
    {
        return 5;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self headerviewHeight:section];
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, [self headerviewHeight:section])];
    [headerview setBackgroundColor:[UIColor commonBackgroundColor]];
    return headerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (NSString*) cellClassName:(NSInteger) section
{
    NSString* classname = @"DetectRecordsChartTableViewCell";
    switch (section)
    {
        case DetectRecords_BodyWeight:
        {
            classname = @"BodyWeightDetectRecordsChartTableViewCell";
        }
            break;
            
//        case DetectRecords_BloodSugar:
//        {
//            classname = @"BloodSugarConstastRecordsChartTableViewCell";
//        }
//            break;
            
        default:
            break;
    }
    return classname;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* cellClassName = [self cellClassName:indexPath.section];
    
    DetectRecordsChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
    if (!cell)
    {
        cell = [[NSClassFromString(cellClassName) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClassName];
    }
    [cell setUserId:userId];
    
    switch (indexPath.section)
    {
        case DetectRecords_BloodPressure:
        {
//            [cell.textLabel setText:@"血压"];
            //BodyPressureDetectStartViewController
            [cell setTargetControllerName:@"BloodPressureRecordStartViewController"];
            NSString* url = [self chartUrlWithKpi:@"XY"];
            [cell loadChartWithUrl:url];
        }
            break;
        case DetectRecords_ECG:
        {
            //[cell.textLabel setText:@"心率"];
            [cell setTargetControllerName:@"ECGDetectRecordStartViewController"];
            NSString* url = [self chartUrlWithKpi:@"XL"];
            //NSString* url = [self chartUrlWithKpi:@"XL"];
            [cell loadChartWithUrl:url];
        }
            break;
        case DetectRecords_PregnancyBodyWeight:
        {
            [cell setTargetControllerName:@"BodyWeightRecordsStartViewController"];
           
            NSString* url = [self pregnancyBodyWeightChartUrl];
            [cell loadChartWithUrl:url];
        }
            break;
        case DetectRecords_BodyWeight:
        {
            //[cell.textLabel setText:@"体重"];
            [cell setTargetControllerName:@"BodyWeightRecordsStartViewController"];
            //NSString* url = [self chartUrlWithKpi:@"TZ"];
            NSString* url = [self bodyWeightChartUrl];
            [cell loadChartWithUrl:url];
        }
            break;
        case DetectRecords_BloodSugar:
        {
            //[cell.textLabel setText:@"血糖"];
            [cell setTargetControllerName:@"BloodSugarRecordsStartViewController"];
            NSString* url = [self chartUrlWithKpi:@"XT"];
            [cell loadChartWithUrl:url];
        }
            break;
        case DetectRecords_BloodFat:
        {
            //[cell.textLabel setText:@"血脂"];
            [cell setTargetControllerName:@"BloodFatDetectRecordsStartViewController"];
            NSString* url = [self chartUrlWithKpi:@"XZ"];
            [cell loadChartWithUrl:url];
        }
            break;
        case DetectRecords_UrineVolume:
        {
            //[cell.textLabel setText:@"尿量"];
            [cell setTargetControllerName:@"UrineVolumeRecordsStartViewController"];
            NSString* url = [self chartUrlWithKpi:@"NL"];
            [cell loadChartWithUrl:url];
        }
            break;
        case DetectRecords_BloodOxygen:
        {
            //[cell.textLabel setText:@"血氧"];
            [cell setTargetControllerName:@"BloodOxygenationRecordStartViewController"];
            NSString* url = [self chartUrlWithKpi:@"OXY"];
            [cell loadChartWithUrl:url];
        }
            break;
        case DetectRecords_Breathing:
        {
            //[cell.textLabel setText:@"呼吸"];
            [cell setTargetControllerName:@"BreathingRecordsStartViewController"];
            NSString* url = [self chartUrlWithKpi:@"HX"];
            [cell loadChartWithUrl:url];
        }
            break;
        case DetectRecords_BodyTemperature:
        {
            //体温
            [cell setTargetControllerName:@"BodyTemperatureDetectsRecordsStartViewController"];
            NSString* url = [self chartUrlWithKpi:@"TEM"];
            [cell loadChartWithUrl:url];
            break;
        }
        default:
            break;
    }
    
    //[cell setUserId:[NSString stringWithFormat:@"%ld", curUser.userId]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (NSString*) chartUrlWithKpi:(NSString*)kpiCode
{
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YH&kpiCode=%@&userId=%@&dateType=%ld", kZJKHealthDataBaseUrl ,kpiCode, userId, _timetype];
    
    return url;
}
//孕期体重
- (NSString*) pregnancyBodyWeightChartUrl
{
    NSString* url = [NSString stringWithFormat:@"%@/bimChart.htm?vType=YH&kpiCode=%@&userId=%@", kZJKHealthDataBaseUrl ,@"YQ_TZ", userId];
    return url;
}

- (NSString*) bodyWeightChartUrl
{
   NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YH&kpiCode=%@&userId=%@&dateType=%ld&islegend=1", kZJKHealthDataBaseUrl ,@"TZ", userId, _timetype];
    return url;
}


#pragma mark - TaskObserver
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
    if ([taskname isEqualToString:@"CheckPregnancyServiceTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSNumber class]])
        {
            NSNumber* numRet = (NSNumber*) taskResult;
            hasPregnancyService = (numRet.integerValue > 0);
            if (hasPregnancyService)
            {
                [self.tableView reloadData];
            }
        }
    }
}
@end
