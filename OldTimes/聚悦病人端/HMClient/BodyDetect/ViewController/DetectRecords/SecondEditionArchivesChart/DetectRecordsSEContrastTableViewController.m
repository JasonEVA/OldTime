//
//  DetectRecordsSEContrastTableViewController.m
//  HMClient
//
//  Created by lkl on 2017/5/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "DetectRecordsSEContrastTableViewController.h"
#import "ArchivesChartsModel.h"
#import "DetectRecordsChartTableViewCell.h"
#import "ClientHelper.h"

@interface DetectRecordsSEContrastTableViewController ()<TaskObserver>

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) NSArray *detectArray;

@end

@implementation DetectRecordsSEContrastTableViewController

- (id)initWithUserId:(NSString *)aUserId
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        _userId = aUserId;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:_userId forKey:@"userId"];
    //1:整体趋势   2:时段对比
    [dicPost setValue:@"2" forKey:@"type"];
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"ArchivesChartsTask" taskParam:dicPost TaskObserver:self];
}

- (void) setTimetype:(DetectTimeType)timetype
{
    _timetype = timetype;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _detectArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (NSString*) cellClassName:(NSInteger) section
{
    ArchivesChartsModel *model = _detectArray[section];
    
    NSString *classname ;
    if ([model.kpiCode isEqualToString:@"TZ"]) {
        classname = @"BodyWeightDetectRecordsChartTableViewCell";
    }
    else if ([model.kpiCode isEqualToString:@"XT"]){
        classname = @"BloodSugarConstastRecordsChartTableViewCell";
    }
    else if ([model.kpiCode isEqualToString:@"XY"]){
        classname = @"BloodPressureDetectRecordsChartTableViewCell";
    }
    else{
        classname = @"DetectRecordsChartTableViewCell";
    }
    return classname;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* cellClassName = [self cellClassName:indexPath.section];
    
    DetectRecordsChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
    if (!cell)
    {
        cell = [[NSClassFromString(cellClassName) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClassName];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell setUserId:_userId];

    ArchivesChartsModel *model = _detectArray[indexPath.section];
    
    if ([model.kpiCode isEqualToString:@"XY"]) {
        
        [cell setTargetControllerName:@"BloodPressureRecordStartViewController"];
        NSString* url = [self chartUrlWithKpi:@"XY"];
        [cell loadChartWithUrl:url];
    }
    else if ([model.kpiCode isEqualToString:@"SSY"]) {
        
        [cell setTargetControllerName:@"BloodPressureRecordStartViewController"];
        NSString* url = [self chartUrlWithKpi:@"XY" ChildKpiCode:@"SSY"];
        [cell loadChartWithUrl:url];
    }
    else if ([model.kpiCode isEqualToString:@"SZY"])
    {
        [cell setTargetControllerName:@"BloodPressureRecordStartViewController"];
        NSString* url = [self chartUrlWithKpi:@"XY" ChildKpiCode:@"SZY"];
        [cell loadChartWithUrl:url];
    }
    else if ([model.kpiCode isEqualToString:@"XL"]){
        
        [cell setTargetControllerName:@"ECGDetectRecordStartViewController"];
        NSString* url = [self chartUrlWithKpi:@"XL"];
        [cell loadChartWithUrl:url];
    }
    else if ([model.kpiCode isEqualToString:@"TZ"]){
        
        [cell setTargetControllerName:@"BodyWeightRecordsStartViewController"];
        NSString* url = [self bodyWeightChartUrl];
        [cell loadChartWithUrl:url];
    }
    else if ([model.kpiCode isEqualToString:@"XT"]){
        
        [cell setTargetControllerName:@"BloodSugarRecordsStartViewController"];
        NSString* url = [self chartUrlWithKpi:@"XT"];
        [cell loadChartWithUrl:url];
    }
    else if ([model.kpiCode isEqualToString:@"XZ"]){
        
        [cell setTargetControllerName:@"BloodFatDetectRecordsStartViewController"];
        NSString* url = [self chartUrlWithKpi:@"XZ"];
        [cell loadChartWithUrl:url];
    }
    else if ([model.kpiCode isEqualToString:@"NL"]){
        
        [cell setTargetControllerName:@"UrineVolumeRecordsStartViewController"];
        NSString* url = [self chartUrlWithKpi:@"NL"];
        [cell loadChartWithUrl:url];
    }
    else if ([model.kpiCode isEqualToString:@"OXY"]){
        
        [cell setTargetControllerName:@"BloodOxygenationRecordStartViewController"];
        NSString* url = [self chartUrlWithKpi:@"OXY"];
        [cell loadChartWithUrl:url];
    }
    else if ([model.kpiCode isEqualToString:@"HX"]){
        
        [cell setTargetControllerName:@"BreathingRecordsStartViewController"];
        NSString* url = [self chartUrlWithKpi:@"HX"];
        [cell loadChartWithUrl:url];
    }
    else if ([model.kpiCode isEqualToString:@"TEM"])
    {
        //体温
        [cell setTargetControllerName:@"BodyTemperatureDetectsRecordsStartViewController"];
        NSString* url = [self chartUrlWithKpi:@"TEM"];
        [cell loadChartWithUrl:url];
    }
    else if ([model.kpiCode isEqualToString:@"FLSZ"]){
        
        //峰流速值
        [cell setTargetControllerName:@"PEFRecordsStartViewController"];
        NSString* url = [self chartUrlWithKpi:@"FLSZ"];
        [cell loadChartWithUrl:url];
    }
    else{
        
    }
    
    return cell;
}

- (NSString*) chartUrlWithKpi:(NSString*)kpiCode
{
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YH&&kpiCode=%@&userId=%@&dateType=%ld", kZJKHealthDataBaseUrl ,kpiCode, _userId, _timetype];
    return url;
}

- (NSString*) chartUrlWithKpi:(NSString*)kpiCode ChildKpiCode:(NSString*) childKpiCode
{
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YH&&kpiCode=%@&userId=%@&dateType=%ld&childKpiCode=%@", kZJKHealthDataBaseUrl ,kpiCode, _userId, _timetype, childKpiCode];
    return url;
}

- (NSString*) bodyWeightChartUrl
{
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YH&&kpiCode=%@&userId=%@&dateType=%ld&islegend=1", kZJKHealthDataBaseUrl ,@"TZ", _userId, _timetype];
    return url;
}

#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
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
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"ArchivesChartsTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            _detectArray = (NSArray *)taskResult;
            [self.tableView reloadData];
        }
    }
}


@end
