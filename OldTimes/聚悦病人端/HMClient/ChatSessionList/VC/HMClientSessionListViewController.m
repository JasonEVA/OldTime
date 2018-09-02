//
//  HMClientSessionListViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/10/19.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMClientSessionListViewController.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "HMClientSessionMainTableViewCell.h"
#import "HMSessionListInteractor.h"
#import "IMMessageHandlingCenter.h"
#import "HMStaffNavTitleHistoryChatViewController.h"
#import "IMPatientContactExtensionModel.h"
#import "HMClientGroupChatModel.h"
#import "HMSessionListInteractor.h"

static BOOL kPatinetFirstTime = YES;

@interface HMClientSessionListViewController ()<UITableViewDelegate,UITableViewDataSource,MessageManagerDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic) BOOL firstIn;

@end

@implementation HMClientSessionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"消息"];
    
    self.firstIn = YES;
    [self at_postLoading];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self refreshMessageListData];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
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
}

- (void)refreshMessageListData {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(p_refreshSessionList) object:nil];
    [self performSelector:@selector(p_refreshSessionList) withObject:nil afterDelay:0.3];
    
}
- (void)p_refreshSessionList {
    NSLog(@"%@=-=刷刷刷刷刷刷刷刷刷刷刷刷新",NSStringFromClass([self class]));
    
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] queryMessageListByTag:im_doctorPatientGroupTag limit:-1 offset:0 completion:^(NSArray<ContactDetailModel *> *arrayList) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.dataList removeAllObjects];
        [strongSelf.dataList addObjectsFromArray:arrayList];
        [strongSelf.tableView reloadData];
        if (strongSelf.firstIn) {
            [strongSelf at_hideLoading];
            strongSelf.firstIn = NO;
        }
    }];
}

#pragma mark - event Response
- (void)rightClick {
    
}

#pragma mark - DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"订购服务套餐后，将可以随时与专家团队进行图文和语音交流" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"666666"]}];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"e"];
}



- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!self.dataList ||self.dataList.count == 0) {
        return YES;
    }
    return NO;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return [[NSAttributedString alloc] initWithString:@"订购套餐" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor mainThemeColor]}];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    //跳转到服务分类
    [[HMSessionListInteractor sharedInstance] gotoBuyService];
}

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
    [self.dataList enumerateObjectsUsingBlock:^(ContactDetailModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model._target isEqualToString:target]) {
            *stop = YES;
            index = idx;
        }
    }];

    if (index != NSUIntegerMax) {
        [self.dataList removeObjectAtIndex:index];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)MessageManagerDelegateCallBack_clearUnreadWithTarget:(NSString *)target {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF._target == %@",target];
    NSArray *array = [self.dataList filteredArrayUsingPredicate:predicate];
    if (array && array.count > 0) {
        ContactDetailModel *model = array.firstObject;
        model._countUnread = 0;
        NSInteger idx = [self.dataList indexOfObject:model];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
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

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMClientSessionMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HMClientSessionMainTableViewCell at_identifier]];
    [cell setModel:self.dataList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ContactDetailModel *model = self.dataList[indexPath.row];
    IMPatientContactExtensionModel *extensionModel = [IMPatientContactExtensionModel mj_objectWithKeyValues:[model._extension mj_JSONObject]];
    if (extensionModel.canChat) {
        // 可用群，去聊天界面
        [[HMSessionListInteractor sharedInstance] gotoChatVCWithFatherVC:self IMGroupId:model._target];
    }
    else {
        // 不可用群，去历史界面
        HMClientGroupChatModel *tempModel = [[HMClientGroupChatModel alloc] init];
        tempModel.grouptargetId = model._target;
        tempModel.teamName = model._nickName;
        HMStaffNavTitleHistoryChatViewController *VC = [[HMStaffNavTitleHistoryChatViewController alloc] initWithChatModel:tempModel];
        
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataList.count == 0) {
        return NO;
    }
    ContactDetailModel *model = self.dataList[indexPath.row];
    IMPatientContactExtensionModel *extensionModel = [IMPatientContactExtensionModel mj_objectWithKeyValues:[model._extension mj_JSONObject]];

    if (extensionModel.canChat) {
        // 能聊天的不可删除
        return NO;
    }
    return YES;
}

// 为兼容iOS 8上侧滑效果
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"删除"
                                                                       handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                           NSLog(@"删除");
                                                                           __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                           
                                                                           ContactDetailModel *model = strongSelf.dataList[indexPath.row];
                                                                           __weak typeof(self) weakSelf = self;
                                                                           [[MessageManager share] removeSessionUid:model._target completion:^(BOOL success) {
                                                                               __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                               if (!success) {
                                                                                   [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                                   return;
                                                                               }
                                                                               // 服务器会推送socket消息
                                                                           }];
                                                                           
                                                                       }];
//    NSString *string = model._muteNotification ? @"恢复提醒" : @"免打扰";
//    UITableViewRowAction *rowActionSec = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
//                                                                            title:string
//                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//                                                                              __strong typeof(weakSelf) strongSelf = weakSelf;
//                                                                              NSLog(string);
//                                                                              if (strongSelf.messageAdepterDelegate) {
//                                                                                  if ([strongSelf.messageAdepterDelegate respondsToSelector:@selector(CoordinationMessageListAdapterDelegateCallBack_muteNotification:)]) {
//                                                                                      [strongSelf.messageAdepterDelegate CoordinationMessageListAdapterDelegateCallBack_muteNotification:model];
//                                                                                  }
//                                                                              }
//                                                                          }];
//    rowActionSec.backgroundColor = [UIColor commonLightGrayColor_999999];
//
//    NSString *stickString = model._stick ? @"取消置顶" : @"置顶";
//    UITableViewRowAction *rowActionStick = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
//                                                                              title:stickString
//                                                                            handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//                                                                                __strong typeof(weakSelf) strongSelf = weakSelf;
//                                                                                [strongSelf dealWithStick:model];
//                                                                            }];
//    rowActionStick.backgroundColor =  [UIColor colorWithHexString:@"ff9d00"];
    
//    NSMutableArray *tempArr = [NSMutableArray array];
//
//    if ([ContactDetailModel isGroupWithTarget:model._target]) {
//        [tempArr addObjectsFromArray:@[rowAction,rowActionSec]];
//    }
//    else {
//        [tempArr addObjectsFromArray:@[rowAction]];
//    }
//    // 用户添加置顶
//    if ([model._tag isEqualToString:im_doctorPatientGroupTag]) {
//        [tempArr insertObject:rowActionStick atIndex:1];
//    }
    return @[rowAction];
    
}

#pragma mark - request Delegate

#pragma mark - Interface

#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setEstimatedRowHeight:100];
        [_tableView registerClass:[HMClientSessionMainTableViewCell class] forCellReuseIdentifier:[HMClientSessionMainTableViewCell at_identifier]];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


@end
