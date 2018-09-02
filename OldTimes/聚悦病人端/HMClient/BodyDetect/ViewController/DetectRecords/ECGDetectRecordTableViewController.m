//
//  ECGDetectRecordTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ECGDetectRecordTableViewController.h"
#import "HeartRateDetectRecordTableViewCell.h"
#import "BraceletHeartRateModel.h"

@interface ECGDetectRecordStartViewController ()
{
    ECGDetectRecordTableViewController* tvcRecords;
}
@end

@implementation ECGDetectRecordStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"心率"];
    
    NSString* userIdStr = nil;
    NSInteger userId = 0;
    if (self.paramObject && [self.paramObject isKindOfClass:[UserInfo class]])
    {
        UserInfo* user = (UserInfo*)self.paramObject;
        userIdStr = [NSString stringWithFormat:@"%ld", user.userId];
        userId = user.userId;
    }
    
    if (userIdStr)
    {
        tvcRecords = [[ECGDetectRecordTableViewController alloc]initWithUserId:userIdStr];
        [self addChildViewController:tvcRecords];
        [tvcRecords.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
        [self.view addSubview:tvcRecords.tableView];
        [self subviewLayout];
    }
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    if (curUser.userId != userId)
    {
        return;
    }
    
    NSString* btiTitle = @"添加数据";
    CGFloat titleWidth = [btiTitle widthSystemFont:[UIFont font_30]];
    UIButton* appendbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, titleWidth, 25)];
    [appendbutton setTitle:@"添加数据" forState:UIControlStateNormal];
    [appendbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [appendbutton.titleLabel setFont:[UIFont font_30]];
    [appendbutton addTarget:self action:@selector(appendBbiClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* bbiAppend = [[UIBarButtonItem alloc]initWithCustomView:appendbutton];
    [bbiAppend setTintColor:[UIColor whiteColor]];
    
    [self.navigationItem setRightBarButtonItem:bbiAppend];
    
}

- (void) subviewLayout
{
    [tvcRecords.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
        make.top.and.left.equalTo(self.view);
    }];
}

- (void) appendBbiClicked:(id) sender
{
    //BodyPressureDetectStartViewController
    [HMViewControllerManager createViewControllerWithControllerName:@"HeartRateDetectStartViewController" ControllerObject:nil];
}

@end

@interface ECGDetectRecordTableViewController () <TaskObserver>
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, assign) BOOL isBraceletData;
@end

@implementation ECGDetectRecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void) viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
    [self getUserTestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createTableHeaderView
{
    NSArray *titleArray = [NSArray arrayWithObjects:@"设备数据", @"手环数据", nil];
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:titleArray];
    self.segmentControl.tintColor = [UIColor mainThemeColor];
    self.segmentControl.selectedSegmentIndex = 0;
    [self.segmentControl addTarget:self action:@selector(segmentControlClick:) forControlEvents:UIControlEventValueChanged];
    
    UIView* chartview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 200)];
    [chartview setBackgroundColor:[UIColor whiteColor]];
    
    webview = [[UIWebView alloc]initWithFrame:chartview.bounds];
    [chartview addSubview:webview];
    [webview scalesPageToFit];
    [webview setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView setTableHeaderView:chartview];
    
    NSString *chartUrl;
    if (!_isBraceletData) {
        chartUrl = [self chartWebUrl];
    }
//    else{
//        chartUrl = [NSString stringWithFormat:@"%@bracelet_flotChart.htm?kpiCode=XL&userId=%@&type=1", kZJKHealthDataBaseUrl , userId];
//    }
    
    if (chartUrl){
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:chartUrl]]];
    }
}

#pragma mark -- Private Method
- (void)segmentControlClick:(UISegmentedControl *)sender
{
    NSString *chartUrl;
    if (sender.selectedSegmentIndex == 0) {
        _isBraceletData = NO;
        chartUrl = [self chartWebUrl];
    }else{
        _isBraceletData = YES;
        chartUrl = [NSString stringWithFormat:@"%@/bracelet_flotChart.htm?kpiCode=XL&userId=%@&type=2", kZJKHealthDataBaseUrl , userId];
    }
    
    if (chartUrl){
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:chartUrl]]];
    }
    
    [recordItems removeAllObjects];
    [self getUserTestData];
}

- (void)getUserTestData
{
    //创建任务，获取监测记录
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    NSInteger startRow = 0;
    if (recordItems){
        startRow = recordItems.count;
    }
    [dicPost setValue:[NSNumber numberWithInteger:startRow] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kDetectRecordTablePageSize] forKey:@"rows"];
    if (userId){
        [dicPost setValue:userId forKey:@"userId"];
    }
    
    if (_isBraceletData) {  //手环数据
        [dicPost setValue:@"2" forKey:@"type"];
        [[TaskManager shareInstance] createTaskWithTaskName:@"BraceletHeartRateListTask" taskParam:dicPost TaskObserver:self];
    }
    else{
        NSString* recordTaskName = [self detectRecordTaskName];
        if (recordTaskName){
            [[TaskManager shareInstance] createTaskWithTaskName:recordTaskName taskParam:dicPost TaskObserver:self];
        }
    }
}

- (NSString*) chartWebUrl{
    NSString* url = [NSString stringWithFormat:@"%@/ztqs_flotChart.htm?vType=YH&kpiCode=%@&userId=%@&dateType=2", kZJKHealthDataBaseUrl ,@"XL", userId];
    return url;
}

- (NSString*) detectRecordTaskName{
    return @"HeartRateRecordsTask";
}

- (void) loadMoreRecords
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    NSInteger startRow = 0;
    if (recordItems && 0 < recordItems.count){
        startRow = recordItems.count;
    }
    [dicPost setValue:[NSNumber numberWithInteger:startRow] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kDetectRecordTablePageSize] forKey:@"rows"];
    
    if (userId){
        [dicPost setValue:userId forKey:@"userId"];
    }
    
    if (_isBraceletData) {   //手环数据
        [dicPost setValue:@"2" forKey:@"type"];
        [[TaskManager shareInstance] createTaskWithTaskName:@"BraceletHeartRateListTask" taskParam:dicPost TaskObserver:self];
    }
    else{
        NSString* recordTaskName = [self detectRecordTaskName];
        [[TaskManager shareInstance] createTaskWithTaskName:recordTaskName taskParam:dicPost TaskObserver:self];
    }
}

#pragma mark - Table view data source
- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 40)];
    [headerview setBackgroundColor:[UIColor commonBackgroundColor]];
    
    UIView* dataview = [[UIView alloc]init];
    [headerview addSubview:dataview];
    [dataview setBackgroundColor:[UIColor whiteColor]];
    [dataview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(headerview);
        make.top.equalTo(headerview).with.offset(5);
        make.bottom.equalTo(headerview);
    }];
    
    UIView* bottomLine = [[UIView alloc]init];
    [dataview addSubview:bottomLine];
    
    [dataview addSubview:self.segmentControl];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dataview).with.offset(12.5);
        make.bottom.equalTo(dataview.mas_bottom);
        make.height.mas_equalTo(@30);
    }];
    
    [bottomLine setBackgroundColor:[UIColor mainThemeColor]];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.segmentControl.mas_bottom).with.offset(1);
        make.left.equalTo(self.segmentControl.mas_right).with.offset(-2);
        make.right.equalTo(dataview);
        make.height.mas_equalTo(@1);
    }];
    return headerview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HeartRateDetectRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeartRateDetectRecordTableViewCell"];
    cell = [[HeartRateDetectRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeartRateDetectRecordTableViewCell"];
    // Configure the cell...
    
    if (!_isBraceletData){
        HeartRateDetectRecord* record = recordItems[indexPath.row];
        [cell setDetectRecord:record];
    }
    else{
        BraceletHeartRateModel* model = recordItems[indexPath.row];
        [cell setBraceletHeartRateModel:model];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果是手环数据，不作跳转
    if (_isBraceletData) {
        return;
    }
    HeartRateDetectRecord* record = recordItems[indexPath.row];
    HeartRateDetectRecord* xyrecord = [[HeartRateDetectRecord alloc]init];

    if (!kStringIsEmpty(record.sourceKpiCode) && [record.sourceKpiCode isEqualToString:@"XY"])
    {
        [xyrecord setKpiCode:@"XY"];
        [xyrecord setTestDataId:record.sourceTestDataId];
        
        [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureResultContentViewController" ControllerObject:xyrecord];
    }
    else if (!kStringIsEmpty(record.sourceKpiCode) && [record.sourceKpiCode isEqualToString:@"XD"])
    {
        [xyrecord setKpiCode:@"XD"];
        [xyrecord setTestDataId:record.sourceTestDataId];
        [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectResultContentViewController" ControllerObject:xyrecord];
    }
    else{
        [xyrecord setKpiCode:@"XL"];
        [xyrecord setTestDataId:record.testDataId];
        [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectResultContentViewController" ControllerObject:xyrecord];
    }
}
@end
