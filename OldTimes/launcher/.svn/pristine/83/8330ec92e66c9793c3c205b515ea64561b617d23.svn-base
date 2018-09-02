//
//  ChatGroupViewController.m
//  launcher
//
//  Created by Lars Chen on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatGroupViewController.h"
#import <Masonry.h>
#import "MyDefine.h"
#import "ChatShowDateTableViewCell.h"
#import "ChatLeftVideoTableViewCell.h"
#import "ChatRightVideoTableViewCell.h"
#import "RMAudioManager.h"
#import "CalculateHeightManager.h"
#import "UnifiedUserInfoManager.h"
#import "Slacker.h"
#import "MWPhotoBrowser.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>
#import "ChatAttachPickView.h"
#import "StreamRecordViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NSDate+MsgManager.h"
#import "NomarlDealWithEventView.h"
#import "ChatGroupManagerViewController.h"
#import "MessageMainViewController.h"
#import <MJExtension/MJExtension.h>
#import "ChatSearchViewController.h"
#import "BaseNavigationController.h"
#import "NewChatRightTextTableViewCell.h"
#import "NewChatRightVoiceTableViewCell.h"
#import "NewChatRightImageTableViewCell.h"
#import "NewChatLeftTextTableViewCell.h"
#import "NewChatLeftImageTableViewCell.h"
#import "NewChatLeftVoiceTableViewCell.h"
#import "NewChatLeftAttachTableViewCell.h"
#import "ChatEventMissionTableViewCell.h"
#import "NewChatRightAttachTableViewCell.h"
#import "MissionDetailViewController.h"
#import "AppTaskModel.h"
#import "ChatAttachMgrViewController.h"
#import "ContactBookDetailViewController.h"
#import "UIColor+Hex.h"
#import "LookAttachmentViewController.h"
#import "MixpanelMananger.h"
#import "AppDelegate.h"
#import "UnifiedFilePathManager.h"
#import "ChatGroupSelectAtUserViewController.h"
#import "UITextView+AtUser.h"
#import "RichTextConstant.h"
#import "LinkLabel.h"
#import <SVWebViewController/SVWebViewController.h>
#import "ApplicationCreateScheduleViewController.h"
#import "UnifiedEggHuntManager.h"
#import "ApplicationCreateMissionViewController.h"
#import "UIViewController+modalPresent.h"
#import "ContactPersonDetailInformationModel.h"
#import "WZPhotoPickerController.h"
#import "NewDetailMissionViewController.h"
#import "TaskListModel.h"
#import "ChatForwardDetailViewController.h"

#import "ChatForwardLeftTableViewCell.h"
#import "ChatForwardRightTableViewCell.h"
#import "ApplicationCreateNewMissionViewController.h"
#import "IMApplicationEnum.h"
#import "NewChatEventMissionRightTableViewCell.h"
#import "NewChatEventMissionLeftTableViewCell.h"
#import "NewMissionGetMissionDetailRequest.h"
#import "IMNickNameManager.h"

static CGFloat const duration_inputView = 0.20;

#define W_MAX_IMAGE (225 + [Slacker getXMarginFrom320ToNowScreen] * 2)     // 照片最大宽度

@interface ChatGroupViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RMAudioManagerDelegate,MessageManagerDelegate,MWPhotoBrowserDelegate,UIAlertViewDelegate,ChatAttachPickViewDelegate,SteamRecordViewControllerDelegate,ChatAttachMgrViewControllerDelegate, ChatBaseTableViewCellDelegate, TTTAttributedLabelDelegate, WZPhotoPickerControllerDelegate, BaseRequestDelegate, ChatGroupManagerViewControllerDelegate>

/** 附件栏模式下移动键盘 */
@property (nonatomic, getter=isAttachModeMoving) BOOL attachModeMoving;
@property (nonatomic, assign) CGPoint pointViewInput;   // viewBG中心点
@property (nonatomic, assign) BOOL isInputViewMoving;   // 底部输入栏移动标记

@property (nonatomic, strong)  NSString  *myAvatarPath; // 我的头像路径

@property (nonatomic, strong)  NSArray *arrayDisplay; // 显示的数据

@property (nonatomic)  long long  lastShowDate; // 撒谎那个词需要显示的时间戳

// 图片浏览
@property (nonatomic, strong)  MWPhotoBrowser  *photoBrowser; // 图片浏览器
@property (nonatomic, strong)  NSMutableArray  *arrayPhotos; // 大图
@property (nonatomic, strong)  NSMutableArray  *arrayThumbs; // 小图
@property (nonatomic)  NSInteger saveIndex; // 要保存的图片index

@property (nonatomic, strong) NomarlDealWithEventView *dropListView;   // 下拉查看聊天记录和设置

@property (nonatomic, assign) BOOL isLongGesture;//是不是长按触发的键盘收起

/***/// 富文本
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *email;
/***/// 富文本
@property (nonatomic,copy) titlechangeBlock myblcok;
@end

@implementation ChatGroupViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initCompnents];
    
    if (!self.isHideInputView)
    {
        UIBarButtonItem *btnSet = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cyclecyclecycle"] style:UIBarButtonItemStylePlain target:self action:@selector(btnDropListClicked)];
        UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"magnifier"] style:UIBarButtonItemStylePlain target:self action:@selector(btnSearchClicked)];
        [self.navigationItem setRightBarButtonItems:@[btnSet,btnSearch]];
    }
    
    self.viewInputHeight = 50;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
	
	[self refreshGroupTitle];
    if (self.keyboardHeight > 0)
    {
        [self.chatInputView popupKeyboard];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

	if (self.chatInputView.isFirstResponder) {
		[self resignKeyBoard];
	}
	
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

#pragma mark - Override Method
- (void)changeLeftNumber {
    [[MessageManager share] queryUnreadMessageCountWithoutUid:self.strUid completion:^(NSInteger unreadCount) {
        [self leftItemNumber:unreadCount];
    }];
}
#pragma mark - interfaceMethod
- (void)changeGroupTitleWithBlcok:(titlechangeBlock)block
{
    self.myblcok = block;
}
#pragma mark - Private Method
// 更新界面
- (void)refreshView
{
    // tell constraints they need updating
    [self.view setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:duration_inputView animations:^{
        [self.view layoutIfNeeded];
    }];
    
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
    if (self.isHideInputView)
    {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        self.chatInputView.hidden = YES;
    }else
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
            make.height.equalTo(@(self.viewInputHeight));
        }];

    }
    
    [super updateViewConstraints];
}

- (void)initCompnents
{
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    [gest setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:gest];
    
    self.dropListView = [[NomarlDealWithEventView alloc] initWithArrayLogos:@[[UIImage imageNamed:@"message_history"], [UIImage imageNamed:@"message_set"]] arrayTitles:@[LOCAL(MESSAGE_LOGGING), LOCAL(CHAT_SET)]];
    self.dropListView.canappear = YES;
}

- (void)resignKeyBoard
{
    [self.chatInputView packupKeyborad];
    
    //    self.viewInputHeight = 50;
    [self.view setNeedsUpdateConstraints];
}

// 键盘将要改变Frame的事件
- (void)keyboardChangeFrame:(NSNotification *)notification
{
    // 判断背景View是否正在移动
    //    if (!_isInputViewMoving)
    //    {
    NSDictionary *keyboardInfo = [notification userInfo];
    
    CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //        CGFloat keyboradAnimationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
//    NSLog(@"%f",self.view.frame.size.height - keyboardFrame.size.height);
    if (keyboardFrame.origin.y > (self.view.frame.size.height - keyboardFrame.size.height + 44 + APP_STATUSBAR_HEIGHT))
    {
        self.keyboardHeight = 0;
        
    }
    else
    {
        self.keyboardHeight = keyboardFrame.size.height;
    }
    
    [self refreshView];
    if (_isLongGesture) {
        return;
    }
    if (self.arrayDisplay.count > 0)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.arrayDisplay.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
    }
}

// 视频截图
- (NSString *)videoScreenShotWithURL:(NSString *)videoUrl
{
    // 缩略图
    //创建URL
    NSURL *url= [[NSURL alloc] initFileURLWithPath:videoUrl];    //根据url创建AVURLAsset
    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:url];
    //根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    // 保证截图方向
    imageGenerator.appliesPreferredTrackTransform = YES;
    /*截图
     * requestTime:缩略图创建时间
     * actualTime:缩略图实际生成的时间
     */
    NSError *error = nil;
    CMTime time = CMTimeMakeWithSeconds(0.0, 1);//CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    CGRect rect =CGRectMake(0, 0, IOS_SCREEN_WIDTH, IOS_SCREEN_HEIGHT - 100);
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(cgImage, rect);
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        [self RecordToDiary:[NSString stringWithFormat:@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription]];
    }
    CMTimeShow(actualTime);
    UIImage *image=[UIImage imageWithCGImage:imageRefRect];//转化为UIImage
    
    // 得到路径
    long long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *strDate = [NSString stringWithFormat:@"%lld",timeStamp];
    NSString *strFileNameThumb = [NSString stringWithFormat:@"%@thumb.jpg",strDate];
    NSString *strPath = [[MsgFilePathMgr share] getMessageDirNamePathWithUid:self.strUid];
    NSString *strThumbPath = [strPath stringByAppendingPathComponent:strFileNameThumb];
    PRINT_STRING(strThumbPath);
    [UIImageJPEGRepresentation(image, 0.3) writeToFile:strThumbPath atomically:YES];
    // 转换成相对路径
    NSString *strRelativeThumb = [[MsgFilePathMgr share] getRelativePathWithAllPath:strThumbPath];
    
    return strRelativeThumb;
}

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
}
/* 标记为重点 */
- (void)markMessage:(NSInteger)index
{
    // 得到消息体
    MessageBaseModel *baseModel = [self.arrayDisplay objectAtIndex:index];
    
    /* 在这里进行标记操作 */
	[[MessageManager share] markMessage:baseModel completion:^(BOOL success) {
		if (success) {
			[[MessageManager share] markMessageImportantWithModel:baseModel important:!baseModel._markImportant];
			baseModel._markImportant ^= 1;
			NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
			if ([cell isKindOfClass:[ChatLeftBaseTableViewCell class]]) {
				[(ChatLeftBaseTableViewCell *)cell setEmphasisIsShow:baseModel._markImportant];
			} else if ([cell isKindOfClass:[ChatRightBaseTableViewCell class]]){
				[(ChatRightBaseTableViewCell *)cell setEmphasisIsShow:baseModel._markImportant];
			}
		}
	}];
	
}

// 打开附件浏览VC
- (void)lookAttachmentWithFileUrl:(NSString *)fileUrl
{
    // 获取附件类型
    Extentsion_kind extentsion = [[UnifiedFilePathManager share] takeFileExtensionWithString:fileUrl];
    if (extentsion == extension_office || extentsion == extension_txt || extentsion == extension_htm)
    {
        // 获得全部路径
        NSString *fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:fileUrl];
        LookAttachmentViewController *lookVC = [[LookAttachmentViewController alloc] initWithFilePath:fullPath];
        [self.navigationController pushViewController:lookVC animated:YES];
    }
    else
    {
        [self postError:LOCAL(UNSUPPORT)];
    }
}

// 群名更新
- (void)refreshGroupTitle
{
	
    // 从数据库取出群信息
    UserProfileModel *model = [[MessageManager share] queryContactProfileWithUid:self.strUid];
    self.module.sessionModel._nickName = model.nickName;
    self.module.sessionModel._headPic = model.avatar;
    if (self.myblcok)
    {
        self.myblcok(model.nickName,model.avatar);
    }
}

- (void)createTaskTitle:(NSString *)title {
    ApplicationCreateNewMissionNavigationController *navigationController = [[ApplicationCreateNewMissionNavigationController alloc] init];
    __weak typeof(self) weakSelf = self;
    [navigationController.rootVC handleDataWithNavigationController:self.navigationController title:title completion:^(MessageAppModel *appModel, ContactPersonDetailInformationModel *model) {
        [weakSelf sendMessageWithContent:appModel peopleModel:model];
    }];

    [self modalPresentViewController:navigationController];
}

#pragma mark - CellClick Events
- (void)ChatSetClicked
{
    ChatGroupManagerViewController *chatGroupManagerVC = [[ChatGroupManagerViewController alloc] init];;
	chatGroupManagerVC.delegate = self;
    chatGroupManagerVC.groupID = self.strUid;
    [self.navigationController pushViewController:chatGroupManagerVC animated:YES];
}

- (void)btnDropListClicked
{
    [self.audioManager cancelRecord];
    if (!self.dropListView.canappear) {
        self.dropListView.canappear = YES;
        [self.dropListView removeFromSuperview];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.dropListView setpassbackBlock:^(NSInteger selectIndex) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (selectIndex == 0)
        {
            // 历史纪录
            MessageMainViewController * messageVC = [[MessageMainViewController alloc] init];
            messageVC.modual = strongSelf.module;
            messageVC.strUid = strongSelf.strUid;
            messageVC.isGroupChat = YES;
            [strongSelf.navigationController pushViewController:messageVC animated:YES];
        }
        else
        {
            [strongSelf ChatSetClicked];
        }
    }];
    [self.view addSubview:self.dropListView];
    [self.dropListView appear];
}

- (void)btnSearchClicked
{
    [self.audioManager cancelRecord];
    ChatSearchViewController *searchVC = [[ChatSearchViewController alloc] init];
    [searchVC setIsquerySearch:NO];
    [searchVC setUidStr:self.strUid];
    searchVC.IsGroup = YES;
    searchVC.isquerySearch = NO;
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:nav animated:YES completion:nil];
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
        }
            break;
            
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
        // 附件
        if ([baseModel isFileDownloaded] == YES)
        {
            [self lookAttachmentWithFileUrl:baseModel._nativeOriginalUrl];
        }
        else
        {
            ChatAttachMgrViewController *chatAttachVC = [[ChatAttachMgrViewController alloc] initWithBaseModel:baseModel ContactModel:nil];
            chatAttachVC.delegate = self;
            [self.navigationController pushViewController:chatAttachVC animated:YES];
        }
    }
    
    else if (baseModel._type == IM_Applicaion_task)
    {
        TaskListModel *model = [TaskListModel new];
        AppTaskModel *taskModel = [AppTaskModel mj_objectWithKeyValues:baseModel.appModel.applicationDetailDictionary];
        model.showId = taskModel.id;
		
		NewMissionGetMissionDetailRequest *request = [[NewMissionGetMissionDetailRequest alloc] initWithDelegate:self];
		[request getDetailTaskWithId:model.showId];
		[self postLoading];
    }
    
    else if (baseModel._type == msg_personal_video)
    {
        NSString *fullPath;
        MPMoviePlayerViewController *playerViewController;
        if (baseModel._markFromReceive)
        {
            fullPath = [NSString stringWithFormat:@"%@%@",im_IP_http,baseModel.attachModel.fileUrl];
            playerViewController =[[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:fullPath]];
        }
        else
        {
            fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:baseModel._nativeOriginalUrl];
            playerViewController =[[MPMoviePlayerViewController alloc]initWithContentURL:[[NSURL alloc] initFileURLWithPath:fullPath]];
        }
        
        [self presentMoviePlayerViewControllerAnimated:playerViewController];
    }
}

// 播放音频管理
- (void)voicePlayOrStopWithVoicePath:(NSString *)voicePath playVoiceMsgId:(long long)voiceMsgId {
    
    self.module.currentNeedPlayVoiceMsgId = wz_default_needVoice_msgId;
    
    if (self.audioManager.isPlaying) {
        if (self.currentPlayingVoiceMsgId == voiceMsgId) {
            // 同一个气泡，停止播放
            [self.audioManager stopPlayAudio];
            self.currentPlayingVoiceMsgId = wz_default_needVoice_msgId;
            [self.tableView reloadData];
            return;
        }
    }
    
    [self.audioManager playAudioWithPath:voicePath];
    self.currentPlayingVoiceMsgId = voiceMsgId;
    [self.tableView reloadData];
}

#pragma mark - override father method
- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    MessageBaseModel *model = self.arrayDisplay[indexPath.row];
    
    NSString *cellHeightId;
    // 消息发送失败用cid存
    if (model._markStatus == status_send_failed || model._markStatus == status_sending || model._markStatus == status_send_waiting)
    {
        cellHeightId = [NSString stringWithFormat:@"%lld",model._clientMsgId];
    }
    else
    {
        cellHeightId =[NSString stringWithFormat:@"%lld",model._msgId];
    }
    height = [[self.cellHeightCache valueForKey:cellHeightId] doubleValue];
    if (height)
    {
        return height;
    }
    
    if (model._type == IM_Applicaion_task)
    {
		height = [CalculateHeightManager fetchAppCardHeightWithBaseModel:model needShowName:YES];
	} else {
		height = [CalculateHeightManager fetchHeightWhileChattingWithBaseModel:model needShowName:YES];
	}
	
//    height = [CalculateHeightManager calculateHeightByModel:model IsShowGroupMemberNick:YES];

    [self.cellHeightCache setObject:@(height) forKey:cellHeightId];
    
    return height;
}

- (UITableViewCell *)tableViewCellAtIndexPath:(NSIndexPath *)indexPath
{
    MessageBaseModel *messageModel = self.arrayDisplay[indexPath.row];
    if (messageModel._type == msg_personal_reSend || messageModel._type == msg_usefulMsgMin) {
        return [self.tableView dequeueReusableCellWithIdentifier:wz_default_tableViewCell_identifier];
    }
    
    if (messageModel._type == IM_Applicaion_task) {
        
        if (![messageModel._toLoginName isEqualToString:self.strUid])
        {
            NewChatEventMissionLeftTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"NewChatEventMissionLeftTableViewCellID"];
            if (!cell)
            {
                cell = [[NewChatEventMissionLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewChatEventMissionLeftTableViewCellID"];
            }
            __weak typeof(self) weakSelf = self;
            [cell setShowDetail:^{
                [weakSelf cellClicked:messageModel];
            }];
            
            [cell setCellData:messageModel];
            return cell;
        }
        else
        {
            NewChatEventMissionRightTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"NewChatEventMissionRightTableViewCellID"];
            if (!cell)
            {
                cell = [[NewChatEventMissionRightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewChatEventMissionRightTableViewCellID"];
            }
            __weak typeof(self) weakSelf = self;
            [cell setShowDetail:^{
                [weakSelf cellClicked:messageModel];
            }];
            
            [cell setCellData:messageModel];
            return cell;
        }
    }
    
    if (![messageModel._toLoginName isEqualToString:self.strUid])
    {
        // 发的人的名字,uid
        NSString *nickName = [messageModel getNickName];
        NSString *userName = [messageModel getUserName];
        
        nickName = [IMNickNameManager showNickNameWithOriginNickName:nickName userId:userName];
        
        switch (messageModel._type)
        {
            case msg_personal_text:
            {
                NewChatLeftTextTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[NewChatLeftTextTableViewCell identifier]];
                cell.messageLabel.delegate = self;
                [cell setDelegate:self];
                [cell setHeadIconWithUid:userName];
                [cell setRealName:nickName hidden:NO];
                [cell setData:messageModel];
                [cell setEmphasisIsShow:messageModel._markImportant];
                return cell;
                
            }
                break;
                
            case msg_personal_voice:
            {
                NewChatLeftVoiceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[NewChatLeftVoiceTableViewCell identifier]];
                [cell setHeadIconWithUid:userName];
                // 计算音频长度
                CGFloat length = messageModel.attachModel.audioLength;
                [cell showVoiceMessageTime:length unreadMark:messageModel._markReaded];
                [cell setRealName:nickName hidden:NO];
                [cell setData:messageModel];
                [cell setEmphasisIsShow:messageModel._markImportant];
                [cell setDelegate:self];
                
                // 判断是否需要播放动画
                if (self.currentPlayingVoiceMsgId == messageModel._msgId) {
                    [cell startPlayVoiceWithTime:length];
                } else {
                    [cell stopPlayVoice];
                }
                
                return cell;
            }
                
                break;
                
            case msg_personal_image:
            {
                NewChatLeftImageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[NewChatLeftImageTableViewCell identifier]];
                [cell setHeadIconWithUid:userName];
                [cell setRealName:nickName hidden:NO];
                [cell setData:messageModel];
                [cell showSendImageMessageBaseModel:messageModel];
                [cell setEmphasisIsShow:messageModel._markImportant];
                [cell setDelegate:self];
                return cell;
                
            }
                
                break;
              
            case msg_personal_file:
            {
                // 生成附件图片
                NewChatLeftAttachTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[NewChatLeftAttachTableViewCell identifier]];
                [cell setHeadIconWithUid:userName];
                [cell setRealName:nickName hidden:NO];
                [cell setData:messageModel];
                [cell setEmphasisIsShow:messageModel._markImportant];
                [cell setAttachmentData:messageModel.attachModel];
                [cell setDelegate:self];
                return cell;
            }
                break;
                
            case msg_personal_mergeMessage:
            {
                ChatForwardLeftTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ChatForwardLeftTableViewCell identifier]];
                [cell setHeadIconWithUid:userName];
                [cell setRealName:nickName hidden:NO];
                [cell setData:messageModel];
                [cell setEmphasisIsShow:messageModel._markImportant];
                [cell setDelegate:self];
                return cell;
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (messageModel._type)
        {
            case msg_personal_text:
            {
                NewChatRightTextTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[NewChatRightTextTableViewCell identifier]];
                cell.messageLabel.delegate = self;
                [cell setDelegate:self];
                [cell setData:messageModel];
                [cell showStatus:messageModel._markStatus];
                [cell setEmphasisIsShow:messageModel._markImportant];
                __weak typeof(self) weakSelf = self;
                [cell setSendAgain:^() {
                    [weakSelf resendMessage:messageModel];
                }];
                return cell;
            }
                break;
                
            case msg_personal_voice:
            {
                NewChatRightVoiceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[NewChatRightVoiceTableViewCell identifier]];
                CGFloat length = 0;
                if (messageModel._nativeOriginalUrl.length == 0)
                {
                    length = messageModel.attachModel.audioLength;
                }
                else
                {
                    // 计算音频长度
                    length = [RMAudioManager calculateAudioDurationWithPath:[[MsgFilePathMgr share] getAllPathWithRelativePath:messageModel._nativeOriginalUrl]];
                }
                
                [cell showVoiceMessageTime:length];
                [cell showStatus:messageModel._markStatus];
                [cell setData:messageModel];
                [cell setEmphasisIsShow:messageModel._markImportant];
                [cell setDelegate:self];
                
                // 判断是否需要播放动画
                if (self.currentPlayingVoiceMsgId == messageModel._msgId) {
                    [cell startPlayVoiceWithTime:length];
                } else {
                    [cell stopPlayVoice];
                }
                __weak typeof(self) weakSelf = self;
                [cell setSendAgain:^() {
                    [weakSelf resendMessage:messageModel];
                }];

                return cell;
            }
                
                break;
                
            case msg_personal_image:
            {
                NewChatRightImageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[NewChatRightImageTableViewCell identifier]];
                [cell setData:messageModel];
                [cell showStatus:messageModel._markStatus progress:[self.uploadImageDictionary objectForKey:messageModel._nativeOriginalUrl]];
                [cell showSendImageMessage:messageModel];
                [cell setEmphasisIsShow:messageModel._markImportant];
                [cell setDelegate:self];

                __weak typeof(self) weakSelf = self;
                [cell setSendAgain:^() {
                    [weakSelf resendMessage:messageModel];
                }];
                
                return cell;
                
            }
                
                break;
                
            case msg_personal_mergeMessage:
            {
                ChatForwardRightTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ChatForwardRightTableViewCell identifier]];
                [cell setData:messageModel];
                [cell showStatus:status_send_success];
                [cell setEmphasisIsShow:messageModel._markImportant];
                [cell setDelegate:self];
                return cell;
            }
                break;
                
            case msg_personal_file:
            {
                // 生成附件图片
                NewChatRightAttachTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[NewChatRightAttachTableViewCell identifier]];
                [cell showStatus:messageModel._markStatus];
                [cell setData:messageModel];
                [cell setEmphasisIsShow:messageModel._markImportant];
                [cell setAttachmentData:messageModel.attachModel];
                [cell setDelegate:self];
                
                __weak typeof(self) weakSelf = self;
                [cell setSendAgain:^() {
                    [weakSelf resendMessage:messageModel];
                }];
                
                return cell;
            }
                break;
                
            default:
                break;
        }
        
    }
    
    // default
    ChatShowDateTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ChatShowDateTableViewCell identifier]];
    [cell showDateAndEvent:messageModel ifEvent:NO];
    return cell;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self resignKeyBoard];
    }
}

#pragma mark - ChatBaseTableViewCell Delegate
- (BOOL)chatBaseTableViewCellIsEdtingMode:(ChatBaseTableViewCell *)cell {
    return [self.tableView isEditing];
}
- (BOOL)chatBaseTableViewCellCanBecomeFirstResponder:(ChatBaseTableViewCell *)cell menuImageView:(MenuImageView *)menuImageView {
    BOOL isFirstResponder = [self.chatInputView isFirstResponder];
    
    ChatInputTextView *textInputView = self.chatInputView._viewCommon._txView;
    textInputView.canPerformNormalMenu = NO;
    textInputView.menuImageView = isFirstResponder ? menuImageView : nil;
    
    return !isFirstResponder;
}
- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToCancelEmphasisAtIndexPath:(NSIndexPath *)indexPath { [self markMessage:indexPath.row];}
- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToEmphasisAtIndexPath:(NSIndexPath *)indexPath { [self markMessage:indexPath.row];}
- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToCopyAtIndexPath:(NSIndexPath *)indexPath { [self copyMessage:indexPath.row];}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToRecallAtIndexPath:(NSIndexPath *)indexPath {
    MessageBaseModel *model = [self.arrayDisplay objectAtIndex:indexPath.row];

    [self postLoading];
    [[MessageManager share] recallMessage:model completion:^(BOOL success) {
        if (!success) {
            [self postError:@""];
            return;
        }
        
        [self hideLoading];
    }];
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToMissionAtIndexPath:(NSIndexPath *)indexPath {
    MessageBaseModel *model = [self.arrayDisplay objectAtIndex:indexPath.row];
    [self createTaskTitle:model._content];
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToScheduleAtIndexPath:(NSIndexPath *)indexPath {
    MessageBaseModel *baseModel = [self.arrayDisplay objectAtIndex:indexPath.row];
    NSString *title = baseModel._content;
    
    ApplicationCreateNavigationController *VC = [[ApplicationCreateNavigationController alloc] init];
    [VC.rootVC handleDataWithNavigationController:self.navigationController title:title completion:nil];
    
    if (IOS_VERSION_8_OR_ABOVE) {
        self.providesPresentationContextTransitionStyle = YES;
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:VC animated:YES completion:nil];
    } else {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:VC animated:YES completion:nil];
        // 这个不知道有没有必要，没试过推多点的VC
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToMoreAtIndexPath:(NSIndexPath *)indexPath {
    [self startEditingWithFirstIndexPath:indexPath];
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell pressHeadAtIndexPath:(NSIndexPath *)indexPath {
    MessageBaseModel *model = [self.arrayDisplay objectAtIndex:indexPath.row];
    ContactBookDetailViewController *detailVC = [[ContactBookDetailViewController alloc] initWithUserShowId:[model getUserName]];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell tappedAtIndexPath:(NSIndexPath *)indexPath {
    MessageBaseModel *baseModel = [self.arrayDisplay objectAtIndex:indexPath.row];
    
    if (baseModel._type == msg_personal_mergeMessage) {
        ChatForwardDetailViewController *VC = [[ChatForwardDetailViewController alloc] initWithForwardMessage:baseModel];
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    
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
    MessageBaseModel *model = [self.arrayDisplay objectAtIndex:indePath.row];
    
    ContactPersonDetailInformationModel *atPerson = [ContactPersonDetailInformationModel new];
    atPerson.show_id = [model getUserName];
    atPerson.u_true_name = [model getNickName];
    
    [self.chatInputView popupKeyboard];
    [self.chatInputView addAtUser:atPerson deleteFrontAt:NO];
    
}

#pragma mark - TTTAttributeLabel Delegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    NSArray *res = [phoneNumber componentsSeparatedByString:LINK_SPLIT];
    if([res count] == 2){
        if([res[0] isEqualToString:PHONE_SPLIT]){
            NSString *phone = [res[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *title = [NSString stringWithFormat:LOCAL(CHAT_CALL_NUMBER), phone];
            self.phoneNumber = phone;
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title
                                                               delegate:self
                                                      cancelButtonTitle:LOCAL(CANCEL)
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:LOCAL(CHAT_CALL), LOCAL(MESSAGE_COPY),nil];
            
            sheet.tag = 10000;
            [sheet showInView:self.view];
        }
        if([res[0] isEqualToString:EMAIL_SPLIT]){
            self.email = res[1];
            NSString *title = [NSString stringWithFormat:LOCAL(CHAT_MAIL_TO),self.email];
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title
                                                               delegate:self
                                                      cancelButtonTitle:LOCAL(CANCEL)
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:LOCAL(CHAT_MAIL_DEFAULT),LOCAL(MESSAGE_COPY), nil];
            
            sheet.tag = 10001;
            [sheet showInView:self.view];
        }
    }
}

#pragma mark - ChatInputViewDelegate
- (void)ChatInputViewDelegateCallBack_sendAttributeText:(NSAttributedString *)attributeText {
    NSString *text = attributeText.string;
    if (![text length]) {
        return;
    }
    
    if (![[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return;
    }
    
    NSMutableArray *atUserList = [NSMutableArray array];
        
    for (NSInteger i = 0; i < text.length; i ++) {
        NSAttributedString *attriText = [attributeText attributedSubstringFromRange:NSMakeRange(i, 1)];
        if (![attriText.string isEqualToString:@"@"]) {
            continue;
        }
        
        // 是@,取出成员内容
        if (!attriText.identifier) {
            [atUserList addObject:@""];
            continue;
        }
        
        [atUserList addObject:attriText.identifier];
    }
    
    [[MessageManager share] sendMessageTo:self.strUid nick:self.strName WithContent:text Type:msg_personal_text atUser:atUserList];
    [MixpanelMananger track:@"IM text"];
}

// 录音按钮的委托回调
- (void)ChatInputViewDelegateCallBack_recordVoiceWithEvents:(UIControlEvents)controlEvents
{
    switch (controlEvents)
    {
        case UIControlEventTouchDown:
            [self recordVoiceStart];
            break;
            
        case UIControlEventTouchUpInside:
            [self recordVoiceEnd];
            break;
            
        case UIControlEventTouchUpOutside:
            [self recordVoiceCancel];
            break;
            
        default:
            break;
    }
}

// 文本语音输入栏高度发生变化委托回调
- (void)ChatInputViewDelegateCallBack_frameChangedWithIncreasedHeight:(CGFloat)increased
{
    self.viewInputHeight = increased;
    
    [self refreshView];
    
    if (increased > 50)
    {
        if (self.arrayDisplay.count > 1)
        {
            [self.tableView scrollToRowAtIndexPath:[ NSIndexPath indexPathForRow:self.arrayDisplay.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

// 底部输入栏点击了增加附件按钮的的委托回调
- (void)ChatInputViewDelegateCallBack_IsAddAttachment:(BOOL)mark
{
    if (mark)
    {
        self.viewInputHeight += H_ATTACH_VIEW;
    }
    else
    {
        if (self.viewInputHeight > H_ATTACH_VIEW)
        {
            self.viewInputHeight -= H_ATTACH_VIEW;
        }
    
    }
    
    [self refreshView];
}

// 附件栏选择的委托回调
- (void)ChatInputViewDelegateCallBack_attchmentSelectedWithTag:(ChatAttachPick_tag)tag
{
    switch (tag)
    {
        case tag_pick_takePhoto:
        {
            [self pickImageisFromCamera:YES];
            break;
        }
        case tag_pick_img:
        {
            WZPhotoPickerController *pickerController = [[WZPhotoPickerController alloc] init];
            pickerController.delegate = self;
            [self presentViewController:pickerController animated:YES completion:nil];
            break;
        }
        case tag_pick_task:
        {
            [self createTaskTitle:@""];
            break;
        }
            
        default:
            break;
    }
}

- (void)ChatInputViewDelegateCallBack_atUser {
    ChatGroupSelectAtUserNavigationViewController *selectAtUserVC = [[ChatGroupSelectAtUserNavigationViewController alloc] initWithGroupID:self.strUid];
    
    __weak typeof(self) weakSelf = self;
    [selectAtUserVC selectedPeople:^(ContactPersonDetailInformationModel *selectedPerson) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.chatInputView popupKeyboard];
        if (!selectedPerson) {
            // 点击取消返回
            return;
        }
        
        [strongSelf.chatInputView addAtUser:selectedPerson];
    }];
    
    [self presentViewController:selectAtUserVC animated:YES completion:nil];
}

// 区分任务的接收者是否是群聊成员
- (void)sendMessageWithContent:(MessageAppModel *)appModel peopleModel:(ContactPersonDetailInformationModel *)model
{
    NSString * show_ID = model.show_id;
    NSString * name = model.u_true_name;
    
    if ([[MessageManager share] queryPeopleIsGroupMembersWithGroupUserName:self.strUid Show_ID:show_ID]) {
        NSLog(@"---- 此人再群聊");
        [[MessageManager share] sendMessageTo:self.strUid nick:self.strName WithContent:appModel Type:(Msg_type)IM_Applicaion_task];

    }else {
        NSLog(@"---- 此人不在群聊");
        [[MessageManager share] sendMessageTo:show_ID nick:self.strName WithContent:appModel Type:(Msg_type)IM_Applicaion_task];
    }

}

#pragma mark - NewMissionGetMissionDetailRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
	NSLog(@"%@", response);
	[self hideLoading];
	
	if ([request isKindOfClass:[NewMissionGetMissionDetailRequest class]]) {
		
		NewDetailMissionViewController *missionVC = [[NewDetailMissionViewController alloc] initWithOnlyShowID: request.params[@"showId"]];
		missionVC.isFirstVC = YES;
		[self.navigationController pushViewController:missionVC animated:YES];
	}
	
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
	[self hideLoading];
	[self postError:LOCAL(errorMessage)];
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 10000){
        if(buttonIndex == 0){
            if(!self.phoneNumber.length){
                return;
            }
            NSString *phone =[NSString stringWithFormat:@"tel:%@",self.phoneNumber];
            NSURL *url = [NSURL URLWithString:phone];
            [[UIApplication sharedApplication] openURL:url];
        }
        if(buttonIndex == 1){
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            pboard.string = self.phoneNumber;
        }
        return;
    }
    if(actionSheet.tag == 10001){
        if (!self.email.length) {
            return;
        }
        if(buttonIndex == 0){
            NSString *email =[NSString stringWithFormat:@"mailto:%@",self.email];
            NSURL *url = [NSURL URLWithString:email];
            [[UIApplication sharedApplication] openURL:url];
        }
        if(buttonIndex == 1){
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            pboard.string = self.email;
        }
        return;
    }
    
    switch (buttonIndex)
    {
        case 0:
        {
            // 拍照
            [self pickImageisFromCamera:YES];
            break;
        }
            
        case 1:
        {
            // 照片
            [self pickImageisFromCamera:NO];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - LCVoice Method
// 开始录制
- (void)recordVoiceStart
{
    long long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *strDate = [NSString stringWithFormat:@"%lld",timeStamp];
    
    // 得到路径
    NSString *strPathWav = [[MsgFilePathMgr share] getMessageDirFilePathWithFileName:strDate extension:extension_wav uid:self.strUid];
    // 开始录制声音到文件夹
    [self.audioManager startRecordWithPath:strPathWav ShowInView:self.view];
}

// 停止录制
- (void)recordVoiceEnd
{
    [self.audioManager stopRecord];
}

// 取消录制
- (void)recordVoiceCancel
{
    [self.audioManager cancelRecord];
    
    // 防御，判断是否已超时
    if (self.audioManager.isFromCancel && !self.audioManager.isFinishRecord)
    {
        [self postError:LOCAL(CANCELVOICE)];
    }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[photo.photoURL absoluteString]];
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

// 保存图片
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    // Handle the end of the image write process
    if (!error)
    {
        [self postSuccess:LOCAL(SUCCESS_SAVE)];
    }
    else
    {
        [self postError:[error localizedDescription]];
    }
}


- (void)pickImageisFromCamera:(BOOL)isFromCamera
{
    NSInteger sourceType;
    // 拍照
    if (isFromCamera)
    {
        // 判断是否有摄像头
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            [self postError:LOCAL(ERROR_NOCAMERA)];
            return;
        }
    }
    // 相册
    else
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - ChatGroupManagerViewController Delegate
- (void)chatGroupManagerViewControllerDidChangedGroupName:(BOOL)didChanged NewGroupName:(NSString *)newGroupName OldGroupName:(NSString *)oldGroupName {
	
	self.keyboardHeight = 0;
	[self resignKeyBoard];
	
	if (didChanged) {
		[self refreshGroupTitle];
	}
	
}

#pragma mark - ChatAttachMrgViewController Delegate

// 附件下载完毕的委托回调
- (void)ChatAttachMgrViewControllerDelegateCallBack_finishDownloadAndLookAttachWithFileUrl:(NSString *)fileUrl
{
    [self lookAttachmentWithFileUrl:fileUrl];
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
    [[UIAlertView alloc] initWithTitle: LOCAL(SAVE_PHOTO)
                               message: nil
                              delegate: self
                     cancelButtonTitle:LOCAL(NO_SAVE)
                     otherButtonTitles:LOCAL(SAVE),nil];
    [cantRecordAlert show];
}


#pragma mark - getter & setter
- (NSArray *)arrayDisplay {
   return self.showingMessages;
}


- (MWPhotoBrowser *)photoBrowser
{
    if (!_photoBrowser)
    {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = YES; // 分享按钮，默认是
        _photoBrowser.displayNavArrows = NO;     // 左右分页切换，默认否
        _photoBrowser.displaySelectionButtons = NO; // 是否显示选择按钮
        _photoBrowser.alwaysShowControls = YES;  // 控制条件控件
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

@end
