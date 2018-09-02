//
//  NewApplyMainAllViewController.m
//  launcher
//
//  Created by conanma on 16/1/14.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyMainAllViewController.h"
#import "UIColor+Hex.h"
#import "ApplyNavBar.h"
#import "Masonry.h"
#import "MyDefine.h"
#import "ApplyAcceptTableViewCell.h"
#import "ApplyAcceptDetailViewController.h"
#import "ApplyGetReceivedApplyListRequest.h"
#import "ApplyGetReceiveListModel.h"
#import "ApplyDealWiththeApplyRequest.h"
#import "ApplySearchView.h"
#import "ApplyCommentView.h"
#import "ContactPersonDetailInformationModel.h"
#import "ApplyMessageRequest.h"
#import "ApplyMessageModel.h"
#import <MJRefresh.h>
#import "AttachmentUtil.h"
#import "ApplyGetTotalCountRequest.h"
#import "SelectContactBookViewController.h"
#import "ApplyUserDefinedDetailViewController.h"
#import "ApplySendTableViewCell.h"
#import "ApplyGetSenderListRequest.h"
#import "NewApplyStyleViewController.h"
#import "NewApplyKindbtnsView.h"
#import "ApplyForwardingRequest.h"
#import "DateTools.h"
#import "NewApplyAllEventTableViewCell.h"
#import "NewApplyDetailViewController.h"
#import "NewApplySearchViewController.h"
#import "BaseNavigationController.h"

typedef enum{
    tableviewcellKind_all = 0,
    tableviewcellKind_Undeal = 1,
    tableviewcellKind_Send = 2,
    tableviewcellKind_Cc = 3,
    tableviewcellKind_Dealed = 4
}tableviewcellKind;

#define tableview_pageSize 20
#warning "The File Code is never uesed , Please use nothing instead"
@interface NewApplyMainAllViewController () <ApplyNavBarDelegate, UITableViewDelegate, UITableViewDataSource,SWTableViewCellDelegate, BaseRequestDelegate,ApplySearchViewDelegate, UIActionSheetDelegate, ApplyCommentViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrAll;
@property (nonatomic, strong) NSMutableArray *arrUndealList;
@property (nonatomic, strong) NSMutableArray *arrDealedList;
@property (nonatomic, strong) NSMutableArray *arrCCList;
@property (nonatomic, strong) NSMutableArray *arrSendList;
@property (nonatomic, strong) NSMutableArray *arrTitles;

@property (nonatomic, strong) NSMutableArray *arrUnreadMessage;    //获取未读数组
@property (nonatomic, strong) NSMutableArray *arrUnreadMessageCC;  //获取未读数组
@property (nonatomic, strong) NSMutableArray *arrUnreadMessageComment;  //获取未读数组
@property (nonatomic, strong) NSMutableArray *arrUnreadMessageSend;


@property (nonatomic) BOOL ReadyUndeal;
@property (nonatomic) BOOL ReadyDealed;
@property (nonatomic) BOOL ReadyCC;
@property (nonatomic) BOOL ReadySend;
@property (nonatomic) BOOL ReadyAproveComment;
@property (nonatomic) BOOL ReadyUnreadAprove;
@property (nonatomic) BOOL ReadyUnreadCC;
@property (nonatomic) BOOL ReadyUnreadSend;

@property (nonatomic, strong) NSString *strNextApproverNames;
@property (nonatomic, strong) NSString *strNextApprovers;
@property (nonatomic, strong) NSString *strReason;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *SelectedShowID;
@property (nonatomic) NSInteger selectIndex;

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIButton *btnNavTitle;
@property (nonatomic, strong) ApplySearchView *SearchView;
@property (nonatomic) tableviewcellKind currentKind;
@property (nonatomic, strong) NewApplyKindbtnsView *NavBtnView;
@property (nonatomic, strong) ApplyCommentView * commentView;
@end

@implementation NewApplyMainAllViewController
- (instancetype)init
{
    if (self = [super init])
    {
        [self.navigationItem setTitleView:self.btnNavTitle];
        UIBarButtonItem *rightitme1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnAddClicked)];
        
        UIBarButtonItem *rightitme2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(btnSearchClicked)];
        [self.navigationItem setRightBarButtonItems:@[rightitme1,rightitme2] animated:NO];
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:self.tableview];
        self.currentKind = tableviewcellKind_all;
        
        //        ApplyGetReceivedApplyListRequest *requestUndeal = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
        //        [requestUndeal GetType:@"APPROVE" IS_PROCESS:0 pageIndex:0 pageSize:20];
        
        [self setframes];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.arrAll removeAllObjects];
    [self.arrUndealList removeAllObjects];
    [self.arrDealedList removeAllObjects];
    [self.arrUndealList removeAllObjects];
    [self.arrCCList removeAllObjects];
    [self.arrSendList removeAllObjects];
    
    [self.arrUnreadMessage removeAllObjects];
    [self.arrUnreadMessageCC removeAllObjects];
    [self.arrUnreadMessageComment removeAllObjects];
    [self.arrUnreadMessageSend removeAllObjects];
    
    self.ReadyUndeal = NO;
    self.ReadyDealed = NO;
    self.ReadyCC = NO;
    self.ReadySend = NO;
    self.ReadyAproveComment = NO;
    self.ReadyUnreadAprove = NO;
    self.ReadyUnreadCC = NO;
    self.ReadyUnreadSend = NO;
    
    ApplyGetReceivedApplyListRequest *requestUndeal = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
    ApplyGetReceivedApplyListRequest *requestDeal = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
    
    [requestUndeal GetType:@"APPROVE" IS_PROCESS:0 pageIndex:-1 pageSize:tableview_pageSize];
    [requestDeal GetType:@"APPROVE" IS_PROCESS:1 pageIndex:-1 pageSize:tableview_pageSize];
    
    ApplyGetReceivedApplyListRequest *requestCC = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
    [requestCC GetType:@"CC" pageIndex:-1 pageSize:tableview_pageSize];
    
    ApplyGetSenderListRequest *requsetSend = [[ApplyGetSenderListRequest alloc] initWithDelegate:self];
    [requsetSend getSenderListRequstWithPageIndex:-1 PageSize:tableview_pageSize];
    
    //未读消息接口
    ApplyMessageRequest *msgrequest = [[ApplyMessageRequest alloc] initWithDelegate:self];
    [msgrequest GetUnreadMessagesWithpageIndex:-1 timeStamp:[NSDate date] appShowID:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdApprove] readStatus:0 messageType:@"APPROVE"];
    
    ApplyMessageRequest *msgrequest2 = [[ApplyMessageRequest alloc] initWithDelegate:self];
    [msgrequest2 GetUnreadMessagesWithpageIndex:-1 timeStamp:[NSDate date] appShowID:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdApprove] readStatus:0 messageType:@"CC"];
    
    //未读消息接口
    ApplyMessageRequest *msgrequestsend = [[ApplyMessageRequest alloc] initWithDelegate:self];
    [msgrequestsend GetUnreadMessagesWithpageIndex:-1 timeStamp:[NSDate date] appShowID:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdApprove] readStatus:0 messageType:@"SEND"];
    
    ApplyMessageRequest *msgrequestComment = [[ApplyMessageRequest alloc] initWithDelegate:self];
    [msgrequestComment GetUnreadMessagesWithpageIndex:-1 timeStamp:[NSDate date] appShowID:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdApprove] readStatus:0 messageType:@"APPROVAL_COMMENT"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Privite Methods
- (void)setframes
{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Privite Methods
- (void)btnAddClicked
{
    NewApplyStyleViewController *VC = [[NewApplyStyleViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)btnSearchClicked
{
    //    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //    [self.tabBarController.tabBar setHidden:YES];
    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //    self.SearchView = [[ApplySearchView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
    //    self.SearchView.delegate = self;
    //    [window addSubview:self.SearchView];
    //    [self.SearchView setSearchBarFirstResponder];
    NewApplySearchViewController *searchVC = [[NewApplySearchViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)NavTitleChange:(UIButton *)sender
{
    if (self.NavBtnView.canappear == NO)
    {
        self.NavBtnView.canappear = YES;
        [self.NavBtnView removeFromSuperview];
    }
    else
    {
        [self.NavBtnView setpassbackBlock:^(NSInteger index) {
            switch (index)
            {
                case tableviewcellKind_all:
                {
                    self.currentKind = tableviewcellKind_all;
                    [self.btnNavTitle setTitle:LOCAL(APPLY_ALL) forState:UIControlStateNormal];
                }
                    break;
                case tableviewcellKind_Undeal:
                {
                    self.currentKind = tableviewcellKind_Undeal;
                    [self.btnNavTitle setTitle:LOCAL(APPLY_NEEDAPPLY) forState:UIControlStateNormal];
                }
                    break;
                case tableviewcellKind_Send:
                {
                    self.currentKind = tableviewcellKind_Send;
                    [self.btnNavTitle setTitle:LOCAL(APPLY_SENDS) forState:UIControlStateNormal];
                }
                    break;
                case tableviewcellKind_Cc:
                {
                    self.currentKind = tableviewcellKind_Cc;
                    [self.btnNavTitle setTitle:LOCAL(APPLY_CC) forState:UIControlStateNormal];
                }
                    break;
                case tableviewcellKind_Dealed:
                {
                    self.currentKind = tableviewcellKind_Dealed;
                    [self.btnNavTitle setTitle:LOCAL(APPLY_DONE) forState:UIControlStateNormal];
                }
                    break;
                default:
                    break;
            }
            [self.tableview reloadData];
            [self.NavBtnView tapdismess];
        }];
        [self.view addSubview:self.NavBtnView];
        [self.NavBtnView appear];
        
    }
}

- (CGFloat)getMaxLenth
{
    CGFloat s = 0;
    for (NSInteger i = 0; i<self.arrTitles.count; i++)
    {
        CGSize size = [self.arrTitles[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:NULL].size;
        if (size.width > s)
        {
            s = size.width;
        }
    }
    return s;
}

- (void)setUpCommentView
{
    if ([self.status isEqualToString:@"CALL_BACK"] || [self.status isEqualToString:@"DENY"])
    {
        self.commentView = [[ApplyCommentView alloc] initWithFrame:[UIScreen mainScreen].bounds withType:kNoApprover];
    }
    else
    {
        self.commentView = [[ApplyCommentView alloc] initWithFrame:[UIScreen mainScreen].bounds withType:kAddApprover];
    }
    self.commentView.delegate = self;
    [self.view addSubview:self.commentView];
}

- (void)SetUnReadMessage
{
    //待审批消息匹配未读
    for (int i = 0 ; i<self.arrUndealList.count; i++)
    {
        for (int s = 0; s<self.arrUnreadMessage.count; s++)
        {
            if ([((ApplyGetReceiveListModel *)self.arrUndealList[i]).SHOW_ID isEqualToString:((ApplyMessageModel *)self.arrUnreadMessage[s]).rmShowID])
            {
                if (((ApplyMessageModel *)self.arrUnreadMessage[s]).readStatus == 0)
                {
                    ((ApplyGetReceiveListModel *)self.arrUndealList[i]).Unreadmsg = YES;
                }
                else
                {
                    ((ApplyGetReceiveListModel *)self.arrUndealList[i]).Unreadmsg = NO;
                }
                
            }
        }
        //待审批评论匹配未读
        for (int s = 0; s<self.arrUnreadMessageComment.count; s++)
        {
            if ([((ApplyGetReceiveListModel *)self.arrUndealList[i]).SHOW_ID isEqualToString:((ApplyMessageModel *)self.arrUnreadMessageComment[s]).rmShowID])
            {
                if (((ApplyMessageModel *)self.arrUnreadMessageComment[s]).readStatus == 0)
                {
                    ((ApplyGetReceiveListModel *)self.arrUndealList[i]).UnreadComment = YES;
                }
                else
                {
                    ((ApplyGetReceiveListModel *)self.arrUndealList[i]).UnreadComment = NO;
                }
            }
        }
    }
    
    for (int i = 0 ; i<self.arrDealedList.count; i++)
    {
        //已审批消息匹配未读
        for (int s = 0; s<self.arrUnreadMessage.count; s++)
        {
            if ([((ApplyGetReceiveListModel *)self.arrDealedList[i]).SHOW_ID isEqualToString:((ApplyMessageModel *)self.arrUnreadMessage[s]).rmShowID])
            {
                if (((ApplyMessageModel *)self.arrUnreadMessage[s]).readStatus == 0)
                {
                    ((ApplyGetReceiveListModel *)self.arrDealedList[i]).Unreadmsg = YES;
                }
                else
                {
                    ((ApplyGetReceiveListModel *)self.arrDealedList[i]).Unreadmsg = NO;
                }
                
            }
        }
        //已审批评论匹配未读
        for (int s = 0; s<self.arrUnreadMessageComment.count; s++)
        {
            if ([((ApplyGetReceiveListModel *)self.arrDealedList[i]).SHOW_ID isEqualToString:((ApplyMessageModel *)self.arrUnreadMessageComment[s]).rmShowID])
            {
                if (((ApplyMessageModel *)self.arrUnreadMessageComment[s]).readStatus == 0)
                {
                    ((ApplyGetReceiveListModel *)self.arrDealedList[i]).UnreadComment = YES;
                }
                else
                {
                    ((ApplyGetReceiveListModel *)self.arrDealedList[i]).UnreadComment = NO;
                }
            }
        }
    }
    
    
    //CC消息匹配未读--------CC
    for (int i = 0 ; i<self.arrCCList.count; i++)
    {
        for (int s = 0; s<self.arrUnreadMessageCC.count; s++)
        {
            if ([((ApplyGetReceiveListModel *)self.arrCCList[i]).SHOW_ID isEqualToString:((ApplyMessageModel *)self.arrUnreadMessageCC[s]).rmShowID])
            {
                if (((ApplyMessageModel *)self.arrUnreadMessageCC[s]).readStatus == 0)
                {
                    ((ApplyGetReceiveListModel *)self.arrCCList[i]).Unreadmsg = YES;
                }
                else
                {
                    ((ApplyGetReceiveListModel *)self.arrCCList[i]).Unreadmsg = NO;
                }
            }
        }
        //CC评论匹配未读--------CC
        for (int s = 0; s<self.arrUnreadMessageComment.count; s++)
        {
            if ([((ApplyGetReceiveListModel *)self.arrCCList[i]).SHOW_ID isEqualToString:((ApplyMessageModel *)self.arrUnreadMessageComment[s]).rmShowID])
            {
                if (((ApplyMessageModel *)self.arrUnreadMessageComment[s]).readStatus == 0)
                {
                    ((ApplyGetReceiveListModel *)self.arrCCList[i]).UnreadComment = YES;
                }
                else
                {
                    ((ApplyGetReceiveListModel *)self.arrCCList[i]).UnreadComment = NO;
                }
            }
        }
    }
    
    //send消息匹配未读
    for (int i = 0 ; i<self.arrSendList.count; i++)
    {
        for (int s = 0; s<self.arrUnreadMessageSend.count; s++)
        {
            if ([((ApplyGetReceiveListModel *)self.arrSendList[i]).SHOW_ID isEqualToString:((ApplyMessageModel *)self.arrUnreadMessageSend[s]).rmShowID])
            {
                if (((ApplyMessageModel *)self.arrUnreadMessageSend[s]).readStatus == 0)
                {
                    ((ApplyGetReceiveListModel *)self.arrSendList[i]).Unreadmsg = YES;
                }
                else
                {
                    ((ApplyGetReceiveListModel *)self.arrSendList[i]).Unreadmsg = NO;
                }
                
            }
        }
        
        //send评论匹配未读--------CC
        for (int s = 0; s<self.arrUnreadMessageComment.count; s++)
        {
            if ([((ApplyGetReceiveListModel *)self.arrSendList[i]).SHOW_ID isEqualToString:((ApplyMessageModel *)self.arrUnreadMessageComment[s]).rmShowID])
            {
                if (((ApplyMessageModel *)self.arrUnreadMessageComment[s]).readStatus == 0)
                {
                    ((ApplyGetReceiveListModel *)self.arrSendList[i]).UnreadComment = YES;
                }
                else
                {
                    ((ApplyGetReceiveListModel *)self.arrSendList[i]).UnreadComment = NO;
                }
            }
        }
    }
    
    [self maketheorder];
    [self.arrAll addObjectsFromArray:self.arrUndealList];
    [self.arrAll addObjectsFromArray:self.arrDealedList];
    [self.arrAll addObjectsFromArray:self.arrCCList];
    [self.arrAll addObjectsFromArray:self.arrSendList];
    [self.tableview reloadData];
}

- (void)CompareUnreadMessage
{
    if (self.ReadySend && self.ReadyCC && self.ReadyUndeal && self.ReadyDealed && self.ReadyAproveComment && self.ReadyUnreadAprove && self.ReadyUnreadCC && self.ReadyUnreadSend)
    {
        [self SetUnReadMessage];
    }
}

//排序
- (void)maketheorder
{
    NSMutableArray *arrUrgent = [[NSMutableArray alloc] init];
    NSMutableArray *arrHasEndTime = [[NSMutableArray alloc] init];
    NSMutableArray *arrNormal = [[NSMutableArray alloc] init];
    
    for (ApplyGetReceiveListModel *model in self.arrUndealList)
    {
        if (model.A_IS_URGENT == 1)
        {
            [arrUrgent addObject:model];
        }
        else
        {
            if (model.A_DEADLINE> 0)
            {
                [arrHasEndTime addObject:model];
            }
            else
            {
                [arrNormal addObject:model];
            }
        }
    }
    NSArray *array = [arrHasEndTime sortedArrayUsingComparator:^NSComparisonResult(ApplyGetReceiveListModel * obj1, ApplyGetReceiveListModel * obj2) {
        if (![[NSDate dateWithTimeIntervalSince1970:obj1.A_DEADLINE/1000] isEarlierThanOrEqualTo:[NSDate dateWithTimeIntervalSince1970:obj2.A_DEADLINE/1000]])
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
    }];
    NSArray *array2 = [arrNormal sortedArrayUsingComparator:^NSComparisonResult(ApplyGetReceiveListModel * obj1, ApplyGetReceiveListModel * obj2) {
        if (![[NSDate dateWithTimeIntervalSince1970:obj1.CREATE_TIME/1000] isEarlierThanOrEqualTo:[NSDate dateWithTimeIntervalSince1970:obj2.CREATE_TIME/1000]])
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
    }];
    
    [self.arrUndealList removeAllObjects];
    [self.arrUndealList addObjectsFromArray:arrUrgent];
    [self.arrUndealList addObjectsFromArray:array];
    [self.arrUndealList addObjectsFromArray:array2];
    
//    NSMutableArray *arrSendCopy = [[NSMutableArray alloc] init];
//    for (ApplyGetReceiveListModel * obj1 in self.arrSendList)
//    {
//        if ([obj1.A_STATUS isEqualToString:@"APPROVE"] && obj1.Unreadmsg == NO)
//        {
//            [arrSendCopy addObject:obj1];
//        }
//    }
//    [self.arrDealedList addObjectsFromArray:arrSendCopy];
//    [self.arrSendList removeObjectsInArray:arrSendCopy];
    
//    NSMutableArray *arrCC = [[NSMutableArray alloc] init];
//    for (ApplyGetReceiveListModel * obj1 in self.arrCCList)
//    {
//        if (obj1.UnreadComment == NO && obj1.Unreadmsg == NO)
//        {
//            [arrCC addObject:obj1];
//        }
//    }
//    [self.arrDealedList addObjectsFromArray:arrCC];
//    [self.arrCCList removeObjectsInArray:arrCC];
    
    
    //    NSArray *array = [arrLeftEvent sortedArrayUsingComparator:^NSComparisonResult(CalendarLaunchrModel * obj1, CalendarLaunchrModel * obj2) {
    //        if (![obj1.time[0] isEarlierThanOrEqualTo:obj2.time[0]])
    //        {
    //            return (NSComparisonResult)NSOrderedDescending;
    //        }
    //        else
    //        {
    //            return (NSComparisonResult)NSOrderedAscending;
    //        }
    //    }];
}

#pragma mark - tableViewDeledgate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.currentKind)
    {
        case tableviewcellKind_all:
            return self.arrAll.count;
            break;
        case tableviewcellKind_Undeal:
            return self.arrUndealList.count;
            break;
        case tableviewcellKind_Dealed:
            return self.arrDealedList.count;
            break;
        case tableviewcellKind_Cc:
            return self.arrCCList.count;
            break;
        case tableviewcellKind_Send:
            return self.arrSendList.count;
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 0.01;}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 60.0f;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* ApplyAcceptTableViewCellUndealID = @"NewApplyAllEventTableViewCellID";
    
    ApplyGetReceiveListModel *model;
    switch (self.currentKind)
    {
        case tableviewcellKind_all:
            model = [self.arrAll objectAtIndex:indexPath.row];
            break;
        case tableviewcellKind_Undeal:
            model = [self.arrUndealList objectAtIndex:indexPath.row];
            break;
        case tableviewcellKind_Dealed:
            model = [self.arrDealedList objectAtIndex:indexPath.row];
            break;
        case tableviewcellKind_Cc:
            model = [self.arrCCList objectAtIndex:indexPath.row];
            break;
        case tableviewcellKind_Send:
            model = [self.arrSendList objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    
    NewApplyAllEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ApplyAcceptTableViewCellUndealID];
    if (!cell)
    {
        cell = [[NewApplyAllEventTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ApplyAcceptTableViewCellUndealID];
    }
    if (model.ShowRightbtns)
    {
        cell.rightUtilityButtons =  [self rightButtons];
        cell.delegate = self;
    }
    [cell setmodel:model];
    return cell;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath* indexpath = [self.tableview indexPathForCell:cell];
    self.selectIndex = indexpath.row;
    ApplyGetReceiveListModel *model;
    if (self.currentKind == tableviewcellKind_all)
    {
        model = [self.arrAll objectAtIndex:self.selectIndex];
        //        model.ShowRightbtns = NO;
    }
    else if (self.currentKind == tableviewcellKind_Undeal)
    {
        model = [self.arrUndealList objectAtIndex:self.selectIndex];
        //        model.ShowRightbtns = NO;
    }
    
    //    [self.arrDealedList addObject:model];
    //    [self.arrUndealList removeObjectAtIndex:self.selectIndex];
    
    self.SelectedShowID = model.SHOW_ID;
    
    switch (index)
    {
        case 0:
        {
            self.status = @"CALL_BACK";
            [self setUpCommentView];
            break;
        }
        case 1:
        {
            self.status = @"DENY";
            [self setUpCommentView];
            break;
        }
        case 2:
        {
            self.status = @"APPROVE";
            [self.view endEditing:YES];
            //确认按钮跳出弹跳框
            UIActionSheet *actionview = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(APPLY_MAKESURE),LOCAL(APPLY_MAKESURE_FORWARD), nil];
            [actionview showInView:self.view];
            
            break;
        }
        default:
            break;
    }
    
    [self.tableview reloadData];
}

- (UIButton *)setRightBtnWithImageName:(NSString *)imgname color:(UIColor *)color title:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imge = [UIImage imageNamed:imgname];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -btn.titleLabel.bounds.size.width/2, 0, btn.titleLabel.bounds.size.width/2)];
    btn.backgroundColor = color;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:imge forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width/2, 0, -btn.titleLabel.bounds.size.width/2);
    return btn;
}

//滑动显示的右侧按钮
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    UIButton *transferBtn = [self setRightBtnWithImageName:@"backward-white" color:[UIColor mtc_colorWithR:180 g:183 b:183] title:LOCAL(APPLY_ACCEPT_BACKWARD_TITLE)];
    [rightUtilityButtons addObject:transferBtn];
    
    UIButton *unAccteptBtn = [self setRightBtnWithImageName:@"X_white" color:[UIColor grayColor] title:LOCAL(APPLY_ACCEPT_UNACCEPT_TITLE)];
    [rightUtilityButtons addObject:unAccteptBtn];
    
    UIButton *acceptBtn = [self setRightBtnWithImageName:@"turnback" color:[UIColor themeBlue] title:LOCAL(APPLY_ACCEPT_ACCEPT_TITLE)];
    [rightUtilityButtons addObject:acceptBtn];
    
    return rightUtilityButtons;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ApplyGetReceiveListModel *model;
    switch (self.currentKind)
    {
        case tableviewcellKind_all:
            model = [self.arrAll objectAtIndex:indexPath.row];
            break;
        case tableviewcellKind_Undeal:
            model = [self.arrUndealList objectAtIndex:indexPath.row];
            break;
        case tableviewcellKind_Dealed:
            model = [self.arrDealedList objectAtIndex:indexPath.row];
            break;
        case tableviewcellKind_Cc:
            model = [self.arrCCList objectAtIndex:indexPath.row];
            break;
        case tableviewcellKind_Send:
            model = [self.arrSendList objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    model.Unreadmsg = NO;
    model.UnreadComment = NO;
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    NewApplyDetailViewController *VC = [[NewApplyDetailViewController alloc] initWithShowID:model.SHOW_ID];
    
    
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - applyCommetViewDelegate
- (void)ApplyCommentViewDelegateCallBack_SendTheTxt:(NSString *)text
{
    self.strReason = text;
    if ([self.status isEqualToString:@"APPROVE"])
    {
        if ([text isEqualToString:@""] || !self.strNextApprovers)
        {
            if ([text isEqualToString:@""])
            {
                UIAlertView *view = [[UIAlertView alloc] initWithTitle:LOCAL(APPLY_INPUT_APPLY_SUGGEST) message:nil delegate:self cancelButtonTitle:LOCAL(CERTAIN) otherButtonTitles:nil];
                [view show];
            }
            else
            {
                UIAlertView *view = [[UIAlertView alloc] initWithTitle:LOCAL(APPLY_INPUT_NEXT_APPRALLER) message:nil delegate:self cancelButtonTitle:LOCAL(CERTAIN)  otherButtonTitles:nil];
                [view show];
            }
        }
        else
        {
            ApplyForwardingRequest *request = [[ApplyForwardingRequest alloc] initWithDelegate:self];
            [request GetShowID:self.SelectedShowID WithApprove:self.strNextApprovers WithApproveName:self.strNextApproverNames WithReason:self.strReason];
            [self postLoading:LOCAL(APPLY_DEALING)];
        }
    }
    else
    {
        ApplyDealWiththeApplyRequest *request = [[ApplyDealWiththeApplyRequest alloc] initWithDelegate:self];
        [request GetShowID:self.SelectedShowID WithStatus:self.status WithReason:self.strReason];
        [self postLoading:LOCAL(APPLY_DEALING)];
    }
}

- (void)ApplyCommentViewDelegateCallBack_PresentAnotherVC
{
    [self.view endEditing:YES];
    SelectContactBookViewController *VC = [[SelectContactBookViewController alloc] init];
    VC.singleSelectable = YES;
    
    [VC selectedPeople:^(NSArray *array) {
        if (![array count]) {
            return;
        }
        ContactPersonDetailInformationModel *model = [array objectAtIndex:0];
        self.strNextApprovers = model.show_id;
        self.strNextApproverNames = model.u_true_name;
        [self.commentView setCommentViewStatus:kNextApprover];
        [self.commentView setHeadNameWithModel:model];
    }];
    
    [self.navigationController presentViewController:VC animated:YES completion:nil];
}

#pragma mark - actionsheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        ApplyDealWiththeApplyRequest *request = [[ApplyDealWiththeApplyRequest alloc] initWithDelegate:self];
        [request GetShowID:self.SelectedShowID WithStatus:self.status WithReason:LOCAL(APPLY_ACCEPT)];
        [self postLoading:LOCAL(APPLY_DEALING)];
    }
    else if (buttonIndex == 1)
    {
        [self setUpCommentView];
    }
    else if (buttonIndex == 2)
    {
        
    }
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    //其他数组是否还要清空－待定 －To：Conan MA
    //    [self.arrUnreadMessageComment removeAllObjects];
    
    
    if ([response isKindOfClass:[ApplyGetReceivedApplyListResponse class]])
    {
        if ([request.params[@"A_TYPE"] isEqualToString:@"APPROVE"])
        {
            if ([request.params[@"IS_PROCESS"] integerValue] == 0)
            {
                [self.arrUndealList removeAllObjects];
                
                for (NSDictionary *dict in ((ApplyGetReceivedApplyListResponse *)response).arrData)
                {
                    ApplyGetReceiveListModel *model = [[ApplyGetReceiveListModel alloc] initWithDict:dict];
                    model.apply_type = applytype_in;
                    model.ShowRightbtns = YES;
                    [self.arrUndealList addObject:model];
                }
                self.ReadyUndeal = YES;
                [self CompareUnreadMessage];
                [self RecordToDiary:[NSString stringWithFormat:@"获取审批列表成功"]];
            }
            else
            {
                [self.arrDealedList removeAllObjects];
                for (NSDictionary *dict in ((ApplyGetReceivedApplyListResponse *)response).arrData)
                {
                    ApplyGetReceiveListModel *model = [[ApplyGetReceiveListModel alloc] initWithDict:dict];
                    model.apply_type = applytype_in;
                    [self.arrDealedList addObject:model];
                }
                self.ReadyDealed = YES;
                [self CompareUnreadMessage];
            }
        }
        else
        {
            [self.arrCCList removeAllObjects];
            for (NSDictionary *dict in ((ApplyGetReceivedApplyListResponse *)response).arrData)
            {
                ApplyGetReceiveListModel *model = [[ApplyGetReceiveListModel alloc] initWithDict:dict];
                model.apply_type = applytype_cc;
                [self.arrCCList addObject:model];
            }
            self.ReadyCC = YES;
            [self CompareUnreadMessage];
        }
    }
    
    if ([response isKindOfClass:[ApplyGetSenderListResponse class]])
    {
        NSMutableArray *arr = [(ApplyGetSenderListResponse *)response modelArr];
        for (ApplyGetReceiveListModel *model in arr)
        {
            model.apply_type = applytype_out;
        }
        [self.arrSendList removeAllObjects];
        [self.arrSendList addObjectsFromArray:arr];
        self.ReadySend = YES;
        [self CompareUnreadMessage];
        [self RecordToDiary:[NSString stringWithFormat:@"获取自己的审批列表成功"]];
    }
    [self performSelector:@selector(hideLoading) withObject:nil afterDelay:0.5];
    
    if ([response isKindOfClass:[ApplyDealWiththeApplyResponse class]])
    {
        [self.arrDealedList addObject:[self.arrUndealList objectAtIndex:self.selectIndex]];
        [self.arrAll removeObjectAtIndex:self.selectIndex];
        [self.arrUndealList removeObjectAtIndex:self.selectIndex];
        
        [self.tableview reloadData];
    }
    else if ([response isKindOfClass:[ApplyForwardingResponse class]])
    {
        [self.arrDealedList addObject:[self.arrUndealList objectAtIndex:self.selectIndex]];
        [self.arrAll removeObjectAtIndex:self.selectIndex];
        [self.arrUndealList removeObjectAtIndex:self.selectIndex];
        
        [self.tableview reloadData];
    }
    else if ([response isKindOfClass:[ApplyMessageResponse class]])
    {
        if ([request.params[@"appMessageType"] isEqualToString:@"APPROVE"])
        {
            [self.arrUnreadMessage removeAllObjects];
        }
        else if ([request.params[@"appMessageType"] isEqualToString:@"CC"])
        {
            [self.arrUnreadMessageCC removeAllObjects];
        }
        else if ([request.params[@"appMessageType"] isEqualToString:@"SEND"])
        {
            [self.arrUnreadMessageSend removeAllObjects];
        }
        else if ([request.params[@"appMessageType"] isEqualToString:@"APPROVAL_COMMENT"])
        {
            [self.arrUnreadMessageComment removeAllObjects];
        }
        
        for (ApplyMessageModel *model in ((ApplyMessageResponse *)response).arrMessageModel)
        {
            if ([model.appMessageType isEqualToString:@"APPROVE"])
            {
                [self.arrUnreadMessage addObject:model];
            }
            else if ([model.appMessageType isEqualToString:@"CC"])
            {
                [self.arrUnreadMessageCC addObject:model];
            }
            else if ([model.appMessageType isEqualToString:@"SEND"])
            {
                [self.arrUnreadMessageSend addObject:model];
            }
            else if ([model.appMessageType isEqualToString:@"APPROVAL_COMMENT"])
            {
                [self.arrUnreadMessageComment addObject:model];
            }
        }
        
        if ([request.params[@"appMessageType"] isEqualToString:@"APPROVE"])
        {
            self.ReadyUnreadAprove = YES;
        }
        else if ([request.params[@"appMessageType"] isEqualToString:@"CC"])
        {
            self.ReadyUnreadCC = YES;
        }
        else if ([request.params[@"appMessageType"] isEqualToString:@"SEND"])
        {
            self.ReadyUnreadSend = YES;
        }
        else if ([request.params[@"appMessageType"] isEqualToString:@"APPROVAL_COMMENT"])
        {
            self.ReadyAproveComment = YES;
        }
        
        [self CompareUnreadMessage];
        //        [self SetUnReadMessage];
    }
    
    //    else if ([response isKindOfClass:[ApplyGetTotalCountResponse class]])
    //    {
    //        [self hideLoading];
    //        [self.navbar setCountViewWithArray:[NSArray arrayWithObjects:@(totalCount),@(0), nil]];
    //    }
    
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}


#pragma mark - init
- (UIButton *)btnNavTitle
{
    if (!_btnNavTitle)
    {
        _btnNavTitle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [self getMaxLenth] + 30, 44)];
        [_btnNavTitle setImage:[UIImage imageNamed:@"calendar_downArrows"] forState:UIControlStateNormal];
        [_btnNavTitle setTitle:LOCAL(APPLY_ALL) forState:UIControlStateNormal];
        [_btnNavTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnNavTitle setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 12)];
        [_btnNavTitle addTarget:self action:@selector(NavTitleChange:) forControlEvents:UIControlEventTouchUpInside];
        [_btnNavTitle setImageEdgeInsets:UIEdgeInsetsMake(0, [self getMaxLenth] + 10, 0, -20)];
    }
    return _btnNavTitle;
}

- (NSMutableArray *)arrTitles
{
    if (!_arrTitles)
    {
        _arrTitles = [[NSMutableArray alloc] initWithArray:@[LOCAL(APPLY_ALL), LOCAL(APPLY_NEEDAPPLY), LOCAL(APPLY_SENDS), LOCAL(APPLY_CC), LOCAL(APPLY_DONE)]];
    }
    return _arrTitles;
}

- (NewApplyKindbtnsView *)NavBtnView
{
    if (!_NavBtnView)
    {
        _NavBtnView = [[NewApplyKindbtnsView alloc] initWithArrayLogos:nil arrayTitles:self.arrTitles];
    }
    return _NavBtnView;
}

- (UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.backgroundColor = [UIColor whiteColor];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

- (NSMutableArray *)arrAll
{
    if (!_arrAll)
    {
        _arrAll = [[NSMutableArray alloc] init];
    }
    return _arrAll;
}

- (NSMutableArray *)arrUndealList
{
    if (!_arrUndealList)
    {
        _arrUndealList = [[NSMutableArray alloc] init];
    }
    return _arrUndealList;
}

- (NSMutableArray *)arrDealedList
{
    if (!_arrDealedList)
    {
        _arrDealedList = [[NSMutableArray alloc] init];
    }
    return _arrDealedList;
}

- (NSMutableArray *)arrCCList
{
    if (!_arrCCList)
    {
        _arrCCList = [[NSMutableArray alloc] init];
    }
    return _arrCCList;
}

- (NSMutableArray *)arrSendList
{
    if (!_arrSendList)
    {
        _arrSendList = [[NSMutableArray alloc] init];
    }
    return _arrSendList;
}

- (NSMutableArray *)arrUnreadMessage
{
    if (!_arrUnreadMessage)
    {
        _arrUnreadMessage = [[NSMutableArray alloc] init];
    }
    return _arrUnreadMessage;
}

- (NSMutableArray *)arrUnreadMessageCC
{
    if (!_arrUnreadMessageCC)
    {
        _arrUnreadMessageCC = [[NSMutableArray alloc] init];
    }
    return _arrUnreadMessageCC;
}

- (NSMutableArray *)arrUnreadMessageComment
{
    if (!_arrUnreadMessageComment)
    {
        _arrUnreadMessageComment = [[NSMutableArray alloc] init];
    }
    return _arrUnreadMessageComment;
}

- (NSMutableArray *)arrUnreadMessageSend
{
    if (!_arrUnreadMessageSend)
    {
        _arrUnreadMessageSend = [[NSMutableArray alloc] init];
    }
    return _arrUnreadMessageSend;
}
@end
