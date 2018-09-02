//
//  ApplyDealViewController.m
//  launcher
//
//  Created by Kyle He on 15/8/10.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//
#import "ApplyNavBar.h"
#import "Masonry.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import "ApplyDealViewController.h"
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

#define screenWidth self.view.frame.size.width

typedef enum
{
    WAITFORDEALING = 0,
    DEALEDEVENT
} EVETS ;

#define tableview_pageSize 20

@interface ApplyDealViewController ()<ApplyNavBarDelegate, UITableViewDelegate, UITableViewDataSource,SWTableViewCellDelegate, BaseRequestDelegate,ApplySearchViewDelegate, UIActionSheetDelegate, ApplyCommentViewDelegate,UIAlertViewDelegate>

@property(nonatomic, strong) ApplyNavBar   *navbar;
@property(nonatomic, strong) UITableView  *tabView;

//测试用，可以删除
@property(nonatomic, strong) NSMutableArray  *arr;

@property (nonatomic, strong) NSMutableArray *arrUndealList;
@property (nonatomic, strong) NSMutableArray *arrDealedList;
@property (nonatomic) BOOL Undeal;
@property (nonatomic) BOOL needForwarding;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *SelectedShowID;
@property (nonatomic) ComesFrom ComeFrom;
@property (nonatomic, strong) ApplyCommentView * commentView;
@property (nonatomic, strong) NSString *strNextApproverNames;
@property (nonatomic, strong) NSString *strNextApprovers;
@property (nonatomic, strong) NSString *strReason;
@property (nonatomic, strong) NSMutableArray *arrUnreadMessage;    //获取未读数组
@property (nonatomic, strong) NSMutableArray *arrUnreadMessageCC;  //获取未读数组
@property (nonatomic, strong) NSMutableArray *arrUnreadMessageComment;  //获取未读数组

@property (nonatomic, strong) NSDate *SearchUnDealDate;
@property (nonatomic, strong) NSDate *SearchDealDate;
@property (nonatomic) NSInteger SearchUndealIndex;
@property (nonatomic) NSInteger SearchDealIndex;
@property (nonatomic) NSInteger DealSelectedIndex;
@property (nonatomic) BOOL isFromDetail;
@property (nonatomic) BOOL isFromContactVC;
@property (nonatomic) NSInteger CurrentSelectIndex;
@property (nonatomic, strong) ApplySearchView *SearchView;

@end

@implementation ApplyDealViewController

- (instancetype)initWithFrom:(ComesFrom)ComeFrom
{
    if (self = [super init])
    {
        self.status = @"";
        self.DealSelectedIndex = -1;
        self.SelectedShowID = @"";
        self.needForwarding = NO;
        self.ComeFrom = ComeFrom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addComponent];
    [self setTableViewRefresh];
    //从详情页返回添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setIsFromDetail) name:@"FormDetail" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.SearchView.hidden)
    {
        self.SearchView.hidden = NO;
        [self.SearchView setSearchBarFirstResponder];
    }
    
    if (self.isFromContactVC)
    {
        self.isFromContactVC = NO;
        return;
    }
    
    [self postLoading];
    
    //    ApplyGetTotalCountRequest *totoalRequst = [[ApplyGetTotalCountRequest alloc] initWithDelegate:self];
    //    if (self.ComeFrom == From_Receiver)
    //    {
    //        [totoalRequst GetType:@"APPROVE" IS_PROCESS:0 pageIndex:0 pageSize:0];
    //    }else
    //    {
    //        [totoalRequst GetType:@"CC" IS_PROCESS:0 pageIndex:0 pageSize:0];
    //    }
    
    if (self.isFromDetail)
    {
        self.isFromDetail = !self.isFromDetail;
        [self.tabView reloadData];
        return;
    }
    self.SearchDealIndex = 1;
    self.SearchUndealIndex = 1;
    [self.arrDealedList removeAllObjects];
    [self.arrUndealList removeAllObjects];
    [self.tabView reloadData];
    ApplyGetReceivedApplyListRequest *requestUndeal = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
    ApplyGetReceivedApplyListRequest *requestDeal = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
    
    if (self.ComeFrom == From_Receiver)
    {
        self.navigationItem.title = LOCAL(APPLY_ACCEPT_ACCEPTBTN_TITLE);
        [requestUndeal GetType:@"APPROVE" IS_PROCESS:0 pageIndex:1 pageSize:tableview_pageSize];
        [requestDeal GetType:@"APPROVE" IS_PROCESS:1 pageIndex:1 pageSize:tableview_pageSize];
    }
    else
    {
        self.navigationItem.title = LOCAL(APPLY_ACCEPT_CCBTN_TITLE);
        [requestUndeal GetType:@"CC" IS_PROCESS:0 pageIndex:1 pageSize:tableview_pageSize];
        [requestDeal GetType:@"CC" IS_PROCESS:1 pageIndex:1 pageSize:tableview_pageSize];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self popGestureDisabled:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FormDetail" object:nil];
}

-(void)setIsFromDetail
{
    self.isFromDetail = YES;
}

- (void)setTableViewRefresh
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.SearchUndealIndex = 1;
        self.SearchDealIndex = 1;
        ApplyGetReceivedApplyListRequest *requestUndeal = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
        ApplyGetReceivedApplyListRequest *requestDeal = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
        
        if (self.ComeFrom == From_Receiver)
        {
            if (self.Undeal)
            {
                [requestUndeal GetType:@"APPROVE" IS_PROCESS:0 pageIndex:1 pageSize:tableview_pageSize];
            }
            else
            {
                [requestDeal GetType:@"APPROVE" IS_PROCESS:1 pageIndex:1 pageSize:tableview_pageSize];
            }
        }
        else
        {
            if (self.Undeal)
            {
                [requestUndeal GetType:@"CC" IS_PROCESS:0 pageIndex:1 pageSize:tableview_pageSize];
            }
            else
            {
                [requestDeal GetType:@"CC" IS_PROCESS:1 pageIndex:1 pageSize:tableview_pageSize];
            }
        }
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tabView.header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self RefreshTableView];
    }];
    
    self.tabView.footer = footer;
}

- (void)addComponent
{
    self.Undeal = YES;
    //初始化导航条：通过数组传入数组每个导航模块的名字即可
    self.navbar.delegate = self;
    [self.view addSubview:self.navbar];
    //搜索🔍按钮
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(SearchActions)];
    self.navigationItem.rightBarButtonItem = searchItem;
    //添加tableview
    self.tabView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 190) style:UITableViewStyleGrouped];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    [self.view addSubview:self.tabView];
    [self createFrame];
}

#pragma mark - tableViewDeledgate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.Undeal)
    {
        return self.arrUndealList.count;
    }
    else
    {
        return self.arrDealedList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* ApplyAcceptTableViewCellUndealID = @"ApplyAcceptTableViewCellUndeal";
    static NSString* ApplyAcceptTableViewCellDealID = @"ApplyAcceptTableViewCellDeal";
    
    if (self.Undeal)
    {
        ApplyAcceptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ApplyAcceptTableViewCellUndealID];
        if (!cell)
        {
            cell = [[ApplyAcceptTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ApplyAcceptTableViewCellUndealID];
        }
        cell.rightUtilityButtons =  [self rightButtons];
        cell.delegate = self;
        [cell setDataWithModel:((ApplyGetReceiveListModel *)[self.arrUndealList objectAtIndex:indexPath.row])];
        return cell;
    }
    else
    {
        ApplyAcceptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ApplyAcceptTableViewCellUndealID];
        if (!cell)
        {
            cell = [[ApplyAcceptTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ApplyAcceptTableViewCellDealID];
        }
        [cell setDataWithModel:((ApplyGetReceiveListModel *)[self.arrDealedList objectAtIndex:indexPath.row])];
        cell.rightUtilityButtons =  [self rightButtons];
        cell.delegate = self;
        return cell;
    }
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    if (self.ComeFrom == 0)
    {
        if (self.Undeal)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }else
    {
        return NO;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    ApplyGetReceiveListModel *model;
    NSIndexPath* indexpath = [self.tabView indexPathForCell:cell];
    self.DealSelectedIndex = indexpath.row;
    
    if (self.Undeal)
    {
        model = [self.arrUndealList objectAtIndex:indexpath.row];
    }
    else
    {
        model = [self.arrDealedList objectAtIndex:indexpath.row];
    }
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.CurrentSelectIndex = indexPath.row;
    //进入对应界面
    ApplyGetReceiveListModel *model;
    if (self.Undeal) {
        model = [self.arrUndealList objectAtIndex:indexPath.row];
    }
    else {
        model = [self.arrDealedList objectAtIndex:indexPath.row];
    }
    
    model.Unreadmsg = NO;
    model.UnreadComment = NO;

    if (self.ComeFrom == From_Receiver)
    {
        if ([model.T_SHOW_ID isEqualToString:@"vEyVJ7K29qcovp3p"] || [model.T_SHOW_ID isEqualToString:@"BB1xoKW53kCPW7OP"])
        {
            ApplyAcceptDetailViewController *detailVc = [[ApplyAcceptDetailViewController alloc] initWithFrom:FromReceiver From:Pass_From_Receiver withShowID:model.SHOW_ID];
            [detailVc clickToRemoveWithBlock:^{
                [self.arrUndealList removeObjectAtIndex:self.CurrentSelectIndex];
            }];
            
            if (self.Undeal)
            {
                detailVc.disappearapprel = NO;
            }
            else
            {
                detailVc.disappearapprel = YES;
            }
            
            ApplyAcceptTableViewCell *cell = (ApplyAcceptTableViewCell *)[self.tabView cellForRowAtIndexPath:indexPath];
            cell.messageTag.hidden = YES;
            cell.tagIcon.hidden = YES;
            
            [detailVc backblock:^(NSInteger has){
                model.IS_HAVECOMMENT = has;
                [cell setDataWithModel:model];
                [self.tabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            
            [detailVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:detailVc animated:YES];
        }
        else
        {
            ApplyUserDefinedDetailViewController *detailVc = [[ApplyUserDefinedDetailViewController alloc] initWithFrom:new_FromReceiver From:new_Pass_From_Receiver withShowID:model.SHOW_ID];
            [detailVc clickToRemoveWithBlock:^{
                [self.arrUndealList removeObjectAtIndex:self.CurrentSelectIndex];
            }];
            
            if (self.Undeal)
            {
                detailVc.disappearapprel = NO;
            }
            else
            {
                detailVc.disappearapprel = YES;
            }
            
            ApplyAcceptTableViewCell *cell = (ApplyAcceptTableViewCell *)[self.tabView cellForRowAtIndexPath:indexPath];
            cell.messageTag.hidden = YES;
            cell.tagIcon.hidden = YES;
            
            [detailVc backblock:^(NSInteger has){
                model.IS_HAVECOMMENT = has;
                [cell setDataWithModel:model];
                [self.tabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            
            [detailVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:detailVc animated:YES];
        }
    }
    else
    {
        if ([model.T_SHOW_ID isEqualToString:VOCATION] || [model.T_SHOW_ID isEqualToString:EXPENSE])
        {
            ApplyAcceptDetailViewController *detailVc = [[ApplyAcceptDetailViewController alloc] initWithFrom:FromReceiver From:Pass_From_CC withShowID:model.SHOW_ID];
            [detailVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:detailVc animated:YES];
        }
        else
        {
             ApplyUserDefinedDetailViewController *detailVc = [[ApplyUserDefinedDetailViewController alloc] initWithFrom:new_FromReceiver From:new_Pass_From_CC withShowID:model.SHOW_ID];
            [detailVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:detailVc animated:YES];
        }
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 0.01;}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 60.0f;}

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

#pragma mark - applyNavigationBarDelegate
//点击后数据切换
- (void)ApplyNavigationBar:(ApplyNavBar *)navBar CurrentSelectedIndex:(NSInteger)index
{
    if(index == WAITFORDEALING && !self.Undeal)
    {
        self.tabView.footer.hidden = NO;
        self.Undeal = YES;
    }
    else if (index == DEALEDEVENT && self.Undeal)
    {
        self.tabView.footer.hidden = NO;
        self.Undeal = NO;
    }
 
    [self.tabView reloadData];
}

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
    
    __weak typeof(self) weakSelf = self;
    [VC selectedPeople:^(NSArray *array) {
        if (![array count]) {
            return;
        }
        __strong typeof(weakSelf) strongSelf = weakSelf;
        ContactPersonDetailInformationModel *model = [array objectAtIndex:0];
        strongSelf.strNextApprovers = model.show_id;
        strongSelf.strNextApproverNames = model.u_true_name;
        [strongSelf.commentView setCommentViewStatus:kNextApprover];
        [strongSelf.commentView setHeadNameWithModel:model];
    }];
    
    [self.navigationController presentViewController:VC animated:YES completion:nil];
}

#pragma mark - ApplySearchView Delegate
// 搜索按钮委托
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

- (void)ApplySearchViewDelegateCallBack_SelectCellWithModel:(ApplyGetReceiveListModel *)model WithIndex:(NSInteger)index
{
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if ([model.T_SHOW_ID isEqualToString:VOCATION] || [model.T_SHOW_ID isEqualToString:EXPENSE])
    {
        ApplyAcceptDetailViewController *detailVC;
        
        NSString *myName = [[UnifiedUserInfoManager share] userShowID];
        
        
        if (model.IS_CAN_APPROVE)
        {
            detailVC = [[ApplyAcceptDetailViewController alloc] initWithFrom:FromReceiver From:Pass_From_Receiver withShowID:model.SHOW_ID];
        }
        else if (model.IS_CAN_MODIFY)
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
        
        [detailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else
    {
        ApplyUserDefinedDetailViewController *detailVC;
        
        NSString *myName = [[UnifiedUserInfoManager share] userShowID];
        
        if (model.IS_CAN_APPROVE)
        {
            detailVC = [[ApplyUserDefinedDetailViewController alloc] initWithFrom:new_FromReceiver From:new_Pass_From_Receiver withShowID:model.SHOW_ID];
        }
        else if (model.IS_CAN_MODIFY)
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
        
        [detailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    [self setUpCommentView];
}

#pragma mark - createFrame
- (void)createFrame
{
    [self.navbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(45));
    }];
    
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navbar.mas_bottom);
    }];
}

- (void)SetUnReadMessage
{
    if (self.ComeFrom == From_Receiver)
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
        
        //已审批消息匹配未读
        for (int i = 0 ; i<self.arrDealedList.count; i++)
        {
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
    }
    else
    {
        //待审批消息匹配未读--------CC
        for (int i = 0 ; i<self.arrUndealList.count; i++)
        {
            for (int s = 0; s<self.arrUnreadMessageCC.count; s++)
            {
                if ([((ApplyGetReceiveListModel *)self.arrUndealList[i]).SHOW_ID isEqualToString:((ApplyMessageModel *)self.arrUnreadMessageCC[s]).rmShowID])
                {
                    if (((ApplyMessageModel *)self.arrUnreadMessageCC[s]).readStatus == 0)
                    {
                        ((ApplyGetReceiveListModel *)self.arrUndealList[i]).Unreadmsg = YES;
                    }
                    else
                    {
                        ((ApplyGetReceiveListModel *)self.arrUndealList[i]).Unreadmsg = NO;
                    }
                }
            }
            
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
        
        //已审批消息匹配未读-------CC
        for (int i = 0 ; i<self.arrDealedList.count; i++)
        {
            for (int s = 0; s<self.arrUnreadMessageCC.count; s++)
            {
                if ([((ApplyGetReceiveListModel *)self.arrDealedList[i]).SHOW_ID isEqualToString:((ApplyMessageModel *)self.arrUnreadMessageCC[s]).rmShowID])
                {
                    if (((ApplyMessageModel *)self.arrUnreadMessageCC[s]).readStatus == 0)
                    {
                        ((ApplyGetReceiveListModel *)self.arrDealedList[i]).Unreadmsg = YES;
                    }
                    else
                    {
                        ((ApplyGetReceiveListModel *)self.arrDealedList[i]).Unreadmsg = NO;
                    }
                }
            }
            
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
    }
    
    [self.tabView reloadData];
    [self.tabView.header endRefreshing];
    [self.tabView.footer endRefreshing];
}

- (void)RefreshTableView
{
    if(self.Undeal)
    {
        ApplyGetReceivedApplyListRequest *requestUndeal = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
        if (self.ComeFrom == From_Receiver)
        {
            [requestUndeal GetType:@"APPROVE" IS_PROCESS:0 pageIndex:self.SearchUndealIndex pageSize:tableview_pageSize timeStamp:self.SearchUnDealDate];
        }
        else
        {
            [requestUndeal GetType:@"CC" IS_PROCESS:0 pageIndex:self.SearchUndealIndex pageSize:tableview_pageSize timeStamp:self.SearchUnDealDate];
        }
    }
    else
    {
        ApplyGetReceivedApplyListRequest *requestDeal = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
        if (self.ComeFrom == From_Receiver)
        {
            [requestDeal GetType:@"APPROVE" IS_PROCESS:1 pageIndex:self.SearchDealIndex pageSize:tableview_pageSize timeStamp:self.SearchDealDate];
        }
        else
        {
            [requestDeal GetType:@"CC" IS_PROCESS:1 pageIndex:self.SearchDealIndex pageSize:tableview_pageSize timeStamp:self.SearchDealDate];
        }
    }
    if(self.Undeal)
    {
        ApplyGetTotalCountRequest * requestTotal = [[ApplyGetTotalCountRequest alloc] initWithDelegate:self];
        if (self.ComeFrom == From_Receiver)
        {
            [requestTotal GetType:@"APPROVE" IS_PROCESS:0 pageIndex:0 pageSize:0];
        }
        else
        {
            [requestTotal GetType:@"CC" IS_PROCESS:0 pageIndex:0 pageSize:0];
        }
    }
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

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    
    //其他数组是否还要清空－待定 －To：Conan MA
    [self.arrUnreadMessageComment removeAllObjects];

    if ([response isKindOfClass:[ApplyGetReceivedApplyListResponse class]])
    {
        if ([request.params[@"IS_PROCESS"] integerValue] == 0)
        {
            if (self.tabView.header.isRefreshing)
            {
                [self.arrUndealList removeAllObjects];
            }
            for (NSDictionary *dict in ((ApplyGetReceivedApplyListResponse *)response).arrData)
            {
                ApplyGetReceiveListModel *model = [[ApplyGetReceiveListModel alloc] initWithDict:dict];
                [self.arrUndealList addObject:model];
            }
            if (self.SearchUndealIndex == 1)
            {
                if (self.arrUndealList.count >0)
                {
                    long long date = ((ApplyGetReceiveListModel *)[self.arrUndealList objectAtIndex:0]).LAST_UPDATE_TIME;
                    self.SearchUnDealDate = [NSDate dateWithTimeIntervalSince1970:date/1000];
                }
            }
            self.SearchUndealIndex = self.SearchUndealIndex + 1;
            [self RecordToDiary:[NSString stringWithFormat:@"获取审批列表成功"]];
        }
        else
        {
            if (self.tabView.header.isRefreshing || (!self.tabView.footer.isRefreshing && !self.tabView.header.isRefreshing))
            {
                [self.arrDealedList removeAllObjects];
            }
            for (NSDictionary *dict in ((ApplyGetReceivedApplyListResponse *)response).arrData)
            {
                ApplyGetReceiveListModel *model = [[ApplyGetReceiveListModel alloc] initWithDict:dict];
                [self.arrDealedList addObject:model];
            }
            if (self.SearchDealIndex == 1)
            {
                if (self.arrDealedList.count > 0)
                {
                    long long date = ((ApplyGetReceiveListModel *)[self.arrDealedList objectAtIndex:0]).LAST_UPDATE_TIME;
                    self.SearchDealDate = [NSDate dateWithTimeIntervalSince1970:date/1000];
                }
            }
            self.SearchDealIndex = self.SearchDealIndex + 1;
        }
        
        if (((ApplyGetReceivedApplyListResponse *)response).arrData.count > 0)
        {
            //未读消息接口
            if (self.ComeFrom == From_Receiver)
            {
                ApplyMessageRequest *msgrequest = [[ApplyMessageRequest alloc] initWithDelegate:self];
                [msgrequest GetUnreadMessagesWithpageIndex:-1 timeStamp:[NSDate date] appShowID:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdApprove] readStatus:0 messageType:@"APPROVE"];
                ApplyMessageRequest *msgrequestComment = [[ApplyMessageRequest alloc] initWithDelegate:self];
                [msgrequestComment GetUnreadMessagesWithpageIndex:-1 timeStamp:[NSDate date] appShowID:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdApprove] readStatus:0 messageType:@"APPROVAL_COMMENT"];
            }
            else if (self.ComeFrom == From_CC)
            {
                ApplyMessageRequest *msgrequest = [[ApplyMessageRequest alloc] initWithDelegate:self];
                [msgrequest GetUnreadMessagesWithpageIndex:-1 timeStamp:[NSDate date] appShowID:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdApprove] readStatus:0 messageType:@"CC"];
                ApplyMessageRequest *msgrequestComment = [[ApplyMessageRequest alloc] initWithDelegate:self];
                [msgrequestComment GetUnreadMessagesWithpageIndex:-1 timeStamp:[NSDate date] appShowID:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdApprove] readStatus:0 messageType:@"APPROVAL_COMMENT"];
            }
        }
        else
        {
            [self.tabView.header endRefreshing];
            [self.tabView.footer endRefreshing];
            [self.tabView.footer noticeNoMoreData];
        }
        
        [self.tabView reloadData];
    }
    else if ([response isKindOfClass:[ApplyDealWiththeApplyResponse class]])
    {
        [self.arrUndealList removeObjectAtIndex:self.DealSelectedIndex];
        [self.tabView reloadData];
        [self RefreshTableView];
    }
    else if ([response isKindOfClass:[ApplyForwardingResponse class]])
    {
        [self.arrUndealList removeObjectAtIndex:self.DealSelectedIndex];
        [self.tabView reloadData];
        [self RefreshTableView];
    }
    else if ([response isKindOfClass:[ApplyMessageResponse class]])
    {
        [self.arrUnreadMessage removeAllObjects];
        [self.arrUnreadMessageCC removeAllObjects];
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
            else if ([model.appMessageType isEqualToString:@"APPROVAL_COMMENT"])
            {
                [self.arrUnreadMessageComment addObject:model];
            }
        }
        [self SetUnReadMessage];
    }
    else if ([response isKindOfClass:[ApplyGetTotalCountResponse class]])
    {
        [self hideLoading];
        [self.navbar setCountViewWithArray:[NSArray arrayWithObjects:@(totalCount),@(0), nil]];
    }
    [self hideLoading];
    //    [self.tabView scrollsToTop];
    [self performSelector:@selector(hideLoading) withObject:nil afterDelay:0.5];
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}

#pragma mark - init
//self.navbar =[[ApplyNavBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45) titles:self.arr ];

- (ApplyNavBar *)navbar
{
    if (!_navbar)
    {
         self.arr = [NSMutableArray arrayWithObjects:LOCAL(APPLY_ACCEPT_WAIT_EVENT),LOCAL(APPLY_ACCEPT_DONE_EVENT), nil];
        _navbar = [[ApplyNavBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45) titles:self.arr ];
    }
    return _navbar;
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

- (NSDate *)SearchUnDealDate
{
    if (!_SearchUnDealDate)
    {
        _SearchUnDealDate = [NSDate date];
    }
    return _SearchUnDealDate;
}

- (NSDate *)SearchDealDate
{
    if (!_SearchDealDate)
    {
        _SearchDealDate = [NSDate date];
    }
    return _SearchDealDate;
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
