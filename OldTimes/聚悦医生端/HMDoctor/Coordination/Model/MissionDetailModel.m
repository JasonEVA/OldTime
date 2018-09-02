//
//  MissionDetailModel.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/28.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionDetailModel.h"

static NSString  * const show_id             = @"sHOW_ID";
static NSString  * const ID                  = @"iD";
static NSString  * const t_title             = @"t_TITLE";
static NSString  * const t_content           = @"t_CONTENT";
static NSString  * const t_start_time        = @"t_START_TIME";
static NSString  * const is_start_allday     = @"iS_START_ALL_DAY";
static NSString  * const t_end_time          = @"t_END_TIME";
static NSString  * const is_end_allday       = @"iS_END_ALL_DAY";
static NSString  * const t_patient           = @"t_PATIENT";
static NSString  * const t_patient_name      = @"t_PATIENT_Name";
static NSString  * const t_user              = @"t_USER";
static NSString  * const t_user_name         = @"t_USER_NAME";
static NSString  * const t_cc                = @"t_CC";
static NSString  * const t_cc_Name           = @"t_CC_NAME";
static NSString  * const t_priority          = @"t_PROIORITY";
static NSString  * const t_remind_type       = @"t_REMIND_TYPE";
static NSString  * const t_remind_time       = @"t_REMIND_TIME";
static NSString  * const t_isremind          = @"t_ISREMIND";
static NSString  * const t_parent_showid     = @"t_PARENT_SHOW_ID";
static NSString  * const t_level             = @"t_LEVEL";
static NSString  * const t_is_comment        = @"t_IS_COMMENT";
static NSString  * const t_is_annex          = @"t_IS_ANNEX";
static NSString  * const t_Status            = @"t_STATUS";
static NSString  * const t_type              = @"t_TYPE";
static NSString  * const last_update_time    = @"lAST_UPDATE_TIME";
static NSString  * const c_show_id           = @"c_SHOW_ID";
static NSString  * const create_user         = @"cREATE_USER";
static NSString  * const create_user_name    = @"cREATE_USER_NAME";
static NSString  * const create_time         = @"cREATE_TIME";



@implementation MissionDetailModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.participatorName = @""; // 任务参与者
        self.hasAttachments = @"";//是否包含附件 0没有 1有
        self.attachmentsTitles = @""; // //附件文件名,包含后缀 多个以|分割
        self.attachmentsPath = @""; // //附件地址 绝对地址 多个以|分割
        self.teamID = @""; // 团队ID
        self.isStartAllDay = @"";
        self.patientsName = @""; // 患者姓名 多个以|分割
        self.patientsID = @"";//患者id 多个以|分割
        self.isEndAllDay = @"";
        self.createUserName = @""; //创建者
        self.taskTitle = @"";//任务标题
        self.remindType = 0;// 任务提醒，
        self.participatorID = @"";//任务参与者id
        self.taskPriority = 0;//任务优先级 0=无，1=低，2=中，3=高
        self.endTime = @"";//任务结束时间
        self.createUserID = @"";//创建者id
        self.taskType = 0;//任务类型 0=随访，1=监测
        self.startTime = @"";//任务开始时间
        self.ID = 0;
        self.showID = @"";//任务id
        self.isRemind = @"";//是否提醒
        self.taskLevel = 1;//任务层级   1=根任务,2=子任务
        self.isComment = @"";//是否有评论,0=没有,1=有
        self.taskStatus = 0;//任务状态
        self.lastUpdateTime = @"";//最后更新时间
        self.createTime = @"";//创建时间
        self.remark = @"";       //备注
    }
    return self;
}


- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSString class]) {
        if (oldValue == nil || oldValue == [NSNull null] || oldValue == NULL) {
            return @"";
        }
        
        if ([oldValue isKindOfClass:[NSString class]] && [oldValue isEqualToString:@"(null)"]) {
            return @"";
        }
    }
    
    return oldValue;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"participatorName" :  @"tUserName",
             @"hasAttachments" : @"tIsAnnex",
             @"attachmentsTitles" : @"tAnnexTitle",
             @"attachmentsPath" : @"tAnnexPath",
             @"teamID" : @"pShowId",
             @"isStartAllDay" : @"isStartAllDay",
             @"patientsName" : @"tPatientName",
             @"patientsID" : @"tPatient",
             @"isEndAllDay" : @"isEndAllDay",
             @"createUserName" : @"createUserName",
             @"taskTitle" : @"tTitle",
             @"remindType" : @"tRemindType",
             @"participatorID" : @"tUser",
             @"taskPriority" : @"tPriority",
             @"endTime" : @"tEndTime",
             @"createUserID" : @"createUser",
             @"taskType" : @"tType",
             @"startTime" : @"tStartTime",
             @"ID" : @"iD",
             @"showID" : @"showId",
             @"isRemind" : @"tIsremind",
             @"taskLevel" : @"tLevel",
             @"isComment" : @"tIsComment",
             @"taskStatus" : @"tStatus",
             @"lastUpdateTime" : @"lastUpdateTime",
             @"createTime" : @"createTime",
             @"remark"  : @"tContent",
             @"isMemberAccess" : @"isMemberAccess",
             @"reason" : @"reason",
             @"pShowName" : @"pShowName"
             };
}


- (BOOL)isSendFromMe {
    UserInfo *info = [UserInfoHelper defaultHelper].currentUserInfo;
    if ([[NSString stringWithFormat:@"%ld",info.userId] isEqualToString:self.createUserID]) {
        return YES;
    }
    return NO;
}



@end
