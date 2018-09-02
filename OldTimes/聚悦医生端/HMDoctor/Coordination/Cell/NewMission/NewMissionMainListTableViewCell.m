//
//  NewMissionMainListTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/8/4.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "NewMissionMainListTableViewCell.h"
#import "MissionDetailModel.h"

@interface NewMissionMainListTableViewCell()
@property (nonatomic,strong) UILabel * titleLabel; // title
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel *stateLb;
@property (nonatomic, strong) UILabel *memberLb;

@property (nonatomic, strong) UIImageView *urgentImageView;
@property (nonatomic, strong) UIImageView *clockImageView;
@property (nonatomic, strong) UIImageView *commentImageView;

@end
@implementation NewMissionMainListTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self configElements];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -private method
- (void)configElements {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.memberLb];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@30);
        make.right.lessThanOrEqualTo(self.contentView.mas_centerX);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_centerY).offset(5);
        make.left.equalTo(self.titleLabel);
    }];
    
    [self.memberLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(11);
        make.centerY.equalTo(self.timeLabel);
    }];
    
    

}
- (UILabel *)getLebalWithTitel:(NSString *)titel font:(UIFont *)font textColor:(UIColor *)textColor
{
    UILabel *lb = [UILabel new];
    [lb setText:titel];
    [lb setTextColor:textColor];
    [lb setFont:font];
    return lb;
}
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
//处理状态显示
- (void)setStateDataWithModel:(MissionDetailModel *)model {
    
    switch (model.taskStatus) {
        case TaskStatusTypeDisabled:
        {
            [self.stateLb setText:@"已拒绝"];
            [self.stateLb setTextColor:[UIColor colorWithHexString:@"ff3366"]];
            break;
        }
        case TaskStatusTypeNonActivated:
        {
            [self.stateLb setText:@"待接收"];
            [self.stateLb setTextColor:[UIColor colorWithHexString:@"ff6600"]];
            break;
        }
        case TaskStatusTypeActivated:
        {
            [self.stateLb setText:@"待执行"];
            [self.stateLb setTextColor:[UIColor colorWithHexString:@"2bb300"]];
            break;
        }
        case TaskStatusTypeExpired:
        {
            [self.stateLb setText:@"已过期"];
            [self.stateLb setTextColor:[UIColor colorWithHexString:@"999999"]];
            break;
        }
        case TaskStatusTypeDone:
        {
            [self.stateLb setText:@"已完成"];
            [self.stateLb setTextColor:[UIColor colorWithHexString:@"0099ff"]];
            break;
        }
       
    }
}
//处理图标显示
- (void)dealWithIconWithModel:(MissionDetailModel *)model {
    
    [self.commentImageView setImage:[UIImage imageNamed:@""]];
    [self.clockImageView setImage:[UIImage imageNamed:@""]];
    [self.urgentImageView setImage:[UIImage imageNamed:@""]];

    if (model.isComment) {
        [self.commentImageView setImage:[UIImage imageNamed:@"pinlun"]];
    }
    if (model.remindType) {
        [self.clockImageView setImage:[UIImage imageNamed:@"tixin"]];
    }
    if (model.taskPriority != 0) {
        [self.urgentImageView setImage:[UIImage imageNamed:@"jiaji"]];
    }
    
    [self.contentView addSubview:self.commentImageView];
    [self.contentView addSubview:self.urgentImageView];
    [self.contentView addSubview:self.clockImageView];
    
    [self.commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.clockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.commentImageView.mas_left).offset(-10);
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.urgentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.clockImageView.mas_left).offset(-10);
        make.centerY.equalTo(self.titleLabel);
    }];
}

#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)setCellDataWithModel:(MissionDetailModel *)model
{
    [self.stateLb removeFromSuperview];
    [self.urgentImageView removeFromSuperview];
    [self.clockImageView removeFromSuperview];
    [self.commentImageView removeFromSuperview];
    
    [self.titleLabel setText:model.taskTitle];
    [self.timeLabel setText:[NSString stringWithFormat:@"时间：%@",[self getTimeStrWithModel:model]]];
    if (model.isSendFromMe ||model.isFromTeam) {//我发出的任务，右侧显示状态
        [self setStateDataWithModel:model];
        [self.contentView addSubview:self.stateLb];
        [self.stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(self.titleLabel);
        }];
        [self.memberLb setText:[NSString stringWithFormat:@"执行者：%@",model.participatorName]];
    }
    else {//其余状态显示图标，
        [self dealWithIconWithModel:model];
        [self.memberLb setText:[NSString stringWithFormat:@"服务群：%@",model.pShowName]];
    }
   
    
}
#pragma mark - init UI
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

- (UILabel *)stateLb
{
    if (!_stateLb) {
        _stateLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:15] textColor:[UIColor commonDarkGrayColor_666666]];
    }
    return _stateLb;
}

- (UILabel *)memberLb
{
    if (!_memberLb) {
        _memberLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor commonLightGrayColor_999999]];
    }
    return _memberLb;
}

- (UIImageView *)urgentImageView {
    if (!_urgentImageView) {
        _urgentImageView = [[UIImageView alloc] init];
    }
    return _urgentImageView;
}
- (UIImageView *)clockImageView {
    if (!_clockImageView) {
        _clockImageView = [[UIImageView alloc] init];
    }
    return _clockImageView;
}
- (UIImageView *)commentImageView {
    if (!_commentImageView) {
        _commentImageView = [[UIImageView alloc] init];
    }
    return _commentImageView;
}
@end
