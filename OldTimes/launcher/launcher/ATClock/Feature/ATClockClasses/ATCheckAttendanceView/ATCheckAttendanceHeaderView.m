//
//  ATCheckAttendanceHeaderView.m
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATCheckAttendanceHeaderView.h"
#import <Masonry/Masonry.h>

#import "NSString+ATConverter.h"

@interface ATCheckAttendanceHeaderView ()

@property (nonatomic, strong) UIButton *punchCardBtn;
@property (nonatomic, strong) NSTimer *tickTimer;

@end

@implementation ATCheckAttendanceHeaderView

- (UIButton *)punchCardBtn {
    if (!_punchCardBtn) {
        _punchCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_punchCardBtn setTitle:@"00:00" forState:UIControlStateNormal];
        [_punchCardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_punchCardBtn setBackgroundImage:[UIImage imageNamed:@"img_checkAttendance_punchCard"] forState:UIControlStateNormal];
        [_punchCardBtn addTarget:self action:@selector(punchCardBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _punchCardBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.punchCardBtn];
        [self initConstraints];
    }
    return self;
}

- (void)initConstraints {
    [self.punchCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(40);
        make.centerX.mas_equalTo(self);
        make.width.height.mas_equalTo(160);
    }];
}

- (void)setCurrentTimestamp:(NSNumber *)currentTimestamp {
    _currentTimestamp = currentTimestamp;
    
    if (!self.tickTimer) {
        self.tickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tickTimerClicked) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:self.tickTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)setIsDesignatedArea:(BOOL)isDesignatedArea {
    _isDesignatedArea = isDesignatedArea;
    if (_isDesignatedArea) {
        [self.punchCardBtn setBackgroundImage:[UIImage imageNamed:@"img_checkAttendance_punchCard"] forState:UIControlStateNormal];
        self.punchCardBtn.enabled = YES;
    } else {
        [self.punchCardBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.punchCardBtn setBackgroundColor:[UIColor lightGrayColor]];
        self.punchCardBtn.enabled = NO;
    }
}

- (void)setBgImage:(UIImage *)bgImage {
    
}

- (void)tickTimerClicked
{
    long long  currentTime = _currentTimestamp.longLongValue;
    currentTime += 1000;
    _currentTimestamp = [NSNumber numberWithLongLong:currentTime];
    NSString *dateStr = [NSString at_getFormatterDateStrWithFormatterStr:@"HH:mm" timeStamp:_currentTimestamp];
    
    [self.punchCardBtn setTitle:dateStr forState:UIControlStateNormal];
}

- (void)punchCardBtnClicked
{
    if (_block) {
        _block(_currentTimestamp);
    }
}

- (void)headerViewOfPunchCardBtnClicked:(ATCheckAttendanceHeaderViewBlock)block
{
    _block = block;
}

@end
