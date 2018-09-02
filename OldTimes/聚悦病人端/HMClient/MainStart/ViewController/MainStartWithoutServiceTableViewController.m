//
//  MainStartWithoutServiceTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MainStartWithoutServiceTableViewController.h"
#import "MainStartNewTargetTableViewCell.h"
#import "MainStartDetectTableViewCell.h"
#import "MainStartServiceTableViewCell.h"

#import "MainStartAdvertiseListViewController.h"
#import "MainStartAdvertiseTableViewCell.h"

#import "HMClientGroupChatModel.h"
#import "HMSessionListInteractor.h"

#import "GetUserTestTargetByDashboardTask.h"
#import "MainStartHealthTargetModel.h"

#import "HMSwitchView.h"
#import "HealthyEducationColumeModel.h"


#import "MainStartEducationClassTableViewController.h"
#import "MainStartEdcuationClassTableViewCell.h"

typedef enum : NSUInteger {
    MainStart_AdvertiseSection,
    MainStart_TargetSection,
    MainStart_DetectSection,
    Mainstart_ServiceSection,
    MainStart_EducationSection,     //健康课堂
    MainStartSectionCount,
} MainStartSection;

@interface MainStartWithoutServiceTableViewController ()
<TaskObserver,UIAlertViewDelegate,MainStartServiceTableViewCellDelegate, HMSwitchViewDelegate>
{
    MainStartAdvertiseListViewController* vcAdvertise;
    
    NSArray* userTargets;
    UIScrollView* educationSwitchScrollView;
    HMSwitchView* educationSwitchView;
    
    UITabBarController* educationTabbarController;
    UIView* educationView;
}
@property (nonatomic) NSInteger teamStaffId;
@property (nonatomic, retain) NSNumber* numTeamId;
@property (nonatomic, readonly) NSString* teamName;
@property (nonatomic, retain) NSArray* staffs;

//健康宣教
@property (nonatomic, readonly) NSArray* educationColumes;
@property (nonatomic, readonly) NSMutableArray* educationTableControllers;

@end

@implementation MainStartWithoutServiceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.tableView setSeparatorColor:[UIColor commonBackgroundColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    educationSwitchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 47)];
//    [educationSwitchView setDelegate:self];
    educationTabbarController = [[UITabBarController alloc] init];
    [self createEducationClassView];
    
    [self loadHealthEducationColumeList];
}

- (void) createEducationClassView
{
    educationView = [[UIView alloc] init];
    UIView* headerView = [[UIView alloc] init];
    [educationView addSubview:headerView];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(educationView);
        make.height.mas_equalTo(@77);
    }];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    [headerView addSubview:educationSwitchView];
    [educationSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(headerView);
        make.bottom.equalTo(headerView);
        make.height.mas_equalTo(@47);
    }];
    
    UIView* titleView = [[UIView alloc] init];
    [headerView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(headerView);
        make.top.equalTo(headerView);
        make.height.mas_equalTo(@30);
    }];
    
    UILabel* titleLable = [[UILabel alloc] init];
    [titleView addSubview:titleLable];
    [titleLable setText:@"健康课堂"];
    [titleLable setTextColor:[UIColor commonTextColor]];
    [titleLable setFont:[UIFont font_30]];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView);
        make.left.equalTo(titleView).with.offset(12.5);
    }];
    
    UIButton* moreEducationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:moreEducationButton];
    [moreEducationButton setTitle:@"查看更多>" forState:UIControlStateNormal];
    [moreEducationButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [moreEducationButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [moreEducationButton addTarget:self action:@selector(moreEducationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [moreEducationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView);
        make.right.equalTo(titleView).with.offset(-12.5);
    }];
    
    [headerView addSubview: educationSwitchScrollView];
    [educationSwitchScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(headerView);
        make.top.equalTo(titleView.mas_bottom);
        make.bottom.equalTo(headerView);
    }];
    
    [educationView addSubview:educationTabbarController.view];
    [educationTabbarController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(educationView);
        make.top.equalTo(headerView.mas_bottom);
    }];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 获取健康目标数据2.3
    [[TaskManager shareInstance] createTaskWithTaskName:@"GetUserTestTargetByDashboardTask" taskParam:nil TaskObserver:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

//获取健康宣教栏目列表
- (void) loadHealthEducationColumeList
{
    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthEducationColumeTask" taskParam:nil TaskObserver:self];
    
}

- (void) educationColumesLoaded:(NSArray*) columes
{
    if (!columes || columes.count == 0) {
        return;
    }
    _educationColumes = columes;
    NSMutableArray* columeTitles = [NSMutableArray array];
    _educationTableControllers = [NSMutableArray array];
    [self.educationColumes enumerateObjectsUsingBlock:^(HealthyEducationColumeModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
        [columeTitles addObject:model.typeName];
        
        MainStartEducationClassTableViewController* tableViewController = [[MainStartEducationClassTableViewController alloc] initWithColumeId:model.classProgramTypeId];
        
        [self.educationTableControllers addObject:tableViewController];
    }];
    
    CGFloat educationSwitchWidth = kScreenWidth;
    if (columes.count > 4)
    {
        educationSwitchWidth = (kScreenWidth/4) * columes.count;
    }
    educationSwitchView = [[HMSwitchView alloc] initWithFrame:CGRectMake(0, 0, educationSwitchWidth, 47)];
    [educationSwitchScrollView addSubview:educationSwitchView];
    [educationSwitchView setDelegate:self];
    [educationSwitchScrollView setContentSize:CGSizeMake(educationSwitchWidth, 47)];
    
    [educationSwitchView createCells:columeTitles];
    [educationTabbarController setViewControllers:self.educationTableControllers];
}

- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSInteger) selectedIndex
{
    if (educationSwitchView == switchview)
    {
        [educationTabbarController setSelectedIndex:selectedIndex];
        
    }
}

- (void) moreEducationButtonClicked:(id) sender
{
    //跳转宣教列表
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationStartViewController" ControllerObject:nil];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return MainStartSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    switch (section)
    {
        case MainStart_EducationSection:
        {
            
            return 1;
        }
            break;
            
        default:
            break;
    }
    return 1;
}


- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 0.5)];
    [footerview setBackgroundColor:[UIColor clearColor]];
    
    return footerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case MainStart_AdvertiseSection:
        {
            return 200 * kScreenWidthScale;
        }
        case MainStart_TargetSection:
        {
            return 158 * kScreenWidthScale;
        }
            break;
        case MainStart_DetectSection:
        {
            return 108 * kScreenWidthScale;
        }
            break;
        case Mainstart_ServiceSection:
        {
            return 87 * kScreenWidthScale;
        }
            break;
        case MainStart_EducationSection:
        {
            return 130 * 3 + 77;
        }
            break;
        default:
            break;
    }
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case MainStart_AdvertiseSection:
        {
            cell = [self mainAdvertiseCell];
        }
            break;
        case MainStart_TargetSection:
        {
            cell = [self healthTargetCell];
        }
            break;
        case MainStart_DetectSection:
        {
            cell = [self heahthDetectCell];
        }
            break;
        case Mainstart_ServiceSection:
        {
            cell = [self mainServiceCell];
        }
            break;
        case MainStart_EducationSection:
        {
            cell = [self mainEdcuationClassCell];
        }
            break;
        default:
            break;
    }
    // Configure the cell...
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainStartWithoutServiceTableViewCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (UITableViewCell*) healthTargetCell
{
    MainStartNewTargetTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"MainStartTargetTableViewCell"];
    if (!cell)
    {
        cell = [[MainStartNewTargetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainStartTargetTableViewCell"];
    }
    [cell configTargetItems:userTargets];
    [cell addTargetValueClickedCompletion:^(MainStartHealthTargetModel *model) {
        [self targetValueDashboardClicked:model];
    }];

    return cell;
}

- (UITableViewCell*) heahthDetectCell
{
    MainStartDetectTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"MainStartDetectTableViewCell"];
    if (!cell)
    {
        cell = [[MainStartDetectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainStartDetectTableViewCell"];
    }
    return cell;
}

- (UITableViewCell*) mainServiceCell
{
    MainStartServiceTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"MainStartServiceTableViewCell"];
    if (!cell)
    {
        cell = [[MainStartServiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainStartServiceTableViewCell"];
        [cell setDelegate:self];
    }
    return cell;
}

- (UITableViewCell*) mainAdvertiseCell
{
    MainStartAdvertiseTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"MainStartAdvertiseTableViewCell"];
    if (!cell)
    {
        cell = [[MainStartAdvertiseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainStartAdvertiseTableViewCell"];
        if (!vcAdvertise)
        {
            vcAdvertise = [[MainStartAdvertiseListViewController alloc]initWithNibName:nil bundle:nil];
            [self addChildViewController:vcAdvertise];
            
        }
        [cell setAdvertiseView:vcAdvertise.view];
    }

    return cell;
}

- (UITableViewCell*) mainEdcuationClassCell
{
    MainStartEdcuationClassTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"MainStartEdcuationClassTableViewCell"];
    if (!cell)
    {
        cell = [[MainStartEdcuationClassTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainStartEdcuationClassTableViewCell"];
        [cell.contentView addSubview:educationView];
        [educationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(cell.contentView);
            make.top.and.bottom.equalTo(cell.contentView);
        }];
    }
    
    return cell;
}


#pragma mark - MainStartServiceTableViewCellDelegate

- (void)MainStartServiceTableViewCellDelegateCallBack_askDoctorClick {
    [[HMSessionListInteractor sharedInstance] goToSessionList];

}

#pragma mark - EventResponse

- (void)targetValueDashboardClicked:(MainStartHealthTargetModel *)model {
    NSString *kpiCode = model.rootKpiCode;
    NSString *controllerName = nil;
    if (!kpiCode || 0 == kpiCode.length) {
        return;
    }
    if ([kpiCode isEqualToString:@"XY"]) {
        //血压
        controllerName = @"BodyPressureDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－血压"];
    }
    else if ([kpiCode isEqualToString:@"TZ"]) {
        //体重
        controllerName = @"BodyWeightDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－体重"];
    }
    else if ([kpiCode isEqualToString:@"XT"]) {
        //血糖
        controllerName = @"BloodSugarDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－血糖"];
    }
    else if ([kpiCode isEqualToString:@"XL"]) {
        //心率
        controllerName = @"ECGDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－心率"];
    }
    else if ([kpiCode isEqualToString:@"XZ"]) {
        //血脂
        controllerName = @"BloodFatDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－血脂"];
    }
    else if ([kpiCode isEqualToString:@"OXY"]) {
        //血氧
        controllerName = @"BloodOxygenDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－血氧"];
    }
    else if ([kpiCode isEqualToString:@"NL"]) {
        //尿量
        controllerName = @"UrineVolumeDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－尿量"];
    }
    else if ([kpiCode isEqualToString:@"HX"]) {
        //呼吸
        controllerName = @"BreathingDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－呼吸"];
    }
    
    if (!controllerName || 0 == controllerName.length) {
        return;
    }
    
    [HMViewControllerManager createViewControllerWithControllerName:controllerName ControllerObject:nil];
}

#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError)
    {
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
    
    if ([taskname isEqualToString:@"GetUserTestTargetByDashboardTask"])
    {
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:MainStart_TargetSection];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"GetUserTestTargetByDashboardTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            userTargets = (NSArray*) taskResult;
        }
    }
   
    if ([taskname isEqualToString:@"HealthEducationColumeTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* columes = (NSArray*) taskResult;
            [self educationColumesLoaded:columes];
        }
    }
    
}
@end
