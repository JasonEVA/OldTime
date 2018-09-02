//
//  ChatBaseViewController.m
//  launcher
//
//  Created by williamzhang on 15/12/24.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatBaseViewController.h"
#import "ChatBaseViewControllerPrivate.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"
#import "CalculateHeightManager.h"
#import <UIAlertView+Blocks/UIAlertView+Blocks.h>
#import <UIActionSheet+Blocks/UIActionSheet+Blocks.h>
#import "Slacker.h"

#import "NewChatLeftAttachTableViewCell.h"
#import "NewChatLeftImageTableViewCell.h"
#import "NewChatLeftVoiceTableViewCell.h"
#import "NewChatLeftTextTableViewCell.h"
#import "ChatForwardLeftTableViewCell.h"
#import "ChatLeftVoipTableViewCell.h"

#import "NewChatRightAttachTableViewCell.h"
#import "NewChatRightImageTableViewCell.h"
#import "NewChatRightVoiceTableViewCell.h"
#import "NewChatRightTextTableViewCell.h"
#import "ChatForwardRightTableViewCell.h"
#import "ChatRightVoipTableViewCell.h"

#import "ChatShowDateTableViewCell.h"

#import "ChatBottomMoreBar.h"
#import "ChatSelectForwardUsersViewController.h"
#import "IMNickNameManager.h"

#define W_MAX_IMAGE (225 + [Slacker getXMarginFrom320ToNowScreen] * 2)     // 照片最大宽度
NSString *const wz_default_tableViewCell_identifier = @"wz_default_tableViewCell_identifier";

typedef void(^forwardMessageCompletion)(BOOL merge);

@interface ChatBaseViewController () <UITableViewDelegate, UITableViewDataSource, ChatBottomMoreBarDelegate, UIActionSheetDelegate>

@property (nonatomic, assign) BOOL firstTime;

@property (nonatomic, weak) ChatBottomMoreBar *bottomTabbar;

@property (nonatomic, assign) BOOL needRemove;

@property (nonatomic, strong, readwrite) ChattingModule *module;
/// 选择的 待转发消息字典 (key,value)=(clientMsgId:MessageBaseModel)
@property (nonatomic, strong) NSMutableDictionary *selectedMessagesDictionary;
@property (nonatomic, strong) NSMutableArray *originalMarkedMessageModels;

@end

@implementation ChatBaseViewController

- (instancetype)init {
    return [super init];
}

- (instancetype)initWithDetailModel:(ContactDetailModel *)detailModel {
    self = [super init];
    if (self) {
        self.module.sessionModel = detailModel;
        
        _ifScrollBottom = YES;
        _firstTime = YES;
    }
    return self;
}

- (void)dealloc {
	
	@try {
		[self.module removeObserver:self forKeyPath:@"sessionModel._nickName"];
	} @catch (NSException *exception) {
		NSLog(@"------%@------", exception.debugDescription);
		self.module = nil;
	} @finally {

	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:[UIColor grayBackground]];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.chatInputView];
    
    [self.module alive:YES];
    [self initModule];
    [self draftShowIfNeed];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setTitle:self.strName];
    BOOL isAlive = self.module.isAlive;
    [self.module alive:YES];
    
    if (!self.firstTime) {
        [self.tableView reloadData];
    }
    
    if (!isAlive || self.firstTime) {
        self.firstTime = NO;
        __weak typeof(self) weakSelf = self;
        [self.module loadLocalMessagesCompletion:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.tableView reloadData];
            [strongSelf scrollToBottomIfNeed:self.ifScrollBottom animated:NO];
        }];
    }
    
    [self.module setReadMessages];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewNeedReload:) name:MTImageDidFinishedLoadNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    
    NSString *terimedString = [[self.chatInputView.inputAttributeString string] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //过滤空格之后的文字
    if (terimedString.length == 0)
    {
        self.chatInputView.inputAttributeString = [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
    [[MessageManager share] updateDraftWithTarget:self.strUid draft:self.chatInputView.inputAttributeString];
    [[MessageManager share] updateAtMeWithTarget:self.strUid atMe:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTImageDidFinishedLoadNotification object:nil];
}

#pragma mark - Chat Module
/// 初始化聊天组建
- (void)initModule {
    [self.module addObserver:self forKeyPath:@"sessionModel._nickName" options:NSKeyValueObservingOptionNew context:NULL];
    
    __weak typeof(self) weakSelf = self;
    [self.module willLoadLatestHistory:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.loadingUserInteractionEnabled = NO;
        [strongSelf postLoadingBackgroundColor:[UIColor clearColor]];
    }];
    
    // 获取最新消息
    [self.module loadHistoryCompletion:^(BOOL getLatest, BOOL success, NSInteger insertCount) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!success) {
            [strongSelf hideLoading];
            return;
        }
        
        
        [strongSelf.tableView reloadData];
        
        if (getLatest) {
            if (insertCount < 0) {
                // 之前显示的最后一条数据在新数据的哪个位置，用于动画效果
                insertCount = 0;
            }
            
            if ([strongSelf.tableView numberOfRowsInSection:0] != 0) {
                [strongSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:insertCount inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            
            [strongSelf performSelector:@selector(scrollToBottomWithAnimated:) withObject:@(insertCount < 0) afterDelay:0.01];
            [strongSelf hideLoading];
        }
    }];
    
    [self.module sendMessage:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView reloadData];
        
        NSInteger rows = [strongSelf.tableView numberOfRowsInSection:0];
        if (rows == 0) {
            return;
        }
        
        [strongSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:rows - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
    
    [self.module receiveMessage:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView reloadData];
        [strongSelf scrollToBottomIfNeed:strongSelf.ifScrollBottom animated:YES];
    }];
    
    [self.module playVoice:^(long long playVoiceMsgId, NSString *voicePath) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf voicePlayOrStopWithVoicePath:voicePath playVoiceMsgId:playVoiceMsgId];
        [strongSelf.tableView reloadData];
    }];
    
    [self.module reloadMessages:^{
        [weakSelf.tableView reloadData];
    }];
    
    [self.module refreshReSendMessage:^(NSMutableArray *arrIndexpaths) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        for (NSIndexPath *indexPath in arrIndexpaths)
        {
            // 高度重新计算
            MessageBaseModel *message = [strongSelf.module.showingMessages objectAtIndex:indexPath.row];
            CGFloat height = [CalculateHeightManager calculateHeightByModel:message IsShowGroupMemberNick:NO];
            NSString *msgId = [NSString stringWithFormat:@"%lld",message._msgId];
            [strongSelf.cellHeightCache setObject:@(height) forKey:msgId];
        }
        
        // 实时需要刷新
        if (arrIndexpaths.count == 1)
        {
            [strongSelf.tableView reloadRowsAtIndexPaths:arrIndexpaths withRowAnimation:UITableViewRowAnimationBottom];
        }
    }];
    
    [self.module handleErrorMessage:^(NSString *errorMessage) {
        [weakSelf postError:errorMessage];
    }];
}

#pragma mark - Interface Method
- (void)startEditingWithFirstIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    
    [CATransaction begin];
    [self.tableView setEditing:YES animated:YES];
    [CATransaction setCompletionBlock:^{

        BaseSelectTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell setWz_selected:YES];
		
    }];
    
    [CATransaction commit];
    
    MessageBaseModel *message = [self.showingMessages objectAtIndex:indexPath.row];
    [self.selectedMessagesDictionary setObject:message forKey:@(message._clientMsgId)];
    
    [self popGestureDisabled:YES];
    
    [self createBottomTabbarWithModel:message];
    
    [self.bottomTabbar canTapButtons:YES];
    
    // 存储之前的rightItems
    self.previousRightItems = self.navigationItem.rightBarButtonItems;
    [self.navigationItem setRightBarButtonItems:nil animated:YES];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(resumeBottomTabbar)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)markVisibleMessageCellsWithOtherImportantMessageModels {
	[self.showingMessages enumerateObjectsUsingBlock:^(MessageBaseModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
		
		if (model._markImportant) {
			[self.selectedMessagesDictionary setObject:model forKey:@(model._clientMsgId)];
			[self.originalMarkedMessageModels addObject:model];
		}
		
	}];
}

/**
 *  只要选择的消息存在未标为重点的,底部标题则显示标记重点
 */
- (void)setBottomBarTitleWithIsMarkStateWhileHasUnMarkedMessages {
	BOOL markState = NO;
	for (MessageBaseModel *model in [self.selectedMessagesDictionary allValues])
	{
		if (!model._markImportant) {
			markState = YES;
		}
	}
	
	[self setTitleWithIsMarkState:markState];
	
}

///@brief：如果一个已经标记，再次点击另一个的时候就应显示标记重点
- (void)setTitleWithIsMarkState:(BOOL)isMarkState
{
    //标记重点
    if (isMarkState)
    {
        [self.bottomTabbar setTitleEmphsisButtonWithTitle:LOCAL(MAKE_MARK) Image:[UIImage imageNamed:@"menu_Emphasis_black"]];
    }
    else //取消标记
    {
        [self.bottomTabbar setTitleEmphsisButtonWithTitle:LOCAL(CANCEL_MARK) Image:[UIImage imageNamed:@"menu_cancelEmphasis_black"]];
    }
}

#pragma mark - Override Method
- (void)changeLeftNumber {
    [[MessageManager share] queryUnreadMessageCountWithoutUid:self.strUid completion:^(NSInteger unreadCount) {
        [self leftItemNumber:unreadCount];
    }];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y + CGRectGetHeight(self.tableView.frame) >= self.tableView.contentSize.height - 100) {
        self.ifScrollBottom = YES;
    } else {
        self.ifScrollBottom = NO;
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"sessionModel._nickName"]) {
        if ([self.module.sessionModel._nickName length]) {
            [self.navigationItem setTitle:self.module.sessionModel._nickName];
        }
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  { return [self.module.showingMessages count]; }
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.001; }
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 0.001; }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { return [self tableViewCellAtIndexPath:indexPath]; }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath         { return [self heightForIndexPath:indexPath]; }
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath { return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert; }

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIView performWithoutAnimation:^{
        [cell layoutIfNeeded];
       
        if (![tableView isEditing]) {
            return;
        }
        // 不知道为啥一定要在这里设置selected才有效果
        MessageBaseModel *message = [self.showingMessages objectAtIndex:indexPath.row];
        BOOL isSelected = [self.selectedMessagesDictionary objectForKey:@(message._clientMsgId)] ? YES : NO;
        if (![cell isKindOfClass:[BaseSelectTableViewCell class]]) {
            return;
        }
        
        [(BaseSelectTableViewCell *)cell setWz_selected:isSelected];
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (!tableView.isEditing) { return NO; }
    MessageBaseModel *message = [self.showingMessages objectAtIndex:indexPath.row];
    
    return message._type != msg_other_timeStamp && message._type != msg_personal_alert && message._type != msg_personal_reSend && message._type != IM_Applicaion_task;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageBaseModel *message = [self.showingMessages objectAtIndex:indexPath.row];
    
    if (![tableView isEditing]) {
        return;
    }
    
    NSNumber *key = [NSNumber numberWithLongLong:message._clientMsgId];
    id value = [self.selectedMessagesDictionary objectForKey:key];
    
    self.selectedMessagesDictionary[key] = !value ? message : nil;
    
    BaseSelectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if (![cell isKindOfClass:[BaseSelectTableViewCell class]]) {
		return;
	}
    [cell setWz_selected:!value];
	
    //根据选择动态修改文字
	[self setBottomBarTitleWithIsMarkStateWhileHasUnMarkedMessages];

    [self.bottomTabbar canTapButtons:[self.selectedMessagesDictionary allKeys].count != 0];
}

#pragma mark - 子类继承
- (UITableViewCell *)tableViewCellAtIndexPath:(NSIndexPath *)indexPath { NSAssert(0,@"未继承该方法"); return  nil; }
- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath { NSAssert(0,@"未继承该方法"); return 0; }
- (void)voicePlayOrStopWithVoicePath:(NSString *)voicePath playVoiceMsgId:(long long)voiceMsgId { NSAssert(0, @"未继承该方法"); }

#pragma mark - ChatBottomMoreBar Delegate
- (void)chatBottomMoreBar:(ChatBottomMoreBar *)bottomMoreBar clickedAtIndex:(NSUInteger)index {
	
	[bottomMoreBar.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if (obj.tag == 0 && [obj isKindOfClass:[UIButton class]]) {
			self.needRemove = [[obj currentTitle] isEqualToString:LOCAL(CANCEL_MARK)];
		}
	}];
	
    NSMutableArray *messages =  [NSMutableArray arrayWithArray:[self.selectedMessagesDictionary allValues]];
	if (!self.needRemove) {
		[messages removeObjectsInArray:self.originalMarkedMessageModels];
	}
	
    
    if (index == 0) {
        // 标记重点
        [self postLoading];
        self.loadingUserInteractionEnabled = NO;
		BOOL markImportant = !self.needRemove;
        dispatch_group_t dispatchGroup = dispatch_group_create();
        
        __block NSString *errorMessage;
        [messages enumerateObjectsUsingBlock:^(MessageBaseModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            dispatch_group_enter(dispatchGroup);
			obj._markImportant = markImportant ? NO : YES;
            [[MessageManager share] markMessage:obj completion:^(BOOL success) {
                if (!success) {
                    errorMessage = LOCAL(ERROROTHER);
                }
                
                dispatch_group_leave(dispatchGroup);
                }];
        }];
        
        dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
            if (errorMessage) {
                [self postError:errorMessage];
            } else {
                [self hideLoading];
                [self resumeBottomTabbar];
            }
            self.loadingUserInteractionEnabled = YES;
        });
        
        return;
    }
    
    if (index == 1) {
        // 消息转发
		
        if ([messages count] == 1) {
            if (![self canForwardSingleMessage:[messages firstObject]]) return;
            [self forwardCompletion](NO);
            return;
        }
        
        [UIActionSheet showInView:self.view
                        withTitle:nil
                cancelButtonTitle:LOCAL(CANCEL)
           destructiveButtonTitle:nil
                otherButtonTitles:@[LOCAL(CHAT_FORWARD_ONEBYONE), LOCAL(CHAT_FORWARD_MERGE)]
                         tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex)
         {
             BOOL merge = NO;
             if (buttonIndex == 0) {
                 // 逐条转发
                 merge = NO;
             } else if (buttonIndex == 1) {
                 // 合并转发
                 merge = YES;
             } else {
                 return;
             }
             
             if (![self canForwardMessages:messages merge:merge]) {
                 return;
             }
             [self forwardCompletion](merge);
         }];
    }
}

#pragma mark - UIImagePickerController Delegate
// 选择后返回
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image != nil)
    {
        CGFloat W_img = MIN(W_MAX_IMAGE, image.size.width);
        CGFloat H_img = (W_img / image.size.width) * image.size.height;
        UIImage *imgThumb =  [Slacker imageWithImage:image scaledToSize:CGSizeMake(W_img, H_img)];
        
        [self writeImageToFilePathWithOringnalImage:image thumbImage:imgThumb];
    }
    
    if (picker) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
// 取消返回
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WZPhotoPickerController Delegate
- (void)wz_imagePickerController:(WZPhotoPickerController *)photoPickerController didSelectAssets:(NSArray *)assets {
    for (ALAsset *asset in assets) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];
        
        // 压缩了当bug提示不清晰不压缩了
        CGFloat W_img = MIN(W_MAX_IMAGE, image.size.width);
        CGFloat H_img = (W_img / image.size.width) * image.size.height;
        UIImage *imgThumb =  [Slacker imageWithImage:image scaledToSize:CGSizeMake(W_img, H_img)];
        
        [self writeImageToFilePathWithOringnalImage:image thumbImage:imgThumb];
    }
    
    [photoPickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RMAudioManager Delegate
// 完成播放音频
- (void)RMAudioManagerDelegateCallBack_AudioDidFinishPlaying
{
    // 标记
    self.currentPlayingVoiceMsgId = wz_default_needVoice_msgId;
}

- (void)RMAudioManagerDelegateCallBack_AudioFailedRecordWithError:(NSError *)error
{
    UIAlertView *cantRecordAlert =
    [[UIAlertView alloc] initWithTitle: LOCAL(RADIO_NOWORK)
                               message: LOCAL(RADIO_NOWORREASON)
                              delegate: nil
                     cancelButtonTitle: LOCAL(CONFIRM)
                     otherButtonTitles:nil];
    [cantRecordAlert show];
}

- (void)RMAudioManagerDelegateCallBack_AudioFinishedRecordWithDuration:(CGFloat)duration Path:(NSString *)path
{
    if (self.audioManager.recordDuration <= 1.0f) {
        // 时间过短
        [self postError:LOCAL(RADIO_TIMETOOSHORT)];
        return;
    }
    
    
    // 得到已经录制的音频路径（wav）
    NSString *strPathWav = self.audioManager.recordPath;
    
    // 转为相对路径
    NSString *relativePathWav = [[MsgFilePathMgr share] getRelativePathWithAllPath:strPathWav];
    // 下锚点
    [[MessageManager share] anchorAttachMessageType:msg_personal_voice
                                           toTarget:self.strUid
                                           nickName:self.strName
                                        primaryPath:relativePathWav
                                          minorPath:nil];
}

#pragma mark - WriteToFilePath
- (void)writeImageToFilePathWithOringnalImage:(UIImage *)originImage thumbImage:(UIImage *)thumbImage;
{
    // 1.文件写入沙盒
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        // 得到路径
        long long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
        NSString *strDate = [NSString stringWithFormat:@"%lld",timeStamp];
        NSString *strFileNameOriginal = [NSString stringWithFormat:@"%@origin.jpg",strDate];
        NSString *strFileNameThumb = [NSString stringWithFormat:@"%@thumb.jpg",strDate];
        NSString *strPath = [[MsgFilePathMgr share] getMessageDirNamePathWithUid:self.strUid];
        NSString *strOriginPath = [strPath stringByAppendingPathComponent:strFileNameOriginal];
        NSString *strThumbPath = [strPath stringByAppendingPathComponent:strFileNameThumb];
        
        PRINT_STRING(strOriginPath);
        PRINT_STRING(strThumbPath);
        
        [self RecordToDiary:[NSString stringWithFormat:@"单聊文件写入沙盒，strOriginPath:%@---strThumbPath:%@",strOriginPath,strThumbPath]];
        
        // 写入文件夹
        [UIImageJPEGRepresentation(originImage, 0.5) writeToFile:strOriginPath atomically:YES];
        [UIImageJPEGRepresentation(thumbImage, 1.0) writeToFile:strThumbPath atomically:YES];
        
        
        // 转换成相对路径
        NSString *strRelativeOrigin = [[MsgFilePathMgr share] getRelativePathWithAllPath:strOriginPath];
        NSString *strRelativeThumb = [[MsgFilePathMgr share] getRelativePathWithAllPath:strThumbPath];
        
        // 回归主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 2. 下锚点
            [[MessageManager share] anchorAttachMessageType:msg_personal_image
                                                   toTarget:self.strUid
                                                   nickName:self.strName
                                                primaryPath:strRelativeOrigin
                                                  minorPath:strRelativeThumb];
        });
    });
}

#pragma mark - Notification Method
// 图片下载完的刷新列表操作
- (void)tableViewNeedReload:(NSNotification *)notification
{
    MessageBaseModel *baseModel = notification.object;
    BOOL isGroup = [ContactDetailModel isGroupWithTarget:baseModel._target];
    CGFloat height = [CalculateHeightManager calculateHeightByModel:baseModel IsShowGroupMemberNick:isGroup];
    [self.cellHeightCache setObject:@(height) forKey:[NSString stringWithFormat:@"%lld",baseModel._msgId]];
    
    [self.tableView reloadData];
}

#pragma mark - Private Method
/// 查看是否有草稿
- (void)draftShowIfNeed {
    
    [[MessageManager share] querySessionDataWithUid:self.strUid completion:^(ContactDetailModel *model) {
        [self.chatInputView setInputAttributeString:model._draft];
        
        if (![model._draft.string length]) {
            return;
        }
        
        [UIView performWithoutAnimation:^{
            [self.chatInputView performSelector:@selector(popupKeyboard) withObject:nil afterDelay:0.5];
        }];
    }];
}

- (void)scrollToBottomWithAnimated:(BOOL)animated {
    if (animated) {
        [self scrollToBottomIfNeed:YES animated:YES];
        return;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [self scrollToBottomIfNeed:YES animated:NO];
    }];
}
- (void)scrollToBottomIfNeed:(BOOL)isNeed animated:(BOOL)animated {
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if (rows <= 0 || !isNeed) {
        return;
    }
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:rows - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

- (void)pullRefreshData {
    
    __weak typeof(self) weakSelf = self;
    [self.module loadMoreHistoryCompletion:^(NSUInteger addCount) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView reloadData];
        [strongSelf.tableView.header endRefreshing];
        if (addCount == 0) {
            return;
        }
        [strongSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:addCount inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
}

- (void)createBottomTabbarWithModel:(MessageBaseModel *)Model
{
    ChatBottomMoreBar *bottomBar = [[ChatBottomMoreBar alloc] initWithImages:@[
                                                                                     Model._markImportant?[UIImage imageNamed:@"menu_cancelEmphasis_black"]:[UIImage imageNamed:@"menu_Emphasis_black"],
                                                                                     [UIImage imageNamed:@"share_black"]
                                                                                     ]
                                                                            titles:@[
                                                                                     Model._markImportant?LOCAL(CANCEL_MARK):LOCAL(MAKE_MARK),
                                                                                     LOCAL(FROWARDING)
                                                                                     ]];
    bottomBar.backgroundColor = [UIColor whiteColor];
    bottomBar.delegate = self;

    [self.view addSubview:bottomBar];
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    self.bottomTabbar = bottomBar;
}
/// 还原回原样
- (void)resumeBottomTabbar {
    [self.bottomTabbar removeFromSuperview];
    [self.selectedMessagesDictionary removeAllObjects];
	[self.originalMarkedMessageModels removeAllObjects];
    [self popGestureDisabled:NO];
    
    [self showLeftItemWithSelector:nil];
    [self.navigationItem setRightBarButtonItems:self.previousRightItems animated:YES];
    self.previousRightItems = nil;
    
    [self.tableView setEditing:NO animated:YES];
}

- (BOOL)canForwardSingleMessage:(MessageBaseModel *)message {
    BOOL canForward = message._type == msg_personal_text ||
                 message._type == msg_personal_mergeMessage;
    if (!canForward) {
		NSString *cancelTitle = self.vaildMergeForwardMessagesCount == 0 &&![self hasVaildForwordMessagesWithSelectedMessages:@[message]] ? nil : LOCAL(CANCEL);
        [UIAlertView showWithTitle:nil message:LOCAL(CHAT_FORWARD_ONEBYE_WARNING)
				 cancelButtonTitle:cancelTitle
                 otherButtonTitles:@[LOCAL(CONFIRM)]
                          tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex)
         {
             if (buttonIndex == 0) {
                 return;
             }
             
             // 多条转发
             if ([[self.selectedMessagesDictionary allValues] count] > 1) {
                 [self forwardCompletion](NO);
                 return;
             }
             
             [self resumeBottomTabbar];
         }];
    }
    
    return canForward;
}

- (BOOL)canForwardMessages:(NSArray *)messages merge:(BOOL)merge {
    __block BOOL canForward = YES;
    
    [messages enumerateObjectsUsingBlock:^(MessageBaseModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj._type != msg_personal_text) {
            if (!merge) {
                if (obj._type != msg_personal_mergeMessage) {
                    // 逐条发送 多加个条件
                    [self canForwardSingleMessage:obj];
                    *stop = YES;
                    canForward = NO;
                }
            }
            else {
                *stop = YES;
                canForward = NO;
            }
        }
    }];
    
    if (!canForward && !merge) {
        // 已经在block中做了操作
        return canForward;
    }
    
    
    if (!canForward) {
		NSString *cancelTitle = self.vaildMergeForwardMessagesCount == 0 ? nil : LOCAL(CANCEL);
        [UIAlertView showWithTitle:nil message:LOCAL(CHAT_FORWARD_MERGE_WARNING)
                 cancelButtonTitle:cancelTitle
                 otherButtonTitles:@[LOCAL(CONFIRM)]
                          tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex)
        {
            if (buttonIndex == 0) {
                return;
            }
            
            [self forwardCompletion](YES);
        }];
    }
    
    return canForward;
}

- (forwardMessageCompletion)forwardCompletion {
    forwardMessageCompletion completion = ^(BOOL merge){
        NSMutableArray *messages = [NSMutableArray arrayWithArray:[self.selectedMessagesDictionary allValues]];
        NSArray *handledMessages = [ChatSelectForwardUsersViewController handledMessages:messages merge:merge];
        
        if ([handledMessages count] == 0) {
            [self resumeBottomTabbar];
            return;
        }
        
        //清理工作***********
        NSMutableArray *tempArray = [NSMutableArray array];
        for (MessageBaseModel *model in messages)
        {
            BOOL canForward;
            if (!merge)
            {
                canForward = model._type == msg_personal_text ||
                model._type == msg_personal_mergeMessage;
            }else
            {
				canForward = model._type == msg_personal_text;
            }
            
            if (canForward)
            {
                [tempArray addObject:model];
            }
        }
        messages = tempArray;
        //清理工作***********
        
        __weak typeof(self) weakSelf = self;
        ChatSelectForwardUsersViewController *VC = [[ChatSelectForwardUsersViewController alloc] initWithForwardMerge:merge
                                                                                                      sessionNickName:self.module.sessionModel._nickName
                                                                                                             messages:messages
                                                                                                              isGroup:[ContactDetailModel isGroupWithTarget:self.strUid]
                                                                                                           completion:^{ [weakSelf resumeBottomTabbar]; }];
        [self presentViewController:VC animated:YES completion:nil];
    };
    
    return completion;
}

/**
 *  判断选择的消息中是否存在可以转发的消息
 */
- (BOOL)hasVaildForwordMessagesWithSelectedMessages:(NSArray *)selectedMsgs {
	__block BOOL result = NO;
	if (selectedMsgs.count <= 1) {
		MessageBaseModel *message = [selectedMsgs firstObject];
		result = message._type == msg_personal_text || message._type == msg_personal_mergeMessage;
	} else {
		[selectedMsgs enumerateObjectsUsingBlock:^(MessageBaseModel  *_Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
			if (message._type == msg_personal_text || message._type == msg_personal_mergeMessage) {
				result = YES;
			}
		}];
	}
	
	return result;
}

/**
 *  从选中的消息中获得能合并转发的消息数
 */
- (NSUInteger)vaildMergeForwardMessagesCount {
	__block NSUInteger count = 0;
	
	[[self.selectedMessagesDictionary allValues] enumerateObjectsUsingBlock:^(MessageBaseModel * _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
		if (message._type == msg_personal_text) {
			count += 1;
		}
	}];
	
	return count;
}

#pragma mark - Get
@synthesize strUid = _strUid, strName = _strName;
- (NSString *)strUid {
    return self.module.sessionModel._target ?: @"";
}

- (NSString *)strName {
    return  [IMNickNameManager showNickNameWithOriginNickName:self.module.sessionModel._nickName userId:self.strUid] ?: @"";
}

- (NSArray<MessageBaseModel *> *)showingMessages {
    return self.module.showingMessages;
}

- (NSDictionary *)uploadImageDictionary {
    return [MessageManager share].attachUploadProgressDictionary;
}

#pragma mark - Initializer
@synthesize tableView = _tableView, chatInputView = _chatInputView;

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64 - HEIGTH_TABBAR) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        _tableView.allowsMultipleSelectionDuringEditing = YES;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefreshData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        
        _tableView.header = header;
        
        
        void (^ registerClassBlock)(Class) = ^(Class registerClass) {
            [_tableView registerClass:registerClass forCellReuseIdentifier:[(id)registerClass identifier]];
        };
        
        // 无identifier的方法不能使用该函数
        registerClassBlock(NewChatLeftAttachTableViewCell.class);
        registerClassBlock(NewChatLeftImageTableViewCell.class);
        registerClassBlock(NewChatLeftTextTableViewCell.class);
        registerClassBlock(NewChatLeftVoiceTableViewCell.class);
        registerClassBlock(ChatForwardLeftTableViewCell.class);
        registerClassBlock(ChatLeftVoipTableViewCell.class);
        
        registerClassBlock(NewChatRightAttachTableViewCell.class);
        registerClassBlock(NewChatRightImageTableViewCell.class);
        registerClassBlock(NewChatRightVoiceTableViewCell.class);
        registerClassBlock(NewChatRightTextTableViewCell.class);
        registerClassBlock(ChatForwardRightTableViewCell.class);
        registerClassBlock(ChatRightVoipTableViewCell.class);
        
        registerClassBlock(ChatShowDateTableViewCell.class);
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:wz_default_tableViewCell_identifier];
        
    }
    return _tableView;
}

- (NSMutableDictionary *)selectedMessagesDictionary {
    if (!_selectedMessagesDictionary) {
        _selectedMessagesDictionary = [NSMutableDictionary dictionary];
    }
    return _selectedMessagesDictionary;
}

- (ChatInputView *)chatInputView {
    if (!_chatInputView) {
        _chatInputView = [[ChatInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 64 - H_COMMON_VIEW, self.view.frame.size.width, H_COMMON_VIEW + H_ATTACH_VIEW)];
        _chatInputView.delegate = self;
        [_chatInputView setBackgroundColor:[UIColor grayBackground]];
    }
    return _chatInputView;
}

@synthesize module = _module;
- (ChattingModule *)module {
    if (!_module) {
        _module = [[ChattingModule alloc] init];
    }
    return _module;
}

- (NSMutableDictionary *)cellHeightCache
{
    if (!_cellHeightCache)
    {
        _cellHeightCache = [NSMutableDictionary new];
    }
    
    return _cellHeightCache;
}

- (RMAudioManager *)audioManager
{
    if (!_audioManager)
    {
        _audioManager = [[RMAudioManager alloc] init];
        [_audioManager setDelegate:self];
    }
    return _audioManager;
}

- (NSMutableArray *)originalMarkedMessageModels {
	if (!_originalMarkedMessageModels) {
		_originalMarkedMessageModels = [NSMutableArray array];
	}
	return  _originalMarkedMessageModels;
}
@end
