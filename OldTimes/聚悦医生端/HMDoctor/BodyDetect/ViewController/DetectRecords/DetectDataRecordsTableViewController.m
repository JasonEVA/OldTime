//
//  DetectDataRecordsTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/11.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectDataRecordsTableViewController.h"
#import "DetectDataRecordTableViewCell.h"
#import "HeartRateDetectRecord.h"
#import "PEFDetectRecord.h"
#import "BodyDetectStartViewController.h"

@interface DetectDataRecordsTableHeaderView : UIView
{
    UIControl* headerControl;
    UILabel* lbMonth;
    UIImageView* ivArrow;
    UIView* lineview;
}

@property (nonatomic, retain) NSString* month;
@property (nonatomic, assign) BOOL isExtended;


@property (nonatomic, copy) void(^selectSelectedBlock)(NSInteger selSection);

- (void) setMonthIndex:(NSInteger) index;
@end

@implementation DetectDataRecordsTableHeaderView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lineview = [[UIView alloc]init];
        [lineview setBackgroundColor:[UIColor mainThemeColor]];
        [self addSubview:lineview];
        
        headerControl = [[UIControl alloc]init];
        [self addSubview:headerControl];
        [headerControl setBackgroundColor:[UIColor mainThemeColor]];
        headerControl.layer.cornerRadius = 15;
        headerControl.layer.masksToBounds = YES;
        [headerControl addTarget:self action:@selector(headerControlClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.size.mas_equalTo(CGSizeMake(94, 30));
            make.centerY.equalTo(self);
        }];
        
        lbMonth = [[UILabel alloc]init];
        [lbMonth setBackgroundColor:[UIColor clearColor]];
        [lbMonth setTextColor:[UIColor whiteColor]];
        [lbMonth setFont:[UIFont systemFontOfSize:12]];
        [headerControl addSubview:lbMonth];
        
        [lbMonth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerControl).with.offset(7);
            make.centerY.equalTo(headerControl);
        }];
        
        ivArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"history_disexpended"]];
        [headerControl addSubview:ivArrow];
        
        [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@8);
            make.width.mas_equalTo(@8);
            make.centerY.equalTo(headerControl);
            make.right.equalTo(headerControl).with.offset(-8);
        }];
        
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.width.mas_equalTo(@1);
            make.top.equalTo(self);
            make.left.equalTo(self).with.offset(51);
        }];

    }
    return self;
}

- (void) setMonth:(NSString *)month
{
    _month = month;
    NSDate* dateMonth = [NSDate dateWithString:month formatString:@"yyyy-MM"];
    NSString* monthStr = [dateMonth formattedDateWithFormat:@"yyyy年MM月"];
    [lbMonth setText:monthStr];
}

- (void) setIsExtended:(BOOL)isExtended
{
    _isExtended = isExtended;
    if (isExtended)
    {
        [ivArrow setImage:[UIImage imageNamed:@"history_expended"]];

    }
    else
    {
        [ivArrow setImage:[UIImage imageNamed:@"history_disexpended"]];
    }
}

- (void) setMonthIndex:(NSInteger) index
{
    [headerControl setTag:(0x100 + index)];
}

- (void) headerControlClicked:(id) sender
{
    NSInteger section = headerControl.tag - 0x100;
    if (_selectSelectedBlock)
    {
        _selectSelectedBlock(section);
    }
}

@end

@interface DetectDataRecordsViewController ()
{
    DetectDataRecordsTableViewController *dataRecordsTableVC;
}
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) UIButton *recordHealthBtn;

@end

@implementation DetectDataRecordsViewController

- (id) initWithUserId:(NSString*) aUserId
{
    self = [super init];
    if (self)
    {
        self.userId = aUserId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataRecordsTableVC = [[DetectDataRecordsTableViewController alloc] initWithUserId:self.userId];
    [self addChildViewController:dataRecordsTableVC];
    [self.view addSubview:dataRecordsTableVC.view];
    [dataRecordsTableVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.recordHealthBtn];
    [self.recordHealthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-40);
        make.right.equalTo(self.view).offset(-20);
    }];
}

- (void) setKpiCode:(NSString*) kpi
{
    [dataRecordsTableVC setKpiCode:kpi];
}

#pragma mark -- init
- (UIButton *)recordHealthBtn{
    if (!_recordHealthBtn) {
        _recordHealthBtn = [[UIButton alloc] init];
        [_recordHealthBtn setBackgroundImage:[UIImage imageNamed:@"icon_set_add1"] forState:UIControlStateNormal];
        // 按钮图片伸缩充满整个按钮
        _recordHealthBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        [_recordHealthBtn addTarget:self action:@selector(recordHealthBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordHealthBtn;
}

#pragma mark --ButtonClick
- (void)recordHealthBtnClicked:(UIButton *)sender
{
    //添加监测数据
    [HMViewControllerManager createViewControllerWithControllerName:@"BodyDetectStartViewController"ControllerObject:self.userId];
}

@end


@interface DetectDataRecordsTableViewController ()
<TaskObserver>
{
    NSString* kpiCode;
    NSArray* monthList;
    NSMutableArray* recordList;
    NSInteger totalCount;
    NSInteger selectedMonthIndex;
    
    NSString* userId;
}

@end

@implementation DetectDataRecordsTableViewController

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
    
    //
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self loadRecordMonth];
}

- (void) loadRecordMonth
{
    totalCount = 0;
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    if (kpiCode)
    {
        [dicPost setValue:kpiCode forKey:@"kpiCode"];
    }
    if (userId)
    {
        [dicPost setValue:userId forKey:@"userId"];
    }
    [[TaskManager shareInstance] createTaskWithTaskName:@"DetectDataRecordsMonthListTask" taskParam:dicPost TaskObserver:self];
}

- (void) loadMonthRecords:(NSInteger) section
{
    totalCount = 0;
    if (!monthList || 0 == monthList.count)
    {
        [self showBlankView];
        return;
    }
    recordList = [NSMutableArray array];
    
    //DetectDataRecordsTask
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    if (kpiCode)
    {
        [dicPost setValue:kpiCode forKey:@"kpiCode"];
    }
    if (userId)
    {
        [dicPost setValue:userId forKey:@"userId"];
    }
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:15] forKey:@"rows"];
    
    [dicPost setValue:monthList[section] forKey:@"month"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"DetectDataRecordsTask" taskParam:dicPost TaskObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setKpiCode:(NSString*) kpi
{
    if (kpi && 0 < kpi.length && kpiCode && 0 < kpiCode.length) {
        if ([kpiCode isEqualToString:kpi])
        {
            return;
        }
    }
    
    kpiCode = kpi;
    selectedMonthIndex = 0;
    [self loadRecordMonth];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (monthList)
    {
        return monthList.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (section == selectedMonthIndex)
    {
        if (recordList)
        {
            return recordList.count;
        }
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 47;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DetectDataRecordsTableHeaderView* headerview = [[DetectDataRecordsTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 47)];
    [headerview setMonth:[monthList objectAtIndex:section]];
    [headerview setIsExtended:(section == selectedMonthIndex)];
    [headerview setMonthIndex:section];
    __weak typeof(self) weakSelf = self;
    [headerview setSelectSelectedBlock:^(NSInteger selSection) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (selSection == selectedMonthIndex)
        {
            selectedMonthIndex = NSNotFound;
            [strongSelf.tableView reloadData];
            return ;
        }
        [strongSelf selectSection:selSection];
    }];
    return headerview;
}


- (void) selectSection:(NSInteger) section
{
    selectedMonthIndex = section;
    [self loadMonthRecords:selectedMonthIndex];
    [self.tableView reloadData];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetectRecord* record = [recordList objectAtIndex:indexPath.row];
    CGFloat cellHeight = [record recordCellHeight];
    
    //判断峰流速值是否有时段
    if ([record.kpiCode isEqualToString:@"FLSZ"]) {
        PEFDetectRecord *pefRecord = (PEFDetectRecord*) record;
        if ([pefRecord.testTimeName isEqualToString:@"无"] || kStringIsEmpty(pefRecord.testTimeName)) {
            return 55;
        }
    }
    
    return cellHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (selectedMonthIndex == section)
    {
        if (recordList && recordList.count < totalCount)
        {
            return 45;
        }
    }
    return 0;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 45)];
    [footerview setBackgroundColor:[UIColor whiteColor]];
    
    UIView* line = [[UIView alloc]init];
    [footerview addSubview:line];
    [line setBackgroundColor:[UIColor mainThemeColor]];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(footerview.mas_height);
        make.width.mas_equalTo(@1);
        make.top.equalTo(footerview);
        make.left.equalTo(footerview).with.offset(51);
    }];
    
    UIButton* btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerview addSubview:btnMore];
    [btnMore setTitle:@"点击查看更多" forState:UIControlStateNormal];
    [btnMore setTitleColor:[UIColor commonTextColor] forState:UIControlStateNormal];
    [btnMore.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(footerview);
        make.width.mas_equalTo(@200);
        make.height.equalTo(footerview);
    }];
    
    [btnMore addTarget:self action:@selector(loadMoreRecords) forControlEvents:UIControlEventTouchUpInside];
    
    return footerview;
}

- (void) loadMoreRecords
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:recordList.count] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:20] forKey:@"rows"];
    if (kpiCode)
    {
        [dicPost setValue:kpiCode forKey:@"kpiCode"];
    }
    if (userId)
    {
        [dicPost setValue:userId forKey:@"userId"];
    }
    [dicPost setValue:monthList[selectedMonthIndex] forKey:@"month"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"DetectDataRecordsTask" taskParam:dicPost TaskObserver:self];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetectDataRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetectDataRecordTableViewCell"];
    if (!cell)
    {
        cell = [[DetectDataRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetectDataRecordTableViewCell"];
    }
    // Configure the cell...
    DetectRecord* record = [recordList objectAtIndex:indexPath.row];
    [cell setDetectRecord:record];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetectRecord* record = [recordList objectAtIndex:indexPath.row];
    
    NSString* kpi = record.kpiCode;
    
    if (!kpi || ![kpi isKindOfClass:[NSString class]] || 0 == kpi.length)
    {
        return;
    }
    
    
    if ([kpi isEqualToString:@"XY"])
    {
        //血压
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureResultContentViewController" ControllerObject:record];
        return;
    }
    
    if ([kpi isEqualToString:@"XL"]) {
        //心率
        HeartRateDetectRecord* xyrecord = [[HeartRateDetectRecord alloc]init];
    
        if (!kStringIsEmpty(record.sourceKpiCode) && [record.sourceKpiCode isEqualToString:@"XY"]){
            [xyrecord setKpiCode:@"XY"];
            [xyrecord setTestDataId:record.sourceTestDataId];
            [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureResultContentViewController" ControllerObject:xyrecord];
        }
        else if (!kStringIsEmpty(record.sourceKpiCode) && [record.sourceKpiCode isEqualToString:@"XD"]){
            [xyrecord setKpiCode:@"XD"];
            [xyrecord setTestDataId:record.sourceTestDataId];
            [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectResultContentViewController" ControllerObject:xyrecord];
        }
        else{
            [xyrecord setKpiCode:@"XL"];
            [xyrecord setTestDataId:record.testDataId];
            [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectResultContentViewController" ControllerObject:xyrecord];
        }

        return;
    }
    
    if ([kpi isEqualToString:@"TZ"])
    {
        //体重
        [HMViewControllerManager createViewControllerWithControllerName:@"BodyWeightResultContentViewController" ControllerObject:record];
        return;
    }
    
    if ([kpi isEqualToString:@"XT"])
    {
        //血糖
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodSugarDetectResultViewController" ControllerObject:record];
        return;
    }
    
    if ([kpi isEqualToString:@"XZ"])
    {
        //血脂
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodFatDetectResultViewController" ControllerObject:record];
        return;
    }
    
    if ([kpi isEqualToString:@"OXY"])
    {
        //血氧
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodOxygenResultContentViewController" ControllerObject:record];
        return;
    }
    
    if ([kpi isEqualToString:@"HX"])
    {
        //呼吸
        [HMViewControllerManager createViewControllerWithControllerName:@"BreathingDetectResultViewController" ControllerObject:record];
        return;
    }

    if ([kpi isEqualToString:@"TEM"])
    {
        //体温
        [HMViewControllerManager createViewControllerWithControllerName:@"BodyTemperatureDetectResultViewController" ControllerObject:record];
        return;
    }
    
    if ([kpi isEqualToString:@"FLSZ"]) {
        //峰流速值
        [HMViewControllerManager createViewControllerWithControllerName:@"PEFResultContentViewController" ControllerObject:record];
        return;
    }
}

- (void) recordsMonthlistLoaded:(NSArray*) items
{
    selectedMonthIndex = 0;
    monthList = [NSMutableArray arrayWithArray:items];
    
    [self loadMonthRecords:selectedMonthIndex];
    [self.tableView reloadData];
}

- (void) recordsLoaded:(NSArray*) items
{
    if (!recordList)
    {
        recordList = [NSMutableArray array];
    }
    [recordList addObjectsFromArray:items];
    
    [self.tableView reloadData];
}


#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    
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
    
    if ([taskname isEqualToString:@"DetectDataRecordsMonthListTask"])
    {
        //获取到月份集
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* monthItems = (NSArray*) taskResult;
            [self recordsMonthlistLoaded:monthItems];
        }
        
    }
    if ([taskname isEqualToString:@"DetectDataRecordsTask"])
    {
        //
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            NSNumber* numCount = [dicResult valueForKey:@"count"];
            if (numCount && [numCount isKindOfClass:[NSNumber class]])
            {
                totalCount = numCount.integerValue;
            }
            NSArray* list = [dicResult valueForKey:@"list"];
            [self recordsLoaded:list];
        }
    }
}



@end
