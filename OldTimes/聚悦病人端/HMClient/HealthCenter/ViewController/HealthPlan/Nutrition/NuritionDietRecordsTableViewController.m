//
//  NuritionDietRecordsTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NuritionDietRecordsTableViewController.h"
#import "NuritionDietRecordTableViewCell.h"

@interface NuritionDietRecordsTableViewController ()
<TaskObserver>
{
    NSDate* selectedDate;
    NSArray* dietGroups;
}
@end

@implementation NuritionDietRecordsTableViewController

- (id) initWithDate:(NSDate*) date
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        selectedDate = date;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDietRecords)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void) setDate:(NSDate*) date
{
    selectedDate = date;
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadDietRecords
{
    if (!selectedDate)
    {
        [self.tableView.mj_header endRefreshing];
    }
    //NuritionDietRecordsTask
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    NSString* dateStr = [selectedDate formattedDateWithFormat:@"yyyy-MM-dd"];
    [dicPost setValue:dateStr forKey:@"dateStr"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"NuritionDietRecordsTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    if (dietGroups)
    {
        return dietGroups.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    NuritionDietGroup* group = dietGroups[section];
    
    if (group.userDiets)
    {
        return group.userDiets.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 38)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    
    UILabel* lbTitle = [[UILabel alloc]init];
    [headerview addSubview:lbTitle];
    [lbTitle setTextColor:[UIColor commonTextColor]];
    [lbTitle setFont:[UIFont font_30]];
    
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerview).with.offset(12.5);
        make.centerY.equalTo(headerview);
    }];
    
    NuritionDietGroup* group = dietGroups[section];
    [lbTitle setText:group.dietName];
    
    [headerview showBottomLine];
    return headerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NuritionDietRecordTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"NuritionDietRecordTableViewCell"];
    if (!cell)
    {
        cell = [[NuritionDietRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NuritionDietRecordTableViewCell"];
    }
    
    NuritionDietGroup* group = dietGroups[indexPath.section];
    NSArray* diets = group.userDiets;
    NuritionDietInfo* diet = diets[indexPath.row];
    [cell setNuritionDiet:diet];
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
    [self.tableView reloadData];
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
    
    if ([taskname isEqualToString:@"NuritionDietRecordsTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            dietGroups = (NSArray*) taskResult;
        }
    }
}
@end
