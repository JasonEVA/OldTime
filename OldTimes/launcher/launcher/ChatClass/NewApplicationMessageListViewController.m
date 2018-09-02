//
//  NewApplicationMessageListViewController.m
//  launcher
//
//  Created by 马晓波 on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplicationMessageListViewController.h"
#import <Masonry.h>
#import "ChatEventMissionTableViewCell.h"
#import "ChatEventScheduleTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "MyDefine.h"
#import "GetTaskDetailRequest.h"
#import "MissionDetailViewController.h"
#import "AppTaskModel.h"
#import "ChatShowDateTableViewCell.h"
#import "NewCalculateHeightManager.h"
#import "NewApplyDetailV2ViewController.h"
#import "GetMeetingDetailRequest.h"
#import "AppScheduleModel.h"
#import "MeetingConfirmViewController.h"
#import "AppApprovalModel.h"
#import "ApplyCommentView.h"
#import "ApplyForwardingV2Request.h"
#import "ApplyDealWiththeApplyV2Request.h"
#import "MeetingConfirmMeetingRequest.h"
#import "SelectContactBookViewController.h"
#import "UIColor+Hex.h"
#import "UIButton+DeterReClicked.h"
#import "CalendarViewController.h"
#import "NewCalendarViewController.h"
#import "ApplyTabBarController.h"
#import "TestMaininterfaceViewControlViewController.h"
#import "CalendarGetRequest.h"
#import "CalendarNewEventMakeSureViewController.h"
#import "NewApplyMainV2ViewController.h"
#import "NewMissionContainViewController.h"
#import "NewDetailMissionViewController.h"
#import "TaskListModel.h"
#import "NewChatApproveEventTableViewCell.h"
#import "NewChatShowDateTableViewCell.h"
#import "JSONKitUtil.h"
#import "NewEventScheduleTableViewCell.h"
#import "NewChatEventMissionTableViewCell.h"
#import "ChatIMConfigure.h"
#import <MintcodeIM/MintcodeIM.h>
#import "NewMissionGetMissionDetailRequest.h"
#import "NewMeetingConfirmViewController.h"
#import "NewCalendarMakeSureViewController.h"

static NSString *task_cell     = @"task_cell";
static NSString *schedule_cell = @"schedule_cell";
static NSString *approval_cell = @"approval_cell";
static NSString *system_cell = @"system_cell";
static NSString *Newsystem_cell = @"Newsystem_cell";

typedef enum{
    actionSheetTag_normal = 0,
    actionSheetTag_isWorkFlow = 1
}actionSheetTag;

#define COUNT_MSG 20

@interface NewApplicationMessageListViewController ()<UITableViewDelegate,UITableViewDataSource,BaseRequestDelegate,ApplyCommentViewDelegate,UIActionSheetDelegate,MessageManagerDelegate,ChatEventScheduleTableViewCellDelegate,NewChatApproveEventTableViewCellDelegate, NewEventScheduleTableViewCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *titleView;

// Data
@property (nonatomic) IM_Applicaion_Type appType;         // 应用类型
@property (nonatomic, strong) NSArray *arrayDisplay;

@property (nonatomic) NSInteger currCount;               // 当前查看信息条数
@property (nonatomic) BOOL isPullRefresh;                // 标记是否是下拉刷新
@property (nonatomic) NSInteger lastCount;               // 上一次条数
@property (nonatomic, strong) NSString *strUid;

@property (nonatomic,strong) ApplyCommentView * appCommentView;
@property (nonatomic,strong) NSString * strReason;
@property (nonatomic,strong) NSString * strNextApprovers;
@property (nonatomic,strong) NSString * strNextApproverNames;
@property (nonatomic,strong) NSString * status;
@property (nonatomic,strong) NSString * ShowID;

@property (nonatomic, assign) BOOL isFirstShow;  // 记录 是不是第一次打开此界面

@end

@implementation NewApplicationMessageListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.appType) {
        case IM_Applicaion_task:
            self.navigationItem.title = LOCAL(Application_Mission);
            break;
        case IM_Applicaion_schedule:
            self.navigationItem.title = LOCAL(Application_Calendar);
            break;
        case IM_Applicaion_approval:
            self.navigationItem.title = LOCAL(Application_Apply);
            break;
            
        default:
            break;
    }
    
    [self initComponents];
    [[MessageManager share] setDelegate:self];
    
    [self getHistoryMessage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MessageManager share] setDelegate:self];
    [self refreshView];
    
    //    MessageBaseModel *baseModel = [self.arrayDisplay firstObject];
    //    // 取出该聊天所有未读消息(除去语音)
    //    NSArray *arrMsgId = [[MessageManager share] getAllUnReadedMessageListWithUid:self.strUid msgId:baseModel._msgId];
    [self sendReadMessageRequestWith:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[MessageManager share] setDelegate:nil];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)nil;
    
}

#pragma mark - Interface Method
- (instancetype)initWithAppType:(IM_Applicaion_Type)type
{
    if (self = [super init])
    {
        self.appType = type;
        switch (type) {
            case IM_Applicaion_task:
                self.strUid = im_task_uid;
                break;
            case IM_Applicaion_approval:
                self.strUid = im_approval_uid;
                break;
            case IM_Applicaion_schedule:
                self.strUid = im_schedule_uid;
                break;
        }
    }
    
    return self;
}

#pragma mark - Private Method
- (void)initComponents
{
    self.isPullRefresh = NO;
    self.currCount = COUNT_MSG;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.titleView];
    
    [self initConstraints];
}

// 获取历史消息
- (void)getHistoryMessage
{
    [[MessageManager share] getHistoryMessageWithUid:self.strUid MessageCount:self.currCount];
}

- (void)initConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.titleView.mas_top);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@49);
    }];
}

// 获得委托
- (void)getDelegate {
    [[MessageManager share] setDelegate:self];
}

// 获取应用消息 并刷新界面
- (void)refreshView
{
    self.lastCount = self.arrayDisplay.count;
    
    MessageBaseModel * oldModel = [self.arrayDisplay lastObject];
    long long oldMsgId = oldModel._msgId;
    
    //如果不是第一次打开此页面
    if (_isFirstShow) {
        // 看缓存中最老的消息是否是最新的
        
        BOOL isNewestMegId = [[MessageManager share] queryMessageIsNewestWithTagert:self.strUid msgid:oldMsgId];
        // 如果不是最新的
        if (!isNewestMegId) {
            // 缓存容量 +1
            self.currCount += 1;
        }
    }
    
    [[MessageManager share] queryBatchMessageWithUid:self.strUid MessageCount:self.currCount completion:^(NSArray *arrayData) {
        self.arrayDisplay = [arrayData mutableCopy];
        for (MessageBaseModel *model in arrayData)
        {
            // 系统消息
            if ([model.appModel isAppSystemMessage])
            {
                model._type = msg_personal_alert;
            }
        }
        
        [self.tableView reloadData];
        
        if (self.arrayDisplay.count > 0)
        {
            // 如果是下拉刷新状态的话就滚到原来第一条的时候
            if (_isPullRefresh)
            {
                [self.tableView.header endRefreshing];
                _isPullRefresh = NO;
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.arrayDisplay.count - self.lastCount inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            else
            {
                if ([self isNeedScrollWithOffSet]) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.arrayDisplay.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
            }
        }
    }];
}

- (BOOL)isNeedScrollWithOffSet
{
    if (!_isFirstShow) {
        _isFirstShow = YES;
        return YES;
    }
    CGSize contentSize =  self.tableView.contentSize;
    CGPoint offSet     =  self.tableView.contentOffset;
    
    CGFloat distance = contentSize.height - offSet.y - self.tableView.frame.size.height;
    if (distance <= 350) {
        return YES;
    }
    return NO;
}


// 下拉刷新
- (void)pullRefreshData
{
    self.currCount += COUNT_MSG;
    
    self.isPullRefresh = YES;
    
    //    [self refreshView];
    [self getHistoryMessage];
}

// 发送消息已读
- (void)sendReadMessageRequestWith:(NSArray *)arrMsgId
{
    [[MessageManager share] sendReadedRequestWithUid:self.strUid messages:arrMsgId];
}

#pragma mark - Event Responder
- (void)titleClicked
{
    //按钮暴力点击防御
    [self.titleView mtc_deterClickedRepeatedly];
    
    id VC = nil;
    // 跳进相应的首页界面
    switch (self.appType) {
        case IM_Applicaion_task:
            VC = [[NewMissionContainViewController alloc] init];
            [VC selectAtIndex:2];
            [VC presentedByViewController:self];
            return;
            break;
            
        case IM_Applicaion_approval:
        {
            VC = [[NewApplyMainV2ViewController alloc] init];
            break;
        }
            
        case IM_Applicaion_schedule:
//            VC = [[CalendarViewController alloc] init];
            VC = [[NewCalendarViewController alloc] init];
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayDisplay.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageBaseModel *messageModel = self.arrayDisplay[indexPath.row];
    
    if (messageModel._type == IM_Applicaion_task)
    {
        AppTaskModel *model = [AppTaskModel mj_objectWithKeyValues:messageModel.appModel.applicationDetailDictionary];
        if (model.projectName.length == 0 && model.end <= 0)
        {
            return 97.5 + 35 + 15;
        }
        else
        {
            return 97.5 + 35 * 2 + 15;
        }
    }
    else if (messageModel._type == IM_Applicaion_schedule)
    {
        CGFloat height = [NewCalculateHeightManager calculateHeightByContent:messageModel.appModel Type:type_meeting IsShowGroupMemberNick:NO];
        return height;
    }
    else if (messageModel._type == msg_personal_alert)
    {
            MessageAppModel *appModel = messageModel.appModel;
            NSString *text = [IMApplicationUtil getMsgTextWithModel:appModel];
            
            if ([appModel.msgTransType isEqualToString:@"comment"])
            {
                NSString *str =  [[appModel.msgInfo mtc_objectFromJSONString] objectForKey:@"comment"]?:nil;
                if (str != nil && str.length > 0)
                {
                    text = str;
                }
            }
            
            NSString *strfile = [[appModel.msgInfo mtc_objectFromJSONString] objectForKey:@"filePath"]?:@"";
            CGSize size;
            if (strfile.length > 0)
            {
                UIFont *font = [UIFont systemFontOfSize:13];
                NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
                size = [text boundingRectWithSize:CGSizeMake(IOS_SCREEN_WIDTH - 12.5 - 40 -12 - 13 - 20 - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            }
            else
            {
                UIFont *font = [UIFont systemFontOfSize:13];
                NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
                size = [text boundingRectWithSize:CGSizeMake(IOS_SCREEN_WIDTH - 12.5 - 40 -12 - 13 - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            }
            
            // 设置label长度
            if (size.height > 20)
            {
                return 165;
            }
            else
            {
                return 145;
            }        
    }
    else if (messageModel._type == IM_Applicaion_approval)
    {
        CGFloat height = [NewCalculateHeightManager calculateHeightByContent:messageModel.appModel Type:type_approval IsShowGroupMemberNick:NO];
        return height;
        
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    MessageBaseModel *messageModel = self.arrayDisplay[indexPath.row];
    if (![messageModel isEventType]) {
        cell = [tableView dequeueReusableCellWithIdentifier:Newsystem_cell];
        [(NewChatShowDateTableViewCell *)cell showDateAndEvent:messageModel ifEvent:NO];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
        return cell;
    }
    switch ((IM_Applicaion_Type)messageModel._type) {
        case IM_Applicaion_task:
        {
            //            cell = [tableView dequeueReusableCellWithIdentifier:task_cell];
            //            [(ChatEventMissionTableViewCell *)cell setCellData:messageModel];
            //            __weak typeof(self) weakSelf = self;
            //            [(ChatEventMissionTableViewCell *)cell setShowDetail:^{
            //                [weakSelf tableView:tableView didSelectRowAtIndexPath:indexPath];
            //            }];
            cell = [tableView dequeueReusableCellWithIdentifier:task_cell];
            [(NewChatEventMissionTableViewCell *)cell setCellData:messageModel];
        }
            break;
            
        case IM_Applicaion_schedule:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:schedule_cell];
            [(NewEventScheduleTableViewCell *)cell setCellData:messageModel];
            ((NewEventScheduleTableViewCell *)cell).delegate = self;
        }
            break;
            
        case IM_Applicaion_approval:
        {
            /**
             *    approvalShowID :   // 请假 = vEyVJ7K29qcovp3p     费用 = BB1xoKW53kCPW7OP
             *    如果approvalShowID 不存在,或者不在这两个之内,都会出问题
             *    前者界面展示错误 , 后者直接崩溃  !!!!
             *    ---> 现在不会了,不在这两个中的,会用另外的方式展示 PS: 2015.11.04
             */
            cell = [tableView dequeueReusableCellWithIdentifier:approval_cell forIndexPath:indexPath];
            [(NewChatApproveEventTableViewCell *)cell setCellData:messageModel];
            [(NewChatApproveEventTableViewCell *)cell setDelegate:self];
            [(NewChatApproveEventTableViewCell *)cell setPath_row:indexPath.row];
        }
            break;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor grayBackground]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageBaseModel *messageModel = self.arrayDisplay[indexPath.row];
    
    [self postLoading];
    switch (self.appType) {
        case IM_Applicaion_task:
        {
            [self hideLoading];
            TaskListModel *taskListModel = [TaskListModel new];
            AppTaskModel *taskModel = [AppTaskModel mj_objectWithKeyValues:messageModel.appModel.applicationDetailDictionary];
            if (taskModel.id.length != 0)
            {
                taskListModel.showId = taskModel.id;
            }
            else
            {
                // 任务系统消息
                taskListModel.showId = messageModel.appModel.msgRMShowID;
            }
            NewMissionGetMissionDetailRequest *request = [[NewMissionGetMissionDetailRequest alloc] initWithDelegate:self];
             [request getDetailTaskWithId:taskListModel.showId];
            [self postLoading];
//            NewDetailMissionViewController *VC = [[NewDetailMissionViewController alloc] initWithMissionDetailModel:taskListModel];
//            VC.isFirstVC = YES;
//            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        case IM_Applicaion_schedule:
        {
            MsgAppType type = [IMApplicationUtil getMsgAppTypeWith:messageModel.appModel.msgAppType];
            CalendarLaunchrModel *model = [CalendarLaunchrModel new];
            AppScheduleModel *scheduleModel = [AppScheduleModel mj_objectWithKeyValues:messageModel.appModel.applicationDetailDictionary];
            model.relateId = scheduleModel.id;
            [model.time addObject:[NSDate dateWithTimeIntervalSince1970:scheduleModel.start / 1000]];
            switch (type) {
                case AppType_S_Remind:
                case AppType_EVENT_COMMENT:
                    model.showId = messageModel.appModel.msgRMShowID;
                    // fallthrough
                case AppType_Event: {
                    CalendarGetRequest *request = [[CalendarGetRequest alloc] initWithDelegate:self];
                    [request getCalendarWithModel:model];
                }
                    break;
                case AppType_M_Remind:
                case AppType_FromCC:
                case AppType_FromReceiver:
                case AppType_MEETING_COMMENT:
                case AppType_Meeting:
                case AppType_APPROVAL_COMMENT:
                {    model.relateId = messageModel.appModel.msgRMShowID;
                    // fallthrough
                    
                    GetMeetingDetailRequest *request = [[GetMeetingDetailRequest alloc] initWithDelegate:self];
                    [request getMeetingDetailWithShowID:model.relateId startTime:model.time[0]];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        case IM_Applicaion_approval:
        {
            NewApplyDetailV2ViewController *detailVc;
            NSString *showId;
            AppApprovalModel *approvalModel = [AppApprovalModel mj_objectWithKeyValues:messageModel.appModel.applicationDetailDictionary];
            if (approvalModel.id.length != 0)
            {
                showId = approvalModel.id;
            }
            else
            {
                // 审批系统消息
                showId = messageModel.appModel.msgRMShowID;
            }
            detailVc = [[NewApplyDetailV2ViewController alloc] initWithShowID:showId];
            
            [self hideLoading];
            [self.navigationController pushViewController:detailVc animated:YES];
        }
            
            break;
            
        default:
            break;
    }
}



#pragma mark - ChatApprovalEventTableViewCellDelegate
- (void)approvalCellButtonClick:(NSString *)type path_row:(NSInteger)row
{
    [self setApplicationType:type path_row:row];
}

- (void)approvalCellButtonClick:(NSString *)type path_row:(NSInteger)row isWorkFlow:(BOOL)workflow
{
    self.status = type;
    MessageBaseModel * model = self.arrayDisplay[row];
    MessageAppModel * appModel = model.appModel;
    AppApprovalModel * approvalModel = [AppApprovalModel mj_objectWithKeyValues:appModel.applicationDetailDictionary];
    self.ShowID = approvalModel.id;
    
    if ([type isEqualToString:pass])
    {
        if (workflow)
        {
            UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(APPLY_MAKESURE), nil];
            actionSheet.tag = actionSheetTag_isWorkFlow;
            [actionSheet showInView:self.view];
        }
        else
        {
            UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(APPLY_MAKESURE),LOCAL(APPLY_MAKESURE_FORWARD), nil];
            actionSheet.tag = actionSheetTag_normal;
            [actionSheet showInView:self.view];
        }
        
    }
    else
    {
        [self ApplyCommentViewType:kNoApprover];
    }
}

- (void)setApplicationType:(NSString *)type path_row:(NSInteger)row
{
    self.status = type;
    MessageBaseModel * model = self.arrayDisplay[row];
    MessageAppModel * appModel = model.appModel;
    AppApprovalModel * approvalModel = [AppApprovalModel mj_objectWithKeyValues:appModel.applicationDetailDictionary];
    self.ShowID = approvalModel.id;
    
    if ([type isEqualToString:pass]) {
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(APPLY_MAKESURE),LOCAL(APPLY_MAKESURE_FORWARD), nil];
        [actionSheet showInView:self.view];
    } else {
        [self ApplyCommentViewType:kNoApprover];
    }
}

- (void)ApplyCommentViewType:(COMMENTSTATUS)type
{
    _appCommentView = [[ApplyCommentView alloc] initWithFrame:[UIScreen mainScreen].bounds withType:type];
    _appCommentView.delegate = self;
    [self.view addSubview:_appCommentView];
    [_appCommentView showKeyBoard];
}

// 会议是否参加
- (void)ChatEventScheduleTableViewCellDelegateCallBack_btnAttendClicked:(BOOL)isAttend ShowId:(NSString *)showId
{
    MeetingConfirmMeetingRequest *confirmRequest = [[MeetingConfirmMeetingRequest alloc] initWithDelegate:self];
    [confirmRequest ConfirmWhetherAttendWith:showId WhetherAgree:isAttend Reason:nil];
    
    [self postLoading];
    
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == actionSheetTag_isWorkFlow)
    {
        switch (buttonIndex) {
            case 0:
            {
                ApplyDealWiththeApplyV2Request *request = [[ApplyDealWiththeApplyV2Request alloc] initWithDelegate:self];
                [request GetShowID:self.ShowID WithStatus:self.status WithReason:@""];
                [self postLoading];
                
            }
                break;
            case 1:
            case 2:
            {
                
            }
                break;
            default:
                break;
        }
    }
    else
    {
        switch (buttonIndex) {
            case 0:
            {
                ApplyDealWiththeApplyV2Request *request = [[ApplyDealWiththeApplyV2Request alloc] initWithDelegate:self];
                [request GetShowID:self.ShowID WithStatus:self.status WithReason:@""];
                [self postLoading];
                
            }
                break;
                
            case 1:
            {
                [self ApplyCommentViewType:kAddApprover];
                //
            }
                break;
                
            case 2:
            {
                return;
            }
                break;
                
            default:
                break;
        }
    }
    
}

#pragma mark - ApplyCommentViewDelegate

- (void)ApplyCommentViewDelegateCallBack_SendTheTxt:(NSString *)text
{
    self.strReason = text;
    
    if ([self.status isEqualToString:@"APPROVE"])//同意
    {
        if ([text isEqualToString:@""] || !self.strNextApprovers)
        {
            if ([text isEqualToString:@""])   //审批意见是否为空
            {
                UIAlertView *view = [[UIAlertView alloc] initWithTitle:LOCAL(APPLY_INPUT_APPLY_SUGGEST) message:nil delegate:self cancelButtonTitle:LOCAL(CERTAIN) otherButtonTitles:nil];
                [view show];
            }
            else
            {
                // 转发 - 是否选择转发人
                UIAlertView *view = [[UIAlertView alloc] initWithTitle:LOCAL(APPLY_INPUT_NEXT_APPRALLER) message:nil delegate:self cancelButtonTitle:LOCAL(CERTAIN) otherButtonTitles:nil];
                [view show];
            }
        }
        else
        {
            ApplyForwardingV2Request *request = [[ApplyForwardingV2Request alloc] initWithDelegate:self];
            [request GetShowID:self.ShowID WithApprove:self.strNextApprovers WithApproveName:self.strNextApproverNames WithReason:self.strReason];
            [self postLoading];
        }
    }
    else
    {
        ApplyDealWiththeApplyV2Request *request = [[ApplyDealWiththeApplyV2Request alloc] initWithDelegate:self];
        [request GetShowID:self.ShowID WithStatus:self.status WithReason:self.strReason];
        [self postLoading];
    }
    
}
- (void)ApplyCommentViewDelegateCallBack_PresentAnotherVC
{
    SelectContactBookViewController *VC = [[SelectContactBookViewController alloc] init];
    VC.singleSelectable = YES;
    
    __weak typeof(self) weakSelf = self;
    [VC selectedPeople:^(NSArray *array) {
        ContactPersonDetailInformationModel *model = [array firstObject];
        if (!model) {
            return;
        }
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.strNextApprovers = model.show_id;
        strongSelf.strNextApproverNames = model.u_true_name;
        [strongSelf.appCommentView setCommentViewStatus:kNextApprover];
        [strongSelf.appCommentView setHeadNameWithModel:model];
    }];
    
    [self presentViewController:VC animated:YES completion:nil];
}

#pragma mark - MessageDelegate
// 消息补充（附件等下载）等需要针对某个聊天对象重新刷新显示————针对和某个对象的聊天窗口内容变化时
- (void)MessageManagerDelegateCallBack_needRefreshWithTareget:(NSString *)target
{
    if ([target isEqualToString:self.strUid])
    {
        [self refreshView];
        [self sendReadMessageRequestWith:nil];
    }
}

#pragma mark - Request Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([request isKindOfClass:[GetTaskDetailRequest class]])
    {
        MissionDetailModel *detailModel = [(id)response detailModel];
        MissionDetailViewController *MDVC = [[MissionDetailViewController alloc] initWithMissionDetailModel:detailModel];
        [self.navigationController pushViewController:MDVC animated:YES];
    }
    
    else if ([response isKindOfClass:[GetMeetingDetailResponse class]])
    {
        GetMeetingDetailResponse *result = (GetMeetingDetailResponse *)response;
        // TODO重复提示 暂时为NO
        NewMeetingConfirmViewController *DetailVC = [[NewMeetingConfirmViewController alloc] initWithModel:result.meetingModel WithRepeatType:calendar_repeatNo];
        [self.navigationController pushViewController:DetailVC animated:YES];
    }
    
    else if ([request isKindOfClass:[CalendarGetRequest class]]) {
        CalendarLaunchrModel *model = [(id)response modelCalendar];
        
        NewCalendarMakeSureViewController *CNEMSVC = [[NewCalendarMakeSureViewController alloc] initWithModelShow:model];
        [self.navigationController pushViewController:CNEMSVC animated:YES];
       
    }
    else if ([request isKindOfClass:[NewMissionGetMissionDetailRequest class]])
    {
        NewMissionGetMissionDetailResponse *result = (NewMissionGetMissionDetailResponse *)response;
        
        NewDetailMissionViewController *VC = [[NewDetailMissionViewController alloc] initWithOnlyShowID:result.detailModel.showId];
        VC.isFirstVC = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
    [self hideLoading];
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - Init UI
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [UITableView new];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setBackgroundColor:[UIColor grayBackground]];
        [_tableView registerClass:[NewChatEventMissionTableViewCell class] forCellReuseIdentifier:task_cell];
        [_tableView registerClass:[NewEventScheduleTableViewCell class] forCellReuseIdentifier:schedule_cell];
        [_tableView registerClass:[ChatShowDateTableViewCell class] forCellReuseIdentifier:system_cell];
        [_tableView registerClass:[NewChatApproveEventTableViewCell class] forCellReuseIdentifier:approval_cell];
        [_tableView registerClass:[NewChatShowDateTableViewCell class] forCellReuseIdentifier:Newsystem_cell];
        // 添加动画图片的下拉刷新
        // 上拉刷新
        _tableView.header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefreshData)];
    }
    
    return _tableView;
}

- (UIButton *)titleView
{
    if (!_titleView)
    {
        _titleView = [UIButton new];
        [_titleView setBackgroundColor:[UIColor whiteColor]];
        NSString *title;
        UIImage *image;
        UIImage *imageSelected;
        switch (self.appType) {
            case IM_Applicaion_approval:
            {
                title = [NSString stringWithFormat:@"%@%@",LOCAL(Application_Apply),LOCAL(LOOK)];
                image = [UIImage imageNamed:@"app_title_approval"];
                imageSelected = [UIImage imageNamed:@"app_title_approvalselected"];
            }
                break;
                
            case IM_Applicaion_task:
            {
                title = [NSString stringWithFormat:@"%@%@",LOCAL(Application_Mission),LOCAL(LOOK)];
                image = [UIImage imageNamed:@"app_title_task"];
                imageSelected = [UIImage imageNamed:@"app_title_taskselected"];
            }
                break;
                
            case IM_Applicaion_schedule:
            {
                title = [NSString stringWithFormat:@"%@%@",LOCAL(Application_Calendar),LOCAL(LOOK)];
                image = [UIImage imageNamed:@"app_title_calendar"];
                imageSelected = [UIImage imageNamed:@"app_title_calendarselected"];
            }
                
            default:
                break;
        }
        
        [_titleView setTitle:title forState:UIControlStateNormal];
        [_titleView setImage:image forState:UIControlStateNormal];
        [_titleView setImage:imageSelected forState:UIControlStateHighlighted];
        _titleView.titleLabel.layer.sublayerTransform = CATransform3DMakeTranslation(15,0,0);
        [_titleView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_titleView setTitleColor:[UIColor themeBlue] forState:UIControlStateHighlighted];
        [_titleView.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_titleView.layer setBorderWidth:0.4];
        [_titleView.layer setBorderColor:[UIColor themeGray].CGColor];
        [_titleView addTarget:self action:@selector(titleClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _titleView;
}

@end
