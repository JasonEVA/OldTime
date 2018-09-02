//
//  SESessionListMainViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/9/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SESessionListMainViewController.h"
#import "SESessionListSelectTypeView.h"
#import "CoordinationSearchResultViewController.h"
#import "MessageListCell.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "ChatIMConfigure.h"
#import "CoordinationMessageListAdapter.h"
#import "ATModuleInteractor+PatientChat.h"
#import "IMMessageHandlingCenter.h"
#import "IMPatientContactExtensionModel.h"
#import "SESessionListEnmu.h"
#import "SESessionListOneTypeViewController.h"
#import "HMSEPatientGroupChatViewController.h"

static BOOL kPatinetFirstTime = YES;

@interface SESessionListMainViewController ()<MessageManagerDelegate,ATTableViewAdapterDelegate,CoordinationMessageListAdapterDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong)  CoordinationMessageListAdapter  *messageAdapter; // <##>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *titelArrow;
@property (nonatomic) BOOL isSelectedTitel;
@property (nonatomic, strong) SESessionListSelectTypeView *selectTypeView;
@property (nonatomic, strong) MASConstraint *selectTypeViewHieght;
@property (nonatomic) BOOL firstIn;
@property (nonatomic, copy)  NSString  *currentSelectSessionID; // 当前点击的会话ID
@property (nonatomic, copy) NSArray *unReadCountArr;
@property (nonatomic, strong) UIView *JWheadView;
@end

@implementation SESessionListMainViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    if ([IMMessageHandlingCenter sharedInstance] != nil) {
//        [[IMMessageHandlingCenter sharedInstance] removeObserver:self forKeyPath:SESSIONSTATUS];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavTitel];

    [self configElements];
    
    ATLog(@"开始获取消息列表");
    self.firstIn = YES;
    [self at_postLoading];
    [self refreshMessageListData];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    // 一键退朝 监听角标数变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessageListData) name:HMPATIENTCLEANALLUNREDESMESSAGESUCCESS object:nil];
    
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

- (void)configNavTitel {
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(rightClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    UILabel *titelLb = [[UILabel alloc] init];
    [titelLb setText:@"消息"];
    [titelLb setTextColor:[UIColor whiteColor]];
    
    UIButton *titelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [titelBtn addTarget:self action:@selector(titelClick) forControlEvents:UIControlEventTouchUpInside];
    
    [titelBtn addSubview:titelLb];
    [titelBtn addSubview:self.titelArrow];
    
    [titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(titelBtn);
    }];
    
    [self.titelArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(titelBtn);
        make.left.equalTo(titelLb.mas_right).offset(3);
    }];
    
    [self.navigationItem setTitleView:titelBtn];
}

- (void)configElements {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.selectTypeView];
    [self.selectTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        self.selectTypeViewHieght = make.height.equalTo(@0);
    }];
}

// 刷新消息列表
- (void)refreshMessageListData
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(p_refreshSessionList) object:nil];
    [self performSelector:@selector(p_refreshSessionList) withObject:nil afterDelay:0.1];
    //    [self p_refreshSessionList];
}

- (void)p_refreshSessionList {
    NSLog(@"%@=-=刷刷刷刷刷刷刷刷刷刷刷刷新",NSStringFromClass([self class]));
    
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] queryMessageListByTag:im_doctorPatientGroupTag limit:-1 offset:0 completion:^(NSArray<ContactDetailModel *> *arrayList) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.messageAdapter.adapterArray removeAllObjects];
        [strongSelf.messageAdapter.adapterArray addObjectsFromArray:[self JWGetSomeTypeSessionListWithTypeList:[self JWGetSelectedTypeList] allSessionList:arrayList]];
        [strongSelf.tableView reloadData];
        if (strongSelf.firstIn) {
            [strongSelf at_hideLoading];
            strongSelf.firstIn = NO;
        }
    }];
}

- (NSArray<ContactDetailModel *> *)JWGetSomeTypeSessionListWithTypeList:(NSArray *)typeList allSessionList:(NSArray<ContactDetailModel *> *)allSessionList{
    __block NSMutableArray *showArr = [NSMutableArray array];
    
    __block NSInteger unReadCount_GroupVIP = 0;
    __block NSInteger unReadCount_GroupMiddle = 0;
    __block NSInteger unReadCount_GroupCommon = 0;
    __block NSInteger unReadCount_PersonalPackage = 0;
    __block NSInteger unReadCount_PersonalFollow = 0;
    __block NSInteger unReadCount_PersonalSingle = 0;

    [allSessionList enumerateObjectsUsingBlock:^(ContactDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IMPatientContactExtensionModel *tempModel  = [IMPatientContactExtensionModel mj_objectWithKeyValues:obj._extension.mj_JSONObject];
        if (tempModel.isBlocService == 1) {
            // 集团
            
            if (tempModel.blocRank == 3) {
                // 集团VIP
                if ([typeList containsObject:@(SESessionListType_GroupVIP)]) {
                    [showArr addObject:obj];
                }
                unReadCount_GroupVIP += obj._countUnread;
            }
            else if ( tempModel.blocRank == 2) {
                // 集团中层
                if ([typeList containsObject:@(SESessionListType_GroupMiddle)]) {
                    [showArr addObject:obj];
                }
                unReadCount_GroupMiddle += obj._countUnread;
            }
            else if (tempModel.blocRank == 1) {
                // 集团普通
                if ([typeList containsObject:@(SESessionListType_GroupCommon)]) {
                    [showArr addObject:obj];
                }
                unReadCount_GroupCommon += obj._countUnread;

            }
            else {
//                NSLog(@"%@", [NSString stringWithFormat:@"集团未知分类 %@ --- %@",obj._target,obj._extension]);
            }
            
        }
        else if (tempModel.isBlocService == 0) {
            // 个人
            if (tempModel.classify == 2 || tempModel.classify == 4) {
                // 个人套餐
                if ([typeList containsObject:@(SESessionListType_PersonalPackage)]) {
                    [showArr addObject:obj];
                }
                unReadCount_PersonalPackage += obj._countUnread;
            }
            else if (tempModel.classify == 3) {
                // 个人免费
                if ([typeList containsObject:@(SESessionListType_PersonalFollow)]) {
                    [showArr addObject:obj];
                }
                unReadCount_PersonalFollow += obj._countUnread;

            }
            else if (tempModel.classify == 5) {
                // 个人单项
                if ([typeList containsObject:@(SESessionListType_PersonalSingle)]) {
                    [showArr addObject:obj];
                }
                unReadCount_PersonalSingle += obj._countUnread;

            }
            else {
//                NSLog(@"%@", [NSString stringWithFormat:@"个人未知分类 %@ --- %@",obj._target,obj._extension]);
            }
        }
        else {
//            NSLog(@"%@", [NSString stringWithFormat:@"未知分类 %@ --- %@",obj._target,obj._extension]);
        }
    }];
    
    self.unReadCountArr = @[@(unReadCount_GroupVIP),@(unReadCount_GroupMiddle),@(unReadCount_GroupCommon),@(unReadCount_PersonalPackage),@(unReadCount_PersonalFollow),@(unReadCount_PersonalSingle)];
    
    self.selectTypeView.unReadArr = self.unReadCountArr;
    return showArr;
}

- (NSArray *)JWGetSelectedTypeList {
    UserInfo* user = [[UserInfoHelper defaultHelper] currentUserInfo];
    NSArray *typeList = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@-%ld",SESESSIONTYPELIST,user.userId]];
    return typeList;
}

- (BOOL)JWGetShowHeadView {
    UserInfo* user = [[UserInfoHelper defaultHelper] currentUserInfo];
     return [[[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@-%ld",SESESSIONTYPEVIEWISSHOWHEAD,user.userId]] boolValue];
}

#pragma mark - event Response
- (void)rightClick {
    CoordinationSearchResultViewController *resultVC = [CoordinationSearchResultViewController new];
    [resultVC setSearchType:searchType_searchPatientChatAndPatients];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:resultVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)titelClick {
    self.isSelectedTitel ^= 1;
    [self.titelArrow setImage:[UIImage imageNamed:self.isSelectedTitel ? @"Triangle_header_up": @"Triangle_header_down"]];
    if (self.isSelectedTitel) {
        self.selectTypeView.selectedArr = [[self JWGetSelectedTypeList] mutableCopy];
        [self.selectTypeView.tableView reloadData];
    }
    self.selectTypeViewHieght.offset = self.isSelectedTitel ? (self.view.frame.size.height):0;
    
}

- (void)headCloseClick {
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)]];
    
    UserInfo* user = [[UserInfoHelper defaultHelper] currentUserInfo];
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:[NSString stringWithFormat:@"%@-%ld",SESESSIONTYPEVIEWISSHOWHEAD,user.userId]];
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
    
//    [self refreshMessageListData];
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
    return [[NSAttributedString alloc] initWithString:[self JWGetSelectedTypeList].count ? @"暂无任何消息":@"消息被您藏起来了" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"]}];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:[self JWGetSelectedTypeList].count ?@"b":@"b2"];
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
        
        
        if ([self JWGetShowHeadView]) {
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
            [headView setBackgroundColor:[UIColor whiteColor]];
            
            UILabel *titelLb = [UILabel new];
            [titelLb setText:@"顶部消息菜单可以定制个性化消息列表哦"];
            [titelLb setTextColor:[UIColor colorWithHexString:@"f7ab3e"]];
            [titelLb setFont:[UIFont systemFontOfSize:14]];
            
            UIButton *closeBtn = [[UIButton alloc] init];
            [closeBtn setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
            [closeBtn addTarget:self action:@selector(headCloseClick) forControlEvents:UIControlEventTouchUpInside];
            [headView addSubview:closeBtn];
            [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headView);
                make.right.equalTo(headView).offset(-15);
            }];
            
            [headView addSubview:titelLb];
            [titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headView);
                make.left.equalTo(headView).offset(15);
                make.right.lessThanOrEqualTo(closeBtn.mas_left).offset(-5);
            }];
            
            [_tableView setTableHeaderView:headView];
        }
        else {
            if ([self JWGetSelectedTypeList].count < 6) {
                [_tableView setTableHeaderView:self.JWheadView];
            }
            else{
                [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)]];
            }
        }
        
    }
    return _tableView;
}

- (UIView *)JWheadView {
    if (!_JWheadView) {
        _JWheadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        [_JWheadView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        
        UILabel *titelLb = [UILabel new];
        [titelLb setText:@"您已定制个性化消息列表"];
        [titelLb setTextColor:[UIColor colorWithHexString:@"666666"]];
        [titelLb setFont:[UIFont systemFontOfSize:14]];
        
        [_JWheadView addSubview:titelLb];
        [titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_JWheadView);
            make.left.equalTo(_JWheadView).offset(15);
            make.right.lessThanOrEqualTo(_JWheadView).offset(-5);
        }];
    }
    return _JWheadView;
}

- (UIImageView *)titelArrow {
    if (!_titelArrow) {
        _titelArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Triangle_header_down"]];
    }
    return _titelArrow;
}

- (SESessionListSelectTypeView *)selectTypeView {
    if (!_selectTypeView) {
        _selectTypeView = [[SESessionListSelectTypeView alloc] init];
        [_selectTypeView selectedEndBlock:^(NSArray *selectedArr) {
            if ([self JWGetSelectedTypeList].count < 6) {
                // 已定制
                [self.tableView setTableHeaderView:self.JWheadView];
                UserInfo* user = [[UserInfoHelper defaultHelper] currentUserInfo];
                [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:[NSString stringWithFormat:@"%@-%ld",SESESSIONTYPEVIEWISSHOWHEAD,user.userId]];
            }
            else {
                // 未定制 或全选了
                if (![self JWGetShowHeadView]) {
                    // 全选且头已隐藏
                    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)]];
                }
                
            }
            if ([self JWGetShowHeadView] && [self JWGetSelectedTypeList].count < 6) {
                [self headCloseClick];
            }
            [self titelClick];
            [self refreshMessageListData];
            [[NSNotificationCenter defaultCenter] postNotificationName:MTBadgeCountChangedNotification object:nil];
        }];
        
        [_selectTypeView clickCellBlock:^(NSInteger row) {
            SESessionListOneTypeViewController *VC = [[SESessionListOneTypeViewController alloc] initWithSessionType:row];
            [self.navigationController pushViewController:VC animated:YES];
            [self titelClick];

        }];
    }
    return _selectTypeView;
}

@end


