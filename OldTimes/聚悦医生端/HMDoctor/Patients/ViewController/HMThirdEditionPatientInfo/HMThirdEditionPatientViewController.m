//
//  HMThirdEditionPatientViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/1/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMThirdEditionPatientViewController.h"
#import "HMThirdEditionPatitentInfoReportTableViewCell.h"
#import "HMThirdEditionPatitentInfoHeaderTableViewCell.h"
#import "HMThirdEditionPatitentInfoRequest.h"
#import "HMThirdEditionPatitentInfoModel.h"
#import "HMBaseInfoServiceTableViewCell.h"
#import "HMRecentMedicalTableViewCell.h"

typedef NS_ENUM(NSUInteger, ThirdEditionPaidPatientInfoSection){
    
    ThirdEditionPaidPatientInfoSection_headerSection,       //患者
    ThirdEditionPaidPatientInfoSection_serviceInfoSection,  //服务信息
    ThirdEditionPaidPatientInfoSection_patientInfoSection,  //人口学信息
    ThirdEditionPaidPatientInfoSection_diagnosisSection,    //诊断
    ThirdEditionPaidPatientInfoSection_RecentMedSection,    //近期用药
    ThirdEditionPaidPatientInfoSection_reportsSection,      //评估
    ThirdEditionPaidPatientInfoSectionSectionMax,
};

typedef NS_ENUM(NSUInteger, ThirdEditionPaidPatientInfoCellType) {
    ThirdEditionPaidPatientInfoCellType_name,                 //紧急联系人
    ThirdEditionPaidPatientInfoCellType_relation,             //关系
    ThirdEditionPaidPatientInfoCellType_phone,                //联系电话
    ThirdEditionPaidPatientInfoCellType_edu,                  //受教育程度
    ThirdEditionPaidPatientInfoCellType_profession,           //职业
    ThirdEditionPaidPatientInfoCellType_payWay,               //付费方式
    ThirdEditionPaidPatientInfoCellType_address,              //地址
    ThirdEditionPaidPatientInfoCellTypeIndexMax,
};
@interface HMThirdEditionPatientViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, readwrite)  BOOL  needRequestUserInfo; // <##>
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) HMThirdEditionPatitentInfoModel *model;

//@property (nonatomic, strong) UIButton *onlineArchiveButton;
@property (nonatomic, assign) BOOL isShowService; //是否显示服务信息

@property (nonatomic, strong) NSArray *recentDugs;
@property (nonatomic, assign) BOOL isShowMoreMedicine;

@end

@implementation HMThirdEditionPatientViewController

- (instancetype)initWithUserID:(NSString *)userID {
    self = [super init];
    if (self) {
        _userId = userID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needRequestUserInfo = YES;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"基础档案";
    
    [self reloadPatientInfoWithUserID:self.userId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
}

- (void)onlineArchiveButtonClick
{
    [HMViewControllerManager createViewControllerWithControllerName:@"HMOnlineArchivesViewController" ControllerObject:self.userId] ;
}

- (ThirdEditionPaidPatientInfoCellType)cellTypeWithIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section + indexPath.row;
}

- (void)startPatientInfoRequest {
    if (!self.userId || self.userId.length == 0) {
        return;
    }
    //获取患者的信息
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:self.userId forKey:@"userId"];
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMThirdEditionPatitentInfoRequest" taskParam:dicPost TaskObserver:self];
}

#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
            
        case ThirdEditionPaidPatientInfoSection_headerSection:
            return 60;
            break;
        
        case ThirdEditionPaidPatientInfoSection_serviceInfoSection:
            return self.isShowService ? 100 : 0;
            break;
            
        case ThirdEditionPaidPatientInfoSection_diagnosisSection:
            return self.model.userIDC.count ? [self jbResultMaxHeight] : 65;
            break;
            
        case ThirdEditionPaidPatientInfoSection_patientInfoSection:
            return self.model.userArchiveInfo ? 25 : 0;
            break;
            
        case ThirdEditionPaidPatientInfoSection_RecentMedSection:
            return !kArrayIsEmpty(_recentDugs) ? 90 : 0;
            break;
            
        case ThirdEditionPaidPatientInfoSection_reportsSection:
            return self.model.assessList.count ? 25+(self.model.assessList.count)*40 : 65;
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
            
        case ThirdEditionPaidPatientInfoSection_headerSection:
        case ThirdEditionPaidPatientInfoSection_diagnosisSection:
            return 1;
            break;
            
        case ThirdEditionPaidPatientInfoSection_serviceInfoSection:
        {
            return self.isShowService ? 1 : 0;
            break;
        }
            
        case ThirdEditionPaidPatientInfoSection_patientInfoSection:
            return self.model.userArchiveInfo ? ThirdEditionPaidPatientInfoCellTypeIndexMax : 0;
            break;
            
        case ThirdEditionPaidPatientInfoSection_RecentMedSection:
        {
            if (kArrayIsEmpty(_recentDugs)) {
                return 0;
            }
            
            //如果大于2条，显示两条、更多按钮
            if (_recentDugs.count > 2 && !_isShowMoreMedicine) {
                return 2;
            }
            return _recentDugs.count;
            break;
        }

        case ThirdEditionPaidPatientInfoSection_reportsSection:
            return 1;
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ThirdEditionPaidPatientInfoSectionSectionMax;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case ThirdEditionPaidPatientInfoSection_serviceInfoSection:
            return self.isShowService ? 35 : 0.001;
            break;
            
        case ThirdEditionPaidPatientInfoSection_patientInfoSection:
            return self.model.userArchiveInfo ? 35 : 0.001;
            break;
            
        case ThirdEditionPaidPatientInfoSection_RecentMedSection:
            return !kArrayIsEmpty(_recentDugs) ? 35 : 0.001;
            break;
            
        default:
            return 0.001;
            break;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    switch (section) {
        case ThirdEditionPaidPatientInfoSection_patientInfoSection:
        case ThirdEditionPaidPatientInfoSection_serviceInfoSection:
        case ThirdEditionPaidPatientInfoSection_RecentMedSection:
        {
            UIView *patientInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
            [patientInfoView setBackgroundColor:[UIColor whiteColor]];
            
            UILabel *titelLb = [UILabel new];
            [titelLb setFont:[UIFont font_32]];
            [titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
            
            UIView *lineView = [UIView new];
            [lineView setBackgroundColor:[UIColor mainThemeColor]];
            
            [patientInfoView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(patientInfoView).offset(15);
                make.centerY.equalTo(patientInfoView);
                make.size.mas_equalTo(CGSizeMake(3, 20));
            }];
            
            [patientInfoView addSubview:titelLb];
            [titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lineView.mas_right).offset(5);
                make.centerY.equalTo(patientInfoView);
                make.height.mas_equalTo(@20);
            }];
            
            if (!self.isShowService && section == ThirdEditionPaidPatientInfoSection_serviceInfoSection)
            {
                UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
                return headerView;
            }
            
            if (!self.model.userArchiveInfo && section == ThirdEditionPaidPatientInfoSection_patientInfoSection) {
                UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
                return headerView;
            }
            
            if (kArrayIsEmpty(_recentDugs) && section == ThirdEditionPaidPatientInfoSection_RecentMedSection) {
                UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
                return headerView;
            }
            
            if (self.model.userArchiveInfo && section == ThirdEditionPaidPatientInfoSection_patientInfoSection) {
                [titelLb setText:@"人口学信息"];
            }
            
            if (self.isShowService && section == ThirdEditionPaidPatientInfoSection_serviceInfoSection)
            {
                [titelLb setText:@"服务信息"];
            }
            
            if (!kArrayIsEmpty(_recentDugs) && section == ThirdEditionPaidPatientInfoSection_RecentMedSection){
                [titelLb setText:@"近期用药"];
            }
            return patientInfoView;
            break;
        }
            
        default:
        {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
            return headerView;
        }
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    switch (section) {
        case ThirdEditionPaidPatientInfoSection_serviceInfoSection:
            return self.isShowService ? 5 : 0.001;
            break;
            
        case ThirdEditionPaidPatientInfoSection_patientInfoSection:
            return self.model.userArchiveInfo ? 5 : 0.001;
            break;
            
        case ThirdEditionPaidPatientInfoSection_RecentMedSection:
        {
            if (kArrayIsEmpty(_recentDugs)) {
                return 0.001;
            }
            
            if (_recentDugs.count > 2) {
                return _isShowMoreMedicine ? 5 : 40;
            }
            return 5;
            break;
        }
            
        default:
            return 5;
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_recentDugs.count > 2 && !_isShowMoreMedicine && section == ThirdEditionPaidPatientInfoSection_RecentMedSection) {
        //显示更多
        UIView *recentMedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        [recentMedView setBackgroundColor:[UIColor whiteColor]];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMoreClick)];
        [recentMedView addGestureRecognizer:tapGesturRecognizer];
        
        UILabel *titelLb = [UILabel new];
        [titelLb setFont:[UIFont font_28]];
        [titelLb setText:@"更多"];
        [titelLb setTextColor:[UIColor commonGrayTextColor]];

        [recentMedView addSubview:titelLb];
        [titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(recentMedView);
            make.centerX.equalTo(recentMedView).offset(-10);
        }];
        
        UIImageView *ivAdd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_more1"]];
        [recentMedView addSubview:ivAdd];
        
        [ivAdd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titelLb.mas_right).offset(3);
            make.centerY.equalTo(recentMedView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        UIView *footerView = [UIView new];
        [recentMedView addSubview:footerView];
        [footerView setBackgroundColor:[UIColor colorWithHexString:@"E7E7E7"]];
        
        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(recentMedView);
            make.height.mas_equalTo(@5);
        }];
        
        return recentMedView;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    switch (indexPath.section) {
        case ThirdEditionPaidPatientInfoSection_headerSection:
        {
            cell = [[HMThirdEditionPatitentInfoHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([HMThirdEditionPatitentInfoHeaderTableViewCell class])];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

            [cell setPatientInfoHeader:self.model];
            break;
        }
            
        case ThirdEditionPaidPatientInfoSection_serviceInfoSection:
        {
            cell = [[HMBaseInfoServiceTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([HMBaseInfoServiceTableViewCell class])];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setServiceInfo:self.model];
            break;
        }
            
        case ThirdEditionPaidPatientInfoSection_patientInfoSection:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            if (!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [[cell textLabel] setTextColor:[UIColor commonGrayTextColor]];
                [[cell textLabel] setFont:[UIFont font_28]];
                //[cell setSeparatorColor:[UIColor whiteColor]];
            }
            NSString *titel = @"";
            NSString *content = @"";
            HMThirdEditionPatitentArchiveInfoModel *userArchiveInfo = self.model.userArchiveInfo;
                switch (indexPath.row) {
                    case ThirdEditionPaidPatientInfoCellType_name:
                    {
                        titel = @"紧急联系人：";
                        content = userArchiveInfo.contactName ? userArchiveInfo.contactName : @"未填写";
                        break;
                    }
                    case ThirdEditionPaidPatientInfoCellType_relation:
                    {
                        titel = @"关系：";
                        content = userArchiveInfo.contactRelation ? userArchiveInfo.contactRelation : @"未填写";
                        break;
                    }
                    case ThirdEditionPaidPatientInfoCellType_phone:
                    {
                        titel = @"联系电话：";
                        content = userArchiveInfo.contactMobile ? userArchiveInfo.contactMobile : @"未填写";
                        break;
                    }
                    case ThirdEditionPaidPatientInfoCellType_edu:
                    {
                        titel = @"受教育程度：";
                        content = userArchiveInfo.educationLevel ? userArchiveInfo.educationLevel : @"未填写";
                        break;
                    }
                    case ThirdEditionPaidPatientInfoCellType_profession:
                    {
                        titel = @"职业：";
                        content = self.model.userArchiveInfo.profession ? self.model.userArchiveInfo.profession : @"未填写";
                        break;
                    }
                    case ThirdEditionPaidPatientInfoCellType_payWay:
                    {
                        titel = @"主要医疗付费方式：";
                        content = userArchiveInfo.medicalPayment ? userArchiveInfo.medicalPayment : @"未填写";
                        break;
                    }
                    case ThirdEditionPaidPatientInfoCellType_address:
                    {
                        titel = @"现居地址：";
                        content = userArchiveInfo.presentRegionFullName ? userArchiveInfo.presentRegionFullName : @"未填写";
                        break;
                    }
                    default:
                        break;
                }

                [[cell textLabel] setText:[NSString stringWithFormat:@"%@%@",titel,content]];
                break;
        }
            
        case ThirdEditionPaidPatientInfoSection_diagnosisSection:
        {
            cell = [[HMThirdEditionPatitentInfoReportTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([HMThirdEditionPatitentInfoReportTableViewCell class])];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            //诊断
            [cell fillDiagnoseDataWithModel:self.model];
            break;
        }
            
        case ThirdEditionPaidPatientInfoSection_RecentMedSection:
        {
            cell = [[HMRecentMedicalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[HMRecentMedicalTableViewCell at_identifier]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            if (!kArrayIsEmpty(_recentDugs)) {
                HMRecentMedicalModel *recentModel = [_recentDugs objectAtIndex:indexPath.row];
                [cell setRecentMedicalInfo:recentModel];
            }
            
            break;
        }

        case ThirdEditionPaidPatientInfoSection_reportsSection:
        {
                
            cell = [[HMThirdEditionPatitentInfoReportTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([HMThirdEditionPatitentInfoReportTableViewCell class])];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
            //健康风险评估
            [cell fillHealthRiskDataWithModel:self.model];
            
            //查看筛查表
            if ([self.model.screeningResultPage isEqualToString:@"Y"]) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:self.userId forKey:@"userId"];
                [dic setObject:self.model.admissionId forKey:@"admissionId"];
                __weak typeof(self) weakSelf = self;
                [cell setIsScreeningResultPageBlock:^{
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    if (strongSelf.model.admissionId) {
                        [HMViewControllerManager createViewControllerWithControllerName:@"HMScreeningInventoryViewController" ControllerObject:dic];
                    }
                }];
            }
            break;
        }

        default:
            break;
    }
    return cell;
}

#pragma mark - request Delegate
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError ) {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
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
    
    if ([taskname isEqualToString:@"HMThirdEditionPatitentInfoRequest"])
    {
        self.needRequestUserInfo = NO;
        self.model = taskResult;
        
        //是否可以查看在院档案
//        if ([self.model.admissionAssessAble isEqualToString:@"Y"]) {
//            
//            [self.onlineArchiveButton setHidden:NO];
//            [self.view addSubview:self.onlineArchiveButton];
//            [self.onlineArchiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.and.right.equalTo(self.view);
//                make.bottom.equalTo(self.view);
//                make.height.mas_offset(@50);
//            }];
//            
//            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.bottom.equalTo(self.view).with.offset(-55);
//            }];
//        }
        
        //是否显示服务信息分区
        if (self.model.serviceName && self.model.serviceMoney) {
            self.isShowService = YES;
        }
        
        //近期用药分区
        if (!kArrayIsEmpty(self.model.recentDugs))
        {
            _recentDugs = [HMRecentMedicalModel mj_objectArrayWithKeyValuesArray:self.model.recentDugs];
        }
        
        [self.tableView reloadData];
    }
    
}

#pragma mark -- Click
- (void)tapMoreClick
{
    _isShowMoreMedicine = YES;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:ThirdEditionPaidPatientInfoSection_RecentMedSection] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Interface
- (void)reloadPatientInfoWithUserID:(NSString *)userID {
    self.userId = userID;
    [self startPatientInfoRequest];
}
#pragma mark - init UI

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        //_tableView.estimatedRowHeight = 60;
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorColor:[UIColor clearColor]];
        [_tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    }
    return _tableView;
}

//- (UIButton *)onlineArchiveButton{
//    if (!_onlineArchiveButton) {
//        _onlineArchiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_onlineArchiveButton setBackgroundColor:[UIColor mainThemeColor]];
//        [_onlineArchiveButton setTitle:@"在院档案" forState:UIControlStateNormal];
//        [_onlineArchiveButton.titleLabel setTextColor:[UIColor whiteColor]];
//        [_onlineArchiveButton.titleLabel setFont:[UIFont font_30]];
//        [_onlineArchiveButton addTarget:self action:@selector(onlineArchiveButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        [_onlineArchiveButton setHidden:YES];
//    }
//    return _onlineArchiveButton;
//}

//诊断行高
- (CGFloat)jbResultMaxHeight
{
    __block NSMutableArray *tempArr = [NSMutableArray array];
    __block NSString *mainDiagnose = @"";
    [self.model.userIDC enumerateObjectsUsingBlock:^(HMThirdEditionPatitentDiagnoseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.orderIndex == 1) {
            mainDiagnose = obj.diseaseName;
        }
        else {
            [tempArr addObject:obj.diseaseName];
        }
    }];

    NSString *mainDiagnoseStr = [NSString stringWithFormat:@"主要诊断：%@",mainDiagnose];
    CGFloat mainDiagHeight = [mainDiagnoseStr heightSystemFont:[UIFont font_28] width:(self.tableView.width - 25 - 80)] + 2;
    
    if (tempArr.count == 0) {
        return 40 + mainDiagHeight + 5;
    }
    
    NSString *str = [NSString stringWithFormat:@"次要诊断：%@",[self acquireStringWithArray:tempArr separator:@" ;"]];
    
    CGFloat descHeight = [str heightSystemFont:[UIFont font_28] width:(self.tableView.width - 25 - 80)] + 2;
    return 40 + descHeight + mainDiagHeight + 5;
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
