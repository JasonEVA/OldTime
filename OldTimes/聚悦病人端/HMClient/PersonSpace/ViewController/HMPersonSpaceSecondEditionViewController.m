//
//  HMPersonSpaceSecondEditionViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/4/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMPersonSpaceSecondEditionViewController.h"
#import "UINavigationBar+JWGradient.h"
#import "ATModuleInteractor+NewSiteMessage.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "HMSEPersonSpaceCollectionTableViewCell.h"
#import "GetOnlineCustomServiceTask.h"
#import "OnlineCustomServiceModel.h"
#import "ChatSingleViewController.h"
#import "InitializationHelper.h"
#import "HMConsultingRecordsViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "PointRedemptionWeeklyControl.h"
#import "AttendanceSummaryModel.h"
#import "AttendanceCalendarViewController.h"

#import "SEPersonSpaceStartTableViewCell.h"
#import "SEPersonSpaceInventFriendViewController.h"

#import "PersonCommitIDCardViewController.h"

#import "IntegralModel.h"

#define HEADICONHEIGHT            40        //头像大小
#define NAVBAR_CHANGE_POINT       0
#define TOPVIEWHEIGHT             200
@interface HMPersonSpaceSecondEditionViewController ()<UITableViewDelegate, UITableViewDataSource,TaskObserver,HMSEPersonSpaceCollectionTableViewCellDelegate>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *headIconView;
@property (nonatomic, strong) UIImageView *headLevelImageView;  //积分等级图标 YinQ
@property (nonatomic, strong) UILabel *userNamelb;
@property (nonatomic, strong) UIButton* identificationButton;   //身份证认证按钮

@property (nonatomic, strong) UIView* signedView;   //签到部分 added by YinQ
@property (nonatomic, strong) PointRedemptionWeeklyControl* pointWeeklyControl;
@property (nonatomic, strong) UIButton* signButton;
@property (nonatomic, strong) UILabel* signedLabel;
@property (nonatomic, strong) UILabel* signPointLabel;

@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) UILabel *moveUserNameLb;     // 移动useranme 动画
@property (nonatomic) CGFloat lastTableViewOffset;         // 用于记录上一次滑动
@property (nonatomic) CGPoint moveLbLocation;              // 记录moveUserNameLb位置
@property (nonatomic, strong) UIView *redPoint;

@property (nonatomic, strong) UILabel *groupUserNameLb;    // 集团用户lb
@property (nonatomic, strong) UIView *topNavView;
@property (nonatomic, strong) UILabel *titelLb;
@end


@implementation HMPersonSpaceSecondEditionViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFd_prefersNavigationBarHidden:YES];

    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    [self.navigationItem setTitle:curUser.userName];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ffffff"],NSFontAttributeName:[UIFont boldFont_36]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    [self configElements];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageListCountAction) name:MTBadgeCountChangedNotification object:nil];
    [self getMessageListCountAction];
    // Do any additional setup after loading the view.
    
    [self.pointWeeklyControl setContinuityDays:0 lastPointDate:nil];
    [self.signedLabel setText:[NSString stringWithFormat:@"已连续签到0天，累计获得积分0"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
//    [self.moveUserNameLb setText:curUser.userName];
    [self.userNamelb setText:curUser.userName];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSURL *url = [NSURL URLWithString:curUser.imgUrl];
        [self.headIconView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_default_photo"]];
    });
    
    [self loadAttendanceInfo];
    [self loadIntegralSummary];
    
    [self.identificationButton setEnabled:!(curUser.idCard && curUser.idCard.length >= 15)];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.tableView setDelegate:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView setDelegate:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取签到信息
- (void) loadAttendanceInfo
{
    //PointRedemptionContinuationTask
    NSMutableDictionary* postDictionary = [NSMutableDictionary dictionary];
    UserInfo* currentUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [postDictionary setValue:@1 forKey:@"type"];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld", currentUser.userId] forKey:@"userId"];    
    [[TaskManager shareInstance] createTaskWithTaskName:@"PointRedemptionContinuationTask" taskParam:postDictionary TaskObserver:self];
}

- (void) loadIntegralSummary
{
    //IntegralSummaryTask
    [[TaskManager shareInstance] createTaskWithTaskName:@"IntegralSummaryTask" taskParam:nil TaskObserver:self];
}

#pragma mark -private method

- (void)configElements {
    [self.view addSubview:self.tableView];

    [self.view addSubview:self.topNavView];
    
    [self.topNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    
    [self.pointWeeklyControl addTarget:self action:@selector(pointWeeklyControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.identificationButton addTarget:self action:@selector(identificationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.signButton addTarget:self action:@selector(signButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SEMainStartic_tongzhi2"]];
    [rightImage setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoMessageVcAction)];
    [rightImage addGestureRecognizer:tap];
    
    
    
    UIImageView * rightImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_ic_sz"]];
    [rightImage2 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingButtonClicked)];
    
    [rightImage2 addGestureRecognizer:tap2];
    
    [self.view addSubview:rightImage];
    [self.view addSubview:rightImage2];
    
    
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topNavView).offset(-10);
        make.top.equalTo(self.topNavView).offset(28);
    }];
    
    [rightImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightImage.mas_left).offset(-18);
        make.centerY.equalTo(rightImage);
    }];
    
    [rightImage addSubview:self.redPoint];
    
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightImage.mas_right).offset(-3);
        make.centerY.equalTo(rightImage.mas_top).offset(3);
        make.width.height.equalTo(@12);
    }];
    
    self.titelLb = [UILabel new];
    [self.titelLb setFont:[UIFont boldFont_36]];
    [self.titelLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
    
    [self.view addSubview:self.titelLb];
    
    [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(rightImage2);
    }];


    self.lastTableViewOffset = -20;
//    [self.view addSubview:self.moveUserNameLb];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(-20);
    }];
//    [self.moveUserNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.view.mas_top).offset(22 + 20 - ![self isGroupUser]?:10);
//        make.left.equalTo(self.view).offset(15+40+15);
//    }];
}

// 检查是否为集团用户
- (BOOL)isGroupUser {
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    if (curUser.blocName && curUser.blocName.length) {
        // 集团用户
        return YES;
    }
    else {
        // 非集团用户
        return NO;
    }
}

- (SEPersonSpaceType)acquireTypeWithIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section * 10 + indexPath.row;
}

// 获取客服列表
- (void)loadOnlineCustomServiceList {
    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetOnlineCustomServiceTask class]) taskParam:nil TaskObserver:self];
}

- (BOOL) userHasService
{
    InitializationHelper* helper = [InitializationHelper defaultHelper];
    if (helper.userHasService) {
        return YES;
    }
    return NO;
}

- (void) signObtainPoint:(NSInteger) point
{
    [self.signPointLabel setText:[NSString stringWithFormat:@"+%ld", point]];
    
    [self.signButton setTitle:@"" forState:UIControlStateDisabled];
    [self.signButton setEnabled:NO];
    [UIView animateWithDuration:0.7 animations:^{
        self.signButton.layer.transform=CATransform3DMakeRotation(M_PI, 1, 0, 0);
//        [self.signButton setTitle:@"" forState:UIControlStateNormal];
        
        
    } completion:^(BOOL finished) {
        self.signButton.layer.transform=CATransform3DMakeRotation(0, 1, 0, 0);
        [self signPointAnimeHandle];
    }];

    [self.signPointLabel setHidden:NO];
    
    [UIView animateWithDuration:1.5 delay:0.2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        CGPoint center = self.signPointLabel.center;
        center.y -= 25;
        self.signPointLabel.center = center;
        
    } completion:^(BOOL finished) {
        
        
        [self.signPointLabel setHidden:YES];
    }];
}

- (void) signPointAnimeHandle
{
    [UIView animateWithDuration:0.7 animations:^{
        self.signButton.layer.transform=CATransform3DMakeRotation(M_PI, 1, 0, 0);

        
        
        
    } completion:^(BOOL finished) {
        [self.signButton setEnabled:NO];
        [self.signButton setTitle:@"已签到" forState:UIControlStateDisabled];

        self.signButton.layer.transform=CATransform3DMakeRotation(0, 1, 0, 0);

    }];
    
    
}

#pragma mark - event Response

- (void) pointWeeklyControlClicked:(id) sender
{
    //签到日历
    [AttendanceCalendarViewController show];
}


//签到按钮
- (void) signButtonClicked:(id) sender
{
//    [self signObtainPoint:5]; return;
    NSMutableDictionary* postDictionary = [NSMutableDictionary dictionary];
    UserInfo* currentUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [postDictionary setValue:@1 forKey:@"type"];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld", currentUser.userId] forKey:@"userId"];

    [[TaskManager shareInstance] createTaskWithTaskName:@"AddPointRedemptionTask" taskParam:postDictionary TaskObserver:self];
}

- (void) identificationButtonClicked:(id) sender
{
    __weak typeof(self) weakSelf = self;
    [PersonCommitIDCardViewController showWithHandleBlock:^{
        //重新设置是否已经身份认证
        UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
        [weakSelf.identificationButton setEnabled:!(curUser.idCard && curUser.idCard.length >= 15)];
    }];
}

// 进入站内信
- (void)gotoMessageVcAction
{
    [[ATModuleInteractor sharedInstance] gotoNewSiteMessageMainListVC];
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:[NSString stringWithFormat:@"站内信"]];
}
// 进入设置
- (void)settingButtonClicked
{
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－设置"];
    [HMViewControllerManager createViewControllerWithControllerName:@"PersonSettingStartViewController" ControllerObject:nil];
}
- (void)getMessageListCountAction
{
    //获取推送类型的session，根据未读数判断红点显示
    [[MessageManager share] querySessionDataWithUid:@"PUSH@SYS" completion:^(ContactDetailModel *model) {
        [self.redPoint setHidden:!model._countUnread];
    }];
}
#pragma mark - HMSEPersonSpaceCollectionTableViewCellDelegate
- (void)HMSEPersonSpaceCollectionTableViewCellDelegateCallBack_CollectType:(SEPersonSpaceCollectionType)type {
    switch (type) {
        case SEPersonSpaceCollectionType_MyOrder:
        {// 我的订单
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－我的订单"];
            [HMViewControllerManager createViewControllerWithControllerName:@"OrderListStartViewController" ControllerObject:nil];
            break;
        }
        case SEPersonSpaceCollectionType_MyService:
        {// 我的服务
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－我的服务"];
            [HMViewControllerManager createViewControllerWithControllerName:@"PersonServicesStartViewController" ControllerObject:[NSNumber numberWithInteger:0]];
            break;
        }
        case SEPersonSpaceCollectionType_MyAppointment:
        {// 我的约诊
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－我的约诊"];
            [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentListViewController" ControllerObject:nil];
            break;
        }
        case SEPersonSpaceCollectionType_MyIntegal:
        {
            //我的约诊
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－我的约诊"];
            [HMViewControllerManager createViewControllerWithControllerName:@"PersonSpaceIntegalStartViewController" ControllerObject:nil];
            break;
        }
        default:
            break;
    }
}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;

    }
    else if (section == 1) {
        return 2;

    }
    else if (section == 2) {
        return 3;

    }
    else if (section == 3) {
        return 2;

    }
    else if (section == 4) {
        return 4;

    }
    else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    
    SEPersonSpaceType type = [self acquireTypeWithIndexPath:indexPath];
   
    if (type == SEPersonSpaceType_TopCollectView) {
        // 顶部我的订单、我的服务、我的约诊
         cell = [tableView dequeueReusableCellWithIdentifier:[HMSEPersonSpaceCollectionTableViewCell at_identifier]];
        [cell setPersonSpaceDelegate:self];
    }
    else {
//        cell = [tableView dequeueReusableCellWithIdentifier:[SEPersonSpaceStartTableViewCell at_identifier]];
        SEPersonSpaceStartTableViewCell* startCell = [tableView dequeueReusableCellWithIdentifier:@"SEPersonSpaceStartTableViewCell"];
        if (!startCell)
        {
            startCell = [[SEPersonSpaceStartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SEPersonSpaceStartTableViewCell"];
        }
//        [startCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        NSString *imageName = @"";
        NSString *titelName = @"";
        [startCell showOpened:YES];
        [startCell showHotIcon:NO];
        switch (type) {
                
            case SEPersonSpaceType_ConsultingRecords:
            {// 咨询记录
                imageName = @"me_ic_zj";
                titelName = @"咨询记录";
                break;
            }
            case SEPersonSpaceType_MyFriends:
            {// 我的亲友
                imageName = @"me_ic_qy";
                titelName = @"我的亲友";
                break;
            }
            case SEPersonSpaceType_MyArchives:
            {// 我的档案
                imageName = @"me_ic_da";
                titelName = @"我的档案";
                break;
            }
            case SEPersonSpaceType_MyReport:
            {// 我的报告
                imageName = @"me_ic_bg";
                titelName = @"我的报告";
                break;
            }
            case SEPersonSpaceType_MyEquipment:
            {// 我的设备
                imageName = @"me_ic_sb";
                titelName = @"我的设备";
                break;
            }
            case SEPersonSpaceType_Collection:
            {// 内容收藏
                imageName = @"me_ic_sc";
                titelName = @"内容收藏";
                // 暂未开通
                [startCell showOpened:NO];
                
                /*
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                UIImageView *notOpenImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"im_wkt"]];
                [[cell contentView] addSubview:notOpenImage];
                [notOpenImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.right.equalTo(cell);
                }];
                 */
                break;
            }
            case SEPersonSpaceType_MyFocus:
            {// 我的关注
                imageName = @"me_ic_gz";
                titelName = @"我的关注";
                break;
            }
                
            case SEPersonSpaceType_ShareToFriend:
            {
                //邀请好友
                imageName = @"me_ic_yq";
                titelName = @"邀请好友";
                [startCell showHotIcon:YES];
                break;
            }
            case SEPersonSpaceType_OnlineService:
            {// 在线客服
                imageName = @"me_ic_kf";
                titelName = @"在线客服";
                break;
            }
            case SEPersonSpaceType_Feedback:
            {// 意见反馈
                imageName = @"me_ic_yj";
                titelName = @"意见反馈";
                break;
            }
            case SEPersonSpaceType_AboutUs:
            {// 关于我们
                imageName = @"me_ic_wm";
                titelName = @"关于我们";
                break;
            }
//            case SEPersonSpaceType_ServiceComplaints:
//            {// 服务投诉
//                imageName = @"me_ic_ts";
//                titelName = @"服务投诉";
//                break;
//            }
                
            default:
                break;
        }
        
        
        [startCell.iconImageView setImage:[UIImage imageNamed:imageName]];
        
        [startCell.titleLabel setText:titelName];
        cell = startCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SEPersonSpaceType type = [self acquireTypeWithIndexPath:indexPath];
    switch (type) {
        case SEPersonSpaceType_ConsultingRecords:
        {// 咨询记录
            HMConsultingRecordsViewController *VC = [HMConsultingRecordsViewController new];
            [self.navigationController pushViewController:VC animated:YES];
            break;
        }
        case SEPersonSpaceType_MyFriends:
        {// 我的亲友
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－我的亲友"];
            [HMViewControllerManager createViewControllerWithControllerName:@"FriendsStartViewController" ControllerObject:nil];
            break;
        }
        case SEPersonSpaceType_MyArchives:
        {// 我的档案
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－我的档案"];
            [HMViewControllerManager createViewControllerWithControllerName:@"HealthDocutmentStartViewController" ControllerObject:nil];
            break;
        }
        case SEPersonSpaceType_MyReport:
        {// 我的报告
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的-我的报告"];
            if (![self userHasService])
            {
                [self showAlertMessage:@"您还没有购买服务。"];
                //[self showAlertWithoutServiceMessage];
                return;
            }
            [HMViewControllerManager createViewControllerWithControllerName:@"HealthReportListStartViewController" ControllerObject:nil];
            break;
        }
        case SEPersonSpaceType_MyEquipment:
        {// 我的设备
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－我的设备"];
            [HMViewControllerManager createViewControllerWithControllerName:@"DeviceManagerViewController" ControllerObject:nil];
            break;
        }
        case SEPersonSpaceType_Collection:
        {// 内容收藏
            
            break;
        }
        case SEPersonSpaceType_MyFocus:
        {// 我的关注
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－我的关注"];
            [HMViewControllerManager createViewControllerWithControllerName:@"AttentionListStartViewController" ControllerObject:nil];
            break;
        }
        case SEPersonSpaceType_ShareToFriend:
        {
            //邀请好友
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－邀请好友"];
            [SEPersonSpaceInventFriendViewController show];
            break;
        }
        case SEPersonSpaceType_OnlineService:
        {// 在线客服
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的-在线客服"];
            [self loadOnlineCustomServiceList];
            break;
        }
        case SEPersonSpaceType_Feedback:
        {// 意见反馈
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的-意见反馈"];
            [HMViewControllerManager createViewControllerWithControllerName:@"PersonSpaceFeedbackViewController" ControllerObject:nil];
            break;
        }
        case SEPersonSpaceType_AboutUs:
        {// 关于我们
            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－关于我们"];
            [HMViewControllerManager createViewControllerWithControllerName:@"HMAboutViewController" ControllerObject:nil];
            break;
        }
//        case SEPersonSpaceType_ServiceComplaints:
//        {// 服务投诉
//            [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的-服务投诉"];
//            [HMViewControllerManager createViewControllerWithControllerName:@"PersonServiceComplainViewController" ControllerObject:nil];
//            break;
//        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIViewController *topVC = self.navigationController.viewControllers.lastObject;
    if (![topVC isKindOfClass:[self class]]) {
        // 不在当前页面不响应
        return;
    }
    
    // 设置navigationBar透明度和颜色
    
    CGFloat tableViewOffsetY = scrollView.contentOffset.y;
//        NSLog(@"%f",tableViewOffsetY);
    if (tableViewOffsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 20 - tableViewOffsetY * 3) / 20));
        
        [self.topNavView setAlpha:alpha];
        
    } else {
        [self.topNavView setAlpha:0];
    }
    // 移动titel
    CGPoint titlePoint = CGPointMake(ScreenWidth / 2, 20 + 22);
//    CGPoint namePoint = self.moveUserNameLb.center;
    CGPoint fromePoint = self.moveLbLocation;
    CGPoint toPoint;
    CGFloat proportion;
    
    if (tableViewOffsetY+22 >= 40) {
        // titel在最上面
        UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
        [self.titelLb setText:curUser.userName];
        [self.userNamelb setHidden:YES];
//        [self.moveUserNameLb setHidden:YES];
    }
    else if(tableViewOffsetY+20 <= 0) {
        // titel在最下面
    [self.titelLb setText:@""];
    [self.userNamelb setHidden:NO];
//    [self.moveUserNameLb setHidden:YES];
    }
    else {
        // 移动中
//        [self.moveUserNameLb setHidden:NO];
        [self.userNamelb setHidden:YES];
        [self.titelLb setText:@""];
    
    if (!self.moveLbLocation.x) {
//        self.moveLbLocation = self.moveUserNameLb.center;
    }

    if ((tableViewOffsetY - self.lastTableViewOffset) > 0) {
        // 向上滑
        toPoint =  titlePoint;
        proportion = (tableViewOffsetY + 22) / 104;
    }
    else {
        // 向下滑
//        toPoint = namePoint;
        proportion = (self.lastTableViewOffset - tableViewOffsetY) / 30;
    }
    //x轴偏移的量
    CGFloat offsetX = (toPoint.x - fromePoint.x) * proportion ;
    
    //Y轴偏移的量
    CGFloat offsetY = (toPoint.y - fromePoint.y) * proportion;
    self.lastTableViewOffset = tableViewOffsetY;
    self.moveLbLocation = CGPointMake(self.moveLbLocation.x + offsetX, self.moveLbLocation.y + offsetY);

//    self.moveUserNameLb.transform = CGAffineTransformTranslate(self.moveUserNameLb.transform, offsetX, offsetY);
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat tableViewOffsetY = scrollView.contentOffset.y + 20;
    
    if (tableViewOffsetY < 100) {
        [self.tableView setContentOffset:CGPointMake(0, -20) animated:YES];
    }
    
    if (tableViewOffsetY >= 50 && tableViewOffsetY < TOPVIEWHEIGHT - 64) {
        [self.tableView setContentOffset:CGPointMake(0, TOPVIEWHEIGHT - 64 - 20) animated:YES];
    }
}

#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    
    if (StepError_None != taskError)
    {
        [self at_hideLoading];
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
        return;
    }

    
    
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    [self at_hideLoading];

    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
     if ([taskname isEqualToString:NSStringFromClass([GetOnlineCustomServiceTask class])]) {
        // 在线客服
        if ([taskResult isKindOfClass:[NSArray class]]) {
            NSArray *result = taskResult;
            if (result.count == 0) {
                return;
            }
            OnlineCustomServiceModel *sourceModel = result.firstObject;
            ContactDetailModel *model = [ContactDetailModel new];
            model._target = [NSString stringWithFormat:@"%ld",sourceModel.userName];
            model._nickName = sourceModel.nickName;
            model._headPic = sourceModel.avatar;
            ChatSingleViewController *VC  = [[ChatSingleViewController alloc] initWithDetailModel:model];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    if ([taskname isEqualToString:@"PointRedemptionContinuationTask"])
    {
        //签到信息 AttendanceSummaryModel
        if (taskResult && [taskResult isKindOfClass:[AttendanceSummaryModel class]]) {
            AttendanceSummaryModel* attendanceModel = (AttendanceSummaryModel*) taskResult;
            [self.pointWeeklyControl setContinuityDays:attendanceModel.seriesNum lastPointDate:attendanceModel.attendanceTime];
            [self.signedLabel setText:[NSString stringWithFormat:@"已连续签到%ld天，累计获得积分%ld", attendanceModel.seriesNum, attendanceModel.totalScore]];
            
            NSDate* attendanceDate = [NSDate dateWithString:attendanceModel.attendanceTime formatString:@"yyyy-MM-dd HH:mm:ss"];
            if (attendanceDate) {
                if ([attendanceDate isToday])
                {
                    [self.signButton setEnabled:NO];
                    [self.signButton setTitle:@"已签到" forState:UIControlStateDisabled];
                }
            }
        }
    }
    
    if ([taskname isEqualToString:@"AddPointRedemptionTask"])
    {
        //签到成功
        if (taskResult && [taskResult isKindOfClass:[AttendanceSummaryModel class]]) {
            AttendanceSummaryModel* attendanceModel = (AttendanceSummaryModel*) taskResult;
            [self.pointWeeklyControl setContinuityDays:attendanceModel.seriesNum lastPointDate:attendanceModel.attendanceTime];
            [self.signedLabel setText:[NSString stringWithFormat:@"已连续签到%ld天，累计获得积分%ld", attendanceModel.seriesNum, attendanceModel.totalScore]];
            
            [self signObtainPoint:attendanceModel.score];
        }
    }
    
    if ([taskname isEqualToString:@"IntegralSummaryTask"])
    {
        IntegralSummaryModel* model = (IntegralSummaryModel*) taskResult;
        NSInteger vipLevel = [model vipLevel];
        UIImage* vipImage = [UIImage imageNamed:[NSString stringWithFormat:@"integral_level_%ld", vipLevel + 1]];
        [self.headLevelImageView setImage:vipImage];
    }
}

#pragma mark - Interface
- (void)hideMoveNameLbWhenPush {
//    [self.moveUserNameLb setHidden:YES];
}
- (void)showMoveNameLbWhenPush {
//    [self.moveUserNameLb setHidden:NO];
}
#pragma mark - init UI


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setEstimatedRowHeight:45];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
        [self.topView addSubview:self.headIconView];
        [self.topView addSubview:self.headLevelImageView];
        [self.topView addSubview:self.userNamelb];
        
        [self.headIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topView).offset(15);
            make.top.equalTo(self.topView).offset(22);
            make.height.width.equalTo(@HEADICONHEIGHT);
        }];
        
        [self.headLevelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.headIconView).offset(-1);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];

        if ([self isGroupUser]) {
            // 是集团用户
            [self.topView addSubview:self.groupUserNameLb];
            [self.userNamelb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.headIconView).offset(-10);
                make.left.equalTo(self.headIconView.mas_right).offset(15);
                make.right.lessThanOrEqualTo(self.topView).offset(-15);
            }];
            
            [self.groupUserNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.userNamelb.mas_bottom).offset(5);
                make.left.equalTo(self.userNamelb);
                make.right.lessThanOrEqualTo(self.topView).offset(-15);

            }];

        }
        else {
            // 非集团用户
            [self.userNamelb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.headIconView);
                make.left.equalTo(self.headIconView.mas_right).offset(15);
                make.right.lessThanOrEqualTo(self.topView).offset(-15);
            }];
        }
        
        [self.identificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userNamelb);
            make.left.equalTo(self.userNamelb.mas_right).offset(7.5);
            make.size.mas_equalTo(CGSizeMake(68, 25));
        }];
        
        [_tableView setTableHeaderView:self.topView];
        [_tableView registerClass:[HMSEPersonSpaceCollectionTableViewCell class] forCellReuseIdentifier:[HMSEPersonSpaceCollectionTableViewCell at_identifier]];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell at_identifier]];

    }
    return _tableView;
}


- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, TOPVIEWHEIGHT)];
        [_topView setBackgroundColor:[UIColor mainThemeColor]];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)[[UIColor colorWithHexString:@"3cd395"] CGColor], (__bridge id)[[UIColor colorWithHexString:@"31c9ba"] CGColor]];
        gradientLayer.locations = @[@0.1, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 1.0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.frame = CGRectMake(0, 0, ScreenWidth, TOPVIEWHEIGHT);
        [_topView.layer addSublayer:gradientLayer];
    }
    return _topView;
}

- (UIView*) signedView
{
    if (!_signedView)
    {
        _signedView = [[UIView alloc] init];
        [self.topView addSubview:_signedView];
        [_signedView setBackgroundColor:[UIColor clearColor]];
        
        [_signedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.topView);
            make.top.equalTo(self.headIconView.mas_bottom).with.offset(4);
        }];
    }
    return _signedView;
}

- (PointRedemptionWeeklyControl*) pointWeeklyControl
{
    if (!_pointWeeklyControl) {
        _pointWeeklyControl = [[PointRedemptionWeeklyControl alloc] init];
        [self.signedView addSubview:_pointWeeklyControl];
        
        [self.pointWeeklyControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.signedView);
            make.top.equalTo(self.signedView).with.offset(4);
            make.height.mas_equalTo(@55);
        }];
    }
    return _pointWeeklyControl;
}

- (UIButton*) signButton
{
    if (!_signButton) {
        _signButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.signedView addSubview:_signButton];
        [_signButton setBackgroundImage:[UIImage rectImage:CGSizeMake(160, 35) Color:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_signButton setBackgroundImage:[UIImage rectImage:CGSizeMake(160, 35) Color:[UIColor whiteColor]] forState:UIControlStateDisabled];
        [_signButton setBackgroundImage:[UIImage rectImage:CGSizeMake(160, 35) Color:[UIColor commonBackgroundColor]] forState:UIControlStateHighlighted];
        [_signButton setTitle:@"签到" forState:UIControlStateNormal];
//        [_signButton setTitle:@"已签到" forState:UIControlStateDisabled];
        [_signButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [_signButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        
        _signButton.layer.cornerRadius = 17.5;
        _signButton.layer.masksToBounds = YES;
        
        [_signButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(160, 35));
            make.centerX.equalTo(self.signedView);
            make.top.equalTo(self.pointWeeklyControl.mas_bottom).with.offset(4);
        }];
    }
    return _signButton;
}

- (UILabel*) signedLabel
{
    if (!_signedLabel) {
        _signedLabel = [[UILabel alloc] init];
        [self.signedView addSubview:_signedLabel];
        
        [_signedLabel setTextColor:[UIColor whiteColor]];
        [_signedLabel setFont:[UIFont systemFontOfSize:12]];
        
        [_signedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.signedView);
            make.top.equalTo(self.signButton.mas_bottom).with.offset(5);
        }];
    }
    
    return _signedLabel;
}

- (UILabel*) signPointLabel
{
    if (!_signPointLabel) {
        _signPointLabel = [[UILabel alloc] init];
        [self.signedView addSubview:_signPointLabel];
        
        [_signPointLabel setTextColor:[UIColor whiteColor]];
        [_signPointLabel setFont:[UIFont systemFontOfSize:15]];
        
        [_signPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.signButton);
            make.centerY.equalTo(self.signButton.mas_top).with.offset(-15);
        }];
    }
    return _signPointLabel;
}

- (UIImageView *)headIconView {
    if (!_headIconView) {
        _headIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_default_photo"]];
        [_headIconView.layer setCornerRadius:HEADICONHEIGHT / 2];
        [_headIconView setClipsToBounds:YES];
    }
    return _headIconView;
}

- (UIImageView*) headLevelImageView
{
    if (!_headLevelImageView) {
        _headLevelImageView = [[UIImageView alloc] init];
        [_headLevelImageView.layer setCornerRadius:9];
        [_headLevelImageView setClipsToBounds:YES];
    }
    return _headLevelImageView;
}

- (UILabel *)userNamelb {
    if (!_userNamelb) {
        _userNamelb = [UILabel new];
        [_userNamelb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_userNamelb setFont:[UIFont boldFont_36]];
        UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
        [_userNamelb setText:curUser.userName];
    }
    return _userNamelb;
}

- (UIButton*) identificationButton
{
    if (!_identificationButton) {
        _identificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.topView addSubview:_identificationButton];
        
        [_identificationButton setTitle:@"实名认证" forState:UIControlStateNormal];
        [_identificationButton setTitle:@"已认证" forState:UIControlStateDisabled];
        [_identificationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_identificationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_identificationButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        
        [_identificationButton setBackgroundImage:[UIImage rectImage:CGSizeMake(120, 28) Color:[UIColor commonOrangeColor]] forState:UIControlStateNormal];
         [_identificationButton setBackgroundImage:[UIImage rectImage:CGSizeMake(120, 28) Color:[UIColor mainThemeColor]] forState:UIControlStateDisabled];
        _identificationButton.layer.borderWidth = 1;
        _identificationButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _identificationButton.layer.cornerRadius = 12.5;
        _identificationButton.layer.masksToBounds = YES;
        UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
        [_identificationButton setEnabled:!(curUser.idCard && curUser.idCard.length >= 15)];
    }
    return _identificationButton;
}

- (UILabel *)groupUserNameLb {
    if (!_groupUserNameLb) {
        _groupUserNameLb = [UILabel new];
        [_groupUserNameLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_groupUserNameLb setAlpha:0.7];
        [_groupUserNameLb setFont:[UIFont systemFontOfSize:14]];
        UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
        [_groupUserNameLb setText:curUser.blocName];
    }
    return _groupUserNameLb;
}

//- (UILabel *)moveUserNameLb {
//    if (!_moveUserNameLb) {
//        _moveUserNameLb = [UILabel new];
//        [_moveUserNameLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
//        [_moveUserNameLb setFont:[UIFont boldFont_36]];
//        UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
//        [_moveUserNameLb setText:curUser.userName];
//    }
//    return _moveUserNameLb;
//}

- (UIView *)redPoint {
    if (!_redPoint) {
        _redPoint = [UIView new];
        [_redPoint setBackgroundColor:[UIColor redColor]];
        [_redPoint.layer setCornerRadius:6];
        [_redPoint.layer setBorderColor:[[UIColor colorWithHexString:@"ffffff"] CGColor]];
        [_redPoint.layer setBorderWidth:1];
        [_redPoint setHidden:YES];
    }
    return _redPoint;
}

- (UIView *)topNavView {
    if (!_topNavView) {
        _topNavView = [UIView new];
        CAGradientLayer *backLayer = [CAGradientLayer layer];
        backLayer.locations = @[@0.1, @1.0];
        backLayer.startPoint = CGPointMake(0, 1.0);
        backLayer.endPoint = CGPointMake(1.0, 0);
        backLayer.frame = CGRectMake(0, 0, ScreenWidth, 64);
        
        backLayer.colors = @[(__bridge id)[[UIColor colorWithHexString:@"3cd395" alpha:1] CGColor], (__bridge id)[[UIColor colorWithHexString:@"31c9ba" alpha:1] CGColor]];
        [_topNavView.layer addSublayer:backLayer];
        
    }
    return _topNavView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
