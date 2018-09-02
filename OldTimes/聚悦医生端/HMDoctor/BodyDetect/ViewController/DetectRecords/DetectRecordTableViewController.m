//
//  DetectRecordTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectRecordTableViewController.h"

@interface DetectRecordTableViewController ()
<TaskObserver>
{
    UISegmentedControl *segmentControl;
}
//所有、预警数据
@property (nonatomic, assign) BOOL isAll;
@property (nonatomic, retain) NSString* recordName;
@end

@implementation DetectRecordTableViewController

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
    [self createTableHeaderView];
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"所有数据", @"预警数据", nil];
    segmentControl = [[UISegmentedControl alloc] initWithItems:titleArray];
    segmentControl.tintColor = [UIColor mainThemeColor];
    segmentControl.selectedSegmentIndex = 0;
    [segmentControl setHidden:YES];
    [segmentControl addTarget:self action:@selector(segmentControlClick:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createTableHeaderView
{
    UIView* chartview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 200)];
    [chartview setBackgroundColor:[UIColor whiteColor]];
    
    webview = [[UIWebView alloc]initWithFrame:chartview.bounds];
    [chartview addSubview:webview];
    [webview scalesPageToFit];
    [webview setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView setTableHeaderView:chartview];
    
    NSString* chartUrl = [self chartWebUrl];
    if (chartUrl)
    {
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:chartUrl]]];
    }
}

- (NSString*) chartWebUrl
{
    return nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getUserTestData];
}

- (void)getUserTestData
{
    NSString* recordTaskName = [self detectRecordTaskName];
    _recordName = recordTaskName;
    if (recordTaskName)
    {
        //创建任务，获取监测记录
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
        NSInteger startRow = 0;
        if (recordItems)
        {
            startRow = recordItems.count;
        }
        [dicPost setValue:[NSNumber numberWithInteger:startRow] forKey:@"startRow"];
        [dicPost setValue:[NSNumber numberWithInteger:kDetectRecordTablePageSize] forKey:@"rows"];
        if (userId)
        {
            [dicPost setValue:userId forKey:@"userId"];
        }
        
        if (_isAll) {
            [dicPost setValue:@"Y" forKey:@"isAlertValue"];
        }
        
        [[TaskManager shareInstance] createTaskWithTaskName:recordTaskName taskParam:dicPost TaskObserver:self];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (recordItems)
    {
        return recordItems.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

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
    
    if ([_recordName isEqualToString:@"UrineVolumeRecordsTask"] || [_recordName isEqualToString:@"PEFRecordsTask"]) {
    
        [segmentControl setHidden:YES];
        
        UILabel* lbData = [[UILabel alloc]init];
        [dataview addSubview:lbData];
        [lbData setBackgroundColor:[UIColor clearColor]];
        [lbData setTextColor:[UIColor colorWithHexString:@"666666"]];
        [lbData setFont:[UIFont systemFontOfSize:13]];
        [lbData setText:@"所有数据"];
        
        [lbData mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dataview).with.offset(12.5);
            make.centerY.equalTo(dataview);
            make.height.mas_equalTo(@35);
        }];
        
        [bottomLine setBackgroundColor:[UIColor commonControlBorderColor]];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(dataview);
            make.width.equalTo(dataview);
            make.height.mas_equalTo(@1);
        }];
    }
    else{
        
        [segmentControl setHidden:NO];
        [dataview addSubview:segmentControl];
        [segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dataview).with.offset(12.5);
            make.bottom.equalTo(dataview.mas_bottom);
            make.height.mas_equalTo(@30);
        }];
        
        [bottomLine setBackgroundColor:[UIColor mainThemeColor]];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(segmentControl.mas_bottom).with.offset(1);
            make.left.equalTo(segmentControl.mas_right).with.offset(-2);
            make.right.equalTo(dataview);
            make.height.mas_equalTo(@1);
        }];
    }
    return headerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 0.5)];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    return footerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

- (void)segmentControlClick:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        _isAll = NO;
    }else{
        _isAll = YES;
    }
    [recordItems removeAllObjects];
    [self getUserTestData];
}

- (void) detectRecordsLoaded:(NSArray*) items
{
    if (!recordItems)
    {
        recordItems = [NSMutableArray array];
    }
    
    [recordItems addObjectsFromArray:items];
    [self.tableView reloadData];

}

- (void) loadMoreRecords
{
    NSString* recordTaskName = [self detectRecordTaskName];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    NSInteger startRow = 0;
    if (recordItems && 0 < recordItems.count)
    {
        startRow = recordItems.count;
    }
    [dicPost setValue:[NSNumber numberWithInteger:startRow] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kDetectRecordTablePageSize] forKey:@"rows"];
    
    if (userId)
    {
        [dicPost setValue:userId forKey:@"userId"];
    }
    if (_isAll) {
        [dicPost setValue:@"Y" forKey:@"isAlertValue"];
    }
    
    [[TaskManager shareInstance] createTaskWithTaskName:recordTaskName taskParam:dicPost TaskObserver:self];
}

- (NSString*) detectRecordTaskName
{
    return nil;
}

- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (recordItems.count < totalCount)
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRecords)];
    }
    else
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    if (StepError_None != taskError) {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId ||0 == taskId.length)
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
            recordItems = [NSMutableArray array];
        }
    }
    
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
            [self detectRecordsLoaded:list];
        }
    }
}
@end
