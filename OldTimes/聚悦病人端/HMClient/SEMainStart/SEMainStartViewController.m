//
//  SEMainStartViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/5/2.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "SEMainStartViewController.h"
//#import "UINavigationBar+JWGradient.h"
#import "SDCycleScrollView.h"
#import "UIImage+EX.h"
#import "ATModuleInteractor+NewSiteMessage.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "SEMainStaffTeamTableViewCell.h"
#import "HMSEMainStartHomeRequest.h"
#import "HMHomeModel.h"
#import "HMSEMainStartWithCollectionTableViewCell.h"
#import "HealthEducationItem.h"
#import "HMInteractor.h"
#import "HMSEMainStartDashboardTableViewCell.h"
#import "MainStartHealthTargetModel.h"
#import "PlanMessionListItem.h"
#import "SurveyRecord.h"
#import "EvaluationListRecord.h"
#import "HealthCenterDoctorGreetingViewController.h"
#import "HMMainStartNotStartAlterView.h"
#import "HMAdsModel.h"
#import "HMWebViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "HMStepUploadManager.h"
#import "HMMainReviewAlterView.h"
#import "HMDoctorConcernViewController.h"
#import "SiteMessageSecondEditionMainListModel.h"
#import "DoctorGreetingInfo.h"

#import "SEMainStartAttendanceViewController.h"
#import "BrithdayIntegralViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "HMWeatherModel.h"
#import "HMWeatherManager.h"

#import "PersonCommitIDCardViewController.h"

#define NAVBAR_CHANGE_POINT       0
#define TOPVIEWHEIGHT             170 * (ScreenWidth / 375)

@interface SEMainStartViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,TaskObserver,HMSEMainStartWithCollectionTableViewCellDelegate,CLLocationManagerDelegate>
{
    NSString* dateString;
    
    NSInteger appointCount;     //还剩余的约诊次数
    NSInteger hasAdded;
}
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *bellImageView;
@property (nonatomic, strong) UIImageView *scanImageView;
@property (nonatomic, strong) UIView *redPoint;
@property (nonatomic, strong) UIView *topNavView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *JWscrollView;
@property (nonatomic, strong) HMHomeModel *homeModel;

@property (nonatomic, strong) HMMainStartNotStartAlterView *noStartAlterView;
@property (nonatomic, strong) HMMainReviewAlterView *reviewAlterView;
@property (nonatomic, strong) NSMutableArray *showRowsArr;

@property (nonatomic) BOOL isFirstIn;
@property (nonatomic) BOOL navBarCanChange;
@property (nonatomic) BOOL viewAppeared;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) HMWeatherModel *weatherModel;
@end

@implementation SEMainStartViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setFd_prefersNavigationBarHidden:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ffffff"],NSFontAttributeName:[UIFont boldFont_36]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self configElements];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageListCountAction) name:MTBadgeCountChangedNotification object:nil];
    [self getMessageListCountAction];
    
    // 集团用户上传步数
    [[HMStepUploadManager shareInstance] upLoadCurrentStep:^(BOOL success) {
    }];
    
    if (![[UserInfoHelper defaultHelper] todayHasBeenSigned])
    {
        //调用接口，获取最后签到日期
        [self loadAttendanceInfo];
    }
    
    
    // Do any additional setup after loading the view.
    
    [self performSelector:@selector(showBrithdayView) withObject:nil afterDelay:0.4];
    
    [self showCommitIDCardView];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    dateString = [[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd"];
    [self startHomeRequest];


}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewAppeared = YES;
    [self navBarColorChangeWith:self.tableView.contentOffset.y];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.viewAppeared = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *vc = [self.navigationController.viewControllers lastObject];
        if (!vc.fd_prefersNavigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.topNavView];

    [self.view addSubview:self.leftImageView];
    [self.view addSubview:self.bellImageView];
    [self.view addSubview:self.scanImageView];

    [self.topNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(-20);
    }];
    
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topNavView).offset(28);
        make.left.equalTo(self.topNavView).offset(15);
    }];
    
    [self.bellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topNavView).offset(-10);
        make.centerY.equalTo(self.leftImageView);
    }];
    
    [self.scanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bellImageView.mas_left).offset(-18);
        make.centerY.equalTo(self.leftImageView);
    }];
    

}

- (void)getMessageListCountAction
{
    //获取推送类型的session，根据未读数判断红点显示
    [[MessageManager share] querySessionDataWithUid:@"PUSH@SYS" completion:^(ContactDetailModel *model) {
        [self.redPoint setHidden:!model._countUnread];
    }];
}

- (void)startHomeRequest {
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    [dict setObject:@"HomePage2.0_ios_jy" forKey:@"adPositionCode"];
    
    if (!self.isFirstIn) {
        [self at_postLoading];
    }
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMSEMainStartHomeRequest" taskParam:dict TaskObserver:self];

}

- (void) loadAttendanceInfo
{
    //PointRedemptionContinuationTask
    NSMutableDictionary* postDictionary = [NSMutableDictionary dictionary];
    UserInfo* currentUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [postDictionary setValue:@1 forKey:@"type"];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld", currentUser.userId] forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"PointRedemptionContinuationTask" taskParam:postDictionary TaskObserver:self];
}

- (SEMainStartType)acquireTypeWithIndexPath:(NSIndexPath *)indexPath {
    return [self.showRowsArr[indexPath.section] integerValue];
}

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
    else if ([kpiCode isEqualToString:@"XD"]) {
        //心电
        controllerName = @"ECGDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－心电"];
    }
    else if ([kpiCode isEqualToString:@"XL"]) {
        //心率
        controllerName = @"HeartRateDetectStartViewController";
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
    else if ([kpiCode isEqualToString:@"TEM"]) {
        //体温
        controllerName = @"BodyTemperatureDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－体温"];
    }
    else if ([kpiCode isEqualToString:@"FLSZ"])
    {
        //峰流速值
        controllerName = @"PEFDetectStartViewController";
        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－目标－峰流速值"];
    }
    
    if (!controllerName || 0 == controllerName.length) {
        return;
    }
    
    [HMViewControllerManager createViewControllerWithControllerName:controllerName ControllerObject:nil];
}

- (void) entryDetectController:(NSString*) kpiCode
                        TaskId:(NSString*) detectTaskId
{
    if (!kpiCode || 0 == kpiCode.length)
    {
        return;
    }
    NSString* controllerName = nil;
    if ([kpiCode isEqualToString:@"XY"])
    {
        //血压
        controllerName = @"BodyPressureDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"TZ"])
    {
        //体重
        controllerName = @"BodyWeightDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"XT"])
    {
        //血糖
        controllerName = @"BloodSugarDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"XD"])
    {
        //心电
        controllerName = @"ECGDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"XL"])
    {
        //心率
        controllerName = @"HeartRateDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"XZ"])
    {
        //血脂
        controllerName = @"BloodFatDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"OXY"])
    {
        //血氧
        controllerName = @"BloodOxygenDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"NL"])
    {
        //尿量
        controllerName = @"UrineVolumeDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"HX"])
    {
        //呼吸
        controllerName = @"BreathingDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"TEM"])
    {
        //体温
        controllerName = @"BodyTemperatureDetectStartViewController";
    }
    else if ([kpiCode isEqualToString:@"FLSZ"])
    {
        //峰流速值
        controllerName = @"PEFDetectStartViewController";
    }
    if (!controllerName || 0 == controllerName.length)
    {
        return;
    }
    
    NSMutableDictionary* dicParam = [NSMutableDictionary dictionary];
    [dicParam setValue:detectTaskId forKey:@"taskId"];
    [HMViewControllerManager createViewControllerWithControllerName:controllerName ControllerObject:dicParam];
}

- (void) entryMentality:(PlanMessionListItem*) planItem
{
    if ([planItem.status isEqualToString:@"1"]) {
        //待记录
        //statusColor = [UIColor colorWithHexString:@"FF6666"];
        [HMViewControllerManager createViewControllerWithControllerName:@"PsychologyPlanStartViewController" ControllerObject:nil];
    }
    else if ([planItem.status isEqualToString:@"2"]) {
        //已记录
        [HMViewControllerManager createViewControllerWithControllerName:@"UserMoodRecordsStartViewController" ControllerObject:nil];
    }
   
}

- (void) entryNutrtuin:(PlanMessionListItem*) planItem
{
    
[HMViewControllerManager createViewControllerWithControllerName:@"SENuritionDietRecordsStartViewController" ControllerObject:nil];
}

- (void)jumpToTodayClickWithDataModel:(PlanMessionListItem *)model {
    
}

- (void)handelTodayMissionClickWithDataModel:(PlanMessionListItem *) planItem{
    
    NSString* code = planItem.code;
    if (!code || 0 == code.length)
    {
        return;
    }
    
    if ([planItem.status isEqualToString:@"0"])
    {
        //未开始
        return;
    }
    
    if ([code isEqualToString:@"TEST"])
    {
        if ([planItem.status isEqualToString:@"2"])
        {
            //已测量
            NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
            [dicPost setValue:planItem.taskId forKey:@"taskId"];
            [[TaskManager shareInstance] createTaskWithTaskName:@"UserDetectPlanInfoTask" taskParam:dicPost TaskObserver:self];
            return;
        }
        //监测计划 跳转检测界面
        if ([planItem.kpiCode isEqualToString:@"XD"])
        {
            if ([planItem.status isEqualToString:@"3"])
            {
                UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
                [self.noStartAlterView configImage:[UIImage imageNamed:@"ic_pastdue"] titel:@"无法测量，该任务必须在有效时间段内完成！"];
                [keyWindow addSubview:self.noStartAlterView];
                [self.noStartAlterView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(keyWindow);
                }];

                return;
            }
        }
        [self entryDetectController:planItem.kpiCode TaskId:planItem.taskId];
        return;
    }
    
    if ([code isEqualToString:@"NUTRITION"])
    {
        //营养，记饮食
        [self entryNutrtuin:planItem];
        return;
    }
    if ([code isEqualToString:@"MENTALITY"])
    {
        //心情
        [self entryMentality:planItem];
        return;
    }
    if ([code isEqualToString:@"DRUGS"])
    {
        //用药 MedicationPlanViewStartController
        [HMViewControllerManager createViewControllerWithControllerName:@"MedicationPlanViewStartController" ControllerObject:dateString];
        return;
    }
    if ([code isEqualToString:@"SPORTS"])
    {
        //记运动
        [HMViewControllerManager createViewControllerWithControllerName:@"RecordSportsExecuteViewController" ControllerObject:nil];
        return;
    }
    
    if ([code isEqualToString:@"SURVEY"])
    {
        //随访
        SurveyRecord *record = [[SurveyRecord alloc]init];
        [record setSurveyId:planItem.taskId];
        [record setSurveyMoudleName:planItem.taskCon];
        UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
        
        [record setUserId:[NSString stringWithFormat:@"%ld", curUser.userId]];
        if ([planItem.status isEqualToString:@"2"]) {
            //跳转到随访详情
            [record setFillTime:dateString];
        }
        [HMViewControllerManager createViewControllerWithControllerName:@"SurveyRecordDatailViewController" ControllerObject:record];
        return;
        
    }
    if ([code isEqualToString:@"ASSESSMENT"])
    {
        //评估计划
        if ([planItem.status isEqualToString:@"1"] || [planItem.status isEqualToString:@"3"]) {
            //跳转到填写评估 一定是阶段评估
            [HMViewControllerManager createViewControllerWithControllerName:@"EvaluationUnFilledDetailViewController" ControllerObject:[NSString stringWithFormat:@"%@", planItem.taskId]];
        }
        else if ([planItem.status isEqualToString:@"2"]) {
            //跳转到随访详情
            EvaluationListRecord *evaluationRecord = [[EvaluationListRecord alloc] init];
            evaluationRecord.itemId = planItem.taskId;
            evaluationRecord.itemType = @"1";
            [HMViewControllerManager createViewControllerWithControllerName:@"EvaluationDetailViewController" ControllerObject:evaluationRecord];
        }
                
        return;
    }
}

- (BOOL)isMissionStart:(PlanMessionListItem *)model {
    NSDateFormatter *fort = [NSDateFormatter new];
    fort.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *excDate = [fort dateFromString:model.excTime];
    NSDate *nowDate = [NSDate date];
    if ([nowDate isLaterThanOrEqualTo:excDate] && [nowDate hoursFrom:excDate] < 1) {
        return YES;
    }
    return NO;
}

- (void)updateAdsView {
    if (self.homeModel.adsModelArr && self.homeModel.adsModelArr.count) {
        self.navBarCanChange = YES;
        NSMutableArray *imageArr = [NSMutableArray array];

        [self.homeModel.adsModelArr enumerateObjectsUsingBlock:^(HMAdsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [imageArr addObject:obj.imgUrlBig];
        }];
        self.JWscrollView.imageURLStringsGroup = imageArr;
        
        __weak typeof(self) weakSelf = self;
        self.JWscrollView.clickItemOperationBlock = ^(NSInteger index) {
            HMAdsModel *tempModel = weakSelf.homeModel.adsModelArr[index];
            if (tempModel.linkUrl && tempModel.linkUrl.length) {
                [weakSelf jumpWithAdsModel:tempModel];
            }
        };
        
        [self.tableView setTableHeaderView:self.JWscrollView];

    }
    else {
        self.navBarCanChange = NO;
        [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 64)]];
        
        [self.topNavView setAlpha:1];
        [self.bellImageView setHighlighted:YES];
        [self.leftImageView setHighlighted:YES];
        [self.scanImageView setHighlighted:YES];
    }
}

- (void)jumpWithAdsModel:(HMAdsModel *)model {
    //根据URL跳转
    NSURL* urlLink = [NSURL URLWithString:model.linkUrl];
    if (urlLink)
    {
        NSString* scheme = [urlLink scheme];
        if (scheme && ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]))
        {
            //跳转到Web页面
            HMWebViewController* webController = [[HMWebViewController alloc] initWithUrlString:model.linkUrl titelString:model.contentName];
            [self.navigationController pushViewController:webController animated:YES];
            return;
        }
        
        if ([scheme isEqualToString:@"jyhmclient"])
        {
            //根据url跳转App页面
            [HMViewControllerRouterHelper routerControllerWithUrlString:model.linkUrl];
            return;
        }
    }

}

- (void)reloadMainView {
    if (!self.homeModel.orgTeam || !self.homeModel.orgTeam.orgTeamDet.count) {
        [self.showRowsArr removeObject:@(SEMainStartType_StaffTeam)];
    }
    else {
        if (![self.showRowsArr containsObject:@(SEMainStartType_StaffTeam)]) {
            [self.showRowsArr insertObject:@(SEMainStartType_StaffTeam) atIndex:0];
        }
    }
    
    if ([self.homeModel.orderInfo[@"hasService"] isEqualToString:@"Y"] && [self.homeModel.orderInfo[@"privilege"] objectForKey:@"JKJH"] &&
        [self.homeModel.orderInfo[@"hasHealthyPlan"] isEqualToString:@"Y"]) {
        
        if (![self.showRowsArr containsObject:@(SEMainStartType_TodayMission)]) {
            [self.showRowsArr insertObject:@(SEMainStartType_TodayMission) atIndex:2];
        }
    }
    else {
        [self.showRowsArr removeObject:@(SEMainStartType_TodayMission)];

    }
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.homeModel.healthyTask];
    __block NSMutableArray *lastArr = [NSMutableArray array];
    [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PlanMessionListItem *model = (PlanMessionListItem *)obj;
        if ([model.code isEqualToString:@"NUTRITION"] ||[model.code isEqualToString:@"SPORTS"] ||[model.code isEqualToString:@"MENTALITY"] ||[model.code isEqualToString:@"DRUGS"] ||
            [model.code isEqualToString:@"REVIEW"]) {
            NSDate *date = [NSDate dateWithString:model.excTime formatString:@"yyyy-MM-dd HH:mm:ss"];
            // 复查过期后放到最后，未过期时正常显示
            if ([model.code isEqualToString:@"REVIEW"]) {
                if ([[NSDate date] hoursLaterThan:date] > 0) {
                    [lastArr addObject:obj];
                }
            }
            else{
                [lastArr addObject:obj];
            }
        }
        
    }];
    
    [tempArr removeObjectsInArray:lastArr];
    [tempArr addObjectsFromArray:lastArr];
    
    self.homeModel.healthyTask = tempArr;
    [self.tableView reloadData];
    [self updateAdsView];
}

- (void)navBarColorChangeWith:(CGFloat)offsetY {
    
    CGFloat tableViewOffsetY = offsetY;
    
    [self.bellImageView setHighlighted:tableViewOffsetY > NAVBAR_CHANGE_POINT];
    [self.leftImageView setHighlighted:tableViewOffsetY > NAVBAR_CHANGE_POINT];
    [self.scanImageView setHighlighted:tableViewOffsetY > NAVBAR_CHANGE_POINT];
    
    if (tableViewOffsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 20 - tableViewOffsetY * 3) / 20));
        [self.topNavView setAlpha:alpha];
    } else {
        [self.topNavView setAlpha:0];
    }

}

- (void)completedUserReview:(PlanMessionListItem *)model {
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    [dict setObject:[[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd"] forKey:@"reviewDate"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMCompletedUserReviewRequest" taskParam:dict TaskObserver:self];

}

- (void) showAttendcnce
{
    [SEMainStartAttendanceViewController show];
}

- (void) showCommitIDCardView
{
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    if (curUser.idCard && curUser.idCard.length > 0) {
        return;
    }

    NSString* alertShownKey = @"alertShownKey";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString* alertShownValue = [NSString stringWithFormat:@"%ld_%@", curUser.userId, version];
    
    NSString* savedShownValue = [[NSUserDefaults standardUserDefaults] valueForKey:alertShownKey];
    if (savedShownValue && savedShownValue.length > 0 && [savedShownValue isEqualToString:alertShownValue]) {
        //已经显示过来
        return;
    }
    
    
    [PersonCommitIDCardViewController showWithHandleBlock:^{
        
    }];
    
    //保存已经显示过了，不再提示了。
    [[NSUserDefaults standardUserDefaults] setValue:alertShownValue forKey:alertShownKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (void) showBrithdayView
{
    if ([[UserInfoHelper defaultHelper] todayHasShownBrithday]) {
        return;
    }
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    if (curUser.birth)
    {
        NSDate* brithDate = [NSDate dateWithString:curUser.birth formatString:@"yyyy-MM-dd"];
        NSDate* todayDate = [NSDate date];
        if (brithDate && brithDate.day == todayDate.day && brithDate.month == todayDate.month)
        {
            [BrithdayIntegralViewController show];
            
            [[UserInfoHelper defaultHelper] setShowBrithDay:[todayDate formattedDateWithFormat:@"yyyy-MM-dd"]];
        }
    }
    
}

// 显示医生关怀弹窗
- (void)showDoctorCareAlterVC:(NSArray *)greetingList {
    
    HMDoctorConcernViewController *careVC = [[HMDoctorConcernViewController alloc] initWithArray:greetingList];
    [careVC doctorCareShowMore:^(NSInteger tag) {
        if (tag) {
            // 跳转健康宣教
            HealthEducationItem* educationModel = [HealthEducationItem new];
            DoctorGreetingInfo *tempModel = greetingList.firstObject;
            educationModel.classId = tempModel.classId.integerValue;
            //跳转到宣教详情
            [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationDetailViewController" ControllerObject:educationModel];
        }
        else {
            //将推送消息session标记已读，去除站内信外面红点
            [[MessageManager share] sendReadedRequestWithUid:@"PUSH@SYS" messages:nil];
            
            // 跳转更多关怀
            SiteMessageSecondEditionMainListModel *model = [SiteMessageSecondEditionMainListModel new];
            // 能收到推送肯定是打开状态
            model.status = 1;
            model.typeCode = @"YSGH";
            model.typeName = @"医生关怀";
            if (!model.typeName.length) {
                // 没有对应titel不跳转
                return;
            }
            [HMViewControllerManager createViewControllerWithControllerName:@"NewSiteMessageItemListViewController" ControllerObject:model];
        }
        
    }];
    [self.view.window.rootViewController presentViewController:careVC animated:YES completion:nil];

}

- (void)startLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        NSLog(@"requestWhenInUseAuthorization");
        [self.locationManager requestWhenInUseAuthorization];
//        [self.locationManager requestAlwaysAuthorization];
    }
    
    
    //开始定位，不断调用其代理方法
    [self.locationManager startUpdatingLocation];
}

- (void)startWeatherRequestWithCityName:(NSString *)cityName {
 
    NSString *path= [[NSBundle mainBundle] pathForResource:@"cityWeatherList" ofType:@"plist"];
    NSDictionary *dict =[[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *cityCode = [dict objectForKey:cityName];
    
    __weak typeof(self) weakSelf = self;
    [[HMWeatherManager shareInstance] HMStartGetCurrentWeatherWithCityCode:cityCode block:^(BOOL isSuccess, HMWeatherModel *model) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (isSuccess && model) {
            strongSelf.weatherModel = model;
            if ([strongSelf.showRowsArr containsObject:@(SEMainStartType_StaffTeam)]) {
                // 有我的专家团
                [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
            
        }
    }];

}
#pragma mark - event Response
//进入站内信
- (void)gotoMessageVcAction
{
    [[ATModuleInteractor sharedInstance] gotoNewSiteMessageMainListVC];
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:[NSString stringWithFormat:@"站内信"]];
}
// 扫一扫
- (void)scanerButtonClick
{
    [HMViewControllerManager createViewControllerWithControllerName:@"ScanQRCodeViewController" ControllerObject:nil];
}

#pragma mark Location and Delegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    // 2.停止定位
    [manager stopUpdatingLocation];
    
    __weak typeof(self) weakSelf = self;
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"%@",placemark.name);
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"cityName, %@",city);
            
            // 市
            NSLog(@"locality,%@",city);
            if (city && city.length > 0) {
                //TODO:
                [weakSelf startWeatherRequestWithCityName:city];
            }
            
        }else if (error == nil && [placemarks count] == 0) {
            //            [weakSelf showAlertMessage:@"获取地址信息失败。"];
            [weakSelf startWeatherRequestWithCityName:@"重庆市"];
        } else if (error != nil){
            //            [weakSelf showAlertMessage:@"获取地址信息失败。"];
            [weakSelf startWeatherRequestWithCityName:@"重庆市"];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        
    }
}

#pragma mark - HMSEMainStartWithCollectionTableViewCellDelegate
// collectionViewcell点击方法
- (void)HMSEMainStartWithCollectionTableViewCellDelegateCallBack_didSelectCollectionCellWithIndexPath:(NSIndexPath *)indexPath tableViewCellType:(SEMainStartType)type {
    
    switch (type) {
            case SEMainStartType_TodayMission:
        {// 今日任务PlanMessionListItem
            
            NSArray *todayMissionDataList = self.homeModel.healthyTask;
            PlanMessionListItem *planItem = todayMissionDataList[indexPath.row];
            if ([planItem.code isEqualToString:@"REVIEW"]) {
                // 复查
                UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
                [self.reviewAlterView fillDataWith:planItem];
                [keyWindow addSubview:self.reviewAlterView];
                [self.reviewAlterView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(keyWindow);
                }];
                
                self.reviewAlterView.tempModel = planItem;
                
                return;

            }
            if ([planItem.status isEqualToString:@"0"]) {
                // 未开始任务弹框提示
                UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
                [self.noStartAlterView configImage:[UIImage imageNamed:@"SEMainStartic_nostart"] titel:@"任务未开始，请稍后操作。"];
                [keyWindow addSubview:self.noStartAlterView];
                [self.noStartAlterView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(keyWindow);
                }];
                
                self.noStartAlterView.tempModel = planItem;

                return;
            }

            [self handelTodayMissionClickWithDataModel:planItem];
            
            break;
        }
        case SEMainStartType_HealthClass:
        {
            NSArray *healthClassDataList = [HealthEducationItem mj_objectArrayWithKeyValuesArray:self.homeModel.mcClassList[@"list"]];

            HealthEducationItem* educationModel = healthClassDataList[indexPath.row];
            //跳转到宣教详情
            [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationDetailViewController" ControllerObject:educationModel];
            break;
        }
        case SEMainStartType_ToolBox:
        {
            switch (indexPath.row) {
                case SEMainStartToolBoxType_Experts:
                {// 约专家
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页-约专家"];
                    if (![UserServicePrivilegeHelper userHasPrivilege:ServicePrivile_Appoint])
                    {
                        //跳转到购买套餐界面
                        [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentServiceListViewController" ControllerObject:nil];
                        return;
                    }
                    //获取是否还有可用的约诊次数
                    [[TaskManager shareInstance] createTaskWithTaskName:@"AppointmentStaffCountTask" taskParam:nil TaskObserver:self];
                    //
                    
                    
                    break;
                }
                case SEMainStartToolBoxType_Nutrition:
                {// 营养库
                    
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－营养库"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"NutritionLibsStartViewController" ControllerObject:nil];
                    break;
                }
                case SEMainStartToolBoxType_Pharmacy:
                {// 药品库
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }

}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 1;
        
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.showRowsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SEMainStartType type = [self acquireTypeWithIndexPath:indexPath];

    id cell;
    
    switch (type) {
        case SEMainStartType_StaffTeam:
        {// 团队信息
            cell = [tableView dequeueReusableCellWithIdentifier:[SEMainStaffTeamTableViewCell at_identifier]];
            [cell fillDataWithTeamModel:self.homeModel.orgTeam cares:self.homeModel.systemUserCares];
            [cell fillWeatherDataWithModel:self.weatherModel];
            break;
        }
        case SEMainStartType_HealthRecord:
        {// 记录健康
            cell = [tableView dequeueReusableCellWithIdentifier:[HMSEMainStartDashboardTableViewCell at_identifier]];
            [cell configTargetItems:self.homeModel.userTestTarget];
            [cell addTargetValueClickedCompletion:^(MainStartHealthTargetModel *model) {
                [self targetValueDashboardClicked:model];
            }];
            break;

            
        }
        case SEMainStartType_TodayMission:
        case SEMainStartType_HealthClass:
        case SEMainStartType_ToolBox:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[HMSEMainStartWithCollectionTableViewCell at_identifier]];
            [cell setJWdelegate:self];
            
            switch (type) {
                case SEMainStartType_TodayMission:
                {// 今日任务
                    [cell fillDataWithTodayMissionTypeDataList:self.homeModel.healthyTask];
                    [[cell moreLb] setHidden:NO];

                    break;
                }
                case SEMainStartType_HealthClass:
                {// 健康课堂
                    [cell fillDataWithHealthClassTypeDataList:self.homeModel.mcClassList[@"list"]];
                    [[cell moreLb] setHidden:NO];

                    break;
                }
                case SEMainStartType_ToolBox:
                {// 工具箱
                    [cell fillDataWithToolBoxType];
                    [[cell moreLb] setHidden:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell at_identifier]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            NSString *titelName = @"JW";
            [[cell textLabel] setText:titelName];
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SEMainStartType type = [self acquireTypeWithIndexPath:indexPath];
    CGFloat rowHeight = 0;
    switch (type) {
        case SEMainStartType_StaffTeam:
        {// 团队信息
            rowHeight = 155;
            break;
        }
        case SEMainStartType_HealthRecord:
        {// 记录健康
            rowHeight = 192 + 40;
            break;
        }
        case SEMainStartType_TodayMission:
        {// 今日任务
            rowHeight = 142;

            break;
        }
        case SEMainStartType_HealthClass:
        {// 健康课堂
            rowHeight = 178;

            break;
        }
        case SEMainStartType_ToolBox:
        {// 工具箱
            rowHeight = 140;

            break;
        }
        default:
            
            break;
    }
    return rowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SEMainStartType type = [self acquireTypeWithIndexPath:indexPath];
    
    switch (type) {
        case SEMainStartType_StaffTeam:
        {// 团队信息
            break;
        }
        case SEMainStartType_HealthRecord:
        {// 记录健康
            
            break;
        }
        case SEMainStartType_TodayMission:
        {// 今日任务
            
            [self.tabBarController setSelectedIndex:1];
//            [HMViewControllerManager createViewControllerWithControllerName:@"HMUserMissionViewController" ControllerObject:nil];
            break;
        }
        case SEMainStartType_HealthClass:
        {// 健康课堂
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康计划－健康课堂"];
            [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationStartViewController" ControllerObject:nil];
            break;
        }
        case SEMainStartType_ToolBox:
        {// 工具箱
            
            break;
        }
        default:
            
            break;
    }

    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.navBarCanChange) {
        return;
    }
    if (!self.viewAppeared) {
        return;
    }
    // 设置navigationBar透明度和颜色
    
    [self navBarColorChangeWith:scrollView.contentOffset.y];
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat tableViewOffsetY = scrollView.contentOffset.y + 20;

    if (tableViewOffsetY < 100) {
        [self.tableView setContentOffset:CGPointMake(0, -20) animated:YES];
    }
    
    if (tableViewOffsetY >= 50 && tableViewOffsetY < TOPVIEWHEIGHT - 64) {
        [self.tableView setContentOffset:CGPointMake(0, TOPVIEWHEIGHT - 64 - 20) animated:YES];
    }
}

#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
   
    if (StepError_None != taskError)
    {
        [self at_hideLoading];
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    if ([taskname isEqualToString:@"PointRedemptionContinuationTask"])
    {
        if (taskError == StepError_None) {
            if (![[UserInfoHelper defaultHelper] todayHasBeenSigned])
            {
                //弹出签到窗口
                [self performSelector:@selector(showAttendcnce) withObject:nil afterDelay:0.3];
            }
        }
        return;
    }
    else if([taskname isEqualToString:@"AppointmentStaffCountTask"])
    {
        if (appointCount > 0) {
            //还有可约诊次数，跳转约诊界面
            [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentStartViewController" ControllerObject:nil];
        }
        else
        {
            //没有可预约次数了
            [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentNoTimesViewController" ControllerObject:nil];
        }
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self at_hideLoading];
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"HMSEMainStartHomeRequest"]) {
        // 上传日志
//        [ATLog uploadLogFile];
        
        self.homeModel = taskResult;
        [self reloadMainView];
        
        if (!self.isFirstIn) {
            self.isFirstIn = YES;
            
            [self startLocation];
        }
        
        NSArray* greetingList = self.homeModel.doctorCares;
        
        if (greetingList.count <= 0)
        {
            return;
        }
    
        [self performSelector:@selector(showDoctorCareAlterVC:) withObject:greetingList afterDelay:0.6];

    }
    else if ([taskname isEqualToString:@"HMCompletedUserReviewRequest"]) {
        [self startHomeRequest];

    }
    
    else if([taskname isEqualToString:@"AppointmentStaffCountTask"])
    {
        if(taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* resultDictionary = (NSDictionary*) taskResult;
            NSNumber* numCount = resultDictionary[@"totalcount"];
            if (numCount)
            {
                NSLog(@"count = %ld", numCount.integerValue);
                appointCount = numCount.integerValue;
            }
            numCount = resultDictionary[@"hasAdded"];
            if (numCount)
            {
                hasAdded = numCount.integerValue;
            }
        }
    }
}

#pragma mark - Interface

#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 64)]];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
        [_tableView registerClass:[SEMainStaffTeamTableViewCell class] forCellReuseIdentifier:[SEMainStaffTeamTableViewCell at_identifier]];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell at_identifier]];
        [_tableView registerClass:[HMSEMainStartWithCollectionTableViewCell class] forCellReuseIdentifier:[HMSEMainStartWithCollectionTableViewCell at_identifier]];
        [_tableView registerClass:[HMSEMainStartDashboardTableViewCell class] forCellReuseIdentifier:[HMSEMainStartDashboardTableViewCell at_identifier]];
        
    }
    return _tableView;
}

- (SDCycleScrollView *)JWscrollView {
    if (!_JWscrollView) {
        _JWscrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, TOPVIEWHEIGHT) delegate:self placeholderImage:[UIImage at_imageWithColor:[UIColor commonBackgroundColor] size:CGSizeMake(ScreenWidth, TOPVIEWHEIGHT)]];
        _JWscrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜
        [_JWscrollView setAutoScrollTimeInterval:5];
        
    }
    return _JWscrollView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SEMainStartim_logo"] highlightedImage:[UIImage imageNamed:@"SEMainStartim_logo_move"]];
    }
    return _leftImageView;
}

- (UIImageView *)bellImageView {
    if (!_bellImageView) {
        _bellImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SEMainStartic_tongzhi"] highlightedImage:[UIImage imageNamed:@"SEMainStartic_tongzhi2"]];
        [_bellImageView setUserInteractionEnabled:YES];
        [_bellImageView addSubview:self.redPoint];
        
        [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bellImageView.mas_right).offset(-3);
            make.centerY.equalTo(_bellImageView.mas_top).offset(3);
            make.width.height.equalTo(@12);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoMessageVcAction)];
        [_bellImageView addGestureRecognizer:tap];
    }
    return _bellImageView;
}

- (UIImageView *)scanImageView {
    if (!_scanImageView) {
        _scanImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SEMainStartic_saoyisao"] highlightedImage:[UIImage imageNamed:@"SEMainStartic_saoyisao2"]];
        [_scanImageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanerButtonClick)];
        [_scanImageView addGestureRecognizer:tap];
    }
    return _scanImageView;
}

- (UIView *)redPoint {
    if (!_redPoint) {
        _redPoint = [UIView new];
        [_redPoint setBackgroundColor:[UIColor redColor]];
        [_redPoint.layer setCornerRadius:6];
        [_redPoint.layer setBorderColor:[[UIColor colorWithHexString:@"ffffff"] CGColor]];
        [_redPoint.layer setBorderWidth:1];
        [_redPoint setHidden:YES];
    }
    return _redPoint;
}

- (HMMainStartNotStartAlterView *)noStartAlterView {
    if (!_noStartAlterView) {
        _noStartAlterView = [HMMainStartNotStartAlterView new];
        [_noStartAlterView btnClickBlock:^(HMMainStartAlterBtnType clickType) {
            [self.noStartAlterView removeFromSuperview];
            switch (clickType) {
                case HMMainStartAlterBtnType_Goon:
                {
                    [self handelTodayMissionClickWithDataModel:self.noStartAlterView.tempModel];
                    break;
                }
                    
                default:
                    break;
            }
            self.noStartAlterView = nil;
        }];
    }
    return _noStartAlterView;
}

- (HMMainReviewAlterView *)reviewAlterView {
    if (!_reviewAlterView) {
        _reviewAlterView = [HMMainReviewAlterView new];
        [_reviewAlterView btnClickBlock:^(HMMainStartAlterBtnType clickType) {
            [self.reviewAlterView removeFromSuperview];
            switch (clickType) {
                case HMMainStartAlterBtnType_Goon:
                {
                    [self completedUserReview:self.reviewAlterView.tempModel];
                    break;
                }
                    
                default:
                    break;
            }
            self.reviewAlterView = nil;
        }];
    }
    return _reviewAlterView;
}


- (NSMutableArray *)showRowsArr {
    if (!_showRowsArr) {
        _showRowsArr = [NSMutableArray arrayWithObjects:@(SEMainStartType_StaffTeam),@(SEMainStartType_HealthRecord),@(SEMainStartType_TodayMission),@(SEMainStartType_HealthClass),
            @(SEMainStartType_ToolBox), nil];
    }
    return _showRowsArr;
}

- (UIView *)topNavView {
    if (!_topNavView) {
        _topNavView = [UIView new];
        CAGradientLayer *backLayer = [CAGradientLayer layer];
        backLayer.locations = @[@0.1, @1.0];
        backLayer.startPoint = CGPointMake(0, 1.0);
        backLayer.endPoint = CGPointMake(1.0, 0);
        backLayer.frame = CGRectMake(0, 0, ScreenWidth, 64);
        
        backLayer.colors = @[(__bridge id)[[UIColor colorWithHexString:@"3cd395" alpha:1] CGColor], (__bridge id)[[UIColor colorWithHexString:@"31c9ba" alpha:1] CGColor]];
        [_topNavView.layer addSublayer:backLayer];
        
    }
    return _topNavView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
