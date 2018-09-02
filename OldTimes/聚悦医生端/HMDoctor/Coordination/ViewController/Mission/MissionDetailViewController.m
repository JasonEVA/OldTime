//
//  MissionDetailViewController.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/18.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionDetailViewController.h"
#import "MissionDetailAdapter.h"
#import <Masonry/Masonry.h>
#import "NomarlBtnsWithNoimagesView.h"
#import "ApplicationInputView.h"
#import "ATModuleInteractor+MissionInteractor.h"
#import "HMDoctorEnum.h"
#import "CoordinationModalViewController.h"
#import "UpdateTaskStatusTask.h"
#import "SetRemindTimeTask.h"
#import "TaskMessagePageTask.h"
#import "MissionCommentsModel.h"
#import "TaskMessageAddTask.h"
#import <MWPhotoBrowser-ADS/MWPhotoBrowser.h>
#import "NSString+TaskStringFormat.h"
#import "GetMissionDetailTask.h"
#import "UpdateTaskStatusTask.h"
typedef NS_ENUM(NSInteger,AlterViewControllerTag)
{
    k_reject_VCTag = 10, //拒绝
    k_finish_VCTag      //完成
};

@interface MissionDetailViewController ()<ATTableViewAdapterDelegate,MissionDetailAdapterDelegate,ApplicationInputViewDelegate,CoordinationModalViewControllerDelegate,UITextViewDelegate,TaskObserver,MWPhotoBrowserDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MissionDetailAdapter *adapter;
@property (nonatomic, strong) NomarlBtnsWithNoimagesView *moreView;
@property (nonatomic, strong) ApplicationInputView *inputView;
@property (nonatomic, strong) MissionDetailModel *model;
@property (nonatomic, strong) UITextView *myInputView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, assign) TaskCommentType  currentCommentType; // <##>
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;
@property (nonatomic, assign) TaskStatusType  currentStatusType;
@property (nonatomic, assign) MissionTaskRemindType  currentRemindTimeType; // <##>

@property (nonatomic, assign)  BOOL  needLoadDetail; // <##>
//@property (nonatomic, copy) NSString *MissionID;
@property (nonatomic, strong)  UIButton  *operationButton; // <##>
@property (nonatomic, strong)  UIButton  *declineButton; // <##>
@property (nonatomic, strong)  UIButton  *acceptButton; // <##>
@property (nonatomic, strong)  UIView  *operationView; // 操作状态view
@end

@implementation MissionDetailViewController

- (instancetype)initWIthMissionID:(MissionDetailModel *)model
{
    if (self = [super init])
    {
        self.model = [[MissionDetailModel alloc] init];
        self.model = model;
        self.adapter.model = self.model;
        self.needLoadDetail = YES;
    }
    return self;
}

- (instancetype)initWithMissionModel:(MissionDetailModel *)model
{
    if (self = [super init]) {
        _model = model;
        self.adapter.model = self.model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务详情";
    self.moreView.canappear = YES;
    [self configElements];
    // Do any additional setup after loading the view.
}


#pragma mark - private method

- (void)setModel:(MissionDetailModel *)model {
    if (_model != model) {
        _model = model;
        [self configOperationView];
    }

}

// 设置元素控件
- (void)configElements {
    
    // 设置约束
    [self configConstraints];
    
    // 设置数据
    [self configData];

}

// 设置数据
- (void)configData {
    if (self.needLoadDetail) {
        //有必要再次请求数据的！！！
        [self RequestMissionDetailWithMissionID:[NSString stringWithFormat:@"%@",self.model.showID]];
    }
    [self requestMissionCommentsWithCommentType:TaskCommentTypeAll];
}

// 设置约束
- (void)configConstraints {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.operationView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.inputView.mas_top);
    }];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
    }];
    [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
}

- (void)setRemineTimeWithType:(MissionTaskRemindType )type
{
    self.adapter.model.remindType = type;
    [self.adapter reloadRealIndex:MissionDetailCell_Type_Remind];
}

//隐藏拒绝接受按钮cell
- (void)hideButtonCell
{
    [self.adapter.adapterArray replaceObjectAtIndex:0 withObject:@[@"标题",@"时间",@"参与者",@"用户"]];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)RequestMissionDetailWithMissionID:(NSString *)misstionID
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:misstionID forKey:@"showId"];
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetMissionDetailTask class]) taskParam:dict TaskObserver:self];
    [self at_postLoading];
}

// 接收拒绝请求
- (void)updateTaskStatusRequestWithStatus:(TaskStatusType)status reason:(NSString *)reason {

    if (!self.model.showID || self.model.showID.length<=0) {
        return;
    }
    self.currentStatusType = status;
    NSDictionary *dict = @{
                           @"showId" : self.model.showID,
                           @"status" : @(status),
                           @"reason" : reason ? : @""
                           };
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([UpdateTaskStatusTask class]) taskParam:dict TaskObserver:self];
    [self at_postLoading];
}

- (void)editRemindTimeRequestWithRemindType:(MissionTaskRemindType )type {
    
    if (!self.model.showID || self.model.showID.length<=0) {
        return;
    }
    self.currentRemindTimeType = type;
    NSDictionary *dict = @{
                           @"showId" : self.model.showID,
                           @"remindType" : @(type),
                           };
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([SetRemindTimeTask class]) taskParam:dict TaskObserver:self];
    [self at_postLoading];
}

- (void)requestMissionCommentsWithCommentType:(TaskCommentType)commentType {
    self.currentCommentType = commentType;
    NSInteger type;
    switch (commentType) {
        case TaskCommentTypeAll: {
            type = -1;
            break;
        }
        case TaskCommentTypeComment: {
            type = 1;
            break;
        }
        case TaskCommentTypeOperations: {
            type = 0;
            break;
        }
    }
    
    if (!self.model.showID || self.model.showID.length<=0) {
        return;
    }
    NSDictionary *dict = @{
                           @"showId" : self.model.showID,
                           @"type" : @(type),
                           @"pageSize" : @(100),
                           @"pageIndex" : @"1"
                           };
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([TaskMessagePageTask class]) taskParam:dict TaskObserver:self];
    [self at_postLoading];
}

- (void)sendCommentRequestWithContent:(NSString *)content {
    
    UserInfo *info = [UserInfoHelper defaultHelper].currentUserInfo;
    if (!self.model.showID || self.model.showID.length<=0) {
        return;
    }

    NSDictionary *dict = @{
                           @"showId" : self.model.showID,
                           @"userId" : [NSString stringWithFormat:@"%ld",info.userId],
                           @"content" : content
                           };
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([TaskMessageAddTask class]) taskParam:dict TaskObserver:self];
    [self at_postLoading];
    [self.inputView clearText];
    [self.inputView resignfirstResponder];
    [self at_postLoading];
}

/** 点击查看照片 */
- (void)selectShowImageAtIndex:(NSUInteger)selectedIndex {
    self.photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    self.photoBrowser.displayActionButton = NO;
    self.photoBrowser.alwaysShowControls = NO;
    self.photoBrowser.zoomPhotosToFill = YES;
    self.photoBrowser.enableGrid = NO;
    self.photoBrowser.enableSwipeToDismiss = YES;
    [self.photoBrowser showNextPhotoAnimated:YES];
    [self.photoBrowser showPreviousPhotoAnimated:YES];
    [self.navigationController pushViewController:self.photoBrowser animated:YES];
    [self.photoBrowser setCurrentPhotoIndex:selectedIndex];
}


#pragma mark - event Response


- (void)showAlertView{
    
    CoordinationModalViewController *VC = [[CoordinationModalViewController alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles: nil];
    [self.myInputView addSubview:self.placeholderLabel];
    VC.tag = k_reject_VCTag;
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.myInputView).offset(8);
    }];
    [VC addInputView:self.myInputView height:76];
    [self presentViewController:VC animated:YES completion:nil];
}

- (void)showDoneConfirmAlertView
{
    CoordinationModalViewController *VC = [[CoordinationModalViewController alloc]initWithTitle:@"确认完成？" message:@"任务状态变更后不可修改" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    VC.tag = k_finish_VCTag;
    [self presentViewController:VC animated:YES completion:nil];
}

- (void)acceptTaskButtonClicked {
    [self updateTaskStatusRequestWithStatus:TaskStatusTypeActivated reason:nil];
}

#pragma mark - ApplicationInputViewDelegate

- (void)ApplicationInputViewDelegateCallBack_didStartEdit {
    if (self.adapter.arrayCommentsList.count == 0) {
        return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.adapter.arrayCommentsList.count - 1 inSection:self.adapter.adapterArray.count - 1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - MissionDetailAdapterDelegate
- (void)MissionDetailAdapterDelegateCallBack_isAccept:(BOOL)isAccept
{
    if (isAccept) {
        [self updateTaskStatusRequestWithStatus:TaskStatusTypeActivated reason:nil];
    } else {
        [self showAlertView];
    }
    
}

- (void)missionDetailAdapterDelegateCallBack_finished:(BOOL)finished {
    if (!finished) {
        return;
    }
    [self showDoneConfirmAlertView];

}

- (void)missionDetailAdapterDelegateCallBack_commentTypeClicked:(TaskCommentType)commentType {
    [self requestMissionCommentsWithCommentType:commentType];
}

- (void)missionDetailAdapterDelegateCallBack_accessoryClickImageIndex:(NSInteger)index {
    [self selectShowImageAtIndex:index];
}

- (void)missionDetailAdapterDelegateCallBack_writeCommentClicked {
    [self.inputView inputViewBecomeFirstResponder];
}

#pragma mark - UITableViewDelegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath
{
    // 接收才能改提醒时间
    if (self.model.taskStatus != TaskStatusTypeActivated || self.model.isSendFromMe) {
        return;
    }
    if ([self.adapter realIndexAtIndexPath:indexPath] == MissionDetailCell_Type_Remind) {
        __weak typeof(self) weakSelf = self;
        [[ATModuleInteractor sharedInstance] goToSelectRemineTimeVCWithRemindType:^(MissionTaskRemindType remindType) {
            [weakSelf editRemindTimeRequestWithRemindType:remindType];
        }];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLabel.hidden = textView.text.length;
}

#pragma mark - CoordinationModalViewControllerDelegate
- (void)coordinationModalViewControllerDelegateCallBack_clickedButtonAtIndex:(NSInteger)buttonIndex Tag:(NSInteger)tag
{
    if (tag == k_reject_VCTag) //拒绝
    {
        if (buttonIndex) {
            //确认
            if (self.myInputView.text.length) {
                [self updateTaskStatusRequestWithStatus:TaskStatusTypeDisabled reason:self.myInputView.text];
            } else {
                [self at_postError:@"请输入拒绝理由"];
            }
        } else {
            //取消
        }
    }
    else if(tag == k_finish_VCTag)//完成
    {
        if (buttonIndex){
            [self updateTaskStatusRequestWithStatus:TaskStatusTypeDone reason:nil];
        }
    }
}

#pragma mark - MWPhotoBrowser Delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [self.model.attachmentsPath hm_convertCuttingLineStringToArrayComponentsSeparatedByPeriodString].count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSArray *path = [self.model.attachmentsPath hm_convertCuttingLineStringToArrayComponentsSeparatedByPeriodString];
    if (index < path.count) {
        return [MWPhoto photoWithURL:[NSURL URLWithString:path[index]]];
    }
    return nil;
}

#pragma mark - request Delegate

- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (taskError == StepError_None) {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];

    if ([taskname isEqualToString:NSStringFromClass([UpdateTaskStatusTask class])]) {
        //        self.model.taskStatus = TaskStatusTypeActivated;
        //        [self hideButtonCell];
        [self at_postError:@"状态变更失败"];
    }
    else if ([taskname isEqualToString:NSStringFromClass([SetRemindTimeTask class])]) {
        [self at_postError:@"更改提醒时间失败"];
    }
    else {
        [self at_postError:errorMessage];
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
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
    if ([taskname isEqualToString:NSStringFromClass([UpdateTaskStatusTask class])]) {
        self.model.taskStatus = self.currentStatusType;
        [self.adapter setModel:self.model];
        [self.tableView reloadData];
        [self at_hideLoading];
        [self configOperationView];
    }
    else if ([taskname isEqualToString:NSStringFromClass([SetRemindTimeTask class])]) {
        [self setRemineTimeWithType:self.currentRemindTimeType];
        [self at_hideLoading];
        
    }
    else if ([taskname isEqualToString:NSStringFromClass([TaskMessagePageTask class])]) {
        if ([taskResult isKindOfClass:[MissionCommentListModel class]]) {
            MissionCommentListModel *model = (MissionCommentListModel *)taskResult;
            self.adapter.arrayCommentsList = model.list;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.adapter.adapterArray.count - 1] withRowAnimation:UITableViewRowAnimationNone];
            [self at_hideLoading];
        }
    }
    else if ([taskname isEqualToString:NSStringFromClass([TaskMessageAddTask class])]) {
        if (self.currentCommentType != TaskCommentTypeOperations) {
            [self requestMissionCommentsWithCommentType:self.currentCommentType];
        }
    }
    else if ([taskname isEqualToString:NSStringFromClass([GetMissionDetailTask class])])
    {
        if ([taskResult isKindOfClass:[MissionDetailModel class]])
        {
            self.model = taskResult;
            [self.adapter setModel:taskResult];
            [self.tableView reloadData];
            [self at_hideLoading];
        }
    }
    [self at_hideLoading];
}

#pragma mark - updateViewConstraints

#pragma mark - init UI

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        _tableView.estimatedRowHeight = 60;
    }
    return _tableView;
}

- (MissionDetailAdapter *)adapter
{
    if (!_adapter) {
        _adapter = [MissionDetailAdapter new];
        _adapter.adapterDelegate = self;
        [_adapter setCustomDelegate:self];
        [_adapter setBaseVC:self];
        _adapter.tableView = self.tableView;
        _adapter.adapterArray = [@[@[@"标题",@"参与者",@"用户"],@[@"开始时间",@"结束时间",@"提醒时间"],@[@"附件"],@[@"备注"],@[@"评论"]] mutableCopy];
//        [_adapter setModel:self.model];
    }
    return _adapter;
}

- (ApplicationInputView *)inputView {
    if (!_inputView) {
        _inputView = [[ApplicationInputView alloc] initWithViewController:self];
        [_inputView setDalegate:self];
        __weak typeof(self) weakSelf = self;
        [_inputView sendText:^(NSString *text) {
            // 发送评论
            [weakSelf sendCommentRequestWithContent:text];
        }];
        
    }
    return _inputView;
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

- (UIButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_operationButton setBackgroundImage:[UIImage at_imageWithColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_operationButton setBackgroundImage:[UIImage at_imageWithColor:[UIColor colorWithHexString:@"dfdfdf"] size:CGSizeMake(1, 1)] forState:UIControlStateDisabled];
        [_operationButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_operationButton setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateDisabled];
        [_operationButton setTitle:@"点击完成任务" forState:UIControlStateNormal];
        [_operationButton setTitle:@"任务已完成" forState:UIControlStateDisabled];
        [_operationButton addTarget:self action:@selector(showDoneConfirmAlertView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operationButton;
}

- (UIButton *)declineButton {
    if (!_declineButton) {
        _declineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_declineButton setBackgroundImage:[UIImage at_imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_declineButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_declineButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_declineButton setTitle:@"拒绝任务" forState:UIControlStateNormal];
        [_declineButton addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _declineButton;

}

- (UIButton *)acceptButton {
    if (!_acceptButton) {
        _acceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_acceptButton setBackgroundImage:[UIImage at_imageWithColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_acceptButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_acceptButton setTitle:@"接受任务" forState:UIControlStateNormal];
        [_acceptButton addTarget:self action:@selector(acceptTaskButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _acceptButton;
}

- (UIView *)operationView {
    if (!_operationView) {
        _operationView = [UIView new];
        [_operationView addSubview:self.operationButton];
        [_operationView addSubview:self.declineButton];
        [_operationView addSubview:self.acceptButton];
        
        [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_operationView);
        }];
        [self.declineButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_operationView);
            make.width.equalTo(self.acceptButton);
            make.right.equalTo(self.acceptButton.mas_left);
        }];
        [self.acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(_operationView);
        }];
    }
    [self configOperationView];
    return _operationView;
}

- (void)configOperationView {
    if (self.model.taskStatus == TaskStatusTypeNonActivated && !self.model.isSendFromMe) {
        self.operationButton.hidden = YES;
        self.acceptButton.hidden = NO;
        self.declineButton.hidden = NO;
    }
    else {
        self.operationButton.hidden = NO;
        self.acceptButton.hidden = YES;
        self.declineButton.hidden = YES;
    }
    switch (self.model.taskStatus) {
        case TaskStatusTypeDisabled: {
            self.operationButton.enabled = NO;
            [self.operationButton setTitle:self.model.isSendFromMe ? @"任务被拒绝" : @"任务已拒绝" forState:UIControlStateDisabled];
            break;
        }
        case TaskStatusTypeNonActivated: {
            // 创建者新建任务
            if (self.model.isSendFromMe) {
                self.operationButton.enabled = NO;
                [self.operationButton setTitle:@"任务待接受" forState:UIControlStateDisabled];
            }
            break;
        }
        case TaskStatusTypeActivated:
        case TaskStatusTypeExpired: {
            self.operationButton.enabled = YES;
            [self.operationButton setTitle:@"点击完成任务" forState:UIControlStateNormal];
            break;
        }
        case TaskStatusTypeDone: {
            self.operationButton.enabled = NO;
            [self.operationButton setTitle:@"任务已完成" forState:UIControlStateDisabled];
            break;
        }
    }
    
}
@end
