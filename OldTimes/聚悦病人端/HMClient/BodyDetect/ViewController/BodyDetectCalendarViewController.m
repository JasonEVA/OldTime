//
//  BodyDetectCalendarViewController.m
//  HMClient
//
//  Created by yinquan on 2017/7/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BodyDetectCalendarViewController.h"

@interface BodyDetectIntegralCalendarHubView ()

@property (nonatomic, strong) UILabel* ruleLabel;

@end

@implementation BodyDetectIntegralCalendarHubView

- (UILabel*) ruleLabel
{
    if (!_ruleLabel) {
        _ruleLabel = [[UILabel alloc] init];
        [self addSubview:_ruleLabel];
        
        [_ruleLabel setFont:[UIFont systemFontOfSize:12]];
        [_ruleLabel setTextColor:[UIColor whiteColor]];
        [_ruleLabel setText:@"注：提交记录健康一次10分，每日上限10分，连续记录7天另加20分，14天另加30分，21天另加40分，28天另加50分。"];
        [_ruleLabel setNumberOfLines:0];
    }
    return _ruleLabel;
}

- (void) layoutElements
{
    [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self).insets(UIEdgeInsetsMake(60, 25, 25, 20));
        make.left.equalTo(self).offset(25);
        make.top.equalTo(self).offset(60);
        make.right.equalTo(self).offset(-25);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        
        make.top.equalTo(self).with.offset(9);
        make.right.equalTo(self).with.offset(-9);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(25);
        make.top.equalTo(self).with.offset(20);
    }];
    
    [self.ruleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.calendarView);
        make.centerX.equalTo(self);
        make.top.equalTo(self.calendarView.mas_bottom).offset(15);
        make.bottom.equalTo(self).offset(-15);
    }];
    
}

@end

@interface BodyDetectCalendarViewController ()
<TaskObserver>
{
    NSArray* attendanceModels;
}
@end

@implementation BodyDetectCalendarViewController

@synthesize hubView = _hubView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString* monthString = [self.monthDate formattedDateWithFormat:@"yyyy-MM-01"];
    
    [self loadPointRedemptionRecords:monthString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadPointRedemptionRecords:(NSString*) monthString
{
    [super loadPointRedemptionRecords:monthString];
    
    NSMutableDictionary* postDictionary = [NSMutableDictionary dictionary];
    [postDictionary setValue:@2 forKey:@"type"];
    UserInfo* currentUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld", currentUser.userId] forKey:@"userId"];
    //    NSString* dateString = [[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd"];
    [postDictionary setValue:monthString forKey:@"date"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"PointRedemptionMonthlyRecordTask" taskParam:postDictionary TaskObserver:self];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
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
    if ([taskname isEqualToString:@"PointRedemptionMonthlyRecordTask"])
    {
        if (taskError != StepError_None) {
            [self showAlertMessage:errorMessage];
            return;
        }
        
        NSString* monthString = [self.monthDate formattedDateWithFormat:@"yyyy-MM"];
        
        [self setMonthlyPointRecordModels:attendanceModels];
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
    if ([taskname isEqualToString:@"PointRedemptionMonthlyRecordTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* models = (NSArray*) taskResult;
            //            [self setMonthlyPointRecordModels:models];
            attendanceModels = models;
        }
        
    }
}

#pragma gettingAndSetting
- (PointRedemptionCalendarHubView*) hubView
{
    if (!_hubView) {
        _hubView = [[BodyDetectIntegralCalendarHubView alloc] init];
        [self.view addSubview:_hubView];
        
        _hubView.layer.shadowOpacity = 0.5;// 阴影透明度
        _hubView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
        _hubView.layer.shadowRadius = 3;// 阴影扩散的范围控制
        _hubView.layer.shadowOffset  = CGSizeMake(1, 1);// 阴影的范围
    }
    return _hubView;
}
@end
