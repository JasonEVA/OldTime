//
//  StaffDetailViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "StaffDetailViewController.h"
#import "HMSwitchView.h"

#import "StaffDetailTableViewController.h"

#import "StaffDetailDescTableViewController.h"
#import "StaffDetailTeamsTableViewController.h"
#import "StaffDetailServiceTableViewController.h"

@interface StaffDetailView : UIView
{
    UIImageView* ivStaff;
    UILabel* lbStaffName;
    UILabel* lbStaffType;
    UILabel* lbOrg;
}

- (void) setStaffInfo:(StaffInfo*) staff;
@end

@implementation StaffDetailView



- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        ivStaff = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_default_staff"]];
        [self addSubview:ivStaff];
        ivStaff.layer.borderWidth = 0.5;
        ivStaff.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        ivStaff.layer.cornerRadius = 40;
        ivStaff.layer.masksToBounds = YES;
        
        lbStaffName = [[UILabel alloc]init];
        [self addSubview:lbStaffName];
        [lbStaffName setFont:[UIFont font_30]];
        [lbStaffName setTextColor:[UIColor whiteColor]];
        
        lbStaffType = [[UILabel alloc]init];
        [self addSubview:lbStaffType];
        [lbStaffType setFont:[UIFont font_24]];
        [lbStaffType setTextColor:[UIColor colorWithHexString:@"F4F4F4"]];
        
        lbOrg = [[UILabel alloc]init];
        [self addSubview:lbOrg];
        [lbOrg setFont:[UIFont font_24]];
        [lbOrg setTextColor:[UIColor colorWithHexString:@"F4F4F4"]];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [ivStaff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [lbStaffName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(ivStaff.mas_bottom).with.offset(10);
    }];
    
    [lbStaffType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(lbStaffName.mas_bottom).with.offset(4);
    }];
    
    [lbOrg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(lbStaffType.mas_bottom).with.offset(4);
    }];
}

- (void) setStaffInfo:(StaffInfo*) staff
{
    [lbStaffName setText:staff.staffName];
    //[lbStaffType setText:staff.staffTypeName];
    
    if (staff.imgUrl)
    {
        [ivStaff sd_setImageWithURL:[NSURL URLWithString:staff.imgUrl] placeholderImage:[UIImage imageNamed:@"icon_default_staff"]];
    }
    
    [lbOrg setText:staff.orgName];
    
    NSString* stafftype = staff.staffTypeName;
    NSString* deptname = staff.depName;
    
    if (!stafftype || 0 == stafftype.length)
    {
        stafftype = deptname;
    }
    else
    {
        if (deptname && 0 < deptname.length) {
            stafftype = [stafftype stringByAppendingFormat:@"/%@", deptname];
        }
    }
    
    [lbStaffType setText:stafftype];
    
}

@end


@interface StaffDetailViewController ()
<HMSwitchViewDelegate,TaskObserver>
{
    UIView* navTitleView;
    StaffDetailView* staffview;
    HMSwitchView* switchview;
    StaffInfo* staff;
    
    UIControl *attentionControl;
    UILabel *lbAttention;
    
    UITabBarController* tabbarController;
    StaffDetailTableViewController* descController;
    StaffDetailTeamsTableViewController* teamsController;
//    StaffDetailTableViewController* tvcDetail;
}
@property (nonatomic , assign) BOOL isFavor;

@end

@implementation StaffDetailViewController

- (void) dealloc
{
    if (descController) {
        [descController removeObserver:self forKeyPath:@"staffdetail"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setLeftBarButtonItem:nil];
    [self.navigationItem setHidesBackButton:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (self.paramObject && [self.paramObject isKindOfClass:[StaffInfo class]])
    {
        staff = (StaffInfo*) self.paramObject;
    }
    
    switchview = [[HMSwitchView alloc]init];
    [self.view addSubview:switchview];
    [switchview createCells:@[@"介绍", @"Ta的团队", @"Ta提供的服务"]];
    [switchview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(140);
        make.height.mas_equalTo(@40);
    }];
    
    [switchview setDelegate:self];
    
    [self createDetailTables];
    
//    [self createDetailTable:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO];
    UINavigationBar *bar = [self.navigationController navigationBar];
    CGFloat navBarHeight = 44.0f ;
    CGRect frame = CGRectMake(0.0f, 20.0f, 320.0f * kScreenScale, navBarHeight);
    [bar setFrame:frame];
    [navTitleView removeFromSuperview];
    
    navTitleView = nil;
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    
    CGFloat navBarHeight = 175;
    CGRect frame = CGRectMake(0.0f, 10, 320.0f * kScreenScale, navBarHeight);
    [bar setFrame:frame];
    navTitleView = [[UIView alloc]initWithFrame:frame];
    [bar addSubview:navTitleView];
    
    [navTitleView setBackgroundColor:[UIColor mainThemeColor]];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[[UIColor colorWithHexString:@"3cd395"] CGColor], (__bridge id)[[UIColor colorWithHexString:@"31c9ba"] CGColor]];
    gradientLayer.locations = @[@0.4, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 1.0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, ScreenWidth, navBarHeight);
    [navTitleView.layer addSublayer:gradientLayer];
    
    UIButton* btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(4, 4, 44, 36)];
    [btnBack setBackgroundColor:[UIColor clearColor]];
    [navTitleView addSubview:btnBack];
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(onBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    staffview = [[StaffDetailView alloc]init];
    [navTitleView addSubview:staffview];
    [staffview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navTitleView).with.offset(40);
        make.right.equalTo(navTitleView).with.offset(-40);
        make.top.and.bottom.equalTo(navTitleView);
    }];
    
    if (staff) {
        [staffview setStaffInfo:staff];
    }
    
    attentionControl = [[UIControl alloc] init];
    [navTitleView addSubview:attentionControl];
    [attentionControl addTarget:self action:@selector(attentionControlClick) forControlEvents:UIControlEventTouchUpInside];
    
    [attentionControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnBack.mas_top).with.offset(5);
        make.right.equalTo(navTitleView.mas_right).with.offset(-8);
        make.size.mas_equalTo(CGSizeMake(75, 20));
    }];

    lbAttention = [[UILabel alloc] init];
    [attentionControl addSubview:lbAttention];
    [lbAttention setText:@"关注"];
    [lbAttention setTextColor:[UIColor whiteColor]];
    [lbAttention setFont:[UIFont font_28]];
    
    [lbAttention mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(attentionControl);
        make.right.equalTo(attentionControl.mas_right);
    }];
    
    
    UIButton* ivHeart = [UIButton buttonWithType:UIButtonTypeCustom];
    [attentionControl addSubview:ivHeart];
    [ivHeart setBackgroundImage:[UIImage imageNamed:@"icon_home_fans"] forState:UIControlStateNormal];
    ivHeart.userInteractionEnabled = NO;
    
    [ivHeart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lbAttention.mas_left).with.offset(-2);
        make.centerY.equalTo(attentionControl);
        make.size.mas_equalTo(CGSizeMake(12, 11));
    }];
    
    //检查是否关注
    [self checkStaffAttention];
}

- (void)checkStaffAttention
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",curUser.userId] forKey:@"userId"];
    
    [dicPost setValue:@"1" forKey:@"type"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"objectId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"checkUserFavorTask" taskParam:dicPost TaskObserver:self];
}

- (void)attentionControlClick
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
//    if (_isFavor) {
//        return;
//    }
    _isFavor = !_isFavor;
    if (_isFavor){
        
        [lbAttention setText:@"取消关注"];
        [dicPost setValue:@"Y" forKey:@"isFavor"];
    }
    else{
    
        [lbAttention setText:@"关注"];
        [dicPost setValue:@"N" forKey:@"isFavor"];
    }
    
    [dicPost setValue:@"1" forKey:@"type"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",staff.staffId] forKey:@"objectId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"addUserFavorTask" taskParam:dicPost TaskObserver:self];
}

- (void) onBackClicked:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) createDetailTables
{
    tabbarController = [[UITabBarController alloc] init];
    [self addChildViewController:tabbarController];
    [self.view addSubview:tabbarController.view];
    [tabbarController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(switchview.mas_bottom);
    }];
    
    [tabbarController.tabBar setHidden:YES];
    descController = [[StaffDetailDescTableViewController alloc] initWithStaffInfo:staff];
    [descController addObserver:self forKeyPath:@"staffdetail" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    teamsController = [[StaffDetailTeamsTableViewController alloc] initWithStaffInfo:staff];
    StaffDetailServiceTableViewController* serviceController = [[StaffDetailServiceTableViewController alloc] initWithStaffInfo:staff];
    
    [tabbarController setViewControllers:@[descController, teamsController, serviceController]];
}



#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSInteger) selectedIndex
{
    [tabbarController setSelectedIndex:selectedIndex];
//    [self createDetailTable:selectedIndex];
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
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
//    if ([taskname isEqualToString:@"addUserFavorTask"])
//    {
//        _isFavor = YES;
//        [lbAttention setText:@"已关注"];
//    }
}

- (void) task:(NSString *)taskId Result:(id)taskResult
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
    
    if ([taskname isEqualToString:@"addUserFavorTask"])
    {

    }
    
    if ([taskname isEqualToString:@"checkUserFavorTask"])
    {
        NSString* attention = (NSString*)taskResult;
        if (attention.integerValue > 0)
        {
            [lbAttention setText:@"取消关注"];
            _isFavor = YES;
        }else
        {
            [lbAttention setText:@"关注"];
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"staffdetail"])
    {
        StaffDetail* detail = [object valueForKey:@"staffdetail"];
        [staffview setStaffInfo:detail];
        [teamsController setStaffUserId:detail.userId];
    }
}
@end
