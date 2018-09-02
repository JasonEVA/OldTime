//
//  ChatViewController.m
//  launcher
//
//  Created by William Zhang on 15/7/24.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ChatViewController.h"
#import "SWTableViewCell.h"
#import "ContactPersonDetailInformationModel.h"
#import "ChatSingleViewController.h"
#import "MessageListCell.h"
#import <MintcodeIM/MintcodeIM.h>
#import "MyDefine.h"
#import "SelectContactBookViewController.h"
#import "ChatSearchViewController.h"
#import "BaseNavigationController.h"
#import "ChatGroupViewController.h"
#import "MissionMianViewController.h"
#import "MixpanelMananger.h"
#import "AppDelegate.h"
#import "Category.h"
#import <Masonry/Masonry.h>
#import "NomarlDealWithEventView.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeReaderViewController+CameraAvaibleCheck.h"
#import "QRLoginViewController.h"
#import "WebViewController.h"
#import "ApplicationCreateScheduleViewController.h"
#import "ApplicationCreateMissionViewController.h"
#import "HomeTabBarController.h"
#import "UIViewController+modalPresent.h"
#import "Slacker.h"
#import "ChatEmptyView.h"
#import "ApplicationCreateNewMissionViewController.h"
#import "ChatIMConfigure.h"
#import "AvatarUtil.h"
#import "ChatRelationViewController.h"
#import "ApplicationGetAppInfoRequest.h"
#import "AttachmentUtil.h"
#import "ApplicationAppInfoModel.h"
#import "NewApplicationMessageListViewController.h"
#import "ChatApplicationCalendarViewController.h"
#import "ChatApplicationApplyViewController.h"
#import "ChatApplicationTaskViewController.h"
#import "GetCompanyUserLoginUpdateRequest.h"
#import <UIAlertView+Blocks.h>

#import "NewApplyStyleViewController.h"
#import "NewCalendarAddMeetingViewController.h"
#define T_NOTIFYSOUND 2.0           // 两条消息提醒最小间隔

@interface ChatViewController () <SWTableViewCellDelegate, MessageManagerDelegate, UITableViewDataSource, UITableViewDelegate,BaseRequestDelegate>
{
    NSTimeInterval _currTimeInterval;           // 当前时间，为消息间隔服务
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *messageList;

@property (nonatomic, strong) NomarlDealWithEventView *dropListView;

@property (nonatomic, strong) UIBarButtonItem *addGroupItem;
@property (nonatomic, strong) UIBarButtonItem *btnSearchItem;
@property (nonatomic, strong) ChatEmptyView *emptyPageView;

/// 防止推出2层VC
@property (nonatomic) BOOL doubleclick;

@end

@implementation ChatViewController

#pragma mark - View Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        [[MessageManager share] getMessageListCompletion:^(NSArray *messageList) {
            [self.messageList removeAllObjects];
            [self.messageList addObjectsFromArray:messageList];
        }];
    }
    return self;
}

- (void)dealloc
{
    [self handleNotificationRemove];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureNavigationItems];
    
    // 初始化一堆控件和变量
    [self initComponents];
    [self initVariables];
    
    
    ApplicationGetAppInfoRequest *request = [[ApplicationGetAppInfoRequest alloc] initWithDelegate:self];
    [request GetInfo];
    
    //更新操作只执行一次即可 --- 危险
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        [self requestAppUpdateInfo];
//    });
	
	
    // 单纯存入uid改变取出的数据库
    [MessageManager setUserId:[[UnifiedUserInfoManager share] userShowID]
                     nickName:[[UnifiedUserInfoManager share] userName]];
    
    [[MessageManager share] login];
    
    [self handleNotificationRegister];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor themeBlue];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    self.doubleclick = YES;
    [self RecordToDiary:@"进入聊天消息列表界面"];
    [[MessageManager share] setDelegate:self];
    
    // 防止第一次重复获取
    static BOOL firstTime = YES;
    
    if (!firstTime) {
        [self refreshMessageListData];
    }
    firstTime = NO;
}

#pragma mark - Private Method
/**
 *  ConfigureNavigationItems
 */
- (void)configureNavigationItems {
    UIBarButtonItem *addGroupItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(naviGroupChat)];
    UIBarButtonItem *btnSearchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"magnifier"] style:UIBarButtonItemStylePlain target:self action:@selector(btnSearchClicked)];
    
    [self.navigationItem setRightBarButtonItems:@[addGroupItem, btnSearchItem] animated:NO];
	
	[self setupTitleViewWhileConnecing];
}

- (void)handleNotificationRegister {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginChat:) name:MTWillShowSingleChatNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginGroupChat:) name:MTWillShowGroupChatNotification object:nil];
    
    // 注册消息连接状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketStatusConnecting) name:MTSocketConnectingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketStatusConnected) name:MTSocketConnectSuccessedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketStatusNoConnect) name:MTSocketConnectFailedNotification object:nil];
    
    // 注册监听创建群聊
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(naviGroupChat) name:MTWillCreateGroupNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnSearchClicked) name:MTWillBeginSearchContentNotification object:nil];
    
    // 获取离线消息监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOfflineMsg) name:M_N_GETMESSAGELIST object:nil];
    
    // 注册异地登录的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wsLoginOut:) name:MTLogoutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avatarRemoveCache:) name:MTUserInfoChangeNotification object:nil];
}

- (void)handleNotificationRemove {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTWillShowGroupChatNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTWillShowSingleChatNotification  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTSocketConnectingNotification  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTSocketConnectSuccessedNotification  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTSocketConnectFailedNotification  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTWillCreateGroupNotification   object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTWillBeginSearchContentNotification  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:M_N_GETMESSAGELIST  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTUserInfoChangeNotification  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTLogoutNotification  object:nil];
}

- (void)requestAppUpdateInfo {
	GetCompanyUserLoginUpdateRequest *request = [[GetCompanyUserLoginUpdateRequest alloc] initWithDelegate:self];
	[request fetchAppUpdateInfo];
}

// 是否显示空白页
- (void)isShowEmptyPage
{
    if (self.messageList.count == 0) {
        [self.emptyPageView setHidden:NO];
    } else {
        [self.emptyPageView setHidden:YES];
    }
}

/**
 *  播放声音
 */
- (void)playSoundForNewMessage
{
    //    // 根据时间间隔播放声音
    //    NSTimeInterval newTimeInterval = [[NSDate date] timeIntervalSince1970];
    //    if ((newTimeInterval - _currTimeInterval) > T_NOTIFYSOUND)
    //    {
    //        //        [Slacker playNotifySoundIntellective];
    //        _currTimeInterval = newTimeInterval;
    //    }
}

/**
 *  二维码扫描结果的使用
 *  @param string 扫描后的字符串内容
 */
- (void)QRResult:(NSString *)string {
    [self.navigationController popViewControllerAnimated:NO];
    if ([string hasPrefix:@"{\"id\":"]) {
        QRLoginViewController *VC = [[QRLoginViewController alloc] initWithId:string];
        
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    
    WebViewController *webVC = [[WebViewController alloc] initWithURL:string];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

/**
 *  初始化控件
 */
- (void)initComponents
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

/**
 *  初始化变量
 */
- (void)initVariables {
    _currTimeInterval = [[NSDate date] timeIntervalSince1970];
}

/**
 *  对Socket连接时TitleView初始化
 */
- (void)setupTitleViewWhileConnecing {
	UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
	
	UIActivityIndicatorView *acivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	acivityIndicator.tintColor = [UIColor blackColor];
	[acivityIndicator startAnimating];
	[titleView addSubview:acivityIndicator];
	
	UILabel *titleLabel = [UILabel new];
	titleLabel.font = [UIFont systemFontOfSize:18];
	titleLabel.textColor = [UIColor blackColor];
	titleLabel.text = LOCAL(CONNECTING);
	[titleView addSubview:titleLabel];
	
	[acivityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.bottom.top.equalTo(titleView);
	}];
	
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.right.equalTo(titleView);
		make.left.equalTo(acivityIndicator.mas_right);
	}];
	
	self.navigationItem.titleView = titleView;
	[titleView sizeToFit];
}

/**
 *  刷新消息列表
 */
- (void)refreshMessageListData
{
    // 去消息数据库刷新
    [[MessageManager share] getMessageListCompletion:^(NSArray *arrayList) {
        [self.messageList removeAllObjects];
        [self.messageList addObjectsFromArray:arrayList];
        [self.tableView reloadData];
        [self isShowEmptyPage];
    }];
}

/**
 *  未使用该方法
 */
- (NSArray *)rightButtonsIsTop:(BOOL)isTop
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:LOCAL(DELETE)];
    
    return rightUtilityButtons;
}

#pragma mark - Event Handle
/**
 *  导航栏右上角加号按钮事件处理
 */ 
- (void)naviGroupChat
{

    if (!self.dropListView.canappear) {
        self.dropListView.canappear = YES;
        [self.dropListView removeFromSuperview];
        return;
    }
    
    [self.dropListView setpassbackBlock:^(NSInteger selectIndex) {
        switch (selectIndex) {
            case 0:
            // 发起群聊
            {
                SelectContactBookViewController *createVC = [SelectContactBookViewController new];
                createVC.selectType = selectContact_createGroup;
				createVC.selfSelectable = YES;
				createVC.currentUserID = [[UnifiedUserInfoManager share] userShowID];
                [createVC setHidesBottomBarWhenPushed:YES];
                [self presentViewController:createVC animated:YES completion:nil];
            }
                break;
            case 1:
            {
				// 判断是否可以摄像头
				if ([QRCodeReaderViewController mtc_isCameraAvaible]) {
					QRCodeReaderViewController *QRVC = [QRCodeReaderViewController new];
					[QRVC setCompletionWithBlock:^(NSString * _Nullable resultAsString) {
						[self QRResult:resultAsString];
					}];
					QRVC.hidesBottomBarWhenPushed = YES;
					[self.navigationController pushViewController:QRVC animated:YES];
				}
				
            }
                break;
            case 2:  //新建审批
            {
                
                NewApplyStyleViewController *vc = [[NewApplyStyleViewController alloc] init];
                [vc setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:vc animated:YES];
//新建任务 －－－－－－
//                ApplicationCreateNewMissionNavigationController *createMissionVC = [[ApplicationCreateNewMissionNavigationController alloc] init];
//                [createMissionVC.rootVC handleDataWithNavigationController:self.navigationController title:@"" completion:nil];
//
//                HomeTabBarController *homeVC = (HomeTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//                [homeVC modalPresentViewController:createMissionVC];
                
                
                
            }
                break;
            case 3: //新建会议
            {

                NewCalendarAddMeetingViewController *vc = [[NewCalendarAddMeetingViewController alloc] init];
                vc.isFromQuickStart = YES;
                [vc setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:vc animated:YES];
//新建日程 －－－－－－
//                ApplicationCreateNavigationController *createScheduleVC = [[ApplicationCreateNavigationController alloc] init];
//                [createScheduleVC.rootVC handleDataWithNavigationController:self.navigationController title:@"" completion:nil];
//                
//                HomeTabBarController *homeVC = (HomeTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//                [homeVC modalPresentViewController:createScheduleVC];
            }
                break;
            default:
                break;
        }
    }];
    
    [self.view addSubview:self.dropListView];
    [self.dropListView appear];
}

/**
 *  导航栏搜索按钮的点击事件处理
 */
- (void)btnSearchClicked
{
    ChatSearchViewController *searchVC = [[ChatSearchViewController alloc] init];
    [searchVC setIsquerySearch:YES];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 *  获取离线消息的通知回调事件
 */
- (void)getOfflineMsg
{
    //    [[MessageManager share] setDelegate:self];
    [[MessageManager share] getMessageList];
}

/**
 *  发起单人聊天的通知回调方法
 *  @param notification MTWillShowSingleChatNotification对象
 */
- (void)beginChat:(NSNotification *)notification
{
    // 得到附件信息
    NSDictionary *dictContact = [notification userInfo];
    ContactDetailModel *model = [[ContactDetailModel alloc] init];
    model._target   = [dictContact objectForKey:personDetail_show_id];
    model._nickName = [dictContact objectForKey:personDetail_u_true_name];
    model._headPic  = [dictContact objectForKey:personDetail_headPic];
    
    ChatSingleViewController *singleChatVC = [[ChatSingleViewController alloc] initWithDetailModel:model];
    [singleChatVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:singleChatVC animated:YES];
}

/**
 *  发起和群组聊天的通知回调方法
 *  @param notification MTWillShowGroupChatNotification
 */
- (void)beginGroupChat:(NSNotification *)notification
{
    NSDictionary *dictContact = [notification userInfo];
    
    ContactDetailModel *model = [[ContactDetailModel alloc] init];
    model._target   = [dictContact objectForKey:@"UserProfile_userName"];
    model._nickName = [dictContact objectForKey:@"UserProfile_nickName"];
    
    ChatGroupViewController *groupChatVC = [[ChatGroupViewController alloc] initWithDetailModel:model];
    groupChatVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:groupChatVC animated:YES];
}

/**
 *  Socket连接时的通知回调
 */
- (void)socketStatusConnecting {
	[self setupTitleViewWhileConnecing];
}

/**
 *  Socket连接成功的通知回调方法
 */
- (void)socketStatusConnected
{
    self.navigationItem.titleView = nil;
    [self setTitle:LOCAL(HOMETABBAR_MESSAGE)];
}

/**
 *  Socket连接失败的通知回调方法
 */
- (void)socketStatusNoConnect
{
    self.navigationItem.titleView = nil;
    [self setTitle:LOCAL(UNCONNECT)];
}

/**
 *  用户个人数据刷新的通知回调方法,更新用户头像的缓存
 *  @param notification MTUserInfoChangeNotification对象
 */
- (void)avatarRemoveCache:(NSNotification *)notification {
    avatarRemoveCache(notification.object);
}

/**
 *  用户账号登出的通知回调方法
 *  @param notification MTLogoutNotification对象
 */
- (void)wsLoginOut:(NSNotification *)notification
{
    NSLog(@"WSLOGOUT");
    
    AppDelegate *aDelegate = [UIApplication sharedApplication].delegate;
    [aDelegate.controllerManager releaseHomeView];
#ifdef CHINAMODE
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCAL(CHANGEDEVICE) message:notification.object delegate:nil cancelButtonTitle:LOCAL(CONFIRM) otherButtonTitles:nil];
    [alertView show];
#else
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCAL(PROMPT) message:LOCAL(CHANGEDEVICE) delegate:nil cancelButtonTitle:LOCAL(CONFIRM) otherButtonTitles:nil];
    [alertView show];
#endif
}



#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return self.messageList.count;}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return [MessageListCell height];}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 0.01;}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:[MessageListCell identifier]];

    ContactDetailModel *model = [self.messageList objectAtIndex:indexPath.row];
    [cell setModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.doubleclick) {
        return;
    }
    
    self.doubleclick = NO;
    // 取出数据
    ContactDetailModel *model = [self.messageList objectAtIndex:indexPath.row];
    
    if ([model isRelationSystem]) {
        ChatRelationViewController *VC = [[ChatRelationViewController alloc] init];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    
    // 判断是App还是聊天
    if (model._isApp)
    {
        // 获得消息类型
        IM_Applicaion_Type type = (IM_Applicaion_Type)[MessageBaseModel getMsgTypeFromString:model._target];
        id appVC;

        switch (type) {
            case IM_Applicaion_approval:
                appVC=[[ChatApplicationApplyViewController alloc]init];
                [MixpanelMananger track:@"home/approve"];
                break;
            case IM_Applicaion_schedule:
                appVC = [[ChatApplicationCalendarViewController alloc] init];
                [MixpanelMananger track:@"home/calendar"];
                break;
            case IM_Applicaion_task:
                appVC=[[ChatApplicationTaskViewController alloc]init];
                [MixpanelMananger track:@"home/task"];
                break;
            default:
                break;
        }
        //从右往左
        [appVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:appVC animated:YES];
        
    }else if (!model._isGroup)
    {
        // 跳转到联系人聊天窗口
        ChatSingleViewController *chatVC = [[ChatSingleViewController alloc] initWithDetailModel:model];
        //        chatVC.strUid = model._target;
//                chatVC.title = model._nickName;
//                chatVC.title = @"123456";
        //        chatVC.strDepartment = model._parentDeptName;
        [chatVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    
    else
    {
        // 跳转到群聊窗口
        ChatGroupViewController *chatGroupVC = [[ChatGroupViewController alloc] initWithDetailModel:model];
        [chatGroupVC changeGroupTitleWithBlcok:^(NSString *grouptitle, NSString *avatar) {
            model._nickName = grouptitle;
        }];
        //        chatGroupVC.strUid = model._target;
        //        chatGroupVC.strName = model._nickName;
        //        chatGroupVC.avatarPath = model._headPic;
        [chatGroupVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatGroupVC animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LOCAL(DELETE);
}

// 删除单元格
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        ContactDetailModel *model = [self.messageList objectAtIndex:indexPath.row];

        [self postLoading];
        [self RecordToDiary:@"删除消息列表tableview里的消息"];
        
        NSString *removeSession = model._target;
        [[MessageManager share] removeSessionUid:removeSession completion:^(BOOL isSuccess){
            if (!isSuccess) {
                [self postError:LOCAL(ERROROTHER)];
                return;
            }
            
            [self hideLoading];
            [UIView performWithoutAnimation:^{
                [self.tableView reloadData];
            }];
            
            for (NSInteger i = 0; i < [self.messageList count]; i ++) {
                ContactDetailModel *model = [self.messageList objectAtIndex:i];
                if (![model._target isEqualToString:removeSession]) {
                    continue;
                }
                
                // 单元格删除特效
                [self.tableView beginUpdates];
                [self.messageList removeObjectAtIndex:i];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
                [self isShowEmptyPage];
                // 发送底部栏未读消息条数变化的通知
                [[NSNotificationCenter defaultCenter] postNotificationName:MTBadgeCountChangedNotification object:nil];
                [self RecordToDiary:@"底部栏未读消息条数变化的通知"];
                break;
            }
        }];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    ContactDetailModel *model = [self.messageList objectAtIndex:cellIndexPath.row];
    
    switch (index) {
//        case 0:         // 置顶
            //        {
            // 置反原有置顶设置
            //            [model markMessageTopSet];
            //
            //            // 更改数据库后刷新
            //            [[UnifiedSqlManager share] markMessageTopSetWith:model];
            //
            //            // 刷新列表
            //            [self refreshMessageListData];
            //
            //            // 还原单元格自身
            //            [cell hideUtilityButtonsAnimated:YES];
            //            break;
            //        }
        case 0: // 删除
        {
            [self postLoading];
            NSString *removeSession = model._target;
            [[MessageManager share] removeSessionUid:removeSession completion:^(BOOL isSuccess){
                if (!isSuccess) {
                    [self postError:LOCAL(ERROROTHER)];
                    return;
                }
                
                [self hideLoading];
                [UIView performWithoutAnimation:^{
                    [self.tableView reloadData];
                }];
                
                for (NSInteger i = 0; i < [self.messageList count]; i ++) {
                    ContactDetailModel *model = [self.messageList objectAtIndex:i];
                    if (![model._target isEqualToString:removeSession]) {
                        continue;
                    }
                    
                    // 单元格删除特效
                    [self.tableView beginUpdates];
                    [self.messageList removeObjectAtIndex:i];
                    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];
                    [self isShowEmptyPage];
                    // 发送底部栏未读消息条数变化的通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:MTBadgeCountChangedNotification object:nil];
                    [self RecordToDiary:@"底部栏未读消息条数变化的通知"];
                    break;
                }
            }];
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

#pragma mark - MessageManager Delegate
// 新消息到达等需要重新刷新列表
- (void)MessageManagerDelegateCallBack_needRefreshWithTareget:(NSString *)target
{
    // 刷新消息列表数据
    [self refreshMessageListData];
    [self RecordToDiary:@"新消息到达等需要重新刷新列表"];
    // 播放声效提醒
    [self playSoundForNewMessage];
}

- (void)MessageManagerDelegateCallBack_removeSessionWithTarget:(NSString *)target {
    __block NSUInteger index = NSUIntegerMax;
    [self.messageList enumerateObjectsUsingBlock:^(ContactDetailModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model._target isEqualToString:target]) {
            *stop = YES;
            index = idx;
        }
    }];
    
    if (index != NSUIntegerMax) {
        [self.messageList removeObjectAtIndex:index];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)MessageManagerDelegateCallBack_clearUnreadWithTarget:(NSString *)target {
    [self.messageList enumerateObjectsUsingBlock:^(ContactDetailModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model._target isEqualToString:target]) {
            *stop = YES;
            model._countUnread = 0;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

// 退群的消息委托
- (void)MessageManagerDelegateCallBack_quitGroupWithTareget:(NSString *)target
{
    // 刷新消息列表数据
    [self refreshMessageListData];
    [self RecordToDiary:@"刷新消息列表数据"];
    
    // 播放声效提醒
    [self playSoundForNewMessage];
}

// 信息更改的消息委托
- (void)MessageManagerDelegateCallBack_refreshContactProfileRefresh:(UserProfileModel *)userProfile
{
    // 刷新消息列表数据
    [self refreshMessageListData];
    [self RecordToDiary:@"信息更改的消息委托"];
    
    // 播放声效提醒
    [self playSoundForNewMessage];
}

// 离线消息刷新
- (void)MessageManagerDelegateCallBack_needRefreshWithOfflineMessage
{
    // 刷新消息列表数据
    [self refreshMessageListData];
    [self RecordToDiary:@"离线消息刷新"];
    
    // 播放声效提醒
    [self playSoundForNewMessage];
}

// 撤回重发消息刷新(最后一条)
- (void)MessageManagerDelegateCallBack_reSendRefreshWithMessageBaseModel:(MessageBaseModel *)model
{
    // 刷新消息列表数据
    [self refreshMessageListData];
    [self RecordToDiary:@"消息撤回刷新"];
    
    // 播放声效提醒
    [self playSoundForNewMessage];
}
#pragma mark - ToReadDataManaqger Delegate
// 待阅新消息委托回调
- (void)ToReadDataManagerDelegateCallBack_needRefreshListData
{
    // 刷新消息列表数据
    [self refreshMessageListData];
    [self RecordToDiary:@"待阅新消息委托回调"];
    
    // 播放声效提醒
    [self playSoundForNewMessage];
}
// 新消息提醒
- (void)MessageManagerDelegateCallBack_PlaySystemKind
{
    // 消息提醒
    // 刷新消息列表数据
    // 播放声效提醒
    // 根据时间间隔播放声音
    NSTimeInterval newTimeInterval = [[NSDate date] timeIntervalSince1970];
    if ((newTimeInterval - _currTimeInterval) > T_NOTIFYSOUND)
    {
        [Slacker playNotifySoundIntellective];
        _currTimeInterval = newTimeInterval;
    }

}

- (void)compareWithimgs:(NSMutableArray *)arrModels;
{
    NSMutableDictionary *dictcollect = [[NSMutableDictionary alloc] init];
    for (ApplicationAppInfoModel *model in arrModels)
    {
        NSString *stringurl = [NSString stringWithFormat:@"%@/Base-Module/Annex/AppIcon?annexType=APPIcon&width=150&height=150&fileName=%@",la_imgURLAddress,model.APP_ICON_MOBILE];
        
        if ([model.SHOW_ID isEqualToString:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdCalendar]])
        {
            [dictcollect setObject:stringurl forKey:@(1)];
        }
        else if ([model.SHOW_ID isEqualToString:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdApprove]])
        {
            [dictcollect setObject:stringurl forKey:@(0)];
        }
        else if ([model.SHOW_ID isEqualToString:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdNewTask]])
        {
            [dictcollect setObject:stringurl forKey:@(2)];
        }
        
    }
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:dictcollect];
    NSString *Path =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"appImgs"];
    [NSKeyedArchiver archiveRootObject:dict toFile:filename];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([response isKindOfClass:[ApplicationGetAppInfoResponse class]])
    {
        [self compareWithimgs:((ApplicationGetAppInfoResponse *)response).arrAppModels];
        [self.tableView reloadData];
    }
	
	if ([response isKindOfClass:[GetCompanyUserLoginUpdateResponse class]]) {
		
		GetCompanyUserLoginUpdateResponse *updateResponse =  (GetCompanyUserLoginUpdateResponse *)response;
		
		BOOL needForceUpdate = NO;
		switch (updateResponse.updateStrategy) {
			case AppUpdateNone:
			case AppUpdateOhter:
				return;
			case AppUpdateForce:
				needForceUpdate = YES;
				break;
			case AppUpdateNormal:
				needForceUpdate = NO;
				break;
		}
		
#if JAPANMODE || JAPANTESTMODE
		[self fetchNewestVersionUpdateInfoFromAppStoreWithVersion:updateResponse.version isForeced:needForceUpdate];
#else
		[self fetchNewestVersionUpdateInfoFromFirWithNeedForced:needForceUpdate];
#endif

	}
	
}
	
- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

- (void)fetchNewestVersionUpdateInfoFromFirWithNeedForced:(BOOL)isForeced {
	NSString *bundleId = [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"];
	NSString *bundleIdUrlString = [NSString stringWithFormat:@"http://api.fir.im/apps/latest/%@?api_token=ac0b9f4bbe1acb4a429d27404dd5cb66&type=ios", bundleId];
	NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:bundleIdUrlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		NSError *jsonError = nil;
        if (!data || data == NULL) {
            return;
        }
        
		id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
		if (jsonError || ![object isKindOfClass:[NSDictionary class]]) {
			NSLog(@"%@", jsonError);
			return;
		}
		
		NSString *version    = [object objectForKey:@"versionShort"];
		NSString *build      = [object objectForKey:@"build"];
		NSString *installUrl = [object objectForKey:@"update_url"];
		NSString *changelog  = [object objectForKey:@"changelog"];
#ifdef CHINAMODE
		[[NSUserDefaults standardUserDefaults] setObject:build forKey:@"build"];
        [[NSUserDefaults standardUserDefaults] synchronize];
#endif
		NSString *localBuild = [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleVersionKey];
		
        if ([build compare:localBuild options:NSNumericSearch] == NSOrderedSame) {
			return;
		}
		
		if ([build compare:localBuild options:NSNumericSearch] == NSOrderedAscending)
		{
			return;
		}
		
		NSString *alertTitle = [NSString stringWithFormat:@"%@%@(%@)",LOCAL(FindNewVersion), version, build];
		NSArray *buttonTitles = @[LOCAL(UpdateNow), LOCAL(UpdateLater)];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[UIAlertView showWithTitle:alertTitle message:changelog cancelButtonTitle:(isForeced ? nil : buttonTitles[1]) otherButtonTitles:@[buttonTitles[0]] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
				
				if (!isForeced && buttonIndex == 0) {
					return ;
				}

				if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:installUrl]]) {
					[[UIApplication sharedApplication] openURL:[NSURL URLWithString:installUrl]];
				}
				
			}];
			
		});
		
	}];
	
	[task resume];
}

- (void)fetchNewestVersionUpdateInfoFromAppStoreWithVersion:(NSString *)version isForeced:(BOOL)isForeced {
	NSString *alertTitle = [NSString stringWithFormat:@"%@%@",LOCAL(FindNewVersion),version];
#warning 发布前必须填写
	NSString *changelog = @"";
	NSArray *buttonTitles = @[LOCAL(UpdateNow), LOCAL(UpdateLater)];
	NSString *currentVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
	NSString *installUrl = @"";
	
	if ([version compare:currentVersion options:NSNumericSearch] == NSOrderedSame) {
		return;
	}
	
	if ([version compare:currentVersion options:NSNumericSearch] == NSOrderedAscending)
	{
		return;
	}
	
	[UIAlertView showWithTitle:alertTitle message:changelog cancelButtonTitle:(isForeced ? nil : buttonTitles[1]) otherButtonTitles:@[buttonTitles[0]] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
		
		if (!isForeced && buttonIndex == 0) {
			return ;
		}
		
		if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:installUrl]]) {
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:installUrl]];
		}
		
		
	}];
	
}

#pragma mark - Lazy Initializer
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;

        [_tableView setSeparatorColor:[UIColor borderColor]];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor mtc_colorWithHex:0xebebeb];
        
        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 0);
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            _tableView.layoutMargins = UIEdgeInsetsMake(0, 13, 0, 0);
        }
        
        [_tableView registerClass:[MessageListCell class] forCellReuseIdentifier:[MessageListCell identifier]];
    }
    return _tableView;
}

- (NSMutableArray *)messageList {
    if (!_messageList) {
        _messageList = [NSMutableArray array];
    }
    return _messageList;
}

- (NomarlDealWithEventView *)dropListView {
    if (!_dropListView) {
        NSArray *images = @[[UIImage imageNamed:@"Touch_Chat"],             //群聊
                            [UIImage imageNamed:@"Touch_Code"],             //二维码
                            [UIImage imageNamed:@"apply_fast"],             //请假
                            [UIImage imageNamed:@"NewCalendar_Meeting"]];   //会议
        NSArray *titles = @[LOCAL(QUICK_NEW_CHAT),
                            LOCAL(QUICK_QRCODE),
                            LOCAL(QUICK_APPLY),
                            LOCAL(QUICK_MEETING)];
        _dropListView = [[NomarlDealWithEventView alloc] initWithArrayLogos:images arrayTitles:titles];
        _dropListView.canappear = YES;
    }
    return _dropListView;
}

- (ChatEmptyView *)emptyPageView
{
    if (!_emptyPageView) {
        _emptyPageView = [[ChatEmptyView alloc] init];
        [self.view addSubview:_emptyPageView];
        [_emptyPageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.tableView);
        }];
    }
    return _emptyPageView;
}

@end
