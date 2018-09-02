//
//  NewCalendarStripVIew.m
//  launcher
//
//  Created by TabLiu on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarStripVIew.h"
#import "NewCalendarWeeksModel.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

#define rad_color  [UIColor colorWithRed:230/255.0 green:48/255.0 blue:58/255.0 alpha:1]

#define green_color  [UIColor colorWithRed:63/255.0 green:185/255.0 blue:82/255.0 alpha:1]
#define green_bg_color  [UIColor colorWithRed:232/255.0 green:252/255.0 blue:240/255.0 alpha:1.0]
#define green_line_Color [UIColor colorWithRed:193/255.0 green:233/255.0 blue:209/255.0 alpha:1.0]

#define blue_bg_color  [UIColor colorWithRed:237/255.0 green:249/255.0 blue:10 alpha:1]
#define blue_color  [UIColor colorWithRed:46/255.0 green:158/255.0 blue:251/255.0 alpha:1]
#define blue_line_Color [UIColor colorWithRed:209/255.0 green:231/255.0 blue:249/255.0 alpha:1.0]


@interface NewCalendarStripVIew ()

@property (nonatomic,strong) UIView * markView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIImageView *lockImageView;


@end

@implementation NewCalendarStripVIew

- (id)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = NO;
//        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        [self addSubview:self.markView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.lockImageView];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.markView.mas_right).offset(5);
            make.right.equalTo(self).offset(-5);
        }];
    }
    return self;
}

- (void)setData:(NewCalendarWeeksModel *)model
{

    self.titleLabel.text = model.title;

    if ([model.type isEqualToString:@"event"]) { // 事件
		[self configureEventStripViewStyleWithVisible:model.isVisible isImportant:model.isImportant isAllDay:model.isAllDay];
		
    }else if ([model.type isEqualToString:@"meeting"]) { // 会议
        [self configureMeetingStripViewStyleWithVisible:model.isVisible isCancle:model.isCancel];
		
    }else if ([model.type isEqualToString:@"company_festival"] || [model.type isEqualToString:@"statutory_festival"]) { //节假日
		[self configureFestivalStripViewStyleWithAllDay:model.isAllDay];
		
    }else if ([model.type isEqualToString:@"event_sure"]) { // 待定事件
		[self configurePendingEventStripViewStyleWithVisible:model.isVisible isImportant:model.isImportant];		
    }
    
    [self updateConstraintsIfNeeded];
}

- (void)configureEventStripViewStyleWithVisible:(BOOL)isVisible isImportant:(BOOL)isImportant isAllDay:(BOOL)isAllDay {
	if (isVisible) {
		[self hideLockView];
	} else {
		[self showLockView];
	}
	
	self.markView.backgroundColor = isImportant ? rad_color : green_color;
	
	self.backgroundColor = isAllDay ? green_bg_color : [UIColor whiteColor];
	
	[self setLineColor:green_line_Color];
}

- (void)configurePendingEventStripViewStyleWithVisible:(BOOL)isVisible isImportant:(BOOL)isImportant{
	if (isVisible) {
		[self hideLockView];
	} else {
		[self showLockView];
	}
	
	self.markView.backgroundColor = isImportant ? rad_color : green_color;
	
	self.backgroundColor = [UIColor whiteColor];
	[self setBorderColor:[UIColor mtc_colorWithHex:0x22c064]];
	
}

- (void)configureMeetingStripViewStyleWithVisible:(BOOL)isVisible isCancle:(BOOL)cancled {
	if (isVisible) {
		[self hideLockView];
	}else{
		[self showLockView];
	}

    if (cancled) {
        self.backgroundColor = [UIColor mtc_colorWithHex:0xf5f6f8];
        self.markView.backgroundColor = [UIColor mtc_colorWithHex:0xbec6d3];
        [self setLineColor:[UIColor mtc_colorWithHex:0xe3e7ea]];
		self.titleLabel.textColor = [UIColor mtc_colorWithHex:0xbec6d3];
    }else
    {
        self.markView.backgroundColor = blue_color;
        [self setLineColor:blue_line_Color];
    }
	
}

- (void)configureFestivalStripViewStyleWithAllDay:(BOOL)isAllDay {
	if (isAllDay) {
		self.backgroundColor = rad_color;
		[self setLineColor:rad_color];
	}else {
		[self setBorder];
	}
	
	self.markView.hidden = YES;
	self.titleLabel.textColor = [UIColor whiteColor];
}

- (void)showLockView {
    [self.markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@12);
    }];
    [self.lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.markView);
        make.width.equalTo(@8);
        make.height.equalTo(@10);
    }];
    self.lockImageView.hidden=NO;
}

- (void)hideLockView {
    [self.markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@2);
    }];
    self.lockImageView.hidden=YES;
    
}

// 设置 边框的虚线 默认颜色绿色
- (void)setBorderColor:(UIColor *)color
{
    CAShapeLayer *border = [CAShapeLayer layer];
    [border setStrokeColor:[color CGColor]];
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    border.frame = self.bounds;
    border.lineWidth = 1.f;
    border.lineCap = @"square";
    if (color == [UIColor whiteColor])
    {
        border.lineDashPattern = nil;
    }
    else
    {
        border.lineDashPattern = @[@2, @2];
    }
    [self.layer addSublayer:border];
}

- (void)setLineColor:(UIColor *)lineColor
{
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [lineColor CGColor];
}

- (void)setBorder
{
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0] CGColor];
}

- (UIView *)markView
{
    if (!_markView) {
        _markView = [[UIView alloc] init];
        _markView.userInteractionEnabled = NO;
        _markView.clipsToBounds = YES;
    }
    return _markView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.userInteractionEnabled = NO;
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

-(UIImageView *)lockImageView
{
    if (!_lockImageView) {
        _lockImageView= [[UIImageView alloc]init];
        _lockImageView.userInteractionEnabled= NO;
        [_lockImageView setImage:[UIImage imageNamed:@"personLock"]];
    }
    return _lockImageView;
}

@end
