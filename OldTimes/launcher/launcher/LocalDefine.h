//
//  LocalDefine.h
//  launcher
//
//  Created by William Zhang on 15/8/5.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#ifndef launcher_LocalDefine_h
#define launcher_LocalDefine_h

typedef NS_ENUM(NSInteger, LanguageEnum) {
    language_system,    // 除此是自动，剩下均为手动
    language_japanese,
    language_english,
    language_chinese
};      // 系统语言选择枚举

#define LOCAL_SYSTEM(a)   (NSLocalizedString((a), nil))

// 通用
#define NONE                 @"None"
#define TITLE                @"Title"
#define CONTENT              @"Content"
#define START                @"Start"
#define STOP                 @"Stop"
#define CONFIRM              @"Confirm"
#define DELETE               @"Delete"
#define CLOSE                @"Close"

#define DELETESUCCESS		@"Delete_Success"
#define FAILDELETE          @"Delete_Fail"
#define CALCEL_SUCCESS		@"Cancel_Success"
#define SEND_SECCESS		@"Send_Success"

#define UPLOADERROR @"Upload_Error"
#define INPUT_ERROR @"Input_Error"

#define PERMISSION_ERROR @"Permission_Error"

/**************** HomeClass ****************************/
// Tabbar
#define HOMETABBAR_MESSAGE 			@"HomeTabbar_Message"
#define HOMETABBAR_APPLICATION 		@"HomeTabbar_Application"
#define HOMETABBAR_CONTACT 			@"HomeTabbar_Contact"
#define HOMETABBAR_USERINFO 		@"HomeTabbar_UserInfo"

/**************** LoginClass ****************************/
// 登陆界面
#define  LOGINCLASS_TITLE   	 	@"LoginClass_Title"
#define  LOGINCLASS_NAME   	 		@"LoginClass_Name"
#define  LOGINCLASS_PASSWORD        @"LoginClass_PassWord"
#define  LOGINCLASS_REMERBER   	 	@"LoginClass_Remember"
#define  LOGINCLASS_ERROR1   	 	@"LoginClass_Error1"
#define  LOGINCLASS_ERROR2   	 	@"LoginClass_Error2"
#define  LOGINCLASS_FORGETPSD       @"LoginClass_Forget"
#define  LOGINCLASS_LOGINING        @"LoginClass_Logining"
#define  LOGINCLASS_APPLYTRIAL      @"LoginClass_ApplyTrial"
#define  LOGINCLASS_DESCRIPTION     @"LoginClass_Description"
#define  LOGINCLASS_ENTERVALIDCODE  @"LoginClass_EnterValidCode"

// 手势界面
#define GESTURELOGIN_FORGET 			@"GestureLogin_Forget"
#define GESTURELOGIN_OTHERWAY 			@"GestureLogin_OtherWay"
#define GESTURELOGIN_WRONG				@"GestureLogin_Wrong"
#define GESTURELOGIN_WRONG2				@"GestureLogin_Wrong2"
#define GESTURELOGIN_TITLE 				@"GestureLogin_Title"
#define GESTURELOGIN_PROMPT 			@"GestureLogin_Prompt"
#define GESTURELOGIN_PROMPT1 			@"GestureLogin_Prompt1"
#define GESTURELOGIN_PROMPT2 			@"GestureLogin_Prompt2"
#define GESTURELOGIN_PROMPT3 			@"GestureLogin_Prompt3"
#define GESTURELOGIN_PROMPT4 			@"GrestureLogin_Prompt4"
#define GESTURELOGIN_PROMPT5            @"GestureLogin_Prompt5"
#define FINGERPRINT_IDENTIFICATION      @"Fingerprint_Identification"

#define ERROROTHER		@"ErrorOther"

#define REGISTER_ACCOUNT                     @"register_account"
#define REGISTER_EMAIL_REGISTER              @"register_email_register"
#define REGISTER_NEXTSTEP                    @"register_nextStep"
#define REGISTER_EMAIL_ERROR                 @"register_email_error"
#define REGISTER_EMAIL                       @"register_email"
#define REGISTER_PASSWOR                     @"register_password"
#define REGISTER_PASSWORD_ERROR              @"register_password_error"
#define REGISTER_TEAMNAME_ERROR              @"register_teamName_error"
#define REGISTER_TEAMDOMAIN_ERROR            @"register_teamDomain_error"
#define REGISTER_NAME_ERROR                  @"register_name_error"
#define REGISTER_REGISTERED                  @"register_registered"
#define REGISTER_LOGIN_NOW                   @"register_login_now"
#define REGISTER_EMAIL_CHANGE                @"register_email_change"
#define REGISTER_EMAIL_FIND                  @"register_email_find"
#define REGISTER_LOGIN_BACK                  @"register_login_back"
#define REGISTER_EMAIL_FIND_SEND             @"register_email_find_send"
#define REGISTER_EMAIL_FIND_SEND_DESCRIPTION @"register_email_find_send_description"
#define REGISTER_EMAIL_FIND_RESEND           @"register_email_find_resend"
#define REGISTER_TEAM_CREATE                 @"register_team_create"
#define REGISTER_PASSWORD_SET                @"register_password_set"
#define REGISTER_INFO_CONFIRM                @"register_info_confirm"
#define REGISTER_TEAM_ADDRESS                @"register_team_address"
#define REGISTER_TEAM_NAME                   @"register_team_name"
#define REGISTER_PASSWORD                    @"register_password"

#define REGISTER_TERM1 @"register_term1"
#define REGISTER_TERM1_SUB1 @"register_term1_sub1"
#define REGISTER_TERM1_SUB2 @"register_term1_sub2"
#define REGISTER_TERM2 @"register_term2"

#define SENDER_SUCCESS @"sender_Success"

/***************我的设置*****************/
#define ME_NAME                 @"Me_name"
#define ME_MOBILE               @"Me_mobile"
#define ME_MAIL                 @"Me_mail"
#define ME_OFFICE               @"Me_office"
#define ME_TEAM                 @"Me_team"
#define ME_QRCODE               @"Me_qrcode"
#define ME_SHARE                @"Me_share"
#define ME_REVISE_CODE          @"Me_revise_code"
#define ME_REVISE_TAP           @"Me_revise_tap"
#define ME_SET                  @"Me_set"
#define ME_KINDLY_WARN          @"Me_kindly_warn"
#define ME_CONFIRM_REVISE       @"Me_confirm_revise"
#define ME_ORGINAL_PASSWORD     @"Me_orginal_password"
#define ME_NEW_PASSWORD         @"Me_new_password"
#define ME_CONFIRM_PASSWORD     @"Me_confirm_password"
#define ME_CHECK_CODE           @"Me_check_code"
#define ME_WARN                 @"Me_warn"
#define ME_LOGIN_PW_NEED_EXIST  @"Me_login_pw_need_exist"
#define ME_NEWMAIL_NEED         @"Me_newmail_need"
#define ME_CHECKCODE_NEED       @"Me_checkcode_need"
#define ME_LOGIN_PW             @"Me_login_pw"
#define ME_NEW_MAIL             @"Me_new_mail"
#define ME_OPERATION_CANNOT_BACK @"Me_operation_cannot_back"
#define ME_LANGUAGE             @"Me_language"
#define ME_MESSAGE_NOTIFICATION @"Me_message_notification"
#define ME_DEVISE_MANAGE        @"Me_devise_manage"
#define ME_CLEAN_ALL            @"Me_clean_all"
#define ME_SUGGEST_BACK         @"Me_suggest_back"
#define ME_HELP                 @"Me_help"
#define ME_ABOUT_P              @"Me_about_p"
#define ME_DELETE_ACCOUNT       @"Me_delete_account"
#define ME_CONFIRM_CLEAN_ALL    @"Me_confirm_clean_all"
#define ME_WARN_OPERATION       @"Me_warn_operation"
#define ME_CONFIRM_DELETE       @"Me_confirm_delete"
#define ME_LOGIN_OUT            @"Me_login_out"
#define ME_BACK_RECORDS         @"Me_back_records"
#define ME_LOWERWORD            @"Me_lowerword"
#define ME_UPPERWORD            @"Me_upperword"
#define ME_NUMBER               @"Me_number"
#define ME_SPECIALWORD          @"Me_specialword"
#define ME_MORETHAN8            @"Me_morethan8"
#define ME_HAD_SENT             @"Me_had_sent"
#define ME_GET_CHECK_CODE       @"Me_get_check_code"
#define ME_INPUT_BACKCONTENT    @"Me_input_backcontent"
#define ME_INPUT_BACKSUGGEST    @"Me_input_backsuggest"
#define ME_PW_LESSTHAN16        @"Me_pw_lessthan16"
#define ME_NEWPW_NOTTHESAME     @"Me_newpw_notthesame"
#define ME_NEWPW_NOTASREQUIRED  @"Me_newpw_notasrequired"
#define ME_CHANGE_MAIL          @"Me_change_mail"
#define ME_INPUT_RIGHT_MAIL     @"Me_input_right_mail"
#define ME_REVISE_MOBILE        @"Me_revise_mobile"
#define ME_MEWMOBILENO_NEED     @"Me_newmobile_need"
#define ME_NEW_MOBILENO         @"Me_newmobile_no"
#define ME_PROMPT_TYPE          @"Me_prompt_type"

/***************应用*****************/
#define Application          @"Application"
#define Application_Calendar @"Application_Calendar"
#define Application_Apply    @"Application_Apply"
#define Application_Mission  @"Applcation_Mission"
#define Application_Attendance @"Application_Attendance"

#define Application_Unfinished @"Application_Unfinished"

#define Application_Calendar_notify @"Application_Calendar_notify"
#define Application_Apply_notify    @"Application_Apply_notify"
#define Application_Mission_notify  @"Application_Mission_notify"

#define QUICK_NEW_CHAT      @"Quick_new_chat"
#define QUICK_NEW_TASK      @"Quick_new_task"
#define QUICK_NEW_SCHEDULE  @"Quick_new_schedule"
#define QUICK_QRCODE        @"Quick_QRCode"
#define QUICK_APPLY         @"Quick_Apply"
#define QUICK_MEETING       @"Quick_Meeting"

/*****************请假******************/
#define APPLY_ALLDAY                  @"Apply_allday"
#define APPLY_ADD_DETAIL              @"Apply_add_detail"
#define APPLY_DEALING                 @"Apply_dealing"
#define APPLY_SEARCHING               @"Apply_searching"
#define APPLY_ADD_ACCEPT_TITLE        @"Apply_add_accept_Title"
#define APPLY_ADD_ACCEPT_CC_TITLE     @"Apply_add_cc_Title"
#define APPLY_ADD_APPLYTYPE_TITLE     @"Apply_add_Type_Title"
#define APPLY_ADD_PRIORITY_TITLE      @"Apply_add_Priority_Title"
#define APPLY_ADD_DEADLINE_TITLE      @"Apply_add_Deadline_Title"
#define APPLY_ADD_PERIOD_TITLE        @"Apply_add_Period_Title"
#define APPLY_ADD_EXPENSED_TITLE      @"Apply_add_Expensed_Title"
#define APPLY_ADD_ATTACHMENT_TITLE    @"Apply_add_Attachment_Title"
#define APPLY_APPLY_SUCCESS           @"Apply_apply_success"
#define APPLY_SENDER_SUCCESS          @"Apply_sender_Success"
#define APPLY_CAMERO                  @"Apply_camero"
#define APPLY_PICTURE                 @"Apply_picture"
#define APPLY_GETNEW_COMMENTS         @"Apply_getnew_comments"
#define APPLY_NOMORE_COMMENTS         @"Apply_nomore_comments"
#define PLEASE_INPUT                  @"Pleas_input"
#define APPLY_SEND                    @"Apply_send"
#define APPLY_INPUT_APPLY_SUGGEST     @"Apply_input_apply_suggest"
#define APPLY_INPUT_NEXT_APPRALLER    @"Apply_input_next_appraller"
#define APPLY_ACCEPT                  @"Apply_accept"
#define APPLY_DELETE_COMMENT          @"Apply_delete_comment"
#define APPLY_DELETE_SUCCESS          @"Apply_delete_success"
#define APPLY_MAKESURE_DELETE         @"Apply_makesure_delete"
#define APPLY_CANNOT_DELETE_APPLY     @"Apply_cannot_delete_apply"
#define APPLY_MAKESURE                @"Apply_makesure"
#define APPLY_MAKESURE_FORWARD        @"Apply_makesure_forward"
#define APPLY_INPUT_TITLE             @"Apply_input_title"
#define APPLY_INPUT_MONEY             @"Apply_input_money"
#define APPLY_INPUT_APPROLLER         @"Apply_input_approller"
#define APPLY_BEGIN_TIME              @"Apply_begin_time"
#define APPLY_END_TIME                @"Apply_end_time"
#define APPLY_INPUT_VOCATION_TIME     @"Apply_input_vocation_time"
#define APPLY_DELETE_PICTURE          @"Apply_delete_picture"

//承认者
#define APPLY_ACCEPT_VOCATION_TITLE   @"Apply_Accept_Vocation_Title"
#define APPLY_ADD_NEW_VOCATION        @"Apply_add_new_vocation"
#define APPLY_ADD_NEW_MONEY           @"Apply_add_new_money"
#define APPLY_ACCEPT_EXPENSED_TITLE   @"Apply_Accpet_Expensed_Title"
#define APPLY_ACCEPT_RECEIVER_TITLE   @"Apply_Accept_Receiver_Title"
#define APPLY_ACCEPT_SENDER_TITLE     @"Apply_Accept_Sender_Title"
#define APPLY_ADD                     @"APPLY_ADD"
#define APPLY_ACCEPT_ACCEPTBTN_TITLE  @"Apply_Accept_AcceptBtn_Title"
#define APPLY_ACCEPT_CCBTN_TITLE      @"Apply_Accept_CCBtn_Title"
#define APPLY_ACCEPT_UNACCEPT_TITLE   @"Apply_Accept_Unaccept_Title"
#define APPLY_ACCEPT_BACKWARD_TITLE   @"Apply_Accept_Backward_Title"
#define APPLY_ACCEPT_ACCEPT_TITLE     @"Apply_Accept_AcceptBtn_Title"
#define APPLY_ACCEPT_WAIT_EVENT       @"Apply_Accept_Waiting_Event_Title"
#define APPLY_ACCEPT_DONE_EVENT       @"Apply_Accept_Dealed_Event_Title"
#define APPLY_ACCEPT_BEFORE           @"Apply_accept_before"
#define APPLY_APPLY                   @"Apply_apply"
#define APPLY_sp_contain              @"Apply_sp_contain"
#define APPLY_SP_ASWORD               @"Apply_sp_asword"
#define APPLY_AS_APPROVELLER          @"Apply_as_approveller"

//申请者
#define APPLY_SENDER_UNACCEPT_TITLE   @"Apply_Sender_Unaccept_Title"
#define APPLY_SENDER_ACCEPT_TITLE     @"Apply_Sender_Accept_Title"
#define APPLY_SENDER_BACKWARD_TITLE   @"Apply_Sender_Backward_Title"
#define APPLY_SENDER_DEALING_TITLE    @"Apply_Sender_Dealing_Title"
#define APPLY_SENDER_WAITDEAL_TITLE   @"Apply_Sender_Wait_Deal_Title"

//详细
#define APPLY_DEADLINE_INFO			  @"Apply_list_deadline_info"
#define APPLY_CONFIRM_TITLE           @"Apply_Apply_Confirm_Title"
#define APPLY_DEADLINE_TITLE          @"Apply_Apply_Deadline_Title"
#define APPLY_VOCATION_TITLE          @"Apply_Apply_Vocation_Title"
#define APPLY_ATTACHMENT_TITLE        @"Apply_Apply_Attachment_Title"
#define APPLY_COMEOUT                 @"Apply_comeout"

#define APPLY_INPUTMONEY       @"apply_inputMoney"
#define APPLY_APPLYCOMMENT     @"apply_applyComment"
#define APPLY_NEXTPERSON       @"apply_nextperson"
#define APPLY_SELECTNEXTPERSON @"apply_selectNextperson"
#define APPLY_NORESULT         @"apply_noresult"

#define NEWAPPLY_ALL           @"Newapply_all"
#define NEWAPPLY_COMMENT       @"Newapply_comment"
#define NEWAPPLY_ATTACHMENT    @"Newapply_attachment"
#define NEWAPPLY_SYSTEM        @"Newapply_system"

#define APPLY_SEARCH_CONTAIN_TITLE @"APPLY_SEARCH_CONTAIN_TITLE"
#define APPLY_SEARCH_CONTAIN_NAME @"APPLY_SEARCH_CONTAIN_NAME"

/********************新任务****************************/
#define NEWMISSION_SHOW_FINISH                           @"NewMission_Show_Finish"//显示已处理
#define NEWMISSION_SHOW_UNFINISH                         @"NewMission_Show_UnFinish"//显示未处理
#define NEWMISSION_SELECT_START_TIME                     @"NewMission_Select_Start_Time"//选择开始时间
#define NEWMISSION_SELECT_END_TIME                       @"NewMissionS_elect_End_Time"//选择结束时间
#define NEWMISSION_DELETE_PROJECT                        @"NewMission_Delete_Project"//删除项目
#define NEWMISSION_ONEDAY                                @"NewMission_OneDay"//某一天
#define NEWMISSION_UNSET                                 @"NewMission_UnSet"//无结束时间
#define NEWMISSION_MENU                                  @"NewMission_Menu"//菜单
#define NEWMISSION_ADD_MISSION                           @"NewMission_Add_Mission"//新增任务
#define NEWMISSION_CANCEL_LOGIN                          @"NewMission_Cancel_Login"//取消登录
#define NEWMISSION_CANNOT_EMPTY                          @"NewMission_CanNot_Empty"//该输入框不能为空
#define NEWMISSION_MAIN_MISSION                          @"NewMission_Main_Mission"//主任务
#define NEWMISSION_ADD_ONE_MISSION                       @"NewMission_Add_One_Mission" //添加一个项目
#define NEWMISSION_ALL_MISSION                           @"NewMission_All_Mission"//所有任务
#define NEWMISSION_NO_START_TIME                         @"NewMission_No_Start_Time"//无开始时间
#define NEWMISSION_FINISH                                @"NewMission_Finish"        //已完成
#define NEWMISSION_ADD_MISSION_FINISH                    @"NewMission_Add_Mission_Finish"        //新建任务成功
#define NEWMISSION_GET_MISSION_DETAIL_SUCCESS            @"NewMission_Get_Mission_Detail_Success"        //获取任务详情成功
#define NEWMISSION_EDIT_MISSION_FINISH                   @"NewMission_Edit_Mission_Finish"        //编辑任务成功
#define NEWMISSION_ADD_NEW_MISSION_INTERFACE_FAIL        @"NewMission_Add_New_Mission_Interface_Fail"        //新建任务界面失败
#define NEWMISSION_PLEASE_SELECT_PEOPLE                  @"NewMission_Please_Select_People"        //请选择参与人
#define NEWMISSION_SELECT_START_TIME_INFO				 @"NewMission_Select_Start_Time_info"
#define NEWMISSION_OUT_OF_DATE                           @"NewMission_Out_Of_Date"        //已过期
#define NEWMISSION_IN_DATE                           	 @"NEWMISSION_IN_DATE"        //已过期
#define NEWMISSION_MEMBER                                @"NewMission_Member"        //项目成员
#define NEWMISSION_GET_MISSIONLIST_SUCCESS               @"NewMission_Get_MissionList_success"        //获取任务列表成功
#define NEWMISSION_CHANGE_FAIL                           @"NewMission_Change_Fail"        //修改失败
#define NEWMISSION_ADD_SUBMISSION                        @"NewMission_Add_SubMission"        //添加子任务
#define NEWMISSION_SUBMISSION_DETAIL                     @"NewMission_SubMission_Detail"        //子任务详情

#define MissionMoveError @"MissionMoveError"
/********************任务****************************/
#define MISSION_DETAIL_ITEM          @"Mission_Detaile_item"
#define MISSION_DETAIL_TAG           @"Mission_Detail_tag"
#define MISSION_DETAIL_TITLE         @"Mission_Detail_title"
#define MISSION_NEWTASK_TITLE        @"Mission_NewTask_title"
#define MISSION_EDITTASK_TITLE       @"Mission_EditTask_title"
#define MISSION_TASKDETAIL           @"Mission_TaskDetail_title"
#define MISSION_PROJECT              @"Mission_Project"
#define MISSION_PARTICIPANT          @"Mission_Participant"
#define MISSION_END                  @"Mission_End"
#define MISSION_SUBTASK              @"Mission_SubTask"
#define MISSION_NEWSUBTASK           @"Mission_NewSubTask"
#define MISSION_EDITSUBTASK          @"Mission_EditSubTask"
#define MISSION_DELETESUBTASK        @"Mission_DeleteSubTask"
#define MISSION_CHANGETASK           @"Mission_ChangeTask"
#define MISSION_HIGH                 @"Mission_High"
#define MISSION_MEDIUM               @"Mission_Medium"
#define MISSION_LOW                  @"Mission_Low"
#define MISSION_WHOFIRST             @"Mission_whofirst"
#define MISSION_FILLTASKNAME         @"Mission_FillTaskName"
#define MISSION_ENDTIME              @"Mission_EndTime"
#define MISSION_ALLDAY               @"Mission_AllDay"
#define MISSION_REMARK               @"Mission_Remark"
#define MISSION_MYTASK               @"Mission_MyTask"
#define MISSION_MYATTENDTASK         @"Mission_MyAttendTask"
#define MISSION_MYSENDTASK           @"Mission_MySendTask"
#define MISSION_ENDTODAY             @"Mission_EndToday"
#define MISSION_ENDWEEK              @"Mission_EndWeek"
#define MISSION_NEWPROJECT           @"Mission_NewProject"
#define MISSION_COMFIRMDELETE        @"Mission_ComfirmDelete"
#define MISSION_PROJECTNAME          @"Mission_ProjectName"
#define MISSION_MEMBER               @"Mission_Member"
#define MISSION_NEWBOARD             @"Mission_NewBoard"
#define MISSION_ALL                  @"Mission_All"
#define MISSION_ADD                  @"Mission_Add"
#define MISSION_TODAY                @"Mission_today"
#define MISSION_TOMORROW             @"Mission_tomorrow"
#define MISSION_THEDAYAFTERTOMORROW  @"Mission_thedayaftertomorrow"
#define MISSION_WEEKLATER            @"Mission_weeklater"
#define MISSION_MONTHLATER           @"Mission_monthlater"
#define MISSION_CHOOSE               @"Mission_choose"
#define MISSION_PASS                 @"Mission_pass"
#define MISSION_MORE_CHOOSE          @"Mission_more_choose"
#define MISSION_PLS_INPUT_TAST_TITLE @"Mission_pls_input_task_title"
#define MISSION_CHANGETOPARENT       @"Mission_changeToParent"
#define MISSION_PARENTTASK           @"Mission_parentTask"
#define MISSION_EDITPROJECT          @"Mission_editProject"
#define MISSION_SELECTPROJECT        @"Mission_selectProject"
#define MISSION_EDITWHITEBOARD       @"Mission_editWhiteboard"
#define MISSION_INPUTWHITEBOARDTITLE @"Mission_inputWhiteboardTitle"
#define MISSION_INPUTNOTNONE         @"Mission_inputNotNone"
#define MISSION_EMPTY_ICON           @"Mission_empty_icon"
#define MISSION_FOR_TASK_TITL        @"Mission_title_for_new_tast"
/**************** Message ****************************/
#define CHAT_EMPTY_TIP    @"Chat_empty_tip"
#define CHAT_EMPTY_SUBTIP @"Chat_empty_subTip"

#define MESSAGE_STARTGROUP 			@"Message_StartGroup"
#define CONNECTING                  @"Connecting"
#define UNCONNECT                   @"UnConnect"
#define DELETE                      @"Delete"
#define MESSAGE_SENDAGAIN 			@"Message_SendAgain"
#define MESSAGE_COPY                @"Message_Copy"
#define CANCELVOICE                 @"CancelVoice"
#define UPDATE_SUCCESSFUL           @"UpdateSuccessful"

// RadioManager
#define RADIO_NOWORK                @"Radio_NoWork"
#define RADIO_NOWORREASON 			@"Radio_NoWorkReason"
#define RADIO_TIMETOOSHORT 			@"Radio_TimeTooShort"

// 群聊
#define GEROUPNOTPERMIT 			@"Group_NotPermit"
#define GEROUPPERMIT                @"Group_Permit"
#define GEROUPQUIT                  @"Group_Quit"
#define GEROUPNAME                  @"Group_Name"
#define GEROUPCLEAN                 @"Group_CleanMessage"
#define GEROUPQUITPROMOT            @"Group_QuitPromot"
#define GROUP_CREATE_FAILURE        @"GROUP_CREATE_FAILURE"

// ChatCommonInputView
#define CHAT_TAP                    @"Chat_Tap"
#define CHAT_EMPTY                  @"Chat_empty"
// MsgGroupMgrView
#define GROUPDATA_NAME              @"GroupData_Name"
#define GROUPDATA_NOPUSH            @"GroupData_NoPush"
#define GROUPDATA_DISPLAYNAME       @"GroupData_DisplayName"
#define GROUPDATA_QUIT              @"GroupData_Quit"

// MsgImagePasteView
#define IMAGE_FAILLOAD              @"Image_FailLoad"

// ChatAttachPickView
#define TITLE_BTN_IMG				@"Title_Btn_Img"
#define TITLE_BTN_TAKEPHOTO         @"Title_Btn_TakePhoto"
#define TITLE_BTN_FILE				@"Title_Btn_File"
#define TITLE_BTN_LOCATION			@"Title_Btn_Location"

#define CHAT_READED       @"chat_readed"
#define CHAT_SENDED       @"chat_sended"
#define CHAT_CALL_NUMBER  @"chat_call_number"
#define CHAT_MAIL_TO      @"chat_mail_to"
#define CHAT_MAIL_DEFAULT @"chat_mail_default"
#define CHAT_CALL         @"chat_call"

#define CHAT_ATME_TITEL        @"chat_atme_titel"
#define CHAT_ATME_CONTENT      @"chat_atme_content"

#define CHAT_POINT_TITEL       @"chat_point_titel"
#define CHAT_POINT_CONTENT     @"chat_point_content"

#define CHAT_IMAGE_TITEL       @"chat_image_titel"
#define CHAT_IMAGE_CONTENT     @"chat_image_content"

#define CHAT_FILE_TITEL        @"chat_file_titel"
#define CHAT_FILE_CONTENT      @"chat_file_content"

#define CHAT_APP_TITEL         @"chat_app_titel"
#define CHAT_APP_CONTENT       @"chat_app_content"

// Search
#define SEARCH_DEPARTMENT  @"search_department"
#define SEARCH_CONTACT     @"search_contact"
#define SEARCH_HISTORY     @"search_history"
#define SEARCH_MORECONTACT @"search_moreContact"

#define CHAT_FORWARD_HISTORY        @"Chat_Forward_History"
#define CHAT_FORWARD_HISTORY_SINGLE @"Chat_Forward_History_single"
#define CHAT_FORWARD_ONEBYONE       @"Chat_Forward_Onebyone"
#define CHAT_FORWARD_MERGE          @"Chat_Forward_Merge"
#define CHAT_FORWARD_ONEBYE_WARNING @"Chat_Forward_Onebye_warning"
#define CHAT_FORWARD_MERGE_WARNING  @"Chat_Forward_Merge_warning"
#define CHAT_FORWARD_MERGE_UNSUPPORT_CONTENT  @"CHAT_FORWARD_MERGE_UNSUPPORT_CONTENT"

/**************** ContactClass ****************************/
// 通讯录
#define SEARCH                      @"Search"
#define CONTACT_RECENT              @"Contact_Recent"
#define CONTACT_ORGANIZATION        @"Contact_Organization"
#define CONTACT_MYGROUP             @"Contact_MyGroup"
#define CONTACT_MYFRIEND            @"Contact_MyFriend"
#define CONTACT_MYSECTOR            @"Contact_MySector"
#define CONTACT_MYFAVOUR            @"Contact_MyFavour"
#define SELECT_GROUP                @"Select_Group"
#define FAVOURITE_CONTACT           @"Favourite_Contact"
#define FAVOURITE_CANCEL            @"Favourite_Cancel"
#define OUT_TOPHONE                 @"Out_ToPhone"
#define OUT_SUCCESS                 @"Out_Success"
#define OUT_FAIL                    @"Out_Fail"
#define CONTACT_ADDFAIL             @"Contact_AddFail"
#define SEND_MESSAGE                @"Send_Message"
#define CALL_FAIL                   @"Call_Fail"
#define CONTACT_ADDSUCCESS          @"Contact_AddSuccess"
#define CONTACT_ADD                 @"Contact_Add"
#define CONTACT_SELECT		@"Contact_Select"
#define MYSECTOR_CONTACT            @"MySector_Contact"
#define MYSECTOR_ADD                @"MySector_Add"
#define CHOOSE_GROUP                @"Choose_Group"
#define GROUP_ADDPROMPT             @"Group_AddPrompt"
#define CONTACT_FAVOUR              @"Contact_Favour"
#define COMTACT_GROUPED             @"Contact_Grouped"
#define ISTOP                       @"IsTop"
#define CANCELTOP                   @"CancelTop"
#define FINGERPRINT_IDENTIFICATION  @"Fingerprint_Identification"
#define CONTACT_SEARCHTITLE         @"Contact_SearchTitle"

// FavoriteViewController
#define EDIT                        @"Edit"
#define FINISH                      @"Finish"

// ContactSelectTabBarView
#define CERTAIN_NUMBER              @"Certain_Number"

/**************** ContactBook ****************************/
#define CONTACTBOOK_INDEPARTORDER               @"InDepartOrder"
#define CONTACTBOOK_INNAMEORDER                 @"InNameOrder"
#define CONTACTBOOK_PHONENUM                    @"PhoneNumber"
#define CONTACTBOOK_EMAIL                       @"Email"
#define CONTACTBOOK_BUSINESSPHONENUM            @"BussinsessPhone"
#define CONTACTBOOK_DEPART                      @"Depart"
#define CONTACTBOOK_JOB                         @"Job"
#define CONTACTBOOK_QRCODE                      @"QRCode"
#define CONTACTBOOK_SHARE                       @"Share"
#define CONTACTBOOK_INCLUDE                     @"Include"
#define CONTACTBOOK_DEPARTWORLDS                @"DepartWorlds"
#define CONTACTBOOK_USERNAMEWORLDS              @"UserNameWrolds"
#define CONTACTBOOK_CHAT                        @"chat"
#define CONTACTBOOK_SELECTALL                   @"selectall"

/***************应用评论*****************/
#define COMMENTDELETED     @"CommentDeleted"

/***************Meeting*****************/
#define MEETING_ADDNEWMEETING                    @"Meet_AddNewMeeting"
#define MEETING_TITLE                            @"Meeting_Title"
#define MEETING_MUST_ATTEND                      @"Meeting_Must_Attend"
#define MEETING_CANNOT_ATTEND                    @"Meeting_Cannot_Attend"
#define MEETING_CHOOSETIME_ADDRESS               @"Meeting_ChooseTime_Address"
#define MEETING_TIME_ADDRESS                     @"Meeting_Time_Address"
#define MEETING_REMIND                           @"Meeting_Remind"
#define MEETING_NOTIFICATE                       @"Meeting_Notificate"
#define MEETING_EVENTCONFIRM                     @"Meeting_Eventconfirm"
#define MEETING_COMFIRM                          @"Meeting_Confirm"
#define MEETING_SURE                             @"Meeting_Sure"
#define MEETING_DELETE_CURRENT                   @"Meeting_Delete_Current"
#define MEETING_DELETE                           @"Meeting_Delete"
#define MEETING_INPUT_TITLE                      @"Meeting_input_title"
#define MEETING_INPUT_ATTENDERS                  @"Meeting_input_attenders"
#define MEETING_INPUT_MEETINGTIME                @"Meeting_input_meetingtime"
#define MEETING_INPUT_MEETINGADDRESS             @"Meeting_input_meetingaddress"
#define MEETING_INPUT_MEETINGROOM                @"Meeting_input_meetingroom"
#define MEETING_INPUT_ADDRESSWITHOUT_MEETINGROOM @"Meeting_input_addresswithout_meetingroom"
#define MEETING_INPUT_CHECK_EVENT                @"Meeting_check_event"
#define MEETING_INPUT_ADDRESS                    @"Meeting_input_address"
#define MEETING_INPUT_TIME                       @"Meeting_input_time"
#define MEETING_OPEN_LOCATION                    @"Meeting_open_location"
#define MEETING_IMPORTANT                        @"Meeting_important"
#define MEETING_ADDRESS_CHANGED                  @"Meeting_address_changed"
#define MEETING_EVENT_DAY                        @"Meeting_event_day"
#define MEETING_HOUR                             @"Meeting_hour"

#define MEETING_COMFIRM_DELETE           @"Meeting_Confirm_Delete"
#define MEETING_ADDNEWMEETING_DETAIL     @"Meeting_AddNewMeeting_Deatil"
#define MEETING_ATTEND                   @"Meeting_Attend"
#define MEETING_NOTATTEND                @"Meeting_NotAttend"
#define MEETING_NOTALLOW_CHECK                @"Meeting_NotAllowCheck"
#define MEETING_PERSONAL_SCHEDULE_DETAIL @"Meeting_Personal_Schedule_Detail"

// ************** 好友Friend **************//
#define FRIEND_AGREE          @"Friend_Agree"
#define FRIEND_DISAGREE       @"Friend_DisAgress"
#define FRIEND_ADDFRIEND      @"friend_addFriend"
#define FRIEND_VERIFY         @"friend_verify"
#define FRIEND_REMARK_PLEASE  @"friend_remark_please"
#define FRIEND_ADDREMARK      @"friend_addRemark"
#define FRIEND_REMOVE         @"friend_remove"
#define FRIEND_CHAT           @"friend_chat"
#define FRIEND_VERIFY_PLEASE  @"friend_verify_please"
#define FRIEND_VERIFY_WAIT    @"friend_verify_wait"
#define FRIEND_VERIFY_MESSAGE @"friend_verify_message"
#define FRIEND_ADD            @"friend_add"
#define FRIEND_SEARCH         @"friend_search"

/***************Calendar*****************/
/*view schedle detail*/
#define CALENDAR_CONFIRM_CONFIRMORDER       @"Calendar_confirm_ConfirmOrder"
#define CALENDAR_CONFIRM_DETAILTITLE        @"Calendar_confirm_DetailTitle"
#define CALENDAR_TIME                       @"Calendar_Time"
#define CALENDAR_PLACEHOLDERTIME            @"Calendar_placeHolderTime"
#define CALENDAR_CONFIRM_EDIT               @"Calendar_confirm_Edit"
#define CALENDAR_CONFIRM_TAKEOUTCERTIFICATE @"Calendar_confirm_TakeOutCertificate"

#define CALENDAR_CONFIRM_WHOLEDAY           @"Calendar_confirm_WholeDay"
#define CALENDAR_CONFIRM_ALTERNATE          @"Calendar_confirm_Alternate"
#define CALENDAR_CONFIRM_COPY               @"Calendar_confirm_Copy"
#define CALENDAR_CONFIRM_TEL                @"Calendar_confirm_Tel"
#define CALENDAR_CONFIRM_DETAIL             @"Calendar_confirm_Detail"
#define CALENDAR_CONFIRM_DELETEORDER        @"Calendar_confirm_DeleteOrder"
#define CALENDAR_PLEASE_SELECTE_MEETINGROOM @"Calendar_select_meetingroom"
#define CALENDAR_OTHER_PLACE                @"Calendar_other_place"
#define CALENDAR_EVENT_DETAIL               @"Calendar_event_detail"
#define CALENDAR_NO_MEETING_ROOM            @"Calendar_no_meeting_room"
#define CALENDAR_NO_MEETING_ROOM_OTHER      @"Calendar_no_meeting_room_other"
#define CALENDAR_COPY                       @"Calendar_copy"
#define CALENDAR_CHANGE                     @"Calendar_change"
#define CALENDAR_MYCALENDAR                 @"Calendar_myCalendar"

/*scheduleByWeek*/
#define CALENDAR_SCHEDULEBYWEEK_WEEK      @"Calendar_scheduleByWeek_Week"
#define CALENDAR_SCHEDULEBYWEEK_MONTH     @"Calendar_scheduleByWeek_Month"
#define CALENDAR_SCHEDULEBYWEEK_DAY       @"CALENDAR_SCHEDULEBYWEEK_Day"
#define CALENDAR_SCHEDULEBYWEEK_TIME      @"Calendar_scheduleByWeek_Time"
#define CALENDAR_SCHEDULEBYWEEK_NOORDER   @"Calendar_scheduleByWeek_NoOrder"
#define CALENDAR_SCHEDULEBYWEEK_ADD       @"Calendar_scheduleByWeek_Add"
#define CALENDAR_SCHEDULEBYWEEK_TODAY     @"Calendar_scheduleByWeek_Today"
#define CALENDAR_SCHEDULEBYWEEK_YESTERDAY @"Calendar_scheduleByWeek_Yesterday"
#define CALENDAR_SCHEDULEBYWEEK_TIMEMODE  @"Calendar_scheduleByWeek_TimeMode"
#define CALENDAR_SCHEDULEBYWEEK_SUNDAY    @"Calendar_scheduleByWeek_Sunday"
#define CALENDAR_SCHEDULEBYWEEK_MONDAY    @"Calendar_scheduleByWeek_Monday"
#define CALENDAR_SCHEDULEBYWEEK_TUESTDAY  @"Calendar_scheduleByWeek_Tuesday"
#define CALENDAR_SCHEDULEBYWEEK_WEDNESDAY @"Calendar_scheduleByWeek_Wednesday"
#define CALENDAR_SCHEDULEBYWEEK_THURSDAY  @"Calendar_scheduleByWeek_Thursday"
#define CALENDAR_SCHEDULEBYWEEK_FRIDAY    @"Calendar_scheduleByWeek_Friday"
#define CALENDAR_SCHEDULEBYWEEK_SATURDAY  @"Calendar_scheduleByWeek_Saturday"
#define CALENDAR_OTHERSHADARRANGED_EVENT  @"Calendar_others_hadarranged"
#define CALENDAR_NO_DATA                  @"Calendar_no_data"
#define CALENDAR_NEVER_REMIND             @"Calendar_never_remind"
#define CALENDAR_BEFORE_EVENT_BEGIN       @"Calendar_before_event_begin"
#define CALENDAR_MINUTES_BEFORE           @"Calendar_minutes_before"
#define CALENDAR_HOURS_BEFORE             @"Calendar_hours_before"
#define CALENADR_DAYS_BEFORE              @"Calendar_days_before"
#define CALENDAR_WEEKS_BEFORE             @"Calendar_weeks_before"
#define CALENDAR_NEVER_REPEAT             @"Calendar_never_repeat"
#define CALENDAR_REPEAT_EVERYDAY          @"Calendar_repeat_everyday"
#define CALENDAR_REPEAT_EVERYWEEK         @"Calendar_repeat_everyweek"
#define CALENDAR_REPEAT_EVERYMONTH        @"Calendar_repeat_everymonth"
#define CALENDAR_REPEAT_EVERYYEAR         @"Calenadr_repeat_everyyear"
#define CALENDAR_DELETE_CURRENT           @"Calendar_delete_current"
#define CALENDAR_DELETE_CURRENT_AFTER     @"Calendar_delete_current_after"
#define CALENDAR_EDIT_CURRENT_MEETING     @"Calendar_edit_current_meeting"
#define CALENDAR_EDIT_ALL_MEETINGS        @"Calendar_edit_all_meeting"

#define CALENDAR_MINUTE                   @"Calendar_minute"
#define CALENDAR_HOUR                     @"Calendar_hour"


/*add schedule 1**/
#define CALENDAR_ADD_ADDORDER      @"Calendar_add_AddOrder"
#define CALENDAR_ADD_SAVE          @"Calendar_add_Save"
#define CALENDAR_ADD_CANCLE        @"Calendar_add_Cancle"
#define CALENDAR_ADD_TITLE         @"Calendar_add_Title"
#define CALENDAR_ADD_IMPORTANT     @"Calendar_add_Important"
#define CALENDAR_ADD_PLACE         @"Calendar_add_Place"
#define CALENDAR_ADD_ORDERWHOLEDAY @"Calendar_add_OrderWholeDay"
#define CALENDAR_ADD_CHOOSETIME    @"Calendar_add_ChooseTime"
#define CALENDAR_ADD_REPEAT        @"Calendar_add_Repeat"
#define CALENDAR_ADD_NOTIFICATION  @"Calendar_add_Notification"
#define CALENDAR_ADD_TEL           @"Calendar_add_Tel"
#define CALENDAR_ADD_URL           @"Calendar_add_Url"
#define CALENDAR_ADD_DETAIL        @"Calendar_add_Detail"
#define CALENDAR_OTHERSHADARRANGED_EVENT @"Calendar_others_hadarranged"
#define CALENDAR_EDIT_EVENT        @"Calendar_Edit_Event"

/*add schedule 2*/

#define CALENDAR_TIMEPICKER_CHOOSETIME        @"Calendar_timePicker_ChooseTime"
#define CALENDAR_TIMEPICKER_DATE2             @"Calendar_timePicker_Date2"
#define CALENDAR_TIMEPICKER_STARTTIME         @"Calendar_timePicker_StartTime"
#define CALENDAR_TIMEPICKER_ENDTIME           @"Calendar_timePicker_EndTime"
#define CALENDAR_TIMEPICKER_ADDALTERNATEDATA  @"Calendar_timePicker_AddAlternateData"
#define CALENDAR_TIMEPICKER_COPYALTERNATEDATA @"Calendar_timePicker_CopyAlternateData"
#define CALENDAR_SELECTEALTERNATEDATA 		  @"Calendar_SelecteAlternateData"
/*schedule by month*/
#define CALENDAR_SCHEDULEBYMONTH_SEARCH	@"Calendar_scheduleByMonth_Search"
#define CALENDAR_SCHEDULEBYMONTH_CANCLE	@"Calendar_scheduleByMonth_Cancle"

/*view schedule detail1*/
#define CALENDAR_VIEWSCHEDULEDETAIL_FAIL       @"Calendar_viewScheduleDetail_Fail"
#define CALENDAR_VIEWSCHEDULEDETAIL_FAILDETAIL @"Calendar_viewScheduleDetail_FailDetail"


/*view schedule detail3*/
#define CALENDER_VIEWSCHEDULEDELETEALTERVIEW_ALERTTILE   @"Calender_viewScheduleDeleteAlterview_Alerttile"
#define CALENDER_VIEWSCHEDULEDELETEALTERVIEW_ALERTDETAIL @"Calender_viewScheduleDeleteAlterview_AlertDetail"
#define CALENDER_VIEWSCHEDULEDELETEALTERVIEW_NO          @"Calender_viewScheduleDeleteAlterview_No"
#define CALENDER_VIEWSCHEDULEDELETEALTERVIEW_YES         @"Calender_viewScheduleDeleteAlterview_YES"

#define CALENDAR_SELECTEDITTYPE @"Calendar_selectEditType"
#define CALENDAR_ONLYTYPE       @"Calendar_onlytype"
#define CALENDAR_ALLTYPE        @"Calendar_alltype"
#define CALENDAR_MYCALENDAR     @"Calendar_myCalendar"

#define CALENDAR_CREATE_SENDE_SUCCESS @"Calendar_Create_Sender_Success"

/**************** UserInfo ****************************/
#define USERINFO_CIRCLE 			@"UserInfo_Circle"
#define USERINFO_MYGALLERY 			@"UserInfo_MyGallery"
#define USERINFO_MYFAVORITE 		@"UserInfo_MyFavorite"
#define USERINFO_COMMENTS 			@"UserInfo_Comments"
#define USERINFO_SETTING 			@"UserInfo_Setting"

// 个人信息详情
#define USERINFO_PHONE              @"UserInfo_Phone"
#define USERINFO_HOMEPHONE 			@"UserInfo_HomePhone"
#define USERINFO_MAIL               @"UserInfo_Mail"
#define USERINFO_DEPARTMENT 		@"UserInfo_Department"
#define USERINFO_POSITION 			@"UserInfo_Position"
#define UNSET                       @"Unset"
#define VICE_DIRECTOR               @"Vice_Director"

// 添加头像
#define GALLERY                     @"Gallery"
#define CAMERA                      @"Camera"
#define CANCEL                      @"Cancel"
#define SAVE                        @"Save"

// 设置页面
#define SIGNOUT                     @"Setting_SignOut"
#define SETTING_NEWMESSAGE 			@"Setting_NewMessage"
#define SETTING_CLEARCACHE 			@"Setting_Cache"
#define SETTING_GESTURE 			@"Setting_Gesture"
#define SETTING_FEEDBACK 			@"Setting_FeedBack"
#define SETTING_ABOUT               @"Setting_About"
#define SETTING_MULTILINGUAL        @"Setting_Multilingual"

// 语言列表
#define LANGUAGE_SYSTEM         @"Language_System"
#define LANGUAGE_SPCHINESE      @"Language_SpChinese"
#define LANGUAGE_ENGLISH        @"Language_English"
#define LANGUAGE_JAPANESE       @"Language_Japanese"
#define PROMPT                  @"Prompt"
#define EFFECTIVE_AFTER_RELOGIN @"Effective_After_Re-login"
#define LANGUAGE_CHANGETITLE    @"Language_ChangeTitle"

// 修改密码
#define PASSWORD_SETTING 		@"Password_Title"
#define NOWPASSWORD 			@"Now_Password"
#define CERTAIN 				@"Certain"
#define PASSWORDWRONG			@"PasswordWrong"
#define CHANGESUCCESS 			@"ChangeSuccess"
#define PASSWORD_LEAST 			@"Password_Least"
#define PASSWORD_UNMATCHING 	@"Password_UnMatching"
#define PASSWORD_NEW 			@"Password_New"
#define PASSWORD_DETERMINE 		@"Password_Determine"
#define PASSWORD_TWICE 			@"PassWord_Twice"

// 注销
#define CERTAIN_SIGNOUT @"Certain_SignOut"
#define SETYES 			@"YES"
#define SETNO 			@"NO"

// 新消息通知
#define VOICE 			@"Voice"
#define SHOCK 			@"Shock"

// 意见反馈
#define SEND                @"Send"
#define SENDERROR           @"SendError"
#define WRITECONTENT        @"WRITECONTENT"
#define THANKSFORBACK       @"THAKSFORBACK"
#define INPUTPROBLEM        @"Input_problem"
#define FEEDBACK_PRO        @"Feedback_pro"
#define FEEDBACK_CHOOSEPIC  @"Feedback_choosePic"
#define FEEDBACK_CHOOSETYPE @"Feedback_chooseType"
#define FEEDBACK_COMMIT     @"Feedback_commit"

// 关于软件
#define CHECK_UPDATE 		@"Check_Update"
#define TOSCORE 			@"score"
#define CHECKNEW 			@"Check_New"
#define CHECKDOWN 			@"Check_Down"
#define CHECKDOWN2 			@"Check_Down2"
#define IGONORE 			@"Ignore"
#define UPDATE 			    @"Update"
#define STORE_ERROR 		@"Store_Error"
#define FindNewVersion      @"FindNewVersion"
#define UpdateNow           @"UpdateNow"
#define UpdateLater         @"UpdateLater"

/****************  第三方库  ****************************/
// MJPhotoToolbar
#define SAVEERROR           @"SaveError"
#define SAVEPHOTPSUCCESS    @"SavePhotoSuccess"

// QBImagePicker
#define CAMERA_ROLL @"CameraRoll"
#define PREVIEW     @"Preview"
#define FINISH      @"Finish"
#define BACK        @"Back"

// 上拉 下拉
#define NOMORE        @"NoMore"
#define CLICK_MORE    @"Click_More"
#define CLICK_NULL    @"Click_Null"
#define CLICK_LOADING @"Click_Loading"
#define PUSH_LOADING  @"Push_Loading"
#define LOOSE_LOADING @"Loose_Loading"
#define LOADING       @"Loading"
#define LAST_LOADING  @"Last_Loading"
#define NORECORD      @"Norecord"


// 聊天之前遗漏的
#define CANCEL_MARK                 @"Cancel_Mark"
#define MAKE_MARK                   @"Make_Mark"
#define PICK_PHOTO                  @"Pick_Photo"
#define SAVE_PHOTO                  @"Save_Photo"
#define NO_SAVE                     @"No_Save"
#define CHAT_SET                    @"Chat_Set"
#define NO_MESSAGE                  @"No_Message"
#define DELETE_MESSAGE              @"Delete_Message"
#define QUIT_DELETE                 @"Quit_Delete"
#define FILE_BANDOWNLOAD            @"File_BanDownload"
#define FILE_CLICKDOWNLOAD          @"File_ClickDownload"
#define FILE_FAILDOWNLOAD           @"File_FailDonwload"
#define SCHEDULE_TIME               @"Schedule_Time"
#define SCHEDULE_PLACE              @"Schedule_Place"
#define TASK_TYPE                   @"Task_Type"
#define TASK_LEVEL                  @"Task_Level"
#define LEAVE                       @"Leave"
#define REFUSE                      @"Refuse"
#define LOOK                        @"Look"
#define CHANGEDEVICE                @"ChangeDevice"
#define UNSUPPORT                   @"UnSupport"
#define NEWMESSAGEATTENTION         @"NewMessageAttention"
#define OPENNOTIFY                  @"OpenNotify"
#define CLOSENOTIFY                 @"CloseNotify"

#define CHAT_ATME                   @"Chat_atMe"
#define CHAT_AT                     @"Chat_at"
#define CHAT_SELECTPERSON           @"Chat_selectPerson"
#define CHAT_INPUTHABIT_SETTING     @"Chat_inputHabit_setting"
#define CHAT_BREAKLINE              @"Chat_breakLine"
#define CHAT_DONT_DISTURB           @"Chat_dont_disturb"
#define CHAT_ATALL                  @"Chat_atAll"
#define CHAT_DRAFT                  @"Chat_draft"

// 消息搜索 ---------------------------------------------------------
#define SEARCH_MESSAGECONTENT       @"Search_MessageContent"
#define MESSAGE_LOGGING             @"Message_Logging"
#define EMPHASIS                    @"emphasis"
#define CANCLE_MARK_EMPHASIS        @"Cancle_Mark_Emphasis"
#define TO_SCHEDULE                 @"To_Schedule"
#define TO_TASK                     @"To_Task"
#define TO_RECALL                   @"To_Recall"
#define FROWARDING                  @"Frowarding"
#define MEETING                     @"Meeting"
#define FROM                        @"From"
#define MESSAGE_VOICE               @"Message_voice"
#define PLACE                       @"place"
#define STATE                       @"state"
#define PRIORITY                    @"priority"
#define ASK_FOR_LEAVE               @"Ask_For_Leave"
#define VETO                        @"veto"
#define COST                        @"cost"
#define RECALL_SOMEBODY             @"recall_somebody"
#define RECALL_ME                   @"recall_me"

/*********************应用评论翻译**************************/
#define APPCOMMENT_UNKONW_INFO 				  @"appcomment_unkonw_info"
#define APPCOMMENT_REFUSE_ATTEND              @"appcomment_refuse_attend"
#define APPCOMMENT_MEETING_ATTEND             @"appcomment_meeting_attend"
#define APPCOMMENT_MEETING_CANCEL			  @"appcomment_meeting_cancel"
#define APPCOMMENT_APPROVE_PASS               @"appcomment_approve_pass"
#define APPCOMMENT_APPROVE_BACK_DEFINITE      @"appcomment_approve_back_definite"
#define APPCOMMENT_APPROVE_REFUSE_DEFINITE    @"appcomment_approve_refuse_definite"
#define APPCOMMENT_APPROVE_TRANSPOND_DEFINITE @"appcomment_approve_transpond_definite"
#define APPCOMMENT_TASK_EDIT_STATUS_DEFINITE  @"appcomment_task_edit_status_definite"

#define APPCOMMENT_NEWAPPROVE_CREATE          @"appcomment_newapprove_create"
#define APPCOMMENT_NEWAPPROVE_EDIT            @"appcomment_newapprove_edit"
#define APPCOMMENT_NEWAPPROVE_TRANSPONDTO     @"appcomment_newapprove_transpondto"
#define APPCOMMENT_NEWAPPROVE_PASS            @"appcomment_newapprove_pass"
#define APPCOMMENT_NEWAPPROVE_BACK            @"appcomment_newapprove_back"
#define APPCOMMENT_NEWAPPROVE_REFUSE          @"appcomment_newapprove_refuse"

#define APPCOMMENT_CREATETASK       @"appcomment_createTask"
#define APPCOMMENT_TASKUPDATE       @"appcomment_taskUpdate"
#define APPCOMMENT_TASKCHANGESTATUS @"appcomment_taskChangeStatus"

//"appcomment_refuse_attend"              = "拒绝参加";
//"appcomment_meeting_attend"             = "确定参加";
//"appcomment_approve_pass"               = "通过了 %@";
//"appcomment_approve_back_definite"      = "打回了 %@。 %@";
//"appcomment_approve_refuse_definite"    = "拒绝了 %@。 %@";
//"appcomment_approve_transpond_definite" = "转交了 %@。 %@";
//"appcomment_task_edit_status_definite"  = "修改任务状态为%@";

#define APPLY_ALL           @"Apply_all"
#define APPLY_NEEDAPPLY     @"Apply_needapply"
#define APPLY_SENDS          @"Apply_sends"
#define APPLY_CC            @"Apply_cc"
#define APPLY_DONE          @"Apply_done"
#define APPLY_CHOOSE_APPLYKIND @"Apply_choose_applykind"
#define APPLY_INPUT_LEAVECONTENT @"Apply_input_leavecontent"
#define APPLY_INPUT_MONEYCONTENT @"Apply_input_moneycontent"
#define APPLY_MORE              @"Apply_more"

#define IM_COMMENT               @"im_comment"
#define IM_MEETINGATTEND         @"im_meetingAttend"
#define IM_MEETINGATTENDDEFINITE @"im_meetingAttendDefinite"
#define IM_MEETINGREFUSEATTEND   @"im_meetingRefuseAttend"
#define IM_DELETE                @"im_delete"
#define IM_TASKEDITSTATUS        @"im_taskEditStatus"
#define IM_APPROVEPASS           @"im_approvePass"
#define IM_APPROVEBACK           @"im_approveBack"
#define IM_APPROVEREFUSE         @"im_approveRefuse"
#define IM_APPROVETRANSPOND      @"im_approveTranspond"
#define IM_REMINDSCHEDULE        @"im_remindSchedule"
#define IM_REMINDTASK            @"im_remindTask"
#define IM_REMINDTASKV2          @"im_remindTaskV2"
//#define IM_CREATTASKV2           @"im_createTaskV2"
//#define IM_TASKV2UPDATE          @"im_taskV2Update"
//#define IM_TASKV2CHANGESTATUS    @"im_taskV2ChangeStatus"
//#define IM_TASKV2CHANGEDONESTATUS    @"im_taskV2ChangeDoneStatus"
//#define IM_TASKV2CHANGEDOINGSTATUS   @"im_taskV2ChangeDoingStatus"

#define IM_CHATCARD_UNDONE          @"im_chatcard_undone"
#define IM_CHATCARD_DONE            @"im_chatcard_done"
#define IM_CHATCARD_SYSTEMMESSAGE   @"im_chatcard_systemmessage"
#define IM_CHATCARD_TRANSFORM       @"im_chatcard_transform"
#define IM_CHATCARD_ATTAEND         @"im_chatcard_attend"
#define IM_CHATCARD_NOTATTEND       @"im_chatcard_notattend"

//新版小卡片
#define IM_CHARCARD_REMIND               @"im_charcard_remind"
#define IM_CHATCARD_MEETING_ATTEND       @"im_chatcard_meeting_attend"
#define IM_CHATCARD_MEETING_NOTATTEND    @"im_chatcard_meeting_notattend"
#define IM_CHATCARD_MEETING_CANCEL       @"im_chatcard_meeting_cancel"
#define IM_CHATCARD_MEETING_EDIT         @"im_chatcard_meeting_edit"
#define IM_CHATCARD_APPROVE_PASS         @"im_chatcard_approve_pass"
#define IM_CHATCARD_APPROVE_BACK         @"im_chatcard_approve_back"
#define IM_CHATCARD_APPROVE_NOINFO		 @"IM_CHATCARD_APPROVE_NOINFO"
#define IM_CHATCARD_APPROVE_REFUSE       @"im_chatcard_approve_refuse"
#define IM_CHATCARD_APPROVE_TRANSPOND    @"im_chatcard_approve_transpond"
#define IM_CHATCARD_TASK_EDITTODONE      @"im_chatcard_task_edittodone"
#define IM_CHATCARD_TASK_EDITTOUNDONE    @"im_chatcard_task_edittoundone"
#define IM_CHATCARD_TASK_EDITCONTENT     @"im_chatcard_task_editcontent"
#define IM_CHATCARD_TASK_DELETE          @"im_chatcard_task_delete"

//新版日程
#define NEWCALENDAR_INPUTEVENTTITLE      @"newcalendar_inputeventtitle"
#define NEWCALENDAR_ONLYMECANSEE         @"newcalendar_onlymecansee"
#define NEWCALENDAR_CURRENTLOCATION      @"newcalendar_currentlocation"
#define NEWCALENDAR_SEEOTHEREVENT        @"newcalendar_seeotherevent"
#define NEWCALENDAR_BACKTOMYEVENT        @"newcalendar_backtomyevent"
#define NEWCALENDAR_ADDLOCATION          @"newcalendar_addlocation"
#define NEWCALENDAR_DELETELOCATION       @"newcalendar_deletelocation"

//新版任务
#define NEWTASK_CONTANTWORDSINTASK       @"newtask_contantwordsintask"
#define NEWTASK_CONTANTATTENDARINTASK    @"newtask_contantattendarintask"

//新版会议
#define NEWMEETING_CANCELREASON          @"Newmeeting_cancelreason"
#define NEWMEETING_INPUTREASON           @"Newmeeting_inputreason"

/*********************二维码**************************/
#define QR_SCAN         @"QR_scan"
#define QR_DESCRIPTION  @"QR_description"
#define QR_WEB_LOGIN    @"QR_web_login"
#define QR_CANCEL_LOGIN @"QR_cancel_login"
#define QR_CAMERA_UNVAIABLE_INFO @"QR_Camera_Unavailable_info"

/*********************关于Launchr**************************/
#define ABOUT_LAUNCHR_PROTOCOL       @"About_launchr_protocol"
#define ABOUT_LAUNCHR_POLICY         @"About_launchr_Policy"
#define ABOUT_LAUNCHR_VERSION        @"About_launchr_version"
#define ABOUT_LAUNCHR_LATEST_VERSION @"About_launchr_latest_version"

#endif
