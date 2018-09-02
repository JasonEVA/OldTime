////
////  ChatViewController.m
////  launcher
////
////  Created by William Zhang on 15/7/24.
////  Copyright (c) 2015年 William Zhang. All rights reserved.
////
//
//#import "ChatViewController.h"
//#import <SWTableViewCell/SWTableViewCell.h>
//#import "ContactPersonDetailInformationModel.h"
//#import "ChatSingleViewController.h"
//#import "MessageListCell.h"
//#import <MintcodeIMKit/MintcodeIMKit.h>
//#import "MyDefine.h"
//#import "SelectContactBookViewController.h"
//#import "ChatSearchViewController.h"
//#import "BaseNavigationController.h"
//#import "ChatGroupViewController.h"
//#import "MissionMianViewController.h"
//#import "ApplicationMessageListViewController.h"
//#import "NewApplicationMessageListViewController.h"
//#import "NewApplicationMessageListViewController.h"
//#import "MixpanelMananger.h"
//#import "AppDelegate.h"
//#import "Category.h"
//#import <Masonry/Masonry.h>
//#import "NomarlDealWithEventView.h"
//#import "QRCodeReaderViewController.h"
//#import "QRLoginViewController.h"
//#import "WebViewController.h"
//#import "ApplicationCreateScheduleViewController.h"
//#import "ApplicationCreateMissionViewController.h"
//#import "HomeTabBarController.h"
//#import "UIViewController+modalPresent.h"
//#import "Slacker.h"
//#import "ChatEmptyView.h"
//#import "ApplicationCreateNewMissionViewController.h"
//#import "ChatIMConfigure.h"
//#import "AvatarUtil.h"
//#import "ChatRelationViewController.h"
//#import "ApplicationGetAppInfoRequest.h"
//#import "AttachmentUtil.h"
//#import "ApplicationAppInfoModel.h"
//
//#define T_NOTIFYSOUND 2.0           // 两条消息提醒最小间隔
//
//@interface ChatViewController () <SWTableViewCellDelegate, MessageManagerDelegate, UITableViewDataSource, UITableViewDelegate,BaseRequestDelegate>
//{
//    NSTimeInterval _currTimeInterval;           // 当前时间，为消息间隔服务
//}
//
//@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) NSMutableArray *messageList;
//
//@property (nonatomic, strong) NomarlDealWithEventView *dropListView;
//
//@property (nonatomic, strong) UIBarButtonItem *addGroupItem;
//@property (nonatomic, strong) UIBarButtonItem *btnSearchItem;
//@property (nonatomic, strong) ChatEmptyView *emptyPageView;
//
///// 防止推出2层VC
//@property (nonatomic) BOOL doubleclick;
//
//@end
//
//@implementation ChatViewController
//
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        [[MessageManager share] getMessageListCompletion:^(NSArray *messageList) {
//            [self.messageList removeAllObjects];
//            [self.messageList addObjectsFromArray:messageList];
//        }];
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    self.addGroupItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(naviGroupChat)];
//    self.btnSearchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"magnifier"] style:UIBarButtonItemStylePlain target:self action:@selector(btnSearchClicked)];
//    
//    [self.navigationItem setRightBarButtonItems:@[self.addGroupItem,self.btnSearchItem] animated:NO];
//    
//    [self socketStatusConnecting];
//    
//    // 初始化一堆控件和变量
//    [self initComponents];
//    
//    ApplicationGetAppInfoRequest *request = [[ApplicationGetAppInfoRequest alloc] initWithDelegate:self];
//    [request GetInfo];
//    
//    // 单纯存入uid改变取出的数据库
//    [MessageManager setUserId:[[UnifiedUserInfoManager share] userShowID]
//                     nickName:[[UnifiedUserInfoManager share] userName]];
//    [[MessageManager share] login];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginChat:) name:notify_show_singleChat object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginGroupChat:) name:notify_show_groupChat object:nil];
//    
//    // 注册消息连接状态监听
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketStatusConnecting) name:MTSocketConnectingNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketStatusConnected) name:MTSocketConnectSuccessedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketStatusNoConnect) name:MTSocketConnectFailedNotification object:nil];
//    
//    // 注册监听创建群聊
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(naviGroupChat) name:notify_create_group object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnSearchClicked) name:notify_begin_search object:nil];
//    
//    // 获取离线消息监听
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOfflineMsg) name:M_N_GETMESSAGELIST object:nil];
//    
//    // 注册异地登录的监听
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wsLoginOut:) name:MTLogoutNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avatarRemoveCache:) name:MTUserInfoChangeNotification object:nil];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//     [self.navigationController setNavigationBarHidden:NO animated:NO];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.tintColor = [UIColor themeBlue];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
//                                                                      NSFontAttributeName:[UIFont systemFontOfSize:18]}];
//    
//    self.doubleclick = YES;
//    [self RecordToDiary:@"进入聊天消息列表界面"];
//    [[MessageManager share] setDelegate:self];
//    
//    // 防止第一次重复获取
//    static BOOL firstTime = YES;
//    
//    if (!firstTime) {
//        [self refreshMessageListData];
//    }
//    firstTime = NO;
//}
//
//#pragma mark - Private Method
//// 是否显示空白页
//- (void)isShowEmptyPage
//{
//    if (self.messageList.count == 0) {
//        [self.emptyPageView setHidden:NO];
//    } else {
//        [self.emptyPageView setHidden:YES];
//    }
//}
//// 获取离线消息
//- (void)getOfflineMsg
//{
////    [[MessageManager share] setDelegate:self];
//    [[MessageManager share] getMessageList];
//}
//
//////搜索按钮暴力点击防御
//- (void)defenseNaviGroupChat
//{
//    [self.addGroupItem setEnabled:YES];
//}
//
//// 导航栏右上角按钮事件
//- (void)naviGroupChat
//{
//    //按钮暴力点击防御
//    [self.addGroupItem setEnabled:NO];
//    [self performSelector:@selector(defenseNaviGroupChat) withObject:nil afterDelay:0.5];
//
//    if (!self.dropListView.canappear) {
//        self.dropListView.canappear = YES;
//        [self.dropListView removeFromSuperview];
//        return;
//    }
//    
//    [self.dropListView setpassbackBlock:^(NSInteger selectIndex) {
//        switch (selectIndex) {
//            case 0:
//                // 发起群聊
//            {
//                SelectContactBookViewController *createVC = [SelectContactBookViewController new];
//                createVC.selectType = selectContact_createGroup;
//                [createVC setHidesBottomBarWhenPushed:YES];
//                [self presentViewController:createVC animated:YES completion:nil];
//            }
//                break;
//            case 1:
//            {
//                QRCodeReaderViewController *QRVC = [QRCodeReaderViewController new];
//                [QRVC setCompletionWithBlock:^(NSString * _Nullable resultAsString) {
//                    [self QRResult:resultAsString];
//                }];
//                QRVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:QRVC animated:YES];
//            }
//                break;
//            case 2:
//            {
//                ApplicationCreateNewMissionNavigationController *createMissionVC = [[ApplicationCreateNewMissionNavigationController alloc] init];
//                [createMissionVC.rootVC handleDataWithNavigationController:self.navigationController title:@"" completion:nil];
//                
//                HomeTabBarController *homeVC = (HomeTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//                [homeVC modalPresentViewController:createMissionVC];
//                
//            }
//                break;
//            case 3:
//            {
//                ApplicationCreateNavigationController *createScheduleVC = [[ApplicationCreateNavigationController alloc] init];
//                [createScheduleVC.rootVC handleDataWithNavigationController:self.navigationController title:@"" completion:nil];
//                
//                HomeTabBarController *homeVC = (HomeTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//                [homeVC modalPresentViewController:createScheduleVC];
//            }
//                break;
//            default:
//                break;
//        }
//    }];
//    
//    [self.view addSubview:self.dropListView];
//    [self.dropListView appear];
//}
//////搜索按钮暴力点击防御
//- (void)defenseBtnSearchClicked
//{
//    [self.btnSearchItem setEnabled:YES];
//}
////搜索按钮
//- (void)btnSearchClicked
//{
//    //按钮暴力点击防御
//    [self.btnSearchItem setEnabled:NO];
//    [self performSelector:@selector(defenseBtnSearchClicked) withObject:nil afterDelay:0.5];
//    
//    ChatSearchViewController *searchVC = [[ChatSearchViewController alloc] init];
//    [searchVC setIsquerySearch:YES];
//    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:searchVC];
//    [self presentViewController:nav animated:YES completion:nil];
//}
//
//// 初始化一堆控件
//- (void)initComponents
//{
//    _currTimeInterval = [[NSDate date] timeIntervalSince1970];
//    
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//}
//
//// 刷新消息列表
//- (void)refreshMessageListData
//{
//    // 去消息数据库刷新
//    [[MessageManager share] getMessageListCompletion:^(NSArray *arrayList) {
//        [self.messageList removeAllObjects];
//        [self.messageList addObjectsFromArray:arrayList];
//        [self.tableView reloadData];
//        [self isShowEmptyPage];
//    }];
//}
//
//// 发起和某个人的聊天信息
//- (void)beginChat:(NSNotification *)notification
//{
//    // 得到附件信息
//    NSDictionary *dictContact = [notification userInfo];
//    
//    // 弹出聊天窗口
//    ChatSingleViewController *singleChatVC = [[ChatSingleViewController alloc] init];
//    singleChatVC.strUid = [dictContact objectForKey:personDetail_show_id];
//    singleChatVC.strName = [dictContact objectForKey:personDetail_u_true_name];
//    singleChatVC.avatarPath = [dictContact objectForKey:personDetail_headPic];
//    
//    [singleChatVC setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:singleChatVC animated:YES];
//    
//}
//
//// 群聊
//- (void)beginGroupChat:(NSNotification *)notification
//{
//    NSDictionary *dictContact = [notification userInfo];
//    
//    ChatGroupViewController *groupChatVC = [[ChatGroupViewController alloc] init];
//    groupChatVC.strUid = [dictContact objectForKey:@"UserProfile_userName"];
//    groupChatVC.strName = [dictContact objectForKey:@"UserProfile_nickName"];
//    
//    groupChatVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:groupChatVC animated:YES];
//}
//
//// 播放声音
//- (void)playSoundForNewMessage
//{
////    // 根据时间间隔播放声音
////    NSTimeInterval newTimeInterval = [[NSDate date] timeIntervalSince1970];
////    if ((newTimeInterval - _currTimeInterval) > T_NOTIFYSOUND)
////    {
////        //        [Slacker playNotifySoundIntellective];
////        _currTimeInterval = newTimeInterval;
////    }
//}
//
//// 消息状态的监听处理事件
//- (void)socketStatusConnecting {
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
//    
//    UIActivityIndicatorView *acivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    acivityIndicator.tintColor = [UIColor blackColor];
//    [acivityIndicator startAnimating];
//    [titleView addSubview:acivityIndicator];
//    
//    UILabel *titleLabel = [UILabel new];
//    titleLabel.font = [UIFont systemFontOfSize:18];
//    titleLabel.textColor = [UIColor blackColor];
//    titleLabel.text = LOCAL(CONNECTING);
//    [titleView addSubview:titleLabel];
//    
//    [acivityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.top.equalTo(titleView);
//    }];
//    
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.right.equalTo(titleView);
//        make.left.equalTo(acivityIndicator.mas_right);
//    }];
//    
//    self.navigationItem.titleView = titleView;
//    [titleView sizeToFit];
//}
//
//- (void)socketStatusConnected
//{
//    self.navigationItem.titleView = nil;
//    [self setTitle:LOCAL(HOMETABBAR_MESSAGE)];
//}
//
//- (void)socketStatusNoConnect
//{
//    self.navigationItem.titleView = nil;
//    [self setTitle:LOCAL(UNCONNECT)];
//}
//
//- (void)avatarRemoveCache:(NSNotification *)notification {
//    avatarRemoveCache(notification.object);
//}
//
//- (void)wsLoginOut:(NSNotification *)notification
//{
//    NSLog(@"WSLOGOUT");
//    
//    AppDelegate *aDelegate = [UIApplication sharedApplication].delegate;
//    [aDelegate.controllerManager releaseHomeView];
//#ifdef CHINAMODE
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCAL(CHANGEDEVICE) message:notification.object delegate:nil cancelButtonTitle:LOCAL(CONFIRM) otherButtonTitles:nil];
//    [alertView show];
//#else
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCAL(PROMPT) message:LOCAL(CHANGEDEVICE) delegate:nil cancelButtonTitle:LOCAL(CONFIRM) otherButtonTitles:nil];
//    [alertView show];
//#endif
//}
//
//- (void)QRResult:(NSString *)string {
//    [self.navigationController popViewControllerAnimated:NO];
//    if ([string hasPrefix:@"{\"id\":"]) {
//        QRLoginViewController *VC = [[QRLoginViewController alloc] initWithId:string];
//        
//        VC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:VC animated:YES];
//        return;
//    }
//    
//    WebViewController *webVC = [[WebViewController alloc] initWithURL:string];
//    webVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:webVC animated:YES];
//}
//
//#pragma mark - UITableView Delegate
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return self.messageList.count;}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return [MessageListCell height];}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 0.01;}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:[MessageListCell identifier]];
////    cell.delegate = self;
//    ContactDetailModel *model = [self.messageList objectAtIndex:indexPath.row];
//    [cell setModel:model];
//    if (indexPath.row > 2)
//    {
////        [cell setRightUtilityButtons:[self rightButtonsIsTop:model._extensionModel._isTop]];
//    }
//    
//    //    [cell.contentView setBackgroundColor:(model._extensionModel._isTop ? COLOR_THEME_GRAY : [UIColor whiteColor])];
//    
//    return cell;
//}
//
//- (NSArray *)rightButtonsIsTop:(BOOL)isTop
//{
//    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
////    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
////                                                title:(isTop ? LOCAL(CANCELTOP) : LOCAL(ISTOP))];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
//                                                title:LOCAL(DELETE)];
//    
//    return rightUtilityButtons;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (!self.doubleclick) {
//        return;
//    }
//    
//    self.doubleclick = NO;
//    // 取出数据
//    ContactDetailModel *model = [self.messageList objectAtIndex:indexPath.row];
//    
//    if ([model isRelationSystem]) {
//        ChatRelationViewController *VC = [[ChatRelationViewController alloc] init];
//        VC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:VC animated:YES];
//        return;
//    }
//    
//    // 判断是App还是聊天
//    if (model._isApp)
//    {
//        // 获得消息类型
//        IM_Applicaion_Type type = (IM_Applicaion_Type)[MessageBaseModel getMsgTypeFromString:model._target];
//        NewApplicationMessageListViewController *appVC = [[NewApplicationMessageListViewController alloc] initWithAppType:type];
////        ApplicationMessageListViewController *appVC = [[ApplicationMessageListViewController alloc] initWithAppType:type];
//
//        switch (type) {
//            case IM_Applicaion_approval:
//                [MixpanelMananger track:@"home/approve"];
//                break;
//            case IM_Applicaion_schedule:
//                [MixpanelMananger track:@"home/calendar"];
//                break;
//            case IM_Applicaion_task:
//                [MixpanelMananger track:@"home/task"];
//                break;
//            default:
//                break;
//        }
//        //从右往左
//        [appVC setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:appVC animated:YES];
//        
//    }else if (!model._isGroup)
//    {
//        // 跳转到联系人聊天窗口
//        ChatSingleViewController *chatVC = [[ChatSingleViewController alloc] initWithDetailModel:model];
//        //        chatVC.strUid = model._target;
//        //        chatVC.strName = model._nickName;
//        //        chatVC.avatarPath = model._headPic;
//        //        chatVC.strDepartment = model._parentDeptName;
//        [chatVC setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:chatVC animated:YES];
//    }
//    
//    else
//    {
//        // 跳转到群聊窗口
//        ChatGroupViewController *chatGroupVC = [[ChatGroupViewController alloc] initWithDetailModel:model];
//        //        chatGroupVC.strUid = model._target;
//        //        chatGroupVC.strName = model._nickName;
//        //        chatGroupVC.avatarPath = model._headPic;
//        [chatGroupVC setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:chatGroupVC animated:YES];
//    }
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return LOCAL(DELETE);
//}
//
//// 删除单元格
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        ContactDetailModel *model = [self.messageList objectAtIndex:indexPath.row];
//
//        [self postLoading];
//        [self RecordToDiary:@"删除消息列表tableview里的消息"];
//        
//        NSString *removeSession = model._target;
//        [[MessageManager share] removeSessionUid:removeSession completion:^(BOOL isSuccess){
//            if (!isSuccess) {
//                [self postError:LOCAL(ERROROTHER)];
//                return;
//            }
//            
//            [self hideLoading];
//            [UIView performWithoutAnimation:^{
//                [self.tableView reloadData];
//            }];
//            
//            for (NSInteger i = 0; i < [self.messageList count]; i ++) {
//                ContactDetailModel *model = [self.messageList objectAtIndex:i];
//                if (![model._target isEqualToString:removeSession]) {
//                    continue;
//                }
//                
//                // 单元格删除特效
//                [self.tableView beginUpdates];
//                [self.messageList removeObjectAtIndex:i];
//                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//                [self.tableView endUpdates];
//                [self isShowEmptyPage];
//                // 发送底部栏未读消息条数变化的通知
//                [[NSNotificationCenter defaultCenter] postNotificationName:MTBadgeCountChangedNotification object:nil];
//                [self RecordToDiary:@"底部栏未读消息条数变化的通知"];
//                break;
//            }
//        }];
//    }
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//#pragma mark - SWTableViewDelegate
//
//- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
//{
//    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
//    ContactDetailModel *model = [self.messageList objectAtIndex:cellIndexPath.row];
//    
//    switch (index) {
////        case 0:         // 置顶
//            //        {
//            // 置反原有置顶设置
//            //            [model markMessageTopSet];
//            //
//            //            // 更改数据库后刷新
//            //            [[UnifiedSqlManager share] markMessageTopSetWith:model];
//            //
//            //            // 刷新列表
//            //            [self refreshMessageListData];
//            //
//            //            // 还原单元格自身
//            //            [cell hideUtilityButtonsAnimated:YES];
//            //            break;
//            //        }
//        case 0: // 删除
//        {
//            [self postLoading];
//            NSString *removeSession = model._target;
//            [[MessageManager share] removeSessionUid:removeSession completion:^(BOOL isSuccess){
//                if (!isSuccess) {
//                    [self postError:LOCAL(ERROROTHER)];
//                    return;
//                }
//                
//                [self hideLoading];
//                [UIView performWithoutAnimation:^{
//                    [self.tableView reloadData];
//                }];
//                
//                for (NSInteger i = 0; i < [self.messageList count]; i ++) {
//                    ContactDetailModel *model = [self.messageList objectAtIndex:i];
//                    if (![model._target isEqualToString:removeSession]) {
//                        continue;
//                    }
//                    
//                    // 单元格删除特效
//                    [self.tableView beginUpdates];
//                    [self.messageList removeObjectAtIndex:i];
//                    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//                    [self.tableView endUpdates];
//                    [self isShowEmptyPage];
//                    // 发送底部栏未读消息条数变化的通知
//                    [[NSNotificationCenter defaultCenter] postNotificationName:MTBadgeCountChangedNotification object:nil];
//                    [self RecordToDiary:@"底部栏未读消息条数变化的通知"];
//                    break;
//                }
//            }];
//            break;
//        }
//        default:
//            break;
//    }
//}
//
//- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
//{
//    // allow just one cell's utility button to be open at once
//    return YES;
//}
//
//#pragma mark - MessageManager Delegate
//// 新消息到达等需要重新刷新列表
//- (void)MessageManagerDelegateCallBack_needRefreshWithTareget:(NSString *)target
//{
//    // 刷新消息列表数据
//    [self refreshMessageListData];
//    [self RecordToDiary:@"新消息到达等需要重新刷新列表"];
//    // 播放声效提醒
//    [self playSoundForNewMessage];
//}
//
//- (void)MessageManagerDelegateCallBack_removeSessionWithTarget:(NSString *)target {
//    __block NSUInteger index = NSUIntegerMax;
//    [self.messageList enumerateObjectsUsingBlock:^(ContactDetailModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([model._target isEqualToString:target]) {
//            *stop = YES;
//            index = idx;
//        }
//    }];
//    
//    if (index != NSUIntegerMax) {
//        [self.messageList removeObjectAtIndex:index];
//        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}
//
//- (void)MessageManagerDelegateCallBack_clearUnreadWithTarget:(NSString *)target {
//    [self.messageList enumerateObjectsUsingBlock:^(ContactDetailModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([model._target isEqualToString:target]) {
//            *stop = YES;
//            model._countUnread = 0;
//            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//        }
//    }];
//}
//
//// 退群的消息委托
//- (void)MessageManagerDelegateCallBack_quitGroupWithTareget:(NSString *)target
//{
//    // 刷新消息列表数据
//    [self refreshMessageListData];
//    [self RecordToDiary:@"刷新消息列表数据"];
//    
//    // 播放声效提醒
//    [self playSoundForNewMessage];
//}
//
//// 信息更改的消息委托
//- (void)MessageManagerDelegateCallBack_refreshContactProfileRefresh:(UserProfileModel *)userProfile
//{
//    // 刷新消息列表数据
//    [self refreshMessageListData];
//    [self RecordToDiary:@"信息更改的消息委托"];
//    
//    // 播放声效提醒
//    [self playSoundForNewMessage];
//}
//
//// 离线消息刷新
//- (void)MessageManagerDelegateCallBack_needRefreshWithOfflineMessage
//{
//    // 刷新消息列表数据
//    [self refreshMessageListData];
//    [self RecordToDiary:@"离线消息刷新"];
//    
//    // 播放声效提醒
//    [self playSoundForNewMessage];
//}
//
//// 撤回重发消息刷新(最后一条)
//- (void)MessageManagerDelegateCallBack_reSendRefreshWithMessageBaseModel:(MessageBaseModel *)model
//{
//    // 刷新消息列表数据
//    [self refreshMessageListData];
//    [self RecordToDiary:@"消息撤回刷新"];
//    
//    // 播放声效提醒
//    [self playSoundForNewMessage];
//}
//#pragma mark - ToReadDataManaqger Delegate
//// 待阅新消息委托回调
//- (void)ToReadDataManagerDelegateCallBack_needRefreshListData
//{
//    // 刷新消息列表数据
//    [self refreshMessageListData];
//    [self RecordToDiary:@"待阅新消息委托回调"];
//    
//    // 播放声效提醒
//    [self playSoundForNewMessage];
//}
//// 新消息提醒
//- (void)MessageManagerDelegateCallBack_PlaySystemKind
//{
//    // 消息提醒
//    // 刷新消息列表数据
//    // 播放声效提醒
//    // 根据时间间隔播放声音
//    NSTimeInterval newTimeInterval = [[NSDate date] timeIntervalSince1970];
//    if ((newTimeInterval - _currTimeInterval) > T_NOTIFYSOUND)
//    {
//        [Slacker playNotifySoundIntellective];
//        _currTimeInterval = newTimeInterval;
//    }
//
//}
//
//- (void)compareWithimgs:(NSMutableArray *)arrModels;
//{
//    NSMutableDictionary *dictcollect = [[NSMutableDictionary alloc] init];
//    for (ApplicationAppInfoModel *model in arrModels)
//    {
//        NSString *stringurl = [NSString stringWithFormat:@"%@/Base-Module/Annex/AppIcon?annexType=APPIcon&width=150&height=150&fileName=%@",la_imgURLAddress,model.APP_ICON_MOBILE];
//        
//        if ([model.SHOW_ID isEqualToString:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdCalendar]])
//        {
//            [dictcollect setObject:stringurl forKey:@(1)];
//        }
//        else if ([model.SHOW_ID isEqualToString:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdApprove]])
//        {
//            [dictcollect setObject:stringurl forKey:@(0)];
//        }
//        else if ([model.SHOW_ID isEqualToString:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdNewTask]])
//        {
//            [dictcollect setObject:stringurl forKey:@(2)];
//        }
//        
//    }
//    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:dictcollect];
//    NSString *Path =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
//    NSString *filename = [Path stringByAppendingPathComponent:@"appImgs"];
//    [NSKeyedArchiver archiveRootObject:dict toFile:filename];
//}
//
//#pragma mark - BaseRequest Delegate
//- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
//    if ([response isKindOfClass:[ApplicationGetAppInfoResponse class]])
//    {
//        [self compareWithimgs:((ApplicationGetAppInfoResponse *)response).arrAppModels];
//        [self.tableView reloadData];
//    }
//}
//
//- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
//    [self postError:errorMessage];
//}
//
//#pragma mark - Initializer
//- (UITableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//
//        [_tableView setSeparatorColor:[UIColor borderColor]];
//        [_tableView setBackgroundColor:[UIColor whiteColor]];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        _tableView.separatorColor = [UIColor colorWithHex:0xebebeb];
//        
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 0);
//        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//            _tableView.layoutMargins = UIEdgeInsetsMake(0, 13, 0, 0);
//        }
//        
//        [_tableView registerClass:[MessageListCell class] forCellReuseIdentifier:[MessageListCell identifier]];
//    }
//    return _tableView;
//}
//
//- (NSMutableArray *)messageList {
//    if (!_messageList) {
//        _messageList = [NSMutableArray array];
//    }
//    return _messageList;
//}
//
//- (NomarlDealWithEventView *)dropListView {
//    if (!_dropListView) {
//        NSArray *images = @[[UIImage imageNamed:@"Touch_Chat"],
//                            [UIImage imageNamed:@"Touch_Code"],
//                            [UIImage imageNamed:@"app_title_task"],
//                            [UIImage imageNamed:@"Touch_Calendar"]];
//        NSArray *titles = @[LOCAL(QUICK_NEW_CHAT),
//                            LOCAL(QUICK_QRCODE),
//                            LOCAL(QUICK_NEW_TASK),
//                            LOCAL(QUICK_NEW_SCHEDULE)];
//        _dropListView = [[NomarlDealWithEventView alloc] initWithArrayLogos:images arrayTitles:titles];
//        _dropListView.canappear = YES;
//    }
//    return _dropListView;
//}
//
//- (ChatEmptyView *)emptyPageView
//{
//    if (!_emptyPageView) {
//        _emptyPageView = [[ChatEmptyView alloc] init];
//        [self.view addSubview:_emptyPageView];
//        [_emptyPageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.tableView);
//        }];
//    }
//    return _emptyPageView;
//}
//
//@end
