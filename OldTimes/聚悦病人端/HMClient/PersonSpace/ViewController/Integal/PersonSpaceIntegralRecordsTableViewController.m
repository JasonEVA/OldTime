//
//  PersonSpaceIntegralRecordsTableViewController.m
//  HMClient
//
//  Created by yinquan on 2017/7/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PersonSpaceIntegralRecordsTableViewController.h"
#import "IntegralRecordModel.h"
#import "IntegralRecordTableViewCell.h"

static NSInteger const kRecordPageSize = 10;

@interface PersonSpaceIntegralRecordsTableViewController ()
<TaskObserver,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    
}
@property (nonatomic, readonly) NSMutableArray* monthModels;
@end

@implementation PersonSpaceIntegralRecordsTableViewController

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
    //IntegralRecordsTask
    NSMutableDictionary* postDictionary = [NSMutableDictionary dictionary];
    [postDictionary setValue:@(kRecordPageSize) forKey:@"PageSize"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"IntegralRecordsTask" taskParam:postDictionary TaskObserver:self];
    
}

- (void) loadMoreIntegralRecords
{
    NSInteger totalRecordsCount = [self totalRecordsCount:self.monthModels];
    NSInteger pageIndex = totalRecordsCount / kRecordPageSize + 1;
    if ((totalRecordsCount % kRecordPageSize) > 0) {
        ++pageIndex;
    }
    NSMutableDictionary* postDictionary = [NSMutableDictionary dictionary];
    [postDictionary setValue:@(kRecordPageSize) forKey:@"PageSize"];
    [postDictionary setValue:@(pageIndex) forKey:@"pageIndex"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"IntegralRecordsTask" taskParam:postDictionary TaskObserver:self];
}

- (void) integralRecords:(NSArray*) monthModels
{
    _monthModels = [NSMutableArray arrayWithArray:monthModels];
    [self.tableView reloadData];
    if ([self totalRecordsCount:monthModels] < kRecordPageSize) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }
    else
    {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreIntegralRecords)];
        MJRefreshBackNormalFooter* footer = (MJRefreshBackNormalFooter*) self.tableView.mj_footer;
        
        [footer setTitle:@"我是有底线的" forState:MJRefreshStateNoMoreData];
        
    }
    
}

- (void) moreIntegralRecords:(NSArray*) monthModels
{
    if (!self.monthModels) {
        _monthModels = [NSMutableArray arrayWithArray:monthModels];
//        [self.tableView reloadData];
    }
    else
    {
        [monthModels enumerateObjectsUsingBlock:^(IntegralMonthRecordModel* monthModel, NSUInteger idx, BOOL * _Nonnull stop) {
            __block BOOL isExisted = NO;
            [self.monthModels enumerateObjectsUsingBlock:^(IntegralMonthRecordModel* existedMonthModel, NSUInteger idx, BOOL * _Nonnull existedstop) {
                if ([monthModel.time isEqualToString:existedMonthModel.time])
                {
                    isExisted = YES;
                    [existedMonthModel combineMonthModel:monthModel];
                    return ;
                    *existedstop = YES;
                }
                
            }];
            if (!isExisted) {
                [self.monthModels addObject:monthModel];
            }
            
        }];
        
    }
    [self.tableView reloadData];
    if ([self totalRecordsCount:monthModels] < kRecordPageSize) {
        if (self.tableView.mj_footer)
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        
    }
    else
    {
        if (self.tableView.mj_footer) {
            [self.tableView.mj_footer endRefreshing];
        }
        else
        {
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreIntegralRecords)];
            MJRefreshBackNormalFooter* footer = (MJRefreshBackNormalFooter*) self.tableView.mj_footer;
            
            [footer setTitle:@"我是有底线的" forState:MJRefreshStateNoMoreData];
        }
        
    }
    
    
}

- (NSInteger) totalRecordsCount:(NSArray*) monthModels
{
    __block NSInteger totalRecordsCount = 0;
    [monthModels enumerateObjectsUsingBlock:^(IntegralMonthRecordModel* monthModel, NSUInteger idx, BOOL * _Nonnull stop) {
        totalRecordsCount += monthModel.userIntegerDetailsVOS.count;
    }];
    return totalRecordsCount;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (_monthModels) {
        return _monthModels.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    IntegralMonthRecordModel* monthModel = self.monthModels[section];
    if (monthModel && monthModel.userIntegerDetailsVOS) {
        return monthModel.userIntegerDetailsVOS.count;
    }
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 32)];
    IntegralMonthRecordModel* monthModel = self.monthModels[section];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView* colorview = [[UIImageView alloc] init];
    [colorview setBackgroundColor:[UIColor mainThemeColor]];
    [headerview addSubview:colorview];
    [colorview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 10));
        make.centerY.equalTo(headerview);
        make.left.equalTo(headerview).with.offset(15);
    }];
    
    UILabel* monthLabel = [[UILabel alloc] init];
    [headerview addSubview:monthLabel];
    [monthLabel setFont:[UIFont systemFontOfSize:15]];
    [monthLabel setTextColor:[UIColor commonGrayTextColor]];
    [monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(colorview.mas_right).with.offset(7);
        make.centerY.equalTo(headerview);
    }];

    NSDate* monthdate = [NSDate dateWithString:monthModel.time formatString:@"yyyy-MM"];
    if ([monthdate monthsAgo] == 0) {
        [monthLabel setText:@"本月"];
    }
    else
    {
        [monthLabel setText:monthModel.time];
    }
    
    UILabel* useLabel = [[UILabel alloc] init];
    [headerview addSubview:useLabel];
    [useLabel setFont:[UIFont systemFontOfSize:15]];
    [useLabel setTextColor:[UIColor colorWithHexString:@"4CAF50"]];
    [useLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerview);
        make.right.equalTo(headerview).with.offset(-21);
    }];
    [useLabel setText:[NSString stringWithFormat:@"%ld", monthModel.useNum]];
    
    UILabel* useTitleLabel = [[UILabel alloc] init];
    [headerview addSubview:useTitleLabel];
    [useTitleLabel setFont:[UIFont systemFontOfSize:15]];
    [useTitleLabel setTextColor:[UIColor commonGrayTextColor]];
    [useTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerview);
        make.right.equalTo(useLabel.mas_left).with.offset(-2);
    }];
    [useTitleLabel setText:@"使用:"];
    
    UILabel* gainLabel = [[UILabel alloc] init];
    [headerview addSubview:gainLabel];
    [gainLabel setFont:[UIFont systemFontOfSize:15]];
    [gainLabel setTextColor:[UIColor colorWithHexString:@"F4511E"]];
    [gainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerview);
        make.right.equalTo(useTitleLabel.mas_left).with.offset(-21);
    }];
    [gainLabel setText:[NSString stringWithFormat:@"%ld", monthModel.totalNum]];
    
    UILabel* gainTitleLabel = [[UILabel alloc] init];
    [headerview addSubview:gainTitleLabel];
    [gainTitleLabel setFont:[UIFont systemFontOfSize:15]];
    [gainTitleLabel setTextColor:[UIColor commonGrayTextColor]];
    [gainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(gainLabel.mas_left).with.offset(-2);
        make.centerY.equalTo(headerview);
    }];
    [gainTitleLabel setText:@"获取:"];
    
    [headerview showTopLine];
    [headerview showBottomLine];
    
    return headerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    
    return footerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IntegralRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntegralRecordTableViewCell"];
    if (!cell) {
        cell = [[IntegralRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntegralRecordTableViewCell"];
    }
    // Configure the cell...
    IntegralMonthRecordModel* monthModel = self.monthModels[indexPath.section];
    IntegralRecordModel* model = monthModel.userIntegerDetailsVOS[indexPath.row];
    
    [cell setIntegralRecordModel:model];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
#pragma mark - DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"img_blank_list"];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!self.monthModels || self.monthModels.count == 0) {
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
    if ([taskname isEqualToString:@"IntegralRecordsTask"])
    {
        if (!taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            return;
        }
        NSArray* monthModels = taskResult;
        NSDictionary* postParam = [TaskManager taskparamWithTaskId:taskId];
        NSNumber* indexNumber = [postParam valueForKey:@"pageIndex"];
        if (!indexNumber || indexNumber.integerValue == 0 || indexNumber.integerValue == 1) {
            [self integralRecords:monthModels];
        }
        else
        {
            [self moreIntegralRecords:monthModels];
        }
    }
}
@end
