//
//  DetectRecordsContrastTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectRecordsContrastTableViewController.h"
#import "DetectRecordsChartTableViewCell.h"
#import "ClientHelper.h"

@interface DetectRecordsContrastTableViewController ()
{
    NSString* userId;
}
@end

@implementation DetectRecordsContrastTableViewController

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
    return ConstrastRecords_TypeCount;
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
    return YES;
}

- (CGFloat) footerviewHeight:(NSInteger) section
{
    if (section + 1 == ConstrastRecords_TypeCount ) {
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
        case ConstrastRecords_BodyWeight:
        {
            classname = @"BodyWeightDetectRecordsChartTableViewCell";
        }
            break;
        case ConstrastRecords_BloodSugar:
        {
            classname = @"BloodSugarConstastRecordsChartTableViewCell";
        }
            break;
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
        case ConstrastRecords_SystolicPressure:
        {
            
            [cell setTargetControllerName:@"BloodPressureRecordStartViewController"];
            NSString* url = [self chartUrlWithKpi:@"XY" ChildKpiCode:@"SZY"];
            [cell loadChartWithUrl:url];
        }
            break;
        case ConstrastRecords_DiastolicPressure:
        {
            
            [cell setTargetControllerName:@"BloodPressureRecordStartViewController"];
            NSString* url = [self chartUrlWithKpi:@"XY" ChildKpiCode:@"SSY"];
            [cell loadChartWithUrl:url];
        }
            break;
        case ConstrastRecords_ECG:
        {
            
            [cell setTargetControllerName:@"ECGDetectRecordStartViewController"];
            NSString* url = [self chartUrlWithKpi:@"XL"];
            [cell loadChartWithUrl:url];
        }
            break;
        case ConstrastRecords_BodyWeight:
        {
            //[cell.textLabel setText:@"体重"];
            [cell setTargetControllerName:@"BodyWeightRecordsStartViewController"];
            NSString* url = [self bodyWeightChartUrl];
            [cell loadChartWithUrl:url];
        }
            break;
        case ConstrastRecords_BloodSugar:
        {
            //[cell.textLabel setText:@"血糖"];
            [cell setTargetControllerName:@"BloodSugarRecordsStartViewController"];
            NSString* url = [self chartUrlWithKpi:@"XT"];
            [cell loadChartWithUrl:url];
        }
            break;
        case ConstrastRecords_BloodFat:
        {
            //[cell.textLabel setText:@"血脂"];
            [cell setTargetControllerName:@"BloodFatDetectRecordsStartViewController"];
            NSString* url = [self chartUrlWithKpi:@"XZ"];
            [cell loadChartWithUrl:url];
        }
            break;
        case ConstrastRecords_UrineVolume:
        {
            [cell setTargetControllerName:@"UrineVolumeRecordsStartViewController"];
            NSString* url = [self chartUrlWithKpi:@"NL"];
            [cell loadChartWithUrl:url];
        }
            break;
        case ConstrastRecords_BloodOxygen:
        {
            [cell setTargetControllerName:@"BloodOxygenationRecordStartViewController"];
            NSString* url = [self chartUrlWithKpi:@"OXY"];
            [cell loadChartWithUrl:url];
        }
            break;
        case ConstrastRecords_Breathing:
        {
            [cell setTargetControllerName:@"BreathingRecordsStartViewController"];
            NSString* url = [self chartUrlWithKpi:@"HX"];
            [cell loadChartWithUrl:url];
        }
            break;
        default:
            break;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (NSString*) chartUrlWithKpi:(NSString*)kpiCode
{
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YS&&kpiCode=%@&userId=%@&dateType=%ld", kZJKHealthDataBaseUrl ,kpiCode, userId, _timetype];
    return url;
}

- (NSString*) chartUrlWithKpi:(NSString*)kpiCode ChildKpiCode:(NSString*) childKpiCode
{
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YS&kpiCode=%@&userId=%@&dateType=%ld&childKpiCode=%@", kZJKHealthDataBaseUrl ,kpiCode, userId, _timetype, childKpiCode];
    return url;
}

- (NSString*) bodyWeightChartUrl
{
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YS&&kpiCode=%@&userId=%@&dateType=%ld&islegend=1", kZJKHealthDataBaseUrl ,@"TZ", userId, _timetype];
    
    return url;
}
@end
