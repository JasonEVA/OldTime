//
//  IMChatMessageTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "IMChatMessageTableViewController.h"
#import "IMMessageTableViewCell.h"
#import "IMTextMessageTableCell.h"
#import "PicturePerviewViewController.h"
#import "IMMessageHelper.h"
#import "ATAudioSessionPlayUtility.h"
#import "IMVoiceMessageTableCell.h"
#import "AudioPlayHelper.h"
#import "IMVoiceRecordViewController.h"

#import "IMDetectResultAlertTableCell.h"
#import "IMRecipePageTableViewCell.h"
#import "IMServiceCommentsMessageTableViewCell.h"
#import "PersonCommentViewController.h"
#import <MWPhotoBrowser.h>

#import "AppointmentInfo.h"
#import "HealthPlanInfo.h"
#import "IMAlertDealedMessageTableViewCell.h"
#import "IMPersonEventMessageTableViewCell.h"
#import "IMCompleateDocMessageTableViewCell.h"
#import "HealthHistoryItem.h"
#import "MessageBaseModel+CellSize.h"

#define WithoutServiceAlertTag      0x1211


@interface IMChatMessageTableViewController ()
<MessageManagerDelegate,
IMMessageTableViewCellDelegate,MWPhotoBrowserDelegate>
{
    NSString* targetId;
    
    NSMutableArray* messageList;
    
    ContactDetailModel* conversationDetail;
    
    IMVoiceMessageTableCell* tempVoiceCell;
    
    IMVoiceRecordViewController* vcVoiceRecord;

    long long currentNeedPlayVoiceMsgId;
}
@end

@interface IMChatMessageTableViewController()
// 图片浏览
@property (nonatomic, strong)  MWPhotoBrowser  *photoBrowser; // 图片浏览器
@property (nonatomic, strong)  NSMutableArray  *arrayPhotos; // 大图
@property (nonatomic, strong)  NSMutableArray  *arrayThumbs; // 小图
@property (nonatomic)  NSInteger saveIndex; // 要保存的图片index
@property (nonatomic, strong)  UserProfileModel  *targetProfile; // <##>
@end
@implementation IMChatMessageTableViewController

- (id) initWithTargetId:(NSString*) tid
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        targetId = tid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    // 请求群详情
    [self requestTargetDetailProfile];
    
    [self reloadConversation];
    
    // 注册异地登录的监听
}


- (void)getOfflineMsg
{
    [[MessageManager share] getMessageList];
}

- (void) reloadConversation
{
    [[MessageManager share] querySessionDataWithUid:targetId completion:^(ContactDetailModel * detailModel) {
        conversationDetail = detailModel;
        [[MessageManager share] queryBatchMessageWithUid:targetId MessageCount:20 completion:^(NSArray<MessageBaseModel *> *messages) {
            // 刷新或显示UI
            NSLog(@"queryBatchMessageWithUid %ld", messages.count);
            
            messageList = [NSMutableArray arrayWithArray:messages];
            
            [self.tableView reloadData];
            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreHistoryMessage)];
            MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
            refHeader.lastUpdatedTimeLabel.hidden = YES;
            
            if (0 < messageList.count) {
                MessageBaseModel* model = messageList.firstObject;
                if (model._msgId == conversationDetail._lastMsgId)
                {
                    self.tableView.mj_header = nil;
                }
            }
            //滑动到底部
            [self scrollToBottom];
            [self setReadMessages];
            [self loadHistoryMessage:-1];
            
        }];

    }];
}

// 获取群详情
- (void)requestTargetDetailProfile {
    UserProfileModel *model = [[MessageManager share] queryContactProfileWithUid:targetId];
    if (!model) {
        [[MessageManager share] getUserInfoWithUid:targetId];
    }
    else {
        _targetProfile = model;
    }
}

- (MessageBaseModel *)firstObejctWithoutDate {
    MessageBaseModel *firstMessage = [messageList firstObject];
    
    if (firstMessage._type == msg_other_timeStamp) {
        if ([messageList count] > 1) {
            // 获取到非时间类型
            firstMessage = [messageList objectAtIndex:1];
        } else {
            firstMessage = nil;
        }
    }
    
    return firstMessage;
}

/// 消息设置为已读
- (void)sendReadMessageRequestWith:(NSArray *)messages {
    [[MessageManager share] sendReadedRequestWithUid:targetId messages:messages];
}

- (void)setReadMessages
{
//    [[MessageManager share] sendReadedRequestWithUid:targetId messages:@[]];
    MessageBaseModel *firstMessage = [self firstObejctWithoutDate];
    
    if (!firstMessage) {
        [self sendReadMessageRequestWith:@[]];
        return;
    }
    
    [[MessageManager share] getAllUnReadedMessageListWithUid:targetId msgId:firstMessage._msgId completion:^(NSArray *unreadMessages) {
        [self sendReadMessageRequestWith:unreadMessages];
    }];
}


- (void) loadMoreHistoryMessage
{
    [self.tableView.mj_header beginRefreshing];
    
    if (!messageList) {
        messageList = [NSMutableArray array];
    }
    
    [[MessageManager share] queryBatchMessageWithUid:targetId MessageCount:messageList.count + 20 completion:^(NSArray<MessageBaseModel *> *messages)
    {
        long long timeStamp = -1;
        if (messages)
        {
            BOOL needLoadHistory = messages.count < (messageList.count + 20);
            for (MessageBaseModel* model in messages)
            {
                [self messageModelUpdate:model];
            }
            
            if (needLoadHistory)
            {
                if (messageList && 0 < messageList.count)
                {
                    MessageBaseModel* model = messageList.firstObject;
                    timeStamp = model._msgId;
                }
                
                [self loadHistoryMessage:timeStamp];
            }
            else
            {
                [self.tableView.mj_header endRefreshing];
            }
            [self.tableView reloadData];
            MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
            refHeader.lastUpdatedTimeLabel.hidden = YES;
            if (0 < messageList.count) {
                MessageBaseModel* model = messageList.firstObject;
                if (model._msgId == conversationDetail._lastMsgId)
                {
                    self.tableView.mj_header = nil;
                }
            }

        }
    }];
    
    
    
}

- (void) loadHistoryMessage:(long long) timeStamp
{
    [[MessageManager share] getHistoryMessageWithUid:targetId messageCount:20 endTimestamp:timeStamp completion:^(NSArray *messages, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        if (!success )
        {
            return ;
        }
        if (!messages)
        {
            return;
        }
        NSLog(@"getHistoryMessageWithUid %ld", messages.count);
        if (!messageList)
        {
            messageList = [NSMutableArray arrayWithArray:messages];
        }
        else
        {
            for (MessageBaseModel* model in messages)
            {
                [self messageModelUpdate:model];
            }
        }
        
        [self.tableView reloadData];
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreHistoryMessage)];
        MJRefreshNormalHeader* refHeader = (MJRefreshNormalHeader*)self.tableView.mj_header;
        refHeader.lastUpdatedTimeLabel.hidden = YES;
        if (0 < messageList.count) {
            MessageBaseModel* model = messageList.firstObject;
            if (model._msgId == conversationDetail._lastMsgId)
            {
                self.tableView.mj_header = nil;
            }
        }
        //滑动到底部
        if (-1 == timeStamp)
        {
            [self scrollToBottom];
        }
    }];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scrollToBottom];
    /*
    
     */
    [[IMMessageHelper defaultHelper] addMessageDelegate:self];
}

- (void) scrollToBottom
{
    
    if (messageList && 0 < messageList.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageList.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    
    //return 1;
    
    if (messageList)
    {
        return messageList.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageBaseModel* model = messageList[indexPath.row];
    
    return [model cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMMessageTableViewCell *cell = nil;
    MessageBaseModel* model = messageList[indexPath.row];
    
    // 群里发送者信息从群信息里拿
    UserProfileModel *senderProfile;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName == %@",[model getUserName]];
    NSArray *filtedArray = [self.targetProfile.memberList filteredArrayUsingPredicate:predicate];
    if (filtedArray.count > 0) {
        senderProfile = filtedArray.firstObject;
    }

    NSString* classname = [self cellClassWithMessageModel:model];
    if (classname)
    {
        //cell = [tableView dequeueReusableCellWithIdentifier:classname];
        if (!cell)
        {
            cell = [[NSClassFromString(classname) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:classname];
        }
    }
   
    
    // Configure the cell...
    if (!cell)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"IMMessageTableViewCell"];
        if (!cell)
        {
            cell = [[IMMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IMMessageTableViewCell"];
        }
    }
    
    [cell setDelegate:self];
    [cell setMessage:model];
    [cell configSenderInfo:senderProfile];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (NSString*) cellClassWithMessageModel:(MessageBaseModel*) model
{
    NSString* classname = @"IMMessageTableViewCell"; 
    
    switch (model._type)
    {
        case msg_personal_alert:
        {
            classname = @"IMAlertMessageTableViewCell";
        }
            break;
        case msg_personal_text:
        {
            //文本消息
            classname = @"IMTextMessageTableCell";
        }
            break;
        case msg_personal_image:
        {
            //图片消息
            classname = @"IMImageMessageTableCell";
        }
            break;
        case msg_personal_voice:
        {
            //语音消息
            classname = @"IMVoiceMessageTableCell";
        }
            break;
        case msg_personal_event:
        case msg_usefulMsgMin:
        {
            //自定义消息
            NSString* content = model._content;
            NSLog(@"自定义消息 %@", content);
            if (!content || 0 == content.length) {
                break;
            }
            NSDictionary* dicContent = [NSDictionary JSONValue:content];
            if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
            {
                break;
            }
            MessageBaseModelContent* modelContent = [MessageBaseModelContent mj_objectWithKeyValues:dicContent];
            NSString* contentType = modelContent.type;
            NSLog(@"contentType = %@", contentType);
            if (!contentType || 0 == contentType.length)
            {
                classname = @"IMPersonEventMessageTableViewCell";
                break;
                
            }
            
            //缺省自定义消息
            
            
            if ([contentType isEqualToString:@"testResultPage"] || [contentType isEqualToString:@"healthTest"])
            {
                //监测预警消息
                classname = @"IMDetectResultAlertTableCell";
                break;
            }
            
            if ([contentType isEqualToString:@"recipePage"] || [contentType isEqualToString:@"stopRecipe"])
            {
                //开处方消息
                classname = @"IMRecipePageTableViewCell";
                break;
            }
            
            if ([contentType isEqualToString:@"userServiceOrder"] ||
                [contentType isEqualToString:@"serviceComments"] ||
                [contentType isEqualToString:@"serviceOverTime"])
            {
                //服务评价消息
                classname = @"IMServiceCommentsMessageTableViewCell";
                break;
            }
            
            if ([contentType isEqualToString:@"surveyPush"])
            {
                //发送随访
                classname = @"IMSurveyPushMessageTableViewCell";
                break;
            }
            if ([contentType isEqualToString:@"survey"])
            {
                //发送随访
                classname = @"IMSurveyPushMessageTableViewCell";
                break;
            }
            if ([contentType isEqualToString:@"surveyFilled"])
            {
                //发送随访
                classname = @"IMSurveyPushMessageTableViewCell";
                break;
            }
            if ([contentType isEqualToString:@"surveyReply"])
            {
                //发送随访
                classname = @"IMSurveyPushMessageTableViewCell";
                break;
            }
            if ([contentType isEqualToString:@"healthyReportDetPage"])
            {
                //健康报告
                classname = @"IMHealthReportDetailTableViewCell";
                break;
            }
            
            if ([contentType isEqualToString:@"applyAppoint"])
            {
                //发起申请
                classname = @"IMAppointmentMessageTableViewCell";
                break;
            }
            if ([contentType isEqualToString:@"appointAgree"])
            {
                //同意申请
                classname = @"IMAppointmentMessageTableViewCell";
                break;
            }
            if ([contentType isEqualToString:@"appointRefuse"])
            {
                //拒绝申请
                classname = @"IMAppointmentMessageTableViewCell";
                break;
            }
            if ([contentType isEqualToString:@"appointCancel"])
            {
                //约诊取消
                classname = @"IMAppointmentMessageTableViewCell";
                break;
            }
            if ([contentType isEqualToString:@"appointChange"])
            {
                //预约变更
                classname = @"IMAppointmentMessageTableViewCell";
                break;
            }
            
            if ([contentType isEqualToString:@"healthySubmit"] ||
                [contentType isEqualToString:@"healthyAdjust"] ||
                [contentType isEqualToString:@"healthPlan"])
            {
                classname = @"IMHealthPlanMesssageTableViewCell";
                break;
            }
            
            if ([contentType isEqualToString:@"healthyExecute"])
            {
                classname = @"IMHealthPlanMesssageTableViewCell";
                break;
            }
            
            if ([contentType isEqualToString:@"healthyStop"]||
                [contentType isEqualToString:@"healthPlan"]||
                [contentType isEqualToString:@"healthyDraft"])
            {
                classname = @"IMHealthPlanMesssageTableViewCell";
                break;
            }
            
            if ([contentType isEqualToString:@"adjustWarning"]||
                [contentType isEqualToString:@"continueTest"]||
                [contentType isEqualToString:@"tellVisitDoc"])
            {
                classname = @"IMAlertDealedMessageTableViewCell";
                break;
            }
            
            if ([contentType isEqualToString:@"sendCompleateDocMsg"])
            {
                classname = @"IMCompleateDocMessageTableViewCell";
                break;
            }
        }
            break;
        default:
            break;
    }
    
    return classname;
}

- (void) imMessageCellClicked:(IMMessageTableViewCell*) clickedcell
{
    if ([clickedcell isKindOfClass:[IMMessageTableViewCell class]])
    {
        NSIndexPath* indexPath = [self.tableView indexPathForCell:clickedcell];
        //CGRect rtCell = [self.tableView rectForRowAtIndexPath:indexPath];
        IMBubbleMessageTableViewCell* imgCell = (IMBubbleMessageTableViewCell*)clickedcell;
        CGRect rtBubble = [imgCell convertRect:[imgCell bubbleFrame]  toView:self.tableView];
        rtBubble.origin.y -= self.tableView.contentOffset.y;
        rtBubble.origin.y += self.navigationController.navigationBar.height + self.tableView.superview.top;
        
        MessageBaseModel* model = messageList[indexPath.row];
        switch (model._type)
        {
            case msg_personal_image:
            {
                
                // 封装图片数据
                MWPhoto *photo;
                NSInteger currentSelectIndex = 0;
                [self.arrayPhotos removeAllObjects];
                [self.arrayThumbs removeAllObjects];
                NSArray *arrImages = [[MessageManager share] queryBatchImageMessageWithUid:targetId];
                for (NSInteger i = 0; i < arrImages.count; i ++)
                {
                    MessageBaseModel *imageModel = arrImages[i];
                    
                    if (imageModel._type == msg_personal_image)
                    {
                        if (imageModel._nativeThumbnailUrl.length == 0)
                        {
                            // 网络下载图片
                            photo = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",im_IP_http,imageModel.attachModel.fileUrl]]];
                            [self.arrayPhotos addObject:photo];
                            
                            photo = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",im_IP_http,imageModel.attachModel.thumbnail]]];
                            [self.arrayThumbs addObject:photo];
                            
                        }
                        else
                        {
                            // 本地图片
                            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[MsgFilePathMgr share] getAllPathWithRelativePath:imageModel._nativeOriginalUrl]]];
                            [self.arrayPhotos addObject:photo];
                            
                            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[MsgFilePathMgr share] getAllPathWithRelativePath:imageModel._nativeThumbnailUrl]]];
                            [self.arrayThumbs addObject:photo];
                            
                        }
                    }
                    if (model._msgId == imageModel._msgId)
                    {
                        currentSelectIndex = i;
                    }
                    
                }
                
                // Modal
                UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
                nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:nc animated:YES completion:nil];
                
                [self.photoBrowser reloadData];
                [self.photoBrowser setCurrentPhotoIndex:currentSelectIndex];
                
//                //图片消息，跳转到图片查看 PicturePerviewViewController
//                
//                NSString* allPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeOriginalUrl];
//                 NSString* thumbPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeThumbnailUrl];
//                UIImage* thumbImage = [UIImage imageWithContentsOfFile:thumbPath];
//                if (!thumbImage) {
//                    thumbPath = [NSString stringWithFormat:@"%@%@",im_IP_http,model.attachModel.thumbnail];
//                    allPath = [NSString stringWithFormat:@"%@%@",im_IP_http,model.attachModel.thumbnail];
//                    //return;
//                }
//                PicturePerviewViewController* vcPerview = [[PicturePerviewViewController alloc]initWithThumbPath:thumbPath ImagePath:allPath];
//                
//                [vcPerview setThumbframe:rtBubble];
//                UIViewController* vcTop = [HMViewControllerManager topMostController];
//                [vcTop addChildViewController:vcPerview];
//                [vcTop.view addSubview:vcPerview.view];
//                [vcPerview.view mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.and.right.equalTo(vcTop.view);
//                    make.bottom.and.top.equalTo(vcTop.view);
//                }];
                
            }
                break;
                
            case msg_personal_voice:
            {
                if (![model isFileDownloaded])
                {
                    currentNeedPlayVoiceMsgId = model._msgId;
                    // 下载后再播放
                    [[MessageManager share] downloadAudioSourceWithModel:model];
                    break;
                }
                //语音消息，只有当前语音做动画
                if ([tempVoiceCell.ivVoice isAnimating])
                {
                    [tempVoiceCell.ivVoice stopAnimating];
                }
                IMVoiceMessageTableCell *voiceCell = (IMVoiceMessageTableCell*)clickedcell;
                [voiceCell.ivVoice startAnimating];
                
                tempVoiceCell = voiceCell;

                //播放语音
                NSString* allPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeOriginalUrl];

                NSData *wavData = [[NSData alloc] initWithContentsOfFile:allPath];
                
                //测试的
                //NSData *wavData = [[NSData alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Message/226@SuperGroup/1465282145782.wav",allPath]];
                
                [[AudioPlayHelper shareInstance]playAudioData:wavData callBack:^{
                    [voiceCell.ivVoice stopAnimating];
                }];
            }
                break;
            case msg_personal_event:
            case msg_usefulMsgMin:
            {
                //自定义消息
                NSString* content = model._content;
                NSLog(@"自定义消息 %@", content);
                if (!content || 0 == content.length) {
                    break;
                }
                NSDictionary* dicContent = [NSDictionary JSONValue:content];
                if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
                {
                    break;
                }
                MessageBaseModelContent* modelContent = [MessageBaseModelContent mj_objectWithKeyValues:dicContent];
                NSString* contentType = modelContent.type;
                NSLog(@"contentType = %@", contentType);
                if (!contentType || 0 == contentType.length)
                {
                    break;
                    
                }
                if ([contentType isEqualToString:@"userServiceOrder"] ||
                    [contentType isEqualToString:@"serviceComments"] ||
                    [contentType isEqualToString:@"serviceOverTime"])
                {
                    //点击进入医生评价页面
                    NSString *serviceId = [dicContent valueForKey:@"userServiceId"];
                    PersonCommentViewController *VC = [[PersonCommentViewController alloc]initWithServiceID:serviceId];
                    [self.navigationController pushViewController:VC animated:YES];
                }
            
                if ([contentType isEqualToString:@"recipePage"] || [contentType isEqualToString:@"stopRecipe"])
                {
                    //处方消息
                    MessageBaseModelRecipePageContent* modelContent = [MessageBaseModelRecipePageContent mj_objectWithKeyValues:dicContent];
                    //跳转到处方详情界面
                    [HMViewControllerManager createViewControllerWithControllerName:@"RecipeDetailViewController" ControllerObject:modelContent.userRecipeId];
                    break;
                }

                if ([contentType isEqualToString:@"surveyPush"] || [contentType isEqualToString:@"survey"])
                {
                    //随访待填写
                    MessageBaseModelSurveyContent* modelContent = [MessageBaseModelSurveyContent mj_objectWithKeyValues:dicContent];
                    //跳转到随访填写界面
                    
                    [HMViewControllerManager createViewControllerWithControllerName:@"SurveyUnFilledDetailViewController" ControllerObject:[NSString stringWithFormat:@"%ld", modelContent.recordId]];
                    break;
                }
                
                if ([contentType isEqualToString:@"surveyFilled"] || [contentType isEqualToString:@"surveyReply"])
                {
                    //随访待填写
                    MessageBaseModelSurveyContent* modelContent = [MessageBaseModelSurveyContent mj_objectWithKeyValues:dicContent];
                    //跳转到随访填写界面
                    
                    [HMViewControllerManager createViewControllerWithControllerName:@"SurveyFilledDetailViewController" ControllerObject:[NSString stringWithFormat:@"%ld", modelContent.recordId]];
                    break;
                }
                if ([contentType isEqualToString:@"healthyReportDetPage"])
                {
                    //健康报告
                    MessageBaseModelHealthReportContent* modelContent = [MessageBaseModelHealthReportContent mj_objectWithKeyValues:dicContent];
                    [HMViewControllerManager createViewControllerWithControllerName:@"HealthReportDetailViewController" ControllerObject:modelContent.healthyReportId];
                    break;
                }
                
                if ([contentType isEqualToString:@"applyAppoint"])
                {
                    //发起申请
                    MessageBaseModelAppointmentContent* modelContent = [MessageBaseModelAppointmentContent mj_objectWithKeyValues:dicContent];
                    AppointmentInfo* appointment = [[AppointmentInfo alloc]init];
                    [appointment setAppointId:modelContent.appointId];
                    [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentDetailViewController" ControllerObject:appointment];
                    break;
                    
                }
                if ([contentType isEqualToString:@"appointAgree"])
                {
                    //同意申请
                    MessageBaseModelAppointmentContent* modelContent = [MessageBaseModelAppointmentContent mj_objectWithKeyValues:dicContent];
                    AppointmentInfo* appointment = [[AppointmentInfo alloc]init];
                    [appointment setAppointId:modelContent.appointId];
                    [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentDetailViewController" ControllerObject:appointment];
                    break;
                }
                if ([contentType isEqualToString:@"appointRefuse"])
                {
                    //拒绝申请
                    MessageBaseModelAppointmentContent* modelContent = [MessageBaseModelAppointmentContent mj_objectWithKeyValues:dicContent];
                    AppointmentInfo* appointment = [[AppointmentInfo alloc]init];
                    [appointment setAppointId:modelContent.appointId];
                    [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentDetailViewController" ControllerObject:appointment];
                    break;
                }
                if ([contentType isEqualToString:@"appointCancel"])
                {
                    //约诊取消
                    MessageBaseModelAppointmentContent* modelContent = [MessageBaseModelAppointmentContent mj_objectWithKeyValues:dicContent];
                    AppointmentInfo* appointment = [[AppointmentInfo alloc]init];
                    [appointment setAppointId:modelContent.appointId];
                    [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentDetailViewController" ControllerObject:appointment];
                    break;
                }
                if ([contentType isEqualToString:@"appointChange"])
                {
                    //预约变更
                    MessageBaseModelAppointmentContent* modelContent = [MessageBaseModelAppointmentContent mj_objectWithKeyValues:dicContent];
                    AppointmentInfo* appointment = [[AppointmentInfo alloc]init];
                    [appointment setAppointId:modelContent.appointId];
                    [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentDetailViewController" ControllerObject:appointment];
                    break;
                }

                if ([contentType isEqualToString:@"healthySubmit"] ||
                    [contentType isEqualToString:@"healthyAdjust"] ||
                    [contentType isEqualToString:@"healthPlan"])
                {
                    HealthPlanInfo* healthPlan = [HealthPlanInfo mj_objectWithKeyValues:dicContent];
                    [HMViewControllerManager createViewControllerWithControllerName:@"HealthPlanDetailViewController" ControllerObject:healthPlan];
                    break;
                }
                
                if ([contentType isEqualToString:@"healthyExecute"])
                {
                    HealthPlanInfo* healthPlan = [HealthPlanInfo mj_objectWithKeyValues:dicContent];
                    if (!healthPlan.healthyPlanId)
                    {
                        break;
                    }
                    [HMViewControllerManager createViewControllerWithControllerName:@"HealthPlanDetailViewController" ControllerObject:healthPlan];

                    break;
                }
                
                if ([contentType isEqualToString:@"healthyStop"]||
                    [contentType isEqualToString:@"healthPlan"]||
                    [contentType isEqualToString:@"healthyDraft"])
                {
                    HealthPlanInfo* healthPlan = [HealthPlanInfo mj_objectWithKeyValues:dicContent];
                    if (!healthPlan.healthyPlanId)
                    {
                        break;
                    }
                    [HMViewControllerManager createViewControllerWithControllerName:@"HealthPlanDetailViewController" ControllerObject:healthPlan];

                    break;
                }
                
                if ([contentType isEqualToString:@"tellVisitDoc"])
                {
                    //跳转到约诊界面
                    if (![UserServicePrivilegeHelper userHasPrivilege:ServicePrivile_Appoint])
                    {
                        //没有约诊权限
                        [self showAlertWithoutServiceMessage];
                        return;
                    }
                    
                    //
                    [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentStartViewController" ControllerObject:nil];
                    break;
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
                    break;
                }
                
                
            }
                break;
            default:
                break;
        }
    }
}



- (void)MessageManagerDelegateCallBack_needRefreshWithTareget:(NSString *)target
{
    NSLog(@"MessageManagerDelegateCallBack_needRefreshWithTareget ......");
    if (!target)
    {
        return;
    }
    if ([target isEqualToString:targetId] )
    {
        
        [[MessageManager share] queryBatchMessageWithUid:targetId MessageCount:20 completion:^(NSArray<MessageBaseModel *> *messages) {
            // 刷新或显示UI
            NSLog(@"queryBatchMessageWithUid %ld", messages.count);
            
            //messageList = [NSMutableArray arrayWithArray:messages];
            for (MessageBaseModel* model in messages)
            {
                [self messageModelUpdate:model];
            }

            [self.tableView reloadData];
            
            //滑动到底部
            [self scrollToBottom];
        }];

    }
}
- (void)MessageManagerDelegateCallBack_receiveMessage:(MessageBaseModel *)model {
    
}

- (void) messageModelUpdate:(MessageBaseModel*) model
{
    if (!messageList)
    {
        messageList = [NSMutableArray array];
    }
    
    NSInteger insertIndex = 0;
    BOOL isExisted = NO;
    for (insertIndex = 0; insertIndex < messageList.count; ++insertIndex)
    {
        MessageBaseModel* message = messageList[insertIndex];
        if (message._clientMsgId == model._clientMsgId)
        {
            [messageList replaceObjectAtIndex:insertIndex withObject:model];
            
            isExisted = YES;
        }
        if (model._clientMsgId < message._clientMsgId)
        {
            break;
        }
    }
    
    if (!isExisted)
    {
        if (insertIndex < messageList.count - 1)
        {
            [messageList insertObject:model atIndex:insertIndex];
        }
        else
        {
            [messageList addObject:model];
        }
    }
    
    
    
}

- (void)MessageManagerDelegateCallBack_needRefreshWithMessageBaseModel:(MessageBaseModel *)model
{
    //NSLog(@"MessageManagerDelegateCallBack_needRefreshWithMessageBaseModel ......");
    
    [self messageModelUpdate:model];
    [self.tableView reloadData];
    
    [self scrollToBottom];
}

- (void) MessageManagerDelegateCallBack_FinishDownAudioWithMessageBaseModel:(MessageBaseModel *)model
{
    //语音下载完成
    [self messageModelUpdate:model];
    
    //播放语音
    if ([tempVoiceCell.ivVoice isAnimating])
    {
        [tempVoiceCell.ivVoice stopAnimating];
    }
    
    NSInteger voiceIndex = NSNotFound;
    for (NSInteger index = 0; index < messageList.count; ++index)
    {
        MessageBaseModel* msgModel = messageList[index];
        if (msgModel._msgId == model._msgId)
        {
            voiceIndex = index;
            break;
        }
    }
    
    if (NSNotFound == voiceIndex)
    {
        return;
    }
    IMVoiceMessageTableCell *voiceCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:voiceIndex inSection:0]];
    //IMVoiceMessageTableCell *voiceCell = (IMVoiceMessageTableCell*)clickedcell;
    [voiceCell.ivVoice startAnimating];
    
    tempVoiceCell = voiceCell;
    
    //播放语音
    NSString* allPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeOriginalUrl];
    
    NSData *wavData = [[NSData alloc] initWithContentsOfFile:allPath];
    
    //测试的
    //NSData *wavData = [[NSData alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Message/226@SuperGroup/1465282145782.wav",allPath]];
    
    [[AudioPlayHelper shareInstance]playAudioData:wavData callBack:^{
        [voiceCell.ivVoice stopAnimating];
    }];
}

- (void)MessageManagerDelegateCallBack_refreshContactProfileRefresh:(UserProfileModel *)userProfile {
    if (![userProfile.userName isEqualToString:targetId]) {
        return;
    }
    
    UserProfileModel *model = [[MessageManager share] queryContactProfileWithUid:targetId];
    if (!model) {
        return;
    }
    _targetProfile = model;
    [self.tableView reloadData];
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
    // 提示保存图片
    UIAlertView *cantRecordAlert =
    [[UIAlertView alloc] initWithTitle: @"保存图片"
                               message: nil
                              delegate: self
                     cancelButtonTitle:@"不保存"
                     otherButtonTitles:@"保存",nil];
    [cantRecordAlert show];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == WithoutServiceAlertTag)
    {
        if (buttonIndex == 1)
        {
            //跳转到服务分类
            [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceStartViewController" ControllerObject:nil];
        }
        return;
    }
    
    if (buttonIndex == 1)
    {
        // 保存图片
        /**
         *  将图片保存到iPhone本地相册
         *  UIImage *image            图片对象
         *  id completionTarget       响应方法对象
         *  SEL completionSelector    方法
         *  void *contextInfo
         */
        MWPhoto *photo = self.arrayPhotos[self.saveIndex];
        if ([[photo valueForKey:@"photoURL"] isKindOfClass:[NSURL class]]) {
            UIImage *image = image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[[photo valueForKey:@"photoURL"] absoluteString]];
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        else {
            [self showAlertMessage:@"保存失败"];
        }
        
        
    }
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

- (MWPhotoBrowser *)photoBrowser
    {
        if (!_photoBrowser)
        {
            _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            _photoBrowser.displayActionButton = YES; // 分享按钮，默认是
            _photoBrowser.displayNavArrows = NO;     // 左右分页切换，默认否
            _photoBrowser.displaySelectionButtons = NO; // 是否显示选择按钮
            //        _photoBrowser.alwaysShowControls = YES;  // 控制条件控件
            _photoBrowser.zoomPhotosToFill = NO;    // 是否全屏
            _photoBrowser.enableGrid = YES;//是否允许用网格查看所有图片,默认是
            _photoBrowser.startOnGrid = NO;//是否第一张,默认否
            _photoBrowser.enableSwipeToDismiss = YES;
            [_photoBrowser showNextPhotoAnimated:YES];
            [_photoBrowser showPreviousPhotoAnimated:YES];
            [_photoBrowser setCurrentPhotoIndex:1];
        }
        return _photoBrowser;
    }
    
    - (NSMutableArray *)arrayPhotos
    {
        if (!_arrayPhotos)
        {
            _arrayPhotos = [NSMutableArray array];
        }
        return _arrayPhotos;
    }
    
    - (NSMutableArray *)arrayThumbs
    {
        if (!_arrayThumbs)
        {
            _arrayThumbs = [NSMutableArray array];
        }
        return _arrayThumbs;
    }



- (void) showAlertWithoutServiceMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您的服务包中不包含约诊服务。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看套餐", nil];
    [alert setTag:WithoutServiceAlertTag];
    [alert show];
}


@end
