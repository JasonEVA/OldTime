//
//  HMSEPatientDetailInfoViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/10/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMSEPatientDetailInfoViewController.h"
#import "UIImage+JWNameImage.h"
#import "HMPatientDetailInfoTableViewCell.h"
#import "DAOFactory.h"
#import "HMThirdEditionPatitentInfoModel.h"
#import "HMPresentIMModel.h"
#import "HMSEPatientGroupChatViewController.h"

#import "HMThirdEditionPatientViewController.h"
#import "PatientEMRInfoViewController.h"
#import "HealthPlanSummaryViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#define HEADICONHEIGHT   70
#define ICONHEIGHT       40
@interface HMSEPatientDetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataList;
@property (nonatomic, strong) UIImageView *headIconView;
@property (nonatomic, strong) UILabel *NSALb;
@property (nonatomic, strong) UILabel *phoneNumLb;
@property (nonatomic, strong) UIButton *attentionBtn;
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, copy) NSArray *imageArr;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) HMThirdEditionPatitentInfoModel *model;

@end

@implementation HMSEPatientDetailInfoViewController

- (instancetype)initWithUserId:(NSString *)userId
{
    self = [super init];
    if (self) {
        self.userId = userId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.titleArr = @[@"基础档案",@"在院档案",@"健康记录"];
    self.imageArr = @[@"ic_basic",@"ic_hostipal",@"ic_healthrecord"];
    

    [self configElements];
    [self startPatientInfoRequest];
    [self startRequestAllService];
    
    [self setFd_prefersNavigationBarHidden:YES];
    

    // 禁用滑动返回
    self.fd_interactivePopDisabled = YES;

    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *vc = [self.navigationController.viewControllers lastObject];
        if (!vc.fd_prefersNavigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
    UIButton *popBtn = [[UIButton alloc] init];
    [popBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];
    [popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.centerY.equalTo(self.view.mas_top).offset(44);
    }];

    
    [self.view addSubview:self.headIconView];
    [self.headIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.height.width.equalTo(@HEADICONHEIGHT);
    }];
    
    [self.view addSubview:self.NSALb];
    [self.NSALb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.headIconView.mas_bottom).offset(9);
        make.right.lessThanOrEqualTo(self.view).offset(-15);
    }];
    
    [self.view addSubview:self.phoneNumLb];
    [self.phoneNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.NSALb.mas_bottom).offset(9);
        make.right.lessThanOrEqualTo(self.view).offset(-15);
    }];
    
    [self.view addSubview:self.attentionBtn];
    [self.attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.phoneNumLb.mas_bottom).offset(9);
        make.width.equalTo(@70);
        make.height.equalTo(@27);
    }];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(self.view);
        make.top.equalTo(self.attentionBtn.mas_bottom).offset(36 + ICONHEIGHT + 40);
    }];
}


- (void)configBtnArr  {
    [self.titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *iconBtn = [[UIButton alloc] init];
        [iconBtn setImage:[UIImage imageNamed:self.imageArr[idx]] forState:UIControlStateNormal];
        [iconBtn setTag:idx];
        [iconBtn addTarget:self action:@selector(recordJumpClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:iconBtn];
        [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.attentionBtn.mas_bottom).offset(36);
            make.width.height.equalTo(@ICONHEIGHT);
            make.centerX.equalTo(self.view.mas_left).offset(idx * (ScreenWidth / self.titleArr.count) + ((ScreenWidth / self.titleArr.count) / 2));
        }];
        
        UIButton *titelBtn = [UIButton new];
        [titelBtn setTag:idx];
        [titelBtn addTarget:self action:@selector(recordJumpClick:) forControlEvents:UIControlEventTouchUpInside];
        [titelBtn setTitle:obj forState:UIControlStateNormal];
        [titelBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [titelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        [self.view addSubview:titelBtn];
        [titelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconBtn.mas_bottom).offset(7);
            make.centerX.equalTo(iconBtn);
        }];
    }];
}
- (void)startPatientInfoRequest {
    if (!self.userId || self.userId.length == 0) {
        return;
    }
    //获取患者的信息
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:self.userId forKey:@"userId"];
    
    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMThirdEditionPatitentInfoRequest" taskParam:dicPost TaskObserver:self];
}

- (void)startRequestAllService {
    if (!self.userId || self.userId.length == 0) {
        return;
    }
    
    //获取患者的信息
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:@(self.userId.integerValue) forKey:@"userId"];
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:@(curStaff.staffId) forKey:@"staffId"];

    [self at_postLoading];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMFindAllPresentUserServiceRequest" taskParam:dicPost TaskObserver:self];
    
}

- (void)PushToPatientChatVC:(UIViewController *)VC {
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(p_realPushToPatientChatVC:) withObject:VC afterDelay:0.01];
}

- (void)p_realPushToPatientChatVC:(UIViewController *)VC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UITabBarController *controller = (UITabBarController *)rootViewController;
    UINavigationController *origNavi = controller.selectedViewController;
    [origNavi popToRootViewControllerAnimated:NO];

    controller.selectedIndex = 1;
    UINavigationController *navi = controller.selectedViewController;
    [navi popToRootViewControllerAnimated:NO];
    [VC setHidesBottomBarWhenPushed:YES];
    
    [navi pushViewController:VC animated:YES];
}

#pragma mark - event Response
- (void)rightClick {
    
}
- (void)popClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)recordJumpClick:(UIButton *)btn {
    
    switch (btn.tag) {
        case 0:
        {// 基础档案 HMThirdEditionPatientViewController
            HMThirdEditionPatientViewController* baseInfoViewController = [[HMThirdEditionPatientViewController alloc] initWithUserID:self.userId];
            [self.navigationController pushViewController:baseInfoViewController animated:YES];
            
            break;
        }
        case 1:
        {// 在院档案 HMOnlineArchivesViewController
            NSInteger userIdInt = self.userId.integerValue;
            [HMViewControllerManager createViewControllerWithControllerName:@"HMOnlineArchivesViewController" ControllerObject:[NSString stringWithFormat:@"%ld", userIdInt]] ;
            
            break;
        }
        case 2:
        {// 健康记录 PatientEMRInfoViewController
            PatientEMRInfoViewController* emrInfoViewController = [[PatientEMRInfoViewController alloc] initWithUserID:self.userId];
            [self.navigationController pushViewController:emrInfoViewController animated:YES];
            break;
        }
        case 3:
        {// 健康计划 HealthPlanSummaryViewController
            NSInteger userIdInt = self.userId.integerValue;
            HealthPlanSummaryViewController* detectViewController = [[HealthPlanSummaryViewController alloc] initWithUserId:userIdInt];
            [self.navigationController pushViewController:detectViewController animated:YES];
            break;
        }
        case 4:
        {// 病程
            
            break;
        }
            
        default:
            break;
    }
}

// 关注事件
- (void)p_followAction {
    //__weak typeof(self) weakSelf = self;
    [_DAO.patientInfoListDAO queryPatientInfoWithPatientID:self.userId.integerValue completion:^(NewPatientListInfoModel *model) {
        //__strong typeof(weakSelf) strongSelf = weakSelf;
        BOOL willFollow = model.attentionStatus == 1 ? NO : YES;
        [_DAO.patientInfoListDAO updatePatientFollowStatus:willFollow patientID:model.userId completion:^(BOOL requestSuccess, NSString *errorMsg) {
            if (!requestSuccess) {
                return;
            }
            
            [self.attentionBtn setSelected:willFollow];
        }];
        
    }];
}

#pragma mark - Delegate

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 38;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.dataList.count ? @"当前服务":@"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMPresentIMModel *model = self.dataList[indexPath.row];
    HMPatientDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HMPatientDetailInfoTableViewCell at_identifier]];
    [cell.titelLb setText:model.productName];
    
    [cell.pointView setBackgroundColor:model.classify != 5 ? [UIColor colorWithHexString:@"f2725e"]:[UIColor colorWithHexString:@"77cecd"]];
   
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HMPresentIMModel *model = self.dataList[indexPath.row];

    ContactDetailModel *tempModel = [ContactDetailModel new];
    tempModel._target = model.imGroupId;
    tempModel._nickName = [NSString stringWithFormat:@"%@-%@",self.model.userInfo.userName,model.teamName];
    
    HMSEPatientGroupChatViewController *chatVC = [[HMSEPatientGroupChatViewController alloc] initWithDetailModel:tempModel];
    //        [chatVC hideChatInputView:self.hideInputView];
    //        chatVC.showServiceEnd = self.hideInputView;
    chatVC.chatType = IMChatTypePatientChat;
    chatVC.module.sessionModel._tag = im_doctorPatientGroupTag;
    [self p_realPushToPatientChatVC:chatVC];
}

#pragma mark - request Delegate
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError ) {
        [self at_hideLoading];
        [self showAlertMessage:errorMessage];
        return;
    }
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
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
    
    if ([taskname isEqualToString:@"HMThirdEditionPatitentInfoRequest"])
    {
        self.model = taskResult;
         NSURL *urlHead = avatarURL(avatarType_80, self.userId);
        [self.headIconView sd_setImageWithURL:urlHead placeholderImage:[UIImage JW_acquireNameImageWithNameString:self.model.userInfo.userName imageSize:CGSizeMake(HEADICONHEIGHT, HEADICONHEIGHT) font:[UIFont systemFontOfSize:18]]];
        
        [self.NSALb setText:[NSString stringWithFormat:@"%@ %@ %ld",self.model.userInfo.userName,self.model.userInfo.sex,(long)self.model.userInfo.age]];
        [self.phoneNumLb setText:[NSString stringWithFormat:@"手机号：%@",self.model.userInfo.mobile]];
        
        [_DAO.patientInfoListDAO queryPatientInfoWithPatientID:self.userId.integerValue completion:^(NewPatientListInfoModel *model) {
            if (!model) {
                return;
            }
            BOOL follow = model.attentionStatus == 1 ? YES : NO;
            [self.attentionBtn setSelected:follow];
        }];
    }
    else if ([taskname isEqualToString:@"HMFindAllPresentUserServiceRequest"]) {
        self.dataList = taskResult;
        [self.attentionBtn setEnabled:self.dataList.count];
        [self.tableView reloadData];
        
        __block BOOL isShowHealthPlan = NO;
        
        if (self.dataList.count > 0) {
            [self.dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HMPresentIMModel *tempModel = (HMPresentIMModel *)obj;
                if (tempModel.classify != 5) {
                    isShowHealthPlan = YES;
                    *stop = YES;
                }
            }];
        }
        
        if (isShowHealthPlan) {
            self.titleArr = @[@"基础档案",@"在院档案",@"健康记录",@"健康计划"];
            self.imageArr = @[@"ic_basic",@"ic_hostipal",@"ic_healthrecord",@"ic_healthplan"];
        }
        else {
            self.titleArr = @[@"基础档案",@"在院档案",@"健康记录"];
            self.imageArr = @[@"ic_basic",@"ic_hostipal",@"ic_healthrecord"];
        }
        
        [self configBtnArr];
        
    }
    
}
#pragma mark - Interface

#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        [_tableView setEstimatedRowHeight:45];
        [_tableView registerClass:[HMPatientDetailInfoTableViewCell class] forCellReuseIdentifier:[HMPatientDetailInfoTableViewCell at_identifier]];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
    }
    return _tableView;
}

- (UIImageView *)headIconView {
    if (!_headIconView) {
        _headIconView = [[UIImageView alloc] initWithImage:[UIImage JW_acquireNameImageWithNameString:@"JW" imageSize:CGSizeMake(HEADICONHEIGHT, HEADICONHEIGHT)]];
        [_headIconView.layer setCornerRadius:HEADICONHEIGHT / 2];
        [_headIconView setClipsToBounds:YES];
    }
    return _headIconView;
}

- (UILabel *)NSALb {
    if (!_NSALb) {
        _NSALb = [UILabel new];
        _NSALb.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        _NSALb.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [_NSALb setText:@""];
    }
    return _NSALb;
}

- (UILabel *)phoneNumLb {
    if (!_phoneNumLb) {
        _phoneNumLb = [UILabel new];
        _phoneNumLb.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_phoneNumLb setText:@""];
        _phoneNumLb.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];

    }
    return _phoneNumLb;
}

- (UIButton *)attentionBtn {
    if (!_attentionBtn) {
        _attentionBtn = [[UIButton alloc] init];
        [_attentionBtn setImage:[UIImage imageNamed:@"bt_attention"] forState:UIControlStateNormal];
        [_attentionBtn setImage:[UIImage imageNamed:@"bt_attentioned"] forState:UIControlStateSelected];
        [_attentionBtn addTarget:self action:@selector(p_followAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentionBtn;
}
@end
