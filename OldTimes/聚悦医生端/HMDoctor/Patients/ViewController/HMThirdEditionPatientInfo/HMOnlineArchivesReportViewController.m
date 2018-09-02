//
//  HMOnlineArchivesReportViewController.m
//  HMDoctor
//
//  Created by lkl on 2017/3/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMOnlineArchivesReportViewController.h"
#import "HMOnlineReportTableViewCell.h"
#import "AdmissionAssessSummaryModel.h"

typedef NS_ENUM(NSUInteger, ReportItem) {
    ReportItem_dia,
    ReportItem_Report,
};

@interface HMOnlineArchivesReportViewController ()<TaskObserver,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *admissionId;
@property (nonatomic, strong) NSArray *bfzResultList;
@property (nonatomic, strong) NSArray *jbResultList;

@end

@implementation HMOnlineArchivesReportViewController

- (instancetype)initWithUserID:(NSString *)userID  admissionId:(NSString *)admissionId
{
    self = [super init];
    if (self) {
        _userId = userID;
        _admissionId = admissionId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(5);
    }];
    
    [self getAdmissionAssessSummaryData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createDateChanged:) name:@"OnlineArchivesDateChangedNotification" object:nil];
}

- (void)createDateChanged:(NSNotification *)notification
{
    _admissionId = [notification object];
    [self getAdmissionAssessSummaryData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getAdmissionAssessSummaryData{
    
    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    [dicPost setObject:self.admissionId forKey:@"admissionId"];
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"getAdmissionAssessSummaryTask" taskParam:dicPost TaskObserver:self];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.bfzResultList.count > 0) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;

        case 1:
            return self.bfzResultList.count;
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return self.jbResultList.count ? [self jbResultMaxHeight] : 45;
            break;
            
        case 1:
            return [self bfzResultMaxHeight:indexPath];
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *patientInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [patientInfoView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *lineView = [UIView new];
    [lineView setBackgroundColor:[UIColor mainThemeColor]];
    
    [patientInfoView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(patientInfoView).offset(15);
        make.centerY.equalTo(patientInfoView);
        make.size.mas_equalTo(CGSizeMake(3, 20));
    }];
    
    UILabel *titleLb = [UILabel new];
    [titleLb setFont:[UIFont font_32]];
    [titleLb setTextColor:[UIColor colorWithHexString:@"333333"]];
    
    [patientInfoView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(5);
        make.centerY.equalTo(patientInfoView);
        make.height.mas_equalTo(@20);
    }];
    
    UIView *bottomLine = [UIView new];
    [bottomLine setBackgroundColor:[UIColor commonLightGrayColor_ebebeb]];
    [patientInfoView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(patientInfoView);
        make.bottom.equalTo(patientInfoView.mas_bottom).offset(-1);
        make.height.mas_equalTo(@1);
    }];
    
    switch (section) {
        case 0:
            [titleLb setText:@"诊断"];
            break;
            
        case 1:
            [titleLb setText:@"并发症风险评估"];
            break;
            
        default:
            break;
    }
    
    return patientInfoView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    switch (indexPath.section) {
        case 0:
        {
            HMDiagnoseReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell)
            {
                cell = [[HMDiagnoseReportTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            [cell fillDiagnoseDataList:self.jbResultList];
            return cell;
            break;
        }

        case 1:
        {
            HMOnlineReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HMOnlineReportTableViewCell"];
            if (!cell)
            {
                cell = [[HMOnlineReportTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HMOnlineReportTableViewCell"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            
            BfzResultListModel *model = [self.bfzResultList objectAtIndex:indexPath.row];
            [cell setBfzResultListModel:model];
            return cell;
            break;
        }
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        BfzResultListModel *model = [self.bfzResultList objectAtIndex:indexPath.row];
        [HMViewControllerManager createViewControllerWithControllerName:@"IMEvaluationDetailViewController" ControllerObject:model];
    }
}

#pragma mark - init UI

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
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
    
    if ([taskname isEqualToString:@"getAdmissionAssessSummaryTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dicResult = taskResult;
            self.bfzResultList = [dicResult valueForKey:@"bfzResultList"];
            self.jbResultList = [dicResult valueForKey:@"jbResultList"];

            [self.tableView reloadData];
        }
    }
}


//第一区行高
- (CGFloat)jbResultMaxHeight
{
    __block NSMutableArray *tempArr = [NSMutableArray array];
    __block NSString *mainDiagnose = @"";
    [self.jbResultList enumerateObjectsUsingBlock:^(HMThirdEditionPatitentDiagnoseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.orderIndex == 1) {
            mainDiagnose = obj.diseaseName;
        }
        else {
            [tempArr addObject:obj.diseaseName];
        }
    }];
    
    NSString *mainDiagnoseStr = [NSString stringWithFormat:@"主要诊断：%@",mainDiagnose];
    CGFloat mainDiagHeight = [mainDiagnoseStr heightSystemFont:[UIFont font_28] width:(self.tableView.width - 25)] + 2;
    
    if (tempArr.count == 0) {
        return mainDiagHeight + 20;
    }
    
    NSString *str = [NSString stringWithFormat:@"次要诊断：%@",[self acquireStringWithArray:tempArr separator:@" ;"]];
    
    CGFloat descHeight = [str heightSystemFont:[UIFont font_28] width:(self.tableView.width - 25)] + 2;
    return descHeight + mainDiagHeight + 30;
}

//第二区行高
- (CGFloat)bfzResultMaxHeight:(NSIndexPath *)indexPath
{
    BfzResultListModel *model = [self.bfzResultList objectAtIndex:indexPath.row];
    NSMutableArray *evaluateResult = [NSMutableArray array];
    [model.evaluateResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [evaluateResult addObject:obj];
    }];
    
    if (evaluateResult.count == 0)
    {
        return 40;
    }
    NSString *str = [self acquireStringWithArray:evaluateResult separator:@" ;"];
    CGFloat descHeight = [str heightSystemFont:[UIFont font_28] width:(self.tableView.width - 25)] + 2;
    return descHeight + 40 + 10;
}

- (NSString *)acquireStringWithArray:(NSArray *)array separator:(NSString *)separator{
    __block NSString *tempString = @"";
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj length]) {
            if (!tempString.length ) {
                tempString = obj;
            }
            else {
                tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%@%@",separator,obj]];
            }
            
        }
        
    }];
    return tempString;
}

@end
