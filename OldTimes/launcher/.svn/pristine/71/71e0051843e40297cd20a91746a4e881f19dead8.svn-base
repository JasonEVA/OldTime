//
//  CalendarEventMakeSureTimeSelectView.m
//  launcher
//
//  Created by William Zhang on 15/8/3.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarEventMakeSureTimeSelectView.h"
#import "UnifiedUserInfoManager.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"

/** 本身高度 */
static CGFloat height = 40;

@interface CalendarEventMakeSureTimeSelectView ()

@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *detailLabel;
/** 选择按钮 */
@property (nonatomic, strong) UIButton *checkMarkButton;
/** 又见分割线 */
@property (nonatomic, strong) UIView  *seperatorLine;

/** 点击回调 */
@property (nonatomic, copy) CalendarEvnetMakeSureTimeDidSelectBlock block;

@end

@implementation CalendarEventMakeSureTimeSelectView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToSelect)];
        [self addGestureRecognizer:tapGesture];
        
        [self initComponents];
    }
    return self;
}

- (void)initComponents
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.checkMarkButton];
    [self addSubview:self.seperatorLine];
    
    [self initConstraints];
}

- (void)initConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(13);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.titleLabel.mas_right).offset(20);
    }];
    
    [self.checkMarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-13);
        make.centerY.equalTo(self);
    }];
    
    [self.seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.equalTo(self).offset(10);
//        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-1);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
}

- (void)updateConstraints {
    [super updateConstraints];
    if (self.hideTitle) {
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(13);
            make.centerY.equalTo(self);
        }];
    }
}

#pragma mark - Button Click
- (void)clickToSelect
{
    if (self.block)
    {
        self.block(self);
    }
}

#pragma mark - Interface Method
- (void)selectStauts:(BOOL)isSelect {
    self.checkMarkButton.selected = isSelect;
}

- (void)didSelectBlock:(CalendarEvnetMakeSureTimeDidSelectBlock)block {
    self.block = block;
}

- (void)hideLine:(BOOL)hide {
    self.seperatorLine.hidden = hide;
}

- (void)startTime:(NSDate *)startTime endTime:(NSDate *)endTime wholeDay:(BOOL)wholeDay {
    NSString *str = [startTime mtc_startToEndDate:endTime wholeDay:wholeDay];
    self.detailLabel.text = str;
}

#pragma mark - Setter
- (void)setIndex:(NSInteger)index
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@%ld",  LOCAL(CALENDAR_CONFIRM_ALTERNATE),(long)index];
}

- (void)setCanSelect:(BOOL)canSelect {
    self.checkMarkButton.hidden = !canSelect;
    self.userInteractionEnabled = canSelect;
}

- (void)setHideTitle:(BOOL)hideTitle {
    _hideTitle = hideTitle;
    self.titleLabel.hidden = _hideTitle;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

#pragma mark - Initializer
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont mtc_font_26];
        _titleLabel.textColor = [UIColor minorFontColor];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel)
    {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont mtc_font_26];
        _detailLabel.textColor = [UIColor blackColor];
    }
    return _detailLabel;
}

- (UIButton *)checkMarkButton
{
    if (!_checkMarkButton) {
        _checkMarkButton = [[UIButton alloc] init];
        [_checkMarkButton setImage:[UIImage imageNamed:@"Calendar_uncheked"] forState:UIControlStateNormal];
        [_checkMarkButton setImage:[UIImage imageNamed:@"Calendar_green_check"] forState:UIControlStateSelected];
        _checkMarkButton.userInteractionEnabled = NO;
    }
    return _checkMarkButton;
}

- (UIView *)seperatorLine
{
    if (!_seperatorLine)
    {
        _seperatorLine = [[UIView alloc] init];
        _seperatorLine.backgroundColor = [UIColor borderColor];
    }
    return _seperatorLine;
}

@end
