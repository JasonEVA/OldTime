//
//  NewCalendarWeekCollectionViewCell.m
//  launcher
//
//  Created by TabLiu on 16/3/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarWeekCollectionViewCell.h"
#import "MyDefine.h"
#import <Masonry/Masonry.h>
#import "UIFont+Util.h"
#import "NSDate+MsgManager.h"
#import "DateTools.h"
#import "UIColor+Hex.h"

#define rad_color  [UIColor colorWithRed:230/255.0 green:48/255.0 blue:58/255.0 alpha:1]
#define rad_bg_color  [UIColor colorWithRed:1 green:225/255.0 blue:225/255.0 alpha:1]

#define green_color  [UIColor colorWithRed:63/255.0 green:185/255.0 blue:82/255.0 alpha:1]
#define green_bg_color  [UIColor colorWithRed:232/255.0 green:252/255.0 blue:240/255.0 alpha:1]

#define blue_bg_color  [UIColor colorWithRed:236/255.0 green:246/255.0 blue:253/255.0 alpha:1]
#define blue_color  [UIColor colorWithRed:46/255.0 green:158/255.0 blue:251/255.0 alpha:1]
#define blue_line_Color [UIColor colorWithRed:209/255.0 green:231/255.0 blue:249/255.0 alpha:1.0]


@interface NewCalendarWeekCollectionViewCell ()

@property (nonatomic,strong) UIView  * priorityView;  // 优先级
@property (nonatomic,strong) UILabel * titleLabel;    // title
@property (nonatomic,strong) UILabel * timeLabel;     // 时间 (全天 或 共几个小时)
@property (nonatomic,strong) UIImageView *lockImageView;
@property (nonatomic, strong) CAShapeLayer *borderLayer;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation NewCalendarWeekCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.priorityView];
        [self.priorityView addSubview:self.lockImageView];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.titleLabel];

//        [self.priorityView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.equalTo(self.contentView);
//            make.height.equalTo(@3);
//        }];
     [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setCellData:(NewCalendarWeeksModel *)model
{
    // 设置默认颜色 白色
    self.titleLabel.textColor = [UIColor blackColor];
    self.priorityView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
	self.lineView.hidden = YES;
	self.layer.borderColor = [UIColor whiteColor].CGColor;
	self.layer.borderWidth = 1.0;
	
    self.titleLabel.text = model.title;
    //event=事件,event_sure=待定事件,meeting=会议 company_festival 节假日
	
	[self configureLockViewHiddenWhileIsVisible:model.isVisible];
	
    if ([model.type isEqualToString:@"event"]) { // 事件
        // 绿色 -> 重要 红色
		[self setLineColor:[UIColor mtc_colorWithHex:0x22c064]];
		
        if (model.isImportant) { // 重要 红色
            self.priorityView.backgroundColor = rad_color;
        }else {
            self.priorityView.backgroundColor = green_color;
        }
        if (model.isAllDay) {
            self.contentView.backgroundColor = green_bg_color;
        }
        
    }else if ([model.type isEqualToString:@"meeting"]) { // 会议
        // 蓝色

		if (model.isCancel > 0) {
			self.priorityView.backgroundColor = [UIColor mtc_colorWithHex:0xbec6d3];
			self.contentView.backgroundColor = [UIColor mtc_colorWithHex:0xf5f6f8];
			[self setLineColor: [UIColor mtc_colorWithHex:0xbec6d3]];
			self.titleLabel.textColor = [UIColor mtc_colorWithHex:0xbec6d3];
			
		} else {
			[self setLineColor: blue_line_Color];
			self.priorityView.backgroundColor = blue_color;
			
			if (model.isAllDay) {
				self.contentView.backgroundColor = blue_bg_color;
			}
		}
		
		
    }else if ([model.type isEqualToString:@"company_festival"] || [model.type isEqualToString:@"statutory_festival"]) {
        //节假日
		[self.priorityView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.top.left.right.equalTo(self.contentView);
			make.height.equalTo(@3);
		}];
		
		self.lockImageView.hidden=YES;
        self.priorityView.backgroundColor = rad_color;
        self.titleLabel.textColor = [UIColor blackColor];
        if (model.isAllDay) {
            self.contentView.backgroundColor = rad_bg_color;
        }
        
    }else if ([model.type isEqualToString:@"event_sure"]) {
        // 待定事件
        self.priorityView.backgroundColor = model.isImportant ? rad_color : green_color;
		[self setBorderColor:[UIColor mtc_colorWithHex:0x22c064]];
    }
	
    if (model.isAllDay) {
        self.timeLabel.text = LOCAL(APPLY_ALLDAY);
    }else {
        //NSDate * date = [NSDate dateWithTimeIntervalSince1970:model.startTime/1000];
        NSString * str = [self timeStringFromlong:model.startTime];
        long long count = model.endTime - model.startTime;
        NSString * time = [NSString stringWithFormat:@"%0.1f小时",count/(1000 * 3600.0)];
        
        self.timeLabel.text =  [NSString stringWithFormat:@"%@(%@)",str,time];
    }
    [self setNeedsUpdateConstraints];
    
}

- (void)setNeedsUpdateConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priorityView.mas_bottom).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.left.equalTo(self.contentView).offset(5);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-3);
        make.left.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-6);
    }];
}
//时间戳转HH:mm
- (NSString *)timeStringFromlong:(long long)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:date/1000];
    return [dateFormatter stringFromDate:date1];
    
}

// 设置 边框的虚线 默认颜色绿色
- (void)setBorderColor:(UIColor *)color
{
	
	self.lineView.hidden = NO;
	self.lineView.frame  = CGRectOffset(self.contentView.bounds, 1, 0);
	
    CAShapeLayer *border = [CAShapeLayer layer];
    [border setStrokeColor:[color CGColor]];
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:self.lineView.bounds].CGPath;

	border.frame = self.lineView.bounds;
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
	
	self.lineView.layer.sublayers = nil;
	[self.lineView.layer addSublayer:border];
}

- (void)setLineColor:(UIColor *)lineColor {
	self.layer.borderWidth = 0.5;
	self.layer.borderColor = [lineColor CGColor];
}

- (void)configureLockViewHiddenWhileIsVisible:(BOOL)isVisible {
	if (isVisible) {
		[self.priorityView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.top.left.right.equalTo(self.contentView);
			make.height.equalTo(@3);
		}];
		self.lockImageView.hidden=YES;
		
	}else{
		[self.priorityView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.top.left.right.equalTo(self.contentView);
			make.height.equalTo(@14);
		}];
		[self.lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(self.priorityView);
			make.width.equalTo(@8);
			make.height.equalTo(@10);
		}];
		self.lockImageView.hidden=NO;
	}
	
}

#pragma mark - init

- (UIView *)priorityView
{
    if (!_priorityView) {
        _priorityView = [[UIView alloc] init];
        _priorityView.userInteractionEnabled = YES;
    }
    return _priorityView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont mtc_font_24];
        _titleLabel.userInteractionEnabled = YES;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1];
        _timeLabel.userInteractionEnabled = YES;
        _timeLabel.font = [UIFont mtc_font_20];
    }
    return _timeLabel;
}
-(UIImageView *)lockImageView
{
    if (!_lockImageView) {
        _lockImageView=[[UIImageView alloc]init];
        [_lockImageView setImage:[UIImage imageNamed:@"personLock"]];
    }
    return _lockImageView;
}

- (UIView *)lineView
{
	if (!_lineView) {
		_lineView = [[UIView alloc] init];
		_lineView.userInteractionEnabled = YES;
		_lineView.backgroundColor = [UIColor whiteColor];
	}
	return _lineView;
}

@end
