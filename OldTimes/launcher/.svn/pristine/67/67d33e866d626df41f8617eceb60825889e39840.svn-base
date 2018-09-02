//
//  NewApplyMainV2ViewController.m
//  launcher
//
//  Created by williamzhang on 16/4/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyMainV2ViewController.h"
#import "UIColor+Hex.h"
#import "ApplyNavBar.h"
#import "Masonry.h"
#import "MyDefine.h"
#import "ApplyAcceptTableViewCell.h"
#import "ApplyAcceptDetailViewController.h"
#import "ApplyGetReceivedApplyListRequest.h"
#import "ApplyGetReceiveListModel.h"
#import "ApplyDealWiththeApplyV2Request.h"
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
#import "NewApplyStyleViewController.h"
#import "NewApplyKindbtnsView.h"
#import "ApplyForwardingV2Request.h"
#import "DateTools.h"
#import "NewApplyAllEventTableViewCell.h"
#import "NewApplyDetailV2ViewController.h"
#import "NewApplySearchV2ViewController.h"
#import "BaseNavigationController.h"
#import "NewApplyGetApproveListV2Request.h"

typedef enum{
    tableviewcellKind_all = 0,
    tableviewcellKind_Undeal = 1,
    tableviewcellKind_Send = 2,
    tableviewcellKind_Cc = 3,
    tableviewcellKind_Dealed = 4
}tableviewcellKind;

#define tableview_pageSize 20

@interface NewApplyMainV2ViewController ()<ApplyNavBarDelegate, UITableViewDelegate, UITableViewDataSource,SWTableViewCellDelegate, BaseRequestDelegate,ApplySearchViewDelegate, UIActionSheetDelegate, ApplyCommentViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrAll;
@property (nonatomic, strong) NSMutableArray *arrUndealList;
@property (nonatomic, strong) NSMutableArray *arrDealedList;
@property (nonatomic, strong) NSMutableArray *arrCCList;
@property (nonatomic, strong) NSMutableArray *arrSendList;
@property (nonatomic, strong) NSMutableArray *arrTitles;

@property (nonatomic, strong) NSArray *unreadModels;

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
@property (nonatomic,strong) NSMutableArray *readApprovers;

@end

@implementation NewApplyMainV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitleView:self.btnNavTitle];
    UIBarButtonItem *rightitme1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnAddClicked)];
    
    UIBarButtonItem *rightitme2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(btnSearchClicked)];
    [self.navigationItem setRightBarButtonItems:@[rightitme1,rightitme2] animated:NO];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableview];
    self.currentKind = tableviewcellKind_all;
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self postLoading];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NewApplyGetApproveListV2Request *request = [[NewApplyGetApproveListV2Request alloc] initWithDelegate:self];
    [request listWithKeyword:nil];
    
    ApplyMessageRequest *messageRequest = [[ApplyMessageRequest alloc] initWithDelegate:self];
    [messageRequest getMessageList];
}

#pragma mark - Privite Methods
- (void)btnAddClicked
{
    NewApplyStyleViewController *VC = [[NewApplyStyleViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)btnSearchClicked
{
    NewApplySearchV2ViewController *searchVC = [[NewApplySearchV2ViewController alloc] init];
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
    for (ApplyGetReceiveListModel *model in self.arrAll)
    {
        for (ApplyMessageModel *compareModel in self.unreadModels)
        {
            if ([model.SHOW_ID isEqualToString:compareModel.rmShowID]) {
                
                if ([compareModel.appMessageType isEqualToString:@"APPROVAL_COMMENT"]) {
                    model.UnreadComment = compareModel.readStatus == 0;
                }
                else {
                    model.Unreadmsg = compareModel.readStatus == 0;
                }
            }
        }
    }
    
    for (ApplyGetReceiveListModel *model in self.arrAll) {
    
        for (ApplyGetReceiveListModel *readModel in self.readApprovers) {
            if ([model.SHOW_ID isEqualToString:readModel.SHOW_ID]) {
                model.Unreadmsg = NO;
                model.UnreadComment = NO;
            }
        }
    }
}

- (void)CompareUnreadMessage {
    [self SetUnReadMessage];
}
/// 分类
- (void)classifyModel:(NSArray<ApplyGetReceiveListModel *> *)models {
    
    [self.arrAll removeAllObjects];
    [self.arrUndealList removeAllObjects];
    [self.arrDealedList removeAllObjects];
    [self.arrCCList removeAllObjects];
    [self.arrSendList removeAllObjects];
    
    for (ApplyGetReceiveListModel *model in models) {
        if (model.apply_type == applytype_out) {
            [self.arrSendList addObject:model];
            continue;
        }
        
        if (model.apply_type == applytype_cc) {
            [self.arrCCList addObject:model];
            continue;
        }
        
        if ([model.A_STATUS isEqualToString:@"WAITING"] || [model.A_STATUS isEqualToString:@"IN_PROGRESS"]) {
            [self.arrUndealList addObject:model];
            continue;
        }
        
        [self.arrDealedList addObject:model];
    }
    
    [self maketheorder];
    [self.arrAll removeAllObjects];
    
    [self.arrAll addObjectsFromArray:self.arrUndealList];
    [self.arrAll addObjectsFromArray:self.arrDealedList];
    [self.arrAll addObjectsFromArray:self.arrCCList];
    [self.arrAll addObjectsFromArray:self.arrSendList];
    [self sortAllListModelsByCreatTime];
    
    [self CompareUnreadMessage];
    [self.tableview reloadData];
}

/**
 *  根据审批事件的创建时间来排序所有模型数组,根据当前时间进行降序排列
 */
- (void)sortAllListModelsByCreatTime {
    [self.arrAll sortUsingComparator:^NSComparisonResult(ApplyGetReceiveListModel * _Nonnull obj1, ApplyGetReceiveListModel *_Nonnull obj2) {
        return obj1.CREATE_TIME < obj2.CREATE_TIME;
    }];
    [self.arrUndealList sortUsingComparator:^NSComparisonResult(ApplyGetReceiveListModel * _Nonnull obj1, ApplyGetReceiveListModel *_Nonnull obj2) {
        return obj1.CREATE_TIME < obj2.CREATE_TIME;
    }];
    [self.arrDealedList sortUsingComparator:^NSComparisonResult(ApplyGetReceiveListModel * _Nonnull obj1, ApplyGetReceiveListModel *_Nonnull obj2) {
        return obj1.CREATE_TIME < obj2.CREATE_TIME;
    }];
    [self.arrCCList sortUsingComparator:^NSComparisonResult(ApplyGetReceiveListModel * _Nonnull obj1, ApplyGetReceiveListModel *_Nonnull obj2) {
        return obj1.CREATE_TIME < obj2.CREATE_TIME;
    }];
    [self.arrSendList sortUsingComparator:^NSComparisonResult(ApplyGetReceiveListModel * _Nonnull obj1, ApplyGetReceiveListModel *_Nonnull obj2) {
        return obj1.CREATE_TIME < obj2.CREATE_TIME;
    }];
    
}

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
    }else
    {
        cell.rightUtilityButtons = nil;
        cell.delegate = nil;
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
    [self.readApprovers addObject:model];
    
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (model.A_FORM_DATA.length) {
        
    }
    NewApplyDetailV2ViewController *VC = [[NewApplyDetailV2ViewController alloc] initWithShowID:model.SHOW_ID];
    
    
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
            ApplyForwardingV2Request *request = [[ApplyForwardingV2Request alloc] initWithDelegate:self];
            [request GetShowID:self.SelectedShowID WithApprove:self.strNextApprovers WithApproveName:self.strNextApproverNames WithReason:self.strReason];
            [self postLoading:LOCAL(APPLY_DEALING)];
        }
    }
    else
    {
        ApplyDealWiththeApplyV2Request *request = [[ApplyDealWiththeApplyV2Request alloc] initWithDelegate:self];
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
        ApplyDealWiththeApplyV2Request *request = [[ApplyDealWiththeApplyV2Request alloc] initWithDelegate:self];
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
    if ([request isKindOfClass:[NewApplyGetApproveListV2Request class]]) {
        [self classifyModel:[(id)response modelLists]];
        [self.tableview reloadData];
    }
    
    [self performSelector:@selector(hideLoading) withObject:nil afterDelay:0.5];
    
    if ([request isKindOfClass:[ApplyDealWiththeApplyV2Request class]])
    {
        [self.arrDealedList addObject:[self.arrUndealList objectAtIndex:self.selectIndex]];
        [self.arrAll removeObjectAtIndex:self.selectIndex];
        [self.arrUndealList removeObjectAtIndex:self.selectIndex];
        
        [self.tableview reloadData];
    }
    else if ([request isKindOfClass:[ApplyForwardingV2Request class]])
    {
        [self.arrDealedList addObject:[self.arrUndealList objectAtIndex:self.selectIndex]];
        [self.arrAll removeObjectAtIndex:self.selectIndex];
        [self.arrUndealList removeObjectAtIndex:self.selectIndex];
        
        [self.tableview reloadData];
    }
    else if ([response isKindOfClass:[ApplyMessageResponse class]]) {
        self.unreadModels = [(id)response arrMessageModel];
        [self CompareUnreadMessage];
        [self.tableview reloadData];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}

#pragma mark - Initializer
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
        _NavBtnView.canappear = YES;
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

- (NSMutableArray *)readApprovers {
    if (!_readApprovers) {
        _readApprovers = [[NSMutableArray alloc] init];
    }
    return _readApprovers;
}

@end
