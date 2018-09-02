//
//  SelectContactBookViewController.m
//  launcher
//
//  Created by williamzhang on 15/10/12.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "SelectContactBookViewController.h"
#import "ContactDepartmentImformationModel+UserForSelect.h"
#import "ContactPersonDetailInformationModel.h"
#import "SelectContactTabbarView.h"
#import "UnifiedSqlManager.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "SelectContactBookContainerViewController.h"
#import "BaseNavigationController.h"
#import "HomeTabBarController.h"
#import "AppDelegate.h"
#import "UINavigationController+CompletionHandle.h"
#import <MintcodeIM/MintcodeIM.h>

@interface SelectContactBookViewController ()

/** 将VC.view包含住 */
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) SelectContactTabbarView *tabbar;
@property (nonatomic, strong) SelectContactBookContainerViewController *containerVC;
@property (nonatomic, strong) BaseNavigationController *naviVC;

@property (nonatomic, copy) void (^selectedBlock)(NSArray *);

@property (nonatomic, strong) NSArray *arrOriginGroupMemberList;    // 已有群添加新成员

@property (nonatomic, strong) NSArray *arrayOriginalSelected;
@property (nonatomic, strong) NSArray *arrayUnableSelected;

@end

@implementation SelectContactBookViewController

- (instancetype)initWithSelectedPeople:(NSArray *)selectedPeople {
    return [self initWithSelectedPeople:selectedPeople unableSelectPeople:nil];
}

- (instancetype)initWithSelectedPeople:(NSArray *)selectedPeople unableSelectPeople:(NSArray *)unableSelectPeople {
    self = [super init];
    if (self) {
        if (!selectedPeople) selectedPeople         = @[];
        if (!unableSelectPeople) unableSelectPeople = @[];
        
        _arrayOriginalSelected = selectedPeople;
        _arrayUnableSelected = unableSelectPeople;
        [self handleFirstDatas:selectedPeople unUseDatas:unableSelectPeople];
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
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.naviVC.view.frame = self.contentView.bounds;
}

#pragma mark - Private Method
/** 初始化时处理数据 */
- (void)handleFirstDatas:(NSArray *)useData unUseDatas:(NSArray *)unUseData {
    _arrayOriginalSelected = useData;
    _arrayUnableSelected = unUseData;
}

- (void)createGroupWithUserIds:(NSArray *)userIds {
    [[MessageManager share] createGroupWithUserIds:userIds
                                        completion:^(UserProfileModel *groupProfile, BOOL isSuccess)
     {
         [self hideLoading];
		 
		 if (!isSuccess) {
			 [self postError:LOCAL(GROUP_CREATE_FAILURE)];
			 return;
		 }
		 
         [self dismissViewControllerAnimated:YES completion:^{
             
             AppDelegate *delegate = [UIApplication sharedApplication].delegate;
             HomeTabBarController *tabBarVC = (HomeTabBarController *)delegate.window.rootViewController;
             UINavigationController *naviVC = tabBarVC.selectedViewController;
             
             [naviVC wz_popToRootViewControllerAnimated:YES completion:^{
                 NSDictionary *dictContact = [NSDictionary dictionaryWithObjectsAndKeys:
                                              groupProfile.userName, @"UserProfile_userName",
                                              groupProfile.nickName, @"UserProfile_nickName",
                                              nil];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:MTWillShowGroupChatNotification object:nil userInfo:dictContact];
             }];
         }];
     }];
    
    [self postLoading];
}

- (void)createSingleChatWihtPersonModel:(ContactPersonDetailInformationModel *)model {
	NSDictionary *dictContact = [NSDictionary dictionaryWithObjectsAndKeys:
								 model.show_id, personDetail_show_id,
								 model.u_true_name, personDetail_u_true_name,
								 model.headPic, personDetail_headPic,
								 nil];
	[self dismissViewControllerAnimated:YES completion:^{
		[[NSNotificationCenter defaultCenter] postNotificationName:MTWillShowSingleChatNotification object:nil userInfo:dictContact];
	}];

}

#pragma mark - Interface Method
- (void)selectedPeople:(void (^)(NSArray *))selectedPeopleBlock {
    _selectedBlock = selectedPeopleBlock;
}

#pragma mark - Button Click
- (void)clickToDone:(NSArray *)selectedPeople {
	BOOL hasPeopleSelected = selectedPeople.count > 0;
	
    if (self.selectedBlock) {
        self.selectedBlock(selectedPeople);
    }
    
    NSMutableArray *arrayAnotherNameList = [NSMutableArray array];
    if (self.selectType != selectContact_none)
    {
        for (ContactPersonDetailInformationModel *model in selectedPeople)
        {
            [arrayAnotherNameList addObject:model.show_id];
        }
    }

    if (self.selectType == selectContact_createGroup)
    {
        if (arrayAnotherNameList.count == 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        // 1个人就单聊
        else if (arrayAnotherNameList.count == 1)
        {
            ContactPersonDetailInformationModel *model = [selectedPeople lastObject];
			[self createSingleChatWihtPersonModel:model];
			
			
		} else if (arrayAnotherNameList.count == 2 && self.currentUserID && [arrayAnotherNameList indexOfObject:self.currentUserID] != NSNotFound) {
			NSMutableArray *finalPeople = [selectedPeople mutableCopy];
			[finalPeople removeObjectAtIndex:[arrayAnotherNameList indexOfObject:self.currentUserID]];
			ContactPersonDetailInformationModel *model = [finalPeople lastObject];
			[self createSingleChatWihtPersonModel: model];
			
		} else
        {
            [self createGroupWithUserIds:arrayAnotherNameList];
        }

    }
    else if (self.selectType == selectContact_singleCreateGroup) {
        if (arrayAnotherNameList.count == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [self createGroupWithUserIds:arrayAnotherNameList];
        }
    }
    
    else if (self.selectType == selectContact_addPeople && hasPeopleSelected)
    {
        [[MessageManager share] groupSessionUid:self.groupID addUserIds:arrayAnotherNameList completion:^(BOOL isSuccess){
            if (isSuccess) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
			
			[self hideLoading];
        }];

        [self postLoading];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Initializer
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (BaseNavigationController *)naviVC {
    if (!_naviVC) {
        _naviVC = [[BaseNavigationController alloc] initWithRootViewController:self.containerVC];
    }
    return _naviVC;
}

- (SelectContactBookContainerViewController *)containerVC {
    if (!_containerVC) {
        _containerVC = [[SelectContactBookContainerViewController alloc] initWithSelectedPeople:self.arrayOriginalSelected unableSelectPeople:self.arrayUnableSelected tabbar:self.tabbar];
        _containerVC.singleSelectable = self.singleSelectable;
        _containerVC.selfSelectable = self.selfSelectable;
    }
    return _containerVC;
}

- (SelectContactTabbarView *)tabbar {
    if (!_tabbar) {
        __weak typeof(self) weakSelf = self;
        _tabbar = [[SelectContactTabbarView alloc] initWithSelectPeople:self.arrayOriginalSelected unableSelectPeople:self.arrayUnableSelected completion:^(NSArray *selectedPeople) {
			__strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf clickToDone:selectedPeople];
        }];
        _tabbar.singleSelectable = self.singleSelectable;
        _tabbar.selfSelectable = self.selfSelectable;
        _tabbar.isMission = self.isMission;
    }
        return _tabbar;
}

@end
