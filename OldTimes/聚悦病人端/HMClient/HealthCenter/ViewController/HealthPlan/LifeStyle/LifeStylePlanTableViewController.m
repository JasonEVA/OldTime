//
//  LifeStylePlanTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "LifeStylePlanTableViewController.h"
#import "LifeStylePlanTargetTableViewCell.h"
#import "HealthEducationItem.h"

typedef enum : NSUInteger {
    LifeStylePlan_GuideSection,
    LifeStylePlan_ReaderSection,
    LifeStylePlanTableSectionCount,
}  LifeStylePlanTableSection;

@interface LifeStylePlanViewController ()
{
    LifeStylePlanTableViewController* tvcLifeStyle;
    NSString* userId;
}
@end

@implementation LifeStylePlanViewController

- (id) initWithUserId:(NSString*) aUserId
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        userId = aUserId;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    if (self) {
        
    }
    [self createLifeStylePlanTable];
}

- (void) createLifeStylePlanTable
{
    tvcLifeStyle = [[LifeStylePlanTableViewController alloc]initWithUserId:userId];
    [self addChildViewController:tvcLifeStyle];
    [self.view addSubview:tvcLifeStyle.tableView];
    [tvcLifeStyle.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
}
@end

@interface LifeStylePlanTableViewController ()
<TaskObserver>
{
    UserLifeStyleDetail* lifestyleDetail;
    NSString* userId;
    NSArray* educationClassrooms;
}
@end

@implementation LifeStylePlanTableViewController

- (id) initWithUserId:(NSString *)aUserId
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
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadLifeStylePlanDetail)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    //[self loadLifeStylePlanDetail];
    [self.tableView.mj_header beginRefreshing];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


- (void) loadLifeStylePlanDetail
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    if (userId)
    {
        [dicPost setValue:userId forKey:@"userId"];
    }
    [[TaskManager shareInstance] createTaskWithTaskName:@"LifeStylePlanDetailTask" taskParam:dicPost TaskObserver:self];
}

- (void) moreReaderButtonClicked:(id) sender
{
    //跳转到健康宣教列表
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－健康课堂"];
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationStartViewController" ControllerObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return LifeStylePlanTableSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    switch (section)
    {
        case LifeStylePlan_GuideSection:
            return 1;
            break;
        case LifeStylePlan_ReaderSection:
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
        case LifeStylePlan_GuideSection:
        {
            [lbTitle setText:@"医生指导"];
        }
            break;
        case LifeStylePlan_ReaderSection:
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case LifeStylePlan_GuideSection:
        {
            if (lifestyleDetail && lifestyleDetail.target)
            {
                return [lifestyleDetail.target cellHeight];
            }
            return 30;
        }
            break;
        case LifeStylePlan_ReaderSection:
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
        case LifeStylePlan_GuideSection:
        {
            cell = [self lifeStyleSuggestTableCell];
        }
            break;
        case LifeStylePlan_ReaderSection:
        {
            cell = [self lifeStyleReaderTableCell:indexPath.row];
        }
            break;
            
        default:
            break;
    }
    // Configure the cell...
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LifeStylePlanTableViewCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (UITableViewCell*) lifeStyleSuggestTableCell
{
    LifeStylePlanTargetTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"LifeStylePlanTargetTableViewCell"];
    if (!cell)
    {
        cell = [[LifeStylePlanTargetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LifeStylePlanTargetTableViewCell"];
    }
    
    if (lifestyleDetail && lifestyleDetail.target)
    {
        [cell setLifeStyleSuggest:lifestyleDetail.target.suggest];
    }
    return cell;
}

- (UITableViewCell*) lifeStyleReaderTableCell:(NSInteger) row
{
    LifeStylePlanReaderTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"LifeStylePlanReaderTableViewCell"];
    if (!cell)
    {
        cell = [[LifeStylePlanReaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LifeStylePlanReaderTableViewCell"];
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
        case LifeStylePlan_ReaderSection:
        {
            HealthEducationItem *item = [educationClassrooms objectAtIndex:indexPath.row];
            
            [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationDetailViewController" ControllerObject:item];
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
    if ([taskname isEqualToString:@"LifeStylePlanDetailTask"]) {
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:@"LIVE" forKey:@"planTypeCode"];
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
    
    if ([taskname isEqualToString:@"LifeStylePlanDetailTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[UserLifeStyleDetail class]])
        {
            lifestyleDetail = (UserLifeStyleDetail*) taskResult;
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
