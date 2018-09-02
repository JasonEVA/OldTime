//
//  HealthEducationCollectionStartViewController.m
//  HMClient
//
//  Created by yinquan on 16/12/14.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthEducationCollectionStartViewController.h"
#import "HealthEducationTableViewCell.h"

@interface HealthEducationCollectionTableViewController : UITableViewController
<TaskObserver,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSMutableArray* educationNotes;
}
@end

@interface HealthEducationCollectionStartViewController ()

{
    
}

@property (nonatomic, readonly) HealthEducationCollectionTableViewController* collectionTableViewController;

@end



@implementation HealthEducationCollectionStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"收藏夹"];
    
    _collectionTableViewController = [[HealthEducationCollectionTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [self addChildViewController:self.collectionTableViewController];
    [self.view addSubview:self.collectionTableViewController.tableView];
    [self.collectionTableViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

@implementation HealthEducationCollectionTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadEducationNotesList)];
    MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
    refHeader.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{

    [self loadEducationNotesList];
}

- (void) loadEducationNotesList
{
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthEducationCollectionListTask" taskParam:nil TaskObserver:self];
}

- (void) educationNotesLoaded:(NSArray*) models
{
    
    educationNotes = [NSMutableArray arrayWithArray:models];
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
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
    HealthEducationItem *collectModel = educationNotes[indexPath.row];
    
    [cell setHealthEducationItem:collectModel];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

//设置可以进行编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    return YES;
}

// 为兼容iOS 8上侧滑效果
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthEducationItem *collectModel = educationNotes[indexPath.row];
    
    UITableViewRowAction *removeRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:[NSString stringWithFormat:@"%ld",collectModel.classId] forKey:@"classId"];
        
        [[TaskManager shareInstance] createTaskWithTaskName:@"cancelCollectTask" taskParam:dicPost TaskObserver:self];
    }];
    
    //[removeRowAction setBackgroundColor:[UIColor mainThemeColor]];
    
    return @[removeRowAction];
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthEducationItem *collectModel = educationNotes[indexPath.row];

    //跳转到宣教详情
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationDetailViewController" ControllerObject:collectModel];
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
    [self.view closeWaitView];
    if (taskError != StepError_None)
    {
        [self showAlertMessage:errorMessage];
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
    
    if ([taskname isEqualToString:@"HealthEducationCollectionListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]]) {
            
            NSArray *collectArray = (NSArray *)taskResult;
            [self educationNotesLoaded:collectArray];
        }
    }
    
    if ([taskname isEqualToString:@"cancelCollectTask"]) {
        //刷新数据
        [self loadEducationNotesList];
    }
}

@end
