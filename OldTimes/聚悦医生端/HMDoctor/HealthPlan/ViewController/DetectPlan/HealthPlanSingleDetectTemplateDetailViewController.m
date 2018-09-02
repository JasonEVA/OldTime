//
//  HealthPlanSingleDetectTemplateDetailViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/9/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSingleDetectTemplateDetailViewController.h"
#import "HealthDetectPlanDetailTableViewCell.h"

@interface HealthPlanSingleDetectTemplateDetailViewController ()
<TaskObserver, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) HealthPlanSingleDetectTemplateModel* templateModel;
@property (nonatomic, strong) HealthPlanSingleDetectSelectBlock selectBlock;

@property (nonatomic, strong) UIView* tablefooterView;
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) HealthPlanDetCriteriaModel* criteriaModel;
@end



@implementation HealthPlanSingleDetectTemplateDetailViewController

- (id) initWithTemplateModel:(HealthPlanSingleDetectTemplateModel*) templateModel
                 selectBlock:(HealthPlanSingleDetectSelectBlock) selectBlock
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _templateModel = templateModel;
        _selectBlock = selectBlock;
    }
    return self;
}

- (NSDictionary*) controllerParamDictionary
{
    NSMutableDictionary* paramDictionary = [NSMutableDictionary dictionary];
    if (self.templateModel && self.templateModel.id) {
        [paramDictionary setValue:self.templateModel.id forKey:@"tempId"];
    }
    return paramDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.templateModel.name;
    [self layoutElements];
    NSMutableDictionary* paramDictionary = [NSMutableDictionary dictionary];
    [paramDictionary setValue:self.templateModel.id forKey:@"singleTestTempId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthPlanSingleDetectModelTask" taskParam:paramDictionary TaskObserver:self];
}

- (void) layoutElements
{
    [self.tablefooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@65);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.tablefooterView.mas_top);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - settingAndGetting

- (UIView*) tablefooterView
{
    if (!_tablefooterView) {
        _tablefooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 65)];
        [self.view addSubview:_tablefooterView];
        [_tablefooterView setBackgroundColor:[UIColor whiteColor]];
        [_tablefooterView showTopLine];
        
        UIButton* confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tablefooterView addSubview:confirmButton];
        
        [confirmButton setTitle:@"使用此模版" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [confirmButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 49) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        
        confirmButton.layer.cornerRadius = 4;
        confirmButton.layer.masksToBounds = YES;
        
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_tablefooterView).insets(UIEdgeInsetsMake(10, 12.5, 10, 12.5));
        }];
        [confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tablefooterView;
}

- (UITableView*) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [self.view addSubview:_tableView];
//        [_tableView setTableFooterView:self.tablefooterView];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
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
    if (taskname && [taskname isEqualToString:@"HealthPlanSingleDetectModelTask"]) {
        if (taskResult && [taskResult isKindOfClass:[HealthPlanDetCriteriaModel class]]) {
            _criteriaModel = taskResult;
            [self.tableView reloadData];
        }
    }
}

- (void) confirmButtonClicked:(id) sender
{
    if (self.criteriaModel && self.selectBlock) {
        self.selectBlock(self.criteriaModel);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger warningsCount = 0;
    if (self.criteriaModel && self.criteriaModel.warnings) {
        warningsCount = self.criteriaModel.warnings.count;
    }
    
    return 2 + warningsCount;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthDetectPlanDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HealthDetectPlanDetailTableViewCell"];
    if (!cell) {
        cell = [[HealthDetectPlanDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthDetectPlanDetailTableViewCell"];
    }
    [cell.contentView setHidden:NO];
    if (indexPath.row == HealthDetectPlan_TargetIndex) {
        NSArray* targetKpiList = [[HealthPlanUtil shareInstance] targetKpiList:self.criteriaModel.kpiCode];
        if (!targetKpiList || targetKpiList.count == 0) {
            //不可设置目标值
            [cell.contentView setHidden:YES];
        }
        [cell setName:@"目标:" value:[self.criteriaModel detectTargetString]];
    }
    else if (indexPath.row == HealthDetectPlan_PeriodIndex) {
        [cell setName:@"测量:" value:[self.criteriaModel detectAlertTimesString]];
    }
    else if (indexPath.row < 2 + self.criteriaModel.warnings.count)
    {
        HealthDetectPlanWarningModel* warningModel = self.criteriaModel.warnings[indexPath.row - 2];
        [cell setName:@"预警:" value:[warningModel warningString]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - UITableViewDelegate


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == HealthDetectPlan_TargetIndex) {
        NSArray* targetKpiList = [[HealthPlanUtil shareInstance] targetKpiList:self.criteriaModel.kpiCode];
        if (!targetKpiList || targetKpiList.count == 0) {
            //不可设置目标值
            return 0;
        }
        
    }

    return 50;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == HealthDetectPlan_TargetIndex) {
        //监测目标修改
        NSArray* targetKpiList = [[HealthPlanUtil shareInstance] targetKpiList:self.criteriaModel.kpiCode];
        if (!targetKpiList || targetKpiList.count == 0) {
            //不可设置目标值
            return ;
        }
        //判断是否可以添加预警
        [self startEditTargets];
        
    }
    
    if (indexPath.row == HealthDetectPlan_PeriodIndex) {
        //监测频率、监测时间界面
        __weak typeof(self) weakSelf = self;
        [HealthPlanViewControllerManager createHelathPlanDetectPeriodViewController:self.criteriaModel alertTimeBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.tableView reloadData];
        }];
    }
    
    if (indexPath.row > HealthDetectPlan_PeriodIndex && indexPath.row < 2 + self.criteriaModel.warnings.count)
    {
        //监测预警修改
        HealthDetectPlanWarningModel* model = self.criteriaModel.warnings[indexPath.row - 2];
        [HealthPlanViewControllerManager createHealthPlanDetectWarningEditViewController:model kpiTitle:self.criteriaModel.kpiTitle kpiCode:self.criteriaModel.kpiCode editHandle:^(HealthDetectPlanWarningModel *model) {
            NSMutableArray* warnings = [NSMutableArray arrayWithArray:self.criteriaModel.warnings];
            [warnings replaceObjectAtIndex:indexPath.row - 2 withObject:model];
            self.criteriaModel.warnings = warnings;
            [self.tableView reloadData];
            
        }];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    HealthPlanDetCriteriaModel* criteriaModel = self..criterias[indexPath.section];
    if (indexPath.row >= 2 && indexPath.row < (self.criteriaModel.warnings.count + 2)) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray* warnings = [NSMutableArray arrayWithArray:self.criteriaModel.warnings];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [warnings removeObjectAtIndex:indexPath.row - 2];
        self.criteriaModel.warnings = warnings;
        
    }
    [self.tableView reloadData];
    
}

- (void) startEditTargets
{
    HealthPlanDetCriteriaModel* criteriaModel = self.criteriaModel;
    NSArray* alltargetList = [[HealthPlanUtil shareInstance] targetKpiList:criteriaModel.kpiCode];
    if (!alltargetList || alltargetList.count == 0) {
        //不可编辑监测目标
        return;
    }
    
    //补全目标
    NSMutableArray* allEditTargets = [NSMutableArray arrayWithArray:alltargetList];
    NSArray* targets = criteriaModel.testTargets;
    __block NSString* unitString = [self detectUnitWithKpiCode:criteriaModel.kpiCode];
    [allEditTargets enumerateObjectsUsingBlock:^(HealthDetectPlanTargetModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.unit = unitString;
        [targets enumerateObjectsUsingBlock:^(HealthDetectPlanTargetModel* existedmodel, NSUInteger index, BOOL * _Nonnull existedstop) {
            if ([model.subKpiCode isEqualToString:existedmodel.subKpiCode])
            {
                [allEditTargets replaceObjectAtIndex:idx withObject:existedmodel];
                *existedstop = YES;
            }
        }];
    }];
    
    //跳转到监测目标编辑界面
    __weak typeof(self) weakSelf = self;
    [HealthPlanViewControllerManager createHealthPlanDetectTargetsViewController:criteriaModel.kpiTitle kpiCode:criteriaModel.kpiCode targets:allEditTargets targetBlock:^(NSArray *editedTargets) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf detectTargetsEdited:editedTargets];
        
        [HealthPlanUtil postEditNotification];
    }];
}

//监测目标值完成编辑
- (void) detectTargetsEdited:(NSArray*) targets
{
    
    HealthPlanDetCriteriaModel* criteriaModel = self.criteriaModel;
    criteriaModel.testTargets = targets;
    
    [self.tableView reloadData];
}

- (NSString*) detectUnitWithKpiCode:(NSString*) kpiCode
{
    NSString* unit = @"";
    if (!kpiCode && kpiCode.length == 0) {
        return unit;
    }
    
    if ([kpiCode isEqualToString:@"XY"])
    {
        unit = @"mmHg";
    }
    else if ([kpiCode isEqualToString:@"HX"])
    {
        unit = @"次/分钟";
    }
    else if ([kpiCode isEqualToString:@"XL"])
    {
        unit = @"次/分";
    }
    else if ([kpiCode isEqualToString:@"TZ"])
    {
        unit = @"kg";
    }
    else if ([kpiCode isEqualToString:@"XT"])
    {
        unit = @"mmol/l";
    }
    else if ([kpiCode isEqualToString:@"NL"])
    {
        unit = @"ml";
    }
    else if ([kpiCode isEqualToString:@"OXY"])
    {
        unit = @"%";
    }
    else if ([kpiCode isEqualToString:@"TEM"])
    {
        unit = @"℃";
    }
    else if ([kpiCode isEqualToString:@"FLSZ"])
    {
        unit = @"升/分";
    }
    return unit;
}
@end
