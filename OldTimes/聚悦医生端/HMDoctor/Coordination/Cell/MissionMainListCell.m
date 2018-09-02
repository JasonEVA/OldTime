//
//  MissionMainListCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionMainListCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

#import "NSDate+String.h"
#define FinishColor [UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1]

@interface MissionMainListCell ()
@property (nonatomic,strong) UIButton * iconMarkButton; // 已完成未完成操作的按钮
@property (nonatomic,strong) UILabel * titleLabel; // title
@property (nonatomic,strong) UILabel * timeLabel;

// 优先级
@property (nonatomic,strong) UIView * priorityView ;

@property(nonatomic, copy) changeMissionStateCallBackBlock  myblock;

@end

@implementation MissionMainListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self configElements];
    }
    return self;
}

#pragma mark -- interfaceMethod
- (void)setCellDataWithModel:(MissionDetailModel *)model withType:(MissionType)type
{
    if (type == MissionType_Today || type == MissionType_All || type == MissionType_Tomorrow) //只有这个才有复选框
    {
        self.iconMarkButton.hidden = NO;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconMarkButton.mas_right).offset(10);
            make.bottom.equalTo(self.contentView.mas_centerY);
            make.height.equalTo(@30);
            make.width.lessThanOrEqualTo(@([ [ UIScreen mainScreen ] bounds ].size.width - 200));
        }];
        
    }else
    {
        self.iconMarkButton.hidden = YES;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.bottom.equalTo(self.contentView.mas_centerY).offset(5);
            make.height.equalTo(@30);
            make.width.lessThanOrEqualTo(@([ [ UIScreen mainScreen ] bounds ].size.width - 200));
        }];
    }
    [self.titleLabel setText:model.taskTitle];
    [self setPriority:model.taskPriority];
    [self.timeLabel setText:[self getTimeStrWithModel:model]];
    [self changState:model.taskStatus];
    [self updateConstraints];
}

- (void)finishedCallBlock:(changeMissionStateCallBackBlock)block 
{
    self.myblock = block;
}

#pragma mark -private method

- (NSString *)getTimeStrWithModel:(MissionDetailModel *)model
{
    NSString *startTime = [self handleTimeFormatWithStr:model.startTime AllDay:model.isStartAllDay];
    NSString *endTime = [self handleTimeFormatWithStr:model.endTime AllDay:model.isEndAllDay];
    return [NSString stringWithFormat:@"%@ ~ %@",startTime,endTime];
}

- (NSString *)handleTimeFormatWithStr:(NSString *)timeStr AllDay:(BOOL)isAllDay
{
    if (timeStr.length)
    {
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSArray *timeCompnentArray = [timeStr componentsSeparatedByString:@" "];
        NSString *tempStr = [timeStr substringFromIndex:4];
        NSMutableString *mutableStr;
        if (timeCompnentArray.count == 2)
        {
            mutableStr = [[tempStr substringToIndex:[tempStr length] - 3] mutableCopy];
        }
        [mutableStr insertString:@"/" atIndex:2];
        if (isAllDay) {
            return [mutableStr substringToIndex:5];
        }
    
        return mutableStr;
    }
    return @"";
}

- (void)configElements {
    [self.contentView addSubview:self.iconMarkButton];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.priorityView];
    // 优先级
    [self.priorityView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@5);
    }];
    
    // 是否完成
    [self.iconMarkButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priorityView).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconMarkButton.mas_right).offset(10);
        make.bottom.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@30);
        make.width.lessThanOrEqualTo(@([ [ UIScreen mainScreen ] bounds ].size.width - 200));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.titleLabel);
    }];


}

- (void)changState:(TaskStatusType)status
{
    switch (status) {
        case TaskStatusTypeAll: {
            break;
        }
        case TaskStatusTypeDeleted: {
            break;
        }
        case TaskStatusTypeDisabled: {
            
            break;
        }
        case TaskStatusTypeNonActivated: {
            [self.iconMarkButton setSelected:NO];
            [self.titleLabel setTextColor:[UIColor blackColor]];
            break;
        }
        case TaskStatusTypeActivated: {
            
            break;
        }
        case TaskStatusTypeExpired: {
            
            break;
        }
        case TaskStatusTypeDone: {
            [self.iconMarkButton setSelected:YES];
            [self.titleLabel setTextColor:FinishColor];
            [self.titleLabel setTextColor:[UIColor blackColor]];

            break;
        }
    }
}



- (void)setPriority:(MissionTaskPriority)priority {
    NSString *priorityString = @"";
    UIColor *color;
    switch (priority) {
        case MissionTaskPriorityLow:
            color = [UIColor colorWithHex:0xccccccc];
            priorityString = @"低";
            break;
        case MissionTaskPriorityMid:
            color = [UIColor colorWithHex:0xffac4f];
            priorityString = @"中";
            break;
        case MissionTaskPriorityHigh:
            color = [UIColor colorWithHex:0xff3366];
            priorityString = @"高";
            break;
        case MissionTaskPriorityNone:
            color = [UIColor clearColor];
            priorityString = @"";
            break;
    }
    self.priorityView.backgroundColor = color;
}

#pragma mark - event Response
- (void)iconMarkButtonClick:(UIButton *)sender
{
    if (sender.selected) {return;}
    
//    self.iconMarkButton.selected ^=1;
//    [self changState:self.iconMarkButton.selected];
    if (self.myblock){
        self.myblock(self.iconMarkButton, self);
    }
}

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - updateViewConstraints

#pragma mark - init UI
- (UIButton *)iconMarkButton
{
    if (!_iconMarkButton) {
        _iconMarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconMarkButton addTarget:self action:@selector(iconMarkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_iconMarkButton setImage:[UIImage imageNamed:@"Mission_UNMark"] forState:UIControlStateNormal];
        [_iconMarkButton setImage:[UIImage imageNamed:@"Mission_Mark"] forState:UIControlStateSelected];
    }
    return _iconMarkButton;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_titleLabel setText:@""];
        [_timeLabel setTextColor:[UIColor commonBlackTextColor_333333]];

    }
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _timeLabel.textColor = [UIColor commonLightGrayColor_999999];
        _timeLabel.font = [UIFont systemFontOfSize:13.0];
        [_timeLabel setText:@""];
    }
    return _timeLabel;
}

- (UIView *)priorityView
{
    if (!_priorityView) {
        _priorityView = [[UIView alloc] init];
        _priorityView.userInteractionEnabled = YES;
        [_priorityView setBackgroundColor:[UIColor redColor]];
    }
    return _priorityView;
}

@end
