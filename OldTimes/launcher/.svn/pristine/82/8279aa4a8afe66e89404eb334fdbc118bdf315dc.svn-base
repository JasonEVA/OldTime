//
//  ApplyViewController.m
//  launcher
//
//  Created by Kyle He on 15/8/6.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//


#import "ApplyAcceptViewController.h"
#import "ApplyButtonView.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"
#import "Masonry.h"
#import "ApplyDealViewController.h"
#import "ApplyGetReceivedApplyListRequest.h"
#import "ApplyGetReceiveListModel.h"
#import "ApplySearchView.h"
#import "ApplyAcceptDetailViewController.h"
#import "ApplyMessageRequest.h"
#import "ApplyMessageModel.h"
#import "AttachmentUtil.h"
#import "ApplyCCViewController.h"
#import "ApplyStyleModel.h"


typedef enum{
    applyBtn_corner = 0,
    ccApplyBtn_corner = 1,
}cornerType;

@interface ApplyAcceptViewController ()<BaseRequestDelegate,ApplySearchViewDelegate>
/**
 *  承认按钮
 */
@property ( nonatomic , strong ) ApplyButtonView  * applyBtn;
/**
 *  同报按钮
 */
@property ( nonatomic , strong ) ApplyButtonView  * ccApplyBtn;
@property (nonatomic, strong) NSMutableArray *arrUndealList;
@property (nonatomic, strong) NSMutableArray *arrDealedList;
@property (nonatomic, strong) NSMutableArray *arrUndealListDown;
@property (nonatomic, strong) NSMutableArray *arrDealedListDown;
@property (nonatomic, strong) NSMutableArray *arrUnreadCount;
@property (nonatomic, strong) ApplySearchView *SearchView;
@property (nonatomic) cornerType userforCorner;
@property (nonatomic, strong) NSMutableArray *arrUnreadSenderMessageModel;
@end

@implementation ApplyAcceptViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    ApplyMessageRequest *Msgrequest = [[ApplyMessageRequest alloc] initWithDelegate:self];
    [Msgrequest GetUnreadMessagesWithpageIndex:-1 timeStamp:[NSDate date] appShowID:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdApprove] readStatus:0 messageType:@"SEND"];
    
    [self showLeftItemWithSelector:@selector(backAction)];
    [self addNavigationIems];
    [self.view addSubview:self.applyBtn];
    [self.view addSubview:self.ccApplyBtn];
    self.navigationItem.title = LOCAL(APPLY_APPLY);
    [self createFrame];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    ApplyGetReceivedApplyListRequest *request = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
    [request GetType:@"APPROVE" IS_PROCESS:0 pageIndex:0 pageSize:20];
    
    ApplyGetReceivedApplyListRequest *requestCC = [[ApplyGetReceivedApplyListRequest alloc] initWithDelegate:self];
//    [requestCC GetType:@"CC" IS_PROCESS:0 pageIndex:0 pageSize:20];
    [requestCC GetType:@"CC" pageIndex:0 pageSize:20];
	
	[super viewDidAppear:animated];
	
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

#pragma mark - creataFrame
- (void)createFrame
{
    [self.applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-60);
        make.height.equalTo(@(75));
        make.width.equalTo(self.view).multipliedBy(0.53);
    }];
    
    [self.ccApplyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(60);
        make.width.height.equalTo(self.applyBtn);
    }];
}


//设置导航栏上的空间控件
- (void)addNavigationIems
{
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchActions)];
    self.navigationItem.rightBarButtonItem = searchItem;
}

#pragma mark - event respond
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

//返回应用界面
- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//点击承认人按钮
- (void)applyAction
{
    ApplyDealViewController *dealController = [[ApplyDealViewController alloc] initWithFrom:From_Receiver];
    [dealController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:dealController animated:YES];
}
//点击同报按钮
- (void)ccApplyAction
{
    ApplyCCViewController *CCController = [[ApplyCCViewController alloc] init];
    [CCController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:CCController animated:YES];
}

#pragma mark - ApplySearchView Delegate
// 取消按钮委托
- (void)ApplySearchViewDelegateCallBack_BtnCancelClicked
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.tabBarController.tabBar setHidden:NO];
//    [self.SearchView removeFromSuperview];
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

- (void)SetUnReadMessageWith:(cornerType)type
{
    if (type == ccApplyBtn_corner)
    {
        //待审批消息匹配未读
        [self.arrUnreadCount removeAllObjects];
        for (int i = 0 ; i<self.arrUndealListDown.count; i++)
        {
            for (int s = 0; s<self.arrUnreadSenderMessageModel.count; s++)
            {
                if ([((ApplyGetReceiveListModel *)self.arrUndealListDown[i]).SHOW_ID isEqualToString:((ApplyMessageModel *)self.arrUnreadSenderMessageModel[s]).rmShowID])
                {
                    if (((ApplyMessageModel *)self.arrUnreadSenderMessageModel[s]).readStatus == 0)
                    {
                        ((ApplyGetReceiveListModel *)self.arrUndealListDown[i]).Unreadmsg = YES;
                        [self.arrUnreadCount addObject:self.arrUndealListDown[i]];
                    }
                    else
                    {
                        ((ApplyGetReceiveListModel *)self.arrUndealListDown[i]).Unreadmsg = NO;
                    }
                    
                }
            }
        }
        [self.ccApplyBtn.roundView setCount:self.arrUnreadCount.count];
    }
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([response isKindOfClass:[ApplyGetReceivedApplyListResponse class]])
    {
       // A_TYPE
        if ([request.params[@"A_TYPE"] isEqualToString:@"APPROVE"])
        {
            [self.arrUndealList removeAllObjects];
            for (NSDictionary *dict in ((ApplyGetReceivedApplyListResponse *)response).arrData)
            {
                ApplyGetReceiveListModel *model = [[ApplyGetReceiveListModel alloc] initWithDict:dict];
                [self.arrUndealList addObject:model];
            }
            [self.applyBtn.roundView setCount:self.arrUndealList.count];
        }
        else if ([request.params[@"A_TYPE"] isEqualToString:@"CC"])
        {
            [self.arrUndealListDown removeAllObjects];
            for (NSDictionary *dict in ((ApplyGetReceivedApplyListResponse *)response).arrData)
            {
                ApplyGetReceiveListModel *model = [[ApplyGetReceiveListModel alloc] initWithDict:dict];
                [self.arrUndealListDown addObject:model];
            }
//            [self.ccApplyBtn.roundView setCount:self.arrUndealListDown.count];
            [self SetUnReadMessageWith:ccApplyBtn_corner];
        }
        self.acceptCounLbl.hidden = !self.arrUndealList.count;
        [self RecordToDiary:[NSString stringWithFormat:@"获取审批抄送列表成功"]];
    }
    else if ([response isKindOfClass:[ApplyMessageResponse class]])
    {
        for (ApplyMessageModel *model in ((ApplyMessageResponse *)response).arrMessageModel)
        {
            if ([model.appMessageType isEqualToString:@"SEND"])
            {
                [self.arrUnreadSenderMessageModel addObject:model];
            }
        }
        self.senderCuntLbl.hidden = !self.arrUnreadSenderMessageModel.count;
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}

#pragma mark - getter and setter
- (ApplyButtonView *)applyBtn
{
    if (!_applyBtn)
    {
        _applyBtn = [[ApplyButtonView alloc] initWithTitle:LOCAL(APPLY_ACCEPT_ACCEPTBTN_TITLE) img:@"noun_87352_cc_normal" selectImg:@"noun_87352_cc"];
        [_applyBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
        [_applyBtn.roundView setCount:0];
    }
    return _applyBtn;
}

- (ApplyButtonView *)ccApplyBtn
{
    if (!_ccApplyBtn)
    {
        _ccApplyBtn = [[ApplyButtonView alloc] initWithTitle:LOCAL(APPLY_ACCEPT_CCBTN_TITLE) img:@"cc_normal" selectImg:@"cc_highlight"];
        [_ccApplyBtn addTarget:self action:@selector(ccApplyAction) forControlEvents:UIControlEventTouchUpInside];
        [_ccApplyBtn.roundView setCount:0];
    }
    return  _ccApplyBtn;
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

- (NSMutableArray *)arrUndealListDown
{
    if (!_arrUndealListDown)
    {
        _arrUndealListDown = [[NSMutableArray alloc] init];
    }
    return _arrUndealListDown;
}

- (NSMutableArray *)arrDealedListDown
{
    if (!_arrDealedListDown)
    {
        _arrDealedListDown = [[NSMutableArray alloc] init];
    }
    return _arrDealedListDown;
}

- (NSMutableArray *)arrUnreadSenderMessageModel
{
    if (!_arrUnreadSenderMessageModel)
    {
        _arrUnreadSenderMessageModel = [[NSMutableArray alloc] init];
    }
    return _arrUnreadSenderMessageModel;
}

- (NSMutableArray *)arrUnreadCount
{
    if (!_arrUnreadCount)
    {
        _arrUnreadCount = [[NSMutableArray alloc] init];
    }
    return _arrUnreadCount;
}
@end
