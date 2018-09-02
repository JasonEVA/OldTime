//
//  ApplyAddDeadlineActionSheetView.m
//  launcher
//
//  Created by Kyle He on 15/8/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyAddDeadlineActionSheetView.h"
#import "UnifiedUserInfoManager.h"
#import "UIColor+Hex.h"
#import "Masonry.h"
#import "UIView+Util.h"
#import "UIButton+DeterReClicked.h"
#import "MyDefine.h"

@interface ApplyAddDeadlineActionSheetView()

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

@end

@implementation ApplyAddDeadlineActionSheetView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [self addSubview:self.contentView];
        [self addSubview:self.btnCancel];
        
        [self initComponents];
    }
    return  self;
}

- (void)initComponents
{
    [self.contentView addSubview:self.datePicer];
    [self.datePicer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(80);
    }];
    
    [self.contentView addSubview:self.deadLineokBtn];
    [self.deadLineokBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.contentView addSubview:self.wholeDayLabel];
    [self.wholeDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.contentView addSubview:self.wholeDaySwitch];
    [self.wholeDaySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wholeDayLabel).offset(-7);
        make.left.equalTo(self.wholeDayLabel.mas_right).offset(10);
    }];
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
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.contentView.frame = CGRectMake(5, self.frame.size.height, self.frame.size.width - 10, 230);
    self.btnCancel.frame = CGRectMake(5, self.frame.size.height +230, self.frame.size.width - 10, 50);
    [window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.contentView.frame = CGRectMake(5, self.frame.size.height - 230 - 55, self.frame.size.width - 10, 230);
        self.btnCancel.frame = CGRectMake(5, self.frame.size.height - 50, self.frame.size.width - 10, 50);
    } completion:^(BOOL finished) {
        self.contentView.frame = CGRectMake(5, self.frame.size.height - 230 - 55, self.frame.size.width - 10, 230);
        self.btnCancel.frame = CGRectMake(5, self.frame.size.height - 50, self.frame.size.width - 10, 50);
    }];
}

- (void)dismiss
{
    //按钮暴力点击防御
    [self.deadLineokBtn mtc_deterClickedRepeatedly];

    if ([self.delegate respondsToSelector:@selector(ApplyAddDeadlineActionSheetViewDelegateCallBack_date:)])
    {
        [self.delegate ApplyAddDeadlineActionSheetViewDelegateCallBack_date:[self.datePicer date]];
    }
    
    if ([self.delegate respondsToSelector:@selector(ApplyAddDeadlineActionSheetViewDelegateCallBack_isWholeDay:)]) {
        [self.delegate ApplyAddDeadlineActionSheetViewDelegateCallBack_isWholeDay:self.wholeDaySwitch.on];
    }
    
    if ([self.delegate respondsToSelector:@selector(ApplyAddDeadlineActionSheetViewDelegateCallBack_date:isWholeDay:)])
    {
        [self.delegate ApplyAddDeadlineActionSheetViewDelegateCallBack_date:[self.datePicer date] isWholeDay:self.wholeDaySwitch.on];
    }
    
    
    [self removeFromSuperview];
}

- (void)remove
{
    //按钮暴力点击防御
    [self.btnCancel mtc_deterClickedRepeatedly];
    
    if ([self.delegate respondsToSelector:@selector(ApplyAddDeadlineActionSheetViewDelegateCallBack_closeDeadlineSwitch)]) {
        [self.delegate ApplyAddDeadlineActionSheetViewDelegateCallBack_closeDeadlineSwitch];
    }
    [self removeFromSuperview];
}

- (void)showWholeDay:(BOOL)showWholeDay {
    self.wholeDaySwitch.on = showWholeDay;
    [self switchValueChanged:self.wholeDaySwitch];
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
        _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(5, self.frame.size.height - 50 - 65, self.frame.size.width - 10, 50)];
        _btnCancel.layer.cornerRadius = 4.0f;
        _btnCancel.backgroundColor = [UIColor whiteColor];
        [_btnCancel setTitle:LOCAL(CANCEL) forState:UIControlStateNormal];
        [_btnCancel setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
        _btnCancel.clipsToBounds = YES;
    }
    return _btnCancel;
}

- (UIView *)contentView {
    if (!_contentView)
    {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(5, self.frame.size.height - 230 - 55 - 65, self.frame.size.width - 10, 230)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5.0;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

-(UIDatePicker *)datePicer
{
    if (!_datePicer)
    {
        _datePicer = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        _datePicer.datePickerMode = UIDatePickerModeDate;
        [_datePicer setMinimumDate:[NSDate date]];
		[_datePicer setDate:[NSDate date]];		
        [_datePicer setLocale:[[UnifiedUserInfoManager share] getLocaleIdentifier]];
    }
    return _datePicer;
}

- (UIButton *)deadLineokBtn
{
    if (!_deadLineokBtn)
    {
        _deadLineokBtn = [[UIButton alloc] init];
        _deadLineokBtn.expandSize = CGSizeMake(5, 5);
        [_deadLineokBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_deadLineokBtn setBackgroundImage:[[UIImage imageNamed:@"Calendar_check"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    return _deadLineokBtn;
}

#pragma mark - Private Method

- (UILabel *)wholeDayLabel {
    if (!_wholeDayLabel) {
        _wholeDayLabel = [UILabel new];
        _wholeDayLabel.text = LOCAL(APPLY_ALLDAY);
        _wholeDayLabel.font = [UIFont systemFontOfSize:15];
    }
    return _wholeDayLabel;
}

- (UISwitch *)wholeDaySwitch {
    if (!_wholeDaySwitch) {
        _wholeDaySwitch = [UISwitch new];
        [_wholeDaySwitch setOn:YES];
        [_wholeDaySwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _wholeDaySwitch;
}




@end
