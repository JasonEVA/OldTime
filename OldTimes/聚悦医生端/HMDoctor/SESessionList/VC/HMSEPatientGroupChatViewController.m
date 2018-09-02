//
//  HMSEPatientGroupChatViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/10/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMSEPatientGroupChatViewController.h"
#import <Masonry.h>
#import "MyDefine.h"
#import "CalculateHeightManager.h"
#import "Slacker.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "ChatAttachPickView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NSDate+MsgManager.h"
#import <MJExtension/MJExtension.h>
#import "AppTaskModel.h"
#import "UIColor+Hex.h"
#import "AppDelegate.h"
#import "UITextView+AtUser.h"
#import "ContactPersonDetailInformationModel.h"
#import "CoordinationFilterView.h"
#import "ATModuleInteractor+CoordinationInteractor.h"
#import "ChatGroupSelectAtUserViewController.h"
#import "ForwardSelectRecentContactViewController.h"
#import "MessageBaseModel+CellSize.h"

#import "PatientInfo.h"
#import "HealthPlanMessionInfo.h"
#import "DetectRecord.h"
#import "SurveyRecord.h"
#import "HealthPlanInfo.h"
#import "AppointmentInfo.h"
#import "ContactInfoModel.h"
#import "DealUserWarningViewController.h"
#import "MessageBaseModel+CellSize.h"
#import "HealthHistoryItem.h"
#import "ChatBaseViewController+ChatCellActions.h"
#import "ChatBaseViewController+ChatInputViewActions.h"
#import "HMCommonLanguageViewController.h"
#import "HMIMCELLFeedBackPatientRoundsRequest.h"
#import "DealUserAlertPromptView.h"
#import "HMAddUserDietRecordViewController.h"

#import "IMPatientContactExtensionModel.h"
#import "ATModuleInteractor+PatientChat.h"
#import "HMCheckPatientServiceManager.h"
#import "HealthPlanSummaryViewController.h"

#import "PatientDetailPromptView.h"

static NSString * const DealAlertNotification = @"isDeal";

typedef NS_ENUM(NSUInteger, ChatMenuType) {
    ChatMenuHistoryList,
    ChatMenuGroupInfo,
};

@interface HMSEPatientGroupChatViewController () <CoordinationFilterViewDelegate,TaskObserver>

@property (nonatomic, strong)  CoordinationFilterView  *filterView; // <##>
@property (nonatomic, strong) PatientInfo* patient;
@property (nonatomic, strong)  UILabel  *serviceEnd; // 服务到期提示

@property (nonatomic, strong) DealUserAlertPromptView *alertPromptView;  //预警处理提示
@property (nonatomic, strong) UserProfileModel *chatDetailModel;     // 会话详情model
@property (nonatomic, strong) IMPatientContactExtensionModel *extensionModel;  // 扩展字段model用于业务处理
@property (nonatomic) BOOL isSingle;   // 是否为单项服务，classify == 5 为单项服务

@property (nonatomic, strong) PatientDetailPromptView *promptView; //第一次提示用户信息界面
@end


@implementation HMSEPatientGroupChatViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configCellSenderNameHide:NO];
    
    [self initCompnents];
    
    [self configPatientDetailInfo];
    
    [self.navigationItem setTitle:self.strName];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_close"] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
    
    UIBarButtonItem *btnHistory = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"patient_historyMsg"] style:UIBarButtonItemStylePlain target:self action:@selector(p_historyMessage)];
    
    UIBarButtonItem *btnSet = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_personal"] style:UIBarButtonItemStylePlain target:self action:@selector(btnDropListClicked)];
    //    UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"magnifier"] style:UIBarButtonItemStylePlain target:self action:@selector(btnSearchClicked)];
    [self.navigationItem setRightBarButtonItems:@[btnSet,btnHistory]];
    
    self.viewInputHeight = 50;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertIsDeal:) name:DealAlertNotification object:nil];
    
    //患者信息提示框
    [self showArchivePrompt];
}

//通知：是否显示预警处理提示框
- (void)alertIsDeal:(NSNotification *)noti
{
    //    BOOL isDeal = noti.object;
    //    if (isDeal && _alertPromptView) {
    //        [_alertPromptView removeFromSuperview];
    //    }
    if (_alertPromptView) {
        [_alertPromptView removeFromSuperview];
    }
}

- (void)configPatientInfo:(PatientInfo *)patientInfo {
    _patient = patientInfo;
    
    if (_patient.testName) {
        [self.view addSubview:self.alertPromptView];
        [self.alertPromptView showPromptWithViewController:self prompt:[NSString stringWithFormat:@"%@  %@" ,_patient.testValue ,_patient.uploadTime]];
        [self.alertPromptView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.mas_equalTo(@40);
        }];
        
        __weak typeof(patientInfo) patientInfoSelf = _patient;
        [self.alertPromptView setReturnsAnEventBlock:^{
            
            //判断是否存在处理权限
            BOOL processPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeWarmMode Status:patientInfoSelf.doStatus OperateCode:kPrivilegeProcessOperate];
            if (!processPrivilege)
            {
                //没有处理权限
                return;
            }
            
            UserAlertInfo *alertInfo = [UserAlertInfo new];
            alertInfo.testResulId = patientInfo.testResulId;
            alertInfo.userId = patientInfo.userId;
            alertInfo.sex = patientInfo.sex;
            alertInfo.age = patientInfo.age;
            alertInfo.userName = patientInfo.userName;
            alertInfo.testName = patientInfo.testName;
            alertInfo.kpiCode = patientInfo.kpiCode;
            
            [HMViewControllerManager createViewControllerWithControllerName:@"DealUserWarningViewController" ControllerObject:alertInfo];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshGroupTitle];
    
    if (self.keyboardHeight > 0)
    {
        [self.chatInputView popupKeyboard];
    }
    
//    if (UMSDK_isOn) {
//        [MobClick event:UMCustomEvent_EnterPatientChatVc];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.module.sessionModel._chatStatus = self.isReceiptOn;
    [[MessageManager share] updateChatStatusWithModel:self.module.sessionModel];
}

- (void)btnDropListClicked
{
    if (!self.extensionModel) {
        return;
    }
    [[ATModuleInteractor sharedInstance] goToPatientInfoDetailWithUid:self.extensionModel.pId];
    
    
    //    if (![self.view.subviews containsObject:self.filterView]) {
    //        [self.view addSubview:self.filterView];
    //        [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.edges.equalTo(self.view);
    //        }];
    //    }
    //    else {
    //        [self.filterView removeFromSuperview];
    //        _filterView = nil;
    //    }
}


//患者信息提示框
- (void)showArchivePrompt
{
    if (!kStringIsEmpty([[NSUserDefaults standardUserDefaults] valueForKey:@"FirstEnterArchive"])) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"FirstEnterArchive" forKey:@"FirstEnterArchive"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self.promptView setFrame:window.bounds];
    [window addSubview:self.promptView];
}

// 历史记录
- (void)p_historyMessage {
    if (!self.extensionModel) {
        return;
    }
    [HMViewControllerManager createViewControllerWithControllerName:@"GroupMessageHistoryViewController" ControllerObject:@[self.strUid,self.extensionModel.pId]] ;
}

- (void)configPatientDetailInfo {
    
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] MTRequestGroupInfoWirhGroupId:self.strUid completion:^(UserProfileModel *model) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        strongSelf.chatDetailModel = model;
        strongSelf.extensionModel = [IMPatientContactExtensionModel mj_objectWithKeyValues:[strongSelf.chatDetailModel.extension mj_JSONObject]];
        if (!strongSelf.extensionModel) {
            return;
        }
        [strongSelf patientGroupHideChatInputView:!strongSelf.extensionModel.canChat];

        strongSelf.patient.userId = strongSelf.extensionModel.pId.integerValue;
        strongSelf.isSingle = strongSelf.extensionModel.classify == 5;
        
        [strongSelf.chatInputView configAttachPickViewType:strongSelf.isSingle ?  ChatAttachPickTypePart:ChatAttachPickTypeFull];
        
        [[MessageManager share] querySessionDataWithUid:strongSelf.strUid completion:^(ContactDetailModel *model) {
            [strongSelf changeReceiptStatus:strongSelf.module.sessionModel._chatStatus];
        }];
    }];
}

#pragma mark - Override Method
- (void)changeLeftNumber {
    [[MessageManager share] queryUnreadMessageCountWithoutUid:self.strUid completion:^(NSInteger unreadCount) {
        // 未读数量变换
        // do something
    }];
}

- (void)at_sendReceiptMsgWith:(NSString *)text {
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"fromId"];
    [dicPost setValue:self.strUid forKey:@"toId"];
    [dicPost setValue:text forKey:@"textContent"];
    
    //    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMSendReceipMagRequest" taskParam:dicPost TaskObserver:self];
}

- (void)at_patientDoctorChatCollectImageWithModel:(MessageBaseModel *)model {
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSString *titelStr = @"";
    if (model._markImportant) {
        titelStr = @"已收藏";
    }
    else {
        titelStr = @"仅收藏图片";
        
    }
    UIAlertAction *onlyImage = [UIAlertAction actionWithTitle:titelStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (model._markImportant) {
            // 已收藏
            return;
        }
        [self jw_markMessage:model];
    }];
    UIAlertAction *toFoodRecode = [UIAlertAction actionWithTitle:@"收藏到饮食记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        HMAddUserDietRecordViewController *VC = [[HMAddUserDietRecordViewController alloc]initWithModel:model strUid:self.strUid disMisssBlock:^(BOOL isSuccessed) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
            if (isSuccessed) {
                [self at_postSuccess:@"收藏成功"];
            }
        }];
        
        [self.view.window.rootViewController presentViewController:VC animated:NO completion:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    }];
    UIAlertAction *toCaseHistory = [UIAlertAction actionWithTitle:@"收藏到病历" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self patitentCollectToMedicalHistoryWithModel:model];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionSheetController addAction:cancelAction];
    [actionSheetController addAction:onlyImage];
    [actionSheetController addAction:toFoodRecode];
    [actionSheetController addAction:toCaseHistory];
    
    [self presentViewController:actionSheetController animated:YES completion:nil];
    
}

- (void)at_patientDoctorChatInquirySendWithDict:(NSDictionary *)dict {
    MessageBaseModelSurveyContent* modelContent = [MessageBaseModelSurveyContent mj_objectWithKeyValues:dict];
    
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", modelContent.recordId] forKey:@"recordId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"SurveyRecordInfoTask" taskParam:dicPost TaskObserver:self];
}
#pragma mark - Private Method

- (void)patitentCollectToMedicalHistoryWithModel:(MessageBaseModel *)model {
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:@"收藏到病历" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *onlyImage = [UIAlertAction actionWithTitle:@"门诊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startAddUserIllnessRequestWithIllnessCode:@"outpatientClinic" model:model];
    }];
    UIAlertAction *toFoodRecode = [UIAlertAction actionWithTitle:@"急诊" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startAddUserIllnessRequestWithIllnessCode:@"emergency" model:model];
        
    }];
    UIAlertAction *toCaseHistory = [UIAlertAction actionWithTitle:@"检验检查" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startAddUserIllnessRequestWithIllnessCode:@"inspection" model:model];
        
    }];
    UIAlertAction *medical = [UIAlertAction actionWithTitle:@"药物处方" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self startAddUserIllnessRequestWithIllnessCode:@"prescription" model:model];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionSheetController addAction:cancelAction];
    [actionSheetController addAction:onlyImage];
    [actionSheetController addAction:toFoodRecode];
    [actionSheetController addAction:toCaseHistory];
    [actionSheetController addAction:medical];
    
    
    [self presentViewController:actionSheetController animated:YES completion:nil];
}

/* 标记为重点 */
- (void)jw_markMessage:(MessageBaseModel *)baseModel
{
    /* 在这里进行标记操作 */
    [[MessageManager share] markMessage:baseModel];
    [[MessageManager share] markMessageImportantWithModel:baseModel important:!baseModel._markImportant];
    baseModel._markImportant ^= 1;
    //    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    //    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    [self at_postSuccess:@"已收藏"];
}

- (BOOL)isNeedScrollPositionBottomWithTableViewOffSet
{
    CGSize contentSize =  self.tableView.contentSize;
    CGPoint offSet     =  self.tableView.contentOffset;
    float distance = contentSize.height - offSet.y - self.tableView.frame.size.height;
    if (distance <= 350 ) {
        return YES;
    }
    return NO;
}

- (void)updateViewConstraints
{
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.chatInputView.mas_top);
        
    }];
    
    [self.chatInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-self.keyboardHeight);
        make.top.equalTo(self.tableView.mas_bottom);
        make.height.equalTo(@(MAX(self.viewInputHeight, self.chatInputView.viewCommon.frame.size.height)));
    }];
    
    [super updateViewConstraints];
}

- (void)initCompnents
{
    __weak typeof(self) weakSelf = self;
    
    [self ats_inputViewCustomAttachmentActionResponse:^(ChatAttachPick_tag tag) {
        [weakSelf p_chatInputViewCustomAttachmentAction:tag];
    }];
    [self.view addSubview:self.serviceEnd];
    [self.serviceEnd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.chatInputView);
    }];
}

// 群名更新
- (void)refreshGroupTitle
{
    // 从数据库取出群信息
    UserProfileModel *model = [[MessageManager share] queryContactProfileWithUid:self.strUid];
    self.strName = model.nickName;
    self.avatarPath = model.avatar;
    [self.navigationItem setTitle:self.strName];
}




// 除基本操作外的自定义类型的处理
- (void)p_chatInputViewCustomAttachmentAction:(ChatAttachPick_tag)tag {
    
    if (tag != tag_pick_receipt && self.isReceiptOn) {
        [self changeReceiptStatus:NO];
    }
    
    switch (tag)
    {
        case tag_pick_img:
        case tag_pick_takePhoto:
            break;
            
        case tag_pick_healthPlan:
        {
            // 健康计划
            
            NSInteger userIdInt = _patient.userId;
            HealthPlanSummaryViewController* detectViewController = [[HealthPlanSummaryViewController alloc] initWithUserId:userIdInt];
            [self.navigationController pushViewController:detectViewController animated:YES];
            
            break;
        }
        case tag_pick_survey:
        {
            // 发随访
            // do something
            if (!_patient ) {
                break;
            }
            BOOL processPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateSurveytMode Status:0xFF OperateCode:kPrivilegeProcessOperate];
            if (!processPrivilege)
            {
                //没有发起随访权限
                [self at_postError:@"您的账号没有此功能权限"];
                break;
            }
            [HMViewControllerManager createViewControllerWithControllerName:@"SurveyMoudlesStartViewController" ControllerObject:@[_patient]];
            
            break;
        }
        case tag_pick_inquiry:
        {
            // 发问诊
            if (!_patient ) {
                break;
            }
            
            BOOL processPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateInterrogationtMode Status:0xFF OperateCode:kPrivilegeProcessOperate];
            if (!processPrivilege)
            {
                //没有发起问诊权限
                [self at_postError:@"您的账号没有此功能权限"];
                break;
            }
            [HMViewControllerManager createViewControllerWithControllerName:@"InterrogationMoudlesStartViewController" ControllerObject:@[_patient]];
            break;
        }
        case tag_pick_prescribe:
        {
            // 开处方
            // do something
            if (!_patient ) {
                break;
            }
            BOOL processPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreatePrescriptionMode Status:0xFF OperateCode:kPrivilegeProcessOperate];
            if (!processPrivilege)
            {
                //没有发起问诊权限
                [self at_postError:@"您的账号没有此功能权限"];
                break;
            }
            
            [HMViewControllerManager createViewControllerWithControllerName:@"PrescribeStartViewController" ControllerObject:_patient];
            break;
        }
            //        case tag_pick_care:
            //        {
            //            // 关怀
            //            // do something
            //            if (!_patient ) {
            //                break;
            //            }
            //
            //      /*   //放开权限   BOOL processPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateCareMode Status:0xFF OperateCode:kPrivilegeProcessOperate];
            //            if (!processPrivilege)
            //            {
            //                //没有发起问诊权限
            //       [self at_postError:@"您的账号没有此功能权限"];
            //                break;
            //            }*/
            //            [HMViewControllerManager createViewControllerWithControllerName:@"CareVoiceViewController" ControllerObject:_patient];
            //            break;
            //        }
        case tag_pick_evaluate: {
            // 评估
            BOOL processPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateAccessmentMode Status:0xFF OperateCode:kPrivilegeProcessOperate];
            if (processPrivilege)
            {
                //拥有发送评估的权限, 跳转到评估表分类界面
                [HMViewControllerManager createViewControllerWithControllerName:@"AssessmentTemplateCategoryListViewController" ControllerObject:[NSString stringWithFormat:@"%ld", _patient.userId]];
            }
            else {
                [self at_postError:@"您的账号没有此功能权限"];
            }
            break;
        }
            
            //        case tag_pick_wardRound: {
            //            // 查房
            //            BOOL processPrivilege = YES;
            //            if (processPrivilege)
            //            {
            //                //拥有发送评估的权限, 跳转到评估表分类界面
            //                [HMViewControllerManager createViewControllerWithControllerName:@"RoundsTemplateCategoryListViewController" ControllerObject:[NSString stringWithFormat:@"%ld", _patient.userId]];
            //            }
            //            break;
            //        }
        case tag_pick_commonLanguage: {
            //常用语
            HMCommonLanguageViewController *VC   = [HMCommonLanguageViewController new];
            __weak typeof(self) weakSelf = self;
            [VC btnClick:^(NSString *content) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf.chatInputView.viewCommon.txView setText:content];
                [strongSelf.chatInputView.viewCommon.txView becomeFirstResponder];
            }];
            [self.navigationController pushViewController:VC
                                                 animated:YES];
            
            break;
        }
            
        case tag_pick_receipt: {
            // 回执消息
            [self changeReceiptStatus:!self.isReceiptOn];
            if (self.isReceiptOn) {
                [self.chatInputView.viewCommon.txView becomeFirstResponder];
            }
            break;
        }
            
            
    }
    
}

//根据用户权限隐藏输入框
- (void)patientGroupHideChatInputView:(BOOL)hide {
    [self hideChatInputView:hide];
    [self.chatInputView setHidden:hide];
    [self.serviceEnd setHidden:!hide];
}

- (void)startAddUserIllnessRequestWithIllnessCode:(NSString *)code model:(MessageBaseModel *)model{
    
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    [dicPost setValue:[NSString stringWithFormat:@"%@%@",im_IP_http,model.attachModel.fileUrl] forKey:@"imageUrl"];
    [dicPost setValue:code forKey:@"illnessCode"];
    [dicPost setValue:self.strUid forKey:@"sessionName"];
    [dicPost setValue:@"病历" forKey:@"bookMarkName"];
    [dicPost setValue:@(model._msgId) forKey:@"msgId"];
    
    //    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMAddImageToIllnessRequest" taskParam:dicPost TaskObserver:self];
}

- (void)popClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - CoordinationFilterViewDelegate

- (void)CoordinationFilterViewDelegateCallBack_ClickWithTag:(NSInteger)tag
{
    ChatMenuType type = (ChatMenuType)tag;
    switch (type) {
        case ChatMenuHistoryList: {
            [[ATModuleInteractor sharedInstance] goHistoryListWithUid:self.module.sessionModel._target];
            break;
        }
        case ChatMenuGroupInfo: {
            if ([self.strUid hasSuffix:@"@ChatRoom"]) {
                // 讨论组，工作圈
                [[ATModuleInteractor sharedInstance] goWorkCircleInfoWithUid:self.strUid];
            }
            else if ([self.strUid hasSuffix:@"@SuperGroup"]) {
                // 群
                [[ATModuleInteractor sharedInstance] goGroupInfoWith:self.module.sessionModel._target];
            }
            break;
        }
    }
    
}


#pragma mark - ChatTableViewAdapterDelegate

- (void)chatTableViewAdapterDelegateCallBack_adapter:(ChatTableViewAdapter *)adapter patientChatCheckWarningDetailWithModel:(MessageBaseModel *)baseModel {
    // 查看详情
    [self cellClicked:baseModel];
}

- (void)chatTableViewAdapterDelegateCallBack_adapter:(ChatTableViewAdapter *)adapter patientChatDealWarningWithModel:(MessageBaseModel *)baseModel {
    // 处理预警
    NSString* content = baseModel._content;
    if (!content || 0 == content.length) {
        return;
    }
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    MessageBaseModelTestResultPage *testResultPageModel = [MessageBaseModelTestResultPage mj_objectWithKeyValues:dicContent];
    UserAlertInfo *alertInfo = [UserAlertInfo new];
    alertInfo.kpiCode = testResultPageModel.kpiCode;
    alertInfo.testResulId = testResultPageModel.testResulId;
    alertInfo.userId = testResultPageModel.userId.integerValue;
    alertInfo.sex = testResultPageModel.sex;
    alertInfo.age = testResultPageModel.age.integerValue;
    alertInfo.userName = testResultPageModel.userName;
    alertInfo.testName = testResultPageModel.kpiName;
    
    [HMViewControllerManager createViewControllerWithControllerName:@"DealUserWarningViewController" ControllerObject:alertInfo];
}

- (void)chatTableViewAdapterDelegateCallBack_adapter:(ChatTableViewAdapter *)adapter patientChatDealPatientRoundsWithModel:(MessageBaseModel *)baseModel tag:(NSInteger)tag {
    NSString* content = baseModel._content;
    if (!content || 0 == content.length) {
        return;
    }
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    MessageBaseModelRoundsPush* modelContent = [MessageBaseModelRoundsPush mj_objectWithKeyValues:dicContent];
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    [dicPost setValue:@(modelContent.userId.integerValue) forKey:@"userId"];
    [dicPost setValue:@(modelContent.recordId.integerValue) forKey:@"recordId"];
    [dicPost setValue:@(tag) forKey:@"replyStatus"];
    [dicPost setValue:@(1) forKey:@"feedBackType"];
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMIMCELLFeedBackPatientRoundsRequest" taskParam:dicPost TaskObserver:self];
}
#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError)
    {
        [self.view closeWaitView];
        
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self.view closeWaitView];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"HMIMCELLFeedBackPatientRoundsRequest"])
    {
        
    }
    else if ([taskname isEqualToString:@"HMAddImageToIllnessRequest"]) {
        [self at_postSuccess:@"收藏成功"];
    }
    else if ([taskname isEqualToString:@"SurveyRecordInfoTask"]) {
        //跳转到随访填写界面
        SurveyRecord* record = [SurveyRecord mj_objectWithKeyValues:taskResult[@"record"]];
        if (record.status == 0) {
            [self at_postError:@"该表未填写"];
            return;
        }
        [HMViewControllerManager createViewControllerWithControllerName:@"SurveyRecordDatailViewController" ControllerObject:record];
    }
    
    
}

#pragma mark - getter & setter

- (CoordinationFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[CoordinationFilterView alloc] initWithImageNames:@[@"c_historyList",@"c_groupID"] titles:@[@"历史消息",@"群名片"] tags:@[@(ChatMenuHistoryList),@(ChatMenuGroupInfo)]];
        _filterView.delegate = self;
    }
    return _filterView;
}

- (UILabel *)serviceEnd {
    if (!_serviceEnd) {
        _serviceEnd = [UILabel new];
        _serviceEnd.textAlignment = NSTextAlignmentCenter;
        _serviceEnd.backgroundColor = [UIColor commonSeperatorColor_dfdfdf];
        _serviceEnd.font = [UIFont font_32];
        _serviceEnd.textColor = [UIColor commonLightGrayColor_999999];
        _serviceEnd.text = @"咨询服务未开通/已到期";
        _serviceEnd.hidden = YES;
    }
    return _serviceEnd;
}

- (DealUserAlertPromptView *)alertPromptView{
    if (!_alertPromptView) {
        _alertPromptView = [[DealUserAlertPromptView alloc] init];
    }
    return _alertPromptView;
}

- (PatientDetailPromptView *)promptView{
    if (!_promptView) {
        _promptView = [PatientDetailPromptView new];
    }
    return _promptView;
}

- (PatientInfo *)patient {
    if (!_patient) {
        _patient = [PatientInfo new];
    }
    return _patient;
}
@end

