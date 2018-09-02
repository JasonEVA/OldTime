//
//  SEMainStartAttendanceViewController.m
//  HMClient
//
//  Created by yinquan on 2017/7/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "SEMainStartAttendanceViewController.h"
#import "AppDelegate.h"
#import "PointRedemptionWeeklyControl.h"
#import "AttendanceSummaryModel.h"

@interface SEMainStartAttendanceView : UIView

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* closeButton;
@property (nonatomic, strong) PointRedemptionWeeklyControl* weeklyControl;
@property (nonatomic, strong) UIButton* signButton;
@property (nonatomic, strong) UILabel* signedLabel;
@property (nonatomic, strong) UILabel* signPointLabel;

@end

@implementation SEMainStartAttendanceView

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray* colors = @[[UIColor colorWithHexString:@"31c9ba"], [UIColor colorWithHexString:@"3cd395"]];
        UIImage* patternImage = [UIImage gradientColorImageFromColors:colors gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(400, 400)];
        [self setBackgroundColor:[UIColor colorWithPatternImage:patternImage]];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(18);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self).with.offset(-14);
    }];
    
    [self.weeklyControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(@55);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(5);
        make.width.equalTo(self).with.offset(-20);
    }];
    
    [_signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 35));
        make.centerX.equalTo(self);
        make.top.equalTo(self.weeklyControl.mas_bottom).with.offset(4);
    }];
    
    [_signedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.signButton.mas_bottom).with.offset(12);
    }];
    
    [_signPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.signButton);
        make.centerY.equalTo(self.signButton.mas_top).with.offset(-15);
    }];
}

#pragma mark - settingAndGetting
- (UILabel*) titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setText:@"每日签到"];
    }
    return _titleLabel;
}

- (UIButton*) closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_closeButton];
        [_closeButton setImage:[UIImage imageNamed:@"close_button_icon"] forState:UIControlStateNormal];
        [_closeButton setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    }
    return _closeButton;
}

- (PointRedemptionWeeklyControl*) weeklyControl
{
    if (!_weeklyControl) {
        _weeklyControl = [[PointRedemptionWeeklyControl alloc] init];
        [self addSubview:_weeklyControl];
    }
    return _weeklyControl;
}

- (UIButton*) signButton
{
    if (!_signButton) {
        _signButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self addSubview:_signButton];
        [_signButton setBackgroundImage:[UIImage rectImage:CGSizeMake(160, 35) Color:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_signButton setBackgroundImage:[UIImage rectImage:CGSizeMake(160, 35) Color:[UIColor whiteColor]] forState:UIControlStateDisabled];
        [_signButton setBackgroundImage:[UIImage rectImage:CGSizeMake(160, 35) Color:[UIColor commonBackgroundColor]] forState:UIControlStateHighlighted];
        [_signButton setTitle:@"签到" forState:UIControlStateNormal];
//        [_signButton setTitle:@"已签到" forState:UIControlStateDisabled];
        [_signButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [_signButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        
        _signButton.layer.cornerRadius = 17.5;
        _signButton.layer.masksToBounds = YES;
        
        
    }
    return _signButton;
}

- (UILabel*) signedLabel
{
    if (!_signedLabel) {
        _signedLabel = [[UILabel alloc] init];
        [self addSubview:_signedLabel];
        
        [_signedLabel setTextColor:[UIColor whiteColor]];
        [_signedLabel setFont:[UIFont systemFontOfSize:12]];
        
        
    }
    
    return _signedLabel;
}

- (UILabel*) signPointLabel
{
    if (!_signPointLabel) {
        _signPointLabel = [[UILabel alloc] init];
        [self addSubview:_signPointLabel];
        
        [_signPointLabel setTextColor:[UIColor whiteColor]];
        [_signPointLabel setFont:[UIFont systemFontOfSize:15]];
        
        
    }
    return _signPointLabel;
}

@end

@interface SEMainStartAttendanceViewController ()
<TaskObserver>
@property (nonatomic, strong) SEMainStartAttendanceView* attendanceView;
@end

@implementation SEMainStartAttendanceViewController


+ (void) show
{
    
    SEMainStartAttendanceViewController* attendanceViewController = [[[self class] alloc] init];
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
//    UIViewController* topmostViewController = [HMViewControllerManager topMostController] ;
    UIViewController* topmostViewController = [[HMViewControllerManager defaultManager] tvcRoot];
    [topmostViewController addChildViewController:attendanceViewController];

    [topmostViewController.view addSubview:attendanceViewController.view];
    [attendanceViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.attendanceView.closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.attendanceView.signButton addTarget:self action:@selector(signButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self loadAttendanceInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) closeButtonClicked:(id) sender
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void) signButtonClicked:(id) sender
{
//    [self signObtainPoint:5];
    NSMutableDictionary* postDictionary = [NSMutableDictionary dictionary];
    UserInfo* currentUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [postDictionary setValue:@1 forKey:@"type"];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld", currentUser.userId] forKey:@"userId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"AddPointRedemptionTask" taskParam:postDictionary TaskObserver:self];
//    [self signObtainPoint:5];
}

- (void) loadAttendanceInfo
{
    //PointRedemptionContinuationTask
    NSMutableDictionary* postDictionary = [NSMutableDictionary dictionary];
    UserInfo* currentUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [postDictionary setValue:@1 forKey:@"type"];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld", currentUser.userId] forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"PointRedemptionContinuationTask" taskParam:postDictionary TaskObserver:self];
}

- (void) signObtainPoint:(NSInteger) point
{
    [self.attendanceView.signPointLabel setText:[NSString stringWithFormat:@"+%ld", point]];
    [self.attendanceView.signButton setEnabled:NO];
    [UIView animateWithDuration:0.7 animations:^{
        self.attendanceView.signButton.layer.transform=CATransform3DMakeRotation(M_PI, 1, 0, 0);
        [self.attendanceView.signButton setTitle:@"" forState:UIControlStateNormal];
        
        
    } completion:^(BOOL finished) {
        self.attendanceView.signButton.layer.transform=CATransform3DMakeRotation(0, 1, 0, 0);
        [self signPointAnimeHandle];
    }];
    
    [self.attendanceView.signPointLabel setHidden:NO];
    
    [UIView animateWithDuration:1.5 delay:0.2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        CGPoint center = self.attendanceView.signPointLabel.center;
        center.y -= 25;
        self.attendanceView.signPointLabel.center = center;
        
    } completion:^(BOOL finished) {
        
        [self closeButtonClicked:self.attendanceView.signButton];
        [self.attendanceView.signPointLabel setHidden:YES];
    }];
}

- (void) signPointAnimeHandle
{
    [UIView animateWithDuration:0.7 animations:^{
        self.attendanceView.signButton.layer.transform=CATransform3DMakeRotation(M_PI, 1, 0, 0);
//        [self.attendanceView.signButton setEnabled:NO];
        //        [self.signButton setTitle:@"签到成功" forState:UIControlStateDisabled];
        
        
    } completion:^(BOOL finished) {
        [self.attendanceView.signButton setEnabled:NO];
        [self.attendanceView.signButton setTitle:@"签到成功" forState:UIControlStateDisabled];
        self.attendanceView.signButton.layer.transform=CATransform3DMakeRotation(0, 1, 0, 0);
        
    }];
    
    
}


- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.attendanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(114);
        make.height.mas_equalTo(@200);
        make.width.equalTo(self.view).with.offset(-30);
    }];
}

#pragma mark - settingAndGetting
- (SEMainStartAttendanceView*) attendanceView
{
    if (!_attendanceView) {
        _attendanceView = [[SEMainStartAttendanceView alloc] init];
        [self.view addSubview:_attendanceView];
        
        _attendanceView.layer.cornerRadius = 4;
        _attendanceView.layer.masksToBounds = YES;
        
        _attendanceView.layer.shadowOpacity = 0.5;// 阴影透明度
        _attendanceView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
        _attendanceView.layer.shadowRadius = 3;// 阴影扩散的范围控制
        _attendanceView.layer.shadowOffset  = CGSizeMake(1, 1);// 阴影的范围
    }
    return _attendanceView;
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (taskError != StepError_None) {
        [self showAlertMessage:errorMessage];
        return;
    }
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
            [self.attendanceView.weeklyControl setContinuityDays:attendanceModel.seriesNum lastPointDate:attendanceModel.attendanceTime];
            [self.attendanceView.signedLabel setText:[NSString stringWithFormat:@"已连续签到%ld天，累计获得积分%ld", attendanceModel.seriesNum, attendanceModel.totalScore]];

        }
        return;
    }
    
    if ([taskname isEqualToString:@"AddPointRedemptionTask"])
    {
        //签到成功
        if (taskResult && [taskResult isKindOfClass:[AttendanceSummaryModel class]]) {
            AttendanceSummaryModel* attendanceModel = (AttendanceSummaryModel*) taskResult;
            [self.attendanceView.weeklyControl setContinuityDays:attendanceModel.seriesNum lastPointDate:attendanceModel.attendanceTime];
            [self.attendanceView.signedLabel setText:[NSString stringWithFormat:@"已连续签到%ld天，累计获得积分%ld", attendanceModel.seriesNum, attendanceModel.totalScore]];
            
            [self signObtainPoint:attendanceModel.score];
        }
    }
}
@end
