//
//  HealthEducationListTableViewController.m
//  HMClient
//
//  Created by yinquan on 16/12/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthEducationListTableViewController.h"
#import "HealthEducationTableViewCell.h"
#import "InitializationHelper.h"

#define kHealthEducationListPageSize    20

@interface HealthEducationListTableViewController ()
<TaskObserver,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSInteger totalCount;
}

@property (nonatomic, readonly) NSMutableArray* educationNotes;
@end

@implementation HealthEducationListTableViewController

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
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHealthEducationList)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadHealthEducationList];
}

- (void) setColumeId:(NSInteger)columeId
{
    _columeId = columeId;
    if (_educationNotes) {
        [_educationNotes removeAllObjects];
        [self.tableView reloadData];
    }
    
    [self loadHealthEducationList];
}

- (void) loadHealthEducationList
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    NSInteger rows = kHealthEducationListPageSize;
    if (self.educationNotes && self.educationNotes.count > 0)
    {
        rows = self.educationNotes.count;
    }
    
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", self.columeId] forKey:@"classProgramTypeId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthEducationListTask" taskParam:dicPost TaskObserver:self];
}

- (void) educationNotesLoaded:(NSArray*) models
{
    if (![self userHasService] && self.columeId < 0) {
        [self showNoneServiceView];
        return;
    }
    
    _educationNotes = [NSMutableArray arrayWithArray:models];
    [self.tableView reloadData];
}

- (BOOL) userHasService
{
    InitializationHelper* helper = [InitializationHelper defaultHelper];
    if (helper.userHasService) {
        return YES;
    }
    return NO;
}

- (void) showNoneServiceView
{
    UIView* emptyView = [[UIView alloc] init];
    [emptyView setBackgroundColor:[UIColor commonBackgroundColor]];
    
    UIImageView* emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_none_service"]];
    [emptyView addSubview:emptyImageView];
    [emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(emptyView);
        make.size.mas_equalTo(CGSizeMake(40, 36));
        make.top.equalTo(emptyView);
    }];
    
    UILabel* emptyLable = [[UILabel alloc] init];
    [emptyView addSubview:emptyLable];
    [emptyLable setText:@"您当前没有订购相关服务哦"];
    [emptyLable setFont:[UIFont systemFontOfSize:15]];
    [emptyLable setTextColor:[UIColor commonGrayTextColor]];
    [emptyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(emptyView);
        make.top.equalTo(emptyImageView.mas_bottom).with.offset(15);
        make.width.equalTo(emptyView);
    }];
    
    UIButton* emptyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [emptyView addSubview:emptyButton];
    [emptyButton setTitle:@"购买服务" forState:UIControlStateNormal];
    [emptyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [emptyButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [emptyButton setBackgroundImage:[UIImage rectImage:CGSizeMake(100, 30) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [emptyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(emptyView);
        make.size.mas_equalTo(CGSizeMake(102, 30));
        make.top.equalTo(emptyLable.mas_bottom).with.offset(15);
        make.bottom.equalTo(emptyView);
    }];
    
    emptyButton.layer.cornerRadius = 3;
    emptyButton.layer.masksToBounds = YES;
    
    [emptyButton addTarget:self action:@selector(loadOnlineCustomServiceList) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView);
        make.top.equalTo(self.tableView).with.offset(109);
    }];
    [self.tableView setScrollEnabled:NO];
}

- (void)loadOnlineCustomServiceList {
    
    [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceStartViewController" ControllerObject:nil];
}

- (void) loadMoreHealthEducationList
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:self.educationNotes.count] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kHealthEducationListPageSize] forKey:@"rows"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", self.columeId] forKey:@"classProgramTypeId"];
    
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    
    if ([self userHasService] && (!self.educationNotes || self.educationNotes.count == 0))
    {
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
