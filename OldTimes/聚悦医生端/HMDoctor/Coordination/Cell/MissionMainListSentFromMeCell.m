//
//  MissionMainListSentFromMeCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/5/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionMainListSentFromMeCell.h"
#import "NSDate+String.h"

@interface MissionMainListSentFromMeCell()

@property (nonatomic,strong) UILabel * titleLabel; // title
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel *rightLb;
@property (nonatomic, strong) UILabel *memberLb;
// 优先级
@property (nonatomic,strong) UIView * priorityView ;

@end
@implementation MissionMainListSentFromMeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self configElements];
    }
    return self;
}

- (void)setCellDataWithModel:(MissionDetailModel *)model
{
    [self.titleLabel setText:model.taskTitle];
    [self setPriority:model.taskPriority];
    [self.timeLabel setText:[self getTimeStrWithModel:model]];
    [self setRightLbStateWithModel:model];
    [self.memberLb setText:[NSString stringWithFormat:@"参与者：%@",model.participatorName]];
}

#pragma mark - Private Method

- (NSString *)getTimeStrWithModel:(MissionDetailModel *)model
{
    NSString *startTime = [self handleTimeFormatWithStr:model.startTime AllDay:model.isStartAllDay];
    NSString *endTime   = [self handleTimeFormatWithStr:model.endTime AllDay:model.isEndAllDay];
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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.priorityView];
    [self.contentView addSubview:self.memberLb];
    [self.contentView addSubview:self.rightLb];
    // 优先级
    [self.priorityView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@5);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priorityView.mas_right).offset(10);
        make.bottom.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@30);
        make.width.lessThanOrEqualTo(@([ [ UIScreen mainScreen ] bounds ].size.width - 200));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.titleLabel);
    }];
    
    [self.memberLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(36);
        make.centerY.equalTo(self.timeLabel);
    }];
    
    [self.rightLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.titleLabel);
    }];
}

//设置右侧任务状态
- (void)setRightLbStateWithModel:(MissionDetailModel *)model
{
    NSString *rightTitel = @"";
    UIColor *rightColor = [UIColor new];
    TaskStatusType type = (TaskStatusType)model.taskStatus;
    switch (type) {
        case TaskStatusTypeAll: {
            
            break;
        }
        case TaskStatusTypeDeleted: {
            
            break;
        }
        case TaskStatusTypeDisabled: {
            rightTitel = @"已拒绝";
            rightColor = [UIColor colorWithHexString:@"ff3366"];

            break;
        }
        case TaskStatusTypeNonActivated: {
            rightTitel = @"待接受";
            rightColor = [UIColor colorWithHexString:@"ff9e37"];

            break;
        }
        case TaskStatusTypeActivated: {
            rightTitel = @"待执行";
            rightColor = [UIColor colorWithHexString:@"0099ff"];
            break;
        }
        case TaskStatusTypeExpired: {
            rightTitel = @"已过期";
            rightColor = [UIColor commonGrayTextColor];
            break;
        }
        case TaskStatusTypeDone: {
            rightTitel = @"已完成";
            rightColor = [UIColor colorWithHexString:@"22c064"];

            break;
        }
    }
    [self.rightLb setText:rightTitel];
    [self.rightLb setTextColor:rightColor];
}

- (void)setPriority:(MissionTaskPriority)priority {
    NSString *priorityString = @"";
    UIColor *color;
    switch (priority) {
        case MissionTaskPriorityLow:
            color = [UIColor colorWithHexString:@"cccccc"];
            priorityString = @"低";
            break;
        case MissionTaskPriorityMid:
            color = [UIColor colorWithHexString:@"ffac4f"];
            priorityString = @"中";
            break;
        case MissionTaskPriorityHigh:
            color = [UIColor colorWithHexString:@"ff3366"];
            priorityString = @"高";
            break;
        case MissionTaskPriorityNone:
            color = [UIColor clearColor];
            priorityString = @"";
            break;
    }
    self.priorityView.backgroundColor = color;
}

- (UILabel *)getLebalWithTitel:(NSString *)titel font:(UIFont *)font textColor:(UIColor *)textColor
{
    UILabel *lb = [UILabel new];
    [lb setText:titel];
    [lb setTextColor:textColor];
    [lb setFont:font];
    return lb;
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
- (UILabel *)rightLb
{
    if (!_rightLb) {
        _rightLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:15] textColor:[UIColor commonDarkGrayColor_666666]];
    }
    return _rightLb;
}

- (UILabel *)memberLb
{
    if (!_memberLb) {
        _memberLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor commonLightGrayColor_999999]];
    }
    return _memberLb;
}
@end
