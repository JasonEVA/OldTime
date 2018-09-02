//
//  RoundsMessionsTableViewController.m
//  HMDoctor
//
//  Created by yinquan on 16/9/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "RoundsMessionsTableViewController.h"
#import "RoundsMessionTableViewCell.h"
#import "ATModuleInteractor+PatientChat.h"
#import "RoundsDetailViewController.h"

static const NSInteger kRoundsMessionPageSize = 20;

@interface RoundsMessionsTableViewController ()
<TaskObserver>
{
    NSMutableArray* roundsMessions;
    NSInteger totalCount;
}
@property (nonatomic, readonly) NSArray* statusList;
@end

@implementation RoundsMessionsTableViewController

- (id) initWithStatusList:(NSArray*) statusList
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        _statusList = statusList;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
//    [self createRoundsMessions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadRoundsMessionList];
}

- (void) loadRoundsMessionList
{
    if (self.statusList && self.statusList.count == 0)
    {
        [self showBlankView];
        return;
    }
    NSInteger rows = kRoundsMessionPageSize;
    if (roundsMessions && roundsMessions.count > rows)
    {
        rows = roundsMessions.count;
    }
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:@0 forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    if (_statusList)
    {
        [dicPost setValue:_statusList forKey:@"statusList"];
    }
    [self.tableView.superview showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"RoundsMessionsListTask" taskParam:dicPost TaskObserver:self];

}

- (void) loadMoreRoundsMessionList
{
    NSInteger startRow = 0;
    if (roundsMessions && roundsMessions.count > 0)
    {
        startRow = roundsMessions.count;
    }
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:startRow] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kRoundsMessionPageSize] forKey:@"rows"];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    if (_statusList)
    {
        [dicPost setValue:_statusList forKey:@"statusList"];
    }
    [self.tableView.superview showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"RoundsMessionsListTask" taskParam:dicPost TaskObserver:self];
}


- (void) roundsMessionsLoaded:(NSArray*) items
{
    roundsMessions = [NSMutableArray arrayWithArray:items];
    
}

- (void) moreRoundsMessionsLoaded:(NSArray*) items
{
    if (!roundsMessions)
    {
        roundsMessions = [NSMutableArray array];
    }
    
    [roundsMessions addObjectsFromArray:items];
    
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (roundsMessions)
    {
        return roundsMessions.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoundsMessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoundsMessionTableViewCell"];
    if (!cell)
    {
        cell = [[RoundsMessionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RoundsMessionTableViewCell"];
    }
    
    
    RoundsMessionModel* mession = roundsMessions[indexPath.row];
    [cell setRoundsMessionModel:mession];
    [cell.roundsButton setTag:(0x100 + indexPath.row)];
    [cell.roundsButton addTarget:self action:@selector(roundsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.archiveButton setTag:(0x101 + indexPath.row)];
    [cell.archiveButton addTarget:self action:@selector(archiveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoundsMessionModel* mession = roundsMessions[indexPath.row];
    return mession.status ? 150 : 135;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoundsMessionModel* mession = roundsMessions[indexPath.row];
    if ([mession.status isEqualToString:@"N"]) {
        // 待反馈
        [self at_postError:@"用户未反馈"];
    }
    else if ([mession.status isEqualToString:@"0"]) {
        // 未填写
        //待查房，不能查看
        BOOL editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeRoundsMode Status:0 OperateCode:kPrivilegeEditOperate];
        if (editPrivilege)
        {
            //跳转到填写查房表界面
            RoundsDetailViewController *VC = [[RoundsDetailViewController alloc] initWithModel:mession isFilled:NO];
            [self.navigationController pushViewController:VC animated:YES];
        }
        
    }
    else if ([mession.status isEqualToString:@"1"]) {
        // 已填写
        //已填写,跳转到查房详情页面
        RoundsDetailViewController *VC = [[RoundsDetailViewController alloc] initWithModel:mession isFilled:YES];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
}

#pragma mark - '查房'按钮点击事件
- (void) roundsButtonClicked:(id) sender
{
    UIButton* roundsButton = (UIButton*) sender;
    NSInteger clickedIndex = roundsButton.tag - 0x100;
    if (clickedIndex < 0 || !roundsMessions ||clickedIndex >= roundsMessions.count) {
        return;
    }
    
    RoundsMessionModel* mession = roundsMessions[clickedIndex];
    //跳转到填写查房表界面
    RoundsDetailViewController *VC = [[RoundsDetailViewController alloc] initWithModel:mession isFilled:NO];
    [self.navigationController pushViewController:VC animated:YES];
}

//跳转档案详情
- (void)archiveButtonClicked:(UIButton *) sender
{
    NSInteger clickedIndex = sender.tag - 0x101;
    RoundsMessionModel* mession = roundsMessions[clickedIndex];
    //2017-10-31版本 界面修改调整 by Jason
    [[ATModuleInteractor sharedInstance] goToPatientInfoDetailWithUid:[NSString stringWithFormat:@"%ld",(long)mession.userId]];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.tableView.superview closeWaitView];
    
    if (taskError != StepError_None) {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    
    if (0 == roundsMessions.count ) {
        [self showBlankView];
    }
    else
    {
        [self closeBlankView];
    }
    
    [self.tableView reloadData];
    NSDictionary* dicPost = [TaskManager taskparamWithTaskId:taskId];
    if (dicPost && [dicPost isKindOfClass:[NSDictionary class]])
    {
        NSNumber* numStartRow = [dicPost valueForKey:@"startRow"];
        if (numStartRow && [numStartRow isKindOfClass:[NSNumber class]] && numStartRow.integerValue == 0)
        {
            [self.tableView.superview closeWaitView];
        }
        if (totalCount <= roundsMessions.count)
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            [self.tableView.mj_footer endRefreshing];
        }
        
    }
    
    if (totalCount > roundsMessions.count)
    {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRoundsMessionList)];
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
    
    if ([taskname isEqualToString:@"RoundsMessionsListTask"])
    {
        NSDictionary* dicPost = [TaskManager taskparamWithTaskId:taskId];
        if (!taskResult || ![taskResult isKindOfClass:[NSDictionary class]])
        {
            return;
        }
        NSDictionary* dicResult = (NSDictionary*) taskResult;
        NSNumber* numCount = [dicResult valueForKey:@"count"];
        NSArray* list = [dicResult valueForKey:@"list"];
        
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            totalCount = numCount.integerValue;
        }
        
        if (!list || ![list isKindOfClass:[NSArray class]])
        {
            return;
        }
        
        if (dicPost && [dicPost isKindOfClass:[NSDictionary class]])
        {
            NSNumber* numStartRow = [dicPost valueForKey:@"startRow"];
            if (numStartRow && [numStartRow isKindOfClass:[NSNumber class]] && numStartRow.integerValue == 0)
            {
                [self roundsMessionsLoaded:list];
            }
            else
            {
                [self moreRoundsMessionsLoaded:list];
                
            }

            
        }

    }
}

@end
