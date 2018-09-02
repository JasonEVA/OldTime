//
//  MainConsoleFunctionDisplayTableViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "MainConsoleFunctionDisplayTableViewController.h"
#import "MainConsoleUtil.h"
#import "MainConsoleFunctionView.h"

#import "ATModuleInteractor+CoordinationInteractor.h"
#import "ATModuleInteractor+PatientChat.h"
#import "HMNoticeWindowViewController.h"
#import "HMFastInGroupViewController.h"

@interface MainConsoleFunctionDisplayTableViewController ()
{
    MainConsoleFunctionView* selectedFunctionsView;
    MainConsoleFunctionView* unselectedFunctionsView;
    
    MainConsoleUtil* mainConsoleUtil;
}

@end

typedef NS_ENUM(NSUInteger, MainConsoleFunctionSection) {
    MainConsoleFunctionSelectedSection,
    MainConsoleFunctionUnSelectedSection,
    MainConsoleFunctionSectionCount,
};

@implementation MainConsoleFunctionDisplayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    mainConsoleUtil = [MainConsoleUtil shareInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return MainConsoleFunctionSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 46;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    UILabel* titleLable = [[UILabel alloc] init];
    [headerview addSubview:titleLable];
    [titleLable setFont:[UIFont systemFontOfSize:14]];
    [titleLable setTextColor:[UIColor commonTextColor]];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerview).with.offset(15);
        make.centerY.equalTo(headerview);
    }];
    
    switch (section) {
        case MainConsoleFunctionSelectedSection:
        {
            [titleLable setText:@"已有功能"];
        }
            break;
        case MainConsoleFunctionUnSelectedSection:
        {
            [titleLable setText:@"可选功能"];
        }
        default:
            break;
    }
    return headerview;
}

- (CGFloat) selectionFunctionViewHeight
{
    if (mainConsoleUtil.selectedFunctions) {
        NSInteger rows = mainConsoleUtil.selectedFunctions.count / 3;
        if ((mainConsoleUtil.selectedFunctions.count % 3) > 0) {
            ++rows;
        }
        return (kScreenWidth - 30)/3 * rows;
    }
    
    return 46;
}

- (CGFloat) unselectionFunctionViewHeight
{
    if (mainConsoleUtil.unSelectedFunctions) {
        NSInteger rows = mainConsoleUtil.unSelectedFunctions.count / 3;
        if ((mainConsoleUtil.unSelectedFunctions.count % 3) > 0) {
            ++rows;
        }
        return (kScreenWidth - 30)/3 * rows;
    }
    
    return 46;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case MainConsoleFunctionSelectedSection:
        {
            return [self selectionFunctionViewHeight];
            break;
        }
        case MainConsoleFunctionUnSelectedSection:
        {
            return [self unselectionFunctionViewHeight];
            break;
        }
        default:
            break;
    }
    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case MainConsoleFunctionSelectedSection:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"MainConsoleFunctionSelectedSectionTableCell"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainConsoleFunctionSelectedSectionTableCell"];
                selectedFunctionsView = [[MainConsoleDisplayFunctionView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, [self selectionFunctionViewHeight])];
                [cell.contentView addSubview:selectedFunctionsView];
                [selectedFunctionsView showTopLine];
                [selectedFunctionsView showLeftLine];
                [selectedFunctionsView showRightLine];
                [selectedFunctionsView showBottomLine];
                
            }
            
            [selectedFunctionsView setFunctionModels:mainConsoleUtil.selectedFunctions];
            __weak typeof(self) weakSelf = self;
            [selectedFunctionsView.functionButtons enumerateObjectsUsingBlock:^(UIButton* button, NSUInteger idx, BOOL * _Nonnull stop) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
//                [button setEnabled:NO];
                [button addTarget:strongSelf action:@selector(selectedFunctionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            }];
            
            [selectedFunctionsView setHidden:(mainConsoleUtil.selectedFunctions.count == 0)];
            break;
        }
        case MainConsoleFunctionUnSelectedSection:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"MainConsoleFunctionUnSelectedSectionTableCell"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainConsoleFunctionUnSelectedSectionTableCell"];
                unselectedFunctionsView = [[MainConsoleDisplayFunctionView alloc] init];
                [cell.contentView addSubview:unselectedFunctionsView];
                [unselectedFunctionsView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView).with.offset(15);
                    make.right.equalTo(cell.contentView).with.offset(-15);
                }];
                
                [unselectedFunctionsView showTopLine];
                [unselectedFunctionsView showLeftLine];
                [unselectedFunctionsView showRightLine];
                [unselectedFunctionsView showBottomLine];
                
            }
            
            [unselectedFunctionsView setFunctionModels:mainConsoleUtil.unSelectedFunctions];
            __weak typeof(self) weakSelf = self;
            [unselectedFunctionsView.functionButtons enumerateObjectsUsingBlock:^(UIButton* button, NSUInteger idx, BOOL * _Nonnull stop) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
//                [button setEnabled:NO];
                [button addTarget:strongSelf action:@selector(unSelectedFunctionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            }];
            
            [unselectedFunctionsView setHidden:(mainConsoleUtil.unSelectedFunctions.count == 0)];
            break;
        }
        default:
            break;
    }
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainConsoleFunctionDisplayTableViewCell"];
    }
    // Configure the cell...
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) selectedFunctionButtonClicked:(id) sender
{
    NSInteger index = [selectedFunctionsView.functionButtons indexOfObject:sender];
    if (index == NSNotFound) {
        return;
    }
    if (index < 0 || index >= mainConsoleUtil.selectedFunctions.count) {
        return;
    }
    
    MainConsoleFunctionModel* model = mainConsoleUtil.selectedFunctions[index];
    [self functionHandle:model];
}

- (void) unSelectedFunctionButtonClicked:(id) sender
{
    NSInteger index = [unselectedFunctionsView.functionButtons indexOfObject:sender];
    if (index == NSNotFound) {
        return;
    }
    if (index < 0 || index >= mainConsoleUtil.unSelectedFunctions.count) {
        return;
    }
    
    MainConsoleFunctionModel* model = mainConsoleUtil.unSelectedFunctions[index];
    [self functionHandle:model];
}

- (void) functionHandle:(MainConsoleFunctionModel*) model
{
    if ([model.functionCode isEqualToString:@"testAlert"])
    {
        //预警
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－预警"];
        [HMViewControllerManager createViewControllerWithControllerName:@"MainStartAlertStartViewController" ControllerObject:nil];
    }
    else if ([model.functionCode isEqualToString:@"archives"])
    {
        //建档
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－建档"];
        [HMViewControllerManager createViewControllerWithControllerName:@"CreateDocumentStartViewController" ControllerObject:nil];
    }
    else if ([model.functionCode isEqualToString:@"evaluate"])
    {
        //评估
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－评估"];
        [HMViewControllerManager createViewControllerWithControllerName:@"AssessmentMessionsViewController" ControllerObject:nil];
    }
    else if ([model.functionCode isEqualToString:@"survey"])
    {
        //随访
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－随访"];
        [HMViewControllerManager createViewControllerWithControllerName:@"SurveyMessionStartViewController" ControllerObject:nil];
    }
    else if ([model.functionCode isEqualToString:@"rounds"])
    {
        //查房
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－查房"];
        [HMViewControllerManager createViewControllerWithControllerName:@"SERoundsMainViewController" ControllerObject:nil];
    }
    else if ([model.functionCode isEqualToString:@"appoint"])
    {
        //约诊
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－约诊"];
        [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentStartViewController" ControllerObject:nil];
    }
    else if ([model.functionCode isEqualToString:@"healthyPlan"])
    {
        //健康计划
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－健康计划"];
        [HMViewControllerManager createViewControllerWithControllerName:@"HealthPlanMessionStartViewController" ControllerObject:nil];
    }
    else if ([model.functionCode isEqualToString:@"healthyReport"])
    {
        //健康报告
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－健康报告"];
        [HMViewControllerManager createViewControllerWithControllerName:@"HealthReportStartViewController" ControllerObject:nil];
    }
    else if ([model.functionCode isEqualToString:@"workTask"])
    {
        //协调任务
        [[ATModuleInteractor sharedInstance] goTaskList];
    }
    else if ([model.functionCode isEqualToString:@"userSchedule"])
    {
        //自定义
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－自定义"];
        [HMViewControllerManager createViewControllerWithControllerName:@"CustomTaskViewController" ControllerObject:nil];
    }
    else if ([model.functionCode isEqualToString:@"freePatient"])
    {
        // 随访患者
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－随访患者"];
        [[ATModuleInteractor sharedInstance] goPatientListVCWithPatientFilterViewType:PatientFilterViewTypeFree];
    }
    else if ([model.functionCode isEqualToString:@"chargePatient"])
    {
        // 收费患者
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－收费患者"];
        [[ATModuleInteractor sharedInstance] goPatientListVCWithPatientFilterViewType:PatientFilterViewTypeCharge];
    }
    else if ([model.functionCode isEqualToString:@"advice"])
    {
        //开处方
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－用药建议"];
        [HMViewControllerManager createViewControllerWithControllerName:@"NewPrescribeSelectPatientViewController" ControllerObject:nil];
    }
    
    else if ([model.functionCode isEqualToString:@"solicitude"])
    {
        //关怀
        [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－关怀"];
        [HMViewControllerManager createViewControllerWithControllerName:@"HMDoctorConcernViewController" ControllerObject:nil];
    }
    else if ([model.functionCode isEqualToString:@"noticeWindow"])
    {
        HMNoticeWindowViewController *VC = [HMNoticeWindowViewController new];
        [self presentViewController:VC animated:YES completion:nil];
    }
    else if ([model.functionCode isEqualToString:@"fastInGroup"])
    {
        //快速入组
        HMFastInGroupViewController *VC = [[HMFastInGroupViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:VC];
        [self presentViewController:navVC animated:YES completion:nil];
    }
}


@end
