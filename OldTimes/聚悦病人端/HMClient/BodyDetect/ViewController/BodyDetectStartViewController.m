//
//  BodyDetectStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BodyDetectStartViewController.h"
#import "BodyDetectStartTableViewController.h"
#import "PointRedemptionWeeklyControl.h"
#import "AttendanceSummaryModel.h"
#import "BodyDetectCalendarViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface BodyDetectPointRedemptionView : UIView

@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) UILabel* titleLable;
@property (nonatomic, strong) PointRedemptionWeeklyControl* weeklyControl;
@property (nonatomic, strong) UILabel* pointLabel;
@end

@implementation BodyDetectPointRedemptionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray* colors = @[[UIColor colorWithHexString:@"31c9ba"], [UIColor colorWithHexString:@"3cd395"]];
        UIImage* patternImage = [UIImage gradientColorImageFromColors:colors gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(400, 150)];
        [self setBackgroundColor:[UIColor colorWithPatternImage:patternImage]];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(25);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 36));
        make.left.equalTo(self).with.offset(10);
        make.top.equalTo(self).with.offset(24);
    }];
    
    [self.weeklyControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(70);
        make.width.equalTo(self).with.offset(-20);
        make.height.mas_equalTo(@55);
        make.centerX.equalTo(self);
    }];
    
    [_pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.weeklyControl.mas_bottom).with.offset(5);
    }];
}

#pragma mark - settingAndGetting

- (UIButton*) backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_backButton];
        [_backButton setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
        [_backButton setImageEdgeInsets:UIEdgeInsetsMake(9, 12, 9, 12)];
    }
    return _backButton;
}

- (UILabel*) titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        [self addSubview:_titleLable];
        
        [_titleLable setFont:[UIFont systemFontOfSize:18]];
        [_titleLable setTextColor:[UIColor whiteColor]];
        [_titleLable setText:@"记录健康"];
    }
    return _titleLable;
}

- (PointRedemptionWeeklyControl*) weeklyControl
{
    if (!_weeklyControl) {
        _weeklyControl = [[PointRedemptionWeeklyControl alloc] init];
        [self addSubview:_weeklyControl];
    }
    return _weeklyControl;
}

- (UILabel*) pointLabel
{
    if (!_pointLabel) {
        _pointLabel = [[UILabel alloc] init];
        [self addSubview:_pointLabel];
        
        [_pointLabel setTextColor:[UIColor whiteColor]];
        [_pointLabel setFont:[UIFont systemFontOfSize:12]];
    }
    return _pointLabel;
}
@end

@interface BodyDetectStartViewController ()
<TaskObserver>
{
    
}

@property (nonatomic, strong) BodyDetectPointRedemptionView* pointRedemptionView;
@property (nonatomic, strong) BodyDetectStartTableViewController* tvcStart;
@end

@implementation BodyDetectStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationItem setTitle:@"记录健康"];
    [self setFd_prefersNavigationBarHidden:YES];
    
    [self.tvcStart.tableView setBackgroundColor:[UIColor whiteColor]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton* detectManagerButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [detectManagerButton setImage:[UIImage imageNamed:@"btn_home_add"] forState:UIControlStateNormal];
    [detectManagerButton addTarget:self action:@selector(DetectManagerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [detectManagerButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    [self.pointRedemptionView addSubview:detectManagerButton];
    [detectManagerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pointRedemptionView.backButton);
        make.right.equalTo(self.pointRedemptionView).with.offset(-15);
    }];
    
    [self.pointRedemptionView.backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.pointRedemptionView.weeklyControl addTarget:self action:@selector(weeklyControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadPointRedemptionInfo];
}

- (void) backButtonClicked:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) weeklyControlClicked:(id) sender
{
    [BodyDetectCalendarViewController show];
}

- (void)DetectManagerButtonClick
{
    [HMViewControllerManager createViewControllerWithControllerName:@"BodyDetectManageViewController" ControllerObject:nil];
}

- (void) loadPointRedemptionInfo
{
    //PointRedemptionContinuationTask
    NSMutableDictionary* postDictionary = [NSMutableDictionary dictionary];
    UserInfo* currentUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [postDictionary setValue:@2 forKey:@"type"];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld", currentUser.userId] forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"PointRedemptionContinuationTask" taskParam:postDictionary TaskObserver:self];
}


- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.pointRedemptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(@150);
    }];
    
    [self.tvcStart.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.pointRedemptionView.mas_bottom);
//        make.top.equalTo(self.view);
    }];
}

#pragma mark - settingAndGetting
- (BodyDetectPointRedemptionView*) pointRedemptionView
{
    if (!_pointRedemptionView) {
        _pointRedemptionView = [[BodyDetectPointRedemptionView alloc] init];
        [self.view addSubview:_pointRedemptionView];
    }
    return _pointRedemptionView;
}

- (BodyDetectStartTableViewController*) tvcStart
{
    if (!_tvcStart) {
        _tvcStart = [[BodyDetectStartTableViewController alloc]initWithStyle:UITableViewStylePlain];
        [self addChildViewController:_tvcStart];
        
        [self.view addSubview:_tvcStart.tableView];
    }
    return _tvcStart;
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    
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
    
    if ([taskname isEqualToString:@"PointRedemptionContinuationTask"])
    {
        //签到信息 AttendanceSummaryModel
        if (taskResult && [taskResult isKindOfClass:[AttendanceSummaryModel class]]) {
            AttendanceSummaryModel* attendanceModel = (AttendanceSummaryModel*) taskResult;
            [self.pointRedemptionView.weeklyControl setContinuityDays:attendanceModel.seriesNum lastPointDate:attendanceModel.attendanceTime];
            [self.pointRedemptionView.pointLabel setText:[NSString stringWithFormat:@"已连续记录%ld天，累计获得积分%ld", attendanceModel.seriesNum, attendanceModel.totalScore]];
            
        }
        return;
    }
    
    }

@end
