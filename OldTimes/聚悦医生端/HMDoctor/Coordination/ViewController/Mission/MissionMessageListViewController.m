//
//  MissionMessageListViewController.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/14.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionMessageListViewController.h"
#import "ATModuleInteractor+MissionInteractor.h"
#import "MissionMessageListAdpter.h"
#import <Masonry/Masonry.h>
#import "CoordinationModalViewController.h"
#import "MissionDetailModel.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "IMApplicationConfigure.h"
#import "MessageBaseModel+missionModelTranslate.h"
#import "UIViewController+Loading.h"
#import "UpdateTaskStatusTask.h"
#import "TaskManager.h"
#import "IMMessageHandlingCenter.h"

#define PAGESIZE 10

@interface MissionMessageListViewController()<ATTableViewAdapterDelegate,CoordinationModalViewControllerDelegate,UITextViewDelegate,MessageManagerDelegate, TaskObserver>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MissionMessageListAdpter *adapter;
@property (nonatomic, strong) UITextView *myInputView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property(nonatomic, assign) BOOL  isGetOldData; //是否加载历史数据
@property(nonatomic, assign) long long lastStamp;
@property(nonatomic, assign) BOOL  isNeedFresh;
@property (nonatomic)  NSInteger  lastCount; // <##>
@property (nonatomic)  BOOL  firstTimeLoad; // 第一次加载
@property(nonatomic, strong) UIView  *emptyPageView;   //空白页

@end

@implementation MissionMessageListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"协同任务";
    UIBarButtonItem *missionListBar = [[UIBarButtonItem alloc] initWithTitle:@"清单" style:UIBarButtonItemStylePlain target:self action:@selector(goToMissionList)];
    UIBarButtonItem *addBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick)];
    [self.navigationItem setRightBarButtonItems:@[addBar,missionListBar]];
    [self configElements];
    self.lastStamp = -1;
    self.firstTimeLoad = YES;
    [self getHistoryMessage];
    [self at_postLoading];
    
    if (UMSDK_isOn) {
        [MobClick event:UMCustomEvent_EnterWorkDesk_Cooperation];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IMMessageHandlingCenter sharedInstance] registerDelegate:self];
//    if (self.firstTimeLoad) {
//        return;
//    }
//    [self getLocalListWithCount:self.adapter.adapterArray.count];
    if (UMSDK_isOn) {
        [MobClick event:UMCustomEvent_EnvetWorkingGroup_Cooperation];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IMMessageHandlingCenter sharedInstance] deregisterDelegate:self];
    // 设置已读
    [[MessageManager share] sendReadedRequestWithUid:im_task_uid messages:@[]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private method

- (void)configElements {
    [self.view addSubview:self.emptyPageView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    [self.emptyPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)getHistoryMessage
{
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] getHistoryMessageWithUid:im_task_uid messageCount:PAGESIZE endTimestamp:self.lastStamp?:-1 completion:^(NSArray *messages, BOOL success) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (success && !messages) {
            [strongSelf.tableView.mj_header endRefreshing];
            return ;
        }
        [strongSelf at_hideLoading];
        strongSelf.isNeedFresh = NO;
        strongSelf.lastCount = strongSelf.adapter.adapterArray.count;
        [strongSelf getLocalListWithCount:PAGESIZE + strongSelf.lastCount];
    }];
}

- (void)getLocalListWithCount:(NSInteger)count {
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] queryBatchMessageWithUid:im_task_uid MessageCount:count completion:^(NSArray<MessageBaseModel *> *messages) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf handleMessagesWithArray:messages];
        [strongSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)handleMessagesWithArray:(NSArray *)messages
{
    if (messages.count == 0) {
        return;
    }
    [self.adapter.adapterArray removeAllObjects];

    //数据解析
    MessageBaseModel *stampModel = [messages firstObject];
    self.lastStamp = stampModel._msgId;

    // 解析数据
    [self parseMessageData:messages];
    
    self.firstTimeLoad = NO;
}

// 解析数据
- (void)parseMessageData:(NSArray<MessageBaseModel *> *)messages {
    if (messages.count == 0) {
        return;
    }
    for (MessageBaseModel *model in messages)
    {
        if (model._type == msg_personal_event || model._type == IM_Applicaion_task) //event 事件解析类型 只解析一层
        {
            [self.adapter.adapterArray addObject:[MessageBaseModel getDetailModelWithContent:model]];
        }
        else if (model._type == msg_personal_reSend)                                 //resent 解析两层
        {
            MessageBaseModel *secondModel = [model getContentBaseModel];
            [self.adapter.adapterArray addObject:[MessageBaseModel getDetailModelWithContent:secondModel]];
        }
    }
    
    [self.tableView reloadData];
    [self performSelector:@selector(reloadTableView) withObject:nil afterDelay:0];
}

// 刷新列表
- (void)reloadTableView {
    if (self.adapter.adapterArray.count > 0) {
        if (self.isGetOldData) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.adapter.adapterArray.count - (self.lastCount ? : -1) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        else {
            if (self.adapter.scrollToBottom) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.adapter.adapterArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
    }
    self.isGetOldData = NO;
    self.lastCount = 0;
    self.tableView.hidden = !self.adapter.adapterArray.count;
    self.emptyPageView.hidden = !self.tableView.hidden;

}

- (void)showAlertView{
    CoordinationModalViewController *VC = [[CoordinationModalViewController alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles: nil];
    [self.myInputView addSubview:self.placeholderLabel];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.myInputView).offset(8);
    }];
    [VC addInputView:self.myInputView height:76];
    [self presentViewController:VC animated:YES completion:nil];
}

#pragma mark - event Response
- (void)goToMissionList
{
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"协同任务－清单"];
    [[ATModuleInteractor sharedInstance] goToMissionTypeListVC];
}
- (void)addClick
{
    [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"协同任务－新建任务"];
    [[ATModuleInteractor sharedInstance] goToAddNewMissionVC];
}
- (void)pullRefreshData {
    self.isGetOldData = YES;
    [self getHistoryMessage];
}

- (void)sendAcceptOrRejectRequestWihtAccept:(BOOL)isAccept Reason:(NSString *)reason Model:(MissionDetailModel *)model
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:model.showID forKey:@"showId"];
    [dict setValue:isAccept?@(1):@(-1) forKey:@"status"];
    [dict setValue:reason?:@"" forKey:@"reason"];
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([UpdateTaskStatusTask class]) taskParam:dict TaskObserver:self];
    [self at_postLoading];
}

- (void)statrActionRequestWithIndex:(NSInteger)index isAccept:(BOOL)isAccept
{
    if (!isAccept) {
        [self showAlertView];
        [self.myInputView setTag:index];
    } else {
        
        MissionDetailModel *model = self.adapter.adapterArray[index];
        //接受 －－发送请求
        [self sendAcceptOrRejectRequestWihtAccept:isAccept Reason:nil Model:model];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLabel.hidden = textView.text.length;
}
#pragma mark - CoordinationModalViewControllerDelegate

- (void)coordinationModalViewControllerDelegateCallBack_clickedButtonAtIndex:(NSInteger)buttonIndex Tag:(NSInteger)tag {
    if (buttonIndex) {
        //确认
        if (self.myInputView.text.length)
        {
            MissionDetailModel *model = [self.adapter.adapterArray objectAtIndex:self.myInputView.tag];
            [self sendAcceptOrRejectRequestWihtAccept:NO Reason:self.myInputView.text Model:model];
        } else {
            [self at_postError:@"请输入拒绝理由"];
        }
        
    } else {
        //取消
        
    }

}
#pragma mark - UITableViewDelegate
- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath
{
    //列表刷新回调
    [[ATModuleInteractor sharedInstance] goToMissionDetailVCFromModelID:(MissionDetailModel *)cellData];
}


#pragma mark - request Delegate
- (void)task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:NSStringFromClass([UpdateTaskStatusTask class])])
    {
        [self at_hideLoading];
    }
    
}

- (void)task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError)
    {
        [self at_postError:errorMessage];
        return;
    }
}

#pragma mark - messagemanagerDelegate
- (void)MessageManagerDelegateCallBack_needRefreshWithMessageBaseModel:(MessageBaseModel *)model
{
    [self parseMessageData:@[model]];
}

- (void)MessageManagerDelegateCallBack_needRefreshWithTareget:(NSString *)target
{
    if (!target) {
        // 重连 获取最新消息
        __weak typeof(self) weakSelf = self;
        [[MessageManager share] getHistoryMessageWithUid:im_task_uid
                                  messageCount:PAGESIZE
                                  endTimestamp:-1
                                    completion:^(NSArray *messages, BOOL success) {
                                        __strong typeof(weakSelf) strongSelf = weakSelf;
                                        if (!success || messages == 0) {
                                            return;
                                        }
                                        strongSelf.isNeedFresh = NO;
                                        strongSelf.lastCount = strongSelf.adapter.adapterArray.count;
                                        [strongSelf getLocalListWithCount:messages.count + strongSelf.lastCount];

                                    }];
        return;
    }
    
    if (![target isEqualToString:im_task_uid]) {
        return;
    }
    
    [self getLocalListWithCount:self.adapter.adapterArray.count];

}

- (void)MessageManagerDelegateCallBack_receiveMessage:(MessageBaseModel *)model {
    [self parseMessageData:@[model]];
}

// 重发消息
- (void)MessageManagerDelegateCallBack_reSendRefreshWithMessageBaseModel:(MessageBaseModel *)model
{
    MessageBaseModel *resendModel = [model getContentBaseModel];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"clientMsgId == %lld",model._clientMsgId];
    NSArray *temp = [self.adapter.adapterArray filteredArrayUsingPredicate:predicate];
    if (temp.count > 0 && resendModel) {
        NSInteger index = [self.adapter.adapterArray indexOfObject:temp.firstObject];
        [self.adapter.adapterArray replaceObjectAtIndex:index withObject:[MessageBaseModel getDetailModelWithContent:resendModel]];
        [self.tableView reloadData];
    }
}


#pragma mark - updateViewConstraints

#pragma mark - init UI

- (MissionMessageListAdpter *)adapter
{
    if (!_adapter) {
        _adapter = [MissionMessageListAdpter new];
        _adapter.adapterDelegate = self;
        _adapter.scrollToBottom = YES;
        _adapter.tableView = self.tableView;
        __weak typeof(self) weakSelf = self;
        [_adapter clickBlock:^(BOOL isAccept, NSInteger index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf statrActionRequestWithIndex:index isAccept:isAccept];
        }];
    }
    return _adapter;
}

- (UITableView *)tableView

{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefreshData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        _tableView.mj_header = header;

        _tableView.estimatedRowHeight = 60;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    }
    return _tableView;
}
- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [UILabel new];
        _placeholderLabel.text = @"请输入拒绝原因";
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.font = [UIFont systemFontOfSize:15];
    }
    return _placeholderLabel;
}

- (UITextView *)myInputView
{
    if (!_myInputView) {
        _myInputView = [[UITextView alloc] init];
        _myInputView.layer.borderColor = [UIColor grayColor].CGColor;
        _myInputView.layer.borderWidth = 0.5;
        _myInputView.layer.cornerRadius = 2;
        [_myInputView setFont:[UIFont systemFontOfSize:15]];
        _myInputView.clipsToBounds = YES;
        [_myInputView setDelegate:self];

    }
    return _myInputView;
}

- (UIView *)emptyPageView
{
    if (!_emptyPageView) {
        _emptyPageView = [[UIView alloc] init];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_nounfinishjob"]];
        UILabel *titel = [[UILabel alloc]init];
        [titel setText:@"赞！没有未完成的任务"];
        [titel setTextColor:[UIColor commonBlueColor]];
        [_emptyPageView addSubview:imageView];
        [_emptyPageView addSubview:titel];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_emptyPageView).offset(15);
            make.bottom.equalTo(_emptyPageView.mas_centerY);
        }];
        [titel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_emptyPageView);
            make.top.equalTo(_emptyPageView.mas_centerY).offset(20);
        }];
    }
    return _emptyPageView;
}
@end
