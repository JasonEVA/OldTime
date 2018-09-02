//
//  NewSiteMessageItemListViewController.m
//  HMClient
//
//  Created by jasonwang on 2016/10/31.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageItemListViewController.h"
#import "NewSiteMessageItemListAdapater.h"
#import "ATModuleInteractor+NewSiteMessage.h"
#import "UIImage+EX.h"
#import "HMSessionListInteractor.h"
#import "SiteMessageSecondEditionMainListModel.h"
#import "NewSiteMessageGetMessageWithTypeRequest.h"
#import "SiteMessageLastMsgModel.h"
#import "NewSiteMessageRoundsAlterView.h"
#import "NewSiteMeaageRoundsDetailViewController.h"
#import "NewSiteMessageGetWardsRoundStatusRequest.h"
#import "NewSiteMessageRoundsStatusModel.h"
#import "PersonCommentViewController.h"
#import "NewSiteMessageServiceCommentModel.h"
#import "AppointmentInfo.h"
#import "HealthEducationItem.h"
#import "NewSiteMessageGetAssessStatusModel.h"
#import "EvaluationListRecord.h"
#import "HealthPlanInfo.h"
#import "HMRainysEmptyView.h"
#import "NewSiteMessageSetViewController.h"
#import "NewPatientCommentViewController.h"
#import "NewSiteMessageMonitorRemindModel.h"
#import "DetectRecord.h"
#import <MWPhotoBrowser-ADS/MWPhotoBrowser.h>

#define PAGECOUNT   10
static NSString* const kHMControllerPatientMsgModuleHostNot = @"patientMsg"; //站内信

@interface NewSiteMessageItemListViewController ()<ATTableViewAdapterDelegate,TaskObserver,MWPhotoBrowserDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NewSiteMessageItemListAdapater *adapter;
@property (nonatomic, strong) UIButton *askDoctorBtn;
@property (nonatomic, strong) SiteMessageSecondEditionMainListModel *model;
@property (nonatomic) long long lastTimeStamp;        //最后一条时间戳
@property (nonatomic, strong) id currentSelectCellData;  //当前选中cell数据
@property (nonatomic) BOOL roundsCurrentSelectStatus;    //当前打开查房信息选择情况
@property (nonatomic, strong) HMRainysEmptyView *emptyView;    //空白页
@property (nonatomic,strong) NSMutableArray * arrayPhotos;
@property (nonatomic,strong) MWPhotoBrowser * photoBrowser ;
@end

@implementation NewSiteMessageItemListViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithSiteType:(SiteMessageSecondEditionMainListModel *)model {
    if (self = [super init]) {
        self.title = model.typeName;
        self.model = model;
        [self checkShowAskDoctor];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLoadDataList) name:kHMControllerPatientMsgModuleHostNot object:nil];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[SiteMessageSecondEditionMainListModel class]])
    {
        self.model = (SiteMessageSecondEditionMainListModel*) self.paramObject;
        self.title = self.model.typeName;
        [self checkShowAskDoctor];
    }
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NewSite_sz"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    
    [self.navigationItem setRightBarButtonItem:rightBtn];

    [self.view addSubview:self.tableView];
    self.lastTimeStamp = 0;
    if (self.askDoctorBtn) {
        [self.view addSubview:self.askDoctorBtn];
        [self.askDoctorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.equalTo(@45);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.askDoctorBtn.mas_top);
        }];
    }
    else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self.view addSubview:self.emptyView];

    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView);
    }];

    [self startMessageListRequest];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.model.typeCode isEqualToString:@"WDYZ"]) {
        [self reLoadDataList];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.adapter.player = nil;
    [[self.adapter.lastCell voiceImages] stopAnimating];

}
#pragma mark -private method
- (void)reLoadDataList {
    [self.adapter.adapterArray removeAllObjects];
    self.lastTimeStamp = 0;
    [self startMessageListRequest];
}
- (void)checkShowAskDoctor {
    if ([self.model.typeCode isEqualToString:@"YSGH"]) {
        self.askDoctorBtn = [[UIButton alloc] init];
        [self.askDoctorBtn setTitle:@"问医生" forState:UIControlStateNormal];
        [self.askDoctorBtn setBackgroundImage:[UIImage at_imageWithColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [self.askDoctorBtn addTarget:self action:@selector(ackDoctorClick) forControlEvents:UIControlEventTouchUpInside];
        [self.askDoctorBtn setEnabled:[UserServicePrivilegeHelper userHasPrivilege:ServicePrivile_Conversation]];
    }
}
- (void)configElements {
}

- (void)startMessageListRequest {
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [dicPost setValue:@(curUser.userId) forKey:@"userId"];
    [dicPost setValue:self.model.typeCode forKey:@"typeCode"];
    [dicPost setValue:@(PAGECOUNT) forKey:@"limit"];
    [dicPost setValue:@(self.lastTimeStamp) forKey:@"timeStamp"];

    [[TaskManager shareInstance] createTaskWithTaskName:@"NewSiteMessageGetMessageWithTypeRequest" taskParam:dicPost TaskObserver:self];
    [self.view showWaitView];

}
//获取查房状态请求
- (void)startRoundsStatusRequestWithModel:(NewSiteMessageRoundsModel *)model {
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [dicPost setValue:@(curUser.userId) forKey:@"userId"];
    [dicPost setValue:model.recordId forKey:@"recordId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"NewSiteMessageGetWardsRoundStatusRequest" taskParam:dicPost TaskObserver:self];
    [self.view showWaitView];
}

//获取随访状态请求
- (void)startSurveryStatusRequestWithModel:(NewSiteMessageRoundsModel *)model {
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [dicPost setValue:@(curUser.userId) forKey:@"userId"];
    [dicPost setValue:model.recordId forKey:@"recordId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"NewSiteMessageGetSurveryStatusRequest" taskParam:dicPost TaskObserver:self];
    [self.view showWaitView];
}

//获取评估状态请求
- (void)startAssessStatusRequestWithModel:(NewSiteMessageAssessModel *)model {
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    [dicPost setValue:@(model.recordId) forKey:@"recordId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"NewSiteMessageGetAssessStatusRequest" taskParam:dicPost TaskObserver:self];
    [self.view showWaitView];
}

//处理查房是否操作
- (void)startDealWithRoundsWithModel:(NewSiteMessageRoundsModel *)model tag:(NSInteger)tag {
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];

    [dicPost setValue:@(curUser.userId) forKey:@"userId"];
    [dicPost setValue:model.recordId forKey:@"recordId"];
    [dicPost setValue:@(tag) forKey:@"replyStatus"];
    [dicPost setValue:@(0) forKey:@"feedBackType"];
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMIMCELLFeedBackPatientRoundsRequest" taskParam:dicPost TaskObserver:self];
}

- (void)pullRefreshData {
    [self startMessageListRequest];
}

- (void)scrollToBottomWithAnimated:(BOOL)animated {
    ATLog(@"站内信0.1s后滑动到底部");
    [self scrollToBottomIfNeed:YES animated:NO];
}


- (void)scrollToBottomIfNeed:(BOOL)isNeed animated:(BOOL)animated {
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if (rows <= 0 || !isNeed) {
        return;
    }
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:rows - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

//处理查房状态接口返回方法
- (void)dealWithRoundStatusWith:(NewSiteMessageRoundsStatusModel *)statusModel {
    
    SiteMessageLastMsgModel *roundsModel = (SiteMessageLastMsgModel *)self.currentSelectCellData;
    NewSiteMessageRoundsModel *tempModel  = [NewSiteMessageRoundsModel mj_objectWithKeyValues:roundsModel.msgContent.mj_JSONObject];
    
    switch (statusModel.replyStatus) {
        case 0:   //0:否-无症状
        {
            NewSiteMeaageRoundsDetailViewController *detailVC = [[NewSiteMeaageRoundsDetailViewController alloc] init];
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 1:   //1:是-正在问卷
        {
            [HMViewControllerManager createViewControllerWithControllerName:@"RoundsUnFilledDetailViewController" ControllerObject:[NSString stringWithFormat:@"%@", tempModel.recordId]];
            break;
        }
        case 2:   //2:已删除或已过期
        {
            [self.view showAlertMessage:@"查房已过期"];
            break;
        }
        case 3:   //3:未填写症状
        {
            [[NewSiteMessageRoundsAlterView shareRoundsView] showWithModel:tempModel btnClick:^(NSInteger tag) {
                self.roundsCurrentSelectStatus = tag;
                [self startDealWithRoundsWithModel:tempModel tag:tag];
            }];
            
            break;
        }
        case 4:   //4:已填写问卷
        {
            [HMViewControllerManager createViewControllerWithControllerName:@"RoundsDetailViewController" ControllerObject:[NSString stringWithFormat:@"%@", tempModel.recordId]];
            break;
        }
        default:
            break;
    }

}

//处理随访接口返回方法
- (void)dealWithSurveryStatusWith:(NewSiteMessageRoundsStatusModel *)statusModel {
    SiteMessageLastMsgModel *roundsModel = (SiteMessageLastMsgModel *)self.currentSelectCellData;
    NewSiteMessageRoundsModel *tempModel  = [NewSiteMessageRoundsModel mj_objectWithKeyValues:roundsModel.msgContent.mj_JSONObject];
    
    switch (statusModel.replyStatus) {
        case 1:   //1:已填写
        case 4:   //4:医生已答复
        {
            [HMViewControllerManager createViewControllerWithControllerName:@"SurveyFilledDetailViewController" ControllerObject:tempModel.recordId];
            break;
        }
        case 2:   //2:已删除
        {
            [self.view showAlertMessage:@"随访已删除"];
            break;
        }
        case 3:   //3:未填写
        {
            [HMViewControllerManager createViewControllerWithControllerName:@"SurveyUnFilledDetailViewController" ControllerObject: tempModel.recordId];
            break;
        }
        default:
            break;
    }

}

//处理评估接口返回方法
- (void)dealWithAssessStatusWith:(NewSiteMessageGetAssessStatusModel *)statusModel {
    SiteMessageLastMsgModel *assessModel = (SiteMessageLastMsgModel *)self.currentSelectCellData;
    NewSiteMessageAssessModel *tempModel  = [NewSiteMessageAssessModel mj_objectWithKeyValues:assessModel.msgContent.mj_JSONObject];
    
    if (!tempModel.assessCode || 0 == tempModel.assessCode)
    {
        //异常消息，不处理
        return;
    }
    
    switch (statusModel.replyStatus) {
        case 0:  //未填写
        {
            // 跳转到填写评估界面
            [HMViewControllerManager createViewControllerWithControllerName:@"EvaluationUnFilledDetailViewController" ControllerObject:[NSString stringWithFormat:@"%ld", tempModel.recordId]];

            break;
        }
        case 1:  //已填写
        {
            //评估 跳转评估详情
            EvaluationListRecord *evaluationRecord = [[EvaluationListRecord alloc] init];
            evaluationRecord.itemId = [NSString stringWithFormat:@"%ld", tempModel.recordId];
            if ([tempModel.assessCode isEqualToString:@"JDXPG"])
            {
                //阶段评估
                evaluationRecord.itemType = @"1";
            }
            if ([tempModel.assessCode isEqualToString:@"DCPG"])
            {
                //阶段评估
                evaluationRecord.itemType = @"2";
            }
            
            
            if (!evaluationRecord.itemType)
            {
                //未知评估类型
                return;
            }
            [HMViewControllerManager createViewControllerWithControllerName:@"EvaluationDetailViewController" ControllerObject:evaluationRecord];

            break;
        }
        default:
            [self.view showAlertMessage:@"评估已删除"];
            break;
    }
}

- (void)clickImageView:(NSInteger)row sourceArr:(NSArray *)sourceArr
{
    // 封装图片数据
    MWPhoto *photo;
    NSInteger currentSelectIndex = 0;
    [self.arrayPhotos removeAllObjects];
    
    for (NSInteger i = 0; i < sourceArr.count; i ++)
    {
        // 网络下载图片
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:sourceArr[i]]];
        [self.arrayPhotos addObject:photo];
        if (row == i)
        {
            currentSelectIndex =  row;
        }
        
    }
    
    // Modal
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self.photoBrowser reloadData];
    [self.photoBrowser setCurrentPhotoIndex:currentSelectIndex];
    [self presentViewController:nc animated:YES completion:nil];
    
}


#pragma mark - event Response
- (void)ackDoctorClick {
    //跳转聊天界面
    [[HMSessionListInteractor sharedInstance] goToSessionList];
}

- (void)rightClick {
    NewSiteMessageSetViewController *siteSetVC = [[NewSiteMessageSetViewController alloc]initWithModel:self.model];
    [self.navigationController pushViewController:siteSetVC animated:YES];
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    NSLog(@"%ld",self.arrayPhotos.count);
    return self.arrayPhotos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.arrayPhotos.count)
        return [self.arrayPhotos objectAtIndex:index];
    return nil;
}
#pragma mark - UITableViewDelegate
- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    self.currentSelectCellData = cellData;
    
    SiteMessageLastMsgModel *model = (SiteMessageLastMsgModel *)cellData;
    
    SiteMessageSecondEditionType siteMessageType = [NewSiteMessageMessageTypeENUM acquireMessageTypeWithString:model.typeCode];

    switch (siteMessageType) {
        case SiteMessageSecondEditionType_YSGH:
        {//医生关怀 YSGH
            NewSiteMessageYSGHType YSGHType = [NewSiteMessageMessageTypeENUM acquireNewSiteMessageYSGHTypeWithString:model.msgContent.mj_JSONObject[@"type"]];

            switch (YSGHType) {
                case NewSiteMessageYSGHType_userCarePage:
                {//医生问候 userCarePage
                    
                    break;
                }
                case NewSiteMessageYSGHType_roundsAsk:
                {//查房 roundsAsk
                    NewSiteMessageRoundsModel *tempModel  = [NewSiteMessageRoundsModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
                    [self startRoundsStatusRequestWithModel:tempModel];

                    break;
                }
                case NewSiteMessageYSGHType_surveyPush:
                {//随访 surveyPush
                    NewSiteMessageRoundsModel *tempModel  = [NewSiteMessageRoundsModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
                    [self startSurveryStatusRequestWithModel:tempModel];
                    break;
                }
                case NewSiteMessageYSGHType_serviceComments:
                {//服务评价 serviceComments
                    //点击进入医生评价页面
                    NewSiteMessageServiceCommentModel *tempModel  = [NewSiteMessageServiceCommentModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
                    NewPatientCommentViewController *VC = [NewPatientCommentViewController new];
                    VC.userServiceId = tempModel.userServiceId;
                    VC.masgId = model.msgId;
                    [self.navigationController pushViewController:VC animated:YES];
                    break;
                }
                case NewSiteMessageYSGHType_surveyReply: {
                    // 随访回复
                    NewSiteMessageCheackModel *tempModel  = [NewSiteMessageCheackModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];

                    [HMViewControllerManager createViewControllerWithControllerName:@"SurveyFilledDetailViewController" ControllerObject:tempModel.surveyId];
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        case SiteMessageSecondEditionType_JKNZ:
        {//健康闹钟 JKNZ
            NewSiteMessageJKNZType JKNZType = [NewSiteMessageMessageTypeENUM acquireNewSiteMessageJKNZTypeWithString:model.msgContent.mj_JSONObject[@"type"]];
            
            switch (JKNZType) {
                case NewSiteMessageJKNZType_reviewPush:
                {//复查提醒 reviewPush
                    //约专家
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页-约专家"];
                    if (![UserServicePrivilegeHelper userHasPrivilege:ServicePrivile_Appoint])
                    {
                        [self showAlertMessage:@"您还没有购买服务。"];
                        return;
                    }
                    
                    if (![UserServicePrivilegeHelper userHasPrivilege:ServicePrivile_Appoint])
                    {
                        //没有约诊权限
                        [self.view showAlertWithoutServiceMessage];
                        return;
                    }
                    
                    //
                    [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentStartViewController" ControllerObject:nil];
                    break;
                }
                case NewSiteMessageJKNZType_drugPush:
                {//用药提醒 drugPush
                    NewSiteMessageMedicationRemindModel *tempModel  = [NewSiteMessageMedicationRemindModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
                    [[ATModuleInteractor sharedInstance] gotoMedicalListVCWithDataList:tempModel.drugList];

                    break;
                }
                case NewSiteMessageJKNZType_healthTest:
                {//监测提醒 healthTest
                    
                    NewSiteMessageMonitorRemindModel *tempModel = [NewSiteMessageMonitorRemindModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
                    NSString *kpiCode = tempModel.kpiCode;
                    if (!kpiCode || 0 == kpiCode.length) {
                        //跳转记录健康
                        [HMViewControllerManager createViewControllerWithControllerName:@"BodyDetectStartViewController"ControllerObject:nil];
                        return;
                    }
                    
                    if ([kpiCode isEqualToString:@"XY"]){
                        //测血压
                        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测血压"];
                        [HMViewControllerManager createViewControllerWithControllerName:@"BodyPressureDetectStartViewController" ControllerObject:nil];
                        
                    }
                    else if([kpiCode isEqualToString:@"TZ"]){
                        //测体重
                        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测体重"];
                        [HMViewControllerManager createViewControllerWithControllerName:@"BodyWeightDetectStartViewController" ControllerObject:nil];
                        
                    }
                    else if([kpiCode isEqualToString:@"XL"]){
                        //测心电
                        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测心电"];
                        [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectStartViewController" ControllerObject:nil];
                        
                    }
                    else if([kpiCode isEqualToString:@"XT"]){
                        //测血糖
                        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测血糖"];
                        [HMViewControllerManager createViewControllerWithControllerName:@"BloodSugarDetectStartViewController" ControllerObject:nil];
                        
                    }
                    else if([kpiCode isEqualToString:@"XZ"]){
                        //测血脂
                        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测血脂"];
                        [HMViewControllerManager createViewControllerWithControllerName:@"BloodFatDetectStartViewController" ControllerObject:nil];
                        
                    }
                    else if([kpiCode isEqualToString:@"NL"]){
                        //测尿量
                        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测尿量"];
                        [HMViewControllerManager createViewControllerWithControllerName:@"UrineVolumeDetectStartViewController" ControllerObject:nil];
                        
                    }
                    else if([kpiCode isEqualToString:@"HX"]){
                        //测呼吸
                        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测呼吸"];
                        [HMViewControllerManager createViewControllerWithControllerName:@"BreathingDetectStartViewController" ControllerObject:nil];
                        
                    }
                    else if([kpiCode isEqualToString:@"OXY"]){
                        //测血氧
                        [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"健康记录－测血氧"];
                        [HMViewControllerManager createViewControllerWithControllerName:@"BloodOxygenDetectStartViewController" ControllerObject:nil];
                    }
                    else {
                        //没有对应类型就跳转记录健康
                        [HMViewControllerManager createViewControllerWithControllerName:@"BodyDetectStartViewController"ControllerObject:nil];
                    }
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        case SiteMessageSecondEditionType_WDYZ:
        {//我的约诊 WDYZ
            NewSiteMessageWDYZType WDYZType = [NewSiteMessageMessageTypeENUM acquireNewSiteMessageWDYZTypeWithString:model.msgContent.mj_JSONObject[@"type"]];
            NewSiteMessageAppointmentRemindModel *tempModel  = [NewSiteMessageAppointmentRemindModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
            switch (WDYZType) {
                case NewSiteMessageWDYZType_appointAgree: //约诊通过 appointAgree
                case NewSiteMessageWDYZType_appointRefuse://约诊失败 appointRefuse
                case NewSiteMessageWDYZType_appointCancel://约诊取消 appointCancel
                case NewSiteMessageWDYZType_appointChange://约诊变更 appointChange
                case NewSiteMessageWDYZType_appointremind://约诊提醒 appointremind
                {
                    AppointmentInfo* appointment = [[AppointmentInfo alloc]init];
                    [appointment setAppointId:tempModel.appointId];
                    [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentDetailViewController" ControllerObject:appointment];
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        case SiteMessageSecondEditionType_JKJH:
        {//健康计划 JKJH
            NewSiteMessageHealthPlanModel *tempModel  = [NewSiteMessageHealthPlanModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
            HealthPlanInfo* healthPlan = [HealthPlanInfo new];
            healthPlan.healthyPlanId = tempModel.healthyPlanId;
            healthPlan.userId = tempModel.userId;
            if (!healthPlan.healthyPlanId)
            {
                return;
            }
            [HMViewControllerManager createViewControllerWithControllerName:@"HealthPlanDetailViewController" ControllerObject:healthPlan];
            break;
        }
        case SiteMessageSecondEditionType_JKPG:
        {//健康评估 JKPG
            NewSiteMessageAssessModel *tempModel  = [NewSiteMessageAssessModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
            [self startAssessStatusRequestWithModel:tempModel];
            break;
        }
        case SiteMessageSecondEditionType_JKBG:
        {//健康报告 JKBG
            NewSiteMessageHealthReportModel *tempModel  = [NewSiteMessageHealthReportModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
            
            [HMViewControllerManager createViewControllerWithControllerName:@"HealthReportDetailViewController" ControllerObject:tempModel];

            break;
        }
        case SiteMessageSecondEditionType_XTXX:
        {//系统消息 XTXX
            
            break;
        }
        case SiteMessageSecondEditionType_JKKT:
        {//健康课堂 JKKT
            NewSiteMessageHealthClassModel *tempModel  = [NewSiteMessageHealthClassModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
            
            HealthEducationItem* educationModel = [[HealthEducationItem alloc] init];
            educationModel.classId = tempModel.classId.integerValue;
            
            [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationDetailViewController" ControllerObject:educationModel];
            break;
        }
        default:
            break;
    }
}
#pragma mark TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if ([taskname isEqualToString:@"HMIMCELLFeedBackPatientRoundsRequest"]) {
        [[NewSiteMessageRoundsAlterView shareRoundsView] closeClick];
    }
    if ([taskname isEqualToString:@"NewSiteMessageGetMessageWithTypeRequest"]) {
        [self.tableView.mj_header endRefreshing];
    }
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self.view closeWaitView];
    
    if (!taskId || 0 == taskId.length) {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"NewSiteMessageGetMessageWithTypeRequest"]) {
        // 先翻转数组
        NSArray *temp = [[(NSArray *)taskResult reverseObjectEnumerator] allObjects];
        if (temp.count) {
            [self.tableView.mj_header endRefreshing];
            ;
            if (self.adapter.adapterArray.count) {
                // 增量添加数据
                NSMutableArray *tempMubArr = [NSMutableArray array];
                [tempMubArr addObjectsFromArray:temp];
                [tempMubArr addObjectsFromArray:self.adapter.adapterArray];
                self.adapter.adapterArray = tempMubArr;
            }
            else {
                // 首次拉倒数据
                [self.adapter.adapterArray addObjectsFromArray:temp];
            }
            [self.tableView reloadData];

            if (!self.lastTimeStamp) {
                // 首次拉 滚到最下面
                [self performSelector:@selector(scrollToBottomWithAnimated:) withObject:nil afterDelay:0.1];
            }
            else {
                // 分页加载 滚到拉取数量行 以保证页面平稳
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:temp.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            // 存下最后一条
            SiteMessageLastMsgModel *model = self.adapter.adapterArray.firstObject;
            self.lastTimeStamp = model.createTimestamp;
        }
        else {
            [self.tableView.mj_header endRefreshing];
            if (self.adapter.adapterArray.count) {
                [self at_postError:@"没有更多数据了"];
            }
        }
        //没数据显示空白页
        [self.emptyView setHidden:self.adapter.adapterArray.count];
        
    }
    else if ([taskname isEqualToString:@"NewSiteMessageGetWardsRoundStatusRequest"]) {
        NewSiteMessageRoundsStatusModel *result = (NewSiteMessageRoundsStatusModel *)taskResult;
        [self dealWithRoundStatusWith:result];
    }
    else if ([taskname isEqualToString:@"HMIMCELLFeedBackPatientRoundsRequest"]) {
        [[NewSiteMessageRoundsAlterView shareRoundsView] closeClick];
        
        SiteMessageLastMsgModel *roundsModel = (SiteMessageLastMsgModel *)self.currentSelectCellData;
        NewSiteMessageRoundsModel *tempModel  = [NewSiteMessageRoundsModel mj_objectWithKeyValues:roundsModel.msgContent.mj_JSONObject];
        if (self.roundsCurrentSelectStatus) {
            //有
            //填写问卷
            [HMViewControllerManager createViewControllerWithControllerName:@"RoundsUnFilledDetailViewController" ControllerObject:[NSString stringWithFormat:@"%@", tempModel.recordId]];
        }
        else {
            //没有
            NewSiteMeaageRoundsDetailViewController *detailVC = [[NewSiteMeaageRoundsDetailViewController alloc] initWithModel:tempModel];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        
    }
    else if ([taskname isEqualToString:@"NewSiteMessageGetSurveryStatusRequest"]) {
        NewSiteMessageRoundsStatusModel *result = (NewSiteMessageRoundsStatusModel *)taskResult;
        [self dealWithSurveryStatusWith:result];
    }
    else if ([taskname isEqualToString:@"NewSiteMessageGetAssessStatusRequest"]) {
        NewSiteMessageGetAssessStatusModel *result = (NewSiteMessageGetAssessStatusModel *)taskResult;
        [self dealWithAssessStatusWith:result];
    }
}

#pragma mark - Interface

#pragma mark - init UI

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        _tableView.estimatedRowHeight = 60;
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefreshData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        _tableView.mj_header = header;

        [_tableView registerClass:[NewSiteMessageMonitorRemindedTableViewCell class] forCellReuseIdentifier:[NewSiteMessageMonitorRemindedTableViewCell at_identifier]];
        [_tableView registerClass:[NewSiteMessageAllMonitorRemindedTableViewCell class] forCellReuseIdentifier:[NewSiteMessageAllMonitorRemindedTableViewCell at_identifier]];
        [_tableView registerClass:[NewSiteMessageTemindReviewTableViewCell class] forCellReuseIdentifier:[NewSiteMessageTemindReviewTableViewCell at_identifier]];
        [_tableView registerClass:[NewSiteMessageMedicationRemindTableViewCell class] forCellReuseIdentifier:[NewSiteMessageMedicationRemindTableViewCell at_identifier]];
        [_tableView registerClass:[NewSiteMessageAppointmentRemindTableViewCell class] forCellReuseIdentifier:[NewSiteMessageAppointmentRemindTableViewCell at_identifier]];
         [_tableView registerClass:[NewSiteMessageSystemTableViewCell class] forCellReuseIdentifier:[NewSiteMessageSystemTableViewCell at_identifier]];
        [_tableView registerClass:[NewSiteMessageTextTableViewCell class] forCellReuseIdentifier:[NewSiteMessageTextTableViewCell at_identifier]];
        [_tableView registerClass:[NewSiteMessageRoundsTableViewCell class] forCellReuseIdentifier:[NewSiteMessageRoundsTableViewCell at_identifier]];
        [_tableView registerClass:[NewSiteMessageLeftImageTableViewCell class] forCellReuseIdentifier:[NewSiteMessageLeftImageTableViewCell at_identifier]];
        [_tableView registerClass:[NewChatLeftVoiceTableViewCell class] forCellReuseIdentifier:[NewChatLeftVoiceTableViewCell at_identifier]];
        [_tableView registerClass:[NewSiteMessageDoctorCareTableViewCell class] forCellReuseIdentifier:[NewSiteMessageDoctorCareTableViewCell at_identifier]];
        [_tableView registerClass:[NewSiteMessageHealthClassTableViewCell class] forCellReuseIdentifier:[NewSiteMessageHealthClassTableViewCell at_identifier]];
         [_tableView registerClass:[NewSiteSystemTableViewCell class] forCellReuseIdentifier:[NewSiteSystemTableViewCell at_identifier]];
        [_tableView registerClass:[NewSiteMessageVisitTableViewCell class] forCellReuseIdentifier:[NewSiteMessageVisitTableViewCell at_identifier]];
    }
    return _tableView;
}

- (NewSiteMessageItemListAdapater *)adapter
{
    if (!_adapter) {
        _adapter = [NewSiteMessageItemListAdapater new];
        _adapter.adapterDelegate = self;
        _adapter.tableView = self.tableView;
        __weak typeof(self) weakSelf = self;
        [_adapter collectImageClick:^(NSArray *imageArr, NSInteger selectIndex) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf clickImageView:selectIndex sourceArr:imageArr];
        }];
    }
    return _adapter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (HMRainysEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[HMRainysEmptyView alloc] initWithImage:[UIImage imageNamed:@"NewSite_none"] emptyWord:@"暂时没有消息哦"];
    }
    return _emptyView;
}
- (NSMutableArray *)arrayPhotos {
    if (!_arrayPhotos) {
        _arrayPhotos = [NSMutableArray array];
    }
    return _arrayPhotos;
}
- (MWPhotoBrowser *)photoBrowser
{
    if (!_photoBrowser)
    {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = YES; // 分享按钮，默认是
        _photoBrowser.displayNavArrows = NO;     // 左右分页切换，默认否
        _photoBrowser.displaySelectionButtons = NO; // 是否显示选择按钮
        _photoBrowser.alwaysShowControls = NO;  // 控制条件控件
        _photoBrowser.zoomPhotosToFill = NO;    // 是否全屏
        _photoBrowser.enableGrid = NO;//是否允许用网格查看所有图片,默认是
        _photoBrowser.startOnGrid = NO;//是否第一张,默认否
        _photoBrowser.enableSwipeToDismiss = YES;
        [_photoBrowser showNextPhotoAnimated:YES];
        [_photoBrowser showPreviousPhotoAnimated:YES];
        [_photoBrowser setCurrentPhotoIndex:1];
    }
    return _photoBrowser;
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
