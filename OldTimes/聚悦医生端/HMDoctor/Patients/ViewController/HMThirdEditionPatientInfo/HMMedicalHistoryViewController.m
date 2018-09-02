//
//  HMMedicalHistoryViewController.m
//  HMDoctor
//
//  Created by lkl on 2017/3/15.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import"HMMedicalHistoryViewController.h"
#import "HMMedicalHistoryTableViewCell.h"
#import "HMOnlineArchivesModel.h"

typedef NS_ENUM(NSInteger, MedicalHistoryCellType) {
    MedicalHistoryCellType_nowSection,
    MedicalHistoryCellType_beforeSection,
    MedicalHistoryCellType_familySection,
    MedicalHistoryCellTypeMaxSection,
};

@interface HMMedicalHistoryViewController ()<TaskObserver,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HMJbHistoryListModel *medicalHistoryModel;
@property (nonatomic, strong) NSArray *nowList;
@property (nonatomic, strong) NSArray *beforeList;
@property (nonatomic, strong) NSArray *familyList;
@property (nonatomic, copy) NSString *admissionId;
@end

@implementation HMMedicalHistoryViewController

- (instancetype)initWithUserID:(NSString *)userID admissionId:(NSString *)admissionId
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
        make.edges.equalTo(self.view);
    }];
    
    //请求数据
    [self startPatientInfoRequest];
}

- (void)startPatientInfoRequest {
    if (!self.userId || self.userId.length == 0) {
        return;
    }
    
    [self startRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createDateChanged:) name:@"OnlineArchivesDateChangedNotification" object:nil];
}

- (void)createDateChanged:(NSNotification *)notification
{
    _admissionId = [notification object];
    [self startRequest];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startRequest
{
    NSLog(@"%@",self.userId);
    //获取患者的信息
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:self.userId forKey:@"userId"];
    [dicPost setValue:self.admissionId forKey:@"admissionId"];
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"getJbHistoryListTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return MedicalHistoryCellTypeMaxSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case MedicalHistoryCellType_nowSection:
            return self.nowList.count ? self.nowList.count : 0;
            break;
            
        case MedicalHistoryCellType_beforeSection:
            return self.beforeList.count ? self.beforeList.count : 0;
            break;
            
        case MedicalHistoryCellType_familySection:
            return self.familyList.count ? self.familyList.count : 0;
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case MedicalHistoryCellType_nowSection:
            return self.nowList.count ? 40 : 0.001;
            break;
            
        case MedicalHistoryCellType_beforeSection:
            return self.beforeList.count ? 40 : 0.001;
            break;
            
        case MedicalHistoryCellType_familySection:
            return self.familyList.count ? 40 : 0.001;
            break;
            
        default:
            break;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *patientInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    [patientInfoView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbTitle = [UILabel new];
    [lbTitle setFont:[UIFont font_32]];
    [lbTitle setTextColor:[UIColor colorWithHexString:@"333333"]];
    [lbTitle setHidden:YES];
    
    UIView *lineView = [UIView new];
    [lineView setBackgroundColor:[UIColor mainThemeColor]];
    [lineView setHidden:YES];
    
    UIView *bottomLine = [UIView new];
    [bottomLine setBackgroundColor:[UIColor commonLightGrayColor_ebebeb]];
    
    [patientInfoView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(patientInfoView).offset(15);
        make.centerY.equalTo(patientInfoView);
        make.size.mas_equalTo(CGSizeMake(3, 20));
    }];
    
    [patientInfoView addSubview:lbTitle];
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(5);
        make.centerY.equalTo(patientInfoView);
        make.height.mas_equalTo(@20);
    }];
    
    [patientInfoView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(patientInfoView);
        make.bottom.equalTo(patientInfoView.mas_bottom).offset(-1);
        make.height.mas_equalTo(@1);
    }];
    
    switch (section) {
        case MedicalHistoryCellType_nowSection:
        {
            if (self.nowList && self.nowList.count > 0) {
                [lbTitle setHidden:NO];
                [lineView setHidden:NO];
                [lbTitle setText:@"现病史"];
            }
            else{
                return nil;
            }
            
            break;
        }
            
        case MedicalHistoryCellType_beforeSection:
        {
            if (self.beforeList && self.beforeList.count > 0) {
                [lbTitle setHidden:NO];
                [lineView setHidden:NO];
                [lbTitle setText:@"既往史"];
            }
            else{
                return nil;
            }
            break;
        }
            
        case MedicalHistoryCellType_familySection:
        {
            if (self.familyList && self.familyList.count > 0) {
                [lbTitle setHidden:NO];
                [lineView setHidden:NO];
                [lbTitle setText:@"家族史"];
            }
            else{
                return nil;
            }
            
            break;
        }
            
        default:
            break;
    }
    
    return patientInfoView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case MedicalHistoryCellType_nowSection:
            return self.nowList.count ? [self nowCellHeight:indexPath] : 0;
            break;
            
        case MedicalHistoryCellType_beforeSection:
            return self.beforeList.count ? [self beforeCellHeight:indexPath] : 0;
            break;
            
        case MedicalHistoryCellType_familySection:
            return self.familyList.count ? [self familyCellHeight:indexPath] : 0;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case MedicalHistoryCellType_nowSection:
        {
            HMHistoryIllnessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell)
            {
                cell = [[HMHistoryIllnessTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            HMNowListModel *nowModel = [self.nowList objectAtIndex:indexPath.row];
            [cell setHistoryIllnessNowInfo:nowModel];
            return cell;
        }
            break;
            
        case MedicalHistoryCellType_beforeSection:
        {
            HMBeforListModel *beforeModel = [self.beforeList objectAtIndex:indexPath.row];
            
            if ([beforeModel.PMH_TYPE isEqualToString:@"1"])
            {
                HMHistoryIllnessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HMHistoryIllnessTableViewCell"];
                if (!cell)
                {
                    cell = [[HMHistoryIllnessTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HMHistoryIllnessTableViewCell"];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                
                [cell setHistoryIllnessBeforeInfo:beforeModel];
                return cell;
            }
            else{
                
                HMBeforeHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HMBeforeHistoryTableViewCell"];
                if (!cell)
                {
                    cell = [[HMBeforeHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HMBeforeHistoryTableViewCell"];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                
                [cell setHistoryIllnessBeforeInfo:beforeModel];
                return cell;

            }
        }
            break;
            
        case MedicalHistoryCellType_familySection:
        {
            HMFamilyHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HMFamilyHistoryTableViewCell"];
            if (!cell)
            {
                cell = [[HMFamilyHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HMFamilyHistoryTableViewCell"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            HMFamilyListModel *familyModel = [self.familyList objectAtIndex:indexPath.row];
            [cell setFamilyHistoryInfo:familyModel];
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
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
    
    if ([taskname isEqualToString:@"getJbHistoryListTask"])
    {
        if ([taskResult isKindOfClass:[NSDictionary class]]){
            
            NSDictionary *dicResult = (NSDictionary *)taskResult;
            
            self.nowList = [dicResult objectForKey:@"nowList"];
            self.beforeList = [dicResult objectForKey:@"beforeList"];
            self.familyList = [dicResult objectForKey:@"familyList"];
            
            //刷新
            [self.tableView reloadData];
        }
    }
}

#pragma mark - init UI
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        //_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}

- (CGFloat)nowCellHeight:(NSIndexPath *)indexPath
{
    HMNowListModel *nowModel = [self.nowList objectAtIndex:indexPath.row];
    NSString *str = [NSString stringWithFormat:@"近期情况：%@",nowModel.RECENT_DESC];
    CGFloat descHeight = [str heightSystemFont:[UIFont font_28] width:(self.tableView.width - 25)] + 2;
    return descHeight + 70 + 10;
}

- (CGFloat)beforeCellHeight:(NSIndexPath *)indexPath
{
    HMBeforListModel *beforeModel = [self.beforeList objectAtIndex:indexPath.row];
    
    if (![beforeModel.PMH_TYPE isEqualToString:@"1"]) {
        return 40;
    }
    NSString *str = [NSString stringWithFormat:@"结局：%@",beforeModel.END_TYPE];
    CGFloat descHeight = [str heightSystemFont:[UIFont font_28] width:(self.tableView.width - 25)] + 2;
    return descHeight + 70 + 10;
}

- (CGFloat)familyCellHeight:(NSIndexPath *)indexPath
{
    HMFamilyListModel *familyModel = [self.familyList objectAtIndex:indexPath.row];
    if (familyModel.SHIP_TYPE.length <= 0) {
        return 40;
    }
    CGFloat descHeight = [familyModel.SHIP_TYPE heightSystemFont:[UIFont font_28] width:(self.tableView.width - 25)] + 2;
    return descHeight + 40 + 20;
}


#pragma mark - DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"img_blank_list"];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (self.nowList.count == 0 && self.beforeList.count == 0 && self.familyList.count == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -68;
}
@end
