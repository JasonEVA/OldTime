//
//  HealthFillFormTemplateListViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/24.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthFillFormTemplateListViewController.h"
#import "HealthFillFormTemplateTableViewCell.h"
#import "SurveyRecord.h"


@interface HealthFillFormTemplateListViewController ()
<TaskObserver,
UITableViewDataSource,
UITableViewDelegate>
{
    NSArray* templateSections;
}
@property (nonatomic, strong) NSString* code;
@property (nonatomic, strong) UITableView* templatesTableView;
@property (nonatomic, strong) HealthPlanFillFormTemplateSelectHandle selectHandle;
@end

@implementation HealthFillFormTemplateListViewController

- (id) initWithCode:(NSString*) code handle:(HealthPlanFillFormTemplateSelectHandle) handle
{
    self = [super init];
    if (self) {
        _code = code;
        _selectHandle = handle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [NSString stringWithFormat:@"选择%@表", [self codeTitle]];
    
    UIBarButtonItem* closeBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_navi_close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeBarButtonClicked:)];
    [self.navigationItem setLeftBarButtonItem:closeBarButton];
    
    [self layoutElements];
    
    [self loadTemplateList];
}

- (void) layoutElements
{
    [self.templatesTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSString*) codeTitle
{
    NSString* codeTitle = @"";
    if ([self.code isEqualToString:@"survey"]) {
        codeTitle = @"随访";
    }
    if ([self.code isEqualToString:@"assessment"]) {
        codeTitle = @"评估";
    }
    if ([self.code isEqualToString:@"wards"]) {
        codeTitle = @"查房";
    }
    return codeTitle;
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

- (void) loadTemplateList
{
    //获取模板列表
    
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSInteger staffId = staff.staffId;
    NSMutableDictionary* paramDictionary = [NSMutableDictionary dictionary];
    [paramDictionary setValue:[NSString stringWithFormat:@"%ld", staffId] forKey:@"staffId"];
    [paramDictionary setValue:self.code forKey:@"typeCode"];
//    HealthPlanFillFormTemplateList
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanFillFormTemplateListTask" taskParam:paramDictionary TaskObserver:self];
}

- (void) previewButtonClicked:(id) sender
{
    if (![sender isKindOfClass:[UIButton class]])
    {
        return;
    }
    UIButton* previewButton = (UIButton*) sender;
    NSInteger tag = previewButton.tag;
    NSInteger section = tag / 0x1000;
    NSInteger row = tag % 0x1000;
    HealthPlanFillFormTemplateSection* group = templateSections[section];
    NSArray* moudles = group.child;
    HealthPlanFillFormTemplateModel* templateModel = moudles[row];
    SurveryMoudle* model = [[SurveryMoudle alloc] init];
    model.surveyMoudleName = templateModel.surveyMoudleName;
    model.surveyMoudleId = templateModel.surveyMoudleId;
    
    //跳转到随访／问诊模版详情 SurveyMoudleDetailViewController
    [HMViewControllerManager createViewControllerWithControllerName:@"SurveyMoudleDetailViewController" ControllerObject:model];
}


#pragma mark - UITableViewDataSource,

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (templateSections) {
        return templateSections.count;
    }
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HealthPlanFillFormTemplateSection* departmentModel = templateSections[section];
    if (departmentModel.child)
    {
        return departmentModel.child.count;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthFillFormTemplateTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HealthFillFormTemplateTableViewCell"];
    if (!cell) {
        cell = [[HealthFillFormTemplateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthFillFormTemplateTableViewCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    HealthPlanFillFormTemplateSection* departmentModel = templateSections[indexPath.section];
    HealthPlanFillFormTemplateModel* templateModel = departmentModel.child[indexPath.row];
    [cell setHealthPlanTemplateModel:templateModel];
    [cell.perviewButton setTag:(0x1000 * indexPath.section + indexPath.row)];
    [cell.perviewButton addTarget:self action:@selector(previewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthPlanFillFormTemplateSection* departmentModel = templateSections[indexPath.section];
    HealthPlanFillFormTemplateModel* templateModel = departmentModel.child[indexPath.row];
    
    if (self.selectHandle) {
        self.selectHandle(templateModel);
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    
    if ([taskname isEqualToString:@"HealthPlanFillFormTemplateListTask"])
    {
        [self.templatesTableView reloadData];
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
    
    if ([taskname isEqualToString:@"HealthPlanFillFormTemplateListTask"])
    {
        if ([taskResult isKindOfClass:[NSArray class]])
        {
            templateSections = taskResult;
        }
        
    }
}

#pragma mark - settingAndGetting
- (UITableView*) templatesTableView
{
    if (!_templatesTableView) {
        _templatesTableView = [[UITableView alloc] init];
        [self.view addSubview:_templatesTableView];
        [_templatesTableView setBackgroundColor:[UIColor whiteColor]];
        
        [_templatesTableView setDelegate:self];
        [_templatesTableView setDataSource:self];
    }
    return _templatesTableView;
}

@end
