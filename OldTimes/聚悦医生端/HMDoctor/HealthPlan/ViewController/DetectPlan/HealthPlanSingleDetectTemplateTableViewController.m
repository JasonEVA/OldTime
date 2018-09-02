//
//  HealthPlanSingleDetectTemplateTableViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/9/12.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSingleDetectTemplateTableViewController.h"

@interface HealthPlanSingleDetectTemplateTableViewController ()
<TaskObserver>
{
    NSArray* templateSections;
}

@property (nonatomic, retain) NSString* kpiCode;
@property (nonatomic, strong) HealthPlanSingleDetectSelectBlock selectBlock;
@end

@implementation HealthPlanSingleDetectTemplateTableViewController

- (id) initWithKpiCode:(NSString*) kpiCode
           selectBlock:(HealthPlanSingleDetectSelectBlock) selectBlock
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _kpiCode = kpiCode;
        _selectBlock = selectBlock;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"请选择模板";
    
    UIBarButtonItem* closeBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_navi_close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeBarButtonClicked:)];
    [self.navigationItem setLeftBarButtonItem:closeBarButton];

    
    [self loadSingleDetectTemplates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) closeBarButtonClicked:(id) sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void) loadSingleDetectTemplates
{
    //HealthPlanSingleDetectTemplatesTask
    NSMutableDictionary* paramDictionary = [NSMutableDictionary dictionary];
    [paramDictionary setValue:self.kpiCode forKey:@"kpiCode"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanSingleDetectTemplatesTask" taskParam:paramDictionary TaskObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (templateSections) {
        return templateSections.count;
    }
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HealthPlanSingleDetectSectionModel* departmentModel = templateSections[section];
    if (departmentModel.child)
    {
        return departmentModel.child.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthPlanSingleDetectTemplateTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthPlanSingleDetectTemplateTableViewController"];
    }
    // Configure the cell...
    HealthPlanSingleDetectSectionModel* departmentModel = templateSections[indexPath.section];
    HealthPlanSingleDetectTemplateModel* model = departmentModel.child[indexPath.row];
    [cell.textLabel setText:model.name];
    [cell.textLabel setTextColor:[UIColor commonTextColor]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 39;
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
    
    HealthPlanSingleDetectSectionModel* deparmmentTemplateModel = templateSections[section];
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthPlanSingleDetectSectionModel* departmentModel = templateSections[indexPath.section];
    HealthPlanSingleDetectTemplateModel* model = departmentModel.child[indexPath.row];
    
    [HealthPlanViewControllerManager createHealthPlanSingleTemplateDetailViewController:model selectBlock:self.selectBlock];
    
    return;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
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
    if ([taskname isEqualToString:@"HealthPlanSingleDetectTemplatesTask"])
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
    if ([taskname isEqualToString:@"HealthPlanSingleDetectTemplatesTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            templateSections = taskResult;
        }
    }
    
}

@end
