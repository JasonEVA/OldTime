//
//  ApplyCCViewController.m
//  launcher
//
//  Created by Conan Ma on 15/9/29.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplyCCViewController.h"
#import "NewApplyAddNewApplyV2ViewController.h"
#import "ApplyNavBtn.h"
#import "ApplyNavBar.h"
#import "Masonry.h"
#import "ApplySendTableViewCell.h"
#import "ApplyAcceptDetailViewController.h"
#import "ApplyGetReceivedApplyListRequest.h"
#import "ApplySearchView.h"
#import "UnifiedUserInfoManager.h"
#import "ApplyMessageModel.h"
#import "ApplyMessageRequest.h"
#import <MJRefresh.h>
#import "AttachmentUtil.h"
#import "ApplyUserDefinedDetailViewController.h"

#define tableview_pageSize 20


@interface ApplyCCViewController ()<UITableViewDataSource,UITableViewDelegate,ApplyNavBarDelegate, BaseRequestDelegate,ApplySearchViewDelegate>

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

@implementation ApplyCCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = LOCAL(Application_Apply);
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(SearchActions)];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    self.tabView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.tabView.backgroundColor = [UIColor whiteColor];
    
    self.tabView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataFirst)];
    self.tabView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    [self.view addSubview:self.tabView];
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
     }];
    
    self.SearchIndex = 1;
    [self postLoading];
    self.isNeedRefresh = YES;
    self.navigationItem.title = LOCAL(APPLY_ACCEPT_CCBTN_TITLE);

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
- (void)SetUnReadMessage
{
    //待审批消息匹配未读
    for (int i = 0 ; i<self.modelArr.count; i++)
    {
        for (int s = 0; s<self.arrUnreadMessage.count; s++)
        {
            if ([((ApplyGetReceiveListModel *)self.modelArr[i]).SHOW_ID isEqualToString:((ApplyMessageModel *)self.arrUnreadMessage[s]).rmShowID])
            {
                if ([((ApplyMessageModel *)self.arrUnreadMessage[s]).appMessageType isEqual:@"SEND"])
                {
                    ((ApplyGetReceiveListModel *)self.modelArr[i]).Unreadmsg = YES;
                }
                else
                {
                    ((ApplyGetReceiveListModel *)self.modelArr[i]).UnreadComment = YES;
                }
                
            }
        }
    }
    
    [self.tabView reloadData];
    [self.tabView.header endRefreshing];
    [self.tabView.footer endRefreshing];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"luancher";
    ApplySendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ApplySendTableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
    }
    [cell setCCCellWithModel:self.modelArr[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 60;}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 0.01;}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tabView deselectRowAtIndexPath:indexPath animated:NO];
    
    ApplyGetReceiveListModel *model = [self.modelArr objectAtIndex:indexPath.row];
    
    if ([model.T_SHOW_ID isEqualToString:VOCATION] || [model.T_SHOW_ID isEqualToString:EXPENSE])
    {
        model.UnreadComment = NO;
        model.Unreadmsg = NO;
        ApplyAcceptDetailViewController *vc = [[ApplyAcceptDetailViewController alloc] initWithFrom:FromSender From:Pass_nil withShowID:model.SHOW_ID];
        [vc setHidesBottomBarWhenPushed:YES];
        ApplySendTableViewCell * cell  = (ApplySendTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setTagHide];
        [vc backblock:^(NSInteger has) {
            model.IS_HAVECOMMENT = 1;
            [cell setCCCellWithModel:model];
            [self.tabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        ApplyUserDefinedDetailViewController *vc = [[ApplyUserDefinedDetailViewController alloc] initWithFrom:new_FromSender From:new_Pass_nil withShowID:model.SHOW_ID];
        [vc setHidesBottomBarWhenPushed:YES];
        ApplySendTableViewCell * cell  = (ApplySendTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setTagHide];
        [vc backblock:^(NSInteger has) {
            model.IS_HAVECOMMENT = 1;
            [cell setCCCellWithModel:model];
            [self.tabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - interFace method
- (void)refreshData
{
    ApplyGetReceivedApplyListRequest *request = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
    [request GetType:@"CC" pageIndex:self.SearchIndex pageSize:tableview_pageSize timeStamp:self.SearchDate];
    
}

- (void)refreshDataFirst
{
    self.SearchIndex = 1;
    ApplyGetReceivedApplyListRequest *request = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
    [request GetType:@"CC" pageIndex:self.SearchIndex pageSize:tableview_pageSize];
}

#pragma requesetDelegate
- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}

- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([response isKindOfClass:[ApplyGetReceivedApplyListResponse class]])
    {
        if (self.tabView.header.isRefreshing || (!self.tabView.footer.isRefreshing && !self.tabView.header.isRefreshing))
        {
            [self.modelArr removeAllObjects];
        }
        for (NSDictionary *dict in ((ApplyGetReceivedApplyListResponse *)response).arrData)
        {
            ApplyGetReceiveListModel *model = [[ApplyGetReceiveListModel alloc] initWithDict:dict];
            [self.modelArr addObject:model];
        }
        
        if (self.SearchIndex == 1)
        {
            if (self.modelArr.count >0)
            {
                long long date = ((ApplyGetReceiveListModel *)[self.modelArr objectAtIndex:0]).LAST_UPDATE_TIME;
                self.SearchDate = [NSDate dateWithTimeIntervalSince1970:date/1000];
            }
        }
        self.SearchIndex = self.SearchIndex + 1;
        
        if (self.tabView.header.isRefreshing && ((ApplyGetReceivedApplyListResponse *)response).arrData.count == 0)
        {
            [self.tabView.header endRefreshing];
        }
        
        if (((ApplyGetReceivedApplyListResponse *)response).arrData.count > 0)
        {
            //未读消息接口
            ApplyMessageRequest *msgrequest = [[ApplyMessageRequest alloc] initWithDelegate:self];
            [msgrequest GetUnreadMessagesWithpageIndex:-1 timeStamp:[NSDate date] appShowID:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdApprove] readStatus:0 messageType:@"CC"];
            ApplyMessageRequest *msgrequestComment = [[ApplyMessageRequest alloc] initWithDelegate:self];
            [msgrequestComment GetUnreadMessagesWithpageIndex:-1 timeStamp:[NSDate date] appShowID:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdApprove] readStatus:0 messageType:@"APPROVAL_COMMENT"];
        }
        else
        {
            [self.tabView.header endRefreshing];
            [self.tabView.footer endRefreshing];
            [self.tabView.footer noticeNoMoreData];
        }
    }
    if ([response isKindOfClass:[ApplyMessageResponse class]])
    {
        [self.arrUnreadMessage removeAllObjects];
        for (ApplyMessageModel *model in ((ApplyMessageResponse *)response).arrMessageModel)
        {
            if ([model.appMessageType isEqualToString:@"CC"])
            {
                [self.arrUnreadMessage addObject:model];
            }
            else if ([model.appMessageType isEqualToString:@"APPROVAL_COMMENT"])
            {
                [self.arrUnreadMessageComment addObject:model];
            }
        }
        [self SetUnReadMessage];
        [self.tabView.footer endRefreshing];
        [self.tabView.header endRefreshing];
    }
    [self.tabView reloadData];
    [self hideLoading];
}

#pragma mark - private method
-(void)setNeedRefresh
{
    self.isNeedRefresh = YES;
}

#pragma mark - event respond
- (void)SearchActions
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
