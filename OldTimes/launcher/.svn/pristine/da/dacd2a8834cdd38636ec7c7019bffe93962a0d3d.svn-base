//
//  NewMonthPopTableViewCell.m
//  launcher
//
//  Created by TabLiu on 16/3/14.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMonthPopTableViewCell.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "NewCalendarWeeksModel.h"
#import "NSDate+MsgManager.h"
#import "UIColor+Hex.h"

#define rad_color  [UIColor colorWithRed:230/255.0 green:48/255.0 blue:58/255.0 alpha:1]

#define green_color  [UIColor colorWithRed:63/255.0 green:185/255.0 blue:82/255.0 alpha:1]
#define green_bg_color  [UIColor colorWithRed:63/255.0 green:185/255.0 blue:82/255.0 alpha:0.3]

#define blue_bg_color  [UIColor colorWithRed:236/255.0 green:246/255.0 blue:253/255.0 alpha:1]
#define blue_color  [UIColor colorWithRed:46/255.0 green:158/255.0 blue:251/255.0 alpha:1]
#define gray_markview_color 0xbec6d3

@interface NewMonthPopTableViewCell ()

@property (nonatomic,strong) UIView * bgView;
@property (nonatomic,strong) UIView * markView;
@property (nonatomic,strong) UIImageView *lockImageView;
@property (nonatomic,strong) UILabel * titleLabel ;
@property (nonatomic,strong) UILabel * timeLabel ;
@property (nonatomic,strong) UILabel * timeLengthLabel ;
@property (nonatomic,strong) UIImageView * iconLocationImg ;
@property (nonatomic,strong) UILabel * locationLabel;
@property (nonatomic,strong) UIView * lineView;
@end

@implementation NewMonthPopTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self coutomView];
    }
    return self;
}

- (void)setCellData:(NewCalendarWeeksModel *)model
{

    // 设置默认颜色 白色
    self.titleLabel.textColor = [UIColor blackColor];
    self.markView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = model.title;
    self.markView.hidden = NO;
    self.lineView.hidden = YES;
    if (model.place.length) {
        self.iconLocationImg.hidden = NO;
        self.locationLabel.hidden = NO;
        self.locationLabel.text = model.place;
        
    }else {
        self.iconLocationImg.hidden = YES;
        self.locationLabel.hidden = YES;
    }
    
    if (model.isVisible) {
		[self.markView mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.bgView).offset(12.5);
			make.top.bottom.equalTo(self.bgView);
			make.width.equalTo(@5);
		}];
		self.lockImageView.hidden=YES;
		
    }else{
		[self.markView mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.bgView).offset(12.5);
			make.top.bottom.equalTo(self.bgView);
			make.width.equalTo(@12);
		}];
		[self.lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(self.markView);
			make.width.equalTo(@8);
			make.height.equalTo(@10);
		}];
		self.lockImageView.hidden=NO;
		
    }
    //event=事件,event_sure=待定事件,meeting=会议 company_festival 节假日
    if ([model.type isEqualToString:@"event"]) { // 事件
               // 绿色 -> 重要 红色
        self.markView.backgroundColor = model.isImportant ? rad_color : green_color;
        
    }else if ([model.type isEqualToString:@"meeting"]) { // 会议
     // 蓝色
        
        if (model.isCancel) {
			self.markView.backgroundColor = [UIColor mtc_colorWithHex:gray_markview_color];
			self.titleLabel.textColor = [UIColor mtc_colorWithHex:gray_markview_color];
        }else
        {
            self.markView.backgroundColor = blue_color;
        }
        
    }else if ([model.type isEqualToString:@"company_festival"] || [model.type isEqualToString:@"statutory_festival"]) { //节假日
        self.markView.backgroundColor = rad_color;
        self.titleLabel.textColor = [UIColor blackColor];
    }else if ([model.type isEqualToString:@"event_sure"]) { // 待定事件

        self.markView.backgroundColor = model.isImportant ? rad_color : !model.isVisible?green_color:[UIColor whiteColor];
		[self setBorderColor:model.isImportant ? rad_color : [UIColor mtc_colorWithHex:0x22c064]];
	}
    
    if (model.isAllDay) {
        self.timeLabel.text = LOCAL(APPLY_ALLDAY);
        self.timeLengthLabel.hidden = YES;
    }else {
        self.timeLengthLabel.hidden = NO;
        self.timeLengthLabel.text = [NSDate compareTwoTime:model.startTime time2:model.endTime];
        NSString * stStr = [NSDate im_dateFormaterWithTimeInterval:model.startTime appendMinute:YES];
        NSString * endStr = [NSDate im_dateFormaterWithTimeInterval:model.endTime appendMinute:YES];
        self.timeLabel.text = [NSString stringWithFormat:@"%@~%@",stStr,endStr];
    }
    
    [self setNeedsUpdateConstraints];
}

- (void)setNeedsUpdateConstraints
{
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
//    [self.markView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bgView).offset(12.5);
//        make.top.bottom.equalTo(self.bgView);
//        make.width.equalTo(@5);
//    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.markView.mas_right).offset(10);
        make.top.equalTo(self.bgView);
        make.right.equalTo(self.bgView.mas_right).offset(-20);
        make.height.equalTo(@20);
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.timeLengthLabel.mas_left).offset(-10);
        make.height.equalTo(@20);
    }];
    [self.timeLengthLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.right.equalTo(self.bgView.mas_right).offset(-20);
        make.height.equalTo(@20);
        make.width.equalTo(@80);
    }];
    [self.iconLocationImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.bottom.equalTo(self.bgView.mas_bottom);
        make.width.equalTo(@11);
        make.height.equalTo(@14);
    }];
    
    [self.locationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconLocationImg.mas_right).offset(5);
        make.bottom.equalTo(self.bgView.mas_bottom);
        make.right.equalTo(self.bgView.mas_right).offset(-20);
//        make.width.equalTo(@20);
    }];
}


// 设置 边框的虚线 默认颜色绿色
- (void)setBorderColor:(UIColor *)color
{
//    self.markView.hidden = YES;
	CGFloat lineH = self.iconLocationImg.hidden ? 40 : 60;
	CGFloat lineW = self.lockImageView.hidden ? 5 : 12;
	
    self.lineView.hidden = NO;
    self.lineView.frame = CGRectMake(12.5, 0, lineW, lineH);
    
    CAShapeLayer *border = [CAShapeLayer layer];
    [border setStrokeColor:[color CGColor]];
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:self.lineView.bounds].CGPath;
    
    border.frame = CGRectMake(0, 0, lineW, lineH);
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
    [self.lineView.layer addSublayer:border];
}


- (void)coutomView
{
    [self.contentView addSubview:self.bgView];
	[self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.markView];
    [self.markView addSubview:self.lockImageView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.timeLengthLabel];
    [self.bgView addSubview:self.iconLocationImg];
    [self.bgView addSubview:self.locationLabel];
    [self setNeedsUpdateConstraints];
}

#pragma mark - initUI

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UIView *)markView
{
    if (!_markView) {
        _markView = [[UIView alloc] init];
    }
    return _markView;
}

-(UIImageView *)lockImageView
{
    if (!_lockImageView) {
        _lockImageView=[[UIImageView alloc]init];
        [_lockImageView setImage:[UIImage imageNamed:@"personLock"]];
    }
    return _lockImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1];
    }
    return _timeLabel;
}
- (UILabel *)timeLengthLabel
{
    if (!_timeLengthLabel) {
        _timeLengthLabel = [[UILabel alloc] init];
        _timeLengthLabel.textAlignment = NSTextAlignmentRight;
        _timeLengthLabel.font = [UIFont systemFontOfSize:13];
        _timeLengthLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1];
    }
    return _timeLengthLabel;
}
- (UIImageView *)iconLocationImg
{
    if (!_iconLocationImg) {
        _iconLocationImg = [[UIImageView alloc] init];
        _iconLocationImg.userInteractionEnabled = YES;
        _iconLocationImg.image = [UIImage imageNamed:@"pointer"];
    }
    return _iconLocationImg;
}
- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.font = [UIFont systemFontOfSize:13];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1];
    }
    return _locationLabel;
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
