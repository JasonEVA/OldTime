//
//  HealthPlanTemplateSelectViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanTemplateSelectViewController.h"


@interface HealthPlanTemplateSelectViewController ()
<TaskObserver, UITableViewDelegate, UITableViewDataSource>
{
    NSArray* templateSections;
}
@property (nonatomic, strong) NSString* typeCode;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) HealthPlanTemplateSelectedBlock selectedBlock;

@end

@implementation HealthPlanTemplateSelectViewController

- (id) initWithTypeCode:(NSString*) typeCode selectedBlock:(HealthPlanTemplateSelectedBlock) selectedBlock
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _typeCode = typeCode;
        _selectedBlock = selectedBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"请选择计划模板"];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backEvent)];
    [self.navigationItem setLeftBarButtonItem:left];
    [self layoutElements];
    
    [self loadHealthPlanTemplateList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary*) controllerParamDictionary
{
    NSMutableDictionary* paramDictionary = [NSMutableDictionary dictionary];
    if (self.typeCode) {
        [paramDictionary setValue:self.typeCode forKey:@"typeCode"];
    }
    
    return nil;
}

- (void) backEvent
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) layoutElements
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void) loadHealthPlanTemplateList
{
    //获取模版列表
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSInteger staffId = staff.staffId;
    NSMutableDictionary* paramDictionary = [NSMutableDictionary dictionary];
    [paramDictionary setValue:[NSString stringWithFormat:@"%ld", staffId] forKey:@"staffId"];
    if (self.typeCode) {
        [paramDictionary setValue:self.typeCode forKey:@"typeCode"];
    }
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanTemplateListTask" taskParam:paramDictionary TaskObserver:self];
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return templateSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HealthPlanDepartmentTemplateModel* deparmmentTemplateModel = templateSections[section];
    if (deparmmentTemplateModel.child) {
        return deparmmentTemplateModel.child.count;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HealthPlanTemplateSelectTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthPlanTemplateSelectTableViewCell"];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    HealthPlanDepartmentTemplateModel* deparmmentTemplateModel = templateSections[indexPath.section];
    HealthPlanTemplateModel* templateModel = deparmmentTemplateModel.child[indexPath.row];
    
    [cell.textLabel setText:templateModel.name];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.textLabel setTextColor:[UIColor commonTextColor]];
    
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
    
    HealthPlanDepartmentTemplateModel* deparmmentTemplateModel = templateSections[section];
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

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 39;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthPlanDepartmentTemplateModel* deparmmentTemplateModel = templateSections[indexPath.section];
    HealthPlanTemplateModel* templateModel = deparmmentTemplateModel.child[indexPath.row];
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.selectedBlock) {
            self.selectedBlock(templateModel);
        }
    }];
    
    
    
}

#pragma mark - settingAndGetting
- (UITableView*) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [self.view addSubview:_tableView];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
    }
    return _tableView;
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
    if ([taskname isEqualToString:@"HealthPlanTemplateListTask"])
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
    if ([taskname isEqualToString:@"HealthPlanTemplateListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            templateSections = taskResult;
        }
    }
}
@end
