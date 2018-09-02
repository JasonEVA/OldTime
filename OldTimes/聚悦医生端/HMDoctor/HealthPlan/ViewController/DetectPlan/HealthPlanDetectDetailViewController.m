//
//  HealthPlanDetectDetailViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanDetectDetailViewController.h"
#import "HealthDetectPlanDetailTableViewCell.h"
#import "HealthDetectPlanEditFooterView.h"
#import "AppendDetectPickerViewController.h"



static NSInteger const kDeleteSectionBaseTag = 0x100;
static NSInteger const kAppendWarningBaseTag = 0x200;
static NSInteger const kAscendingBaseTag = 0x300;
static NSInteger const kDescendingBaseTag = 0x400;



@interface HealthPlanDetectDetailViewController ()
<UITableViewDelegate, UITableViewDataSource>
{
    NSIndexPath* editIndexPath;
}

@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) UITableView* planTableView;
@property (nonatomic, strong) HealthPlanDetailSectionModel* detailModel;

@end

@implementation HealthPlanDetectDetailViewController

//- (id) initWithDetailDictionary:(NSMutableDictionary*) detailDictionary
- (id) initWithDetailModel:(HealthPlanDetailSectionModel*) detailModel status:(NSString*) status
{
    self = [super init];
    if (self) {
        _detailModel = detailModel;
        _status = status;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"监测";
    
    [self layoutElements];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BOOL staffPrivilege = [HealthPlanUtil staffHasEditPrivilege:self.status];
    if (!staffPrivilege) {
        return;
    }
    
    UIBarButtonItem* appendButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(appendDetectButtonClicked:)];
    
    UINavigationItem* topNavigationItem = [HMViewControllerManager topMostController].navigationItem;
    [topNavigationItem setRightBarButtonItem:appendButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary*) controllerParamDictionary
{
    NSMutableDictionary* paramDictionary = [NSMutableDictionary dictionary];
    [paramDictionary setValue:self.detailModel.code forKey:@"code"];
    if (self.detailModel.planId) {
        [paramDictionary setValue:self.detailModel.planId forKey:@"planId"];
    }
    return nil;
}

- (void) layoutElements
{
    [self.planTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.detailModel && self.detailModel.criterias) {
        return self.detailModel.criterias.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HealthPlanDetCriteriaModel* criteriaModel = self.detailModel.criterias[section];
    NSInteger warningsCount = 0;
    if (criteriaModel.warnings) {
        warningsCount = criteriaModel.warnings.count;
    }
    
    return 2 + warningsCount;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HealthDetectPlanDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HealthDetectPlanDetailTableViewCell"];
    if (!cell) {
        cell = [[HealthDetectPlanDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthDetectPlanDetailTableViewCell"];
    }
     HealthPlanDetCriteriaModel* criteriaModel = self.detailModel.criterias[indexPath.section];
    [cell.contentView setHidden:NO];
    if (indexPath.row == HealthDetectPlan_TargetIndex) {
        [cell setName:@"目标:" value:[criteriaModel detectTargetString]];
        HealthPlanDetCriteriaModel* criteriaModel = self.detailModel.criterias[indexPath.section];
        NSArray* targetKpiList = [[HealthPlanUtil shareInstance] targetKpiList:criteriaModel.kpiCode];
        if (!targetKpiList || targetKpiList.count == 0) {
            //不可设置目标值
            [cell.contentView setHidden:YES];
        }
    }
    else if (indexPath.row == HealthDetectPlan_PeriodIndex) {
        [cell setName:@"测量:" value:[criteriaModel detectAlertTimesString]];
    }
    else if (indexPath.row < 2 + criteriaModel.warnings.count)
    {
        HealthDetectPlanWarningModel* warningModel = criteriaModel.warnings[indexPath.row - 2];
        [cell setName:@"预警:" value:[warningModel warningString]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self footerHeightInSection:section];
}

- (CGFloat) footerHeightInSection:(NSInteger) section
{
    CGFloat footerHeight = 5;
    BOOL privilege = [HealthPlanUtil staffHasEditPrivilege:self.status];
    if (privilege) {
        footerHeight += 40;
    }
    return footerHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == HealthDetectPlan_TargetIndex) {
        HealthPlanDetCriteriaModel* criteriaModel = self.detailModel.criterias[indexPath.section];
        NSArray* targetKpiList = [[HealthPlanUtil shareInstance] targetKpiList:criteriaModel.kpiCode];
        if (!targetKpiList || targetKpiList.count == 0) {
            //不可设置目标值
            return 0;
        }

    }
    return 50;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 38)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    [headerview showTopLine];
    [headerview showBottomLine];
    
    HealthPlanDetCriteriaModel* criteriaModel = self.detailModel.criterias[section];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    [headerview addSubview:titleLabel];
    [titleLabel setTextColor:[UIColor commonTextColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setText:criteriaModel.kpiTitle];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerview).offset(12.5);
        make.centerY.equalTo(headerview);
    }];
    
    UILabel* unitLabel = [[UILabel alloc] init];
    [headerview addSubview:unitLabel];
    [unitLabel setFont:[UIFont systemFontOfSize:13]];
    [unitLabel setTextColor:[UIColor commonGrayTextColor]];
    
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right);
        make.bottom.equalTo(titleLabel);
    }];
    NSString* unitString = [self detectUnitWithKpiCode:criteriaModel.kpiCode];
    if (unitString && unitString.length > 0) {
        [unitLabel setText:[NSString stringWithFormat:@"(%@)", [self detectUnitWithKpiCode:criteriaModel.kpiCode]]];
    }
    
    
    if ([HealthPlanUtil staffHasEditPrivilege:self.status]) {
        UIButton* templateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [headerview addSubview:templateButton];
        [templateButton setTitle:@"模版>" forState:UIControlStateNormal];
        [templateButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [templateButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [templateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerview);
            make.right.equalTo(headerview).offset(-12.5);
        }];
        [templateButton addTarget:self action:@selector(templateButtonClicked:) forControlEvents:UIControlEventTouchDown];
        
        [templateButton setTag:section + 0x1000];

    }
    
    
    return headerview;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [self footerHeightInSection:section])];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    BOOL privilege = [HealthPlanUtil staffHasEditPrivilege:self.status];
    
    if (privilege) {
        HealthDetectPlanEditFooterView* editFooter = [[HealthDetectPlanEditFooterView alloc] init];
        [footerview addSubview:editFooter];
        [editFooter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(footerview);
            make.height.mas_equalTo(@40);
        }];
        
        editFooter.deleteButton.tag = kDeleteSectionBaseTag + section;
        [editFooter.deleteButton addTarget:self action:@selector(deleteSectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //判断是否可以提娜家预警
        HealthPlanDetCriteriaModel* criteriaModel = self.detailModel.criterias[section];
        NSArray* targetKpiList = [[HealthPlanUtil shareInstance] targetKpiList:criteriaModel.kpiCode];
        if (!targetKpiList || targetKpiList.count == 0) {
            //不可设置目标值
            [editFooter.appendButton setEnabled:NO];
        }
        else
        {
            [editFooter.appendButton setEnabled:YES];
        }
        editFooter.appendButton.tag = kAppendWarningBaseTag + section;
        [editFooter.appendButton addTarget:self action:@selector(appendWarningButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        editFooter.ascendingButton.tag = kAscendingBaseTag + section;
        [editFooter.ascendingButton addTarget:self action:@selector(ascendingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        editFooter.descendingButton.tag = kDescendingBaseTag + section;
        [editFooter.descendingButton addTarget:self action:@selector(descendingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return footerview;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL staffPrivilege = [HealthPlanUtil staffHasEditPrivilege:self.status];
    if (!staffPrivilege)
    {
        //没有编辑权限，只能看看
        return;
    }
    HealthPlanDetCriteriaModel* criteriaModel = self.detailModel.criterias[indexPath.section];
    
    editIndexPath = indexPath;
    
    if (indexPath.row == HealthDetectPlan_TargetIndex) {
        //监测目标修改
        //判断是否可以添加预警
        [self startEditTargets:indexPath];
    }
    
    if (indexPath.row == HealthDetectPlan_PeriodIndex) {
        //监测频率、监测时间界面
        __weak typeof(self) weakSelf = self;
        [HealthPlanViewControllerManager createHelathPlanDetectPeriodViewController:criteriaModel alertTimeBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.planTableView reloadData];
            [HealthPlanUtil postEditNotification];
        }];
    }
    
    if (indexPath.row > HealthDetectPlan_PeriodIndex && indexPath.row < 2 + criteriaModel.warnings.count)
    {
        //监测预警修改
        HealthDetectPlanWarningModel* model = criteriaModel.warnings[indexPath.row - 2];
        [HealthPlanViewControllerManager createHealthPlanDetectWarningEditViewController:model kpiTitle:criteriaModel.kpiTitle kpiCode:criteriaModel.kpiCode editHandle:^(HealthDetectPlanWarningModel *model) {
            NSMutableArray* warnings = [NSMutableArray arrayWithArray:criteriaModel.warnings];
            [warnings replaceObjectAtIndex:editIndexPath.row - 2 withObject:model];
            criteriaModel.warnings = warnings;
            [self.planTableView reloadData];
            [HealthPlanUtil postEditNotification];
        }];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL staffPrivilege = [HealthPlanUtil staffHasEditPrivilege:self.status];
    if (!staffPrivilege) {
        return NO;
    }
    
    HealthPlanDetCriteriaModel* criteriaModel = self.detailModel.criterias[indexPath.section];
    if (indexPath.row >= 2 && indexPath.row < (criteriaModel.warnings.count + 2)) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    HealthPlanDetCriteriaModel* criteriaModel = self.detailModel.criterias[indexPath.section];
    NSMutableArray* warnings = [NSMutableArray arrayWithArray:criteriaModel.warnings];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [warnings removeObjectAtIndex:indexPath.row - 2];
        criteriaModel.warnings = warnings;
        
    }
    [self.planTableView reloadData];
    
}

#pragma mark - control click event
//模版选择
- (void) templateButtonClicked:(id) sender
{
    if (![sender isKindOfClass: [UIButton class]])
    {
        return;
    }
    UIButton* templateButton = (UIButton*) sender;
    NSInteger section = templateButton.tag - 0x1000;
    editIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    HealthPlanDetCriteriaModel* criteria = self.detailModel.criterias[section];
    __weak typeof(self) weakSelf = self;
    //跳转到选择模版界面
    [HealthPlanViewControllerManager createHealthPlanSingleDetectTemplateViewController:criteria.kpiCode selectBlock:^(HealthPlanDetCriteriaModel *model) {
        if (!weakSelf) {
            return ;
        }
        __strong typeof(self) strongSelf = weakSelf;
        NSMutableArray* criterias = [NSMutableArray arrayWithArray:strongSelf.detailModel.criterias];
        [criterias replaceObjectAtIndex:editIndexPath.section withObject:model];
        strongSelf.detailModel.criterias = criterias;
        [strongSelf.planTableView reloadData];
    }];
}

//删除
- (void) deleteSectionButtonClicked:(id) sender
{
    if (![sender isKindOfClass: [UIButton class]])
    {
        return;
    }
    UIButton* button = (UIButton*) sender;
    NSInteger section = button.tag - kDeleteSectionBaseTag;
    NSMutableArray* criterias = [NSMutableArray arrayWithArray:self.detailModel.criterias];
    if (criterias.count <= 1) {
        return;
    }
    [criterias removeObjectAtIndex:section];
    //排序sortIndex
    [criterias enumerateObjectsUsingBlock:^(HealthPlanDetCriteriaModel* criteriaModel , NSUInteger idx, BOOL * _Nonnull stop) {
        criteriaModel.sortIndex = [NSString stringWithFormat:@"%ld", idx + 1];
    }];

    self.detailModel.criterias = criterias;
    [self.planTableView reloadData];
    
    [HealthPlanUtil postEditNotification];
}

//添加预警
- (void) appendWarningButtonClicked:(id) sender
{
    if (![sender isKindOfClass: [UIButton class]])
    {
        return;
    }
    
    
    UIButton* button = (UIButton*) sender;
    NSInteger section = button.tag - kAppendWarningBaseTag;
    __block HealthPlanDetCriteriaModel* criteriaModel = self.detailModel.criterias[section];
    editIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    //判断是否可以添加预警
    NSArray* warningKpiList = [[HealthPlanUtil shareInstance] warningKpiList:criteriaModel.kpiCode];
    if (!warningKpiList || warningKpiList.count == 0) {
        //不可添加监测预警
        return;
    }
    
    [self appendDetectWarning:criteriaModel];
}

- (void) appendDetectWarning:(HealthPlanDetCriteriaModel*) criteriaModel
{
    HealthDetectPlanWarningModel* newmodel = [[HealthDetectPlanWarningModel alloc] init];
    
    [HealthPlanViewControllerManager createHealthPlanDetectWarningEditViewController:newmodel kpiTitle:criteriaModel.kpiTitle kpiCode:criteriaModel.kpiCode editHandle:^(HealthDetectPlanWarningModel *model) {
        model.alertGrade = 3;
        NSMutableArray* warnings = [NSMutableArray arrayWithArray:criteriaModel.warnings];
        [warnings addObject:model];
        criteriaModel.warnings = warnings;
        
        [self.planTableView reloadData];
        [HealthPlanUtil postEditNotification];
    }];
}

//升序
- (void) ascendingButtonClicked:(id) sender
{
    if (![sender isKindOfClass: [UIButton class]])
    {
        return;
    }
    UIButton* button = (UIButton*) sender;
    NSInteger section = button.tag - kAscendingBaseTag;
    if (section == 0) {
        return;
    }
    
    NSMutableArray* criterias = [NSMutableArray arrayWithArray:self.detailModel.criterias];
    id criteria = criterias[section];
    [criterias removeObjectAtIndex:section];
    [criterias insertObject:criteria atIndex:section - 1];
    self.detailModel.criterias = criterias;
    //排序sortIndex
    [criterias enumerateObjectsUsingBlock:^(HealthPlanDetCriteriaModel* criteriaModel , NSUInteger idx, BOOL * _Nonnull stop) {
        criteriaModel.sortIndex = [NSString stringWithFormat:@"%ld", idx + 1];
    }];
    
    [self.planTableView reloadData];
    [HealthPlanUtil postEditNotification];
}

//升序
- (void) descendingButtonClicked:(id) sender
{
    if (![sender isKindOfClass: [UIButton class]])
    {
        return;
    }
    UIButton* button = (UIButton*) sender;
    NSInteger section = button.tag - kDescendingBaseTag;
    if (section == self.detailModel.criterias.count - 1) {
        return;
    }
    
    NSMutableArray* criterias = [NSMutableArray arrayWithArray:self.detailModel.criterias];
    id criteria = criterias[section];
    [criterias removeObjectAtIndex:section];
    [criterias insertObject:criteria atIndex:section + 1];
    //排序sortIndex
    [criterias enumerateObjectsUsingBlock:^(HealthPlanDetCriteriaModel* criteriaModel , NSUInteger idx, BOOL * _Nonnull stop) {
        criteriaModel.sortIndex = [NSString stringWithFormat:@"%ld", idx + 1];
    }];
    
    self.detailModel.criterias = criterias;
    [self.planTableView reloadData];
    [HealthPlanUtil postEditNotification];
}

//添加监测项目
- (void) appendDetectButtonClicked:(id) sender
{
    __block NSMutableArray* existedKpiList = [NSMutableArray array];
    [self.detailModel.criterias enumerateObjectsUsingBlock:^(HealthPlanDetCriteriaModel* criteriaModel, NSUInteger idx, BOOL * _Nonnull stop) {
        DetectKPIModel* kpiModel = [[DetectKPIModel alloc] init];
        kpiModel.kpiCode = criteriaModel.kpiCode;
        kpiModel.kpiName = criteriaModel.kpiTitle;
        [existedKpiList addObject:kpiModel];
    }];
    
    __weak typeof(self) weakself = self;
    [AppendDetectPickerViewController showWithExistKpiList:existedKpiList handle:^(DetectKPIModel *model) {
        //添加监测项目，选择模版
        [HealthPlanViewControllerManager createHealthPlanSingleDetectTemplateViewController:model.kpiCode selectBlock:^(HealthPlanDetCriteriaModel *model) {
            
            __strong typeof(self) strongSelf = weakself;
            NSMutableArray* criterias = [NSMutableArray arrayWithArray:strongSelf.detailModel.criterias];
            [criterias addObject:model];
            //排序sortIndex
            [criterias enumerateObjectsUsingBlock:^(HealthPlanDetCriteriaModel* criteriaModel , NSUInteger idx, BOOL * _Nonnull stop) {
                criteriaModel.sortIndex = [NSString stringWithFormat:@"%ld", idx + 1];
            }];
            strongSelf.detailModel.criterias = criterias;
            [strongSelf.planTableView reloadData];
        }];
        
        
    }];
}

- (void) startEditTargets:(NSIndexPath*) indexPath
{
    HealthPlanDetCriteriaModel* criteriaModel = self.detailModel.criterias[indexPath.section];
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
    if (!editIndexPath) {
        return;
    }
    
    HealthPlanDetCriteriaModel* criteriaModel = self.detailModel.criterias[editIndexPath.section];
    criteriaModel.testTargets = targets;
    
    [self.planTableView reloadData];
}


#pragma mark - settingAndGetting
- (UITableView*) planTableView
{
    if (!_planTableView) {
        _planTableView = [[UITableView alloc] init];
        [self.view addSubview:_planTableView];
        
        [self.planTableView setDataSource:self];
        [self.planTableView setDelegate:self];
    }
    return _planTableView;
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
