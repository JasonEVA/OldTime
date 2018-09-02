//
//  MedicationPlanTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MedicationPlanTableViewController.h"
#import "UserRecipeRecordTableViewCell.h"
@interface MedicationPlanTableViewController ()
<TaskObserver,
UserRecipeRecordTableViewCellDelegate>
{
    NSString* dateStr;
    NSMutableArray* records;
    NSString* userId;
}
@end

@implementation MedicationPlanTableViewController

- (id) initWithUserId:(NSString*) aUserId
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        userId = aUserId;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRecipeRecords)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
}

- (void) setDate:(NSDate*) date
{
    dateStr = [date formattedDateWithFormat:@"yyyy-MM-dd"];
    [self.tableView.mj_header beginRefreshing];
}

- (void) loadRecipeRecords
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:dateStr forKey:@"date"];
    //[self.tableView.superview showWaitView];
    
    if (records)
    {
        [records removeAllObjects];
        [self.tableView reloadData];
    }
    if (userId)
    {
        [dicPost setValue:userId forKey:@"userId"];
    }
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserRecipeRecordListTask" taskParam:dicPost TaskObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (records)
    {
        return records.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UserRecipeRecord* record = records[indexPath.row];
    return [record recordCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserRecipeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserRecipeRecordTableViewCell"];
    if (!cell)
    {
        cell = [[UserRecipeRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserRecipeRecordTableViewCell"];
    }
    // Configure the cell...
    UserRecipeRecord* record = records[indexPath.row];
    [cell setUserRecipeRecord:record];
    [cell setDelegate:self];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.tableView.mj_header endRefreshing];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!records || 0 == records.count) {
        [self showBlankView];
    }
    else
    {
        [self closeBlankView];
    }
    
    [self.tableView reloadData];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"UserRecipeRecordListTask"])
    {
        [self.tableView reloadData];
    }
    
    if ([taskname isEqualToString:@"UserRecipeDrugTask"])
    {
        [self loadRecipeRecords];
    }
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
    
    if ([taskname isEqualToString:@"UserRecipeRecordListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            records = [NSMutableArray arrayWithArray:(NSArray*) taskResult];
        }
    }
    
    
}

#pragma mark UserRecipeRecordTableViewCellDelegate
- (void) userRecipeRecordDrag:(UITableViewCell*) cell
                    WithIndex:(NSInteger) index
{
    if (userId && 0 < userId.length)
    {
        if (userId.integerValue != [[[UserInfoHelper defaultHelper] currentUserInfo]userId])
        {
            return;
        }
        //好友的用药记录，不能编辑
        //return;
    }
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    if (!indexPath)
    {
        return;
    }
    
    UserRecipeRecord* record = records[indexPath.row];
    NSArray* usageList = record.useDrugList;
    if (usageList.count <= index)
    {
        return;
    }
    
    UserRecipeDrugUsage* dragUsage = usageList[index];
    [dicPost setValue:[[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd"] forKey:@"drugDate"];
    [dicPost setValue:dragUsage.userDrugsId forKey:@"userDrugsId"];
    [dicPost setValue:dragUsage.frequencyType forKey:@"frequencyType"];
    [dicPost setValue:record.recipeDetId forKey:@"recipeDetId"];
    //[self.tableView.superview showWaitView];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserRecipeDrugTask" taskParam:dicPost TaskObserver:self];
}
@end
