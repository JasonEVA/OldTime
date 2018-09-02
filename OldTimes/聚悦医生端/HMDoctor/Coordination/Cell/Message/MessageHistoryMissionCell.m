//
//  MessageHistoryMissionCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/27.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MessageHistoryMissionCell.h"
#import "NSDate+String.h"

#define FinishColor [UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1]

@interface MessageHistoryMissionCell ()
@property (nonatomic,strong) UIButton * iconMarkButton; // 已完成未完成操作的按钮
@property (nonatomic,strong) UILabel * titleLabel; // title
@property (nonatomic,strong) UILabel * timeLabel;
// 优先级
@property (nonatomic,strong) UIView * priorityView ;
@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UIImageView *timeIcon;
@property (nonatomic, strong) UILabel *rightLb;

@end



@implementation MessageHistoryMissionCell
+ (NSString *)identifier { return NSStringFromClass([self class]);}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configElements];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}
#pragma mark -private method
- (void)configElements {
    [self.contentView addSubview:self.iconMarkButton];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.priorityView];
    [self.contentView addSubview:self.headIcon];
    [self.contentView addSubview:self.timeIcon];
    [self.contentView addSubview:self.rightLb];
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
    
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.iconMarkButton.mas_right).offset(10);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headIcon.mas_right).offset(10);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(4);
        make.height.equalTo(@30);
        make.right.lessThanOrEqualTo(self.rightLb.mas_left);
    }];

    [self.timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.contentView.mas_centerY).offset(4);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeIcon);
        make.left.equalTo(self.timeIcon.mas_right).offset(10);
    }];
    
    [self.rightLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-15);
    }];

}
- (void)setCellDataWithModel:(MissionDetailModel *)model
{
    [self.titleLabel setText:model.taskTitle];
    [self setPriority:model.taskPriority];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.endTime];
//    [self.timeLabel setText:[date dateFormateWithWeekDay:YES]];
    [self.titleLabel setText:model.endTime];
    [self changState:model.taskStatus];
    
}
- (void)setPriority:(MissionTaskPriority)priority {
    NSString *priorityString = @"";
    UIColor *color;
    switch (priority) {
        case MissionTaskPriorityLow:
            color = [UIColor colorWithHexString:@"666666"];
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

- (void)changState:(BOOL)isSelect
{
    [self.iconMarkButton setSelected:isSelect];
    if (isSelect) {
        [self.titleLabel setTextColor:FinishColor];
    } else {
        [self.titleLabel setTextColor:[UIColor blackColor]];
    }
}
#pragma mark - event Response
- (void)iconMarkButtonClick
{
    self.iconMarkButton.selected ^=1;
    [self changState:self.iconMarkButton.selected];
}
#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface

#pragma mark - init UI

- (UIButton *)iconMarkButton
{
    if (!_iconMarkButton) {
        _iconMarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconMarkButton addTarget:self action:@selector(iconMarkButtonClick) forControlEvents:UIControlEventTouchUpInside];
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
        [_titleLabel setText:@"随访"];
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
        [_timeLabel setText:@"4/15 周天"];
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


- (UIImageView *)headIcon
{
    if (!_headIcon) {
        _headIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_default_staff"]];
        [_headIcon.layer setCornerRadius:2];
    }
    return _headIcon;
}

- (UIImageView *)timeIcon
{
    if (!_timeIcon) {
        _timeIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"New_TimeClock"] highlightedImage:[UIImage imageNamed:@"Mission_redClock"]];
    }
    return _timeIcon;
}
- (UILabel *)rightLb
{
    if (!_rightLb) {
        _rightLb = [[UILabel alloc] init];
        _rightLb.font = [UIFont systemFontOfSize:13.0];
        [_rightLb setText:@"待评论"];
        [_rightLb setTextColor:[UIColor colorWithHexString:@"0099ff"]];
    }
    return _rightLb;
}

@end
