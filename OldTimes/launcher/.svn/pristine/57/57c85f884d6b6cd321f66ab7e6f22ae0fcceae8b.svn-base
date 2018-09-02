//
//  ATGoOutAttendanceHeadView.m
//  Clock
//
//  Created by SimonMiao on 16/7/27.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATGoOutAttendanceHeadView.h"
#import <Masonry/Masonry.h>

#import "NSString+ATConverter.h"
#import "UIColor+ATHex.h"
#import "UILabel+ATCreate.h"
#import "UIButton+AtCreate.h"

@interface ATGoOutAttendanceHeadView ()

@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIButton *clockBtn; //!<打卡
@property (nonatomic, strong) NSTimer *tickTimer;

@end

@implementation ATGoOutAttendanceHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor at_blueColor];
        [self addSubview:self.dateLab];
        [self addSubview:self.timeLab];
        [self addSubview:self.clockBtn];
        
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
    [self.clockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_greaterThanOrEqualTo(self.timeLab.mas_bottom).offset(40);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self).offset(- 30);
    }];
}

- (void)setCurrentTimestamp:(NSNumber *)currentTimestamp {
    _currentTimestamp = currentTimestamp;
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

- (void)clockBtnClicked {
    if (_block) {
        _block(_currentTimestamp);
    }
}

- (void)goOutClock:(ATGoOutAttendanceHeadViewBlock)block
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

- (UIButton *)clockBtn {
    if (!_clockBtn) {
        _clockBtn = [UIButton at_createBtnWithTitle:@"打卡" fontSize:15.0 titleColor:[UIColor whiteColor] imgName:nil bgColor:[UIColor at_blueColor] addTarget:self selector:@selector(clockBtnClicked)];
        _clockBtn.layer.cornerRadius = 3;
        _clockBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _clockBtn.layer.borderWidth = 1.0;
    }
    
    return _clockBtn;
}

@end
