//
//  HMHistoryChatViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/4/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMHistoryChatViewController.h"
#import "ChatInputView.h"
#import <Masonry.h>
#import "MyDefine.h"
#import "ChatShowDateTableViewCell.h"
#import "RMAudioManager.h"
#import "CalculateHeightManager.h"
#import "Slacker.h"
#import "MWPhotoBrowser.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "ChatAttachPickView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NSDate+MsgManager.h"
#import "NewChatRightTextTableViewCell.h"
#import "NewChatRightVoiceTableViewCell.h"
#import "NewChatRightImageTableViewCell.h"
#import "NewChatLeftTextTableViewCell.h"
#import "NewChatLeftImageTableViewCell.h"
#import "NewChatLeftVoiceTableViewCell.h"
#import "NewChatLeftAttachTableViewCell.h"
#import "NewChatRightAttachTableViewCell.h"
#import "UIColor+Hex.h"
#import "AppTaskModel.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "ChatIMConfigure.h"
#import "NSDate+MsgManager.h"
#import "PatientServiceCommentLeftTableViewCell.h"
#import "PatientEventTableViewCell.h"
#import "PatientEventRightTableViewCell.h"
#import "IMMessageHandlingCenter.h"
#import "IMNewsModel.h"
#import "PatientHealthEducationLeftTableViewCell.h"
#import "PatientHealthEducationRightTableViewCell.h"
#import "PatientDoubleChooseLeftTableViewCell.h"

static CGFloat const duration_inputView = 0.20;
/// 消息显示时间的最大间隔 (300s * 1000)
static NSInteger const wz_max_timeInterval = 300000;

#define H_CELL 60
#define W_MAX_IMAGE (100 + [Slacker getXMarginFrom320ToNowScreen] * 2)     // 照片最大宽度
#define COUNT_MSG 20
@interface HMHistoryChatViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MessageManagerDelegate,MWPhotoBrowserDelegate,UIAlertViewDelegate,ChatAttachPickViewDelegate, UIScrollViewDelegate ,RMAudioManagerDelegate,ChatBaseTableViewCellDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
/** 附件栏模式下移动键盘 */
@property (nonatomic, getter=isAttachModeMoving) BOOL attachModeMoving;
@property (nonatomic, assign) CGPoint pointViewInput;   // viewBG中心点
@property (nonatomic, assign) BOOL isInputViewMoving;   // 底部输入栏移动标记

@property (nonatomic, strong)  NSString  *myAvatarPath; // 我的头像路径
@property (nonatomic) CGFloat viewInputHeight;           // inputView的高度


@property (nonatomic, strong)  NSMutableArray *arrayDisplay; // 显示的数据
@property (nonatomic, strong)  NSMutableArray *arrayDataList;
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

@property (nonatomic, strong) NSMutableDictionary *dateDictionary;

@property (nonatomic, assign) long long latestDateInterval;

@property (nonatomic, assign)  WZImageShowMenu  showMenu; // 长按事件菜单
@property (nonatomic, assign)  long long oldestRequestMSGID; // 每次网络请求的历史数据最老数据的msgID
@property (nonatomic) BOOL isOnline;   //是否走http

@property (nonatomic) long long begainMsgid;       //按时间段删选聊天记录的最早消息msgid
@property (nonatomic) long long endMsgid;       //按时间段删选聊天记录的最晚消息msgid

@end

@implementation HMHistoryChatViewController

- (instancetype)initMeaageListWithStrUid:(NSString *)strUid begainMsgid:(long long)begainMsgid endMsgid:(long long)endMsgid {
    if (self = [super init]) {
        //获得数据
        self.strUid = strUid;
        self.begainMsgid = begainMsgid;
        self.endMsgid = endMsgid;
        self.oldestRequestMSGID = endMsgid;
        [self at_postLoading];
        [[MessageManager share] getHistoryMessageWithUid:strUid messageCount:COUNT_MSG endTimestamp:self.oldestRequestMSGID completion:^(NSArray *messages, BOOL success) {
            [self at_hideLoading];

            if (!success) {
                //获取失败
                return;
            }
            NSArray *showList = @[];
            
            if (self.begainMsgid && self.begainMsgid > 0) {
                showList = [self dealWithMessageListIsLaterThanBeaginTime:self.begainMsgid messageList:messages];
            }
            else {
                showList = messages;
            }
            
            self.arrayDataList = [NSMutableArray arrayWithArray:showList];
            self.arrayDisplay = [NSMutableArray arrayWithArray:[self handleDateIfNeedWithMessages:self.arrayDataList]];
            [self.tableView reloadData];
            [self performSelector:@selector(scrollToBottomWithAnimated:) withObject:nil afterDelay:0.01];
            if (showList.count > 0) {
                MessageBaseModel *temp = showList.firstObject;
                self.oldestRequestMSGID = temp._msgId;
               
            }
            self.isOnline = YES;
        }];
    }
    return self;
}

- (instancetype)initFromSomeOneMessageWithMessageId:(long long)msgid strUid:(NSString *)strUid{
    if (self = [super init]) {
        self.msgid = msgid;
        self.strUid = strUid;

        //获得数据
        NSArray *arrayData = [[MessageManager share] queryNewerMessageHistoryFromSqlID:msgid - 1 count:COUNT_MSG uid:strUid];
        self.arrayDataList = [NSMutableArray arrayWithArray:arrayData];
        self.arrayDisplay = [NSMutableArray arrayWithArray:[self handleDateIfNeedWithMessages:self.arrayDataList]];

    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:[UIColor grayBackground]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationItem setTitle:self.strName];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setRightBarButtonItem:right];
    
    
    
    self.viewInputHeight = 50;
    self.dropListShow = NO;
    
    [self initCompnents];
    
    [self makrRead];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[IMMessageHandlingCenter sharedInstance] registerDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self resignKeyBoard];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[IMMessageHandlingCenter sharedInstance] deregisterDelegate:self];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)nil;
}

#pragma mark - Event Respond
// 处理筛选出某一时间点后的消息
- (NSArray *)dealWithMessageListIsLaterThanBeaginTime:(long long)beginTime messageList:(NSArray <MessageBaseModel *>*)messageList{
    MessageBaseModel *temp = messageList.firstObject;
    if (temp._msgId >= beginTime) {
        // 此次请求下来的最早的一条消息比开始时间晚（说明还有消息未请求下来）
        return messageList;
    }
    else {
        // 此次请求下来的最早的一条消息比开始时间早（说明这个时间段内都请求下来了，还有多余的消息，要进行筛选）
        __block NSMutableArray *tempArr = [NSMutableArray array];
        [messageList enumerateObjectsUsingBlock:^(MessageBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 筛选出比开始时间早的消息
            if (obj._msgId < beginTime) {
                [tempArr addObject:obj];
            }
            else {
                return;
            }
        }];
        NSMutableArray *mutbMessageArr = [NSMutableArray arrayWithArray:messageList];
        [mutbMessageArr removeObjectsInArray:tempArr];
        return mutbMessageArr;
    }
}
- (void)scrollToBottomWithAnimated:(BOOL)animated {
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if (rows <= 0) {
        return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:rows - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
- (void)makrRead
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
    if (self.isOnline) {
        // http
        [[MessageManager share] getHistoryMessageWithUid:self.strUid messageCount:COUNT_MSG endTimestamp:self.oldestRequestMSGID completion:^(NSArray *arrayData, BOOL success) {
            if (!success) {
                //获取失败
                return;
            }
            NSArray *messageList = @[];
            if (self.begainMsgid && self.begainMsgid > 0) {
                messageList = [self dealWithMessageListIsLaterThanBeaginTime:self.begainMsgid messageList:arrayData];
            }
            else {
                messageList = arrayData;
            }
            if (messageList.count > 0) {
                //将得到的数据插入到数据源数组前面
                NSRange range = NSMakeRange(0, messageList.count);
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                [self.arrayDataList insertObjects:messageList atIndexes:indexSet];
                self.arrayDisplay = [NSMutableArray arrayWithArray:[self handleDateIfNeedWithMessages:self.arrayDataList]];
                //添加tableview行
                [self.tableView reloadData];
                // 分页加载 滚到拉取数量行 以保证页面平稳
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem: messageList.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
                MessageBaseModel *temp = messageList.firstObject;
                self.oldestRequestMSGID = temp._msgId;
            }
            else {
                [self at_postError:@"没有更多数据了"];
            }
            
            [self.tableView.mj_header endRefreshing];
            
        }];
    }
    else {
        // 本地
        //添加数据源
        
        MessageBaseModel *baseModel = [[MessageBaseModel alloc] init];
        //得到数据源数组第一个元素的Model
        baseModel= self.arrayDataList.firstObject;
        //通过moedl得到其sqlid
        self.sqlId = baseModel._msgId;
        //取得最后一个元素之前更老的数据
        NSArray *arrayData = [[MessageManager share] queryOlderMessageHistoryFromSqlID:self.sqlId count:COUNT_MSG uid:self.strUid];
        //当arrayData不为空时
        if (arrayData.count > 0) {
            //将得到的数据插入到数据源数组前面
            NSRange range = NSMakeRange(0, arrayData.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.arrayDataList insertObjects:arrayData atIndexes:indexSet];
            self.arrayDisplay = [NSMutableArray arrayWithArray:[self handleDateIfNeedWithMessages:self.arrayDataList]];
            //添加tableview行
            [self.tableView reloadData];
            // 分页加载 滚到拉取数量行 以保证页面平稳
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem: arrayData.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
            arrayData = nil;
        }
        
        [self.tableView.mj_header endRefreshing];
        
        [self makrRead];
    }
    
}

//上拉加载

- (void)upPullRefreshData
{
    if (!self.isOnline) {
        // 本地
        //添加数据源
        MessageBaseModel *baseModel = [[MessageBaseModel alloc] init];
        //得到数据源数组最后一个元素的Model
        baseModel= self.arrayDataList.lastObject;
        //通过model得到其sqlid
        self.sqlId = baseModel._msgId;
        //取得最后一个元素之后更新的数据
        NSArray *arrayData = [[MessageManager share] queryNewerMessageHistoryFromSqlID:self.sqlId count:COUNT_MSG uid:self.strUid];
        //当arrayData不为空时
        if (arrayData.count > 0) {
            //将得到的数据插入到数据源数组后面
            NSRange range = NSMakeRange(self.arrayDataList.count, arrayData.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.arrayDataList insertObjects:arrayData atIndexes:indexSet];
            self.arrayDisplay = [NSMutableArray arrayWithArray:[self handleDateIfNeedWithMessages:self.arrayDataList]];
            
            //添加tableview行
            [self.tableView reloadData];
            //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.arrayDisplay.count - 11) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            
            arrayData = nil;
        }
        
        [self.tableView.mj_footer endRefreshing];
        
        [self makrRead];
    }
    
}


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
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    [self.tableView addGestureRecognizer:gest];
    // 添加动画图片的下拉刷新
    // 下拉刷新
    //上拉加载       MJRefreshAutoFooter
    MJRefreshAutoStateFooter * footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(upPullRefreshData)];
    footer.stateLabel.hidden = YES;
    
    _tableView.mj_footer = footer;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downPullRefreshData)];
    ((MJRefreshStateHeader*)self.tableView.mj_header).lastUpdatedTimeLabel.hidden = YES;
    ((MJRefreshStateHeader*)self.tableView.mj_header).stateLabel.hidden = YES;
    [self.view addSubview:self.tableView];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    // Todo 设置自己头像
    //    self.myAvatarPath = [NSString stringWithFormat:@"%@%@",URLADDRESS_FILE,[[UnifiedUserInfoManager share] getBaseInfoModel].avatar];
    
    // 当前需要播放的语音cell
    self.currentNeedPlayVoiceTag = -1;
    
    [self.tableView registerClass:[NewChatLeftAttachTableViewCell class] forCellReuseIdentifier:[NewChatLeftAttachTableViewCell identifier]];
    [self.tableView registerClass:[NewChatLeftImageTableViewCell class] forCellReuseIdentifier:[NewChatLeftImageTableViewCell identifier]];
    [self.tableView registerClass:[NewChatLeftTextTableViewCell class] forCellReuseIdentifier:[NewChatLeftTextTableViewCell identifier]];
    [self.tableView registerClass:[NewChatLeftVoiceTableViewCell class] forCellReuseIdentifier:[NewChatLeftVoiceTableViewCell identifier]];
    
    [self.tableView registerClass:[NewChatRightAttachTableViewCell class] forCellReuseIdentifier:[NewChatRightAttachTableViewCell identifier]];
    [self.tableView registerClass:[NewChatRightImageTableViewCell class] forCellReuseIdentifier:[NewChatRightImageTableViewCell identifier]];
    [self.tableView registerClass:[NewChatRightTextTableViewCell class] forCellReuseIdentifier:[NewChatRightTextTableViewCell identifier]];
    [self.tableView registerClass:[NewChatRightVoiceTableViewCell class] forCellReuseIdentifier:[NewChatRightVoiceTableViewCell identifier]];
    [self.tableView registerClass:[PatientServiceCommentLeftTableViewCell class] forCellReuseIdentifier:[PatientServiceCommentLeftTableViewCell identifier]];
    [self.tableView registerClass:[PatientEventTableViewCell class] forCellReuseIdentifier:[PatientEventTableViewCell identifier]];
    [self.tableView registerClass:[PatientEventRightTableViewCell class] forCellReuseIdentifier:[PatientEventRightTableViewCell identifier]];
    [self.tableView registerClass:[PatientHealthEducationLeftTableViewCell class] forCellReuseIdentifier:[PatientHealthEducationLeftTableViewCell identifier]];
    
    [self.tableView registerClass:[PatientHealthEducationRightTableViewCell class] forCellReuseIdentifier:[PatientHealthEducationRightTableViewCell identifier]];
    [self.tableView registerClass:[PatientDoubleChooseLeftTableViewCell class] forCellReuseIdentifier:[PatientDoubleChooseLeftTableViewCell identifier]];
}

- (void)resignKeyBoard
{
    //    self.viewInputHeight = 50;
    [self.view setNeedsUpdateConstraints];
    
    [self resignDropList];
}

- (void)resignDropList
{
    self.dropListShow = NO;
    
    self.constraintsDropListHeight.offset = 0;
    
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
//- (NSString *)videoScreenShotWithURL:(NSString *)videoUrl
//{
//    // 缩略图
//    //创建URL
//    NSURL *url= [[NSURL alloc] initFileURLWithPath:videoUrl];    //根据url创建AVURLAsset
//    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:url];
//    //根据AVURLAsset创建AVAssetImageGenerator
//    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
//    // 保证截图方向
//    imageGenerator.appliesPreferredTrackTransform = YES;
//    /*截图
//     * requestTime:缩略图创建时间
//     * actualTime:缩略图实际生成的时间
//     */
//    NSError *error = nil;
//    CMTime time = CMTimeMakeWithSeconds(0.0, 1);//CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
//    CMTime actualTime;
//    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
//    CGRect rect =CGRectMake(0, 0, IOS_SCREEN_WIDTH, IOS_SCREEN_HEIGHT - 100);
//    CGImageRef imageRefRect =CGImageCreateWithImageInRect(cgImage, rect);
//    if(error){
//        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
//    }
//    CMTimeShow(actualTime);
//    UIImage *image=[UIImage imageWithCGImage:imageRefRect];//转化为UIImage
//
//    // 得到路径
//    long long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
//    NSString *strDate = [NSString stringWithFormat:@"%lld",timeStamp];
//    NSString *strFileNameThumb = [NSString stringWithFormat:@"%@thumb.jpg",strDate];
//    NSString *strPath = [[UnifiedFilePathManager share] getVideoPath
//                         ];
//    NSString *strThumbPath = [strPath stringByAppendingPathComponent:strFileNameThumb];
//    PRINT_STRING(strThumbPath);
//    [UIImageJPEGRepresentation(image, 0.3) writeToFile:strThumbPath atomically:YES];
//    // 转换成相对路径
//    NSString *strRelativeThumb = [[UnifiedFilePathManager share] getRelativePathWithAllPath:strThumbPath];
//
//    return strRelativeThumb;
//}

/* 复制消息*/
- (void)copyMessage:(id)sender
{
    // 得到消息体
    MessageBaseModel *baseModel = [_arrayDisplay objectAtIndex:_reSendIndex];
    
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
- (void)markMessage:(id)sender
{
    // 得到消息体
    MessageBaseModel *baseModel = [_arrayDisplay objectAtIndex:_reSendIndex];
    
    /* 在这里进行标记操作 */
    [[MessageManager share] markMessage:baseModel];
    
    [[MessageManager share] markMessageImportantWithModel:baseModel important:!baseModel._markImportant];
    baseModel._markImportant ^= 1;
    
    _isBubbleFirstResponde = NO;
    _isFailButtonFirstResponde = NO;
    NSIndexPath * path = [NSIndexPath indexPathForRow:_reSendIndex inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
}

// 打开附件浏览VC
//- (void)lookAttachmentWithFileUrl:(NSString *)fileUrl
//{
//    // 获取附件类型
//    Extentsion_kind extentsion = [[UnifiedFilePathManager share] takeFileExtensionWithString:fileUrl];
//    if (extentsion == extension_office || extentsion == extension_txt || extentsion == extension_htm)
//    {
//        // 获得全部路径
//        NSString *fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:fileUrl];
//        LookAttachmentViewController *lookVC = [[LookAttachmentViewController alloc] initWithFilePath:fullPath];
//        [self.navigationController pushViewController:lookVC animated:YES];
//    }
//    else
//    {
//        [self postError:LOCAL(UNSUPPORT)];
//    }
//}

// 发送失败按钮单击事件
- (void)failTapGesture:(UITapGestureRecognizer *)gesture
{
    //    self.isFailButtonFirstResponde = YES;
    //
    //    // 还原布局
    //    //    [self resignKeyBoard];
    //
    //    UIImageView *imageView = (UIImageView *)gesture.view;
    //
    //    // 未发送成功的才能重发
    //    NSInteger index = imageView.tag;
    //    MessageBaseModel *model = [self.arrayDisplay objectAtIndex:index];
    //    if (model._markStatus == status_send_failed)
    //    {
    //        [imageView becomeFirstResponder];
    //
    //        self.popMenu = [UIMenuController sharedMenuController];
    //
    //        UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"重发" action:@selector(resendMessage:)];
    //
    //        NSArray *menuItems = [NSArray arrayWithObjects:item1,nil];
    //        [self.popMenu setMenuItems:menuItems];
    //        [self.popMenu setArrowDirection:UIMenuControllerArrowDown];
    //        [self.popMenu setTargetRect:imageView.frame inView:imageView.superview];
    //        [self.popMenu setMenuVisible:YES animated:YES];
    //
    //        // 标记重发序号
    //        self.reSendIndex = index;
    //    }
}

/// 处理时间，有需要则加入时间显示条
- (NSArray *)handleDateIfNeedWithMessages:(NSArray *)messages {
    NSMutableArray *messageList = [NSMutableArray array];
    
    NSMutableDictionary *dictionaryTmp = [self.dateDictionary mutableCopy];
    
    long long lastMessageCreateDate = 0;
    for (NSInteger i = 0; i < [messages count]; i ++) {
        MessageBaseModel *message = [messages objectAtIndex:i];
        MessageBaseModel *dateMessage = nil;
        
        if (message._type == msg_usefulMsgMin) {
            continue;
        }
        
        if ([dictionaryTmp objectForKey:[NSNumber numberWithLongLong:message._msgId]]) {
            dateMessage = [[MessageBaseModel alloc] initWithTimeStamp:message._msgId];
            lastMessageCreateDate = message._msgId;
            [dictionaryTmp removeObjectForKey:[NSNumber numberWithLongLong:message._msgId]];
        }
        
        else if (lastMessageCreateDate + wz_max_timeInterval < message._msgId) {
            dateMessage = [[MessageBaseModel alloc] initWithTimeStamp:message._msgId];
            lastMessageCreateDate = message._msgId;
            [self.dateDictionary setObject:@1 forKey:[NSNumber numberWithLongLong:message._msgId]];
        }
        
        //剔除群操作消息
        if (dateMessage && ![message._content containsString:@"群组"] && ![message._content containsString:@"修改群"]) {
            [messageList addObject:dateMessage];
            self.latestDateInterval = dateMessage._msgId;
        }
        
        [messageList addObject:message];
    }
    
    return messageList;
}

- (void)JWSetNavTitel:(NSString *)titel {
    [self.navigationItem setTitle:titel];
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1000) {
        if (buttonIndex == 1) {
            [self copyMessage:nil];
        }
        return;
    }
    if (actionSheet.tag == 1001) {
        if (buttonIndex == 0) {
            [self copyMessage:nil];
        }else if (buttonIndex == 1) {
            [self markMessage:nil];
        }
        return;
    }if (actionSheet.tag == 1002) {
        return;
    }if (actionSheet.tag == 1003) {
        if (buttonIndex == 0) {
            [self markMessage:nil];
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

// 气泡长按事件
- (void)longGesture:(UILongPressGestureRecognizer *)gesture
{
    //    _isBubbleFirstResponde = YES;
    //
    //    // 还原布局
    //    //    [self resignKeyBoard];
    //
    //    if (gesture.state == UIGestureRecognizerStateBegan)
    //    {
    //        UIImageView *imageView = (UIImageView *)gesture.view;
    //
    //        // 未发送成功的才能重发
    //        NSInteger index = imageView.tag;
    //        MessageBaseModel *model = [_arrayDisplay objectAtIndex:index];
    //
    //        [imageView becomeFirstResponder];
    //
    //        // 区分文字和非文字
    //        if (model._type == msg_personal_text || model._type == msg_personal_image || model._type == msg_personal_voice || model._type == msg_personal_file)
    //        {
    //            if (model._markStatus == status_send_failed)
    //            {
    //                UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"重发",@"复制",nil];
    //                sheet.tag = 1000;
    //                [sheet showInView:self.view];
    //            }
    //            else//text image
    //            {
    ////                if (![model._toLoginName isEqualToString:self.strUid]){
    //                    /*还要家一步判断:选中的是否为"我的"聊天记录*/
    //                    NSString * string = nil;
    //                    if (model._markImportant == YES) {
    //                        string = LOCAL(CANCEL_MARK);
    //                    }else {
    //                        string = LOCAL(MAKE_MARK);
    //                    }
    //                    if (model._type == msg_personal_voice || model._type == msg_personal_image) {
    //                        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:string,nil];
    //                        sheet.tag = 1003;
    //                        [sheet showInView:self.view];
    //                    }else {
    //                        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL)destructiveButtonTitle:nil otherButtonTitles:LOCAL(MESSAGE_COPY),string,nil];
    //                        sheet.tag = 1001;
    //                        [sheet showInView:self.view];
    //                    }
    //
    ////                }else {
    ////                    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:LOCAL(MESSAGE_COPY),nil];
    ////                    sheet.tag = 1001;
    ////                    [sheet showInView:self.view];
    ////                }
    //            }
    //        }
    //        else
    //        {
    //            if (model._markStatus == status_send_failed)
    //            {
    //                UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL)  destructiveButtonTitle:nil otherButtonTitles:LOCAL(MESSAGE_SENDAGAIN),nil];
    //                sheet.tag = 1002;
    //                [sheet showInView:self.view];
    //
    //            }
    //        }
    //        // 标记重发序号
    //        _reSendIndex = index;
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
                    //                    photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[UnifiedFilePathManager share] getAllPathWithRelativePath:model._nativeOriginalUrl]]];
                    //                    [self.arrayPhotos addObject:photo];
                    //
                    //                    photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[UnifiedFilePathManager share] getAllPathWithRelativePath:model._nativeThumbnailUrl]]];
                    //                    [self.arrayThumbs addObject:photo];
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
                       [self voicePlayOrStopWithVoicePath:[[MsgFilePathMgr share] getAllPathWithRelativePath:baseModel._nativeOriginalUrl] Tag:tag];
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
            //[self lookAttachmentWithFileUrl:baseModel._nativeOriginalUrl];
        }
        else
        {
            //            ChatAttachMgrViewController *chatAttachVC = [[ChatAttachMgrViewController alloc] initWithBaseModel:baseModel ContactModel:nil];
            //            chatAttachVC.delegate = self;
            //            [self.navigationController pushViewController:chatAttachVC animated:YES];
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
            //            fullPath = [[UnifiedFilePathManager share] getAllPathWithRelativePath:baseModel._nativeOriginalUrl];
            //            playerViewController =[[MPMoviePlayerViewController alloc]initWithContentURL:[[NSURL alloc] initFileURLWithPath:fullPath]];
        }
        
        [self presentMoviePlayerViewControllerAnimated:playerViewController];
        
    }
}

// 单元格点击事件
- (void)cellClicked:(UIGestureRecognizer *)gesture
{
    // 得到数据
    UIImageView *imgView = (UIImageView *)gesture.view;
    NSInteger tag = imgView.tag;
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
                    //                    photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[UnifiedFilePathManager share] getAllPathWithRelativePath:model._nativeOriginalUrl]]];
                    //                    [self.arrayPhotos addObject:photo];
                    //
                    //                    photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[UnifiedFilePathManager share] getAllPathWithRelativePath:model._nativeThumbnailUrl]]];
                    //                    [self.arrayThumbs addObject:photo];
                    
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
            [self voicePlayOrStopWithVoicePath:[[MsgFilePathMgr share] getAllPathWithRelativePath:baseModel._nativeOriginalUrl] Tag:tag];
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
            //            [self lookAttachmentWithFileUrl:baseModel._nativeOriginalUrl];
        }
        else
        {
            //            ChatAttachMgrViewController *chatAttachVC = [[ChatAttachMgrViewController alloc] initWithBaseModel:baseModel ContactModel:nil];
            //            chatAttachVC.delegate = self;
            //            [self.navigationController pushViewController:chatAttachVC animated:YES];
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
            //            fullPath = [[UnifiedFilePathManager share] getAllPathWithRelativePath:baseModel._nativeOriginalUrl];
            //            playerViewController =[[MPMoviePlayerViewController alloc]initWithContentURL:[[NSURL alloc] initFileURLWithPath:fullPath]];
        }
        
        [self presentMoviePlayerViewControllerAnimated:playerViewController];
        
    }
}

// 播放音频管理
- (void)voicePlayOrStopWithVoicePath:(NSString *)voicePath Tag:(NSInteger)tag
{
    self.currentNeedPlayVoiceTag = -1;

    NSData *audio = [NSData dataWithContentsOfFile:voicePath];
    if (!audio) {
        [self at_postError:@"语音消息获取失败"];
        return;
    }

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

#pragma mark - UITableView Delegate DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    MessageBaseModel *model = self.arrayDisplay[indexPath.row];
    
    // 需要计算的内容
    id content = nil;
    ContentType type;
    
    // 文本
    if (model._type == msg_personal_text)
    {
        content = model._content;
        type = type_text;
    }
    // 系统消息
    else if (model._type == msg_personal_alert)
    {
        content = model._content;
        type = type_date;
    }
    // 语音
    else if (model._type == msg_personal_voice)
    {
        type = type_voice;
    }
    // 图片
    else if (model._type == msg_personal_image) {
        return [CalculateHeightManager calculateHeightByModel:model IsShowGroupMemberNick:NO];
    }
    else if (model._type == msg_personal_video)
    {
        if (model._markFromReceive)
        {
            content = [NSString stringWithFormat:@"%@%@",im_IP_http,model.attachModel.thumbnail];
            
        }
        else
        {
            // 区分是web端同步下来的还是本地发送的
            if (model._nativeThumbnailUrl.length == 0)
            {
                content = [NSString stringWithFormat:@"%@%@",im_IP_http,model.attachModel.thumbnail];
            }
            else
            {
                //                NSString *fullPath = [[UnifiedFilePathManager share] getAllPathWithRelativePath:model._nativeThumbnailUrl];
                //                content = [UIImage imageWithContentsOfFile:fullPath];
            }
        }
        type = type_image;
    }
    // 附件
    else if (model._type == msg_personal_file)
    {
        type = type_attachment;
    }
    // 任务消息
    //    else if (model._type == IM_Applicaion_task)
    //    {
    //        type = type_task;
    //    }
    
    BOOL hideName = NO;
    if (!self.IsGroup) {
        hideName = YES;
    }
    
    height = [CalculateHeightManager calculateHeightByModel:model IsShowGroupMemberNick:!hideName];
    
    
    if (model._type == msg_personal_event) {
        height = [CalculateHeightManager calculateHeightByModel:model IsShowGroupMemberNick:!hideName];
        
        height = MAX(height, [model cellHeight]);
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
    
    //    if (self.messageModel._type == IM_Applicaion_task) {
    //        id cell;
    //        AppTaskModel *taskModel = [AppTaskModel mj_objectWithKeyValues:self.messageModel.appModel.applicationDetailDictionary];
    //        if (![self.messageModel._toLoginName isEqualToString:self.strUid])
    //        {
    //            cell = [self.tableView dequeueReusableCellWithIdentifier:@"NewChatEventMissionLeftTableViewCellID"];
    //            if (!cell)
    //            {
    //                cell = [[NewChatEventMissionLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewChatEventMissionLeftTableViewCellID"];
    //            }
    //
    //        }
    //        else
    //        {
    //            cell = [self.tableView dequeueReusableCellWithIdentifier:@"NewChatEventMissionRightTableViewCellID"];
    //            if (!cell)
    //            {
    //                cell = [[NewChatEventMissionRightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewChatEventMissionRightTableViewCellID"];
    //            }
    //        }
    //
    //        __weak typeof(self) weakSelf = self;
    //        [cell setShowDetail:^{
    //			__strong typeof(weakSelf) strongSelf = weakSelf;
    //			[strongSelf sendNewMissionGetMissionDetailRequestWithMessageBaseModel:strongSelf.messageModel];
    //        }];
    //
    //        [cell setCellData:self.messageModel];
    //        return cell;
    //    }
    
    
    if (![self.messageModel._toLoginName isEqualToString:self.strUid])
    {
        BOOL hid = YES;
        NSString *nickName = @"";
        NSString *userName = self.strUid;
        if (self.IsGroup) {
            nickName = [self.messageModel getNickName];
            userName = [self.messageModel getUserName];
            
            //nickName = [IMNickNameManager showNickNameWithOriginNickName:nickName userId:userName];
            
            hid = NO;
        }
        switch (self.messageModel._type)
        {
            case msg_personal_text:
            {
                NewChatLeftTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatLeftTextTableViewCell identifier]];
                [cell setDelegate:self];
                [cell setHeadIconWithUid:userName];
                [cell setEmphasisIsShow:self.messageModel._markImportant];
                [cell setRealName:nickName hidden:hid];
                [cell showTextMessage:self.messageModel];
                
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
                [cell setEmphasisIsShow:self.messageModel._markImportant];
                [cell setAttachmentData:self.messageModel.attachModel];
                [cell setRealName:nickName hidden:hid];
                
                return cell;
            }
                break;
            case msg_personal_event:
            {
                //自定义消息
                NSString* content = self.messageModel._content;
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
                if (!contentType || 0 == contentType.length)
                {
                    break;
                    
                }
                
                if ([contentType isEqualToString:@"serviceComments"])
                {
                    //服务评价消息
                    
                    PatientServiceCommentLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientServiceCommentLeftTableViewCell identifier]];
                    [cell setHeadIconWithUid:userName];
                    [cell setRealName:nickName hidden:NO];
                    [cell setEmphasisIsShow:self.messageModel._markImportant];
                    [cell setDelegate:self];
                    [cell fillInDadaWith:self.messageModel];
                    return cell;
                    
                    break;
                }
                else if ([contentType isEqualToString:@"roundsAsk"]) { //查房操作
                    PatientDoubleChooseLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientDoubleChooseLeftTableViewCell identifier]];
                    [cell setHeadIconWithUid:userName];
                    [cell setRealName:nickName hidden:NO];
                    [cell setEmphasisIsShow:self.messageModel._markImportant];
                    [cell setDelegate:self];
                    [cell fillInDataWith:self.messageModel];
                    return cell;
                    break;
                }

                else {
                    //其他自定义消息，样式一样
                    PatientEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientEventTableViewCell identifier]];
                    [cell setHeadIconWithUid:userName];
                    [cell setRealName:nickName hidden:NO];
                    [cell setEmphasisIsShow:self.messageModel._markImportant];
                    // [cell configCellDataWithProfile:senderProfile];
                    //[cell setAttachmentData:messageModel.attachModel];
                    [cell setDelegate:self];
                    [cell fillInDadaWith:self.messageModel];
                    return cell;
                    
                }
                break;
            }
                //图文消息
            case msg_personal_news: {
                NSString* content = self.messageModel._content;
                if (!content || 0 == content.length) {
                    break;
                }
                NSDictionary* dicContent = [NSDictionary JSONValue:content];
                if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
                {
                    break;
                }
                IMNewsModel* modelContent = [IMNewsModel mj_objectWithKeyValues:dicContent];
                
                PatientHealthEducationLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientHealthEducationLeftTableViewCell identifier]];
                [cell setHeadIconWithUid:userName];
                [cell setRealName:nickName hidden:NO];
                [cell setEmphasisIsShow:self.messageModel._markImportant];
                [cell fillInDadaWith:modelContent];
                return cell;
                
                break;
            }
                
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
                [cell showStatus:self.messageModel._markStatus];
                [cell setEmphasisIsShow:self.messageModel._markImportant];
                [cell showTextMessage:self.messageModel];
                
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
                [cell setEmphasisIsShow:self.messageModel._markImportant];
                [cell setAttachmentData:self.messageModel.attachModel];
                
                return cell;
            }
                break;
            case msg_personal_event:
            {
                //自定义消息
                NSString* content = self.messageModel._content;
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
                if (!contentType || 0 == contentType.length)
                {
                    break;
                    
                }
                
                PatientEventRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientEventRightTableViewCell identifier]];
                [cell fillInDadaWith:self.messageModel];
                //[cell setData:messageModel];
                //                                    [cell showStatus:messageModel._markStatus progress:[self.uploadImageDictionary objectForKey:messageModel._nativeOriginalUrl]];
                //                                    [cell showSendImageMessage:messageModel];
                //[cell setEmphasisIsShow:messageModel._markImportant];
                [cell setDelegate:self];
                return cell;
                
                
                
                
                
                
            }
                break;
                //图文消息
            case msg_personal_news: {
                NSString* content = _messageModel._content;
                if (!content || 0 == content.length) {
                    break;
                }
                NSDictionary* dicContent = [NSDictionary JSONValue:content];
                if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
                {
                    break;
                }
                IMNewsModel* modelContent = [IMNewsModel mj_objectWithKeyValues:dicContent];
                
                PatientHealthEducationRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientHealthEducationRightTableViewCell identifier]];
                [cell setEmphasisIsShow:_messageModel._markImportant];
                [cell fillInDadaWith:modelContent];
                return cell;
                
                break;
            }
                
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
#pragma mark - ChatBaseTableViewCell Delegate

//- (void)chatBaseTableViewCell:(ChatBaseTableViewCell *)cell pressHeadAtIndexPath:(NSIndexPath *)indexPath {
//    MessageBaseModel *model = [self.arrayDisplay objectAtIndex:indexPath.row];
//    ContactBookDetailViewController *detailVC = [[ContactBookDetailViewController alloc] initWithUserShowId:model._target];
//    [self.navigationController pushViewController:detailVC animated:YES];
//}

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

#pragma mark - ChatInputViewDelegate

//- (void)ChatInputViewDelegateCallBack_IsAddAttachment:(BOOL)mark
//{
//    if (mark)
//    {
//        // 选择图片
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
//        [actionSheet showInView:self.view];
//
//    }
//
//}

- (void)ChatInputViewDelegateCallBack_sendText:(NSString *)text
{
    if (text.length > 0)
    {
        [[MessageManager share] sendMessageTo:self.strUid nick:self.strName WithContent:text Type:msg_personal_text];
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
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[[photo valueForKey:@"photoURL"] absoluteString]];
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

// 保存图片
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    // Handle the end of the image write process
    if (!error)
    {
        //        [self postSuccess:LOCAL(SUCCESS_SAVE)];
    }
    else
    {
        //        [self postError:[error localizedDescription]];
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
    //	MessageAppModel *appModel = model.appModel;
    //	TaskListModel *taskListModel = [TaskListModel new];
    //	AppTaskModel *taskModel = [AppTaskModel mj_objectWithKeyValues:appModel.applicationDetailDictionary];
    //	if (taskModel.id.length != 0)
    //	{
    //		taskListModel.showId = taskModel.id;
    //	}
    //	else
    //	{
    //		// 任务系统消息
    //		taskListModel.showId = appModel.msgRMShowID;
    //	}
    //	NewMissionGetMissionDetailRequest *request = [[NewMissionGetMissionDetailRequest alloc] initWithDelegate:self];
    //	[request getDetailTaskWithId:taskListModel.showId];
    //	[self postLoading];
}

#pragma mark - ChatAttachMrgViewController Delegate

// 附件下载完毕的委托回调
- (void)ChatAttachMgrViewControllerDelegateCallBack_finishDownloadAndLookAttachWithFileUrl:(NSString *)fileUrl
{
    //    [self lookAttachmentWithFileUrl:fileUrl];
}

//- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
//	if ([request isKindOfClass:[NewMissionGetMissionDetailRequest class]]) {
//		[self hideLoading];
//		NewMissionDetailModel *detailModel = [(NewMissionGetMissionDetailResponse *)response detailModel];
//
//		NewDetailMissionViewController *MDVC = [[NewDetailMissionViewController alloc] initWithOnlyShowID:detailModel.showId];
//		MDVC.isFirstVC = YES;
//		[self.navigationController pushViewController:MDVC animated:YES];
//
//	}
//}

//- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
//    [self postError:errorMessage];
//}

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
    [[UIAlertView alloc] initWithTitle: @"保存"
                               message: nil
                              delegate: self
                     cancelButtonTitle:@"不保存"
                     otherButtonTitles:@"取消",nil];
    [cantRecordAlert show];
}

#pragma mark - DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无记录" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"666666"]}];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"emptyImage_l"];
}



- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!self.arrayDisplay ||self.arrayDisplay.count == 0) {
        return YES;
    }
    return NO;
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
- (NSMutableArray *)arrayDisplay
{
    if (!_arrayDisplay)
    {
        _arrayDisplay = [NSMutableArray array];
    }
    return _arrayDisplay;
}

- (NSMutableArray *)arrayDataList
{
    if (!_arrayDataList)
    {
        _arrayDataList = [NSMutableArray array];
    }
    return _arrayDataList;
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
        _photoBrowser.alwaysShowControls = NO;  // 控制条件控件
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
- (NSMutableDictionary *)dateDictionary {
    if (!_dateDictionary) {
        _dateDictionary = [NSMutableDictionary dictionary];
    }
    return _dateDictionary;
}

@end
