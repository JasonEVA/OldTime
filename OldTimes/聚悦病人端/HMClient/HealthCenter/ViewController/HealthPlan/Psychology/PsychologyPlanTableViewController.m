//
//  PsychologyPlanTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/15.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PsychologyPlanTableViewController.h"
#import "PsychologyPlanRecordTableViewCell.h"
#import "HealthEducationItem.h"

typedef enum : NSUInteger {
     PsychologyPlan_RecordSection,
     PsychologyPlan_ReaderSection,
     PsychologyPlanTableSectionCount,
}  PsychologyPlanTableSection;

@interface PsychologyPlanTableViewController ()
<TaskObserver,
PsychologyPlanRecordDelegate>
{
    NSString* userId;
    UserPsychologyDetail* moodDetail;
    NSArray* educationClassrooms;
}
@end

@implementation PsychologyPlanTableViewController

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
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadPsychologyPlanDetail)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
    //[self loadPsychologyPlanDetail];
}

- (void) loadPsychologyPlanDetail
{
    //PsychologyDetailTask
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    if (userId)
    {
        [dicPost setValue:userId forKey:@"userId"];
    }
    [[TaskManager shareInstance] createTaskWithTaskName:@"PsychologyDetailTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return PsychologyPlanTableSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    switch (section)
    {
        case PsychologyPlan_RecordSection:
            return 1;
            break;
        case PsychologyPlan_ReaderSection:
        {
            if (educationClassrooms) {
                return educationClassrooms.count;
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 5)];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    return footerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 40)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    [headerview showBottomLine];
    
    UIImageView* ivFlage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_list_line"]];
    [headerview addSubview:ivFlage];
    [ivFlage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerview).with.offset(12.5);
        make.centerY.equalTo(headerview);
    }];
    
    UILabel* lbTitle = [[UILabel alloc]init];
    [headerview addSubview:lbTitle];
    [lbTitle setFont:[UIFont font_30]];
    [lbTitle setTextColor:[UIColor mainThemeColor]];
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivFlage.mas_right).with.offset(5);
        make.centerY.equalTo(headerview);
    }];
    
    switch (section)
    {
        case PsychologyPlan_RecordSection:
        {
            [lbTitle setText:@"今日心情"];
            

        }
            break;
        case PsychologyPlan_ReaderSection:
        {
            [lbTitle setText:@"相关阅读"];
            UIButton* moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [headerview addSubview:moreButton];
            [moreButton setTitle:@"更多>>" forState:UIControlStateNormal];
            [moreButton setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateNormal];
            [moreButton.titleLabel setFont:[UIFont font_24]];
            
            [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(headerview).with.offset(-12.5);
                make.centerY.equalTo(headerview);
                make.height.mas_equalTo(30);
            }];
            
            [moreButton addTarget:self action:@selector(moreRecordsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        default:
            break;
    }
    return headerview;
}

- (void) moreRecordsButtonClicked:(id) sender
{
    //跳转到健康宣教列表
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－健康课堂"];
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationStartViewController" ControllerObject:nil];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case PsychologyPlan_RecordSection:
        {
            return 100;
        }
            break;
        case PsychologyPlan_ReaderSection:
        {
            return 60;
        }
        default:
            break;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case PsychologyPlan_RecordSection:
            cell = [self psychologyRecordTableCell];
            break;
        case PsychologyPlan_ReaderSection:
            cell = [self psychologyReaderTableCell:indexPath.row];
            break;
        default:
            break;
    }
    // Configure the cell...
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PsychologyPlanTableViewCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


- (UITableViewCell*) psychologyRecordTableCell
{
    PsychologyPlanRecordTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PsychologyPlanRecordTableViewCell"];
    if (!cell)
    {
        cell = [[PsychologyPlanRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PsychologyPlanRecordTableViewCell"];
    }
    [cell setDelegate:self];
    
    if (moodDetail)
    {
        [cell setPsychologInfo:moodDetail.userMood];
    }
    return cell;
}


- (UITableViewCell*) psychologyReaderTableCell:(NSInteger) row
{
    PsychologyPlanReaderTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PsychologyPlanReaderTableViewCell"];
    if (!cell)
    {
        cell = [[PsychologyPlanReaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PsychologyPlanReaderTableViewCell"];
    }
    if (educationClassrooms)
    {
        HealthEducationItem *item = [educationClassrooms objectAtIndex:row];
        [cell setTitle:item.title Content:item.paper];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case PsychologyPlan_ReaderSection:
        {
            HealthEducationItem *educationModel = [educationClassrooms objectAtIndex:indexPath.row];
            
            [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationDetailViewController" ControllerObject:educationModel];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - TaskObservice
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.tableView.mj_header endRefreshing];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"ReportPsychologyTask"])
    {
        //重新获取心情数据
        [self loadPsychologyPlanDetail];
        return;
    }
    if ([taskname isEqualToString:@"PsychologyDetailTask"])
    {
        //获取相关阅读
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:@"MENTALITY" forKey:@"planTypeCode"];
        [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
        [dicPost setValue:[NSNumber numberWithInteger:5] forKey:@"rows"];
        [[TaskManager shareInstance] createTaskWithTaskName:@"HealthEducationListWithPlanTypeTask" taskParam:dicPost TaskObserver:self];
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
    
    if ([taskname isEqualToString:@"PsychologyDetailTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[UserPsychologyDetail class]])
        {
            moodDetail = (UserPsychologyDetail*) taskResult;
        }
    }
    if ([taskname isEqualToString:@"HealthEducationListWithPlanTypeTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResp = (NSDictionary*) taskResult;
            educationClassrooms = [dicResp valueForKey:@"list"];
        }
    }
}

#pragma mark - PsychologyPlanRecordDelegate
- (void) selectedPsychology:(NSInteger) moodType
{
    if (moodDetail && moodDetail.userMood)
    {
        //已经存在心情记录
        return;
    }
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:moodType] forKey:@"moodType"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"ReportPsychologyTask" taskParam:dicPost TaskObserver:self];
}
@end
