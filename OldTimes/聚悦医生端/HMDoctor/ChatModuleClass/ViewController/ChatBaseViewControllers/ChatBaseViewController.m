//
//  ChatBaseViewController.m
//  launcher
//
//  Created by williamzhang on 15/12/24.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatBaseViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
//#import "Category.h"
#import "MyDefine.h"
#import "CalculateHeightManager.h"
#import "Slacker.h"

#import "NewChatLeftAttachTableViewCell.h"
#import "NewChatLeftImageTableViewCell.h"
#import "NewChatLeftVoiceTableViewCell.h"
#import "NewChatLeftTextTableViewCell.h"

#import "NewChatRightAttachTableViewCell.h"
#import "NewChatRightImageTableViewCell.h"
#import "NewChatRightVoiceTableViewCell.h"
#import "NewChatRightTextTableViewCell.h"

#import "ChatShowDateTableViewCell.h"
#import "PatientServiceCommentLeftTableViewCell.h"
#import "PatientEventTableViewCell.h"
#import "PatientEventRightTableViewCell.h"
#import "PatientLeftWithTwoButtonTableViewCell.h"
#import "PatientServiceCommentRightTableViewCell.h"

#import "ChatBaseViewController+ChatCellActions.h"
#import "ChatBaseViewController+ChatInputViewActions.h"
#import "ChatBaseViewController+TTTAttributedLabelDelegate.h"

#import "PatientDoubleChooseLeftTableViewCell.h"
#import "PatientDoubleChooseRightTableViewCell.h"

#import "PatientHealthEducationLeftTableViewCell.h"
#import "PatientHealthEducationRightTableViewCell.h"
#import "PatientReceiptMessageRightTableViewCell.h"
#import "PatientReceiptMessageLeftTableViewCell.h"

#define W_MAX_IMAGE (225 + [Slacker getXMarginFrom320ToNowScreen] * 2)     // 照片最大宽度
static CGFloat const duration_inputView = 0.20;

@interface ChatBaseViewController ()<UITableViewDelegate>

@property (nonatomic, strong, readwrite) ChattingModule *module;
@property (nonatomic, assign) BOOL firstTime;
@property (nonatomic, strong)  ChatTableViewAdapter  *adapter; // <##>
@property (nonatomic, assign) BOOL isLongGesture;//是不是长按触发的键盘收起
@property (nonatomic, assign, readwrite)  BOOL  hideSenderName; // 是否隐藏发送者名字
@property (nonatomic, assign)  BOOL  hideInputView; // 是否隐藏输入栏
@property (nonatomic, assign)  WZImageShowMenu  showMenu; // <##>
@end

@implementation ChatBaseViewController

- (instancetype)initWithDetailModel:(ContactDetailModel *)detailModel {
    self = [super init];
    if (self) {
        _strUid        = detailModel._target;
        _strName       = detailModel._nickName;
        _avatarPath    = detailModel._headPic;
        _hideInputView = (detailModel._target && detailModel._target.length > 0) ? NO : YES;
        self.module.sessionModel = detailModel;
        
        _ifScrollBottom = YES;
        _firstTime = YES;
        // 放didLoad里可能不会注册，dealloc移除时会crash
        [self.module addObserver:self forKeyPath:@"sessionModel._nickName" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)dealloc {
    
    [self.module removeObserver:self forKeyPath:@"sessionModel._nickName"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"APPEnterBackground" object:nil];

    // 移除委托
    [self.module alive:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置cell手势长按菜单
    [self configCellLongPressActionWithChatType:self.chatType];

    [self.view addSubview:self.tableView];
    
    if (!self.chatInputView) {
        self.chatInputView = [[ChatInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 64 - H_COMMON_VIEW, self.view.frame.size.width, H_COMMON_VIEW + H_ATTACH_VIEW)];
        self.chatInputView.delegate = self;
        //        [_chatInputView setBackgroundColor:[UIColor lightGrayColor]];
        self.chatInputView.hidden = self.hideInputView;
    }
    
    [self.view addSubview:self.chatInputView];

    [self.module alive:YES];
//    [self.module addObserver:self forKeyPath:@"sessionModel._nickName" options:NSKeyValueObservingOptionNew context:NULL];
    [self initModule];
    [self draftShowIfNeed];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBack) name:@"APPEnterBackground" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.module.isAlive) {
        [self.module alive:YES];
    }
    BOOL isAlive = self.module.isAlive;
    if (!self.firstTime) {
        [self.tableView reloadData];
    }
    
    if (!isAlive || self.firstTime) {
        self.firstTime = NO;
        __weak typeof(self) weakSelf = self;
        [self.module loadLocalMessagesCompletion:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.tableView reloadData];
            [strongSelf scrollToBottomIfNeed:strongSelf.ifScrollBottom animated:NO];
        }];
    }

    [self.module setReadMessages];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewNeedReload:) name:notify_image_finish_loaded object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.module setReadMessages];
    [[MessageManager share] updateDraftWithTarget:self.strUid draft:self.chatInputView.inputAttributeString];
    [[MessageManager share] updateAtMeWithTarget:self.strUid atMe:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notify_image_finish_loaded object:nil];
    
}

#pragma mark - Chat Module
/// 初始化聊天组建
- (void)initModule {

    [self.module configTargetProfile];
    __weak typeof(self) weakSelf = self;
    [self.module willLoadLatestHistory:^{
        // do something 即将获取最新历史
    }];
    
    // 获取最新消息
    ATLog(@"获取最新消息");
    [self.module loadHistoryCompletion:^(BOOL getLatest, BOOL success, NSInteger insertCount) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!success) {
            ATLog(@"获取最新消息失败");
            return;
        }
        ATLog(@"获取最新消息成功");
        [strongSelf.tableView reloadData];
        
        if (getLatest) {
            if (insertCount < 0) {
                // 之前显示的最后一条数据在新数据的哪个位置，用于动画效果
                insertCount = 0;
            }
            
//            insertCount = 0; // 取消动画
//            [strongSelf scrollToBottomIfNeed:YES animated:NO];
            
            if ([strongSelf.tableView numberOfRowsInSection:0] != 0) {
                [strongSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:insertCount inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                ATLog(@"滑动到底部");
            }
            
            [strongSelf performSelector:@selector(scrollToBottomWithAnimated:) withObject:@(insertCount < 0) afterDelay:0.01];
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
            CGFloat height = [CalculateHeightManager calculateHeightByModel:message IsShowGroupMemberNick:!strongSelf.hideSenderName];
            NSString *msgId = [NSString stringWithFormat:@"%lld",message._msgId];
            
            if (message._type == msg_personal_event) {
                height = MAX(height + 10, [message cellHeight] + 60);
            }

            [strongSelf.cellHeightCache setObject:@(height) forKey:msgId];
        }
        
        // 实时需要刷新
        if (arrIndexpaths.count > 0)
        {
            [strongSelf.tableView reloadRowsAtIndexPaths:arrIndexpaths withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    
    [self.module handleErrorMessage:^(NSString *errorMessage) {
    
    }];
}

#pragma mark - Interface Method

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

// 配置是否显示发送者名字
- (void)configCellSenderNameHide:(BOOL)hide {
    self.hideSenderName = hide;
    self.adapter.hideName = hide;
}

// 刷新联系人信息（重新配置Adapter）
- (void)refreshTargetInfo {
    [self.adapter configTargetUid:self.strUid chattingModule:self.module];
}

// 隐藏输入框
- (void)hideChatInputView:(BOOL)hide {
    self.hideInputView = hide;
}


#pragma mark - Override Method
- (void)changeLeftNumber {
    [[MessageManager share] queryUnreadMessageCountWithoutUid:self.strUid completion:^(NSInteger unreadCount) {

    }];
}

- (void)setChatType:(IMChatType)chatType {
    if (_chatType == chatType) {
        return;
    }
    _chatType = chatType;
    [self configCellLongPressActionWithChatType:chatType];
}

// 配置cell长按事件菜单
- (void)configCellLongPressActionWithChatType:(IMChatType)chatType {
    switch (chatType) {
        case IMChatTypePatientChat: {
            self.showMenu = WZImageShowMenuEmphasis | WZImageShowMenuCancelEmphasis | WZImageShowMenuRecall | WZImageShowMenuCopy | WZImageShowMenuForward;
            break;
        }
        case IMChatTypeWorkGroup: {
            self.showMenu = WZImageShowMenuEmphasis | WZImageShowMenuCancelEmphasis | WZImageShowMenuRecall | WZImageShowMenuCopy | WZImageShowMenuForward;
            break;
        }
        case IMChatTypeCustomerService: {
            self.showMenu = WZImageShowMenuCopy;
            break;
        }

        default:
            self.showMenu = WZImageShowMenuCopy;
            break;
    }
    [self.adapter configCellLongPressActions:self.showMenu];
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
        [self.navigationItem setTitle:self.module.sessionModel._nickName];
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  { return [self.module.showingMessages count];}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.001;}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 0.001;}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIView performWithoutAnimation:^{
        [cell layoutIfNeeded];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    height = [CalculateHeightManager calculateHeightByModel:model IsShowGroupMemberNick:!self.hideSenderName];
    
    
    if (model._type == msg_personal_event) {
        height = MAX(height , [model cellHeight]);
    }
    [self.cellHeightCache setObject:@(height) forKey:cellHeightId];
    
    return height;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self resignKeyBoard];
    }
}

#pragma mark - ChatTableViewAdapterDelegate

- (void)chatTableViewAdapterDelegateCallBack_adapter:(ChatTableViewAdapter *)adapter resendMessageWithModel:(MessageBaseModel *)baseModel {
    [self resendMessage:baseModel];
}


#pragma mark - Notification Method
// 图片下载完的刷新列表操作
- (void)tableViewNeedReload:(NSNotification *)notification
{
    MessageBaseModel *baseModel = notification.object;
    CGFloat height = [CalculateHeightManager calculateHeightByModel:baseModel IsShowGroupMemberNick:!self.hideSenderName];
    [self.cellHeightCache setObject:@(height) forKey:[NSString stringWithFormat:@"%lld",baseModel._msgId]];
    
    [self.tableView reloadData];
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
    //    if (keyboardFrame.origin.y > (self.view.frame.size.height - keyboardFrame.size.height + 44 + APP_STATUSBAR_HEIGHT))
    if (keyboardFrame.origin.y > (self.view.window.frame.size.height - keyboardFrame.size.height))
        
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

#pragma mark - Private Method

- (void)changeReceiptStatus:(BOOL)isReceiptOn {
    [self.chatInputView.viewAttach changeReceiptStatus:isReceiptOn];
    self.isReceiptOn = isReceiptOn;
    [self.chatInputView.viewCommon changePlaceHolderIsHidden:!self.isReceiptOn];
}

/// 查看是否有草稿
- (void)draftShowIfNeed {
__weak typeof(self) weakSelf = self;
    [[MessageManager share] querySessionDataWithUid:self.strUid completion:^(ContactDetailModel *model) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.chatInputView setInputAttributeString:model._draft];
        [strongSelf changeReceiptStatus:self.module.sessionModel._chatStatus];

        if (![model._draft.string length]) {
            return;
        }
        
        [UIView performWithoutAnimation:^{
            [strongSelf.chatInputView performSelector:@selector(popupKeyboard) withObject:nil afterDelay:0.5];
        }];
    }];
}

- (void)scrollToBottomWithAnimated:(BOOL)animated {
    ATLog(@"0.1s后滑动到底部");
//    if (animated) {
//        [self scrollToBottomIfNeed:YES animated:YES];
//        return;
//    }
    [self scrollToBottomIfNeed:YES animated:animated];
//    [UIView animateWithDuration:0.5 animations:^{
//        [self scrollToBottomIfNeed:YES animated:NO];
//    }];
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
        [strongSelf.tableView.mj_header endRefreshing];
        if (addCount == 0) {
            return;
        }
        if (!strongSelf.module.showingMessages || strongSelf.module.showingMessages.count <= addCount) {
            return;
        }
        [strongSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:addCount inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
}

// 收起键盘
- (void)resignKeyBoard
{
    [self.chatInputView packupKeyborad];
    
    //    self.viewInputHeight = 50;
    [self.view setNeedsUpdateConstraints];
}
//进入后台
- (void)enterBack {
    [self.audioManager stopRecord];
    [self.cellHeightCache removeAllObjects];
}
#pragma mark - Get
@synthesize strUid = _strUid, strName = _strName;
- (NSString *)strUid {
    return _strUid ? _strUid : @"";
}

- (NSString *)strName {
    return _strName ? _strName : @"";
}

#pragma mark - Setter
- (void)setStrUid:(NSString *)strUid {
    _strUid = strUid;
    self.module.sessionModel._target = strUid;
}

- (void)setStrName:(NSString *)strName {
    _strName = strName;
    self.module.sessionModel._nickName = strName;
}

#pragma mark - Initializer
@synthesize tableView = _tableView, chatInputView = _chatInputView;

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64 - HEIGTH_TABBAR) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self.adapter;
        self.adapter.tableView = _tableView;
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
        [gest setCancelsTouchesInView:NO];
        [_tableView addGestureRecognizer:gest];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefreshData)];
            header.lastUpdatedTimeLabel.hidden = YES;
            header.stateLabel.hidden = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                _tableView.mj_header = header;
            });
        });
        
        
        [_tableView registerClass:[NewChatLeftAttachTableViewCell class] forCellReuseIdentifier:[NewChatLeftAttachTableViewCell identifier]];
        [_tableView registerClass:[NewChatLeftImageTableViewCell class] forCellReuseIdentifier:[NewChatLeftImageTableViewCell identifier]];
        [_tableView registerClass:[NewChatLeftVoiceTableViewCell class] forCellReuseIdentifier:[NewChatLeftVoiceTableViewCell identifier]];
        [_tableView registerClass:[NewChatLeftTextTableViewCell class] forCellReuseIdentifier:[NewChatLeftTextTableViewCell identifier]];

        [_tableView registerClass:[NewChatRightAttachTableViewCell class] forCellReuseIdentifier:[NewChatRightAttachTableViewCell identifier]];
        [_tableView registerClass:[NewChatRightImageTableViewCell class] forCellReuseIdentifier:[NewChatRightImageTableViewCell identifier]];
        [_tableView registerClass:[NewChatRightVoiceTableViewCell class] forCellReuseIdentifier:[NewChatRightVoiceTableViewCell identifier]];
        [_tableView registerClass:[NewChatRightTextTableViewCell class] forCellReuseIdentifier:[NewChatRightTextTableViewCell identifier]];
        
        [_tableView registerClass:[ChatShowDateTableViewCell class] forCellReuseIdentifier:[ChatShowDateTableViewCell identifier]];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:wz_default_tableViewCell_identifier];

        [_tableView registerClass:[PatientServiceCommentLeftTableViewCell class] forCellReuseIdentifier:[PatientServiceCommentLeftTableViewCell identifier]];
        [_tableView registerClass:[PatientEventTableViewCell class] forCellReuseIdentifier:[PatientEventTableViewCell identifier]];
        [_tableView registerClass:[PatientEventRightTableViewCell class] forCellReuseIdentifier:[PatientEventRightTableViewCell identifier]];
        [_tableView registerClass:[PatientLeftWithTwoButtonTableViewCell class] forCellReuseIdentifier:[PatientLeftWithTwoButtonTableViewCell identifier]];
        [_tableView registerClass:[PatientServiceCommentRightTableViewCell class] forCellReuseIdentifier:[PatientServiceCommentRightTableViewCell identifier]];
        [_tableView registerClass:[PatientDoubleChooseLeftTableViewCell class] forCellReuseIdentifier:[PatientDoubleChooseLeftTableViewCell identifier]];
        [_tableView registerClass:[PatientDoubleChooseRightTableViewCell class] forCellReuseIdentifier:[PatientDoubleChooseRightTableViewCell identifier]];
        [_tableView registerClass:[PatientHealthEducationLeftTableViewCell class] forCellReuseIdentifier:[PatientHealthEducationLeftTableViewCell identifier]];
         [_tableView registerClass:[PatientHealthEducationRightTableViewCell class] forCellReuseIdentifier:[PatientHealthEducationRightTableViewCell identifier]];
        [_tableView registerClass:[PatientReceiptMessageRightTableViewCell class] forCellReuseIdentifier:[PatientReceiptMessageRightTableViewCell identifier]];
        [_tableView registerClass:[PatientReceiptMessageLeftTableViewCell class] forCellReuseIdentifier:[PatientReceiptMessageLeftTableViewCell identifier]];

    }
    
    return _tableView;
}

- (ChatInputView *)chatInputView {
    if (!_chatInputView) {
        _chatInputView = [[ChatInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 64 - H_COMMON_VIEW, self.view.frame.size.width, H_COMMON_VIEW + H_ATTACH_VIEW)];
        _chatInputView.delegate = self;
//        [_chatInputView setBackgroundColor:[UIColor lightGrayColor]];
        _chatInputView.hidden = self.hideInputView;
    }
    return _chatInputView;
}

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

- (ChatTableViewAdapter *)adapter {
    if (!_adapter) {
        _adapter = [[ChatTableViewAdapter alloc] initWithTargetUid:self.strUid chattingModule:self.module];
        _adapter.cellDelegate = self;
        _adapter.adapterDelegate = self;
    }
    return _adapter;
}

- (NSMutableArray *)arrayDisplay {
    return self.module.showingMessages;
}

- (MWPhotoBrowser *)photoBrowser
{
    if (!_photoBrowser)
    {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = YES; // 分享按钮，默认是
        _photoBrowser.displayNavArrows = NO;     // 左右分页切换，默认否
        _photoBrowser.displaySelectionButtons = NO; // 是否显示选择按钮
        _photoBrowser.alwaysShowControls = NO;  // 控制条件控件
        _photoBrowser.zoomPhotosToFill = YES;    // 是否全屏
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

- (BOOL)groupChat {
    // 单聊不能@人
    if ([self.strUid hasSuffix:@"@ChatRoom"] || [self.strUid hasSuffix:@"@SuperGroup"]) {
        return YES;
    }
    return NO;
}

@end
