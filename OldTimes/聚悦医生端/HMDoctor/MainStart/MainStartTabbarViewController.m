//
//  MainStartTabbarViewController.m
//  HMDoctor
//
//  Created by yinquan on 16/4/9.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MainStartTabbarViewController.h"
#import "CoordinationStartViewController.h"
//#import "MainStartViewController.h"
#import "SecondEditMainStartViewController.h"
#import "PersonSpaceStartViewController.h"
#import "PatientStartViewController.h"
#import "ToolLibraryStartCollectionViewController.h"

#import "InitializeViewController.h"
#import "HMBaseNavigationViewController.h"

#import "MainTabbarView.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "ActionStatusManager.h"
#import "HMCoordinationMainViewController.h"
#import "ChatIMConfigure.h"
#import "AZMetaBallCanvas.h"
#import "IMMessageHandlingCenter.h"
#import "SESessionListMainViewController.h"
#import "IMPatientContactExtensionModel.h"
#import "SESessionListEnmu.h"

#define TABBARHIDDEN    @"hidden"
static NSInteger const kCountModule = 5; // 模块数

@interface MainStartTabbarViewController ()
<MainTabbarDelegate>
{
    MainTabbarView* mainTabbar;
}
@property (nonatomic,strong) NSMutableArray<HMBaseNavigationViewController *> *arrayNavi;
@property (nonatomic,strong) NSMutableArray<UITabBarItem *> *arrayItems;
@property (nonatomic, strong) AZMetaBallCanvas *patientAzMetaBallView;
@property (nonatomic, strong) AZMetaBallCanvas *workAzMetaBallView;
@end

@implementation MainStartTabbarViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.tabBar != nil) {
        [self.tabBar removeObserver:self forKeyPath:TABBARHIDDEN];
    }
    
    if ([IMMessageHandlingCenter sharedInstance] != nil) {
        [[IMMessageHandlingCenter sharedInstance] removeObserver:self forKeyPath:SESSIONSTATUS];
    }
    
    [self.patientAzMetaBallView removeFromSuperview];
    [self.workAzMetaBallView removeFromSuperview];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initTab];
    [self configNotifications];
    // 使用KVO 监听tabbar的状态
    [self.tabBar addObserver:self forKeyPath:TABBARHIDDEN options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    [[IMMessageHandlingCenter sharedInstance] addObserver:self forKeyPath:SESSIONSTATUS options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if ([InitializationHelper defaultHelper].initialized)
//    {
//        
//        return;
//    }
//    InitializeViewController* vcInit = [[InitializeViewController alloc]initWithNibName:nil bundle:nil];
//    [self.navigationController pushViewController:vcInit animated:NO];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //NSLog(@"%f", self.view.height);
    if (!mainTabbar)
    {
        //自定义Tabbar
        CGRect rtTabbar = self.tabBar.bounds;
        
        self.tabBar.tintColor = [UIColor whiteColor];
        self.tabBar.barTintColor = [UIColor whiteColor];
        
        mainTabbar = [[MainTabbarView alloc]initWithFrame:rtTabbar];
        [self.tabBar addSubview:mainTabbar];
        //[mainTabbar setBottom:self.view.bottom];
        [mainTabbar setDelegate:self];
//         一键退朝 动画view（罩住整个屏幕）
        UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;

        [keyWindow addSubview:self.patientAzMetaBallView];
        [keyWindow addSubview:self.workAzMetaBallView];
        
        // 一键退朝（用户）
        MainTabbarCell *tabcell1 = mainTabbar.tabbarCells[1];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptabbarSelectPatient)];
        [tabcell1.allUnReadCountLb addGestureRecognizer:tap];
        
        __weak typeof(self) weakSelf = self;
        [self.patientAzMetaBallView attach:tabcell1.allUnReadCountLb callBack:^(BOOL isDroped) {
            if (isDroped) {
                // 销毁了
                [weakSelf cleanPatientUnReadCount];
            }
            else {
                // 未销毁，刷新红点（防止在拖动过程中受到消息）
                [weakSelf showRedPointNotification];
            }
        }];
        
        // 一键退朝（工作组）
        MainTabbarCell *tabcell2 = mainTabbar.tabbarCells[2];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptabbarSelectWork)];
        [tabcell2.allUnReadCountLb addGestureRecognizer:tap1];
        
        [self.workAzMetaBallView attach:tabcell2.allUnReadCountLb callBack:^(BOOL isDroped) {
            if (isDroped) {
                // 销毁了
                [weakSelf cleanWorkUnReadCount];
            }
            else {
                // 未销毁，刷新红点（防止在拖动过程中受到消息）
                [weakSelf showRedPointNotification];
            }
            
        }];


    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
}
- (void) setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    [mainTabbar setSelectedIndex:selectedIndex];
}

#pragma mark - Private Method

- (void)initTab {
    SecondEditMainStartViewController* vcConsole = [[SecondEditMainStartViewController alloc]initWithNibName:nil bundle:nil];
    
    SESessionListMainViewController* vcPatients = [[SESessionListMainViewController alloc] initWithNibName:nil bundle:nil];
    
    HMCoordinationMainViewController* vcCoordination = [[HMCoordinationMainViewController alloc]initWithNibName:nil bundle:nil];
    
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
    ToolLibraryStartCollectionViewController* vcTools = [[ToolLibraryStartCollectionViewController alloc]initWithCollectionViewLayout:fl];
    
    PersonSpaceStartViewController* vcPersonSpace = [[PersonSpaceStartViewController alloc]init];
    
    NSArray *arrayVC = @[vcConsole, vcPatients, vcCoordination, vcTools, vcPersonSpace];
    
    for (UIViewController *vc in arrayVC) {
        // 主页模块
        HMBaseNavigationViewController *navi = [[HMBaseNavigationViewController alloc] initWithRootViewController:vc];
        [self.arrayNavi addObject:navi];
    }
    
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    
    
    [self setViewControllers:self.arrayNavi];

}

- (void)configNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRedPointNotification) name:MTBadgeCountChangedNotification object:nil];
}

- (void)taptabbarSelectPatient {
    [self setSelectedIndex:1];
}

- (void)taptabbarSelectWork {
    [self setSelectedIndex:2];
}
// 清除用户所有角标
- (void)cleanPatientUnReadCount {
    [[MessageManager share] sendReadedSessionRequestWithTag:@"DOCTOR_USER_GROUP" completion:^(BOOL success) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HMPATIENTCLEANALLUNREDESMESSAGESUCCESS object:nil];
    }];
}
// 清除工作组所有角标
- (void)cleanWorkUnReadCount {
    [[MessageManager share] queryMessageListWithoutTags:@[im_doctorPatientGroupTag] limit:-1 offset:0 completion:^(NSArray<ContactDetailModel *> *arrayList) {
        __block NSMutableArray *unReadList = [NSMutableArray array];
       [arrayList enumerateObjectsUsingBlock:^(ContactDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           if (obj._countUnread > 0) {
               [unReadList addObject:obj._target];
           }
       }];
        
        //会话角标批量清零
        [[MessageManager share]sendReadedSessionRequestWithSessionNameList:unReadList];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:HMWORKCLEANALLUNREDESMESSAGESUCCESS object:nil];

    }];
}

- (NSArray *)JWGetSelectedTypeList {
    UserInfo* user = [[UserInfoHelper defaultHelper] currentUserInfo];
    NSArray *typeList = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@-%ld",SESESSIONTYPELIST,user.userId]];
    return typeList;
}

- (NSInteger)getVariableUnreadCountWith:(NSArray *)arrayPatientArr {
    
    __block NSInteger unReadCount_GroupVIP = 0;
    __block NSInteger unReadCount_GroupMiddle = 0;
    __block NSInteger unReadCount_GroupCommon = 0;
    __block NSInteger unReadCount_PersonalPackage = 0;
    __block NSInteger unReadCount_PersonalFollow = 0;
    __block NSInteger unReadCount_PersonalSingle = 0;
    
    
    [arrayPatientArr enumerateObjectsUsingBlock:^(ContactDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IMPatientContactExtensionModel *tempModel  = [IMPatientContactExtensionModel mj_objectWithKeyValues:obj._extension.mj_JSONObject];
        
        if (tempModel.isBlocService == 1) {
            // 集团
            
            if (tempModel.blocRank == 3) {
                // 集团VIP
                unReadCount_GroupVIP += obj._countUnread;
            }
            else if ( tempModel.blocRank == 2) {
                // 集团中层
                unReadCount_GroupMiddle += obj._countUnread;
            }
            else if (tempModel.blocRank == 1) {
                // 集团普通
                unReadCount_GroupCommon += obj._countUnread;
                
            }
            
        }
        else if (tempModel.isBlocService == 0) {
            // 个人
            if (tempModel.classify == 2 || tempModel.classify == 4) {
                // 个人套餐
              
                unReadCount_PersonalPackage += obj._countUnread;
            }
            else if (tempModel.classify == 3) {
                // 个人免费
                
                unReadCount_PersonalFollow += obj._countUnread;
                
            }
            else if (tempModel.classify == 5) {
                // 个人单项
                
                unReadCount_PersonalSingle += obj._countUnread;
                
            }
            
        }
        
    }];
    
    NSArray *typeList = [self JWGetSelectedTypeList];

    NSInteger showCount = 0;
    if ([typeList containsObject:@(SESessionListType_GroupVIP)]) {
        showCount += unReadCount_GroupVIP;
    }
    
    if ([typeList containsObject:@(SESessionListType_GroupMiddle)]) {
        showCount += unReadCount_GroupMiddle;
    }
    
    if ([typeList containsObject:@(SESessionListType_GroupCommon)]) {
        showCount += unReadCount_GroupCommon;
    }
    if ([typeList containsObject:@(SESessionListType_PersonalPackage)]) {
        showCount += unReadCount_PersonalPackage;
    }
    if ([typeList containsObject:@(SESessionListType_PersonalFollow)]) {
        showCount += unReadCount_PersonalFollow;
    }
    if ([typeList containsObject:@(SESessionListType_PersonalSingle)]) {
        showCount += unReadCount_PersonalSingle;
    }
    
    return showCount;
}
#pragma mark - Delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    NSLog(@"selectedIndex %ld", self.selectedIndex);
    [self.navigationItem setTitle:item.title];
    
}

#pragma mark - RedPointNotification
// 红点提示
- (void)showRedPointNotification {
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] getMessageListCompletion:^(NSArray *arrayList) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (arrayList.count == 0) {
            return;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // 患者部分
            NSPredicate *predicatePatient = [NSPredicate predicateWithFormat:@"_tag = %@ AND _countUnread > 0",im_doctorPatientGroupTag];
            NSArray <ContactDetailModel *>*arrayPatient =[arrayList filteredArrayUsingPredicate:predicatePatient];
            
            __block NSInteger allUnreadCount = 0;
            allUnreadCount = [self getVariableUnreadCountWith:arrayPatient];
//            [arrayPatient enumerateObjectsUsingBlock:^(ContactDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                allUnreadCount += obj._countUnread;
//            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!strongSelf.patientAzMetaBallView.isMoving) {
                    [mainTabbar showRedPointAtIndex:1 withCount:allUnreadCount];
                }
                });
        });


        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // 工作组
            NSPredicate *predicateCoordination = [NSPredicate predicateWithFormat:@"_tag != %@ AND _countUnread > 0",im_doctorPatientGroupTag];
            NSArray *arrayCoordination =[arrayList filteredArrayUsingPredicate:predicateCoordination];
            
            __block NSInteger allUnreadCount = 0;
            [arrayCoordination enumerateObjectsUsingBlock:^(ContactDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                allUnreadCount += obj._countUnread;
            }];

            dispatch_async(dispatch_get_main_queue(), ^{
                if (!strongSelf.workAzMetaBallView.isMoving) {
                    [mainTabbar showRedPointAtIndex:2 withCount:allUnreadCount];
                }
            });
            
            
        });

    }];
    
    [[MessageManager share] queryAllUnreadMessageCountCompletion:^(NSInteger countUnreadMsg) {
        // 设置AppIcon未读角标设置
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:countUnreadMsg];
    }];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // tabbar隐藏状态
    if ([keyPath isEqualToString:TABBARHIDDEN]) {
        if ([change[@"new"] integerValue]) {
            // tabbar隐藏了
            [self.patientAzMetaBallView removeFromSuperview];
            [self.workAzMetaBallView removeFromSuperview];
        }
        else {
            // tabbar显示了
            UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;

            [keyWindow addSubview:self.patientAzMetaBallView];
            [keyWindow addSubview:self.workAzMetaBallView];
        }
    }
    // 会话状态
    if ([keyPath isEqualToString:SESSIONSTATUS]) {
        
        MainTabbarCell *tabcell1 = mainTabbar.tabbarCells[1];
        MainTabbarCell *tabcell2 = mainTabbar.tabbarCells[2];
        if ([change[@"new"] integerValue]) {
            [tabcell1.allUnReadCountLb setUserInteractionEnabled:NO];
            [tabcell2.allUnReadCountLb setUserInteractionEnabled:NO];

        }
        else {
            [tabcell1.allUnReadCountLb setUserInteractionEnabled:YES];
            [tabcell2.allUnReadCountLb setUserInteractionEnabled:YES];
        }

    }
}

#pragma mark - Init

- (NSMutableArray<HMBaseNavigationViewController *> *)arrayNavi {
    if (!_arrayNavi) {
        _arrayNavi = [[NSMutableArray alloc] initWithCapacity:kCountModule];
    }
    return _arrayNavi;
}

- (NSMutableArray<UITabBarItem *> *)arrayItems {
    if (!_arrayItems) {
        _arrayItems = [[NSMutableArray alloc] initWithCapacity:kCountModule];
    }
    return _arrayItems;
}

#pragma mark - MainTabbarDelegate
- (void) tabbarSelected:(NSInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex];
    //友盟统计部分
    if (UMSDK_isOn) {
        switch (selectedIndex) {
            case 0:
                [MobClick event:UMcustomEvent_EnterWorkingDeskVc];
                break;
            case 1:
                [MobClick event:UMCustomEvent_EnterPatientVc];
                break;
            case 2:
                [MobClick event:UMCustomEvent_EnetrWorkingGroupVc];
                break;
            case 3:
                [MobClick event:UMCustomEvent_EnterToolVc];
                break;
            case 4:
                [MobClick event:UMCustomEvent_EnterMeVc];
                break;
            default:
                break;
                
        }
    }
}
- (AZMetaBallCanvas *)patientAzMetaBallView {
    if (!_patientAzMetaBallView) {
        _patientAzMetaBallView = [[AZMetaBallCanvas alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        [_patientAzMetaBallView setBackgroundColor:[UIColor clearColor]];
        [_patientAzMetaBallView setUserInteractionEnabled:NO];
    }
    return _patientAzMetaBallView;
}

- (AZMetaBallCanvas *)workAzMetaBallView {
    if (!_workAzMetaBallView) {
        _workAzMetaBallView = [[AZMetaBallCanvas alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        [_workAzMetaBallView setBackgroundColor:[UIColor clearColor]];
        [_workAzMetaBallView setUserInteractionEnabled:NO];
    }
    return _workAzMetaBallView;
}

@end
