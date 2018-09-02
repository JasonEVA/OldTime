//
//  CoordinationStartViewController.m
//  HMDoctor
//
//  Created by yinquan on 16/4/9.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CoordinationStartViewController.h"
#import "ATModuleInteractor+CoordinationInteractor.h"
#import "CoordinationMessageListAdapter.h"
#import "CoordinationFilterView.h"
#import "CoordinationSearchResultViewController.h"
#import "HMDoctorEnum.h"
#import "SessionListTableViewCell.h"
#import "SessionListModel.h"
#import "ChatIMConfigure.h"
#import "MessageListCell.h"
#import "IMApplicationConfigure.h"
#import "IMMessageHandlingCenter.h"

static BOOL kCoordinationFirstTime = YES;
@interface CoordinationStartViewController ()<MessageManagerDelegate,ATTableViewAdapterDelegate,CoordinationFilterViewDelegate,UISearchResultsUpdating,CoordinationMessageListAdapterDelegate,UISearchBarDelegate>

@property (nonatomic, strong)  CoordinationMessageListAdapter  *messageAdapter; // <##>

@property (nonatomic, strong)  UITableView  *tableView; // <##>
//@property (nonatomic, strong)  UISearchController  *searchVC; // <##>
@property (nonatomic, strong)  CoordinationFilterView  *filterView; // <##>
//@property (nonatomic, strong)  CoordinationSearchResultViewController  *resultVC; // <##>
@property (nonatomic) BOOL firstIn;

@end

@implementation CoordinationStartViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    if ([IMMessageHandlingCenter sharedInstance] != nil) {
        [[IMMessageHandlingCenter sharedInstance] removeObserver:self forKeyPath:SESSIONSTATUS];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"消息"];
    self.definesPresentationContext = YES;
    [self configElements];
    
    self.firstIn = YES;
    [self at_postLoading];
    [self refreshMessageListData];
    [self configNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IMMessageHandlingCenter sharedInstance] registerDelegate:self];
    //获取会话列表
    // 防止第一次重复获取
    if (!kCoordinationFirstTime) {

        [self refreshMessageListData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.view.subviews containsObject:self.filterView]) {
        [self.filterView removeFromSuperview];
        _filterView = nil;
    }
    // 移除委托
    [[IMMessageHandlingCenter sharedInstance] deregisterDelegate:self];
    kCoordinationFirstTime = NO;
}
#pragma mark - Interface Method

#pragma mark - Private Method

- (void)configNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessageListData) name:HMWORKCLEANALLUNREDESMESSAGESUCCESS object:nil];
    
    [[IMMessageHandlingCenter sharedInstance] addObserver:self forKeyPath:SESSIONSTATUS options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

}
// 设置元素控件
- (void)configElements {
    
    UIBarButtonItem *taskItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(taskAction)];
    UIBarButtonItem *contacts = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"contact"] style:UIBarButtonItemStylePlain target:self action:@selector(contactClick)];
    [self.navigationItem setRightBarButtonItems:@[taskItem,contacts]];
    [self.view addSubview:self.tableView];
    
    
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
 [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.edges.equalTo(self.view);
 }];
}

// 设置数据
- (void)configData {
    
}

// 获取离线消息
- (void)getOfflineMsg
{
    [[MessageManager share] getMessageList];
}
// 刷新消息列表
- (void)refreshMessageListData
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(p_refreshSessionList) object:nil];
    [self performSelector:@selector(p_refreshSessionList) withObject:nil afterDelay:0.3];
//    [self p_refreshSessionList];
}

- (void)p_refreshSessionList {
    NSLog(@"%@=-=刷刷刷刷刷刷刷刷刷刷刷刷新",NSStringFromClass([self class]));
    // 去消息数据库刷新
    __weak typeof(self) weakSelf = self;
    
    [[MessageManager share] queryMessageListWithoutTags:@[im_doctorPatientGroupTag] limit:-1 offset:0 completion:^(NSArray<ContactDetailModel *> *arrayList) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSMutableArray *array = [NSMutableArray arrayWithArray:arrayList];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_target = %@",im_task_uid];
        NSArray *arrayTask =[array filteredArrayUsingPredicate:predicate];
        if (arrayTask.count > 0) {
            [array removeObject:arrayTask.firstObject];
            [array insertObject:arrayTask.firstObject atIndex:0];
        }
        else {
            ContactDetailModel *model = [[ContactDetailModel alloc] init];
            model._target = im_task_uid;
            model._isApp = YES;
            [array insertObject:model atIndex:0];
        }
        [strongSelf.messageAdapter.adapterArray removeAllObjects];
        [strongSelf.messageAdapter.adapterArray addObjectsFromArray:array];
        if (strongSelf.firstIn) {
            [strongSelf at_hideLoading];
            strongSelf.firstIn = NO;
        }        [strongSelf.tableView reloadData];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // 会话状态
    if ([keyPath isEqualToString:SESSIONSTATUS]) {
        if ([change[@"new"] integerValue]) {
            [self at_postLoading:@"加载中"];
        }
        else {
            [self at_hideLoading];
        }
        
    }
}

#pragma mark - Event Response

- (void)taskAction {
    if (![self.view.subviews containsObject:self.filterView]) {
        [self.view addSubview:self.filterView];
        [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    else {
        [self.filterView removeFromSuperview];
        _filterView = nil;
    }

}

//联系人
- (void)contactClick
{
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作组－联系人"];
    [[ATModuleInteractor sharedInstance] goToConactsVC];
}

#pragma mark - MessageManager Delegate

// 新消息到达等需要重新刷新列表
- (void)MessageManagerDelegateCallBack_needRefreshWithTareget:(NSString *)target
{
    // 刷新消息列表数据
    NSLog(@"%@=-=MessageManagerDelegateCallBack_needRefreshWithTareget新消息到达等需要重新刷新列表",NSStringFromClass([self class]));
    [self refreshMessageListData];
    //[self RecordToDiary:@"新消息到达等需要重新刷新列表"];
    // 播放声效提醒
    //[self playSoundForNewMessage];
    
}

- (void)MessageManagerDelegateCallBack_receiveMessage:(MessageBaseModel *)model {
    // 刷新消息列表数据

    NSLog(@"%@=-=MessageManagerDelegateCallBack_receiveMessage",NSStringFromClass([self class]));
    [self refreshMessageListData];
}

- (void)MessageManagerDelegateCallBack_removeSessionWithTarget:(NSString *)target {
    __block NSUInteger index = NSUIntegerMax;
    [self.messageAdapter.adapterArray enumerateObjectsUsingBlock:^(ContactDetailModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model._target isEqualToString:target]) {
            *stop = YES;
            index = idx;
        }
    }];
    
    if (index != NSUIntegerMax) {
        [self.messageAdapter.adapterArray removeObjectAtIndex:index];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)MessageManagerDelegateCallBack_clearUnreadWithTarget:(NSString *)target {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF._target == %@",target];
    NSArray *array = [self.messageAdapter.adapterArray filteredArrayUsingPredicate:predicate];
    if (array && array.count > 0) {
        ContactDetailModel *model = array.firstObject;
        model._countUnread = 0;
        NSInteger idx = [self.messageAdapter.adapterArray indexOfObject:model];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }

//    [self.messageAdapter.adapterArray enumerateObjectsUsingBlock:^(ContactDetailModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([model._target isEqualToString:target]) {
//            *stop = YES;
//            model._countUnread = 0;
//            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//        }
//    }];
}

// 退群的消息委托
- (void)MessageManagerDelegateCallBack_quitGroupWithTareget:(NSString *)target
{
    // 刷新消息列表数据
    NSLog(@"%@=-=MessageManagerDelegateCallBack_quitGroupWithTareget退群的消息委托",NSStringFromClass([self class]));
    [self refreshMessageListData];
    //[self RecordToDiary:@"刷新消息列表数据"];
    
    // 播放声效提醒
   // [self playSoundForNewMessage];
}

// 信息更改的消息委托
- (void)MessageManagerDelegateCallBack_refreshContactProfileRefresh:(UserProfileModel *)userProfile
{
    if ([userProfile.tag isEqualToString:im_doctorPatientGroupTag]) {
        return;
    }
    NSLog(@"%@=-=MessageManagerDelegateCallBack_refreshContactProfileRefresh信息更改的消息委托",NSStringFromClass([self class]));
    [self refreshMessageListData];
}


// 撤回重发消息刷新(最后一条)
- (void)MessageManagerDelegateCallBack_reSendRefreshWithMessageBaseModel:(MessageBaseModel *)model
{

    // 刷新消息列表数据
    NSLog(@"%@=-=MessageManagerDelegateCallBack_reSendRefreshWithMessageBaseModel撤回重发消息刷新(最后一条)",NSStringFromClass([self class]));
    [self refreshMessageListData];
   // [self RecordToDiary:@"消息撤回刷新"];
    
    // 播放声效提醒
   // [self playSoundForNewMessage];
}

#pragma mark - CoordinationMessageListAdapterDelegate
- (void)CoordinationMessageListAdapterDelegateCallBack_muteNotification:(ContactDetailModel *)model
{
    userProfileReceiveMode receiveMode = model._muteNotification ?  kUserProfileReceiveNormal : kUserProfileReceiveAccept ;
   __weak typeof(self) weakSelf = self;
        [[MessageManager share] groupSessionUid:model._target receiveMode:receiveMode completion:^(BOOL success) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (success) {
                NSLog(@"%@=-=CoordinationMessageListAdapterDelegateCallBack_muteNotification",NSStringFromClass([strongSelf class]));
                [strongSelf refreshMessageListData];
                return;
            }
        }];

}

#pragma mark - CoordinationFilterViewDelegate
- (void)CoordinationFilterViewDelegateCallBack_ClickWithTag:(NSInteger)tag
{
    TitelType type = (TitelType)tag;
    switch (type) {
        case AddNewFriendType: {
            //
            [[ATModuleInteractor sharedInstance] goAddFriends];

            break;
        }
        case CreateWorkCircle: {
            [[ATModuleInteractor sharedInstance] goCreateWorkCircleIsCreate:YES nonSelectableContacts:nil workCircleID:nil];

            break;
        }
        case AddNewMissionType: {
            [[ATModuleInteractor sharedInstance] goToAddNewMission];
            break;
        }
    }

}

#pragma mark - Adapter Delegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    ContactDetailModel *model = self.messageAdapter.adapterArray[indexPath.row];
    if (model._isApp) {
        // 任务列表
        [[ATModuleInteractor sharedInstance] goTaskList];
    }
    else if ([model isRelationSystem]) {
        //新朋友
        [[ATModuleInteractor sharedInstance] goNewFriendWithContactDetailModel:model];
    }

    else if (model._isGroup) {
        // 工作组
        [[ATModuleInteractor sharedInstance] goToGroupChatVCWith:self.messageAdapter.adapterArray[indexPath.row] chatType:IMChatTypeWorkGroup];
    }
    else {
        //单聊
        [[ATModuleInteractor sharedInstance] goSingleChatVCWith:self.messageAdapter.adapterArray[indexPath.row] chatType:IMChatTypeWorkGroup];
    }
}

- (void)deleteCellData:(id)cellData indexPath:(NSIndexPath *)indexPath {
    ContactDetailModel *model = self.messageAdapter.adapterArray[indexPath.row];
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] removeSessionUid:model._target completion:^(BOOL success) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!success) {
            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            return;
        }
        // 服务器会推送socket消息
    }];
}

#pragma mark - UISearchResultUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"-------------->updating");

}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    CoordinationSearchResultViewController *resultVC = [CoordinationSearchResultViewController new];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:resultVC];
    [self presentViewController:nav animated:YES completion:nil];
    [self.view endEditing:YES];
    return YES;
}


#pragma mark - Override

#pragma mark - Init

- (CoordinationMessageListAdapter *)messageAdapter {
    if (!_messageAdapter) {
        _messageAdapter = [CoordinationMessageListAdapter new];
        _messageAdapter.adapterDelegate = self;
        _messageAdapter.tableView = self.tableView;
        _messageAdapter.messageAdepterDelegate = self;
    }
    return _messageAdapter;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor commonBackgroundColor]];
        _tableView.delegate = self.messageAdapter;
        _tableView.dataSource = self.messageAdapter;
        _tableView.rowHeight = 60;
        UISearchBar *searchBar = [UISearchBar new];
        searchBar.placeholder = @"搜索";
        [searchBar setDelegate:self];
        [searchBar sizeToFit];
        [searchBar setBackgroundImage:[UIImage imageColor:[UIColor colorWithHexString:@"f0f0f0"] size:CGSizeMake(1, 1) cornerRadius:0]];
        [_tableView setTableHeaderView:searchBar];
        [_tableView setTableFooterView:[UIView new]];
        [_tableView registerClass:[MessageListCell class] forCellReuseIdentifier:[MessageListCell at_identifier]];

    }
    return _tableView;
}

//- (UISearchController *)searchVC {
//    if (!_searchVC) {
//        _searchVC = [[UISearchController alloc] initWithSearchResultsController:self.resultVC];
//        _searchVC.searchResultsUpdater = self;
//        _searchVC.searchBar.placeholder = @"搜索";
//        [_searchVC.searchBar sizeToFit];
//        _searchVC.hidesNavigationBarDuringPresentation = NO;
//        [_searchVC.searchBar setBackgroundImage:[UIImage imageColor:[UIColor colorWithHexString:@"f0f0f0"] size:CGSizeMake(1, 1) cornerRadius:0]];
//    }
//    return _searchVC;
//}
- (CoordinationFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[CoordinationFilterView alloc] initWithImageNames:@[@"c_addFriend",@"c_addWorkCircle",@"c_newTask"] titles:@[@"加好友",@"创建工作圈",@"新建任务"] tags:@[@(AddNewFriendType),@(CreateWorkCircle),@(AddNewMissionType)]];
        _filterView.delegate = self;
    }
    return _filterView;
}

//- (CoordinationSearchResultViewController *)resultVC {
//    if (!_resultVC) {
//        _resultVC = [CoordinationSearchResultViewController new];
//    }
//    return _resultVC;
//}

@end
