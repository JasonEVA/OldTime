//
//  ImApplicationConfigure.m
//  launcher
//
//  Created by williamzhang on 16/3/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ImApplicationConfigure.h"
#import "NSDate+String.h"
#import "JSONKitUtil.h"
#import "MyDefine.h"

NSString *const im_task_uid     = @"PWP16jQLLjFEZXLe@APP";
NSString *const im_approval_uid = @"ADWpPoQw85ULjnQk@APP";
NSString *const im_schedule_uid = @"l6b3YdE9LzTnmrl7@APP";

@implementation IMApplicationUtil

// 获得消息应用类型 比如审批是审批人还是抄送人 消息应用类型 EVENT   事件 EVENT_COMMENT  事件评论 MEETING   会议 MEETING_COMMENT  会议评论 APPROVE    审批 CC     抄送 SEND   发出 APPROVAL_COMMENT 审批的评论
+ (MsgAppType)getMsgAppTypeWith:(NSString *)msgAppString
{
    MsgAppType type;
    if ([msgAppString isEqualToString:@"APPROVE"])
    {
        type = AppType_FromReceiver;
    }
    else if ([msgAppString isEqualToString:@"CC"])
    {
        type = AppType_FromCC;
    }
    else if ([msgAppString isEqualToString:@"EVENT"])
    {
        type = AppType_Event;
    }
    else if ([msgAppString isEqualToString:@"MEETING"])
    {
        type = AppType_Meeting;
    }
    else if ([msgAppString isEqualToString:@"S_REMIND"]) {
        type = AppType_S_Remind;
    }
    else if ([msgAppString isEqualToString:@"M_REMIND"]) {
        type = AppType_M_Remind;
    }
    else if ([msgAppString isEqualToString:@"T_REMIND"]) {
        type = AppType_T_Remind;
    }
    else if ([msgAppString isEqualToString:@"EVENT_COMMENT"]) {
        type = AppType_EVENT_COMMENT;
    }
    else if ([msgAppString isEqualToString:@"MEETING_COMMENT"]) {
        type = AppType_MEETING_COMMENT;
    }
    else if ([msgAppString isEqualToString:@"APPROVAL_COMMENT"]) {
        type = AppType_APPROVAL_COMMENT;
    }
    
    return type;
}


+ (MsgApprovalType)getMsgApprovalTypeWith:(NSString *)approvalShowID
{
    MsgApprovalType type;
    if ([approvalShowID isEqualToString:@"vEyVJ7K29qcovp3p"]) {
        type = MsgApprovalType_askLeave;
    }else if ([approvalShowID isEqualToString:@"BB1xoKW53kCPW7OP"]) {
        type = MsgApprovalType_cost;
    }else {
        type = MsgApprovalType_Other;
    }
    return type;
}

+ (MsgTransType)getMsgTransTypeWith:(NSString *)msgTransType
{
    NSNumber *number = [[self msgTransTypeDictionary] objectForKey:msgTransType];
    if (!number) {
        return 0;
    }
    return [number integerValue];
}

+ (NSDictionary *)msgTransTypeDictionary {
    return @{
             @"comment":@(comment),
             @"meetingAttend":@(meetingAttend),
             @"meetingAttendDefinite":@(meetingAttendDefinite),
             @"meetingRefuseAttend":@(meetingRefuseAttend),
             @"meetingRefuseAttendDefinite":@(meetingRefuseAttendDefinite),
             @"meetingCancel":@(meetingCancel),
             @"meetingEdit":@(meetingEdit),
             @"meetingCancelOne":@(meetingCancelOne),
             @"approvePut":@(approvePut),
             @"approvePost":@(approvePost),
             @"approvePass":@(approvePass),
             @"approveBack":@(approveBack),
             @"approveBackV2":@(approveBackV2),
             @"approveBackDefinite":@(approveBackDefinite),
             @"approveRefuse":@(approveRefuse),
             @"approveRefuseDefinite":@(approveRefuseDefinite),
             @"approveTranspond":@(approveTranspond),
             @"approveTranspondDefinite":@(approveTranspondDefinite),
             @"taskDelete":@(taskDelete),
             @"taskEditStatus":@(taskEditStatus),
             @"taskEditStatusDefinite":@(taskEditStatusDefinite),
             @"remindSchedule":@(remindSchedule),
             @"remindTask":@(remindTask),
             @"remindTaskV2":@(remindTaskV2),
             @"createTaskV2":@(createTaskV2),
             @"taskV2Update":@(taskV2Update),
             @"taskV2ChangeStatus":@(taskV2ChangeStatus),
             @"taskV2ChangeDoneStatus":@(taskV2ChangeDoneStatus),
             @"taskV2ChangeDoingStatus":@(taskV2ChangeDoingStatus)
             };
}

+ (NSString *)getMsgTextWithModel:(MessageAppModel *)model {
    NSString *name = model.msgFrom;
    NSString *title = model.msgContent;
    NSString *msgTransType = model.msgTransType;
    NSDate *date = nil;
    
    
    MsgTransType type = [self getMsgTransTypeWith:msgTransType];
    if (type == remindTask || type == remindTaskV2) {
        title = model.msgTitle;
        date = [NSDate dateWithTimeIntervalSince1970:model.msgRemark / 1000];
    }
    
    if (type == remindSchedule) {
        title = model.msgTitle;
        date = [NSDate dateWithTimeIntervalSince1970:model.msgRemark / 1000];
    }
    
    NSString *dateString = nil;
    if (date) {
        dateString = [date mtc_dateFormate];
    }
    switch (type) {
        case comment:
            //            return [[model.msgInfo mtc_objectFromJSONString] objectForKey:@"comment"];
            return [NSString stringWithFormat:LOCAL(IM_COMMENT),name,title];  //在外面处理了
        case meetingAttend:
        case meetingAttendDefinite:
            return LOCAL(IM_CHATCARD_MEETING_ATTEND);
        case meetingRefuseAttend:
        case meetingRefuseAttendDefinite:
            return LOCAL(IM_CHATCARD_MEETING_NOTATTEND);
        case meetingCancel:
        case meetingCancelOne:
//            return LOCAL(IM_CHATCARD_MEETING_CANCEL);
        {
            if ([[model.msgInfo mtc_objectFromJSONString] objectForKey:@"reason"] == nil || [[[model.msgInfo mtc_objectFromJSONString] objectForKey:@"reason"] isEqualToString:@""])
            {
                NSString *str = [NSString stringWithFormat:LOCAL(IM_CHATCARD_MEETING_CANCEL),@""];
                NSString *strneed = [str substringToIndex:[str length] - 1];
                return strneed;
            }
            else
            {
                return [NSString stringWithFormat:LOCAL(IM_CHATCARD_MEETING_CANCEL),[[model.msgInfo mtc_objectFromJSONString] objectForKey:@"reason"]?:@""];
            }
            break;
        }
        case meetingEdit:
            return LOCAL(IM_CHATCARD_MEETING_EDIT);
        case remindSchedule:
        case remindTask:
        case remindTaskV2:
            return [NSString stringWithFormat:LOCAL(IM_CHARCARD_REMIND),dateString];
        case approvePass:
            return LOCAL(IM_CHATCARD_APPROVE_PASS);
        case approveBack:
        case approveBackV2:
		case approveBackDefinite: {
			NSString *opinion = [self getOpitonWithFormJSONString:model.msgInfo];
			return [NSString stringWithFormat:LOCAL(IM_CHATCARD_APPROVE_BACK), opinion];
		}
        case approveRefuse:
		case approveRefuseDefinite:{
			NSString  *opinion = [self getOpitonWithFormJSONString:model.msgInfo];
			return [NSString stringWithFormat:LOCAL(IM_CHATCARD_APPROVE_REFUSE), opinion];
		}
        case approveTranspond:
		case approveTranspondDefinite: {
			NSString  *opinion = [self getOpitonWithFormJSONString:model.msgInfo];
			NSString  *transportUser = [self getTransportUserWithFormJSONString:model.msgInfo];
            return [NSString stringWithFormat:LOCAL(IM_CHATCARD_APPROVE_TRANSPOND), transportUser,opinion];
		}
        case taskDelete:
            return LOCAL(IM_CHATCARD_TASK_DELETE);
        case taskEditStatusDefinite:
        case taskEditStatus:
        case taskV2Update:
        case taskV2ChangeStatus:
            return LOCAL(IM_CHATCARD_TASK_EDITCONTENT);
        case taskV2ChangeDoingStatus:
            return LOCAL(IM_CHATCARD_TASK_EDITTOUNDONE);
        case taskV2ChangeDoneStatus:
            return LOCAL(IM_CHATCARD_TASK_EDITTODONE);
        default:
            return @"";
    }
    
    
#warning 新版卡片之后替换 wz____    
//    switch (type) {
//        case comment:
////            return [[model.msgInfo mtc_objectFromJSONString] objectForKey:@"comment"];
//#warning 新版卡片之后替换 wz____
//            return [NSString stringWithFormat:LOCAL(IM_COMMENT),name,title];  //在外面处理了
//        case meetingAttend:
//            return [NSString stringWithFormat:LOCAL(IM_MEETINGATTEND),name,title];
//        case meetingAttendDefinite:
//            return [NSString stringWithFormat:LOCAL(IM_MEETINGATTENDDEFINITE),title,name];
//        case meetingRefuseAttend:
//            return [NSString stringWithFormat:LOCAL(IM_MEETINGREFUSEATTEND),name];
//        case remindSchedule:
//            return [NSString stringWithFormat:LOCAL(IM_REMINDSCHEDULE), title ,dateString];
//        case remindTask:
//            return [NSString stringWithFormat:LOCAL(IM_REMINDTASK), title ,dateString];
//        case approvePass:
//            return [NSString stringWithFormat:LOCAL(IM_APPROVEPASS),name, title];
//        case approveBack:
//            return [NSString stringWithFormat:LOCAL(IM_APPROVEBACK),name,title];
//        case approveRefuse:
//            return [NSString stringWithFormat:LOCAL(IM_APPROVEREFUSE),name,title];
//        case approveTranspond:
//            return [NSString stringWithFormat:LOCAL(IM_APPROVETRANSPOND),name,title];
//        case taskDelete:
//            return [NSString stringWithFormat:LOCAL(IM_DELETE),name,title];
//        case taskEditStatus:
//            return [NSString stringWithFormat:LOCAL(IM_TASKEDITSTATUS),name,title];
//        case remindTaskV2:
//            return [NSString stringWithFormat:LOCAL(IM_REMINDTASK), title ,dateString];
//        default:
//            return @"";
//    }
}

+ (NSString *)getOpitonWithFormJSONString:(NSString *)form {
	NSString  *reason = [[form mtc_objectFromJSONString] objectForKey:@"reason"];
	if (!reason) {
		reason = LOCAL(IM_CHATCARD_APPROVE_NOINFO);
	}
	return reason;
	
}

+ (NSString *)getTransportUserWithFormJSONString:(NSString *)form {
	NSString *tranportUser = [[form mtc_objectFromJSONString] objectForKey:@"transUserName"];
	if (!tranportUser) {
		tranportUser = @"";
	}
	return tranportUser;
}

@end