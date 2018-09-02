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
    
    NSString* recordTaskName = [self detectRecordTaskName];
    if (recordTaskName)
    {
        //创建任务，获取监测记录 
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
        NSInteger startRow = 0;
        NSInteger rows = kDetectRecordTablePageSize;
        if (recordItems && 0 < recordItems.count)
        {
            rows = recordItems.count;
        }
        [dicPost setValue:[NSNumber numberWithInteger:startRow] forKey:@"startRow"];
        [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
        [dicPost setValue:userId forKey:@"userId"];
        
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
    
    UILabel* lbData = [[UILabel alloc]init];
    [dataview addSubview:lbData];
    [lbData setBackgroundColor:[UIColor clearColor]];
    [lbData setTextColor:[UIColor colorWithHexString:@"666666"]];
    [lbData setFont:[UIFont font_26]];
    [lbData setText:@"所有数据"];
    
    [lbData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dataview).with.offset(12.5);
        make.centerY.equalTo(dataview);
        make.height.mas_equalTo(@21);
    }];
    
    UIView* bottomLine = [[UIView alloc]init];
    [bottomLine setBackgroundColor:[UIColor commonControlBorderColor]];
    [dataview addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(dataview);
        make.width.equalTo(dataview);
        make.height.mas_equalTo(@0.5);
    }];
    
    
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
    if (recordItems)
    {
        startRow = recordItems.count;
    }
    [dicPost setValue:[NSNumber numberWithInteger:startRow] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kDetectRecordTablePageSize] forKey:@"rows"];
    [dicPost setValue:userId forKey:@"userId"];
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
