//
//  ApplicationMessageSearchListViewController.m
//  launcher
//
//  Created by TabLiu on 15/10/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplicationMessageSearchListViewController.h"
#import <Masonry.h>
#import "ChatEventMissionTableViewCell.h"
#import "ChatEventScheduleTableViewCell.h"
#import <MintcodeIM/MintcodeIM.h>
#import <MJRefresh/MJRefresh.h>
#import "MyDefine.h"
#import "AppTaskModel.h"
#import "ChatShowDateTableViewCell.h"
#import "ApplyAcceptDetailViewController.h"
#import "GetMeetingDetailRequest.h"
#import "CalendarNewEventMakeSureViewController.h"
#import "AppScheduleModel.h"
#import "MeetingConfirmViewController.h"
#import "AppApprovalModel.h"
#import "ApplyCommentView.h"
#import "ApplyCommentView.h"
#import "ApplyForwardingRequest.h"
#import "ApplyDealWiththeApplyRequest.h"
#import "MeetingConfirmMeetingRequest.h"
#import "SelectContactBookViewController.h"
#import "UIColor+Hex.h"
#import "ChatApprovalEventTableViewCell.h"
#import "CalendarGetRequest.h"
#import "NewChatApproveEventTableViewCell.h"
#import "NewChatEventMissionTableViewCell.h"
#import "NewEventScheduleTableViewCell.h"
#import "NewChatShowDateTableViewCell.h"
#import "JSONKitUtil.h"
#import "TaskListModel.h"
#import "NewMissionGetMissionDetailRequest.h"
#import "NewDetailMissionViewController.h"
#import "NewApplyDetailV2ViewController.h"
#import "NewApplyDetailV2Request.h"

static NSString * const task_cell      = @"task_cell";
static NSString * const schedule_cell  = @"schedule_cell";
static NSString * const approval_cell  = @"approval_cell";
static NSString * const system_cell    = @"system_cell";
static NSString * const Newsystem_cell = @"Newsystem_cell";

#define COUNT_MSG 10

@interface ApplicationMessageSearchListViewController () <UITableViewDelegate,UITableViewDataSource,BaseRequestDelegate,ApplyCommentViewDelegate,UIActionSheetDelegate,MessageManagerDelegate,ChatEventScheduleTableViewCellDelegate,ChatApprovalEventTableViewCellDelegate, NewEventScheduleTableViewCellDelegate>
@property (nonatomic, strong) UITableView *tableView;

// Data
@property (nonatomic) IM_Applicaion_Type appType;         // 应用类型

@property (nonatomic) NSInteger currCount;               // 当前查看信息条数
@property (nonatomic) NSInteger lastCount;               // 上一次条数

@property (nonatomic,strong) ApplyCommentView * appCommentView;
@property (nonatomic,strong) NSString * strReason;
@property (nonatomic,strong) NSString * strNextApprovers;
@property (nonatomic,strong) NSString * strNextApproverNames;
@property (nonatomic,strong) NSString * status;
@property (nonatomic,strong) NSString * ShowID;
@property (nonatomic, assign) BOOL isRequesting;

@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation ApplicationMessageSearchListViewController

- (instancetype)initWithAppType:(IM_Applicaion_Type)type
{
    if (self = [super init])
    {
        self.appType = type;
        
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
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.titleString;
    
    [self initComponents];
    
    NSArray * array = [[MessageManager share] queryOlderEvevtMessageHistoryFromCreatDate:self.creatDate+1 count:1 uid:self.uidStr];
    if (array.count > 0) {
        //将得到的数据插入到数据源数组前面
        NSRange range = NSMakeRange(0, array.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.dataArray insertObjects:array atIndexes:indexSet];
        NSInteger row = array.count;
        NSIndexPath * path = [NSIndexPath indexPathForRow:row - 1 inSection:0];
        
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

#pragma mark - Private Method
- (void)initComponents
{
    self.currCount = COUNT_MSG;
    [self.view addSubview:self.tableView];
    
    [self initConstraints];
}

- (void)initConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


- (void)headRefreshDataWithSqlID:(long long)sqlid creatDate:(long long)creatDate
{
    NSArray * array = [[MessageManager share] queryOlderEvevtMessageHistoryFromCreatDate:creatDate count:COUNT_MSG uid:self.uidStr];
    if (array.count > 0) {
        for (MessageBaseModel *model in array)
        {
            // 系统消息
            if ([model.appModel isAppSystemMessage])
            {
                model._type = msg_personal_alert;
            }
        }
        //将得到的数据插入到数据源数组前面
        NSRange range = NSMakeRange(0, array.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.dataArray insertObjects:array atIndexes:indexSet];
        NSInteger row = array.count;
        NSIndexPath * path = [NSIndexPath indexPathForRow:row - 1 inSection:0];
        
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    [self.tableView.header endRefreshing];
}

- (void)footRefreshDataWithSqlID:(long long)sqlid creatDate:(long long)creatDate
{
    NSArray * array = [[MessageManager share] queryNewerEventMessageHistoryFromCreatDate:creatDate count:COUNT_MSG uid:self.uidStr];
    if (array.count > 0) {
        for (MessageBaseModel *model in array)
        {
            // 系统消息
            if ([model.appModel isAppSystemMessage])
            {
                model._type = msg_personal_alert;
            }
        }
        NSRange range = NSMakeRange(self.dataArray.count, array.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.dataArray insertObjects:array atIndexes:indexSet];
        
        NSIndexPath * path = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
        
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];
        
    }
    [self.tableView.footer endRefreshing];
}


// 下拉刷新
- (void)pullRefreshData
{
    MessageBaseModel * model = [self.dataArray firstObject];
    NSInteger sqlid = model._sqlId;
    [self headRefreshDataWithSqlID:sqlid creatDate:model._createDate];
}

// 上拉
- (void)footRefreshData
{
    MessageBaseModel * model = [self.dataArray lastObject];
    NSInteger sqlid = model._sqlId;
    [self footRefreshDataWithSqlID:sqlid creatDate:model._createDate];
}

- (void)sendMissionGetDetailRequestWithMessageBaseModel:(MessageBaseModel *)model {
	if (self.isRequesting) {
		return;
	}
	
	MessageAppModel *appModel = model.appModel;
	TaskListModel *taskListModel = [TaskListModel new];
	AppTaskModel *taskModel = [AppTaskModel mj_objectWithKeyValues:appModel.applicationDetailDictionary];
	if (taskModel.id.length != 0)
	{
		taskListModel.showId = taskModel.id;
	}
	else
	{
		// 任务系统消息
		taskListModel.showId = appModel.msgRMShowID;
	}
	NewMissionGetMissionDetailRequest *request = [[NewMissionGetMissionDetailRequest alloc] initWithDelegate:self];
	[request getDetailTaskWithId:taskListModel.showId];
	self.isRequesting = YES;
	[self postLoading];
	
}

- (void)sendApplyDetailRequestWithMessageBaseeModel:(MessageBaseModel *)model {
	if (self.isRequesting) {
		return;
	}
	
	AppApprovalModel *approvalModel = [AppApprovalModel mj_objectWithKeyValues:model.appModel.applicationDetailDictionary];
	
	NewApplyDetailV2Request *request = [[NewApplyDetailV2Request alloc] initWithDelegate:self];
	[request detailWithShowId:approvalModel.id];
	self.isRequesting = YES;
	
}

/**
 *  防止用户重复点击导致重复请求的情况
 */
- (void)resetRequestState {
	self.isRequesting = NO;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
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
    MessageBaseModel *messageModel = self.dataArray[indexPath.row];
    
    if (messageModel._type == IM_Applicaion_task)
    {
		return [NewChatEventMissionTableViewCell height];
    }
    else if (messageModel._type == IM_Applicaion_schedule)
    {
        return [NewEventScheduleTableViewCell heightForModel:messageModel];
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
        return [NewChatApproveEventTableViewCell cellHeightWithAppModel:messageModel.appModel];
    }
	
    return 10;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    MessageBaseModel *messageModel = self.dataArray[indexPath.row];
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
	
	MessageBaseModel *messageModel = self.dataArray[indexPath.row];
	
	switch (self.appType) {
		case IM_Applicaion_task:
		{
			[self sendMissionGetDetailRequestWithMessageBaseModel:messageModel];
			
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
					model.showId = messageModel.appModel.msgRMShowID;
					// fallthrough
				case AppType_Event: {
					CalendarGetRequest *request = [[CalendarGetRequest alloc] initWithDelegate:self];
					[request getCalendarWithModel:model];
					[self postLoading];
				}
					break;
				case AppType_MEETING_COMMENT:
				case AppType_M_Remind:
				case AppType_FromCC:
				case AppType_FromReceiver:
					model.relateId = messageModel.appModel.msgRMShowID;
					// fallthrough
				case AppType_Meeting: {
					GetMeetingDetailRequest *request = [[GetMeetingDetailRequest alloc] initWithDelegate:self];
					[request getMeetingDetailWithShowID:model.relateId startTime:model.time[0]];
					[self postLoading];
				}
					break;
				default:
					break;
			}
		}
			break;
			
		case IM_Applicaion_approval:
		{
			[self sendApplyDetailRequestWithMessageBaseeModel:messageModel];
			
		}
			
		default:
			break;
	}
}

#pragma mark - ChatApprovalEventTableViewCellDelegate
- (void)approvalCellButtonClick:(NSString *)type path_row:(NSInteger)row
{
    [self setApplicationType:type path_row:row];
}

#pragma mark - CharEventPassTableViewCellDelegate   ChatApprovalEventMoneyListTableViewCellDelegate

- (void)setApplicationType:(NSString *)type path_row:(NSInteger)row
{
    self.status = type;
    MessageBaseModel * model = self.dataArray[row];
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
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            ApplyDealWiththeApplyRequest *request = [[ApplyDealWiththeApplyRequest alloc] initWithDelegate:self];
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
            ApplyForwardingRequest *request = [[ApplyForwardingRequest alloc] initWithDelegate:self];
            [request GetShowID:self.ShowID WithApprove:self.strNextApprovers WithApproveName:self.strNextApproverNames WithReason:self.strReason];
            [self postLoading];
        }
    }
    else
    {
        ApplyDealWiththeApplyRequest *request = [[ApplyDealWiththeApplyRequest alloc] initWithDelegate:self];
        [request GetShowID:self.ShowID WithStatus:self.status WithReason:self.strReason];
        [self postLoading];
    }
    
}
- (void)ApplyCommentViewDelegateCallBack_PresentAnotherVC
{
    SelectContactBookViewController *VC = [[SelectContactBookViewController alloc] init];
    VC.singleSelectable = YES;
    
    [VC selectedPeople:^(NSArray *array) {
        ContactPersonDetailInformationModel *model = [array firstObject];
        if (!model) {
            return;
        }
        
        self.strNextApprovers = model.show_id;
        self.strNextApproverNames = model.u_true_name;
        [self.appCommentView setCommentViewStatus:kNextApprover];
        [self.appCommentView setHeadNameWithModel:model];
    }];
    
    [self presentViewController:VC animated:YES completion:nil];
    
}

#pragma mark - Request Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
	[self resetRequestState];

	if ([request isKindOfClass:[NewApplyDetailV2Request class]]) {
		
		ApplyDetailInformationModel *model = (ApplyDetailInformationModel *)[(id)response infomodel];
		NewApplyDetailV2ViewController *detailVc = [[NewApplyDetailV2ViewController alloc] initWithShowID:model.SHOW_ID];
		[self.navigationController pushViewController:detailVc animated:YES];
		
	} else if ([request isKindOfClass:[NewMissionGetMissionDetailRequest class]]) {
        NewMissionDetailModel *detailModel = [(NewMissionGetMissionDetailResponse *)response detailModel];
		
		NewDetailMissionViewController *MDVC = [[NewDetailMissionViewController alloc] initWithOnlyShowID:detailModel.showId];		
		MDVC.isFirstVC = YES;
		[self.navigationController pushViewController:MDVC animated:YES];
		
	} else if ([response isKindOfClass:[GetMeetingDetailResponse class]]) {
        //        [self postSuccess];
        GetMeetingDetailResponse *result = (GetMeetingDetailResponse *)response;
        // TODO重复提示 暂时为NO
        MeetingConfirmViewController *DetailVC = [[MeetingConfirmViewController alloc] initWithModel:result.meetingModel WithRepeatType:calendar_repeatNo];
        [self.navigationController pushViewController:DetailVC animated:YES];
    }
    
    else if ([request isKindOfClass:[CalendarGetRequest class]]) {
        CalendarLaunchrModel *model = [(id)response modelCalendar];
        CalendarNewEventMakeSureViewController *CNEMSVC = [[CalendarNewEventMakeSureViewController alloc] initWithModelShow:model];
        [self.navigationController pushViewController:CNEMSVC animated:YES];
    }
    
    [self hideLoading];
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
	[self resetRequestState];
    [self hideLoading];
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
        [_tableView registerClass:[NewChatShowDateTableViewCell class] forCellReuseIdentifier:Newsystem_cell];
        [_tableView registerClass:[NewChatApproveEventTableViewCell class] forCellReuseIdentifier:approval_cell];
        [_tableView registerClass:[ChatShowDateTableViewCell class] forCellReuseIdentifier:system_cell];
        // 添加动画图片的下拉刷新
        // 上拉刷新
        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefreshData)];
        ((MJRefreshStateHeader*)self.tableView.header).lastUpdatedTimeLabel.hidden = YES;
        ((MJRefreshStateHeader*)self.tableView.header).stateLabel.hidden = YES;
        
        _tableView.footer = [self getRefreshingFooterCoutomText];
    }
    
    return _tableView;
}
- (MJRefreshAutoNormalFooter *)getRefreshingFooterCoutomText
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefreshData)];

    return footer;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
