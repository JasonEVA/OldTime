//
//  NewApplyMainViewController.m
//  launcher
//
//  Created by conanma on 16/1/6.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyMainViewController.h"
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


#pragma mark - new
#import "NewApplyDetailViewController.h"



#define screenWidth self.view.frame.size.width

typedef enum
{
    WAITFORDEALING = 0,
    DEALEDEVENT
} EVETS ;

#define tableview_pageSize 20
#warning "The File Code is never used , Please use NewApplyMainV2ViewController instead"
@interface NewApplyMainViewController ()<ApplyNavBarDelegate, UITableViewDelegate, UITableViewDataSource,SWTableViewCellDelegate, BaseRequestDelegate,ApplySearchViewDelegate, UIActionSheetDelegate, ApplyCommentViewDelegate,UIAlertViewDelegate>
@property(nonatomic, strong) ApplyNavBar   *navbar;
@property(nonatomic, strong) UITableView  *tabView;

//测试用，可以删除
@property(nonatomic, strong) NSMutableArray  *arr;

@property (nonatomic, strong) NSMutableArray *arrUndealList;
@property (nonatomic, strong) NSMutableArray *arrDealedList;
@property (nonatomic, strong) NSMutableArray *arrCCList;
@property (nonatomic, strong) NSMutableArray *arrSendList;
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
@property (nonatomic, strong) NSMutableArray *arrUnreadMessageSend;

@property (nonatomic, strong) NSDate *SearchUnDealDate;
@property (nonatomic, strong) NSDate *SearchDealDate;
@property (nonatomic, strong) NSDate *SearchCCDate;
@property (nonatomic, strong) NSDate *SearchSendDate;
@property (nonatomic) NSInteger SearchUndealIndex;
@property (nonatomic) NSInteger SearchDealIndex;
@property (nonatomic) NSInteger SearchCCIndex;
@property (nonatomic) NSInteger SearchSendIndex;
@property (nonatomic) NSInteger DealSelectedIndex;
@property (nonatomic) BOOL isFromDetail;
@property (nonatomic) BOOL isFromContactVC;
@property (nonatomic) NSInteger CurrentSelectIndex;
@property (nonatomic, strong) ApplySearchView *SearchView;
@property (nonatomic) BOOL isreceive;
@property (nonatomic) BOOL isapply;
@property (nonatomic, strong) UIButton *btnShow;
@end

@implementation NewApplyMainViewController
- (instancetype)initWithFrom:(ComesFrom)ComeFrom
{
    if (self = [super init])
    {
        self.status = @"";
        
        self.ComeFrom = ComeFrom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addComponent];
    [self setTableViewRefresh];
    self.isreceive = YES;
    self.isapply = YES;
    self.status = @"";
    self.DealSelectedIndex = -1;
    self.SelectedShowID = @"";
    self.needForwarding = NO;
    //从详情页返回添加监听
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setIsFromDetail) name:@"FormDetail" object:nil];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[LOCAL(APPLY_ACCEPT_RECEIVER_TITLE),LOCAL(APPLY_ACCEPT_SENDER_TITLE)]];
    segment.frame = CGRectMake(0, 0, 140, 30);
    segment.selectedSegmentIndex = 0;
    segment.tintColor = [UIColor themeBlue];
    [segment addTarget:self  action:@selector(indexDidChangeForSegmentedControl:)
               forControlEvents:UIControlEventValueChanged];
    
//    [self.navigationController.navigationBar.topItem setTitleView:segment];
    [self.navigationItem setTitleView:segment];
    
    UIBarButtonItem *rightitme1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnAddClicked)];
    
    UIBarButtonItem *rightitme2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(btnSearchClicked)];
    [self.navigationItem setRightBarButtonItems:@[rightitme1,rightitme2] animated:NO];

    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.SearchView.hidden)
    {
        self.SearchView.hidden = NO;
        [self.SearchView setSearchBarFirstResponder];
    }
    
    self.SearchDealIndex = 1;
    self.SearchUndealIndex = 1;
    self.SearchSendIndex = 1;
    self.SearchCCIndex = 1;
    [self.arrDealedList removeAllObjects];
    [self.arrUndealList removeAllObjects];
    [self.arrCCList removeAllObjects];
    [self.arrSendList removeAllObjects];
    [self.tabView reloadData];
    ApplyGetReceivedApplyListRequest *requestUndeal = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
    ApplyGetReceivedApplyListRequest *requestDeal = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
    
    [requestUndeal GetType:@"APPROVE" IS_PROCESS:0 pageIndex:1 pageSize:tableview_pageSize];
    [requestDeal GetType:@"APPROVE" IS_PROCESS:1 pageIndex:1 pageSize:tableview_pageSize];

    ApplyGetReceivedApplyListRequest *requestCC = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
    [requestCC GetType:@"CC" pageIndex:self.SearchCCIndex pageSize:tableview_pageSize];
    
    ApplyGetSenderListRequest *requsetSend = [[ApplyGetSenderListRequest alloc] initWithDelegate:self];
    [requsetSend getSenderListRequstWithPageIndex:self.SearchSendIndex PageSize:tableview_pageSize];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self popGestureDisabled:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FormDetail" object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Privite Methods
- (void)btnAddClicked
{
    NewApplyStyleViewController *VC = [[NewApplyStyleViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)btnSearchClicked
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.tabBarController.tabBar setHidden:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.SearchView = [[ApplySearchView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.SearchView.delegate = self;
    [window addSubview:self.SearchView];
    [self.SearchView setSearchBarFirstResponder];
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
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navbar.mas_bottom);
    }];
    
    [self.btnShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@45);
    }];
}

- (void)btnShowClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.Undeal = btn.selected;
    [self.tabView reloadData];
}

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex == 0)
    {
        self.isreceive = YES;
        self.navbar.hidden = NO;
        [self.navbar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.equalTo(@(45));
        }];
        if (self.isapply)
        {
            self.btnShow.hidden = NO;
            [self.tabView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.top.equalTo(self.view).offset(45);
                make.bottom.equalTo(self.view.mas_bottom).offset(-45);
            }];
        }
        else
        {
            self.btnShow.hidden = YES;
            [self.tabView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.top.equalTo(self.view).offset(45);
                make.bottom.equalTo(self.view.mas_bottom);
            }];
        }
    }
    else
    {
        self.isreceive = NO;
        self.navbar.hidden = YES;
        self.btnShow.hidden = YES;
        [self.tabView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
    [self.tabView reloadData];
}

- (void)setTableViewRefresh
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ApplyGetReceivedApplyListRequest *requestUndeal = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
        ApplyGetReceivedApplyListRequest *requestDeal = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
        
        if (self.isreceive)
        {
            if (self.isapply)
            {
                if (self.Undeal)
                {
                    self.SearchUndealIndex = 1;
                    [requestUndeal GetType:@"APPROVE" IS_PROCESS:0 pageIndex:1 pageSize:tableview_pageSize];
                }
                else
                {
                    self.SearchDealIndex = 1;
                    [requestDeal GetType:@"APPROVE" IS_PROCESS:1 pageIndex:1 pageSize:tableview_pageSize];
                }
            }
            else
            {
                self.SearchCCIndex = 1;
                ApplyGetReceivedApplyListRequest *request = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
                [request GetType:@"CC" pageIndex:1 pageSize:tableview_pageSize];
            }
        }
        else
        {
            self.SearchSendIndex = 1;
            ApplyGetSenderListRequest *requset = [[ApplyGetSenderListRequest alloc] initWithDelegate:self];
            [requset getSenderListRequstWithPageIndex:1 PageSize:tableview_pageSize];
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
    
    //搜索🔍按钮
//    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(SearchActions)];
//    self.navigationItem.rightBarButtonItem = searchItem;
    //添加tableview
    self.tabView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50) style:UITableViewStyleGrouped];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    [self.view addSubview:self.tabView];
    [self.view addSubview:self.navbar];
    [self.view addSubview:self.btnShow];
    [self createFrame];
}

#pragma mark - tableViewDeledgate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isreceive)
    {
        if (self.isapply)
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
        else
        {
            return self.arrCCList.count;
        }
    }
    else
    {
        return self.arrSendList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* ApplyAcceptTableViewCellUndealID = @"ApplyAcceptTableViewCellUndeal";
    static NSString* ApplyAcceptTableViewCellDealID = @"ApplyAcceptTableViewCellDeal";
    if (self.isreceive)
    {
        if (self.isapply)
        {
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
        else
        {
            static NSString * ID = @"luancher";
            ApplySendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[ApplySendTableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
            }
            [cell setCCCellWithModel:self.arrCCList[indexPath.row]];
            return cell;
        }
    }
    else
    {
        static NSString * ID = @"luancher";
        ApplySendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            cell = [[ApplySendTableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
        }
                    [cell setCellWithModel:self.arrSendList[indexPath.row]];
        return cell;
    }
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    
    if (self.isreceive)
    {
        if (self.isapply)
        {
            if (self.Undeal)
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
    }
    else
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
    
    if (self.isreceive)
    {
        ApplyGetReceiveListModel *model;
        if (self.isapply)
        {
            if (self.Undeal)
            {
                model = [self.arrUndealList objectAtIndex:indexPath.row];
            }
            else
            {
                model = [self.arrDealedList objectAtIndex:indexPath.row];
            }
        }
        else
        {
            model = [self.arrCCList objectAtIndex:indexPath.row];
        }
        NewApplyDetailViewController *VC = [[NewApplyDetailViewController alloc] initWithShowID:model.SHOW_ID];
        [self.navigationController pushViewController:VC animated:YES];
    }
    else
    {
        ApplyGetSendListModel *model;
        model = [self.arrSendList objectAtIndex:indexPath.row];
        NewApplyDetailViewController *VC = [[NewApplyDetailViewController alloc] initWithShowID:model.showID];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    
//    进入对应界面
//    if (self.isreceive)
//    {
//        if (self.isapply)
//        {
//            ApplyGetReceiveListModel *model;
//            if (self.Undeal)
//            {
//                model = [self.arrUndealList objectAtIndex:indexPath.row];
//            }
//            else
//            {
//                model = [self.arrDealedList objectAtIndex:indexPath.row];
//            }
//            model.Unreadmsg = NO;
//            model.UnreadComment = NO;
//            if ([model.T_SHOW_ID isEqualToString:@"vEyVJ7K29qcovp3p"] || [model.T_SHOW_ID isEqualToString:@"BB1xoKW53kCPW7OP"])
//            {
//                ApplyAcceptDetailViewController *detailVc = [[ApplyAcceptDetailViewController alloc] initWithFrom:FromReceiver From:Pass_From_Receiver withShowID:model.SHOW_ID];
//                [detailVc clickToRemoveWithBlock:^{
//                    [self.arrUndealList removeObjectAtIndex:self.CurrentSelectIndex];
//                }];
//                
//                if (self.Undeal)
//                {
//                    detailVc.disappearapprel = NO;
//                }
//                else
//                {
//                    detailVc.disappearapprel = YES;
//                }
//                
//                ApplyAcceptTableViewCell *cell = (ApplyAcceptTableViewCell *)[self.tabView cellForRowAtIndexPath:indexPath];
//                cell.messageTag.hidden = YES;
//                cell.tagIcon.hidden = YES;
//                
//                [detailVc backblock:^(NSInteger has){
//                    model.IS_HAVECOMMENT = has;
//                    [cell setDataWithModel:model];
//                    [self.tabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                }];
//                
//                [detailVc setHidesBottomBarWhenPushed:YES];
//                [self.navigationController pushViewController:detailVc animated:YES];
//            }
//            else
//            {
//                ApplyUserDefinedDetailViewController *detailVc = [[ApplyUserDefinedDetailViewController alloc] initWithFrom:new_FromReceiver From:new_Pass_From_Receiver withShowID:model.SHOW_ID];
//                [detailVc clickToRemoveWithBlock:^{
//                    [self.arrUndealList removeObjectAtIndex:self.CurrentSelectIndex];
//                }];
//                
//                if (self.Undeal)
//                {
//                    detailVc.disappearapprel = NO;
//                }
//                else
//                {
//                    detailVc.disappearapprel = YES;
//                }
//                
//                ApplyAcceptTableViewCell *cell = (ApplyAcceptTableViewCell *)[self.tabView cellForRowAtIndexPath:indexPath];
//                cell.messageTag.hidden = YES;
//                cell.tagIcon.hidden = YES;
//                
//                [detailVc backblock:^(NSInteger has){
//                    model.IS_HAVECOMMENT = has;
//                    [cell setDataWithModel:model];
//                    [self.tabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                }];
//                
//                [detailVc setHidesBottomBarWhenPushed:YES];
//                [self.navigationController pushViewController:detailVc animated:YES];
//            }
//
//        }
//        else
//        {
//            ApplyGetReceiveListModel *model = [self.arrCCList objectAtIndex:indexPath.row];
//            if ([model.T_SHOW_ID isEqualToString:VOCATION] || [model.T_SHOW_ID isEqualToString:EXPENSE])
//            {
//                ApplyAcceptDetailViewController *detailVc = [[ApplyAcceptDetailViewController alloc] initWithFrom:FromReceiver From:Pass_From_CC withShowID:model.SHOW_ID];
//                [detailVc setHidesBottomBarWhenPushed:YES];
//                [self.navigationController pushViewController:detailVc animated:YES];
//            }
//            else
//            {
//                ApplyUserDefinedDetailViewController *detailVc = [[ApplyUserDefinedDetailViewController alloc] initWithFrom:new_FromReceiver From:new_Pass_From_CC withShowID:model.SHOW_ID];
//                [detailVc setHidesBottomBarWhenPushed:YES];
//                [self.navigationController pushViewController:detailVc animated:YES];
//            }
//        }
//    }
//    else
//    {
//        ApplySendTableViewCell *cell  = (ApplySendTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//        [cell setTagHide];
//        ApplyGetSendListModel *model = [self.arrSendList objectAtIndex:indexPath.row];
//        if ([model.T_SHOW_ID isEqualToString:VOCATION] || [model.T_SHOW_ID isEqualToString:EXPENSE])
//        {
//            ApplyAcceptDetailViewController *vc = [[ApplyAcceptDetailViewController alloc] initWithFrom:FromSender From:Pass_nil withShowID:model.showID];
//            [vc setHidesBottomBarWhenPushed:YES];
//            [vc backblock:^(NSInteger has) {
//                model.UnreadComment = has;
//                [cell setCellWithModel:model];
//                [self.tabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            }];
//            
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        else
//        {
//            ApplyUserDefinedDetailViewController *vc = [[ApplyUserDefinedDetailViewController alloc] initWithFrom:new_FromSender From:new_Pass_nil withShowID:model.showID];
//            [vc setHidesBottomBarWhenPushed:YES];
//            [vc backblock:^(NSInteger has) {
//                model.UnreadComment = has;
//                [cell setCellWithModel:model];
//                [self.tabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            }];
//            
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//
//    }

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
    if(index == WAITFORDEALING)
    {
        self.tabView.footer.hidden = NO;
        self.isapply = YES;
        self.btnShow.hidden = NO;
        [self.tabView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(45);
            make.bottom.equalTo(self.view.mas_bottom).offset(-45);
        }];
    }
    else if (index == DEALEDEVENT)
    {
        self.tabView.footer.hidden = NO;
        self.isapply = NO;
        self.btnShow.hidden = YES;
        [self.tabView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(45);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
    
    [self.tabView reloadData];
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
        self.strNextApprovers = model.u_name;
        self.strNextApproverNames = model.u_true_name;
        [self.commentView setCommentViewStatus:kNextApprover];
        [self.commentView setHeadNameWithModel:model];
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

- (void)SetUnReadMessage
{
    if (self.isreceive)
    {
        if (self.isapply)
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
            
            //待审批消息匹配未读
            for (int i = 0 ; i<self.arrCCList.count; i++)
            {
                for (int s = 0; s<self.arrUnreadMessageCC.count; s++)
                {
                    if ([((ApplyGetReceiveListModel *)self.arrCCList[i]).SHOW_ID isEqualToString:((ApplyMessageModel *)self.arrUnreadMessageCC[s]).rmShowID])
                    {
                        if ([((ApplyMessageModel *)self.arrUnreadMessageCC[s]).appMessageType isEqual:@"SEND"])
                        {
                            ((ApplyGetReceiveListModel *)self.arrCCList[i]).Unreadmsg = YES;
                        }
                        else
                        {
                            ((ApplyGetReceiveListModel *)self.arrCCList[i]).UnreadComment = YES;
                        }
                        
                    }
                }
            }
        }
    }
    else
    {
        //待审批消息匹配未读
        for (int i = 0 ; i<self.arrSendList.count; i++)
        {
            for (int s = 0; s<self.arrUnreadMessageSend.count; s++)
            {
                if ([((ApplyGetSendListModel *)self.arrSendList[i]).showID isEqualToString:((ApplyMessageModel *)self.arrUnreadMessageSend[s]).rmShowID])
                {
                    if ([((ApplyMessageModel *)self.arrUnreadMessageSend[s]).appMessageType isEqual:@"SEND"])
                    {
                        ((ApplyGetSendListModel *)self.arrSendList[i]).Unreadmsg = YES;
                    }
                    else
                    {
                        ((ApplyGetSendListModel *)self.arrSendList[i]).UnreadComment = YES;
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
    if (self.isreceive)
    {
        if (self.isapply)
        {
            if (self.Undeal)
            {
                ApplyGetReceivedApplyListRequest *requestUndeal = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
                [requestUndeal GetType:@"APPROVE" IS_PROCESS:0 pageIndex:self.SearchUndealIndex pageSize:tableview_pageSize timeStamp:self.SearchUnDealDate];
            }
            else
            {
                ApplyGetReceivedApplyListRequest *requestDeal = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
                [requestDeal GetType:@"APPROVE" IS_PROCESS:1 pageIndex:self.SearchDealIndex pageSize:tableview_pageSize timeStamp:self.SearchDealDate];
            }
        }
        else
        {
            ApplyGetReceivedApplyListRequest *request = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
            [request GetType:@"CC" pageIndex:self.SearchCCIndex pageSize:tableview_pageSize timeStamp:self.SearchCCDate];
        }
    }
    else
    {
        ApplyGetSenderListRequest *requset = [[ApplyGetSenderListRequest alloc] initWithDelegate:self];
        [requset getSenderListRequstWithPageIndex:self.SearchSendIndex PageSize:tableview_pageSize TimeStamp:self.SearchSendDate];
    }
    
    
    
//    if(self.Undeal)
//    {
//        ApplyGetReceivedApplyListRequest *requestUndeal = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
//        if (self.ComeFrom == From_Receiver)
//        {
//            [requestUndeal GetType:@"APPROVE" IS_PROCESS:0 pageIndex:self.SearchUndealIndex pageSize:tableview_pageSize timeStamp:self.SearchUnDealDate];
//        }
//        else
//        {
//            [requestUndeal GetType:@"CC" IS_PROCESS:0 pageIndex:self.SearchUndealIndex pageSize:tableview_pageSize timeStamp:self.SearchUnDealDate];
//        }
//    }
//    else
//    {
//        ApplyGetReceivedApplyListRequest *requestDeal = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
//        if (self.ComeFrom == From_Receiver)
//        {
//            [requestDeal GetType:@"APPROVE" IS_PROCESS:1 pageIndex:self.SearchDealIndex pageSize:tableview_pageSize timeStamp:self.SearchDealDate];
//        }
//        else
//        {
//            [requestDeal GetType:@"CC" IS_PROCESS:1 pageIndex:self.SearchDealIndex pageSize:tableview_pageSize timeStamp:self.SearchDealDate];
//        }
//    }
    if(self.isapply)
    {
        ApplyGetTotalCountRequest * requestTotal = [[ApplyGetTotalCountRequest alloc] initWithDelegate:self];
        [requestTotal GetType:@"APPROVE" IS_PROCESS:0 pageIndex:0 pageSize:0];
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
        if ([request.params[@"A_TYPE"] isEqualToString:@"APPROVE"])
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
        }
        else
        {
            if (self.tabView.header.isRefreshing || (!self.tabView.footer.isRefreshing && !self.tabView.header.isRefreshing))
            {
                [self.arrCCList removeAllObjects];
            }
            for (NSDictionary *dict in ((ApplyGetReceivedApplyListResponse *)response).arrData)
            {
                ApplyGetReceiveListModel *model = [[ApplyGetReceiveListModel alloc] initWithDict:dict];
                [self.arrCCList addObject:model];
            }
            
            if (self.SearchCCIndex == 1)
            {
                if (self.arrCCList.count >0)
                {
                    long long date = ((ApplyGetReceiveListModel *)[self.arrCCList objectAtIndex:0]).LAST_UPDATE_TIME;
                    self.SearchCCDate = [NSDate dateWithTimeIntervalSince1970:date/1000];
                }
            }
            self.SearchCCIndex = self.SearchCCIndex + 1;
            
            if (self.tabView.header.isRefreshing && ((ApplyGetReceivedApplyListResponse *)response).arrData.count == 0)
            {
                [self.tabView.header endRefreshing];
            }
        }
        
        
        if (((ApplyGetReceivedApplyListResponse *)response).arrData.count > 0)
        {
            //未读消息接口
            if (self.isapply)
            {
                ApplyMessageRequest *msgrequest = [[ApplyMessageRequest alloc] initWithDelegate:self];
                [msgrequest GetUnreadMessagesWithpageIndex:-1 timeStamp:[NSDate date] appShowID:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdApprove] readStatus:0 messageType:@"APPROVE"];
                ApplyMessageRequest *msgrequestComment = [[ApplyMessageRequest alloc] initWithDelegate:self];
                [msgrequestComment GetUnreadMessagesWithpageIndex:-1 timeStamp:[NSDate date] appShowID:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdApprove] readStatus:0 messageType:@"APPROVAL_COMMENT"];
            }
            else
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
        if ([request.params[@"appMessageType"] isEqualToString:@"APPROVE"])
        {
            [self.arrUnreadMessage removeAllObjects];
            [self.arrUnreadMessageCC removeAllObjects];
        }
        else
        {
            [self.arrUnreadMessageSend removeAllObjects];
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
        [self SetUnReadMessage];
    }
    else if ([response isKindOfClass:[ApplyGetTotalCountResponse class]])
    {
        [self hideLoading];
        [self.navbar setCountViewWithArray:[NSArray arrayWithObjects:@(totalCount),@(0), nil]];
    }
    if ([response isKindOfClass:[ApplyGetSenderListResponse class]])
    {
        NSMutableArray *arr = [(ApplyGetSenderListResponse *)response modelArr];
        
        if (self.tabView.header.isRefreshing || (!self.tabView.footer.isRefreshing && !self.tabView.header.isRefreshing))
        {
            [self.arrSendList removeAllObjects];
        }
        
        [self.arrSendList addObjectsFromArray:arr];
        if (self.SearchSendIndex == 1 && self.arrSendList.count > 0)
        {
            long long date = ((ApplyGetSendListModel *)[self.arrSendList objectAtIndex:0]).LAST_UPDATE_TIME;
            self.SearchSendDate = [NSDate dateWithTimeIntervalSince1970:date/1000];
        }
        self.SearchSendIndex = self.SearchSendIndex + 1;
        
        [self.tabView reloadData];
//        if (self.needScrollTotop)
//        {
//            self.needScrollTotop = NO;
//            if (self.modelArr.count)
//            {
//                [self.tabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//            }
//        }
        
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
        self.arr = [NSMutableArray arrayWithObjects:LOCAL(APPLY_ACCEPT_ACCEPTBTN_TITLE),LOCAL(APPLY_ACCEPT_CCBTN_TITLE), nil];
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

- (UIButton *)btnShow
{
    if (!_btnShow)
    {
        _btnShow = [[UIButton alloc] init];
        [_btnShow setTitle:LOCAL(NEWMISSION_SHOW_FINISH) forState:UIControlStateNormal];
        [_btnShow setTitle:LOCAL(NEWMISSION_SHOW_UNFINISH) forState:UIControlStateSelected];
        [_btnShow.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_btnShow setTitleColor:[UIColor cellTitleGray] forState:UIControlStateNormal];
        [_btnShow setTitleColor:[UIColor cellTitleGray] forState:UIControlStateSelected];
        [_btnShow addTarget:self action:@selector(btnShowClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnShow.selected = YES;
    }
    return _btnShow;
}
@end
