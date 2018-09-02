//
//  NutritionPlanTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NutritionPlanTableViewController.h"
#import "NutriationPlanTableViewCell.h"
#import "NuritionDietRecordTableViewCell.h"
#import "HealthEducationItem.h"

typedef enum : NSUInteger {
    NutritionReferenceSection,
    NutritionRecordSection,
    NutritionReaderSection,
    NutritionTableSectionCount,
} NutritionTableSection;

@interface NutritionPlanTableViewController ()
<TaskObserver>
{
    NuritionDetail* nuritionDetail;
    NSArray* educationClassRooms;
}
@end

@implementation NutritionPlanTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNuritionDetail)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadNuritionDetail
{
    [[TaskManager shareInstance] createTaskWithTaskName:@"NuritionPlanDetailTask" taskParam:nil TaskObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return NutritionTableSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    switch (section)
    {
        case NutritionReferenceSection:
        {
            return 1;
        }
            break;
        case NutritionRecordSection:
        {
            if (nuritionDetail && nuritionDetail.userDiets)
            {
                return nuritionDetail.userDiets.count;
            }
        }
            break;
        case NutritionReaderSection:
        {
            if (educationClassRooms) {
                return educationClassRooms.count;
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
        case NutritionReferenceSection:
        {
            [lbTitle setText:@"营养参考"];
        }
            break;
        case NutritionRecordSection:
        {
            [lbTitle setText:@"饮食记录"];
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
        case NutritionReaderSection:
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

- (void) moreRecordsButtonClicked:(id) sender
{
    //跳转饮食记录界面 NuritionDietRecordsStartViewController
    [HMViewControllerManager createViewControllerWithControllerName:@"NuritionDietRecordsStartViewController" ControllerObject:nil];
}

- (void) moreReaderButtonClicked:(id) sender
{
    //跳转到健康宣教列表
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－健康课堂"];
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationStartViewController" ControllerObject:nil];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case NutritionReferenceSection:
        {
            if (nuritionDetail && nuritionDetail.nutrition)
            {
                return [nuritionDetail.nutrition cellHeight];
            }
            return 30;
        }
            break;
        case NutritionRecordSection:
        case NutritionReaderSection:
            return 60;
            break;
            
        default:
            break;
    }
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case NutritionReferenceSection:
        {
            cell = [self nuritionSuggestTableCell];
        }
            break;
        case NutritionRecordSection:
        {
            cell = [self nuritionDietRecordTableCell:indexPath.row];
        }
            break;
        case NutritionReaderSection:
        {
            cell = [self nuritionReaderTableCell:indexPath.row];
        }
            break;
            
        default:
            break;
    }
    // Configure the cell...
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NuritionPlanTableViewCell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (UITableViewCell*) nuritionSuggestTableCell
{
    NutriationPlanTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"NutriationPlanTableViewCell"];
    if (!cell)
    {
        cell = [[NutriationPlanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NutriationPlanTableViewCell"];
    }
    
    if (nuritionDetail && nuritionDetail.nutrition)
    {
        [cell setNuritionSuggest:nuritionDetail.nutrition.suggest];
    }
    return cell;
}

- (UITableViewCell*) nuritionDietRecordTableCell:(NSInteger) row
{
    NuritionDietRecordTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"NuritionDietRecordTableViewCell"];
    if (!cell)
    {
        cell = [[NuritionDietRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NuritionDietRecordTableViewCell"];
    }
    if (nuritionDetail && nuritionDetail.userDiets)
    {
        NuritionDietInfo *item = [nuritionDetail.userDiets objectAtIndex:row];
        [cell setNuritionDiet:item];
    }
    return cell;
}

- (UITableViewCell*) nuritionReaderTableCell:(NSInteger) row
{
    NuritionPlanReaderTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"NuritionPlanReaderTableViewCell"];
    if (!cell)
    {
        cell = [[NuritionPlanReaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NuritionPlanReaderTableViewCell"];
    }
    if (educationClassRooms)
    {
        HealthEducationItem* model = [educationClassRooms objectAtIndex:row];
        [cell setTitle:model.title Content:model.paper];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case NutritionReaderSection:
        {
            HealthEducationItem* educationModel = educationClassRooms[indexPath.row];
            //跳转到宣教详情
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
    if ([taskname isEqualToString:@"NuritionPlanDetailTask"]) {
        //获取营养相关阅读
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:@"NUTRITION" forKey:@"planTypeCode"];
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
    
    if ([taskname isEqualToString:@"NuritionPlanDetailTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NuritionDetail class]])
        {
            nuritionDetail = (NuritionDetail*) taskResult;
        }
    }
    if ([taskname isEqualToString:@"HealthEducationListWithPlanTypeTask"]) {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResp = (NSDictionary*) taskResult;
            educationClassRooms = [dicResp valueForKey:@"list"];
        }
    }
}
@end
