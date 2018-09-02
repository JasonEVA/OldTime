//
//  HealthEducationFineViewController.m
//  HMDoctor
//
//  Created by yinquan on 17/1/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//  健康课堂－精品课堂界面

#import "HealthEducationFineViewController.h"
#import "HealthEducationTableViewCell.h"

#define kHealthEducationFineListPageSize      20

@interface HealthEducationFineTableViewController : UITableViewController
<TaskObserver, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSMutableArray* educationNotes;
    NSInteger totalCount;
}
@end

@interface HealthEducationFineViewController ()

@property (nonatomic, readonly) HealthEducationFineTableViewController* fineTableViewController;
@end

@implementation HealthEducationFineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"精品课堂"];
    
    
    _fineTableViewController = [[HealthEducationFineTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:self.fineTableViewController];
    [self.view addSubview:self.fineTableViewController.tableView];
    [self.fineTableViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


@implementation HealthEducationFineTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    //    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadEducationNotesList)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

- (void) loadEducationNotesList
{

    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:0] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kHealthEducationFineListPageSize] forKey:@"rows"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthEducationFineListTask" taskParam:dicPost TaskObserver:self];
}

- (void) educationNotesLoaded:(NSArray*) models
{
    educationNotes = [NSMutableArray arrayWithArray:models];
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

- (void) loadMoreHealthEducationList
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:educationNotes.count] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:kHealthEducationFineListPageSize] forKey:@"rows"];
    
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthEducationFineListTask" taskParam:dicPost TaskObserver:self];
}

- (void) moreEducationNotesLoaded:(NSArray*) models
{
    if (!educationNotes)
    {
        educationNotes = [NSMutableArray arrayWithArray:models];
    }
    else
    {
        for (HealthEducationItem* model in models) {
            if ([self educationNotesIsExisted:model])
            {
                continue;
            }
            [educationNotes addObject:model];
        }
    }
    [self.tableView reloadData];
}

- (BOOL) educationNotesIsExisted:(HealthEducationItem*) model
{
    BOOL isExisted = NO;
    for (HealthEducationItem* note in educationNotes)
    {
        if (note.notesId == model.notesId)
        {
            return YES;
        }
    }
    
    return isExisted;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (educationNotes) {
        return educationNotes.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
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
    HealthEducationItem* educationModel = educationNotes[indexPath.row];
    
    [cell setHealthEducationItem:educationModel];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthEducationItem* educationModel = educationNotes[indexPath.row];
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
    
    if (!educationNotes || educationNotes.count == 0) {
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
    
    if (totalCount >= educationNotes.count)
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
    
    if ([taskname isEqualToString:@"HealthEducationFineListTask"])
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
