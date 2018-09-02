//
//  SecondEditMainStartViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/5/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SecondEditMainStartViewController.h"
#import "MainConsoleUtil.h"

#import "MainConsoleStaffView.h"
#import "MainConsoleStatisticsView.h"
#import "MainConsoleFunctionView.h"

#import "ATModuleInteractor+CoordinationInteractor.h"
#import "ATModuleInteractor+PatientChat.h"

#import "SiteMessageViewController.h"

#import "JKGWModel.h"
#import "ChatSingleViewController.h"
#import "HMNoticeWindowViewController.h"
#import "SEDoctorSiteMessageMainViewController.h"
#import "HMFastInGroupViewController.h"
#import "DAOFactory.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

typedef void(^tableScrollBlock)(CGFloat tableViewOffsetY);

@interface SecondEditMainStartTableViewController : UITableViewController
{
    
    NSMutableArray* mainFunctions;
}

@property (nonatomic, readonly) MainConsoleStatisticsView* statisticsView;
@property (nonatomic, readonly) MainConsoleFunctionView* functionView;
@property (nonatomic, copy) tableScrollBlock block;

- (void) setMainFunctions:(NSMutableArray*) functions;

- (void)tableScrollBlock:(tableScrollBlock)block;
@end

@implementation SecondEditMainStartTableViewController

@synthesize statisticsView = _statisticsView;
@synthesize functionView = _functionView;

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableHeaderView:self.statisticsView];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reFreshPatientList)];
    [header setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉更新用户信息" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中" forState:MJRefreshStateRefreshing];
    header.stateLabel.textColor = [UIColor whiteColor];
    header.arrowView.hidden = YES;
    self.tableView.mj_header = header;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView.mj_header endRefreshing];
}

- (void)reFreshPatientList {
    [_DAO.patientInfoListDAO requestPatientListImmediately:YES CompletionHandler:^(BOOL success, NSString *errorMsg, NSArray<NewPatientListInfoModel *> *results) {
        [self.tableView.mj_header endRefreshing];
    }];

}

- (void) setMainFunctions:(NSMutableArray*) functions
{
    mainFunctions = functions;
    [self.functionView setFunctionModels:functions];
    [self.tableView reloadData];
}

- (void)tableScrollBlock:(tableScrollBlock)block {
    self.block = block;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat tableViewOffsetY = scrollView.contentOffset.y;
    if (self.block) {
        self.block(tableViewOffsetY);
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (mainFunctions) {
        NSInteger rows = mainFunctions.count / 3;
        if ((mainFunctions.count % 3) > 0) {
            ++rows;
        }
        return (kScreenWidth - 30)/3 * rows + 15;
    }
    
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MainConsoleFunctionSelectedSectionTableCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainConsoleFunctionSelectedSectionTableCell"];
 
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:self.functionView];
        
//        [self.functionView setContentSize:CGSizeMake(kScreenWidth - 30, 116 * 2)];
        self.functionView.layer.shadowColor = [UIColor grayColor].CGColor;
        self.functionView.layer.shadowOpacity = 0.8f;
        self.functionView.layer.shadowRadius = 2.f;
        self.functionView.layer.shadowOffset = CGSizeMake(0,3);
        
        [self.functionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(0, 15, 15, 15));
        }];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.functionView.functionButtons enumerateObjectsUsingBlock:^(UIButton* button, NSUInteger idx, BOOL * _Nonnull stop) {
        //functionButtonClicked
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [button addTarget:strongSelf action:@selector(functionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) functionButtonClicked:(id) sender
{
    NSInteger index = [self.functionView.functionButtons indexOfObject:sender];
    if (index == NSNotFound) {
        return;
    }
    if (index < 0 || index >= mainFunctions.count) {
        return;
    }
    
    MainConsoleFunctionModel* model = mainFunctions[index];
    
    if ([model.functionCode isEqualToString:@"more"]) {
        //更多
        HMBasePageViewController* moreViewController = [HMViewControllerManager createViewControllerWithControllerName:@"MainConsoleMoreViewController" ControllerObject:nil];
        
        [moreViewController.navigationItem setTitle:[MainConsoleUtil shareInstance].staffRoleString];
        return;
    }
    else if ([model.functionCode isEqualToString:@"testAlert"])
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


#pragma mark - settingAndGetting

- (MainConsoleStatisticsView*) statisticsView
{
    if (!_statisticsView) {
        _statisticsView = [[MainConsoleStatisticsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 60, 85)];
//        [self.view addSubview:_statisticsView];
        [_statisticsView setHidden:YES];
    }
    return _statisticsView;
}

- (MainConsoleFunctionView*) functionView
{
    if (!_functionView) {
        _functionView = [[MainConsoleStartFunctionView alloc] init];
//        [self.view addSubview:_functionView];
        [_functionView setBackgroundColor:[UIColor whiteColor]];
    }
    return _functionView;
}

@end

#define BACKIMAGEHEIGHT       180
@interface SecondEditMainStartViewController ()
<TaskObserver>
//<UINavigationControllerDelegate,
//TaskObserver>
{
    MainConsoleUtil* mainConsoleUtil;
    NSMutableArray* mainFunctions;
    NSArray* JKGWList;
}

@property (nonatomic, readonly) UIImageView* headerBackgoundImageView;
@property (nonatomic, readonly) MainConsoleStaffView* staffView;
@property (nonatomic, readonly) SecondEditMainStartTableViewController* startTableViewController;
@property (nonatomic, readonly) UIButton* assistButton;
@property (nonatomic, readonly) UIButton* noticeButton;
@end

@implementation SecondEditMainStartViewController

@synthesize headerBackgoundImageView = _headerBackgoundImageView;
@synthesize staffView = _staffView;
@synthesize startTableViewController = _startTableViewController;
@synthesize assistButton = _assistButton;
@synthesize noticeButton = _noticeButton;

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationController setDelegate:self];
    [self setFd_prefersNavigationBarHidden:YES];
    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ffffff"],NSFontAttributeName:[UIFont boldFont_36]}];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    [self headerBackgoundImageView];
    
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    if (staff) {
        [self.staffView setStaffModel:staff];
    }
    
    NSMutableDictionary* postDict = [NSMutableDictionary dictionary];
    [postDict setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"GetJKGWListRequest" taskParam:postDict TaskObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainFunctionNotificationHandle) name:kMainConsoleFunctionNotificationName object:nil];
    
    mainConsoleUtil = [MainConsoleUtil shareInstance];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *vc = [self.navigationController.viewControllers lastObject];
        if (!vc.fd_prefersNavigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    });
}

- (void) mainFunctionNotificationHandle
{
    [self.staffView setStaffRole:mainConsoleUtil.staffRoleString];
    
    mainFunctions = [NSMutableArray arrayWithArray:mainConsoleUtil.selectedFunctions];
    //更多
    MainConsoleFunctionModel* model = [[MainConsoleFunctionModel alloc] init];
    model.functionCode = @"more";
    model.functionName = @"设置";
    [mainFunctions addObject:model];
    
    [self.startTableViewController setMainFunctions:mainFunctions];
    //是否是主治医生
    [self.startTableViewController.statisticsView setShowIncome:[mainConsoleUtil.staffRole isEqualToString:@"SXZJ"]];
//    [self.functionView.functionButtons enumerateObjectsUsingBlock:^(UIButton* button, NSUInteger idx, BOOL * _Nonnull stop) {
//        [button addTarget:self action:@selector(functionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [mainConsoleUtil loadMainFunctions];
    [self getMessageListCountAction];
    
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    NSMutableDictionary* postDict = [NSMutableDictionary dictionary];
    [postDict setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"MainConsoleStatisticsTask" taskParam:postDict TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getMessageListCountAction
{
    //获取推送类型的session，根据未读数判断红点显示
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] querySessionDataWithUid:@"PUSH@SYS" completion:^(ContactDetailModel *model) {
//        [redImage setHidden:!model._countUnread];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (model._countUnread == 0)
        {
//            UIBarButtonItem* bbiNotice = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_home_notice"] style:UIBarButtonItemStylePlain target:self action:@selector(navAlertButtonClicked:)];
//            [self.navigationItem setRightBarButtonItem:bbiNotice];
            
            [strongSelf.noticeButton setImage:[UIImage imageNamed:@"icon_home_notice"] forState:UIControlStateNormal];
        }
        else
        {
//            UIButton* noticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [noticeButton setImage:[UIImage imageNamed:@"icon_home_notice_a"] forState:UIControlStateNormal];
//            [noticeButton setFrame:CGRectMake(0, 0, 30, 30)];
//            UIBarButtonItem* bbiNotice = [[UIBarButtonItem alloc] initWithCustomView:noticeButton];
//            [noticeButton addTarget:self action:@selector(navAlertButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//            
//            [self.navigationItem setRightBarButtonItem:bbiNotice];
            
            [strongSelf.noticeButton setImage:[UIImage imageNamed:@"icon_home_notice_a"] forState:UIControlStateNormal];
        }
    }];
}




- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    [self.headerBackgoundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        self.backImageHeight = make.height.equalTo(@BACKIMAGEHEIGHT);
//    }];
    
    [self.staffView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(@75);
    }];
    
    [self.assistButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.staffView).with.offset(15);
        make.top.equalTo(self.staffView).with.offset(24);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.noticeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.staffView).with.offset(-15);
        make.top.equalTo(self.staffView).with.offset(24);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.startTableViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.staffView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-49);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
//    return UIStatusBarStyleDefault;
}

#pragma mark - settingAndGetting
- (UIImageView*) headerBackgoundImageView
{
    if (!_headerBackgoundImageView) {
        _headerBackgoundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainconsole_background"]];
        [_headerBackgoundImageView setFrame:CGRectMake(0, 0, ScreenWidth, BACKIMAGEHEIGHT)];
        [_headerBackgoundImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.view addSubview:_headerBackgoundImageView];
    }
    
    return _headerBackgoundImageView;
}

- (MainConsoleStaffView*) staffView
{
    if (!_staffView) {
        _staffView = [[MainConsoleStaffView alloc] init];
        [self.view addSubview:_staffView];
    }
    return _staffView;
}

- (UIButton*) assistButton
{
    if (!_assistButton) {
        _assistButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.staffView addSubview:_assistButton];
        [_assistButton setImage:[UIImage imageNamed:@"nav_assist"] forState:UIControlStateNormal];
        [_assistButton addTarget:self action:@selector(navAssistButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _assistButton;
}

- (UIButton*) noticeButton
{
    if (!_noticeButton) {
        _noticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.staffView addSubview:_noticeButton];
        [_noticeButton setImage:[UIImage imageNamed:@"icon_home_notice"] forState:UIControlStateNormal];
        [_noticeButton addTarget:self action:@selector(navAlertButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noticeButton;
}

- (SecondEditMainStartTableViewController*) startTableViewController
{
    if (!_startTableViewController) {
        _startTableViewController = [[SecondEditMainStartTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self addChildViewController:_startTableViewController];
        [self.view addSubview:_startTableViewController.tableView];
        [_startTableViewController tableScrollBlock:^(CGFloat tableViewOffsetY) {
            if (tableViewOffsetY > 0) {
                return;
            }
            CGRect newFrame = self.headerBackgoundImageView.frame;
            newFrame.size.height = BACKIMAGEHEIGHT - tableViewOffsetY;
            self.headerBackgoundImageView.frame = newFrame;
        }];
    }
    return _startTableViewController;
}

#pragma mark - UINavigationControllerDelegate


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self) {
        
        
        UIImage* bgImage = [[UIImage alloc] init];
        [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
        
        // 设置为半透明
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.navigationBar.shadowImage = bgImage;
        
    } else {
        // 进入其他视图控制器
        self.navigationController.navigationBar.alpha = 1;
        // 背景颜色设置为系统默认颜色
        [self.navigationController setNavigationBarHidden:NO];
        //        self.navigationController.navigationBar.tintColor = nil;
        self.navigationController.navigationBar.translucent = NO;
    }
}



//医学顾问
- (void) navAssistButtonClicked:(id) sender
{
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－我的顾问"];
    JKGWModel *model = [JKGWModel new];
    
    if (JKGWList.count > 0) {
        model = JKGWList.firstObject;
    }
    else {
        [self showAlertMessage:@"您所在的小组没有其他健康顾问"];
        return;
    }
    ContactDetailModel *tempModel = [[ContactDetailModel alloc]init];
    tempModel._target = [NSString stringWithFormat:@"%ld",model.USER_ID];
    tempModel._nickName = model.STAFF_NAME;
    [[ATModuleInteractor sharedInstance] goToJKGWChhatVC:tempModel list:JKGWList];
    
    NSLog(@"点击左上角头像了");
}

- (void) navAlertButtonClicked:(id) sender
{
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－站内信"];
    NSLog(@"点击站内信了");
    SEDoctorSiteMessageMainViewController *VC = [[SEDoctorSiteMessageMainViewController alloc] init];
    
    [self.navigationController pushViewController:VC animated:YES];
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
    if ([taskname isEqualToString:@"MainConsoleStatisticsTask"]) {
        if (taskResult && [taskResult isKindOfClass:[MainConsoleStatisticsModel class]])
        {
            MainConsoleStatisticsModel* statisticsModel = taskResult;
            [self.startTableViewController.statisticsView setMainConsoleStatisticsModel:statisticsModel];
        }
    }
    
    else if ([taskname isEqualToString:@"GetJKGWListRequest"]) {
        //健康顾问列表
        JKGWList = [NSArray new];
        JKGWList = (NSArray *)taskResult;
    }
}
@end
