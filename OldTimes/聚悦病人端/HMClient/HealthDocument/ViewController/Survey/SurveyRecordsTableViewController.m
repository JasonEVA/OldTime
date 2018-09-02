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

@implementation SurveyRecordsStartViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"随访"];
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    SurveyRecordsTableViewController* tvcSurvey = [[SurveyRecordsTableViewController alloc]initWithUserId:[NSString stringWithFormat:@"%ld", curUser.userId]];
    [self addChildViewController:tvcSurvey];
    [self.view addSubview:tvcSurvey.tableView];
    [tvcSurvey.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
}

@end

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
    surveyTypes = @[@"1",@"4"];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView.superview showWaitView];
    
    NSInteger rows = kSurveyPageSize;
    if (surveyRecordItem && 0 == surveyRecordItem.count)
    {
        rows = surveyRecordItem.count;
    }
    
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    [dicPost setValue:surveyTypes forKey:@"surveyTypes"];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"type"];
    [dicPost setValue:[NSNumber numberWithLong:0] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithLong:rows] forKey:@"rows"];
    [dicPost setValue:userId forKey:@"userId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"SurveyRecordTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SurveyRecord *record = [surveyRecordItem objectAtIndex:indexPath.row];
    if (0 != record.status)
    {
        return 60 * kScreenScale;
    }else
    {
        return 80 * kScreenScale;
    }
    return 0;
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
        //不是自己的随访，不能填写
        UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
        NSString* curUserId = [NSString stringWithFormat:@"%ld", curUser.userId];
        if (![curUserId isEqualToString:userId])
        {
            return;
        }
    }
    [HMViewControllerManager createViewControllerWithControllerName:@"SurveyRecordDatailViewController" ControllerObject:record];
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView.superview closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    if (!surveyRecordItem || 0 == surveyRecordItem.count) {
        [self showBlankView];
    }
    else
    {
        [self closeBlankView];
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
    
    [dicPost setValue:[NSNumber numberWithLong:kSurveyPageSize] forKey:@"rows"];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"type"];
    [dicPost setValue:userId forKey:@"userId"];
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
