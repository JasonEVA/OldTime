//
//  SenderApplyViewController.m
//  launcher
//
//  Created by Kyle He on 15/8/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplySenderViewController.h"
#import "NewApplyAddNewApplyV2ViewController.h"
#import "ApplyNavBtn.h"
#import "ApplyNavBar.h"
#import "Masonry.h"
#import "ApplySendTableViewCell.h"
#import "ApplyAcceptDetailViewController.h"
#import "ApplyGetSenderListRequest.h"
#import "ApplySearchView.h"
#import "UnifiedUserInfoManager.h"
#import "ApplyMessageModel.h"
#import "ApplyMessageRequest.h"
#import <MJRefresh.h>
#import "AttachmentUtil.h"
#import "ApplyUserDefinedDetailViewController.h"

#define tableview_pageSize 20

@interface ApplySenderViewController () <UITableViewDataSource,UITableViewDelegate,ApplyNavBarDelegate, BaseRequestDelegate,ApplySearchViewDelegate>

@property (nonatomic , strong) UITableView  *tabView;
@property (nonatomic, strong) NSMutableArray *arrUnreadMessage;   //获取未读数组
@property(nonatomic, strong) NSMutableArray  *modelArr;
@property (nonatomic, strong) NSDate *SearchDate;
@property (nonatomic) NSInteger SearchIndex;
@property (nonatomic) BOOL needScrollTotop;
@property(nonatomic, assign) BOOL  isNeedRefresh; //
@property (nonatomic, strong) NSMutableArray *arrUnreadMessageComment;  //获取未读数组
@property (nonatomic, strong) ApplySearchView *SearchView;


@end

@implementation ApplySenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.SearchIndex = 1;
    [self showLeftItemWithSelector:@selector(backAction)];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchActions)];
    self.navigationItem.rightBarButtonItem = searchItem;
    self.navigationItem.title = LOCAL(APPLY_APPLY);
    self.tabView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    
    [self.view addSubview:self.tabView];
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self postLoading];
    [self setTableViewRefresh];
    self.isNeedRefresh = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedRefresh) name:MCApplyListDataDidRefreshNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.isNeedRefresh) return;
    self.isNeedRefresh = NO;
    self.SearchIndex = 1;
    self.needScrollTotop = YES;
    [self.tabView scrollsToTop];
    [self.modelArr removeAllObjects];
    [self refreshDataFirst];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.SearchView.hidden)
    {
        self.SearchView.hidden = NO;
        [self.SearchView setSearchBarFirstResponder];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MCApplyListDataDidRefreshNotification object:nil];
}

#pragma mark - Privite Methods
- (void)setTableViewRefresh
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.SearchIndex = 1;
        [self refreshDataFirst];
    }];
    
    self.tabView.header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self refreshData];
    }];

    self.tabView.footer = footer;
}

- (void)SetUnReadMessage
{
    //待审批消息匹配未读
    for (int i = 0 ; i<self.modelArr.count; i++)
    {
        for (int s = 0; s<self.arrUnreadMessage.count; s++)
        {
            if ([((ApplyGetSendListModel *)self.modelArr[i]).showID isEqualToString:((ApplyMessageModel *)self.arrUnreadMessage[s]).rmShowID])
            {
                if ([((ApplyMessageModel *)self.arrUnreadMessage[s]).appMessageType isEqual:@"SEND"])
                {
                    ((ApplyGetSendListModel *)self.modelArr[i]).Unreadmsg = YES;
                }
                else
                {
                    ((ApplyGetSendListModel *)self.modelArr[i]).UnreadComment = YES;
                }
                
            }
        }
    }
    
    [self.tabView reloadData];
    [self.tabView.header endRefreshing];
    [self.tabView.footer endRefreshing];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"luancher";
    ApplySendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[ApplySendTableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
    }
    [cell setCellWithModel:self.modelArr[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tabView deselectRowAtIndexPath:indexPath animated:NO];
    ApplySendTableViewCell *cell  = (ApplySendTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setTagHide];
    ApplyGetSendListModel *model = [self.modelArr objectAtIndex:indexPath.row];
    if ([model.T_SHOW_ID isEqualToString:VOCATION] || [model.T_SHOW_ID isEqualToString:EXPENSE])
    {
        ApplyAcceptDetailViewController *vc = [[ApplyAcceptDetailViewController alloc] initWithFrom:FromSender From:Pass_nil withShowID:model.showID];
        [vc setHidesBottomBarWhenPushed:YES];
        [vc backblock:^(NSInteger has) {
            model.UnreadComment = has;
            [cell setCellWithModel:model];
            [self.tabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        ApplyUserDefinedDetailViewController *vc = [[ApplyUserDefinedDetailViewController alloc] initWithFrom:new_FromSender From:new_Pass_nil withShowID:model.showID];
        [vc setHidesBottomBarWhenPushed:YES];
        [vc backblock:^(NSInteger has) {
            model.UnreadComment = has;
            [cell setCellWithModel:model];
            [self.tabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 0.01;}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}

#pragma mark - Interface method
- (void)refreshData
{
    ApplyGetSenderListRequest *requset = [[ApplyGetSenderListRequest alloc] initWithDelegate:self];
    [requset getSenderListRequstWithPageIndex:self.SearchIndex PageSize:tableview_pageSize TimeStamp:self.SearchDate];
}

- (void)refreshDataFirst
{
    ApplyGetSenderListRequest *requset = [[ApplyGetSenderListRequest alloc] initWithDelegate:self];
    [requset getSenderListRequstWithPageIndex:self.SearchIndex PageSize:tableview_pageSize];
}

#pragma requesetDelegate
- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}

- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([response isKindOfClass:[ApplyGetSenderListResponse class]])
    {
        NSMutableArray *arr = [(ApplyGetSenderListResponse *)response modelArr];
        
        if (self.tabView.header.isRefreshing || (!self.tabView.footer.isRefreshing && !self.tabView.header.isRefreshing))
        {
           [self.modelArr removeAllObjects];
        }
        
        [self.modelArr addObjectsFromArray:arr];
        if (self.SearchIndex == 1 && self.modelArr.count > 0)
        {
            long long date = ((ApplyGetSendListModel *)[self.modelArr objectAtIndex:0]).LAST_UPDATE_TIME;
            self.SearchDate = [NSDate dateWithTimeIntervalSince1970:date/1000];
        }
        self.SearchIndex = self.SearchIndex + 1;
        
        [self.tabView reloadData];
        if (self.needScrollTotop)
        {
            self.needScrollTotop = NO;
            if (self.modelArr.count)
            {
                [self.tabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
        
        if (self.tabView.header.isRefreshing && ((ApplyGetSenderListResponse *)response).modelArr.count == 0)
        {
            [self.tabView.header endRefreshing];
        }
        
        if (((ApplyGetSenderListResponse *)response).modelArr.count >0)
        {
            //未读消息接口
            ApplyMessageRequest *msgrequest = [[ApplyMessageRequest alloc] initWithDelegate:self];
            [msgrequest GetUnreadMessagesWithpageIndex:-1 timeStamp:[NSDate date] appShowID:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdApprove] readStatus:0 messageType:@"SEND"];
            ApplyMessageRequest *msgrequestComment = [[ApplyMessageRequest alloc] initWithDelegate:self];
            [msgrequestComment GetUnreadMessagesWithpageIndex:-1 timeStamp:[NSDate date] appShowID:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdApprove] readStatus:0 messageType:@"APPROVAL_COMMENT"];
        }
        else
        {
            [self.tabView.footer noticeNoMoreData];
        }
        
        [self RecordToDiary:[NSString stringWithFormat:@"获取自己的审批列表成功"]];
    }
    else if ([response isKindOfClass:[ApplyMessageResponse class]])
    {
        [self.arrUnreadMessage removeAllObjects];
        for (ApplyMessageModel *model in ((ApplyMessageResponse *)response).arrMessageModel)
        {
            if ([model.appMessageType isEqualToString:@"SEND"])
            {
                [self.arrUnreadMessage addObject:model];
            }
            else
            {
                [self.arrUnreadMessageComment addObject:model];
            }
        }
        [self SetUnReadMessage];
        [self RecordToDiary:[NSString stringWithFormat:@"获取自己的审批列表未读消息成功"]];
        [self.tabView.footer endRefreshing];
        [self.tabView.header endRefreshing];
    }
    [self hideLoading];
}

#pragma mark - private method
-(void)setNeedRefresh
{
    self.isNeedRefresh = YES;
}

#pragma mark - event respond
- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchActions
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.tabBarController.tabBar setHidden:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.SearchView = [[ApplySearchView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.SearchView.delegate = self;
    [window addSubview:self.SearchView];
    [self.SearchView setSearchBarFirstResponder];
}

#pragma mark - ContactSearchView Delegate
// 取消按钮委托
- (void)ApplySearchViewDelegateCallBack_BtnCancelClicked
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.tabBarController.tabBar setHidden:NO];
    
}

- (void)ApplySearchViewDelegateCallBack_DidBeginEditing
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.tabBarController.tabBar setHidden:YES];
}

// 搜索按钮委托
- (void)ApplySearchViewDelegateCallBack_SelectCellWithModel:(ApplyDetailInformationModel *)model WithIndex:(NSInteger)index
{
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if ([model.T_SHOW_ID isEqualToString:VOCATION] || [model.T_SHOW_ID isEqualToString:EXPENSE])
    {
        ApplyAcceptDetailViewController *detailVC;
        
        NSArray *arrNameList = [model.A_APPROVE_NAME componentsSeparatedByString:@"●"];
        BOOL needApprovel = NO;
        BOOL needEdit = NO;
        NSString *myName = [[UnifiedUserInfoManager share] userShowID];
        for (NSString *str in arrNameList)
        {
            if ([str isEqualToString:myName])
            {
                needApprovel = YES;
            }
        }
        
        if ([model.CREATE_USER_NAME isEqualToString:myName] && [model.A_STATUS isEqualToString:@"WAITING"])
        {
            needEdit = YES;
        }
        
        if (needApprovel)
        {
            detailVC = [[ApplyAcceptDetailViewController alloc] initWithFrom:FromReceiver From:Pass_From_Receiver withShowID:model.SHOW_ID];
        }
        else
        {
            if (needEdit)
            {
                detailVC = [[ApplyAcceptDetailViewController alloc] initWithFrom:FromSender From:Pass_nil withShowID:model.SHOW_ID];
            }
            else
            {
                if ([model.CREATE_USER_NAME isEqualToString:myName])
                {
                    detailVC = [[ApplyAcceptDetailViewController alloc] initWithFrom:FromSender From:Pass_nil withShowID:model.SHOW_ID];
                }
                else
                {
                    detailVC = [[ApplyAcceptDetailViewController alloc] initWithFrom:FromReceiver From:Pass_From_CC withShowID:model.SHOW_ID];
                }
            }
        }
        
        [detailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else
    {
        ApplyUserDefinedDetailViewController *detailVC;
        NSArray *arrNameList = [model.A_APPROVE_NAME componentsSeparatedByString:@"●"];
        BOOL needApprovel = NO;
        BOOL needEdit = NO;
        NSString *myName = [[UnifiedUserInfoManager share] userShowID];
        for (NSString *str in arrNameList)
        {
            if ([str isEqualToString:myName])
            {
                needApprovel = YES;
            }
        }
        
        if ([model.CREATE_USER_NAME isEqualToString:myName] && [model.A_STATUS isEqualToString:@"WAITING"])
        {
            needEdit = YES;
        }
        
        if (needApprovel)
        {
            detailVC = [[ApplyUserDefinedDetailViewController alloc] initWithFrom:new_FromReceiver From:new_Pass_From_Receiver withShowID:model.SHOW_ID];
        }
        else
        {
            if (needEdit)
            {
                detailVC = [[ApplyUserDefinedDetailViewController alloc] initWithFrom:new_FromSender From:new_Pass_nil withShowID:model.SHOW_ID];
            }
            else
            {
                if ([model.CREATE_USER_NAME isEqualToString:myName])
                {
                    detailVC = [[ApplyUserDefinedDetailViewController alloc] initWithFrom:new_FromSender From:new_Pass_nil withShowID:model.SHOW_ID];
                }
                else
                {
                    detailVC = [[ApplyUserDefinedDetailViewController alloc] initWithFrom:new_FromReceiver From:new_Pass_From_CC withShowID:model.SHOW_ID];
                }
            }
        }
        
        [detailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (NSMutableArray *)modelArr
{
    if (!_modelArr)
    {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

- (NSMutableArray *)arrUnreadMessage
{
    if (!_arrUnreadMessage)
    {
        _arrUnreadMessage = [[NSMutableArray alloc] init];
    }
    return _arrUnreadMessage;
}

- (NSDate *)SearchDate
{
    if (!_SearchDate)
    {
        _SearchDate = [NSDate date];
    }
    return _SearchDate;
}

- (NSMutableArray *)arrUnreadMessageComment
{
    if (!_arrUnreadMessageComment)
    {
        _arrUnreadMessageComment = [[NSMutableArray alloc] init];
    }
    return _arrUnreadMessageComment;
}
@end
