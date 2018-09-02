//
//  ChatSearchResultViewController.m
//  launcher
//
//  Created by Jason Wang on 15/9/25.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatSearchResultViewController.h"
#import "ChatInputView.h"
#import <Masonry.h>
#import "MyDefine.h"
#import "ChatShowDateTableViewCell.h"
#import "RMAudioManager.h"
#import "CalculateHeightManager.h"
#import "UnifiedUserInfoManager.h"
#import "UnifiedFilePathManager.h"
#import "Slacker.h"
#import "MWPhotoBrowser.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "ChatAttachPickView.h"
#import "StreamRecordViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ChatSingleManagerViewController.h"
#import "NSDate+MsgManager.h"
#import "ChatDropListView.h"
#import "MessageMainViewController.h"
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
#import "UIColor+Hex.h"
#import "LookAttachmentViewController.h"
#import "ChatAttachMgrViewController.h"
#import "AppTaskModel.h"
#import "IMApplicationEnum.h"
#import <MintcodeIM/MintcodeIM.h>
#import "IMNickNameManager.h"
#import "TaskListModel.h"
#import "NewMissionGetMissionDetailRequest.h"
#import "NewDetailMissionViewController.h"
#import "ChatForwardLeftTableViewCell.h"
//-----------------
#import "NSDate+MsgManager.h"
#import "NewChatEventMissionRightTableViewCell.h"
#import "NewChatEventMissionLeftTableViewCell.h"
#import "ChatForwardLeftTableViewCell.h"
#import "ChatForwardRightTableViewCell.h"
#import "ChatBottomMoreBar.h"
#import "ChatSelectForwardUsersViewController.h"
#import <UIAlertView+Blocks.h>
#import <UIActionSheet+Blocks.h>

static CGFloat const duration_inputView = 0.20;

typedef void(^forwardMessageCompletion)(BOOL merge);
#define H_CELL 60
#define W_MAX_IMAGE (100 + [Slacker getXMarginFrom320ToNowScreen] * 2)     // 照片最大宽度
#define COUNT_MSG 20

@interface ChatSearchResultViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MessageManagerDelegate,MWPhotoBrowserDelegate,UIAlertViewDelegate,ChatAttachPickViewDelegate, UIScrollViewDelegate ,RMAudioManagerDelegate,ChatAttachMgrViewControllerDelegate, BaseRequestDelegate,ChatBaseTableViewCellDelegate, ChatBottomMoreBarDelegate>

/** 附件栏模式下移动键盘 */
@property (nonatomic, getter=isAttachModeMoving) BOOL attachModeMoving;
@property (nonatomic, assign) CGPoint pointViewInput;   // viewBG中心点
@property (nonatomic, assign) BOOL isInputViewMoving;   // 底部输入栏移动标记

@property (nonatomic, strong)  UITableView *tableView; // 聊天TableView



@property (nonatomic, strong)  NSString  *myAvatarPath; // 我的头像路径
@property (nonatomic) CGFloat viewInputHeight;           // inputView的高度


@property (nonatomic, strong)  NSMutableArray *arrayDisplay; // 显示的数据
@property (nonatomic, strong)  RMAudioManager  *audioManager; // 录音manager

@property (nonatomic)  BOOL  isPlayingAudio; // 是否正在播放录音
@property (nonatomic) NSInteger currPlayingVoiceTag;     // 正在播放的音频标记
@property (nonatomic)      NSInteger reSendIndex;      // 待重发Index
@property (nonatomic)  NSInteger  currentNeedPlayVoiceTag; // 当需要播放的音频单元格

@property (nonatomic)  BOOL isBubbleFirstResponde;                    // 气泡第一相应标记
@property (nonatomic)  BOOL isFailButtonFirstResponde;                // 发送失败按钮第一相应标记
@property (nonatomic, strong)   UIMenuController *popMenu;     // 弹出菜单

@property (nonatomic)  long long  lastShowDate; // 撒谎那个词需要显示的时间戳
@property (nonatomic, strong)  MessageBaseModel  *messageModel; // 消息model
//@property (nonatomic, strong)  AttachmentUploadModel  *attachmentModel; // 图片上传model
@property (nonatomic, strong)  MessageBaseModel  *uploadImageModel; // 图片上传的messageModel

// 图片浏览
@property (nonatomic, strong)  MWPhotoBrowser  *photoBrowser; // 图片浏览器
@property (nonatomic, strong)  NSMutableArray  *arrayPhotos; // 大图
@property (nonatomic, strong)  NSMutableArray  *arrayThumbs; // 小图
@property (nonatomic)  NSInteger saveIndex; // 要保存的图片index

@property (nonatomic) NSInteger currCount;               // 当前查看信息条数
@property (nonatomic) BOOL isPullRefresh;                // 标记是否是下拉刷新
@property (nonatomic) NSInteger lastCount;               // 上一次条数
@property (nonatomic) CGFloat preContentHeight;          // 上一次内容高度


@property (nonatomic, strong) MASConstraint *constraintsDropListHeight;
@property (nonatomic) BOOL dropListShow;

@property (nonatomic,strong) NSMutableArray * pathArray ;

@property (nonatomic,assign) NSInteger dataCount;

@property (nonatomic, strong) ChatBottomMoreBar *bottomTabbar;
/// 选择的 待转发消息字典 (key,value)=(clientMsgId:MessageBaseModel)
@property (nonatomic, strong) NSMutableDictionary *selectedMessagesDictionary;
@property (nonatomic, strong) NSMutableArray *originalMarkedMessageModels;
@property (nonatomic, assign) BOOL needRemove;

@end

@implementation ChatSearchResultViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:[UIColor grayBackground]];
    
    [self.navigationItem setTitle:self.strName];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setRightBarButtonItem:right];
    
    self.viewInputHeight = 50;
    self.dropListShow = NO;
    
    //获得数据
    NSArray *arrayData = [[MessageManager share] queryNewerMessageHistoryFromSqlID:self.msgid - 1 count:COUNT_MSG uid:self.strUid];

	self.arrayDisplay = [NSMutableArray array];
	[arrayData enumerateObjectsUsingBlock:^(MessageBaseModel *  _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
		if (message._type == msg_personal_reSend || message._type == msg_usefulMsgMin) {
			NSLog(@"%@", message._content);
		} else {
			[self.arrayDisplay addObject:message];
			
		}
	}];
	
    [self initCompnents];
    
    [self markRead];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[MessageManager share] setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewNeedReload) name:MTImageDidFinishedLoadNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTImageDidFinishedLoadNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[MessageManager share] setDelegate:nil];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)nil;
}

#pragma mark - Event Respond

- (void)markRead
{
    MessageBaseModel *baseModel = [self.arrayDisplay firstObject];
    // 取出该聊天所有未读消息(除去语音)
    [[MessageManager share] getAllUnReadedMessageListWithUid:self.strUid msgId:baseModel._msgId completion:^(NSArray *arrMsgId) {
        [self sendReadMessageRequestWith:arrMsgId];
    }];
}

/// 发送消息已读 (messageBaseModel)
- (void)sendReadMessageRequestWith:(NSArray *)arrMsgId
{
    [[MessageManager share] sendReadedRequestWithUid:self.strUid messages:arrMsgId];
}

// menu气泡
- (BOOL)canBecomeFirstResponder {
    return YES;
}

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

// 下拉刷新
- (void)downPullRefreshData
{
    //添加数据源

    MessageBaseModel *baseModel = [[MessageBaseModel alloc] init];
    //得到数据源数组第一个元素的Model
    baseModel= self.arrayDisplay.firstObject;
    //通过moedl得到其sqlid
    self.sqlId = baseModel._msgId;
    //取得最后一个元素之前更老的数据
    NSArray *arrayData = [[MessageManager share] queryOlderMessageHistoryFromSqlID:self.sqlId count:COUNT_MSG uid:self.strUid];
	
	NSMutableArray *messages = [NSMutableArray array];
	[arrayData enumerateObjectsUsingBlock:^(MessageBaseModel * _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
		if (message._type == msg_personal_reSend || message._type == msg_usefulMsgMin) {
			NSLog(@"%@", message._content);
		} else {
			[messages addObject:message];
		}
		
	}];
	
    if (messages.count > 0) {
        //将得到的数据插入到数据源数组前面
        NSRange range = NSMakeRange(0, messages.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.arrayDisplay insertObjects:messages atIndexes:indexSet];
        
        //添加tableview行
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
        arrayData = nil;
		messages = nil;
    }

    [self.tableView.header endRefreshing];
    
    [self markRead];
}

//上拉加载

- (void)upPullRefreshData
{
    //添加数据源
    MessageBaseModel *baseModel = [[MessageBaseModel alloc] init];
    //得到数据源数组最后一个元素的Model
    baseModel= self.arrayDisplay.lastObject;
    //通过model得到其sqlid
    self.sqlId = baseModel._msgId;
    //取得最后一个元素之后更新的数据
    NSArray *arrayData = [[MessageManager share] queryNewerMessageHistoryFromSqlID:self.sqlId count:COUNT_MSG uid:self.strUid];
	NSMutableArray *messages = [NSMutableArray array];
	[arrayData enumerateObjectsUsingBlock:^(MessageBaseModel * _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
		if (message._type == msg_personal_reSend || message._type == msg_usefulMsgMin) {
			NSLog(@"%@", message._content);
		} else {
			[messages addObject:message];
		}
		
	}];
	
    //当arrayData不为空时
    if (messages.count > 0) {
        //将得到的数据插入到数据源数组后面
        NSRange range = NSMakeRange(self.arrayDisplay.count, messages.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.arrayDisplay insertObjects:messages atIndexes:indexSet];
        
        //添加tableview行
        [self.tableView reloadData];
        //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.arrayDisplay.count - 11) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

        messages = nil;
		arrayData = nil;
    }

    [self.tableView.footer endRefreshing];
    
    [self markRead];
}

#pragma mark - Private Method
- (void)updateViewConstraints
{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (void)initCompnents
{
    self.isPullRefresh = NO;
    self.currCount = COUNT_MSG;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64) style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	
	
    // 添加动画图片的下拉刷新
    // 下拉刷新
    //上拉加载       MJRefreshAutoFooter
    MJRefreshAutoStateFooter * footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(upPullRefreshData)];
    footer.stateLabel.hidden = YES;
    
    _tableView.footer = footer;

    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downPullRefreshData)];
    ((MJRefreshStateHeader*)self.tableView.header).lastUpdatedTimeLabel.hidden = YES;
    ((MJRefreshStateHeader*)self.tableView.header).stateLabel.hidden = YES;
    [self.view addSubview:self.tableView];
    
    // Todo 设置自己头像
    //    self.myAvatarPath = [NSString stringWithFormat:@"%@%@",URLADDRESS_FILE,[[UnifiedUserInfoManager share] getBaseInfoModel].avatar];
    
    // 当前需要播放的语音cell
    self.currentNeedPlayVoiceTag = -1;
	
	[self registerChatResultTableCells];
}

- (void)registerChatResultTableCells {
	[self.tableView registerClass:[NewChatLeftAttachTableViewCell class] forCellReuseIdentifier:[NewChatLeftAttachTableViewCell identifier]];
	[self.tableView registerClass:[NewChatLeftImageTableViewCell class] forCellReuseIdentifier:[NewChatLeftImageTableViewCell identifier]];
	[self.tableView registerClass:[NewChatLeftTextTableViewCell class] forCellReuseIdentifier:[NewChatLeftTextTableViewCell identifier]];
	[self.tableView registerClass:[NewChatLeftVoiceTableViewCell class] forCellReuseIdentifier:[NewChatLeftVoiceTableViewCell identifier]];
	
	[self.tableView registerClass:[NewChatRightAttachTableViewCell class] forCellReuseIdentifier:[NewChatRightAttachTableViewCell identifier]];
	[self.tableView registerClass:[NewChatRightImageTableViewCell class] forCellReuseIdentifier:[NewChatRightImageTableViewCell identifier]];
	[self.tableView registerClass:[NewChatRightTextTableViewCell class] forCellReuseIdentifier:[NewChatRightTextTableViewCell identifier]];
	[self.tableView registerClass:[NewChatRightVoiceTableViewCell class] forCellReuseIdentifier:[NewChatRightVoiceTableViewCell identifier]];
	
	[self.tableView registerClass:[ChatForwardLeftTableViewCell class] forCellReuseIdentifier:[ChatForwardLeftTableViewCell identifier]];
	[self.tableView registerClass:[ChatForwardRightTableViewCell class] forCellReuseIdentifier:[ChatForwardRightTableViewCell identifier]];
	
}

// 判断是否需要显示时间
- (BOOL)isNeedShowDate:(long long)timeStamp
{
    // 当前model的时间和上一次显示的时间比较是否超过规定时间差
    //    if ((timeStamp - self.lastShowDate) / 1000 > INTERVAL_MAX_FORCHATSHOW)
    //    {
    //        self.lastShowDate = timeStamp;
    //        return YES;
    //    }
    //    else
    return NO;
}

// 图片下载完的刷新列表操作
- (void)tableViewNeedReload
{
    [self.tableView reloadData];
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
    }
    CMTimeShow(actualTime);
    UIImage *image=[UIImage imageWithCGImage:imageRefRect];//转化为UIImage
    
    // 得到路径
    long long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *strDate = [NSString stringWithFormat:@"%lld",timeStamp];
    NSString *strFileNameThumb = [NSString stringWithFormat:@"%@thumb.jpg",strDate];
    NSString *strPath = [[UnifiedFilePathManager share] getVideoPath
                         ];
    NSString *strThumbPath = [strPath stringByAppendingPathComponent:strFileNameThumb];
    PRINT_STRING(strThumbPath);
    [UIImageJPEGRepresentation(image, 0.3) writeToFile:strThumbPath atomically:YES];
    // 转换成相对路径
    NSString *strRelativeThumb = [[UnifiedFilePathManager share] getRelativePathWithAllPath:strThumbPath];
    
    return strRelativeThumb;
}

/* 复制消息*/
- (void)copyMessage:(NSInteger)index
{
    // 得到消息体
    MessageBaseModel *baseModel = [_arrayDisplay objectAtIndex:index];
    
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
    
    _isBubbleFirstResponde = NO;
    _isFailButtonFirstResponde = NO;
}
/* 标记为重点 */
- (void)markMessage:(NSInteger)index
{
    // 得到消息体
    MessageBaseModel *baseModel = [_arrayDisplay objectAtIndex:index];
    
    /* 在这里进行标记操作 */
    [[MessageManager share] markMessage:baseModel];

    [[MessageManager share] markMessageImportantWithModel:baseModel important:!baseModel._markImportant];
    baseModel._markImportant ^= 1;
    
    _isBubbleFirstResponde = NO;
    _isFailButtonFirstResponde = NO;
    NSIndexPath * path = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
	
	!self.refreshEmphasisDataBlock ?: self.refreshEmphasisDataBlock(YES);
	
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

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1000) {
        if (buttonIndex == 1) {
            [self copyMessage:_reSendIndex];
        }
        return;
    }
    if (actionSheet.tag == 1001) {
        if (buttonIndex == 0) {
            [self copyMessage:_reSendIndex];
        }else if (buttonIndex == 1) {
            [self markMessage:_reSendIndex];
        }
        return;
    }if (actionSheet.tag == 1002) {
        return;
    }if (actionSheet.tag == 1003) {
        if (buttonIndex == 0) {
            [self markMessage:_reSendIndex];
        }
        return;
    }
}


// 头像点击事件
- (void)headPicClicked:(UITapGestureRecognizer *)tapGesture
{
    //    UIImageView *imgViewHead = (UIImageView *)tapGesture.view;
    //    MessageBaseModel *model = [_arrayDisplay objectAtIndex:imgViewHead.tag];
    
    // 单聊只要区分收发即可
    //    _contactVC = [[ContactDetailViewController alloc] init];
    //    _userDetailVC = [[UserInfoDetailViewController alloc] init];
    //
    //    ContactDetailModel *newModel = nil;
    //    if (model._markFromReceive)
    //    {
    //        newModel = [[UnifiedSqlManager share] queryContactWithAnotherName:model._target];
    //
    //        // 创建名片VC
    //        [_contactVC set_model:newModel];
    //
    //        for (ContactDetailModel *model in _arrayFavoriteContacts)
    //        {
    //            if ([model._realName isEqualToString:_contactVC._model._realName])
    //            {
    //                _contactVC._isFavorite = YES;
    //            }
    //        }
    //        [self.navigationController pushViewController:_contactVC animated:YES];
    //
    //    }
    //    else
    //    {
    //        //        newModel = self._contactModel;
    //        for (ContactDetailModel *model in _arrayFavoriteContacts)
    //        {
    //            if ([model._realName isEqualToString:_contactVC._model._realName])
    //            {
    //                _contactVC._isFavorite = YES;
    //            }
    //        }
    //        [self.navigationController pushViewController:_userDetailVC animated:YES];
    //    }
}

- (void)newCellClick:(NSIndexPath *)path
{
    // 得到数据
    NSInteger tag = path.row;
    MessageBaseModel *baseModel = [self.arrayDisplay objectAtIndex:tag];
    
    // 区分消息类型
    if (baseModel._type == msg_personal_image)
    {
        // 封装图片数据
        MWPhoto *photo;
        NSInteger currentSelectIndex = 0;
        [self.arrayPhotos removeAllObjects];
        [self.arrayThumbs removeAllObjects];
        for (NSInteger i = 0; i < self.arrayDisplay.count; i ++)
        {
            MessageBaseModel *model = self.arrayDisplay[i];
            
            if (model._type == msg_personal_image)
            {
                if (baseModel._nativeThumbnailUrl.length == 0)
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
                    photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[UnifiedFilePathManager share] getAllPathWithRelativePath:model._nativeOriginalUrl]]];
                    [self.arrayPhotos addObject:photo];
                    
                    photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[UnifiedFilePathManager share] getAllPathWithRelativePath:model._nativeThumbnailUrl]]];
                    [self.arrayThumbs addObject:photo];
                }
            }
            if (tag == i)
            {
                currentSelectIndex = self.arrayPhotos.count - 1;
            }
            
        }
        
        // Modal
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self.photoBrowser reloadData];
        [self.photoBrowser setCurrentPhotoIndex:currentSelectIndex];
        
        [self presentViewController:nc animated:YES completion:nil];
    }
    
    else if (baseModel._type == msg_personal_voice)
    {
        if ([baseModel isFileDownloaded] == YES)
        {
            // 直接播放
            // 播放音频管理
            [self voicePlayOrStopWithVoicePath:[[UnifiedFilePathManager share] getAllPathWithRelativePath:baseModel._nativeOriginalUrl] Tag:tag];
        }
        else
        {
            self.currentNeedPlayVoiceTag = tag;
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
            fullPath = [[UnifiedFilePathManager share] getAllPathWithRelativePath:baseModel._nativeOriginalUrl];
            playerViewController =[[MPMoviePlayerViewController alloc]initWithContentURL:[[NSURL alloc] initFileURLWithPath:fullPath]];
        }
        
        [self presentMoviePlayerViewControllerAnimated:playerViewController];
        
    }
}

// 播放音频管理
- (void)voicePlayOrStopWithVoicePath:(NSString *)voicePath Tag:(NSInteger)tag
{
    self.currentNeedPlayVoiceTag = -1;
    
    // 如果正在播放
    if (self.isPlayingAudio)
    {
        // 如果是同一个气泡就需要停止
        if (tag == self.currPlayingVoiceTag)
        {
            [self.audioManager stopPlayAudio];
            
            self.isPlayingAudio = NO;
        }
        else
        {
            // 开始新的音频播放
            [self.audioManager playAudioWithPath:voicePath];
        }
        
        // 标记
        self.currPlayingVoiceTag = tag;
    }
    // 如果是新开始播放
    else
    {
        [self.audioManager playAudioWithPath:voicePath];
        
        self.currPlayingVoiceTag = tag;
        
        self.isPlayingAudio = YES;
    }
    
    // 刷新列表去显示cell的动画
    [self.tableView reloadData];
}

#pragma mark - ChatBottomMoreBar Delegate
- (void)startEditingWithFirstIndexPath:(NSIndexPath *)indexPath {
	
	[CATransaction begin];
	[self.tableView setEditing:YES animated:YES];
	[CATransaction setCompletionBlock:^{
		
		BaseSelectTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		[cell setWz_selected:YES];
		
	}];
	
	[CATransaction commit];
	
	MessageBaseModel *message = [self.arrayDisplay objectAtIndex:indexPath.row];
	[self.selectedMessagesDictionary setObject:message forKey:@(message._clientMsgId)];
	
	[self popGestureDisabled:YES];
	
	[self createBottomTabbarWithModel:message];
	
	[self.bottomTabbar canTapButtons:YES];
	
	// 存储之前的rightItems
//	[self.navigationItem setRightBarButtonItems:nil animated:YES];
	
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(resumeBottomTabbar)];
	self.navigationItem.leftBarButtonItem = leftItem;
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

- (BOOL)canForwardSingleMessage:(MessageBaseModel *)message {
	BOOL canForward = message._type == msg_personal_text ||
	message._type == msg_personal_mergeMessage ;
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
																									  sessionNickName:self.strName
																											 messages:messages
																											  isGroup:[ContactDetailModel isGroupWithTarget:self.strUid]
																										   completion:^{ [weakSelf resumeBottomTabbar]; }];
		[self presentViewController:VC animated:YES completion:nil];
	};
	
	return completion;
}

- (void)resumeBottomTabbar {
	[self.bottomTabbar removeFromSuperview];
	[self.selectedMessagesDictionary removeAllObjects];
	[self.originalMarkedMessageModels removeAllObjects];
	[self popGestureDisabled:NO];
	
	[self showLeftItemWithSelector:nil];
//	[self.navigationItem setRightBarButtonItems:self.previousRightItems animated:YES];
//	self.previousRightItems = nil;
	
	[self.tableView setEditing:NO animated:YES];
}

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
		BOOL markImportant = !self.needRemove;// remove为YES时markImportant为NO 请求前都为YES,请求时请求后为NO
		dispatch_group_t dispatchGroup = dispatch_group_create();
		__block NSString *errorMessage;
		[messages enumerateObjectsUsingBlock:^(MessageBaseModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
			
			dispatch_group_enter(dispatchGroup);
			BOOL previousImmportantMark = obj._markImportant;
			obj._markImportant = markImportant ? NO : YES;
			[[MessageManager share] markMessage:obj completion:^(BOOL success) {
				if (!success) {
					errorMessage = LOCAL(ERROROTHER);
					obj._markImportant = previousImmportantMark;
				} else {
					obj._markImportant = !obj._markImportant;
				}
				
				[[MessageManager share] markMessageImportantWithModel:obj important:obj._markImportant];
				
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

			!self.refreshEmphasisDataBlock ?: self.refreshEmphasisDataBlock(YES);
			[self.tableView reloadData];
			
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

#pragma mark - UITableView Delegate DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    MessageBaseModel *model = self.arrayDisplay[indexPath.row];

	if (model._type == IM_Applicaion_task) {
		height = [CalculateHeightManager fetchAppCardHeightWithBaseModel:model needShowName:NO];
    } else
    {
		height = [CalculateHeightManager fetchHeightWhileChattingWithBaseModel:model needShowName:NO];
	}
	
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayDisplay.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.messageModel = self.arrayDisplay[indexPath.row];
	
    if (self.messageModel._type == IM_Applicaion_task) {
        id cell;
        AppTaskModel *taskModel = [AppTaskModel mj_objectWithKeyValues:self.messageModel.appModel.applicationDetailDictionary];
        if (![self.messageModel._toLoginName isEqualToString:self.strUid])
        {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"NewChatEventMissionLeftTableViewCellID"];
            if (!cell)
            {
                cell = [[NewChatEventMissionLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewChatEventMissionLeftTableViewCellID"];
            }
        }
        else
        {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"NewChatEventMissionRightTableViewCellID"];
            if (!cell)
            {
                cell = [[NewChatEventMissionRightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewChatEventMissionRightTableViewCellID"];
            }
        }
        
//        __weak typeof(self) weakSelf = self;
//        [cell setShowDetail:^{
//			__strong typeof(weakSelf) strongSelf = weakSelf;
//			[strongSelf sendNewMissionGetMissionDetailRequestWithMessageBaseModel:strongSelf.messageModel];
//        }];
		
        [cell setCellData:self.messageModel];
        return cell;
    }

    
    if (![self.messageModel._toLoginName isEqualToString:self.strUid])
    {
        BOOL hid = YES;
        NSString *nickName = @"";
        NSString *userName = self.strUid;
        if (self.IsGroup) {
            nickName = [self.messageModel getNickName];
            userName = [self.messageModel getUserName];
            
            nickName = [IMNickNameManager showNickNameWithOriginNickName:nickName userId:userName];
            
            hid = NO;
        }
        switch (self.messageModel._type)
        {
            case msg_personal_text:
            {
                NewChatLeftTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatLeftTextTableViewCell identifier]];
                [cell setDelegate:self];
                [cell setHeadIconWithUid:userName];
				[cell setInteractiveMode:ChatBaseCellInteractiveModeInChattingRecords];
                [cell setData:self.messageModel];
                [cell setEmphasisIsShow:self.messageModel._markImportant];
                [cell setRealName:nickName hidden:hid];
                return cell;
                
            }
                break;
                
            case msg_personal_voice:
            {
                NewChatLeftVoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatLeftVoiceTableViewCell identifier]];
                [cell setDelegate:self];
                [cell setHeadIconWithUid:userName];
                // 计算音频长度
                //                float length = [RMAudioManager calculateAudioDurationWithPath:[[UnifiedFilePathManager share] getAllPathWithRelativePath:self.messageModel._imgOriginalUrl]];
                CGFloat length = self.messageModel.attachModel.audioLength;
                [cell showVoiceMessageTime:length unreadMark:self.messageModel._markReaded];
				[cell setInteractiveMode:ChatBaseCellInteractiveModeInChattingRecords];
                [cell setData:self.messageModel];
                [cell setEmphasisIsShow:self.messageModel._markImportant];
                // 判断是否需要播放动画
                if (self.isPlayingAudio)
                {
                    if (self.currPlayingVoiceTag == indexPath.row)
                    {
                        [cell startPlayVoiceWithTime:length];
                    }
                    else
                    {
                        [cell stopPlayVoice];
                    }
                }
                else
                {
                    [cell stopPlayVoice];
                }
                [cell setRealName:nickName hidden:hid];

                return cell;
            }
                
                break;
                
            case msg_personal_image:
            {
                NewChatLeftImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatLeftImageTableViewCell identifier]];
                [cell setDelegate:self];
                [cell setHeadIconWithUid:userName];
                [cell showSendImageMessageBaseModel:self.messageModel];
				[cell setInteractiveMode:ChatBaseCellInteractiveModeInChattingRecords];
                [cell setData:self.messageModel];
                [cell setEmphasisIsShow:self.messageModel._markImportant];
                [cell setRealName:nickName hidden:hid];

                return cell;
                
            }
                
                break;
            
            case msg_personal_file:
            {
                // 生成附件图片
                NewChatLeftAttachTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatLeftAttachTableViewCell identifier]];
                [cell setDelegate:self];
                [cell setHeadIconWithUid:userName];
				[cell setInteractiveMode:ChatBaseCellInteractiveModeInChattingRecords];
                [cell setData:self.messageModel];
                [cell setEmphasisIsShow:self.messageModel._markImportant];
                [cell setAttachmentData:self.messageModel.attachModel];
                [cell setRealName:nickName hidden:hid];

                return cell;
            }
                break;
            case msg_personal_mergeMessage:
            {
                ChatForwardLeftTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ChatForwardLeftTableViewCell identifier]];
                [cell setHeadIconWithUid:self.strUid];
				[cell setInteractiveMode:ChatBaseCellInteractiveModeInChattingRecords];
                [cell setData:self.messageModel];
                [cell setEmphasisIsShow:self.messageModel._markImportant];
                [cell setDelegate:self];
                [cell setRealName:[self.messageModel getNickName] hidden:NO];
				return cell;
			}
				break;
        }
        
    }
    else
    {
        switch (self.messageModel._type)
        {
            case msg_personal_text:
            {
                NewChatRightTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatRightTextTableViewCell identifier]];
                [cell setDelegate:self];
				[cell setInteractiveMode:ChatBaseCellInteractiveModeInChattingRecords];
                [cell setData:self.messageModel];
                [cell showStatus:self.messageModel._markStatus];
                [cell setEmphasisIsShow:self.messageModel._markImportant];

                return cell;
                
            }
                break;
                
            case msg_personal_voice:
            {
                NewChatRightVoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatRightVoiceTableViewCell identifier]];
                [cell setDelegate:self];
                CGFloat length = 0;
                if (self.messageModel._nativeOriginalUrl.length == 0)
                {
                    length = self.messageModel.attachModel.audioLength;
                }
                else
                {
                    // 计算音频长度
                    length = [RMAudioManager calculateAudioDurationWithPath:[[MsgFilePathMgr share] getAllPathWithRelativePath:self.messageModel._nativeOriginalUrl]];
                }
                
                [cell showVoiceMessageTime:length];
                [cell showStatus:self.messageModel._markStatus];
				[cell setInteractiveMode:ChatBaseCellInteractiveModeInChattingRecords];
                [cell setData:self.messageModel];
                [cell setEmphasisIsShow:self.messageModel._markImportant];

                // 判断是否需要播放动画
                if (self.isPlayingAudio)
                {
                    if (self.currPlayingVoiceTag == indexPath.row)
                    {
                        [cell startPlayVoiceWithTime:length];
                    }
                    else
                    {
                        [cell stopPlayVoice];
                    }
                }
                else
                {
                    [cell stopPlayVoice];
                }
                
                return cell;
            }
                
                break;
                
            case msg_personal_image:
            {
                NewChatRightImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatRightImageTableViewCell identifier]];
                [cell setDelegate:self];
                [cell showStatus:self.messageModel._markStatus progress:nil];
                [cell showSendImageMessage:self.messageModel];
                [cell showStatus:self.messageModel._markStatus];
				[cell setInteractiveMode:ChatBaseCellInteractiveModeInChattingRecords];
                [cell setData:self.messageModel];
                [cell setEmphasisIsShow:self.messageModel._markImportant];

                return cell;
                
            }
                
                break;

            case msg_personal_file:
            {
                // 生成附件图片
                NewChatRightAttachTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatRightAttachTableViewCell identifier]];
                [cell setDelegate:self];
                [cell showStatus:self.messageModel._markStatus];
				[cell setInteractiveMode:ChatBaseCellInteractiveModeInChattingRecords];
                [cell setData:self.messageModel];
                [cell setEmphasisIsShow:self.messageModel._markImportant];
                [cell setAttachmentData:self.messageModel.attachModel];
                
                return cell;
            }
            case msg_personal_mergeMessage:
            {
                ChatForwardRightTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ChatForwardRightTableViewCell identifier]];
				[cell setInteractiveMode:ChatBaseCellInteractiveModeInChattingRecords];
                [cell setData:self.messageModel];
                [cell setEmphasisIsShow:self.messageModel._markImportant];
                [cell setDelegate:self];
                return cell;
            }
                break;
        }
        
    }
    
    ChatShowDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChatShowDateTableViewCell identifier]];
    if (!cell)
    {
        cell = [[ChatShowDateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ChatShowDateTableViewCell identifier]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell showDateAndEvent:self.messageModel ifEvent:NO];
        
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	[UIView performWithoutAnimation:^{
		[cell layoutIfNeeded];
		
		if (![tableView isEditing]) {
			return;
		}
		// 不知道为啥一定要在这里设置selected才有效果
		MessageBaseModel *message = [self.arrayDisplay objectAtIndex:indexPath.row];
		BOOL isSelected = [self.selectedMessagesDictionary objectForKey:@(message._clientMsgId)] ? YES : NO;
		if (![cell isKindOfClass:[BaseSelectTableViewCell class]]) {
			return;
		}
		
		[(BaseSelectTableViewCell *)cell setWz_selected:isSelected];
	}];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	if (!tableView.isEditing) { return NO; }
	MessageBaseModel *message = [self.arrayDisplay objectAtIndex:indexPath.row];
	
	return message._type != msg_other_timeStamp && message._type != msg_personal_alert && message._type != msg_personal_reSend && message._type != IM_Applicaion_task;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath { return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert; }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	MessageBaseModel *message = [self.arrayDisplay objectAtIndex:indexPath.row];
    
	if (![tableView isEditing]) {
        if (message._type == IM_Applicaion_task) {
            [self sendNewMissionGetMissionDetailRequestWithMessageBaseModel:message];
        }
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

#pragma mark - ChatBaseTableViewCell Delegate

- (BOOL)chatBaseTableViewCellIsEdtingMode:(ChatBaseTableViewCell *)cell {
	return [self.tableView isEditing];
}

- (BOOL)chatBaseTableViewCellCanBecomeFirstResponder:(ChatBaseTableViewCell *)cell menuImageView:(MenuImageView *)menuImageView {
	return YES;
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToEmphasisAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"emphasis");
	[self markMessage: indexPath.row];
	
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToCancelEmphasisAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"cancel emphasis");
	[self markMessage:indexPath.row];
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToCopyAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"copy");
	[self copyMessage:indexPath.row];
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell clickedToMoreAtIndexPath:(NSIndexPath *)indexPath {
	[self startEditingWithFirstIndexPath:indexPath];
}

- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell tappedAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageBaseModel *baseModel = [self.arrayDisplay objectAtIndex:indexPath.row];
    if (baseModel._type != msg_personal_image) {
        [self newCellClick:indexPath];
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

#pragma mark - ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //    if (scrollView == _tableView) {
    //        self.viewInputHeight = H_COMMON_VIEW;
    //        [self refreshChatView];
    //    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentSize.height >CGRectGetHeight(scrollView.bounds)
        && scrollView.contentOffset.y < 5) {
        _preContentHeight = self.tableView.contentSize.height;
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

#pragma mark - RMAudioManager Delegate
// 完成播放音频
- (void)RMAudioManagerDelegateCallBack_AudioDidFinishPlaying
{
    // 标记
    self.isPlayingAudio = NO;
}

#pragma mark - MessageDelegate
// 语音下载完成刷新该条语音未读
- (void)MessageManagerDelegateCallBack_FinishDownAudioWithMessageBaseModel:(MessageBaseModel *)model
{
    if (self.currentNeedPlayVoiceTag >= 0)
    {
        MessageBaseModel *baseModel = [self.arrayDisplay objectAtIndex:self.currentNeedPlayVoiceTag];
        
        if (baseModel._markFromReceive)
        {
            baseModel._markReaded = YES;
            // 把已读语音上传
            NSArray *arrMsgId = @[baseModel];
            [self sendReadMessageRequestWith:arrMsgId];
        }
        
        // 播放音频管理
        [self voicePlayOrStopWithVoicePath:[[MsgFilePathMgr share] getAllPathWithRelativePath:baseModel._nativeOriginalUrl] Tag:self.currentNeedPlayVoiceTag];
        
        NSIndexPath * path = [NSIndexPath indexPathForRow:_reSendIndex inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)sendNewMissionGetMissionDetailRequestWithMessageBaseModel:(MessageBaseModel *)model {
	MessageAppModel *appModel = model.appModel;
	TaskListModel *taskListModel = [TaskListModel new];
	AppTaskModel *taskModel = [AppTaskModel mj_objectWithKeyValues:appModel.applicationDetailDictionary];
    NSLog(@"%@",appModel.applicationDetailDictionary);
	if (taskModel.id.length != 0)
	{
		taskListModel.showId = taskModel.id;
        NSLog(@"task");
	}
	else
	{
		// 任务系统消息
		taskListModel.showId = appModel.msgRMShowID;
        NSLog(@"app");
	}
    NSLog(@"%@",taskListModel.showId);
	NewMissionGetMissionDetailRequest *request = [[NewMissionGetMissionDetailRequest alloc] initWithDelegate:self];
	[request getDetailTaskWithId:taskListModel.showId];
	[self postLoading];
}

#pragma mark - ChatAttachMrgViewController Delegate

// 附件下载完毕的委托回调
- (void)ChatAttachMgrViewControllerDelegateCallBack_finishDownloadAndLookAttachWithFileUrl:(NSString *)fileUrl
{
    [self lookAttachmentWithFileUrl:fileUrl];
}

- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
	if ([request isKindOfClass:[NewMissionGetMissionDetailRequest class]]) {
		[self hideLoading];
		NewMissionDetailModel *detailModel = [(NewMissionGetMissionDetailResponse *)response detailModel];
		
		NewDetailMissionViewController *MDVC = [[NewDetailMissionViewController alloc] initWithOnlyShowID:detailModel.showId];
		MDVC.isFirstVC = YES;
		[self.navigationController pushViewController:MDVC animated:YES];
		
	}
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - MWPhotoBrowser
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
//    NSLog(@"%ld(unsigned long)",self.arrayThumbs.count);
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
                     otherButtonTitles:LOCAL(CALENDAR_ADD_SAVE),nil];
    [cantRecordAlert show];
}


#pragma mark - getter & setter
- (NSString *)strUid
{
    if (!_strUid)
    {
        _strUid = @"";
    }
    return _strUid;
}

- (NSString *)strName
{
    if (!_strName)
    {
        _strName = @"";
    }
    return _strName;
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

- (NSMutableDictionary *)selectedMessagesDictionary {
	if (!_selectedMessagesDictionary) {
		_selectedMessagesDictionary = [NSMutableDictionary dictionary];
	}
	return _selectedMessagesDictionary;
}

- (NSMutableArray *)originalMarkedMessageModels {
	if (!_originalMarkedMessageModels) {
		_originalMarkedMessageModels = [NSMutableArray array];
	}
	return  _originalMarkedMessageModels;
}

@end
