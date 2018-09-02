//
//  HealthRecodUpLoadSuccessView.m
//  HMClient
//
//  Created by jasonwang on 2016/12/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthRecodUpLoadSuccessView.h"
#import "AttendanceSummaryModel.h"

@interface HealthRecodUpLoadSuccessView ()
<TaskObserver>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *successLb;
@property (nonatomic, strong) UILabel *serviceNameLb;
@property (nonatomic, strong) UILabel* pointObtainLabel;
//倒计时
@property (nonatomic) NSInteger secondsCoundDown;
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, copy)   NSMutableString *time;
@property (nonatomic, copy) successViewBlock block;
@end

@implementation HealthRecodUpLoadSuccessView
- (instancetype)init {
    if (self = [super init]) {
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.serviceNameLb];
        [self.contentView addSubview:self.successLb];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
        }];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(45);
            make.centerX.equalTo(self.contentView);
        }];
        
        [self.serviceNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconView.mas_bottom).offset(25);
            make.centerX.equalTo(self.contentView);
        }];
        
        [self.pointObtainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.serviceNameLb.mas_bottom).with.offset(11);
            make.centerX.equalTo(self.contentView);
        }];
        
        [self.successLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pointObtainLabel.mas_bottom).offset(15);
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-45);
        }];
        
        
    }
    return self;
}

- (void)showSuccessView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
//    self.secondsCoundDown = 3;
//    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    //获取记录健康的积分奖励
    
    NSMutableDictionary* postDictionary = [NSMutableDictionary dictionary];
    UserInfo* currentUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [postDictionary setValue:@2 forKey:@"type"];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld", currentUser.userId] forKey:@"userId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"AddPointRedemptionTask" taskParam:postDictionary TaskObserver:self];
}

- (void) startCountDown
{
    self.secondsCoundDown = 3;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}

//倒计时方法，
- (void)timeFireMethod
{
    self.secondsCoundDown --;
    //更新按钮倒计时时间
    self.time = [NSMutableString stringWithFormat:@"%lds后跳转",(long)self.secondsCoundDown];
    [self.successLb setText:self.time];
    
    if (self.secondsCoundDown == 0) {
        [self killTimer];
        [self removeFromSuperview];
        if (self.block) {
            self.block();
        }
    }
    
    
}
- (void)killTimer
{
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
    //设置按钮可点击
    self.secondsCoundDown = 3;
    [self.successLb setText:@"3s后跳转"];
}

- (void)jumpToNextStep:(successViewBlock)block {
    self.block = block;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView.layer setCornerRadius:4];
        [_contentView setClipsToBounds:YES];
    }
    return _contentView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pingan_paysuccess"]];
    }
    return _iconView;
}

- (UILabel *)successLb {
    if (!_successLb) {
        _successLb = [UILabel new];
        [_successLb setText:@"3s后跳转"];
        [_successLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_successLb setFont:[UIFont font_30]];
    }
    return _successLb;
}

- (UILabel *)serviceNameLb {
    if (!_serviceNameLb) {
        _serviceNameLb = [UILabel new];
        [_serviceNameLb setText:@"数据上传成功"];
        [_serviceNameLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_serviceNameLb setFont:[UIFont font_36]];
    }
    return _serviceNameLb;
}

- (UILabel*) pointObtainLabel
{
    if (!_pointObtainLabel) {
        _pointObtainLabel = [UILabel new];
        [self addSubview:_pointObtainLabel];
        
        [_pointObtainLabel setTextColor:[UIColor mainThemeColor]];
        [_pointObtainLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _pointObtainLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
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
    if ([taskname isEqualToString:@"AddPointRedemptionTask"])
    {
        [self startCountDown];
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
    if ([taskname isEqualToString:@"AddPointRedemptionTask"])
    {
        AttendanceSummaryModel* attendanceModel = (AttendanceSummaryModel*) taskResult;
        [self.pointObtainLabel setText:[NSString stringWithFormat:@"积分奖励：本次您已获取%ld积分", attendanceModel.score]];
        
    }
}


@end
