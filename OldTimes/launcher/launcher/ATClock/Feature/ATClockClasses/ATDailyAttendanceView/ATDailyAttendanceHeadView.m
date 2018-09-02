//
//  ATDailyAttendanceHeadView.m
//  Clock
//
//  Created by SimonMiao on 16/7/26.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATDailyAttendanceHeadView.h"
#import <Masonry/Masonry.h>

#import "NSString+ATConverter.h"
#import "UIColor+ATHex.h"
#import "UILabel+ATCreate.h"
#import "UIButton+AtCreate.h"

@interface ATDailyAttendanceHeadView ()

@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIButton *clockInBtn; //!<上班打卡
@property (nonatomic, strong) UIButton *clockOutBtn; //!<下班打卡
@property (nonatomic, strong) NSTimer *tickTimer;

@end

@implementation ATDailyAttendanceHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor at_blueColor];
        _enbleClockInBtn = YES;
        [self addSubview:self.dateLab];
        [self addSubview:self.timeLab];
        [self addSubview:self.clockInBtn];
        [self addSubview:self.clockOutBtn];
        
        [self initConstraints];
    }
    return self;
}

- (void)initConstraints
{
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(10);
        make.centerX.mas_equalTo(self);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateLab.mas_bottom).offset(25);
        make.centerX.mas_equalTo(self.dateLab);
    }];
    [self.clockInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_greaterThanOrEqualTo(self.timeLab.mas_bottom).offset(40);
        make.right.mas_equalTo(self.mas_centerX).offset(- 28);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self).offset(- 30);
    }];
    [self.clockOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.bottom.mas_equalTo(self.clockInBtn);
        make.left.mas_equalTo(self.mas_centerX).offset(28);
    }];
}

- (void)setEnbleClockInBtn:(BOOL)enbleClockInBtn {
    _enbleClockInBtn = enbleClockInBtn;
    self.clockInBtn.enabled = enbleClockInBtn;
    self.clockInBtn.alpha = 0.3;
}

- (void)setCurrentTimestamp:(NSNumber *)currentTimestamp {
    _currentTimestamp = currentTimestamp;
    //移除计时器
    if (self.tickTimer) {
        [self.tickTimer invalidate];
        self.tickTimer = nil;
    }
    if (!self.tickTimer) {
        self.tickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tickTimerClicked) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:self.tickTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)tickTimerClicked
{
    long long  currentTime = _currentTimestamp.longLongValue;
    currentTime += 1000;
    _currentTimestamp = [NSNumber numberWithLongLong:currentTime];
    NSString *dateStr = [NSString at_getFormatterDateStrWithFormatterStr:@"yyyy年MM月dd日 E" timeStamp:_currentTimestamp];
    self.dateLab.text = dateStr;
    NSString *timeStr = [NSString at_getFormatterDateStrWithFormatterStr:@"HH:mm" timeStamp:_currentTimestamp];
    self.timeLab.text = timeStr;
}

- (void)clockBtnClicked:(UIButton *)btn {
    if (_block) {
        _block(btn.tag - 10000,_currentTimestamp);
    }
}

- (void)dailyClock:(ATDailyAttendanceHeadViewBlock)block
{
    _block = block;
}

- (UILabel *)dateLab {
    if (!_dateLab) {
        _dateLab = [UILabel at_createLabWithText:@"" fontSize:15.0 titleColor:[UIColor whiteColor]];
    }
    
    return _dateLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [UILabel at_createLabWithText:@"" fontSize:40.0 titleColor:[UIColor whiteColor]];
    }
                    
    return _timeLab;
}

- (UIButton *)clockInBtn {
    if (!_clockInBtn) {
        _clockInBtn = [UIButton at_createBtnWithTitle:@"上班打卡" fontSize:15.0 titleColor:[UIColor whiteColor] imgName:nil bgColor:[UIColor at_blueColor] addTarget:self selector:@selector(clockBtnClicked:)];
        _clockInBtn.tag = 10000;
        _clockInBtn.layer.cornerRadius = 3;
        _clockInBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _clockInBtn.layer.borderWidth = 1.0;
    }
    
    return _clockInBtn;
}

- (UIButton *)clockOutBtn {
    if (!_clockOutBtn) {
        _clockOutBtn = [UIButton at_createBtnWithTitle:@"下班打卡" fontSize:15.0 titleColor:[UIColor whiteColor] imgName:nil bgColor:[UIColor at_blueColor] addTarget:self selector:@selector(clockBtnClicked:)];
        _clockOutBtn.tag = 10001;
        _clockOutBtn.layer.cornerRadius = 3;
        _clockOutBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _clockOutBtn.layer.borderWidth = 1.0;
    }
    
    return _clockOutBtn;
}

@end
