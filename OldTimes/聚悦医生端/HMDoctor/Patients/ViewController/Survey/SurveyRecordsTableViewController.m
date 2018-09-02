//
//  SurveyRecordsTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SurveyRecordsTableViewController.h"
#import "SurveyRecordsTableViewCell.h"
#import "SurveyRecordDatailViewController.h"
#import "SurveyRecord.h"

#define kSurveyPageSize         20

@interface SurveyRecordsTableViewController ()<TaskObserver>
{
    NSString* userId;
    
    NSMutableArray* surveyRecordItem;
    NSInteger totalCount;

}
@end

@implementation SurveyRecordsTableViewController

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
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    surveyTypes = @[@"1"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self p_requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshDataWithUserID:(NSString *)userID {
    userId = userID;
    [self p_requestData];
}

- (void)p_requestData {
    [self.tableView showWaitView];
    
    
    NSInteger rows = kSurveyPageSize;
    if (surveyRecordItem)
    {
        rows = surveyRecordItem.count;
    }
    
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    [dicPost setValue:surveyTypes forKey:@"surveyTypes"];
    [dicPost setValue:userId forKey:@"userId"];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"type"];
    [dicPost setValue:[NSNumber numberWithLong:0] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithLong:rows] forKey:@"rows"];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.userId] forKey:@"staffUserId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"SurveyRecordTask" taskParam:dicPost TaskObserver:self];

}
#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return surveyRecordItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SurveyRecord *record = [surveyRecordItem objectAtIndex:indexPath.row];
    
    SurveyRecordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SurveyRecordsTableViewCell"];
    if (!cell)
    {
        cell = [[SurveyRecordsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SurveyRecordsTableViewCell"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    [cell setSurveyRecord:record];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SurveyRecord *record = [surveyRecordItem objectAtIndex:indexPath.row];
    if (0 == record.status)
    {
        //患者还没有填写
        return;
    }
    
    //判断是否有查看权限
    BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeSurveyMode Status:record.status OperateCode:kPrivilegeViewOperate];
    if (!viewPrivilege)
    {
        return;
    }
    SurveyRecordDatailViewController *vc = [[SurveyRecordDatailViewController alloc] init];
    vc.record = record;
    [self.navigationController pushViewController:vc animated:YES];
    //[HMViewControllerManager createViewControllerWithControllerName:@"SurveyRecordDatailViewController" ControllerObject:record];
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
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
    
    if ([taskname isEqualToString:@"SurveyRecordTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            
            NSNumber* numCount = [dicResult valueForKey:@"count"];
            if (numCount && [numCount isKindOfClass:[NSNumber class]])
            {
                totalCount = numCount.integerValue;
            }
            
            NSArray *Items = [dicResult valueForKey:@"list"];
            
            NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
            NSNumber* numStart = [dicParam valueForKey:@"startRow"];
            if (numStart && [numStart isKindOfClass:[NSNumber class]] && 0 < numStart.integerValue)
            {
                //加载
                [self moreSurveyRecordListLoaded:Items];
                return;
            }
            else
            {
                [self surveyRecordListLoaded:Items];
            }
        }
    }

}

- (void) loadMoreSurveyItem
{
    NSDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:surveyTypes forKey:@"surveyTypes"];
    if (surveyRecordItem)
    {
        [dicPost setValue:[NSNumber numberWithLong:surveyRecordItem.count] forKey:@"startRow"];
    }
    [dicPost setValue:userId forKey:@"userId"];
    [dicPost setValue:[NSNumber numberWithLong:kSurveyPageSize] forKey:@"rows"];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"type"];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.userId] forKey:@"staffUserId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"SurveyRecordTask" taskParam:dicPost TaskObserver:self];
}


- (void) surveyRecordListLoaded:(NSArray*) surveyItems
{
    surveyRecordItem = [NSMutableArray arrayWithArray:surveyItems];
    [self.tableView reloadData];
    
    if (surveyRecordItem.count >= totalCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData ];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSurveyItem)];
    }
    
}

- (void) moreSurveyRecordListLoaded:(NSArray*) surveyItems
{
    if (!surveyRecordItem)
    {
        surveyRecordItem = [NSMutableArray array];
    }
    [surveyRecordItem addObjectsFromArray:surveyItems];
    [self.tableView reloadData];
    
    if (surveyRecordItem.count >= totalCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData ];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSurveyItem)];
    }
}


@end

@implementation InterrogationRecordsTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    surveyTypes = @[@"4"];
}

@end
