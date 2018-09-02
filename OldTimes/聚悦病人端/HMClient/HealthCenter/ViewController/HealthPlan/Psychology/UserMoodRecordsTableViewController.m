//
//  UserMoodRecordsTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserMoodRecordsTableViewController.h"
#import "PsychologyMoodRecordTableViewCell.h"

@interface UserMoodRecordsStartViewController ()
{
    UserMoodRecordsTableViewController* tvcMoodRecords;
}
@end

@implementation UserMoodRecordsStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"心情记录"];
    [self createMoodRecordsTable];
}

- (void) createMoodRecordsTable
{
    tvcMoodRecords = [[UserMoodRecordsTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:tvcMoodRecords];
    [self.view addSubview:tvcMoodRecords.tableView];
    [tvcMoodRecords.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
        
    }];
    
    //[tvcSports setDate:dateSelectView.date];
}

@end

#define kMoodRecordsPageSize            20

@interface UserMoodRecordsTableViewController ()
<TaskObserver>
{
    NSMutableArray* moodRecords;
    NSInteger totalCount;
}
@end

@implementation UserMoodRecordsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    moodRecords = [NSMutableArray array];
    totalCount = 0;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoodRecords)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
    
}

- (void) loadMoodRecords
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kMoodRecordsPageSize] forKey:@"rows"];
    [self.tableView.mj_header beginRefreshing];
    //UserMoodRecordsListTask
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserMoodRecordsListTask" taskParam:dicPost TaskObserver:self];
}

- (void) loadMoreMoodRecords
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:moodRecords.count] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kMoodRecordsPageSize] forKey:@"rows"];
    
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserMoodRecordsListTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (moodRecords)
    {
        return moodRecords.count;
    }
    return 0;
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
    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PsychologyMoodRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PsychologyMoodRecordTableViewCell"];
    if (!cell)
    {
        cell = [[PsychologyMoodRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PsychologyMoodRecordTableViewCell"];
    }
    // Configure the cell...
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UserPsychologyInfo* mood = moodRecords[indexPath.row];
    [cell setMoodInfo:mood];
    
    return cell;
}


#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView.mj_header endRefreshing];
    if (self.tableView.mj_footer)
    {
        if (moodRecords.count >= totalCount)
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData ];
        }
        else
        {
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMoodRecords)];
        }
    }
    
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    [self.tableView reloadData];
    if (!moodRecords ||0 == moodRecords.count) {
        [self showBlankView];
    }
    else
    {
        [self closeBlankView];
    }
    
    if (moodRecords.count < totalCount)
    {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMoodRecords)];
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
    
    if ([taskname isEqualToString:@"UserMoodRecordsListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            NSNumber* numCount = [dicResult valueForKey:@"count"];
            if (numCount && [numCount isKindOfClass:[NSNumber class]]) {
                totalCount = numCount.integerValue;
            }
            
            NSArray* items = (NSArray*) [dicResult valueForKey:@"list"];
            
            NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
            NSNumber* numStart = [dicParam valueForKey:@"startRow"];
            if (numStart && [numStart isKindOfClass:[NSNumber class]] && 0 < numStart.integerValue)
            {
                //加载更多。。。
                if (!moodRecords)
                {
                    moodRecords = [NSMutableArray array];
                }
                
                [moodRecords addObjectsFromArray:items];
            }
            else
            {
                moodRecords = [NSMutableArray arrayWithArray:items];
                
            }
            
            
        }
    }
}

@end
