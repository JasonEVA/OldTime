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
#import "ForwardSelectRecentContactViewController.h"
#import "ContactInfoModel.h"
#import "MessageBaseModel+CellSize.h"
#import "ATModuleInteractor+CoordinationInteractor.h"

typedef NS_ENUM(NSUInteger, ChatMenuType) {
    ChatMenuHistoryList,
    ChatMenuGroupInfo,
};

@interface ChatGroupViewController () <ChatAttachPickViewDelegate,CoordinationFilterViewDelegate>

@property (nonatomic, strong)  CoordinationFilterView  *filterView; // <##>
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshGroupTitle];
    
    if (self.keyboardHeight > 0)
    {
        [self.chatInputView popupKeyboard];
    }
    
    if (UMSDK_isOn) {
        [MobClick event:UMCustomEvent_EnterWorkingGroup_GroupChat];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
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
        make.height.equalTo(@(MAX(self.viewInputHeight, self.chatInputView.viewCommon.frame.size.height)));
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
            [[ATModuleInteractor sharedInstance] goHistoryListWithUid:self.module.sessionModel._target];
            break;
        }
        case ChatMenuGroupInfo: {
            if ([self.strUid hasSuffix:@"@ChatRoom"]) {
                // 讨论组，工作圈
                [[ATModuleInteractor sharedInstance] goWorkCircleInfoWithUid:self.strUid];
            }
            else if ([self.strUid hasSuffix:@"@SuperGroup"]) {
                // 群
                [[ATModuleInteractor sharedInstance] goGroupInfoWith:self.module.sessionModel._target];
            }
            break;
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
