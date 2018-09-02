//
//  SportsPlanTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/14.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SportsPlanTableViewController.h"
#import "SportsPlanTargetTableViewCell.h"
#import "UserSportsDetail.h"
#import "SportsPlanRecommandSportsTableViewCell.h"
#import "HealthEducationItem.h"


typedef enum : NSUInteger {
    SportsPlanTable_TargetSection,
    SportsPlanTable_RecommandSection,
    SportsPlanTable_ReaderSection,
    SportsPlanTableSectionCount,
} SportsPlanTableSection;

@interface SportsPlanTableViewController ()
<TaskObserver>
{
    NSString* dateStr;
    UserSportsDetail* sportsDetail;
    NSArray* educationClassrooms;
}
@end

@implementation SportsPlanTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadSports)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    
}

- (void) setDate:(NSDate*) date
{
    [self.tableView.mj_header beginRefreshing];
    sportsDetail = nil;
    dateStr = [date formattedDateWithFormat:@"yyyy-MM-dd"];
    [self loadSports];
}

- (void) loadSports
{
    [self.tableView reloadData];
    //
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:dateStr forKey:@"date"];
    
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserSportsDetailTask" taskParam:dicPost TaskObserver:self];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (dateStr)
    {
        [self loadSports];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) moreReaderButtonClicked:(id) sender
{
    //跳转到健康宣教列表
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－健康课堂"];
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationStartViewController" ControllerObject:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return SportsPlanTableSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    switch (section)
    {
        case SportsPlanTable_TargetSection:
        
            return 1;
        case SportsPlanTable_RecommandSection:
            if (sportsDetail && sportsDetail.sportType && 0 < sportsDetail.sportType.count)
            {
                return 1;
            }
            break;
        case SportsPlanTable_ReaderSection:
        {
            if (educationClassrooms)
            {
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
    switch (section)
    {
        case SportsPlanTable_RecommandSection:
            if (!sportsDetail || !sportsDetail.sportType || 0 == sportsDetail.sportType.count)
            {
                return 0;
            }
            break;
            
        default:
            break;
    }
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
    switch (section)
    {
        //case SportsPlanTable_RecommandSection:
        case SportsPlanTable_RecommandSection:
        {
            if (!sportsDetail || !sportsDetail.sportType || 0 == sportsDetail.sportType.count)
            {
                return 0;
            }
            return 40;
        }
        case SportsPlanTable_ReaderSection:
            return 40;
            break;
            
        default:
            break;
    }
    return 0;
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
        case SportsPlanTable_RecommandSection:
        {
            [lbTitle setText:@"推荐运动方式"];
        }
            break;
        case SportsPlanTable_ReaderSection:
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
            
            [moreButton addTarget:self action:@selector(moreReaderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        default:
            break;
    }
    return headerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case SportsPlanTable_TargetSection:
            return 200;
            break;
        case SportsPlanTable_RecommandSection:
        {
            NSInteger rows = sportsDetail.sportType.count / 4;
            if (0 < rows % 4) {
                rows++;
            }
            
            return rows * 26 + 14;
        }
            break;
        case SportsPlanTable_ReaderSection:
        {
            return 45;
        }
            break;
        default:
            break;
    }
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case SportsPlanTable_TargetSection:
        {
            cell = [self sportsTargetTableCell];
        }
            break;
        case SportsPlanTable_RecommandSection:
        {
            cell = [self recommandSportsTableCell];
        }
            break;
        case SportsPlanTable_ReaderSection:
        {
            cell = [self sportsReaderTableCell:indexPath.row];
        }
            break;
        default:
            break;
    }
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SportsPlanTableViewController"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


- (UITableViewCell*) sportsTargetTableCell
{
    SportsPlanTargetTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"SportsPlanTargetTableViewCell"];
    if (!cell)
    {
        cell = [[SportsPlanTargetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SportsPlanTargetTableViewCell"];
    }
    
    if (sportsDetail)
    {
        [cell setUserSportsDetail:sportsDetail];
    }
    return cell;
}

- (UITableViewCell*) recommandSportsTableCell
{
    SportsPlanRecommandSportsTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"SportsPlanRecommandSportsTableViewCell"];
    if (!cell)
    {
        cell = [[SportsPlanRecommandSportsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SportsPlanRecommandSportsTableViewCell"];
    }
    
    if (sportsDetail)
    {
        [cell setSportType:sportsDetail.sportType];
    }
    return cell;
}

- (UITableViewCell*) sportsReaderTableCell:(NSInteger) index
{
    SportsPlanReaderTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"SportsPlanReaderTableViewCell"];
    if (!cell)
    {
        cell = [[SportsPlanReaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SportsPlanReaderTableViewCell"];
    }
    
    if (educationClassrooms)
    {
        //[cell setSportType:sportsDetail.sportType];
        HealthEducationItem* item = educationClassrooms[index];
        [cell setTitle:item.title];
    }
    else
    {
        [cell setTitle:@""];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case SportsPlanTable_ReaderSection:
        {
            HealthEducationItem *item = [educationClassrooms objectAtIndex:indexPath.row];
            
            [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationDetailViewController" ControllerObject:item];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - TaskObserver
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
    if ([taskname isEqualToString:@"UserSportsDetailTask"]) {
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:@"SPORTS" forKey:@"planTypeCode"];
        [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
        [dicPost setValue:[NSNumber numberWithInteger:5] forKey:@"rows"];
        [[TaskManager shareInstance] createTaskWithTaskName:@"HealthEducationListWithPlanTypeTask" taskParam:dicPost TaskObserver:self];
    }
    [self.tableView reloadData];
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
    
    if ([taskname isEqualToString:@"UserSportsDetailTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[UserSportsDetail class]])
        {
            sportsDetail = (UserSportsDetail*) taskResult;
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
@end
