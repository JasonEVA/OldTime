//
//  HealthPlanReviewIndicesTableViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/30.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanReviewIndicesTableViewController.h"

@interface HealthPlanReviewIndicesTableViewController ()
<TaskObserver>
{
    NSArray* indicesSections;
}
@property (nonatomic, strong) HealthPlanReviewIndicesHandle selectHandle;

@end

@implementation HealthPlanReviewIndicesTableViewController

- (id) initWithHandle:(HealthPlanReviewIndicesHandle) handle
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _selectHandle = handle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择复查项目";
    
    UIBarButtonItem* closeBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_navi_close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeBarButtonClicked:)];
    [self.navigationItem setLeftBarButtonItem:closeBarButton];
    
    [self loadReviewIndices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadReviewIndices
{
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanReviewIndicesListTask" taskParam:nil TaskObserver:self];
}

- (void) closeBarButtonClicked:(id) sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (indicesSections) {
        return indicesSections.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HealthPlanFillFormTemplateSection* departmentModel = indicesSections[section];
    if (departmentModel.child)
    {
        return departmentModel.child.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthPlanReviewIndicesTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthPlanReviewIndicesTableViewCell"];
    }
    
    // Configure the cell...
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    HealthPlaneviewIndicesSection* departmentModel = indicesSections[indexPath.section];
    HealthPlanReviewIndicesModel* indicesModel = departmentModel.child[indexPath.row];
    
    [cell.textLabel setText:indicesModel.name];
    
    return cell;
}

#pragma mark - table view delegate

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 39;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 39)];
    [headerview setBackgroundColor:[UIColor commonBackgroundColor]];
    [headerview showBottomLine];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    [headerview addSubview:titleLabel];
    [titleLabel setTextColor:[UIColor mainThemeColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerview).offset(12.5);
        make.centerY.equalTo(headerview);
    }];
    
    HealthPlaneviewIndicesSection* deparmmentTemplateModel = indicesSections[section];
    [titleLabel setText:deparmmentTemplateModel.standardName];
    
    UIImageView* arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_down_list_arrow"]];
    [headerview addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerview);
        make.right.equalTo(headerview).offset(-12.5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    return headerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthPlaneviewIndicesSection* departmentModel = indicesSections[indexPath.section];
    HealthPlanReviewIndicesModel* indicesModel = departmentModel.child[indexPath.row];
    
    if (self.selectHandle) {
        self.selectHandle(indicesModel);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (taskError != StepError_None) {
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
    
    if ([taskname isEqualToString:@"HealthPlanReviewIndicesListTask"])
    {
        [self.tableView reloadData];
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
    
    if ([taskname isEqualToString:@"HealthPlanReviewIndicesListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            indicesSections = taskResult;
        }
    }
}
@end
