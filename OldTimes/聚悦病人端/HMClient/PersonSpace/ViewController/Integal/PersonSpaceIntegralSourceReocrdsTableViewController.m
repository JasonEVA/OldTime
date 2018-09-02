//
//  PersonSpaceIntegralSourceReocrdsTableViewController.m
//  HMClient
//
//  Created by yinquan on 2017/7/17.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PersonSpaceIntegralSourceReocrdsTableViewController.h"
#import "IntegralRecordTableViewCell.h"
#import "IntegralRecordModel.h"

static NSInteger const kRecordPageSize = 10;


@interface PersonSpaceIntegralSourceReocrdsTableViewController ()
<TaskObserver,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, readonly) NSMutableArray* integralRecords;
@property (nonatomic, readonly) NSInteger pageNo;
@property (nonatomic, readonly) NSInteger  totalPage;
@property (nonatomic, readonly) NSInteger totalCount;
@end

@implementation PersonSpaceIntegralSourceReocrdsTableViewController

- (id) initWithSourceId:(NSInteger) sourceId
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _sourceId = sourceId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self loadIntegralRecords];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadIntegralRecords
{
    NSMutableDictionary* postDictionary = [NSMutableDictionary dictionary];
    [postDictionary setValue:@(self.sourceId) forKey:@"sourceId"];
    [postDictionary setValue:@(kRecordPageSize) forKey:@"pageSize"];
    
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"IntegralSourceRecordsListTask" taskParam:postDictionary TaskObserver:self];
}

- (void) loadMoreIntegralRecords
{
    NSInteger pageIndex = self.integralRecords.count / kRecordPageSize + 1;
    if ((self.integralRecords.count % kRecordPageSize) > 0) {
        ++pageIndex;
    }
    
    NSMutableDictionary* postDictionary = [NSMutableDictionary dictionary];
    [postDictionary setValue:@(self.sourceId) forKey:@"sourceId"];
    [postDictionary setValue:@(kRecordPageSize) forKey:@"pageSize"];
    [postDictionary setValue:@(pageIndex) forKey:@"pageIndex"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"IntegralSourceRecordsListTask" taskParam:postDictionary TaskObserver:self];
}

- (void) setSourceId:(NSInteger)sourceId
{
    if (sourceId == self.sourceId) {
        return;
    }
    
    _sourceId = sourceId;
    if (self.integralRecords)
    {
        [self.integralRecords removeAllObjects];
        [self.tableView reloadData];
    }
    [self loadIntegralRecords];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if (self.integralRecords) {
        return self.integralRecords.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IntegralRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntegralRecordTableViewCell"];
    if (!cell) {
        cell = [[IntegralRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntegralRecordTableViewCell"];
        // Configure the cell...
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    IntegralRecordModel* model = self.integralRecords[indexPath.row];
    
    [cell setIntegralRecordModel:model];

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    
    return footerview;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"img_blank_list"];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!self.integralRecords || self.integralRecords.count == 0) {
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
    return -38;
}


#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (taskError != StepError_None) {
        [self showAlertMessage:errorMessage];
        [self.tableView.mj_footer endRefreshing];
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
    
    if ([taskname isEqualToString:@"IntegralSourceRecordsListTask"])
    {
        [self.tableView reloadData];
        if (self.totalCount <= self.integralRecords.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreIntegralRecords)];
            
            MJRefreshBackNormalFooter* footer = (MJRefreshBackNormalFooter*) self.tableView.mj_footer;
            
            [footer setTitle:@"我是有底线的" forState:MJRefreshStateNoMoreData];
        }
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
    
    if ([taskname isEqualToString:@"IntegralSourceRecordsListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[IntegralSourceRecordModel class]])
        {
            IntegralSourceRecordModel* sourceModel = (IntegralSourceRecordModel*) taskResult;
            _totalCount = sourceModel.totalCount;
            _pageNo = sourceModel.pageNo;
            NSDictionary* postParam = [TaskManager taskparamWithTaskId:taskId];
            NSNumber* indexNumber = [postParam valueForKey:@"pageIndex"];
            
            if (indexNumber.integerValue == 0 || indexNumber.integerValue == 1)
            {
                _integralRecords = [NSMutableArray arrayWithArray:sourceModel.results];
                
            }
            else
            {
                NSArray* models = (NSArray*) sourceModel.results;
                [models enumerateObjectsUsingBlock:^(IntegralRecordModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
                    __block BOOL isExisted = NO;
                    [_integralRecords enumerateObjectsUsingBlock:^(IntegralRecordModel* existedModel, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (model.id == existedModel.id)
                        {
                            isExisted = YES;
                            return;
                        }
                    }];
                    if (!isExisted) {
                        [_integralRecords addObject:model];
                    }
                }];
            }
        }
        
    }
}

@end
