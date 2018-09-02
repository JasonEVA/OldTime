//
//  HealthyEducationListTableViewController.m
//  HMDoctor
//
//  Created by yinquan on 17/1/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthyEducationListTableViewController.h"
#import "HealthEducationItem.h"
#import "HealthEducationTableViewCell.h"

static NSInteger kHealthEducationListPageSize = 20;

@interface HealthyEducationListTableViewController ()
<TaskObserver, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSInteger totalCount;
}
@property (nonatomic, readonly) NSMutableArray* educationNotes;
@end

@implementation HealthyEducationListTableViewController

- (id) initWithColumeId:(NSInteger) columeId
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _columeId = columeId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setEmptyDataSetSource:self];
    [self.tableView setEmptyDataSetDelegate:self];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHealthEducationList)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadHealthEducationList
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kHealthEducationListPageSize] forKey:@"rows"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", self.columeId] forKey:@"classProgramTypeId"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", [UserInfoHelper defaultHelper].currentUserInfo.userId] forKey:@"userId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthEducationListTask" taskParam:dicPost TaskObserver:self];
}

- (void) educationNotesLoaded:(NSArray*) models
{
    _educationNotes = [NSMutableArray arrayWithArray:models];
    [self.tableView reloadData];
}

- (void) loadMoreHealthEducationList
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:self.educationNotes.count] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kHealthEducationListPageSize] forKey:@"rows"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", self.columeId] forKey:@"classProgramTypeId"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", [UserInfoHelper defaultHelper].currentUserInfo.userId] forKey:@"userId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthEducationListTask" taskParam:dicPost TaskObserver:self];
}

- (void) moreEducationNotesLoaded:(NSArray*) models
{
    if (!self.educationNotes)
    {
        _educationNotes = [NSMutableArray arrayWithArray:models];
    }
    else
    {
        for (HealthEducationItem* model in models) {
            if ([self educationNotesIsExisted:model])
            {
                continue;
            }
            [_educationNotes addObject:model];
        }
    }
    [self.tableView reloadData];
}

- (BOOL) educationNotesIsExisted:(HealthEducationItem*) model
{
    BOOL isExisted = NO;
    for (HealthEducationItem* note in self.educationNotes)
    {
        if (note.notesId == model.notesId)
        {
            return YES;
        }
    }
    
    return isExisted;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_educationNotes)
    {
        return _educationNotes.count;
    }
    return 0;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    return footerview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HealthEducationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthEducationTableViewCell"];
    if (!cell)
    {
        cell = [[HealthEducationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthEducationTableViewCell"];
    }
    // Configure the cell...
    HealthEducationItem* educationModel = self.educationNotes[indexPath.row];
    
    [cell setHealthEducationItem:educationModel];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthEducationItem* educationModel = self.educationNotes[indexPath.row];
    //跳转到宣教详情
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationDetailViewController" ControllerObject:educationModel];
}

#pragma mark - DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"img_blank_list"];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!self.educationNotes || self.educationNotes.count == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -68;
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (self.tableView.mj_header && [self.tableView.mj_header isRefreshing])
    {
        [self.tableView.mj_header endRefreshing];
    }
    if (taskError != StepError_None)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    if (totalCount >= self.educationNotes.count)
    {
        if (self.tableView.mj_footer)
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    else
    {
        if (self.tableView.mj_footer)
        {
            [self.tableView.mj_footer endRefreshing];
        }
        
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreHealthEducationList)];
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
    
    if ([taskname isEqualToString:@"HealthEducationListTask"])
    {
        if (!taskResult || ![taskResult isKindOfClass:[NSDictionary class]])
        {
            return;
        }
        NSDictionary* dicResult = (NSDictionary*) taskResult;
        NSNumber* numCount = [dicResult valueForKey:@"count"];
        NSArray* notes = [dicResult valueForKey:@"list"];
        
        totalCount = numCount.integerValue;
        
        NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
        NSNumber* numStartRow = [dicParam valueForKey:@"startRow"];
        if (!numStartRow || numStartRow.integerValue == 0) {
            //
            [self educationNotesLoaded:notes];
        }
        else
        {
            //
            [self moreEducationNotesLoaded:notes];
        }
    }
}
@end
