//
//  ChatBaseViewController+ChatCellActions.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ChatBaseViewController+ChatCellActions.h"
#import "ATModuleInteractor+CoordinationInteractor.h"
#import "ForwardSelectRecentContactViewController.h"
#import "HMBaseNavigationViewController.h"
#import "ChatIMConfigure.h"
#import "MessageBaseModel+CellSize.h"
#import "ContactInfoModel.h"
#import "HealthPlanMessionInfo.h"

#import "DetectRecord.h"
#import "SurveyRecord.h"
#import "AppointmentInfo.h"
#import "HealthHistoryItem.h"

#import "CreateDocumetnMessionInfo.h"
#import "EvaluationListRecord.h"
#import "RoundsMessionModel.h"
#import "HealthNoteDetailViewController.h"
#import "IMNewsModel.h"
#import "HealthEducationItem.h"
#import "HealthEducationDetailViewController.h"
#import "HMPatientGroupForwardViewController.h"
#import "HMNoticeWindowViewController.h"

#import "RoundsDetailViewController.h"
#import "HealthPlanSummaryViewController.h"


@implementation ChatBaseViewController (ChatCellActions)

#pragma mark - ChatBaseTableViewCell Delegate

- (BOOL)chatBaseTableViewCellCanBecomeFirstResponder:(ChatBaseTableViewCell *)cell menuImageView:(MenuImageView *)menuImageView {
    BOOL isFirstResponder = [self.chatInputView isFirstResponder];
    
    ChatInputTextView *textInputView = self.chatInputView.viewCommon.txView;
    textInputView.canPerformNormalMenu = NO;
    textInputView.menuImageView = isFirstResponder ? menuImageView : nil;
    
    return !isFirstResponder;
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToCancelEmphasisAtIndexPath:(NSIndexPath *)indexPath {
    return; // 不能直接取消收藏

    //    MessageBaseModel *baseModel = [self.arrayDisplay objectAtIndex:indexPath.row];
//
//    if ([self.module.sessionModel._tag isEqualToString:im_doctorPatientGroupTag] && baseModel._type == msg_personal_image) {
//        // 医患聊天收藏图片事件，由子类处理
//        [self at_patientDoctorChatCollectImageWithModel:baseModel];
//    }
//    else {
//        return; // 不能直接取消收藏
//    }

//    [self markMessage:indexPath.row];
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToEmphasisAtIndexPath:(NSIndexPath *)indexPath {
    MessageBaseModel *baseModel = [self.arrayDisplay objectAtIndex:indexPath.row];

    if ([self.module.sessionModel._tag isEqualToString:im_doctorPatientGroupTag] && baseModel._type == msg_personal_image) {
        // 医患聊天收藏图片事件，由子类处理
        [self at_patientDoctorChatCollectImageWithModel:baseModel];
    }
    else {
        [self markMessage:indexPath.row];
    }
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToCopyAtIndexPath:(NSIndexPath *)indexPath {
    [self copyMessage:indexPath.row];
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToRecallAtIndexPath:(NSIndexPath *)indexPath {
    MessageBaseModel *model = [self.arrayDisplay objectAtIndex:indexPath.row];
    
    [[MessageManager share] recallMessage:model completion:^(BOOL success) {
        if (!success) {
            NSLog(@"撤回失败");
            return;
        }
        
        NSLog(@"撤回成功");
    }];
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToMissionAtIndexPath:(NSIndexPath *)indexPath {
    MessageBaseModel *model = [self.arrayDisplay objectAtIndex:indexPath.row];
#pragma unused (model)
    
    // 转为任务
    // do something
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToScheduleAtIndexPath:(NSIndexPath *)indexPath {
    MessageBaseModel *baseModel = [self.arrayDisplay objectAtIndex:indexPath.row];
    NSString *title = baseModel._content;
#pragma unused (title)
    // 转为日程
    // do something
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToForwardAtIndexPath:(NSIndexPath *)indexPath {
    MessageBaseModel *baseModel = [self.arrayDisplay objectAtIndex:indexPath.row];
    NSString *title = baseModel._content;
#pragma unused (title)

    // 转发
    // do something
    switch (self.chatType) {
        case IMChatTypePatientChat:
        {//医患
            HMPatientGroupForwardViewController *forwardVC = [[HMPatientGroupForwardViewController alloc] initWithMessages:@[baseModel]];
            [self.navigationController pushViewController:forwardVC animated:YES];

            break;
        }
        case IMChatTypeWorkGroup:
        {//工作组
            ForwardSelectRecentContactViewController *VC = [ForwardSelectRecentContactViewController new];
            VC.messageModel = baseModel;
            HMBaseNavigationViewController *navi = [[HMBaseNavigationViewController alloc] initWithRootViewController:VC];
            [self presentViewController:navi animated:YES completion:nil];

            
            break;
        }
        default:
            break;
    }
   
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell pressHeadAtIndexPath:(NSIndexPath *)indexPath {
    MessageBaseModel *model = [self.arrayDisplay objectAtIndex:indexPath.row];
    // 查看人员详情
    // do something
    // 先获取群信息
    UserProfileModel *groupModel = [[MessageManager share] queryContactProfileWithUid:self.strUid];
    // 遍历群成员，取出点击头像对用的群成员model
    for (UserProfileModel *newModel in groupModel.memberList) {
        if ([newModel.userName isEqualToString:[model getUserName]]) {
            if ([self.strUid hasSuffix:@"@ChatRoom"]) {
                // 讨论组，工作圈
                [[ATModuleInteractor sharedInstance] goDoctorDetailInfoWithRelationType:ContactRelationshipType_stranger model:newModel];
            }
            else if ([self.strUid hasSuffix:@"@SuperGroup"]&&![newModel.type isEqualToString:@"普通用户"]) {
                // 群
                [[ATModuleInteractor sharedInstance] goDoctorDetailInfoWithRelationType:ContactRelationshipType_groupMember model:newModel];
            }
            
        }
    }
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell tappedAtIndexPath:(NSIndexPath *)indexPath {
    MessageBaseModel *baseModel = [self.arrayDisplay objectAtIndex:indexPath.row];
    if (baseModel._type != msg_personal_image) {
        [self cellClicked:baseModel];
        return;
    }
    
    // 封装图片数据
    MWPhoto *photo;
    NSInteger currentSelectIndex = 0;
    [self.arrayPhotos removeAllObjects];
    [self.arrayThumbs removeAllObjects];
    NSArray *arrImages = [[MessageManager share] queryBatchImageMessageWithUid:self.strUid];
    for (NSInteger i = 0; i < arrImages.count; i ++)
    {
        MessageBaseModel *model = arrImages[i];
        
        if (model._type == msg_personal_image)
        {
            if (model._nativeThumbnailUrl.length == 0)
            {
                // 网络下载图片
                photo = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",im_IP_http,model.attachModel.fileUrl]]];
                [self.arrayPhotos addObject:photo];
                
                photo = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",im_IP_http,model.attachModel.thumbnail]]];
                [self.arrayThumbs addObject:photo];
                
            }
            else
            {
                // 本地图片
                photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeOriginalUrl]]];
                [self.arrayPhotos addObject:photo];
                
                photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeThumbnailUrl]]];
                [self.arrayThumbs addObject:photo];
                
            }
        }
        if (baseModel._msgId == model._msgId)
        {
            currentSelectIndex = i;
        }
        
    }
    
    // Modal
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self.photoBrowser reloadData];
    [self.photoBrowser setCurrentPhotoIndex:currentSelectIndex];
    
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell longPressHeadAtIndexPath:(NSIndexPath *)indePath {
    // 单聊不能@人
    if (!self.groupChat || self.hideInputView) {
        return;
    }
    MessageBaseModel *model = [self.arrayDisplay objectAtIndex:indePath.row];
    
    ContactInfoModel *atPerson = [ContactInfoModel new];
    atPerson.relationInfoModel.relationName = [model getUserName];
    atPerson.relationInfoModel.nickName = [model getNickName];
    
    [self.chatInputView popupKeyboard];
    [self.chatInputView addAtUser:atPerson deleteFrontAt:NO];
    
}


#pragma mark - Actions

/* 复制消息*/
- (void)copyMessage:(NSInteger)index
{
    // 得到消息体
    MessageBaseModel *baseModel = [self.arrayDisplay objectAtIndex:index];
    
    // 复制消息
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    // 判断是文字还是图片
    if (baseModel._type == msg_personal_text)
    {
        [pasteboard setString:baseModel._content];
    }
    else if (baseModel._type == msg_personal_image)
    {
        // 判断是接收的消息还是发送的消息
        NSString *strImg;
        if (baseModel._markFromReceive)
        {
            strImg = baseModel.attachModel.fileUrl;
            // FK，太BT了 http起头的URL进去后，pasteborad.string也会被设置，而pasteborad.string一旦有值就不会触发外层的paste:方法，只能伪装下URL；By Remon，以后有更好的方法可以自行修改；
            strImg = [NSString stringWithFormat:@"//%@",strImg];
        }
        else
        {
            // 区分是web端同步下来的还是本地发送的
            if (baseModel._nativeThumbnailUrl.length == 0)
            {
                strImg = baseModel.attachModel.fileUrl;
                // FK，太BT了 http起头的URL进去后，pasteborad.string也会被设置，而pasteborad.string一旦有值就不会触发外层的paste:方法，只能伪装下URL；By Remon，以后有更好的方法可以自行修改；
                strImg = [NSString stringWithFormat:@"//%@",strImg];
            }
            else
            {
                strImg = baseModel._content;
            }
            
        }
        [pasteboard setURL:[NSURL URLWithString:strImg]];
    }
    else if (baseModel._type == msg_personal_event) {
        
        NSDictionary* dicContent = [NSDictionary JSONValue:baseModel._content];
        MessageBaseModelContent *contentModel = [MessageBaseModelContent mj_objectWithKeyValues:dicContent];
        if ([contentModel.type isEqualToString:@"receiptMsg"]) {
            // 回执消息
            [pasteboard setString:contentModel.msg];
            
        }
    }

}
/* 标记为重点 */
- (void)markMessage:(NSInteger)index
{
    // 得到消息体
    MessageBaseModel *baseModel = [self.arrayDisplay objectAtIndex:index];
    
    /* 在这里进行标记操作 */
    [[MessageManager share] markMessage:baseModel];
    [[MessageManager share] markMessageImportantWithModel:baseModel important:!baseModel._markImportant];
    baseModel._markImportant ^= 1;
//    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
//    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    [self at_postSuccess:@"已收藏"];
}

// 播放音频管理
- (void)voicePlayOrStopWithVoicePath:(NSString *)voicePath playVoiceMsgId:(long long)voiceMsgId {
    
    self.module.currentNeedPlayVoiceMsgId = wz_default_needVoice_msgId;
    
    if (self.audioManager.isPlaying) {
        if (self.currentPlayingVoiceMsgId == voiceMsgId) {
            // 同一个气泡，停止播放
            [self.audioManager stopPlayAudio];
            self.currentPlayingVoiceMsgId = wz_default_needVoice_msgId;
            self.adapter.currentPlayingVoiceMsgId = wz_default_needVoice_msgId;
            return;
        }
    }
    
    [self.audioManager playAudioWithPath:voicePath];
    self.currentPlayingVoiceMsgId = voiceMsgId;
    //
    self.adapter.currentPlayingVoiceMsgId = voiceMsgId;
}

/** 重发消息*/
- (void)resendMessage:(MessageBaseModel *)baseModel
{
    // 文本直接删除数据库重发，其他直接更改状态
    [[MessageManager share] shouldReSendMessageWith:baseModel];
    
    switch (baseModel._type)
    {
        case msg_personal_text:
            [[MessageManager share] sendMessageTo:self.strUid nick:self.strName WithContent:baseModel._content Type:msg_personal_text atUser:[baseModel atUser]];
            break;
            
        case msg_personal_image:
        case msg_personal_voice:
        {
            // 2. 下锚点
            [[MessageManager share] anchorAttachMessageType:baseModel._type
                                                   toTarget:self.strUid
                                                   nickName:self.strName
                                                primaryPath:baseModel._nativeOriginalUrl
                                                  minorPath:baseModel._nativeThumbnailUrl];
            break;
        }
            //        case msg_personal_video:
            //        {
            //            // 获取目录下路径
            //            NSString *fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:baseModel._nativeOriginalUrl];
            //
            //            // 下锚点
            //            MessageBaseModel *uploadBaseModel = [[MessageManager share] anchorVideoMessageTo:self.strUid nick:self.strName localOriginalPath:fullPath thumbnailPath:[self videoScreenShotWithURL:baseModel._nativeThumbnailUrl]];
            //
            //            AttachmentUploadModel *videoUploadModel = [[AttachmentUploadModel alloc] initWithPath:fullPath type:attachment_video];
            //            AttachmentUploadDAL *videoUploadDAL = [[AttachmentUploadDAL alloc] initWithAttach:videoUploadModel];
            //            videoUploadDAL.uploadBaseModel = uploadBaseModel;
            //            [videoUploadDAL setDelegate:self];
            //        }

        default:
            break;
    }
}

// 单元格点击事件
- (void)cellClicked:(MessageBaseModel *)baseModel {
    // 区分消息类型
    if (baseModel._type == msg_personal_voice)
    {
        if ([baseModel isFileDownloaded] == YES)
        {
            // 直接播放
            // 播放音频管理
            [self voicePlayOrStopWithVoicePath:[[MsgFilePathMgr share] getAllPathWithRelativePath:baseModel._nativeOriginalUrl] playVoiceMsgId:baseModel._msgId];
        }
        else
        {
            self.module.currentNeedPlayVoiceMsgId = baseModel._msgId;
            // 下载后再播放
            [[MessageManager share] downloadAudioSourceWithModel:baseModel];
        }
        
    }
    
    else if (baseModel._type == msg_personal_file)
    {
    }
    else if (baseModel._type == msg_personal_news) {
        //图文消息
        NSString* content = baseModel._content;
        if (!content || 0 == content.length) {
            return;
        }
        NSDictionary* dicContent = [NSDictionary JSONValue:content];
        if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
        {
            return;
        }
        IMNewsModel* modelContent = [IMNewsModel mj_objectWithKeyValues:dicContent];
        [modelContent conmfirmNewsType];
        
        switch (modelContent.newsType) {
            case News_Normal:
            {
                //文章阅读(健康宣教)
                HealthNoteDetailViewController *VC = [[HealthNoteDetailViewController alloc]initWithNewsModel:modelContent];
                [self.navigationController pushViewController:VC animated:YES];
                break;
            }
            case News_EdcuationClassroom:
            {
                //健康课堂
                HealthEducationItem* educationModel = [[HealthEducationItem alloc] init];
                educationModel.classId = modelContent.notesID.integerValue;
                
                [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationDetailViewController" ControllerObject:educationModel];
                
                break;
            }
            case News_Notice:{
                // 公告
                HMNoticeWindowViewController *VC = [[HMNoticeWindowViewController alloc] initWithUrl:modelContent.newsUrl];
                [self presentViewController:VC animated:YES completion:nil];
                break;
            }
            default:
            {
                HealthNoteDetailViewController *VC = [[HealthNoteDetailViewController alloc]initWithNewsModel:modelContent];
                [self.navigationController pushViewController:VC animated:YES];
                break;
            }
        }

        

    }

    else if (baseModel._type == msg_personal_event)
    {
        // 事件类型
        //自定义消息
        NSString* content = baseModel._content;
        if (!content || 0 == content.length) {
        }
        NSDictionary* dicContent = [NSDictionary JSONValue:content];
        if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
        {
            return;
        }
        MessageBaseModelContent* modelContent = [MessageBaseModelContent mj_objectWithKeyValues:dicContent];
        NSString* contentType = modelContent.type;
        if (!contentType || contentType.length == 0)
        {
            return;
        }
        
        if ([contentType isEqualToString:@"serviceComments"])
        {
            //服务评价消息
            
        }
        
        if ([contentType isEqualToString:@"healthyReportDetPage"])
        {
            //健康报告
            MessageBaseModelHealthReportContent* modelContent = [MessageBaseModelHealthReportContent mj_objectWithKeyValues:dicContent];
            [HMViewControllerManager createViewControllerWithControllerName:@"HealthReportDetailViewController" ControllerObject:modelContent.healthyReportId];
        }
        
        if ([contentType isEqualToString:@"testResultPage"])
        {
            //跳转到监测结果界面
            MessageBaseModelDetectResultAlertContent* modelContent = [MessageBaseModelDetectResultAlertContent mj_objectWithKeyValues:dicContent];
            NSString* kpi = modelContent.kpiCode;
            if (!kpi || 0 == kpi.length) {
                return;
            }
            
            DetectRecord* record = [[DetectRecord alloc]init];
            [record setUserId:modelContent.reUserId.integerValue];
            [record setTestDataId:modelContent.testDataId];
            [record setKpiCode:modelContent.kpiCode];
            
            if ([kpi isEqualToString:@"XY"])
            {
                //血压
                [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureResultContentViewController" ControllerObject:record];
                return;
            }
            
            if ([kpi isEqualToString:@"XL"])
            {
                DetectRecord* sourceRecord = [[DetectRecord alloc]init];
                [sourceRecord setTestDataId:modelContent.sourceTestDataId];
                
                if ([modelContent.sourceKpiCode isEqualToString:@"XD"])
                {
                    //心电 跳转到心电监测详情页面
                    [HMViewControllerManager createViewControllerWithControllerName:@"ECGDetectResultContentViewController" ControllerObject:sourceRecord];
                    return;
                }
                if ([modelContent.sourceKpiCode isEqualToString:@"XY"])
                {
                    //血压
                    [HMViewControllerManager createViewControllerWithControllerName:@"BloodPressureResultContentViewController" ControllerObject:sourceRecord];
                    return;
                }
                
            }
            
            if ([kpi isEqualToString:@"TZ"])
            {
                //体重
                [HMViewControllerManager createViewControllerWithControllerName:@"BodyWeightResultContentViewController" ControllerObject:record];
                return;
            }
            
            if ([kpi isEqualToString:@"XT"])
            {
                //血糖
                [HMViewControllerManager createViewControllerWithControllerName:@"BloodSugarDetectResultViewController" ControllerObject:record];
                return;
            }
            
            if ([kpi isEqualToString:@"XZ"])
            {
                //血脂
                [HMViewControllerManager createViewControllerWithControllerName:@"BloodFatDetectResultViewController" ControllerObject:record];
                return;
            }
            
            if ([kpi isEqualToString:@"OXY"])
            {
                //血氧
                [HMViewControllerManager createViewControllerWithControllerName:@"BloodOxygenResultContentViewController" ControllerObject:record];
                return;
            }
            
            if ([kpi isEqualToString:@"HX"])
            {
                //呼吸
                [HMViewControllerManager createViewControllerWithControllerName:@"BreathingDetectResultViewController" ControllerObject:record];
                return;
            }
            
        }
        
        if ([contentType isEqualToString:@"healthySubmit"]
            ||[contentType isEqualToString:@"healthyStop"]
            ||[contentType isEqualToString:@"healthyExecute"]
            ||[contentType isEqualToString:@"healthPlan"]
            ||[contentType isEqualToString:@"healthyAdjust"]
            ||[contentType isEqualToString:@"healthyDraft"])
            
        {
            //跳转健康计划详情
            MessageBaseModelHealthPlanContent* modelContent = [MessageBaseModelHealthPlanContent mj_objectWithKeyValues:dicContent];
            HealthPlanMessionInfo* healthPlan = [HealthPlanMessionInfo mj_objectWithKeyValues:dicContent];
            
            NSInteger userIdInt = healthPlan.userId;
            HealthPlanSummaryViewController* detectViewController = [[HealthPlanSummaryViewController alloc] initWithUserId:userIdInt];
            [self.navigationController pushViewController:detectViewController animated:YES];
            
            return;
        }
        
        if ([contentType isEqualToString:@"surveyFilled"] || [contentType isEqualToString:@"surveyReply"] ||
            [contentType isEqualToString:@"surveyPush"] || [contentType isEqualToString:@"survey"])
            
        {
            //用户已填写随访
            [self at_patientDoctorChatInquirySendWithDict:dicContent];
            return;
        }
        
        if ([contentType isEqualToString:@"recipePage"] || [contentType isEqualToString:@"stopRecipe"])
        {
            //处方
            MessageBaseModelRecipePageContent* modelContent = [MessageBaseModelRecipePageContent mj_objectWithKeyValues:dicContent];
            //跳转到处方详情界面
            [HMViewControllerManager createViewControllerWithControllerName:@"RecipeDetailViewController" ControllerObject:modelContent.userRecipeId];
            return;
            
        }
        if ([contentType isEqualToString:@"applyAppoint"]||
            [contentType isEqualToString:@"appointAgree"]||
            [contentType isEqualToString:@"appointRefuse"]||
            [contentType isEqualToString:@"appointChange"])

        {
            //处理约诊申请
            AppointmentInfo* appoint = [AppointmentInfo mj_objectWithKeyValues:dicContent];
            [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentDetailViewController" ControllerObject:appoint];
            return;
        }
        if ([contentType isEqualToString:@"sendCompleateDocMsg"])
        {
            //跳转到住院计划详情
            MessageBaseModelSendCompleateDocMsg* modelContent = [MessageBaseModelSendCompleateDocMsg mj_objectWithKeyValues:dicContent];
            HealthHistoryItem* history = [[HealthHistoryItem alloc]init];
            [history setDocuRegID:modelContent.docuRegId];
            [history setDocuType:modelContent.docuType];
            [history setStorageID:modelContent.storageId];
            [history setVisitOrgTitle:modelContent.visitOrgTitle];
            
            [HMViewControllerManager createViewControllerWithControllerName:@"HealthHistoryDetailViewController" ControllerObject:history];
            return;
        }
        if ([contentType isEqualToString:@"assessmentReport"])
        {
           //更新评估报告 建档
            MessageBaseModelAssessmentReport* assessmentReport = [MessageBaseModelAssessmentReport mj_objectWithKeyValues:dicContent];
            
            CreateDocumetnMessionInfo *messionInfo = [[CreateDocumetnMessionInfo alloc] init];
            messionInfo.assessmentReportId = assessmentReport.assessmentReportId;
            [HMViewControllerManager createViewControllerWithControllerName:@"CreateDocumentAssessmentDetailViewController" ControllerObject:messionInfo];
            
            return;
        }
    
        if ([contentType isEqualToString:@"assessFilled"]||
            [contentType isEqualToString:@"assessPush"])
        {
            MessageBaseAssessmentModel* assessmentModel = [MessageBaseAssessmentModel mj_objectWithKeyValues:dicContent];
            if (assessmentModel.status == 0)
            {
                [self at_postError:@"评估尚未填写"];
                return;
            }
            //评估消息
            if (!assessmentModel.assessCode || 0 == assessmentModel.assessCode)
            {
                //异常消息，不处理
                return;
            }

            
            
            if ([assessmentModel.assessCode isEqualToString:@"JDXPG"])
            {
                //阶段评估
                
                BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAssessmentMode Status:assessmentModel.status OperateCode:kPrivilegeViewOperate];
                if (!viewPrivilege)
                {
                    [self showAlertMessage:@"对不起，你没有该权限。"];
                    return;
                }
            }
            if ([assessmentModel.assessCode isEqualToString:@"DCPG"])
            {
                //阶段评估
                
                BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeSingleAssessmentMode Status:assessmentModel.status OperateCode:kPrivilegeViewOperate];
                if (!viewPrivilege)
                {
                    [self showAlertMessage:@"对不起，你没有该权限。"];
                    return;
                }
            }
            
            [HMViewControllerManager createViewControllerWithControllerName:@"IMEvaluationDetailViewController" ControllerObject:assessmentModel];

            return;
        }
        if ([contentType isEqualToString:@"roundsPush"])
        {
            //查房发送
            MessageBaseModelRoundsPush* modelContent = [MessageBaseModelRoundsPush mj_objectWithKeyValues:dicContent];
            if (!modelContent.status)
            {
                return;
            }
            BOOL editPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeRoundsMode Status:0/*modelContent.status.integerValue*/ OperateCode:kPrivilegeEditOperate];
            if (!editPrivilege)
            {
                return;
            }
            
            
            RoundsMessionModel* messionModel = [[RoundsMessionModel alloc]init];
            messionModel.surveyId = modelContent.recordId;
            if (modelContent.userId)
            {
                messionModel.userId = modelContent.userId.integerValue;
            }
            RoundsDetailViewController *VC = [[RoundsDetailViewController alloc] initWithModel:messionModel isFilled:NO];
            [self.navigationController pushViewController:VC animated:YES];
            return;
        }
        
        if ([contentType isEqualToString:@"roundsFilled"])
        {
            //查房已填写
            MessageBaseModelRoundsPush* modelContent = [MessageBaseModelRoundsPush mj_objectWithKeyValues:dicContent];
            RoundsMessionModel* messionModel = [[RoundsMessionModel alloc]init];
            messionModel.surveyId = modelContent.recordId;
            if (modelContent.userId)
            {
                messionModel.userId = modelContent.userId.integerValue;
            }
            
            RoundsDetailViewController *VC = [[RoundsDetailViewController alloc] initWithModel:messionModel isFilled:YES];
            [self.navigationController pushViewController:VC animated:YES];
            
            return;
        }
        
        if ([contentType isEqualToString:@"roundsAsk"])
        {
            //查房询问

            return;
        }
        if ([contentType isEqualToString:@"inquirySend"])
        {
            //问诊表发送
            [self at_patientDoctorChatInquirySendWithDict:dicContent];
            return;
        }
    }

}

#pragma mark - MWPhotoBrowser

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.arrayThumbs.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.arrayPhotos.count)
        return [self.arrayPhotos objectAtIndex:index];
    return nil;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    if (index < self.arrayThumbs.count)
        return [self.arrayThumbs objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
    self.saveIndex = index;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 保存
        // 保存图片
        /**
         *  将图片保存到iPhone本地相册
         *  UIImage *image            图片对象
         *  id completionTarget       响应方法对象
         *  SEL completionSelector    方法
         *  void *contextInfo
         */
        MWPhoto *photo = strongSelf.arrayPhotos[strongSelf.saveIndex];
        if ([[photo valueForKey:@"photoURL"] isKindOfClass:[NSURL class]]) {
            UIImage *image = image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[[photo valueForKey:@"photoURL"] absoluteString]];
            
            UIImageWriteToSavedPhotosAlbum(image, strongSelf, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        else {
            [strongSelf showAlertMessage:@"保存失败"];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    [self.presentedViewController presentViewController:alert animated:YES completion:nil];
}

// 保存图片
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    // Handle the end of the image write process
    if (!error)
    {
        [self showAlertMessage:@"保存成功"];
    }
    else
    {
        [self showAlertMessage:[error localizedDescription]];
    }
}

@end
