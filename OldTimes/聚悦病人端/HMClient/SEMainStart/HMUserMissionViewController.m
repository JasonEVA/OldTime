//
//  HMUserMissionViewController.m
//  HMClient
//
//  Created by JasonWang on 2017/5/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMUserMissionViewController.h"
#import "HMWeeklySelectDateView.h"
#import "HMUserMissionTableViewCell.h"
#import "PlanMessionListItem.h"
#import "SurveyRecord.h"
#import "EvaluationListRecord.h"
#import "HMMainReviewAlterView.h"
#import "HMMainStartNotStartAlterView.h"
#import "HMSEHealthPlanMissionHeadView.h"

#define DATESELECTSELECTVIEWHEIGHT      120
@interface HMUserMissionViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray <PlanMessionListItem *>*dataList;
@property (nonatomic, strong) HMWeeklySelectDateView *dateSelectView;
@property (nonatomic, strong) HMMainReviewAlterView *reviewAlterView;
@property (nonatomic, strong) HMMainStartNotStartAlterView *noStartAlterView;
@property (nonatomic, strong) HMSEHealthPlanMissionHeadView *tableHeadView;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, copy) isHaveHealthPlan block;
@property (nonatomic) BOOL isFirstIn;

@end

@implementation HMUserMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.startDate = [NSDate date];
    self.selectedDate = self.startDate;
    [self.view addSubview:self.dateSelectView];
    [self.dateSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@DATESELECTSELECTVIEWHEIGHT);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateSelectView.mas_bottom);
        make.bottom.left.right.equalTo(self.view);
    }];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateVCWithDate:self.selectedDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
}
- (void)updateVCWithDate:(NSDate *)date {
    self.selectedDate = date;
    NSString *dateString = [date formattedDateWithFormat:@"yyyy年MM月dd日"];
//    [self.navigationItem setTitle:dateString];
    
    [self requestHealthTesk];
}

- (void)requestHealthTesk {
    NSString* dateStr = [self.selectedDate formattedDateWithFormat:@"yyyy-MM-dd"];
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:dateStr forKey:@"dateStr"];
    
    if (!self.isFirstIn) {
        [self at_postLoading];
        self.isFirstIn = YES;
    }
    [[TaskManager shareInstance]createTaskWithTaskName:@"HealthPlanDailyListTask" taskParam:dicPost TaskObserver:self];
}

- (NSArray *)changeDataList:(NSArray *)array {
    NSMutableArray <PlanMessionListItem *>*tempArr = [NSMutableArray arrayWithArray:array];
    NSMutableArray *tempAllDayArr = [NSMutableArray array];
    [tempArr enumerateObjectsUsingBlock:^(PlanMessionListItem * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.title isEqualToString:@"记饮食"]||
            [model.title isEqualToString:@"记心情"]||
            [model.title isEqualToString:@"做运动"]||
            [model.title isEqualToString:@"记录服药"]||
            [model.title isEqualToString:@"复查"]) {
            [tempAllDayArr addObject:model];
        }
    }];
    
    [tempArr removeObjectsInArray:tempAllDayArr];
    [tempArr addObjectsFromArray:tempAllDayArr];
    
    return tempArr;
}

- (BOOL) dateIsAfterToday:(NSString *)dateString
{

    NSDate* planDate = [NSDate dateWithString:dateString formatString:@"yyyy-MM-dd HH:mm:ss"];
    if ([planDate isTomorrow]) {
        return YES;
    }
    if ([planDate daysFrom:[NSDate date]] > 0)
    {
        return YES;
    }
    return NO;
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

- (void) entryNutrtuin:(PlanMessionListItem*) planItem
{
    
[HMViewControllerManager createViewControllerWithControllerName:@"SENuritionDietRecordsStartViewController" ControllerObject:nil];
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

- (NSString *)dateString {
    NSString* dateStr = [self.selectedDate formattedDateWithFormat:@"yyyy-MM-dd"];
    return dateStr;
}

- (void)completedUserReview:(PlanMessionListItem *)model {
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    [dict setObject:[self.selectedDate formattedDateWithFormat:@"yyyy-MM-dd"] forKey:@"reviewDate"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMCompletedUserReviewRequest" taskParam:dict TaskObserver:self];
    
}

#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlanMessionListItem *tempModel = self.dataList[indexPath.row];
    HMUserMissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HMUserMissionTableViewCell at_identifier]];
    [cell fillDataWithModel:tempModel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlanMessionListItem* planItem = self.dataList[indexPath.row];
    if ([self dateIsAfterToday:planItem.excTime])
    {
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
    
    NSString* code = planItem.code;
    if (!code || 0 == code.length)
    {
        return;
    }
    
    if ( [planItem.status isEqualToString:@"0"])
    {
        // 未开始任务弹框提示
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self.noStartAlterView];
        [self.noStartAlterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(keyWindow);
        }];
        
        self.noStartAlterView.tempModel = planItem;
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
        [HMViewControllerManager createViewControllerWithControllerName:@"MedicationPlanViewStartController" ControllerObject:[self dateString]];
        return;
    }
    if ([code isEqualToString:@"SPORTS"])
    {
        //记运动
        [HMViewControllerManager createViewControllerWithControllerName:@"RecordSportsExecuteViewController" ControllerObject:nil];
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
            [record setFillTime:[self dateString]];
            
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
        else if ([planItem.status isEqualToString:@"1"]) {
            //跳转到随访详情
            EvaluationListRecord *evaluationRecord = [[EvaluationListRecord alloc] init];
            evaluationRecord.itemId = planItem.taskId;
            evaluationRecord.itemType = @"1";
            [HMViewControllerManager createViewControllerWithControllerName:@"EvaluationDetailViewController" ControllerObject:evaluationRecord];
        }
        return;
    }
    
    if ([code isEqualToString:@"WARDS"])
    {
        //查房计划
        if ([planItem.status isEqualToString:@"1"] || [planItem.status isEqualToString:@"3"]) {
            //TODO:跳转到填写查房界面
            [HMViewControllerManager createViewControllerWithControllerName:@"RoundsUnFilledDetailViewController" ControllerObject:[NSString stringWithFormat:@"%@", planItem.taskId]];
        }
        else if ([planItem.status isEqualToString:@"1"]) {
            //TODO:跳转到查房表详情界面
            [HMViewControllerManager createViewControllerWithControllerName:@"RoundsDetailViewController" ControllerObject:[NSString stringWithFormat:@"%@", planItem.taskId]];
        }
        
        return;
    }
    
    if ([code isEqualToString:@"REVIEW"]) {
        if ([planItem.status isEqualToString:@"2"]) {
            // 已完成
            return;
        }
        // 复查
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [self.reviewAlterView fillDataWith:planItem];
        [keyWindow addSubview:self.reviewAlterView];
        [self.reviewAlterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(keyWindow);
        }];
        
        self.reviewAlterView.tempModel = planItem;
        

    }
    

}

#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    
    if (StepError_None != taskError)
    {
        [self at_hideLoading];
        NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
        if (self.block) {
            self.block(!([taskname isEqualToString:@"HealthPlanDailyListTask"] && [errorMessage isEqualToString:@"您还没有健康计划"]));
        }
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
        return;
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
    
    if ([taskname isEqualToString:@"HealthPlanDailyListTask"]) {
        NSDictionary* dicResult = (NSDictionary*) taskResult;
        
        NSArray* items = [dicResult valueForKey:@"list"];
        if (items && [items isKindOfClass:[NSArray class]])
        {
            self.dataList = [self changeDataList:[NSArray arrayWithArray:(NSArray*)items]];
            [self.tableView reloadData];
            if (self.block) {
                self.block(YES);
            }

        }
        
        NSNumber* numExecute = [dicResult valueForKey:@"alertExecute"];
        if (numExecute && [numExecute isKindOfClass:[NSNumber class]])
        {
            NSInteger alertExecute = numExecute.integerValue;
            [self.tableHeadView fillDataWithdoneMissionCount:alertExecute];
        }
        
        NSNumber* numCount = [dicResult valueForKey:@"taskCount"];
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            NSInteger taskCount = numCount.integerValue;
            [self.tableHeadView fillDataWithAllMissionCount:taskCount];
        }

    }
    else if ([taskname isEqualToString:@"HMCompletedUserReviewRequest"]) {
        [self requestHealthTesk];
    }
    
}

#pragma mark - DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无内容" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"666666"]}];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"emptyImage_i"];
}



- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!self.dataList ||self.dataList.count == 0) {
        return YES;
    }
    return NO;
}

#pragma mark - Interface
- (void)checkIsHaveHealthPlan:(isHaveHealthPlan)block {
    self.block = block;
}
#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setRowHeight:70];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
        [_tableView registerClass:[HMUserMissionTableViewCell class] forCellReuseIdentifier:[HMUserMissionTableViewCell at_identifier]];
        [_tableView setTableHeaderView:self.tableHeadView];
    }
    return _tableView;
}

- (HMWeeklySelectDateView *)dateSelectView {
    if (!_dateSelectView) {
        _dateSelectView = [[HMWeeklySelectDateView alloc] initWithStartDate:self.startDate];
        [_dateSelectView dateCellClick:^(NSDate *selectedDate) {
            [self updateVCWithDate:selectedDate];
        }];
    }
    return _dateSelectView;
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

- (HMMainStartNotStartAlterView *)noStartAlterView {
    if (!_noStartAlterView) {
        _noStartAlterView = [HMMainStartNotStartAlterView new];
        [_noStartAlterView btnClickBlock:^(HMMainStartAlterBtnType clickType) {
            [self.noStartAlterView removeFromSuperview];
            switch (clickType) {
                case HMMainStartAlterBtnType_Goon:
                {
                    
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

- (HMSEHealthPlanMissionHeadView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView = [[HMSEHealthPlanMissionHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    }
    return _tableHeadView;
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
