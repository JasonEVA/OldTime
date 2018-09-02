//
//  NewMissionTimeSelectView.m
//  launcher
//
//  Created by jasonwang on 16/2/16.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMissionTimeSelectView.h"
#import "UnifiedUserInfoManager.h"
#import "UIColor+Hex.h"
#import "Masonry.h"
#import "UIView+Util.h"
#import "UIButton+DeterReClicked.h"
#import "MyDefine.h"
#import <DateTools/DateTools.h>
@interface NewMissionTimeSelectView()

/**
 *  容器view
 */
@property (nonatomic, strong) UIView *contentView;
/**
 *  取消按钮
 */
@property (nonatomic, strong) UIButton *btnCancel;
/**
 *  时间选择器
 */
@property(nonatomic, strong) UIDatePicker  *datePicer;
/**
 *  右上角的确认按钮
 */
@property(nonatomic, strong) UIButton *deadLineokBtn;

@property(nonatomic, strong) NSDate *deadlineDate;

@property (nonatomic, strong) UILabel *wholeDayLabel;
@property (nonatomic, strong) UISwitch *wholeDaySwitch;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UIButton *noSelectTime;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSDate *minDate;

@end

@implementation NewMissionTimeSelectView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [self addSubview:self.contentView];
        [self initComponents];
    }
    return  self;
}

- (void)initComponents
{
    [self.contentView addSubview:self.titelLb];
    [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(20);
    }];
    
    [self.contentView addSubview:self.deadLineokBtn];
    [self.deadLineokBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.titelLb);
    }];
    [self.contentView addSubview:self.btnCancel];
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.titelLb);
    }];

    [self.contentView addSubview:self.datePicer];
    [self.datePicer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(150);
        make.top.equalTo(self.titelLb).offset(30);
    }];
    
    [self.contentView addSubview:self.wholeDaySwitch];
    [self.wholeDaySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.contentView).offset(10);
    }];
    
    [self.contentView addSubview:self.wholeDayLabel];
    [self.wholeDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wholeDaySwitch.mas_right).offset(10);
        make.centerY.equalTo(self.wholeDaySwitch);
    }];
    
    [self.contentView addSubview:self.noSelectTime];
    [self.noSelectTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.datePicer.mas_bottom);
    }];
    
}

#pragma mark - Interface Method

- (void)setDate:(NSDate *)date {
    [self.datePicer setDate:date animated:NO];
}

- (void)wholeDayIsOn:(BOOL)isOn {
    [self.wholeDaySwitch setOn:isOn];
    [self switchValueChanged:self.wholeDaySwitch];
}

- (void)setMyMaxDate:(NSDate *)MaxDate MinDate:(NSDate *)MinDate
{
    [self.datePicer setMaximumDate:MaxDate];
    [self.datePicer setMinimumDate:MinDate];
    
}
//设置标题和某一天或不设置
- (void)setTitle:(NSString *)title noSelect:(NSString *)noSelect{
    [self.titelLb setText:title];
    [self.noSelectTime setTitle:noSelect forState:UIControlStateNormal];
}

#pragma mark - Private Method
- (void)switchValueChanged:(UISwitch *)aSwitch {
    if (aSwitch.isOn) {
        [self.datePicer setDatePickerMode:UIDatePickerModeDate];
        self.datePicer.minimumDate = [NSDate date];
    }
    else {
        [self.datePicer setDatePickerMode:UIDatePickerModeDateAndTime];
    }
    
    [self.datePicer setDate:[self.datePicer date] animated:NO];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.contentView.frame = CGRectMake(5, self.frame.size.height, self.frame.size.width - 10, 280);
    [window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.contentView.frame = CGRectMake(5, self.frame.size.height - 280 - 55, self.frame.size.width - 10, 280);
    } completion:^(BOOL finished) {
        self.contentView.frame = CGRectMake(5, self.frame.size.height - 280 - 55, self.frame.size.width - 10, 280);
    }];
}

- (void)dismiss:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(NewMissionTimeSelectViewDelegateCallBack_isWholeDay:)]) {
        [self.delegate NewMissionTimeSelectViewDelegateCallBack_isWholeDay:self.wholeDaySwitch.on];
    }
    //按钮暴力点击防御
    [self.deadLineokBtn mtc_deterClickedRepeatedly];
    
    if ([self.delegate respondsToSelector:@selector(NewMissionTimeSelectView:didSelectDate:)])
    {
        NSDate *date;
        if (btn.tag == 0) {
            date = nil;
        } else {
            //防止在选择无的情况下进入本界面然后直接点击确认出现1970的时间数据
            date = [[self.datePicer date] year] != 1970?[self.datePicer date]:[NSDate date];
        }
        [self.delegate NewMissionTimeSelectView:self didSelectDate:date];
    }
    
    [self removeFromSuperview];
}


- (void)remove
{
    //按钮暴力点击防御
    [self.btnCancel mtc_deterClickedRepeatedly];
    
    if ([self.delegate respondsToSelector:@selector(NewMissionTimeSelectViewDelegateCallBack_closeDeadlineSwitch)]) {
        [self.delegate NewMissionTimeSelectViewDelegateCallBack_closeDeadlineSwitch];
    }
    [self removeFromSuperview];
}

#pragma mark - Setter
- (void)setShowWholeDayMode:(BOOL)showWholeDayMode {
    [self.wholeDayLabel setHidden:!showWholeDayMode];
    [self.wholeDaySwitch setHidden:!showWholeDayMode];
}

#pragma mark -initilizer

- (UIButton *)btnCancel
{
    if (!_btnCancel)
    {
        _btnCancel = [[UIButton alloc] init];
        [_btnCancel setTitle:LOCAL(CANCEL) forState:UIControlStateNormal];
        [_btnCancel setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCancel;
}

- (UIView *)contentView {
    if (!_contentView)
    {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(5, self.frame.size.height - 230 - 55 - 65, self.frame.size.width - 10, 280)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5.0;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIDatePicker *)datePicer
{
    if (!_datePicer)
    {
        _datePicer = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        _datePicer.datePickerMode = UIDatePickerModeDate;
        [_datePicer setMinimumDate:[NSDate date]];
        [_datePicer setLocale:[[UnifiedUserInfoManager share] getLocaleIdentifier]];
    }
    return _datePicer;
}

- (UIButton *)deadLineokBtn
{
    if (!_deadLineokBtn)
    {
        _deadLineokBtn = [[UIButton alloc] init];
        [_deadLineokBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        [_deadLineokBtn setTitle:LOCAL(CERTAIN) forState:UIControlStateNormal];
        [_deadLineokBtn setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
        [_deadLineokBtn setTag:1];
//        [_deadLineokBtn setBackgroundImage:[[UIImage imageNamed:@"Calendar_check"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    return _deadLineokBtn;
}

#pragma mark - Private Method

- (UILabel *)wholeDayLabel {
    if (!_wholeDayLabel) {
        _wholeDayLabel = [UILabel new];
        _wholeDayLabel.text = LOCAL(APPLY_ALLDAY);
        _wholeDayLabel.font = [UIFont systemFontOfSize:18];
    }
    return _wholeDayLabel;
}

- (UISwitch *)wholeDaySwitch {
    if (!_wholeDaySwitch) {
        _wholeDaySwitch = [UISwitch new];
        [_wholeDaySwitch setOn:YES];
        [_wholeDaySwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_wholeDaySwitch setOnTintColor:[UIColor themeBlue]];
    }
    return _wholeDaySwitch;
}

- (UILabel *)titelLb
{
    if (!_titelLb) {
        _titelLb = [UILabel new];
        _titelLb.font = [UIFont systemFontOfSize:18];
    }
    return _titelLb;
}

- (UIButton *)noSelectTime
{
    if (!_noSelectTime) {
        _noSelectTime = [[UIButton alloc] init];
        [_noSelectTime addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        [_noSelectTime setTitle:LOCAL(NEWMISSION_ONEDAY) forState:UIControlStateNormal];
        [_noSelectTime setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
        [_noSelectTime setTag:0];
    }
    return _noSelectTime;
}


@end
