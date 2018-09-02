//
//  SESessionListOneTypeViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/9/26.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SESessionListOneTypeViewController.h"
#import "CoordinationMessageListAdapter.h"
#import "MessageListCell.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "IMMessageHandlingCenter.h"
#import "ATModuleInteractor+PatientChat.h"
#import "IMPatientContactExtensionModel.h"
#import "ChatIMConfigure.h"

static BOOL kPatinetFirstTime = YES;

@interface SESessionListOneTypeViewController ()<MessageManagerDelegate,ATTableViewAdapterDelegate,CoordinationMessageListAdapterDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong)  CoordinationMessageListAdapter  *messageAdapter; // <##>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) SESessionListType sessionType;
@property (nonatomic) BOOL firstIn;
@property (nonatomic, copy)  NSString  *currentSelectSessionID; // 当前点击的会话ID

@end

@implementation SESessionListOneTypeViewController
- (instancetype)initWithSessionType:(SESessionListType)type
{
    self = [super init];
    if (self) {
        self.sessionType = type;
        self.title = [SESessionListEnmu sessionTypeList][type];
    }
    return self;
}

- (void)dealloc {
        if ([IMMessageHandlingCenter sharedInstance] != nil) {
            [[IMMessageHandlingCenter sharedInstance] removeObserver:self forKeyPath:SESSIONSTATUS];
        }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configElements];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.firstIn = YES;
    [self at_postLoading];
    [self refreshMessageListData];
    
     [[IMMessageHandlingCenter sharedInstance] addObserver:self forKeyPath:SESSIONSTATUS options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 注册委托
    [[IMMessageHandlingCenter sharedInstance] registerDelegate:self];
    
    //获取会话列表
    // 防止第一次重复获取
    if (!kPatinetFirstTime) {
        [self refreshMessageListData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 移除委托
    [[IMMessageHandlingCenter sharedInstance] deregisterDelegate:self];
    kPatinetFirstTime = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
    
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] queryMessageListByTag:im_doctorPatientGroupTag limit:-1 offset:0 completion:^(NSArray<ContactDetailModel *> *arrayList) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.messageAdapter.adapterArray removeAllObjects];
        [strongSelf.messageAdapter.adapterArray addObjectsFromArray:[self JWGetSomeTypeSessionListWithType:self.sessionType allSessionList:arrayList]];
        [strongSelf.tableView reloadData];
        
        if (strongSelf.firstIn) {
            [strongSelf at_hideLoading];
            strongSelf.firstIn = NO;
        }
    }];
}

- (NSArray<ContactDetailModel *> *)JWGetSomeTypeSessionListWithType:(SESessionListType)type allSessionList:(NSArray<ContactDetailModel *> *)allSessionList{
    __block NSMutableArray *showArr = [NSMutableArray array];
    
    [allSessionList enumerateObjectsUsingBlock:^(ContactDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IMPatientContactExtensionModel *tempModel  = [IMPatientContactExtensionModel mj_objectWithKeyValues:obj._extension.mj_JSONObject];
        if (tempModel.isBlocService == 1) {
            // 集团
            
            if (tempModel.blocRank == 3) {
                // 集团VIP
                if (
                    type == SESessionListType_GroupVIP) {
                    [showArr addObject:obj];
                }
            }
            else if ( tempModel.blocRank == 2) {
                // 集团中层
                if (type == SESessionListType_GroupMiddle) {
                    [showArr addObject:obj];
                }
            }
            else if (tempModel.blocRank == 1) {
                // 集团普通
                if (type == SESessionListType_GroupCommon) {
                    [showArr addObject:obj];
                }
            }
            else {
                NSLog(@"%@", [NSString stringWithFormat:@"集团未知分类 %@ --- %@",obj._target,obj._extension]);
            }
            
        }
        else if (tempModel.isBlocService == 0) {
            // 个人
            if (tempModel.classify == 2 || tempModel.classify == 4) {
                // 个人套餐
                if (type == SESessionListType_PersonalPackage) {
                    [showArr addObject:obj];
                }
            }
            else if (tempModel.classify == 3) {
                // 个人免费
                if (type == SESessionListType_PersonalFollow) {
                    [showArr addObject:obj];
                }
                
            }
            else if (tempModel.classify == 5) {
                // 个人单项
                if (type == SESessionListType_PersonalSingle) {
                    [showArr addObject:obj];
                }
            }
            else {
                NSLog(@"%@", [NSString stringWithFormat:@"个人未知分类 %@ --- %@",obj._target,obj._extension]);
            }
        }
        else {
            NSLog(@"%@", [NSString stringWithFormat:@"未知分类 %@ --- %@",obj._target,obj._extension]);
        }
    }];
    
    return showArr;
}

#pragma mark - event Response

#pragma mark - MessageManager Delegate
// 新消息到达等需要重新刷新列表
- (void)MessageManagerDelegateCallBack_needRefreshWithTareget:(NSString *)target
{
    // 刷新消息列表数据
    NSLog(@"%@=-=MessageManagerDelegateCallBack_needRefreshWithTareget新消息到达等需要重新刷新列表",NSStringFromClass([self class]));
    //    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMessageListData) object:nil];
    //    [self performSelector:@selector(refreshMessageListData) withObject:nil afterDelay:0.3];
    [self refreshMessageListData];
    //[self RecordToDiary:@"新消息到达等需要重新刷新列表"];
    // 播放声效提醒
    //[self playSoundForNewMessage];
    
}

- (void)MessageManagerDelegateCallBack_receiveMessage:(MessageBaseModel *)model {
    // 刷新消息列表数据
    
    NSLog(@"%@=-=MessageManagerDelegateCallBack_receiveMessage新消息到达等刷新消息列表数据",NSStringFromClass([self class]));
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
    NSLog(@"%@=-=MessageManagerDelegateCallBack_quitGroupWithTareget新消退群的消息委托",NSStringFromClass([self class]));
    
    [self refreshMessageListData];
    //[self RecordToDiary:@"刷新消息列表数据"];
    
    // 播放声效提醒
    // [self playSoundForNewMessage];
}

// 信息更改的消息委托
- (void)MessageManagerDelegateCallBack_refreshContactProfileRefresh:(UserProfileModel *)userProfile
{
    if (![userProfile.tag isEqualToString:im_doctorPatientGroupTag]) {
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
#pragma mark - Adapter Delegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    ContactDetailModel *model = self.messageAdapter.adapterArray[indexPath.row];
    self.currentSelectSessionID = model._target;
    if (model._isApp) {
        // 应用
    }
    else if ([model isRelationSystem]) {
        //新朋友
    }
    else if (model._isGroup) {
        // 工作组 / 群
        [[ATModuleInteractor sharedInstance] goToSEPatientChatWithContactDetailModel:model];
    }
    else {
        //单聊
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

#pragma mark - DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无任何消息" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]}];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"b"];
}



- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    if (!self.messageAdapter.adapterArray ||self.messageAdapter.adapterArray.count == 0) {
        return YES;
    }
    return NO;
}
#pragma mark KVO
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

#pragma mark - request Delegate

#pragma mark - Interface

#pragma mark - init UI
- (CoordinationMessageListAdapter *)messageAdapter {
    if (!_messageAdapter) {
        _messageAdapter = [CoordinationMessageListAdapter new];
        _messageAdapter.adapterDelegate = self;
        _messageAdapter.tableView = self.tableView;
        _messageAdapter.messageAdepterDelegate = self;
    }
    return _messageAdapter;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.messageAdapter;
        _tableView.dataSource = self.messageAdapter;
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setRowHeight:60];
        [_tableView registerClass:[MessageListCell class] forCellReuseIdentifier:[MessageListCell at_identifier]];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)]];

    }
    return _tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
