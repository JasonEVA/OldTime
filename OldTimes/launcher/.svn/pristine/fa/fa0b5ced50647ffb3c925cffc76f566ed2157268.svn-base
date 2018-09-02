//
//  MissionDetailHeadTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/8/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MissionDetailHeadTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MissionDetailModel.h"
#import <Masonry/Masonry.h>
#import "UIImage+Manager.h"
#import "UIView+Util.h"
#import "AvatarUtil.h"
#import "Category.h"
#import "MyDefine.h"

//圆点半径
#define RoudCoradius 4.5

@interface MissionDetailHeadTableViewCell ()

@property(nonatomic, strong) UILabel *titleLabel;
/** 提出时间标签 */
@property(nonatomic, strong) UILabel *deadLineLbl;
/** 紧急状态按钮 */
@property(nonatomic, strong) UILabel *levelStateLbl;
/** 红色元点 */
@property(nonatomic, strong) UIImageView *levelTag;
/** 头像 */
@property(nonatomic, strong) UIImageView *headIcon;
/** 姓名 */
@property(nonatomic, strong) UILabel *nameLbl;
/** 重复 */
@property(nonatomic, strong) UILabel *repeatLbl;
/** 重复图标 */
@property(nonatomic, strong) UIImageView *repeatIcon;
/** 红色的钟 */
@property(nonatomic, strong) UIImageView *clock;
/** 标题旁的闹钟 */
@property(nonatomic, strong) UIImageView *alarmClock;

@end

@implementation MissionDetailHeadTableViewCell

+ (NSString *)identifier { return NSStringFromClass([self class]);}
+ (CGFloat)height { return 115.0;};

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(13);
    }];
    [self addSubview:self.alarmClock];
    [self.alarmClock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.top.equalTo(self.titleLabel);
    }];
    
    [self addSubview:self.levelStateLbl];
    [self.levelStateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
    
    [self addSubview:self.levelTag];
    [self.levelTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.levelStateLbl);
        make.right.equalTo(self.levelStateLbl.mas_left).offset(-3);
        make.width.height.equalTo(@(RoudCoradius * 2));
    }];
    
    // 标题右边不与tag重叠
    [self.alarmClock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.lessThanOrEqualTo(self.levelTag.mas_left).offset(-10);
    }];

    [self addSubview:self.headIcon];
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
        make.left.equalTo(self.titleLabel);
        make.width.height.equalTo(@(44));
    }];
    [self addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headIcon.mas_right).offset(10);
        make.centerY.equalTo(self.headIcon.mas_centerY);
    }];
    
    [self addSubview:self.deadLineLbl];
    [self.deadLineLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.levelStateLbl);
        make.centerY.equalTo(self.nameLbl.mas_centerY);
    }];
    
    [self addSubview:self.clock];
    [self.clock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.deadLineLbl.mas_left).offset(-10);
        make.centerY.equalTo(self.deadLineLbl);
    }];
    
//    [self addSubview:self.repeatLbl];
//    [self.repeatLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.deadLineLbl);
//        make.top.equalTo(self.deadLineLbl.mas_bottom).offset(5);
//        make.width.equalTo(self.deadLineLbl);
//    }];
//    
//    [self addSubview:self.repeatIcon];
//    [self.repeatIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.repeatLbl);
//        make.left.equalTo(self.clock);
//        make.width.equalTo(@10);
//        make.height.equalTo(@8);
//    }];
}

#pragma mark - Private Method
- (void)setPriority:(MissionTaskPriority)priority {
    NSString *priorityString = @"";
    UIColor *color;
    switch (priority) {
        case MissionTaskPriorityLow:
            color = [UIColor mtc_colorWithHex:0x666666];
            priorityString = LOCAL(MISSION_LOW);
            break;
        case MissionTaskPriorityMid:
            color = [UIColor mtc_colorWithHex:0xffac4f];
            priorityString = LOCAL(MISSION_MEDIUM);
            break;
        case MissionTaskPriorityHeigh:
            color = [UIColor mtc_colorWithHex:0xff3366];
            priorityString = LOCAL(MISSION_HIGH);
            break;
    }
    self.levelStateLbl.text = priorityString;
    self.levelTag.backgroundColor = color;
    self.levelStateLbl.textColor = color;
}

- (void)setRepeatType:(calendar_repeatType)repeatType {
    NSString *string;
    switch (repeatType) {
        case calendar_repeatNo:
            string = @"不循环";
            break;
        case calendar_repeatDay:
            string = @"每天循环";
            break;
        case calendar_repeatMonth:
            string = @"每月循环";
            break;
        case calendar_repeatWeak:
            string = @"每周循环";
            break;
        case calendar_repeatYear:
            string = @"每年循环";
            break;
    }
    self.repeatLbl.text = string;
}

#pragma mark - Setter
- (void)setDataWithModel:(MissionDetailModel *)model {
    self.titleLabel.text = model.title;
    [self.alarmClock setHidden:(model.remindType == calendar_remindTypeEventNo)];
    [self setPriority:model.priority];
    
    if (model.deadlineDate) {
        NSString *string = [model.deadlineDate mtc_dateFormate];
        string = [string stringByAppendingString:LOCAL(MISSION_END)];
        self.deadLineLbl.text = string;
    }
    
    self.deadLineLbl.hidden = !model.deadlineDate;
    self.clock.hidden = !model.deadlineDate;
    
    [self setRepeatType:model.repeatType];
    
    self.nameLbl.text = [@[model.arrayUserName] firstObject] ?:@"";
    [self.headIcon sd_setImageWithURL:avatarURL(avatarType_80, [@[model.arrayUser] firstObject]) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] options:SDWebImageRefreshCached];
}

#pragma mark - initilizer
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont mtc_font_30];
        _titleLabel.textColor = [UIColor themeBlue];
    }
    return _titleLabel;
}

- (UILabel *)deadLineLbl
{
    if (!_deadLineLbl)
    {
        _deadLineLbl = [[UILabel alloc] init];
        _deadLineLbl.font = [UIFont systemFontOfSize:12];
        _deadLineLbl.textColor = [UIColor themeRed];
        _deadLineLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _deadLineLbl;
}

- (UILabel *)levelStateLbl
{
    if (!_levelStateLbl)
    {
        _levelStateLbl = [[UILabel alloc] init];
        _levelStateLbl.textColor = [UIColor themeRed];
        _levelStateLbl.font = [UIFont boldSystemFontOfSize:13];
        
        [_levelStateLbl setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _levelStateLbl;
}

- (UIImageView *)levelTag
{
    if (!_levelTag) {
        _levelTag = [[UIImageView alloc] init];
        _levelTag.layer.cornerRadius = RoudCoradius;
        _levelTag.layer.masksToBounds = YES;
    }
    return _levelTag;
}

- (UIImageView *)headIcon
{
    if (!_headIcon)
    {
        _headIcon = [[UIImageView alloc] init];
        _headIcon.layer.cornerRadius = 5;
        _headIcon.layer.masksToBounds = YES;
    }
    return _headIcon;
}

- (UILabel *)nameLbl
{
    if (!_nameLbl)
    {
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = [UIFont mtc_font_30];
    }
    return _nameLbl;
}

- (UILabel *)repeatLbl
{
    if (!_repeatLbl)
    {
        _repeatLbl = [[UILabel alloc] init];
        _repeatLbl.textColor = [UIColor minorFontColor];
        _repeatLbl.font = [UIFont mtc_font_26];
    }
    return _repeatLbl;
}

- (UIImageView *)repeatIcon
{
    if (!_repeatIcon)
    {
        _repeatIcon = [[UIImageView alloc] init];
        _repeatIcon.image = [UIImage imageNamed:@"repeat_gray"];
    }
    return _repeatIcon;
}

- (UIImageView *)clock
{
    if (!_clock)
    {
        _clock = [[UIImageView alloc] init];
        _clock.image = [UIImage imageNamed:@"clock_red"];
    }
    return _clock;
}

- (UIImageView *)alarmClock
{
    if (!_alarmClock)
    {
        _alarmClock = [[UIImageView alloc] init];
        _alarmClock.image = [UIImage imageNamed:@"Mission_alarmClock"];
    }
    return _alarmClock;
}

@end
