//
//  ChatApplicationCalendarViewController.m
//  launcher
//
//  Created by williamzhang on 16/5/4.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatApplicationCalendarViewController.h"
#import "NewCalendarMakeSureViewController.h"
#import "NewMeetingConfirmViewController.h"
#import "NewEventScheduleTableViewCell.h"
#import "MeetingConfirmMeetingRequest.h"
#import "NewCalendarViewController.h"
#import "NewGetMeetingDetailRequest.h"
#import "CalendarLaunchrModel.h"
#import "CalendarGetRequest.h"
#import "AppScheduleModel.h"
#import "Category.h"
#import "MyDefine.h"

@interface ChatApplicationCalendarViewController () <NewEventScheduleTableViewCellDelegate, BaseRequestDelegate>

@end

@implementation ChatApplicationCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableViewRegisterClass:[NewEventScheduleTableViewCell class] forCellReuseIdentifier:NSStringFromClass(NewEventScheduleTableViewCell.class)];
}

- (NSString *)applicationUid { return im_schedule_uid; }

- (NSString *)buttonTitle { return LOCAL(Application_Calendar); }
- (UIImage *)buttonImage { return [UIImage imageNamed:@"app_title_calendar"]; }
- (UIImage *)buttonHighlightedImage { return [UIImage imageNamed:@"app_title_calendarselected"]; }

- (void)clickedButton {
    NewCalendarViewController *VC = [[NewCalendarViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (CGFloat)heightForMessageModel:(MessageBaseModel *)model {
    if (model._type == msg_personal_alert) {
        return [super heightForMessageModel:model];
    }
    
    return [NewEventScheduleTableViewCell heightForModel:model];
}
- (UITableViewCell *)cellForMessageModel:(MessageBaseModel *)model  withRowAtIndexPath:(NSIndexPath *)indexPath{
    NewEventScheduleTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass(NewEventScheduleTableViewCell.class)];
    
    [cell setCellData:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor grayBackground];
    cell.delegate = self;
    
    return cell;
}

- (void)didSelectCellForMessageModel:(MessageBaseModel *)model {
    MessageAppModel *appModel = model.appModel;
    
    MsgAppType type = [IMApplicationUtil getMsgAppTypeWith:appModel.msgAppType];
    CalendarLaunchrModel *calenderModel = [CalendarLaunchrModel new];
    AppScheduleModel *scheduleModel = [AppScheduleModel mj_objectWithKeyValues:appModel.applicationDetailDictionary];
    calenderModel.relateId = scheduleModel.id;
    [calenderModel.time addObject:[NSDate dateWithTimeIntervalSince1970:scheduleModel.start / 1000]];
	

	
	[self postLoading];
	
    switch (type) {
        case AppType_S_Remind:
        case AppType_EVENT_COMMENT:
            calenderModel.showId = appModel.msgRMShowID;
            // fallthrough
        case AppType_Event: {
            CalendarGetRequest *request = [[CalendarGetRequest alloc] initWithDelegate:self];
            [request getCalendarWithModel:calenderModel];
        }
            break;
        case AppType_M_Remind:
        case AppType_FromCC:
        case AppType_FromReceiver:
        case AppType_MEETING_COMMENT:
        case AppType_Meeting:
        case AppType_APPROVAL_COMMENT:
        {    calenderModel.relateId = appModel.msgRMShowID;
            // fallthrough
			NewGetMeetingDetailRequest *request = [[NewGetMeetingDetailRequest alloc] initWithDelegate:self];
			NSDate *startTime = calenderModel.time[0];
			[request getMeetingDetailWithShowID:calenderModel.relateId startTime:[startTime timeIntervalSince1970] * 1000 needCheckAttend:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - ChatEventScheduleTableViewCell delegate
- (void)ChatEventScheduleTableViewCellDelegateCallBack_btnAttendClicked:(BOOL)isAttend ShowId:(NSString *)showId {
    MeetingConfirmMeetingRequest *request = [[MeetingConfirmMeetingRequest alloc] initWithDelegate:self];
    [request ConfirmWhetherAttendWith:showId WhetherAgree:isAttend Reason:nil];
    [self postLoading];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    
    [self hideLoading];
    
    if ([request isKindOfClass:[NewGetMeetingDetailRequest class]]) {
        
        NewMeetingModel *model = (NewMeetingModel *)[(id)response model];
        
        NewMeetingConfirmViewController *DetailVC = [[NewMeetingConfirmViewController alloc] initWithModel:model WithRepeatType:calendar_repeatNo];
        [self.navigationController pushViewController:DetailVC animated:YES];
    }
    
    else if ([request isKindOfClass:[CalendarGetRequest class]]) {
        CalendarLaunchrModel *model = [(id)response modelCalendar];
        
        NewCalendarMakeSureViewController *CNEMSVC = [[NewCalendarMakeSureViewController alloc] initWithModelShow:model];
        [self.navigationController pushViewController:CNEMSVC animated:YES];
        
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

@end
