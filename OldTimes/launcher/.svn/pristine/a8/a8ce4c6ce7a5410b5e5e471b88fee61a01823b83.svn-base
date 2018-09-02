//
//  ChatSelectForwardUsersViewController.m
//  launcher
//
//  Created by williamzhang on 16/3/28.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatSelectForwardUsersViewController.h"
#import "ContactPersonDetailInformationModel.h"
#import "ContactBookViewController.h"
#import "BaseNavigationController.h"
#import "SelectContactTabbarView.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"

#define CHAT_FORWARD_MAXLIMIT 9

@interface ChatSelectForwardUsersViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) SelectContactTabbarView *tabbar;
@property (nonatomic, strong) BaseNavigationController *naviVC;

@property (nonatomic, copy) void (^ completion)();

// Data
@property (nonatomic, assign) BOOL isMerge;
@property (nonatomic, strong) NSArray *forwardMessages;
@property (nonatomic, strong) NSString *forwardTitle;

@end

@implementation ChatSelectForwardUsersViewController

+ (NSArray *)handledMessages:(NSArray<MessageBaseModel *> *)messages merge:(BOOL)merge {
    NSMutableArray *array = [NSMutableArray array];
    
    for (MessageBaseModel *message in messages) {
        if (message._type == msg_personal_text)
        {
            [array addObject:message];
            continue;
        }
        
        if (message._type == msg_personal_mergeMessage && !merge) {
            [array addObject:message];
            continue;
        }
    }
    
    return array;
}

- (instancetype)initWithForwardMerge:(BOOL)isMerge sessionNickName:(NSString *)sessionNickName messages:(NSArray<MessageBaseModel *> *)messages isGroup:(BOOL)isGroup completion:(void (^)())completion {
    self = [super init];
    if (self) {
        _isMerge = isMerge;
        _forwardMessages = messages;
        
        if ([_forwardMessages count] == 1) {
            _isMerge = NO;
        }
        
        if (isGroup) {
            _forwardTitle = [sessionNickName stringByAppendingString:LOCAL(CHAT_FORWARD_HISTORY)];
        }
        
        else {
            _forwardTitle = [NSString stringWithFormat:LOCAL(CHAT_FORWARD_HISTORY_SINGLE), [UnifiedUserInfoManager share].userName, sessionNickName];
        }
        
        _completion = completion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.tabbar];
    
    [self.tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.tabbar.mas_top);
    }];
    
    [self addChildViewController:self.naviVC];
    [self.naviVC view].frame = self.contentView.bounds;
    [self.contentView addSubview:self.naviVC.view];
    [self.naviVC didMoveToParentViewController:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.naviVC view].frame = self.contentView.bounds;
}

#pragma mark - Private Method
- (void)forwardMessagesToPeople:(NSArray *)toPeople {
    [self postLoading];
    
    NSMutableArray *toUsers = [NSMutableArray array];
    for (id model in toPeople) {
        if ([model isKindOfClass:[UserProfileModel class]]) {
            ContactDetailModel *toUser = [[ContactDetailModel alloc] init];
            toUser._nickName = [model nickName];
            toUser._target = [model userName];
            [toUsers addObject:toUser];
            continue;
        }
        
        if ([model isKindOfClass:[ContactPersonDetailInformationModel class]]) {
            ContactDetailModel *toUser = [[ContactDetailModel alloc] init];
            toUser._target = [model show_id];
            toUser._nickName = [model u_true_name];
            [toUsers addObject:toUser];
            continue;
        }
        
        if ([model isKindOfClass:[MessageRelationInfoModel class]]) {
            ContactDetailModel *toUser = [[ContactDetailModel alloc] init];
            toUser._target = [model relationName];
            toUser._nickName = [model nickName];
            [toUsers addObject:toUser];
            continue;
        }
    }
    
    [[MessageManager share] forwardMergeMessages:self.forwardMessages
                                           title:self.forwardTitle
                                         toUsers:toUsers
                                         isMerge:self.isMerge
                                      completion:^(BOOL success)
    {
        if (!success) {
            [self postError:LOCAL(ERROROTHER)];
            return;
        }
        
        [self postSuccess];
        !_completion ?: _completion();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

#pragma mark - Initializer
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (SelectContactTabbarView *)tabbar {
    if (!_tabbar) {
        __weak typeof(self) weakSelf = self;
        _tabbar = [[SelectContactTabbarView alloc] initWithSelectPeople:nil unableSelectPeople:nil completion:^(NSArray *selectedPeople) {
            
            if (![selectedPeople count]) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                return;
            }
            
            [weakSelf forwardMessagesToPeople:selectedPeople];
        }];
    }
    
    return _tabbar;
}

- (BaseNavigationController *)naviVC {
    if (!_naviVC) {
        ContactBookViewController * vc = [[ContactBookViewController alloc] initWithTabbar:self.tabbar];
        _naviVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
    }
    
    return _naviVC;
}

@end