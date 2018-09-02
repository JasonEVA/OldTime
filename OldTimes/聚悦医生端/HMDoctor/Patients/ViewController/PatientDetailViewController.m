//
//  PatientDetailViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientDetailViewController.h"
#import "PatientInfo.h"
#import "UserAlertInfo.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "PatientGroupChatViewController.h"
#import "PatientEMRInfoViewController.h"
#import "HMThirdEditionPatientViewController.h"
#import "HealthPlanSummaryViewController.h"

#import "ATModuleInteractor+CoordinationInteractor.h"
#import "IMPatientContactExtensionModel.h"
#import "HMCheckPatientServiceManager.h"
#import "DAOFactory.h"

//
#import "HealthPlanMessionInfo.h"
#import "AppointmentInfo.h"
#import "UserAlertInfo.h"
#import "RoundsMessionModel.h"
#import "SurveyRecord.h"
#import "UIBarButtonItem+BackExtension.h"
#import "PatientDetailPromptView.h"
#import "GroupMessageHistoryViewController.h"

#import "HMThirdEditionPatitentInfoModel.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface PatientDetailViewController ()
<TaskObserver,UIPageViewControllerDelegate,UIPageViewControllerDataSource,UINavigationControllerDelegate>

@property (nonatomic, strong)  ContactDetailModel  *IMModel; // <##>
@property (nonatomic, copy)  NSString  *titleString; // <##>
@property (nonatomic, strong)  PatientInfo  *patientInfo; // <##>
@property (nonatomic, strong)  UIView  *segmentedHeaderView; // <##>
@property (nonatomic, strong)  UISegmentedControl  *segmentedControl; // <##>
@property (nonatomic, strong)  UIPageViewController  *pageViewController; // <##>
@property (nonatomic, strong)  HMThirdEditionPatientViewController  *baseInfoVC; // <##>
@property (nonatomic, strong)  PatientGroupChatViewController  *chatVC; // <##>
@property (nonatomic, strong)  PatientEMRInfoViewController  *EMRInfoVC; // <##>
@property (nonatomic, strong)  HealthPlanSummaryViewController* healthPlanSummaryVC;// 健康
@property (nonatomic, strong)  UIBarButtonItem  *historyMsgItem; // 历史按钮
@property (nonatomic, strong)  UIImageView  *imageFollow; // 关注按钮

@property (nonatomic, strong)  NSMutableArray  *arrayVC; // <##>
@property (nonatomic, strong)  HMBaseViewController  *chatPlaceholderVC; // <##>
@property (nonatomic, assign)  BOOL  hideInputView; // <##>

@property (nonatomic,strong) ArchivesDetailModel *jumpDetailModel;
@property (nonatomic, assign)  BOOL isJumpArchive;  //是否是档案详情跳转


@property (nonatomic, strong) PatientDetailNavigationView *navigationView;
@property (nonatomic, strong) PatientDetailPromptView *promptView;

@end

@implementation PatientDetailViewController

- (void)dealloc {
    
}
- (instancetype)initWithContactDetailModel:(ContactDetailModel *)model {
    self = [super init];
    if (self) {
        _IMModel = model;

        NSArray *array = [model._nickName componentsSeparatedByString:@"-"];
        _titleString = array.firstObject;
        if ([_titleString containsString:@"("]) {
            NSRange range = NSMakeRange(0, [_titleString rangeOfString:@"("].location);
            _titleString = [_titleString substringWithRange:range];
        }
        IMPatientContactExtensionModel *extension = [[IMPatientContactExtensionModel alloc] initWithExtensionJsonString:model._extension];
        if (extension.pId && extension.pId.length > 0) {
            _patientInfo = [PatientInfo new];
            self.patientInfo.userId = extension.pId.integerValue;
            self.patientInfo.userName = extension.pName;
            self.hideInputView = !extension.canChat;
        }
        // 获取用户信息
        [self p_requestPatientInfoWithIMTarget:model._target];
        
        [self p_getUserChatInfoWithUserId:nil imGroupId:_IMModel._target];

    }
    return self;
}

- (instancetype)initWithPatientInfo:(PatientInfo *)patientInfo {
    self = [super init];
    if (self) {
        _patientInfo = patientInfo;
        [self p_getUserChatInfoWithUserId:[NSString stringWithFormat:@"%ld",patientInfo.userId] imGroupId:nil];
        if (patientInfo.diseaseTitle.length > 0) {
            _titleString = [NSString stringWithFormat:@"%@(%@)",patientInfo.userName,patientInfo.diseaseTitle];
        }
        else {
            _titleString = patientInfo.userName;
            if (patientInfo.imGroupId) {
                // 获取用户信息
                [self p_requestPatientInfoWithIMTarget:patientInfo.imGroupId];
            }
        }
        
    }
    return self;
}

//预警、随访、查房、健康计划、约诊跳转
- (instancetype)initWithJumpInfo:(id)jumpInfo {
    self = [super init];
    if (self) {
        
        _jumpDetailModel = jumpInfo;
        _isJumpArchive = YES;

        if (_jumpDetailModel.userId) {
            _patientInfo = [PatientInfo new];
            self.patientInfo.userId = _jumpDetailModel.userId;
            self.patientInfo.userName = _jumpDetailModel.userName;
            
        }
        
        if (!kStringIsEmpty(_jumpDetailModel.mainIll)) {
            _titleString = [NSString stringWithFormat:@"%@(%@)",_jumpDetailModel.userName,_jumpDetailModel.mainIll];
        }
        else {
            _titleString = _jumpDetailModel.userName;
        }
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFd_prefersNavigationBarHidden:YES];
    self.fd_interactivePopDisabled = YES;
    // 禁用滑动返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        
    }
    
    
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
//    UIBarButtonItem *archiveItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_patient_file"] style:UIBarButtonItemStylePlain target:self action:@selector(p_historyMessage)];
//    self.historyMsgItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"patient_historyMsg"] style:UIBarButtonItemStylePlain target:self action:@selector(p_historyMessage)];
    //[self.navigationItem setRightBarButtonItems:@[self.historyMsgItem]];
    
//    [self.navigationItem setRightBarButtonItems:@[self.historyMsgItem,archiveItem]];
    
//    self.title = self.titleString;
    [self p_configElements];
    self.arrayVC = [@[self.baseInfoVC, self.chatVC, self.EMRInfoVC, self.healthPlanSummaryVC] mutableCopy];
    if (_isJumpArchive) {
        //档案详情跳转，进入基本信息页面

        [self.pageViewController setViewControllers:@[self.arrayVC[self.segmentedIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        if (self.baseInfoVC.needRequestUserInfo) {
            [self.baseInfoVC reloadPatientInfoWithUserID:[NSString stringWithFormat:@"%ld",self.patientInfo.userId]];
        }
        
        //禁止滑动
        for (UIView *view in self.pageViewController.view.subviews ) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                UIScrollView *scroll = (UIScrollView *)view;
                scroll.bounces = NO;
                scroll.scrollEnabled = NO;
            }
        }
    }
    else{
        //从患者跳转
        [self.pageViewController setViewControllers:@[self.chatVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    // 异步加载健康记录和基础信息VC
//    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(globalQueue, ^{

    [self p_addVC];

//    });
    
    [self p_configBarItemWithPatientID:self.patientInfo.userId];
    
    //第一次进入在院档案按钮引导
    [self showArchivePrompt];
    // 设置导航控制器的代理为self
//    self.navigationController.delegate = self;
    
    if (kStringIsEmpty(self.patientInfo.userName))
    {
        [self startPatientInfoRequest];
    }
}

- (void)startPatientInfoRequest {
    //获取患者的信息
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",self.patientInfo.userId] forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMThirdEditionPatitentInfoRequest" taskParam:dicPost TaskObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *vc = [self.navigationController.viewControllers lastObject];
        if (!vc.fd_prefersNavigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    });
}

#pragma mark - Event Response
#pragma mark -- Button Click
- (void)backBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)archiveBtnClick:(UIButton *)sender
{
    [HMViewControllerManager createViewControllerWithControllerName:@"HMOnlineArchivesViewController" ControllerObject:[NSString stringWithFormat:@"%ld",self.patientInfo.userId]] ;
}

// 关注事件
- (void)p_followAction {
    //__weak typeof(self) weakSelf = self;
    [_DAO.patientInfoListDAO queryPatientInfoWithPatientID:self.patientInfo.userId completion:^(NewPatientListInfoModel *model) {
        //__strong typeof(weakSelf) strongSelf = weakSelf;
        BOOL willFollow = model.attentionStatus == 1 ? NO : YES;
        [_DAO.patientInfoListDAO updatePatientFollowStatus:willFollow patientID:model.userId completion:^(BOOL requestSuccess, NSString *errorMsg) {
            if (!requestSuccess) {
                return;
            }
            [UIView animateWithDuration:0.14 animations:^{
//               [strongSelf.imageFollow setTransform:CGAffineTransformMakeScale(1, 1.2)];
                [_navigationView.followBtn setTransform:CGAffineTransformMakeScale(1, 1.2)];
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.1 animations:^{
//                        [strongSelf.imageFollow setImage:[UIImage imageNamed:willFollow ? @"icon_care" : @"icon_nocare"]];
//                        [strongSelf.imageFollow setTransform:CGAffineTransformMakeScale(1, 1)];
                        [_navigationView.followBtn setImage:[UIImage imageNamed:willFollow ? @"icon_care" : @"icon_nocare"] forState:UIControlStateNormal];
                        [_navigationView.followBtn setTransform:CGAffineTransformMakeScale(1, 1)];
                    }];
                }
            }];

        }];

    }];
}

// 历史记录
- (void)p_historyMessage {
    if (self.IMModel._target) {
        [HMViewControllerManager createViewControllerWithControllerName:@"GroupMessageHistoryViewController" ControllerObject:@[self.IMModel._target,[NSString stringWithFormat:@"%ld",(long)self.patientInfo.userId]]] ;
    }
}

- (void)p_segmentedViewClicked:(UISegmentedControl *)segmentedControl {
    switch (segmentedControl.selectedSegmentIndex) {
        case PatientDetailSegmentedIndexBaseInfo: {
            //
            [self.pageViewController setViewControllers:@[self.baseInfoVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
            if (self.baseInfoVC.needRequestUserInfo) {
                [self.baseInfoVC reloadPatientInfoWithUserID:[NSString stringWithFormat:@"%ld",self.patientInfo.userId]];
            }
            break;
        }
        case PatientDetailSegmentedIndexChatMessage: {
            //
            if (_isJumpArchive) {
                [self p_getUserChatInfoWithUserId:[NSString stringWithFormat:@"%ld",_jumpDetailModel.userId] imGroupId:nil];
                // 跳转聊天列表
                //[self p_showChatVCWithUID:_messionInfo.imGroupId];
            }
            else{
                UIPageViewControllerNavigationDirection direction;
                if (self.pageViewController.viewControllers.firstObject == self.baseInfoVC) {
                    direction = UIPageViewControllerNavigationDirectionForward;
                }
                else if (self.pageViewController.viewControllers.firstObject == self.EMRInfoVC) {
                    direction = UIPageViewControllerNavigationDirectionReverse;
                }
                [self.pageViewController setViewControllers:@[self.chatVC] direction:direction animated:YES completion:nil];
            }

            break;
        }
        case PatientDetailSegmentedIndexEMR: {
            //
//            [self.pageViewController setViewControllers:@[self.EMRInfoVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            UIViewController* curVC = self.pageViewController.viewControllers.firstObject;
            NSInteger index = [self.arrayVC indexOfObject:curVC];
            if (index < PatientDetailSegmentedIndexEMR) {
                [self.pageViewController setViewControllers:@[self.EMRInfoVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            }
            else if(index > PatientDetailSegmentedIndexEMR)
            {
                [self.pageViewController setViewControllers:@[self.EMRInfoVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
            }
            
            
            if (self.EMRInfoVC.needRequestEMRInfo) {
                [self.EMRInfoVC reloadEMRInfoWithUserID:[NSString stringWithFormat:@"%ld",self.patientInfo.userId]];
            }

            break;
        }
        case PatientDetailSegmentedIndexHealthPlan:
        {
            [self.pageViewController setViewControllers:@[self.healthPlanSummaryVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            break;
        }
    }
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // 判断要显示的控制器是否是自己
//    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
//    
//    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
//}

#pragma mark - Private Method
//在院档案提示框
- (void)showArchivePrompt
{
    //从制定计划跳转，不提示在院档案
    if (_formulatePlan) {
        return;
    }
    if (!kStringIsEmpty([[NSUserDefaults standardUserDefaults] valueForKey:@"FirstEnterArchive"])) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"FirstEnterArchive" forKey:@"FirstEnterArchive"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self.promptView setFrame:window.bounds];
    [window addSubview:self.promptView];
}

// 设置导航栏元素
- (void)p_configBarItemWithPatientID:(NSInteger)patientID {
    if (patientID <= 0 || !self.viewLoaded) {
        return;
    }
    //__weak typeof(self) weakSelf = self;
    [_DAO.patientInfoListDAO queryPatientInfoWithPatientID:patientID completion:^(NewPatientListInfoModel *model) {
        //__strong typeof(weakSelf) strongSelf = weakSelf;
        if (!model) {
            return;
        }
        BOOL follow = model.attentionStatus == 1 ? YES : NO;
        
        [_navigationView.followBtn setImage:[UIImage imageNamed:follow ? @"icon_care" : @"icon_nocare"] forState:UIControlStateNormal];
        
//        strongSelf.imageFollow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:follow ? @"icon_care" : @"icon_nocare"]];
//        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:strongSelf action:@selector(p_followAction)];
//        [strongSelf.imageFollow addGestureRecognizer:gesture];
//
//        UIBarButtonItem *itemFollow  = [[UIBarButtonItem alloc] initWithCustomView:strongSelf.imageFollow];
//        [strongSelf.navigationItem setLeftBarButtonItems:@[itemFollow]];
    }];

}


// 设置元素控件
- (void)p_configElements {
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1) cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self.view addSubview:self.navigationView];
    _navigationView.titleLabel.text = self.titleString;
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(@64);
    }];
    
    [self.view addSubview:self.segmentedHeaderView];
    [self.segmentedHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_navigationView.mas_bottom);
        make.height.mas_equalTo(39);
    }];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.segmentedHeaderView.mas_bottom);
    }];
    [self.pageViewController didMoveToParentViewController:self];
 
}

// 获取患者信息
- (void)p_requestPatientInfoWithIMTarget:(NSString *)target {
    if (!target || target.length == 0) {
        return;
    }
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:target forKey:@"imGroupId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserByImGroupIdTask" taskParam:dicPost TaskObserver:self];
}

- (void)p_showChatVCWithUID:(NSString *)uid {
    if (!uid) {
        return;
    }
    // 查询会话信息创建患者会话界面
    ContactDetailModel *contactModel = [[MessageManager share] querySessionDataWithUid:uid];
    if (!contactModel) {
        contactModel = [ContactDetailModel new];
        contactModel._target = uid;
        UserProfileModel *profileModel = [[MessageManager share] queryContactProfileWithUid:uid];
        if (profileModel) {
            contactModel._extension = profileModel.extension;
        }
    }
    IMPatientContactExtensionModel *extension = [[IMPatientContactExtensionModel alloc] initWithExtensionJsonString:contactModel._extension];
    if (extension.pId && extension.pId.length > 0) {
        self.hideInputView = !extension.canChat;
    }
    self.IMModel = contactModel;
    [self.pageViewController setViewControllers:@[self.chatVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

// 获取患者服务
- (void)p_requestPatientTeamServiceWithUserID:(NSString *)userID {
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:userID forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceStaffTeamTask" taskParam:dicPost TaskObserver:self];
}

// 获取会话ID
- (void)p_requestPatientChatIDWithUserID:(NSString *)userID teamID:(NSString *)teamID {
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:userID forKey:@"userId"];
    [dicPost setValue:teamID forKey:@"teamId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"TeamImGroupIdTask" taskParam:dicPost TaskObserver:self];
}

//检查用户是否有聊天权限
- (void)p_checkPatientServiceWithUserId:(NSString *)userId {
    if (!userId || userId.length == 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[HMCheckPatientServiceManager shareManager] checkPatientServiceWithUserId:userId completion:^(PatientServiceStatus serviceStatus, NSArray *privilegeArray, BOOL success) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (success) {
            if ([privilegeArray containsObject:@(PatientPrivilege_TWZX)] && serviceStatus == PatientServiceStatus_YES) {
                strongSelf.hideInputView = NO;
                if ([strongSelf.chatVC isKindOfClass:[PatientGroupChatViewController class]]) {
                    [strongSelf.chatVC patientGroupHideChatInputView:NO];
                }
            }
            else {
                strongSelf.hideInputView = YES;
                if ([strongSelf.chatVC isKindOfClass:[PatientGroupChatViewController class]]) {
                    [strongSelf.chatVC patientGroupHideChatInputView:YES];
                }
            }
        }
        else {
            ATLog(@"获取用户权限失败");
            return;
        }
    }];
}

- (void)p_getUserChatInfoWithUserId:(NSString *)userId imGroupId:(NSString *)imGroupId{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    if (imGroupId && imGroupId.length) {
        dict[@"imGroupId"] = imGroupId;
    }
    else {
        dict[@"userId"] = userId;
        StaffInfo *user = [UserInfoHelper defaultHelper].currentStaffInfo;
        dict[@"staffId"] = @(user.staffId);
    }
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMGetUserChatInfoRequest" taskParam:dict TaskObserver:self];
}

- (void)p_addVC {
    
    if (!self.baseInfoVC) {
        self.baseInfoVC = [[HMThirdEditionPatientViewController alloc] init];
    }
   
    
    if (!self.chatVC) {
        
        if (!self.IMModel) {
            self.chatVC = (PatientGroupChatViewController *)self.chatPlaceholderVC;
        }
        else {
            self.chatVC = [[PatientGroupChatViewController alloc] initWithDetailModel:self.IMModel];
            [self.chatVC hideChatInputView:self.hideInputView];
            self.chatVC.showServiceEnd = self.hideInputView;
            self.chatVC.chatType = IMChatTypePatientChat;
            [self.chatVC configPatientInfo:self.patientInfo];
            self.chatPlaceholderVC = nil;
        }
    }
    
    if (!self.EMRInfoVC) {
        self.EMRInfoVC = [[PatientEMRInfoViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",self.patientInfo.userId]];
    }
    
    self.arrayVC = [NSMutableArray arrayWithArray:@[self.baseInfoVC,self.chatVC,self.EMRInfoVC, self.healthPlanSummaryVC]];
    
}

#pragma mark - PageViewControllerDataSource && Delegate
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
//    NSInteger index = [self.arrayVC indexOfObject:viewController];
//    if (index > 0) {
//        return self.arrayVC[index - 1];
//    }
//    return nil;
//}
//
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
//    NSInteger index = [self.arrayVC indexOfObject:viewController];
//    if (index < self.arrayVC.count - 1) {
//        return self.arrayVC[index + 1];
//    }
//    return nil;
//}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    NSInteger index = [self.arrayVC indexOfObject:pageViewController.viewControllers.firstObject];
    self.segmentedControl.selectedSegmentIndex = index;
//    [self p_segmentedViewClicked:self.segmentedControl];
}

//- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
//    NSInteger index = [self.arrayVC indexOfObject:pageViewController.viewControllers.firstObject];
//    self.segmentedControl.selectedSegmentIndex = index;
//    [self p_segmentedViewClicked:self.segmentedControl];
//}


#pragma mark - TaskObserver

- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError) {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length) {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    if ([taskname isEqualToString:@"UserByImGroupIdTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[PatientInfo class]])
        {
            //跳转到患者详情界面
            PatientInfo* patientInfo = (PatientInfo*) taskResult;
            self.patientInfo = patientInfo;
            if (!patientInfo.userId||patientInfo.userId <= 0) {
                ATLog(@"userId为空");
            }
            // 设置导航栏按钮
            if (patientInfo.diseaseTitle && patientInfo.diseaseTitle.length > 0) {
                _navigationView.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",patientInfo.userName,patientInfo.diseaseTitle];
            }
            else {
                _navigationView.titleLabel.text = patientInfo.userName ?:self.titleString;
            }
//            if (self.chatVC) {
//                [self.chatVC configPatientInfo:self.patientInfo];
//            }

            [self p_configBarItemWithPatientID:self.patientInfo.userId];

            if (self.segmentedControl.selectedSegmentIndex == PatientDetailSegmentedIndexEMR) {
                [self.EMRInfoVC reloadEMRInfoWithUserID:[NSString stringWithFormat:@"%ld",self.patientInfo.userId]];
            }
            
            if (self.segmentedControl.selectedSegmentIndex == PatientDetailSegmentedIndexBaseInfo) {
                [self.baseInfoVC reloadPatientInfoWithUserID:[NSString stringWithFormat:@"%ld",self.patientInfo.userId]];
            }

        }
    }
    else if ([taskname isEqualToString:@"ServiceStaffTeamTask"]) {
        NSDictionary* dicResult = (NSDictionary*) taskResult;
        NSNumber* numTeamId = [dicResult valueForKey:@"teamId"];
        [self p_requestPatientChatIDWithUserID:[NSString stringWithFormat:@"%ld",self.patientInfo.userId] teamID:[NSString stringWithFormat:@"%ld",numTeamId.integerValue]];
    }
    else if ([taskname isEqualToString:@"TeamImGroupIdTask"]) {
        if (taskResult && [taskResult isKindOfClass:[NSString class]]) {
            NSString *targetID = (NSString*) taskResult;
            // 查询会话信息创建患者会话界面
            __weak typeof(self) weakSelf = self;
            [[MessageManager share] querySessionDataWithUid:targetID completion:^(ContactDetailModel * contactModel)
             {
                 __strong typeof(weakSelf) strongSelf = weakSelf;
                 if (!contactModel)
                 {
                     contactModel = [ContactDetailModel new];
                     contactModel._target = targetID;
                 }
                 strongSelf.IMModel = contactModel;
                 [strongSelf p_checkPatientServiceWithUserId:[NSString stringWithFormat:@"%ld",strongSelf.patientInfo.userId]];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [strongSelf p_addVC];
                     [strongSelf.pageViewController setViewControllers:@[strongSelf.chatVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
                 });
             }];
        }
    }
    else if ([taskname isEqualToString:@"HMGetUserChatInfoRequest"]) {
        // 获取IMGroupId和聊天权限
        NSDictionary *dict = (NSDictionary *)taskResult;
        NSString *IMGroupId = dict[@"imGroupId"];
        NSInteger canChat = [dict[@"canChat"] integerValue];
        
        if (!IMGroupId || !IMGroupId.length) {
            return;
        }
        __weak typeof(self) weakSelf = self;
        [[MessageManager share] querySessionDataWithUid:IMGroupId completion:^(ContactDetailModel * contactModel)
         {
             __strong typeof(weakSelf) strongSelf = weakSelf;
             if (!contactModel)
             {
                 contactModel = [ContactDetailModel new];
                 contactModel._target = IMGroupId;
             }
             strongSelf.IMModel = contactModel;
             [strongSelf.healthPlanSummaryVC setGroupId:IMGroupId];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [strongSelf p_addVC];
                 [strongSelf.pageViewController setViewControllers:@[strongSelf.chatVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
                 
                 strongSelf.hideInputView = !canChat;
                 if (strongSelf.chatVC && [strongSelf.chatVC isKindOfClass:[PatientGroupChatViewController class]]) {
                     [strongSelf.chatVC patientGroupHideChatInputView:!canChat];
                 }
             });
             
            

         }];


    }
    else if ([taskname isEqualToString:@"HMThirdEditionPatitentInfoRequest"]){
            HMThirdEditionPatitentInfoModel *model = (HMThirdEditionPatitentInfoModel *)taskResult;
            _navigationView.titleLabel.text = [NSString stringWithFormat:@"%@",model.userInfo.userName];
            self.patientInfo.userName = model.userInfo.userName;
//            self.patientInfo.userName = model.userInfo.userName;
//        
//            [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ (%@, %ld)", model.userInfo.userName, model.userInfo.sex, model.userInfo.age]];
        
    }

}


//YinQ
- (void) setSegmentedIndex:(PatientDetailSegmentedIndex)segmentedIndex
{
    _segmentedIndex = segmentedIndex;
    
    if (!self.arrayVC || self.arrayVC.count == 0) {
        return;
    }
    
    [self.segmentedControl setSelectedSegmentIndex:segmentedIndex];
    
    UIViewController* curVC = self.pageViewController.viewControllers.firstObject;
    UIViewController* targetViewController = self.arrayVC[segmentedIndex];
    
    NSInteger index = [self.arrayVC indexOfObject:curVC];
    if (index < segmentedIndex) {
        [self.pageViewController setViewControllers:@[targetViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    else if(index > segmentedIndex)
    {
        [self.pageViewController setViewControllers:@[targetViewController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }

   
}



- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    //    return UIStatusBarStyleDefault;
}

#pragma mark - Init

- (UIView *)segmentedHeaderView {
    if (!_segmentedHeaderView) {
        _segmentedHeaderView = [UIView new];
        _segmentedHeaderView.backgroundColor = [UIColor mainThemeColor];
        NSArray *items = @[@"基础信息", @"会话消息", @"健康记录", @"健康计划"];
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        if (_isJumpArchive) {
//            _segmentedControl.selectedSegmentIndex = PatientDetailSegmentedIndexBaseInfo;
            _segmentedControl.selectedSegmentIndex = self.segmentedIndex;
        }
        else{
            _segmentedControl.selectedSegmentIndex = PatientDetailSegmentedIndexChatMessage;
        }
        
        
        _segmentedControl.tintColor = [UIColor whiteColor];
        [_segmentedControl addTarget:self action:@selector(p_segmentedViewClicked:) forControlEvents:UIControlEventValueChanged];
        [_segmentedHeaderView addSubview:_segmentedControl];
        [_segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_segmentedHeaderView);
            make.width.equalTo(_segmentedHeaderView).offset(-30);
//            make.width.mas_equalTo(251);
        }];
    }
    return _segmentedHeaderView;
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
    }
    return _pageViewController;
}

- (HMThirdEditionPatientViewController *)baseInfoVC {
    if (!_baseInfoVC) {
        _baseInfoVC = [[HMThirdEditionPatientViewController alloc] init];
    }
    return _baseInfoVC;
}

- (PatientGroupChatViewController *)chatVC {
    if (!self.IMModel) {
        return (PatientGroupChatViewController *)self.chatPlaceholderVC;
    }
    if (!_chatVC) {
        _chatVC = [[PatientGroupChatViewController alloc] initWithDetailModel:self.IMModel];
        [_chatVC hideChatInputView:self.hideInputView];
        _chatVC.showServiceEnd = self.hideInputView;
        _chatVC.chatType = IMChatTypePatientChat;
        [_chatVC configPatientInfo:self.patientInfo];
        _chatPlaceholderVC = nil;
    }
    return _chatVC;
}

- (HealthPlanSummaryViewController*) healthPlanSummaryVC
{
    if (!_healthPlanSummaryVC) {
        _healthPlanSummaryVC = [[HealthPlanSummaryViewController alloc] initWithUserId:self.patientInfo.userId];
        [_healthPlanSummaryVC setFormulatePlan:self.formulatePlan];
        
        if (_IMModel && _IMModel._target && _IMModel._target.length > 0) {
            [_healthPlanSummaryVC setGroupId:_IMModel._target];
        }
        if (self.jumpDetailModel.healthyId > 0) {
            [_healthPlanSummaryVC setHealthyPlanId:[NSString stringWithFormat:@"%ld", self.jumpDetailModel.healthyId]];
        }
    
    }
    return _healthPlanSummaryVC;
}

- (PatientEMRInfoViewController *)EMRInfoVC {
    if (!_EMRInfoVC) {
        _EMRInfoVC = [[PatientEMRInfoViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",self.patientInfo.userId]];
    }
    return _EMRInfoVC;
}

- (HMBaseViewController *)chatPlaceholderVC {
    if (!_chatPlaceholderVC) {
        _chatPlaceholderVC = [HMBaseViewController new];
    }
    return _chatPlaceholderVC;
}

- (PatientDetailPromptView *)promptView{
    if (!_promptView) {
        _promptView = [PatientDetailPromptView new];
    }
    return _promptView;
}

- (PatientDetailNavigationView *)navigationView{
    if (!_navigationView) {
        _navigationView = [PatientDetailNavigationView new];
        [_navigationView.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navigationView.followBtn addTarget:self action:@selector(p_followAction) forControlEvents:UIControlEventTouchUpInside];
        [_navigationView.historyMsgBtn addTarget:self action:@selector(p_historyMessage) forControlEvents:UIControlEventTouchUpInside];
        [_navigationView.archiveBtn addTarget:self action:@selector(archiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navigationView;
}

- (NSMutableArray *)arrayVC {
    if (!_arrayVC) {
        _arrayVC = [NSMutableArray array];
    }
    return _arrayVC;
}
@end
