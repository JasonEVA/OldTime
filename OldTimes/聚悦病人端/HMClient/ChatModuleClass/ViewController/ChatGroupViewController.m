
//
//  ChatGroupViewController.m
//  launcher
//
//  Created by Lars Chen on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatGroupViewController.h"
#import <Masonry.h>
#import "MyDefine.h"
#import "CalculateHeightManager.h"
#import "Slacker.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "ChatAttachPickView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NSDate+MsgManager.h"
#import <MJExtension/MJExtension.h>
#import "UIColor+Hex.h"
#import "AppDelegate.h"
#import "UITextView+AtUser.h"
#import "ContactPersonDetailInformationModel.h"
#import "CoordinationFilterView.h"
#import "ChatGroupSelectAtUserViewController.h"
//#import "ForwardSelectRecentContactViewController.h"
#import "ContactInfoModel.h"
#import "MessageBaseModel+CellSize.h"
//#import "ATModuleInteractor+CoordinationInteractor.h"
#import "IMNoPrivilegeView.h"
typedef NS_ENUM(NSUInteger, ChatMenuType) {
    ChatMenuHistoryList,
    ChatMenuGroupInfo,
};

@interface ChatGroupViewController () <ChatAttachPickViewDelegate,CoordinationFilterViewDelegate,TaskObserver>
{
    NSInteger appointCount;  //剩余约诊次数
    NSInteger hasAdded;       //商城是否有约诊的增值服务
}

@property (nonatomic, strong)  CoordinationFilterView  *filterView; //
@property (nonatomic, strong) IMNoPrivilegeView *noPrivilegeView;
@end

@implementation ChatGroupViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configCellSenderNameHide:NO];
    
    [self initCompnents];
    [self.chatInputView configAttachPickViewType:ChatAttachPickTypeBase];

    
    [self.navigationItem setTitle:self.strName];
    
    UIBarButtonItem *btnSet = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"c_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(btnDropListClicked)];
//    UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"magnifier"] style:UIBarButtonItemStylePlain target:self action:@selector(btnSearchClicked)];
    [self.navigationItem setRightBarButtonItems:@[btnSet]];//,btnSearch]];
    
    self.viewInputHeight = 50;
    
    [self startCheckIMStatusRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshGroupTitle];
    
    if (self.keyboardHeight > 0)
    {
        [self.chatInputView popupKeyboard];
    }
   

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    // 重复设为已读，防止第一次请求失败
    [self.module setReadMessages];
}

- (void)btnDropListClicked
{
    
    if (![self.view.subviews containsObject:self.filterView]) {
        [self.view addSubview:self.filterView];
        [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    else {
        [self.filterView removeFromSuperview];
        _filterView = nil;
    }
}

#pragma mark - Override Method
- (void)changeLeftNumber {
    [[MessageManager share] queryUnreadMessageCountWithoutUid:self.strUid completion:^(NSInteger unreadCount) {
        // 未读数量变换
        // do something
    }];
}

#pragma mark - Private Method
// 检查聊天状态
- (void)startCheckIMStatusRequest  {
    
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    [dict setObject:self.strUid forKey:@"imGroupId"];

    [[TaskManager shareInstance] createTaskWithTaskName:@"HMCheckChatStatusRequest" taskParam:dict TaskObserver:self];
    
}

- (BOOL)isNeedScrollPositionBottomWithTableViewOffSet
{
    CGSize contentSize =  self.tableView.contentSize;
    CGPoint offSet     =  self.tableView.contentOffset;
    float distance = contentSize.height - offSet.y - self.tableView.frame.size.height;
    if (distance <= 350 ) {
        return YES;
    }
    return NO;
}

- (void)updateViewConstraints
{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.chatInputView.mas_top);
        
    }];
    
    [self.chatInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-self.keyboardHeight);
        make.top.equalTo(self.tableView.mas_bottom);
        make.height.equalTo(@(MAX(self.viewInputHeight, self.chatInputView._viewCommon.frame.size.height)));
    }];
    
    [super updateViewConstraints];
}

- (void)initCompnents
{

}


// 群名更新
- (void)refreshGroupTitle
{
    // 从数据库取出群信息
    UserProfileModel *model = [[MessageManager share] queryContactProfileWithUid:self.strUid];
    self.strName = model.nickName;
    self.avatarPath = model.avatar;
    [self.navigationItem setTitle:self.strName];
}

#pragma mark - CoordinationFilterViewDelegate
- (void)CoordinationFilterViewDelegateCallBack_ClickWithTag:(NSInteger)tag
{
    ChatMenuType type = (ChatMenuType)tag;
    switch (type) {
        case ChatMenuHistoryList: {
//            [[ATModuleInteractor sharedInstance] goHistoryListWithUid:self.module.sessionModel._target];
            break;
        }
        case ChatMenuGroupInfo: {
            if ([self.strUid hasSuffix:@"@ChatRoom"]) {
                // 讨论组，工作圈
//                [[ATModuleInteractor sharedInstance] goWorkCircleInfoWithUid:self.strUid];
            }
            else if ([self.strUid hasSuffix:@"@SuperGroup"]) {
                // 群
//                [[ATModuleInteractor sharedInstance] goGroupInfoWith:self.module.sessionModel._target];
            }
            break;
        }
    }
    
}
#pragma mark - ChatTableViewAdapterDelegate

- (void)chatTableViewAdapterDelegateCallBack_adapter:(ChatTableViewAdapter *)adapter patientChatDealPatientRoundsWithModel:(MessageBaseModel *)baseModel tag:(NSInteger)tag {
    NSString* content = baseModel._content;
    NSLog(@"自定义消息 %@", content);
    if (!content || 0 == content.length) {
        return;
    }
    NSDictionary* dicContent = [NSDictionary JSONValue:content];
    if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    MessageBaseModelRoundsPush* modelContent = [MessageBaseModelRoundsPush mj_objectWithKeyValues:dicContent];
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    [dicPost setValue:@(modelContent.userId.integerValue) forKey:@"userId"];
    [dicPost setValue:@(modelContent.recordId.integerValue) forKey:@"recordId"];
    [dicPost setValue:@(tag) forKey:@"replyStatus"];
    [dicPost setValue:@(0) forKey:@"feedBackType"];
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMIMCELLFeedBackPatientRoundsRequest" taskParam:dicPost TaskObserver:self];

}

- (void)chatTableViewAdapterDelegateCallBack_adapter:(ChatTableViewAdapter *)adapter patientChatReadedReceiptWithModel:(MessageBaseModel *)baseModel {
    NSDictionary *dict = [NSDictionary JSONValue:baseModel._info];
    baseModel._fromLoginName = dict[@"userName"];
    
    [[MessageManager share] sendReadedRequestWithUid:self.strUid messages:@[baseModel]];
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"AppointmentStaffCountTask"])
    {
        
        if (appointCount > 0) {
            //还可以约诊次数，跳转到约诊界面
            [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentStartViewController" ControllerObject:nil];
            return;
        }
        else
        {
            if (hasAdded) {
                //已经没有可以约诊次数，跳转到订购增值服务列表界面
                [HMViewControllerManager createViewControllerWithControllerName:@"AddedValueServiceListViewController" ControllerObject:nil];
            }
            else
            {
                [self showAlertMessage:@"暂时无法预约，如需帮助，请联系您的健康顾问" confirmTitle:@"我知道了"];
                return;
            }
        }
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self.view closeWaitView];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"HMIMCELLFeedBackPatientRoundsRequest"])
    {
        
    }
    
    if ([taskname isEqualToString:@"AppointmentStaffCountTask"])
    {
        if(taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* resultDictionary = (NSDictionary*) taskResult;
            NSNumber* numCount = resultDictionary[@"totalcount"];
            if (numCount)
            {
                NSLog(@"count = %ld", numCount.integerValue);
                appointCount = numCount.integerValue;
            }
            numCount = resultDictionary[@"hasAdded"];
            if (numCount)
            {
                hasAdded = numCount.integerValue;
            }
        }
    }
    
    if ([taskname isEqualToString:@"HMCheckChatStatusRequest"]) {
        NSDictionary *dict = (NSDictionary *)taskResult;
        NSInteger status = [dict[@"sessionStatus"] integerValue];
       /* 0 未知状态
        1 可聊天
        2 套餐到期
        3 套餐退订
        4 套餐不包含图文资讯
        5 单次咨询服务到期
        6 员工无权限*/
        
        if (status == 1)
        {
            //拥有图文咨询权限
            if (self.noPrivilegeView)
            {
                [self.noPrivilegeView removeFromSuperview];
            }
        }
        else
        {
            //没有图文咨询权限
            if (!self.noPrivilegeView)
            {
                self.noPrivilegeView = [[IMNoPrivilegeView alloc] initWithIMStatus:status];
                [self.chatInputView addSubview:self.noPrivilegeView];
                [self.noPrivilegeView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.equalTo(self.chatInputView);
                    make.top.and.height.equalTo(self.chatInputView);
                }];
            }
            [self.view endEditing:YES];
        }
        
    }
}

#pragma mark - getter & setter
- (CoordinationFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[CoordinationFilterView alloc] initWithImageNames:@[@"c_historyList",@"c_groupID"] titles:@[@"历史消息",@"群名片"] tags:@[@(ChatMenuHistoryList),@(ChatMenuGroupInfo)]];
        _filterView.delegate = self;
    }
    return _filterView;
}




@end
