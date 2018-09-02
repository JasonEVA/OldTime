//
//  ApplyTotalDetail_headTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/8/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyTotalDetail_headTableViewCell.h"
#import "UIView+Util.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
#import "Category.h"
#import "UIImage+Manager.h"
#import "NSDate+String.h"
#import "DateTools.h"
#import "MyDefine.h"
#import "AvatarUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>


//圆点半径
#define RoudCoradius 4

@interface  ApplyTotalDetail_headTableViewCell()
/**
 *  蓝色标题标签
 */
@property(nonatomic, strong) UILabel  *titleLabel;
/**
 *  提出时间标签
 */
@property(nonatomic, strong) UILabel  *comeOutTimeLbl;
/**
 *  紧急状态按钮
 */
@property(nonatomic, strong) UILabel  *levelStateLbl;
/**
 *  红色元点
 */
@property(nonatomic, strong) UILabel  *levelTag;
/**
 *  事件处理状态标签
 */
@property(nonatomic, strong) UIButton *stateBtn;
/**
 *  头像
 */
@property(nonatomic, strong) UIImageView  *headIcon;
/**
 *  姓名
 */
@property(nonatomic, strong) UILabel  *nameLbl;

@property(nonatomic, strong) NSDictionary  *StatusDict;
@property (nonatomic, strong) NSDictionary *StatusColorDict;

@property(nonatomic, assign) CharacterType type;

@end

@implementation ApplyTotalDetail_headTableViewCell

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier from:(CharacterType )charactype
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.type = charactype;
        [self initComponents];
    }
    return self;
}

#pragma mark - createFrame
- (void)initComponents
{
    [self.contentView addSubview:self.levelStateLbl];
    [self.levelStateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-13);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(13);
        make.right.lessThanOrEqualTo(self.levelStateLbl.mas_left).offset(-90);
    }];
    
    [self.contentView addSubview:self.levelTag];
    [self.levelTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.levelStateLbl);
        make.right.equalTo(self.levelStateLbl.mas_left);
        make.width.height.equalTo(@(8));
    }];
    
    /*---------------以上添加一定有的元素-------------------- */
    //根据状态动态添加
    if (!self.type)
    {
        [self.contentView addSubview:self.comeOutTimeLbl];
        [self.comeOutTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        }];
        
        [self.contentView addSubview:self.stateBtn];
        [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.levelStateLbl);
            make.top.equalTo(self.levelStateLbl.mas_bottom).offset(5);
            make.width.greaterThanOrEqualTo(@(60));
            make.height.equalTo(@(20));
        }];
    }
    else
    {
        [self.contentView addSubview:self.headIcon];
        [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
            make.left.equalTo(self.titleLabel);
            make.width.height.equalTo(@(40));
        }];
        [self.contentView addSubview:self.nameLbl];
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headIcon.mas_right).offset(10);
            make.centerY.equalTo(self.headIcon.mas_centerY);
        }];
        [self.contentView addSubview:self.comeOutTimeLbl];
        [self.comeOutTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.levelStateLbl);
            make.centerY.equalTo(self.nameLbl.mas_centerY);
        }];
    }
}

#pragma mark - setUpData
- (void)SetDataWithModel:(ApplyDetailInformationModel *)model
{
    self.titleLabel.text = model.A_TITLE? :@"";
    self.nameLbl.text = model.CREATE_USER_NAME? :@"";
    self.comeOutTimeLbl.text = [self getDeadLineTime:model.CREATE_TIME]? :@"";
    if (model.A_IS_URGENT)
    {
        self.levelStateLbl.text = LOCAL(APPLY_ADD_PRIORITY_TITLE);
        self.levelTag.hidden = NO;
    }
    else
    {
        self.levelStateLbl.text = @"";
        self.levelTag.hidden = YES;
    }
    
    [self.headIcon sd_setImageWithURL:avatarURL(avatarType_80, model.CREATE_USER) placeholderImage:[UIImage imageNamed:@"login_head_companylogo"] options:SDWebImageRefreshCached];
    
    [self.stateBtn setTitle:[self.StatusDict objectForKey:model.A_STATUS] forState:UIControlStateNormal];
    [self.stateBtn setTitle:[self.StatusDict objectForKey:model.A_STATUS]  forState:UIControlStateSelected];
    [self.stateBtn setBackgroundColor:[self.StatusColorDict objectForKey:model.A_STATUS]];
}

- (NSString *)getDeadLineTime:(long long)time
{
    NSString *str;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDate *today = [NSDate date];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"",LOCAL(CALENDAR_SCHEDULEBYWEEK_SUNDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_MONDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_TUESTDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_WEDNESDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_THURSDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_FRIDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_SATURDAY),nil];
    
    if (date.year == today.year && date.month == today.month && date.day == today.day)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm"];
        str = [NSString stringWithFormat:@"%@%@%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY),[df stringFromDate:date],LOCAL(APPLY_COMEOUT)];
    }
    else if (date.year == today.year)
    {
        str = [NSString stringWithFormat:@"%ld/%ld(%@)%ld:%ld%@",date.month,date.day,[arr objectAtIndex:date.weekday -1],date.hour,date.minute,LOCAL(APPLY_COMEOUT)];
    }
    else
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy/MM/dd HH:mm"];
        str = [NSString stringWithFormat:@"%@%@",[df stringFromDate:date],LOCAL(APPLY_COMEOUT)];
    }
    if ([str hasPrefix:@"1970"]) {
        str = @"";
    }
    return str;
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

- (UILabel *)comeOutTimeLbl
{
    if (!_comeOutTimeLbl)
    {
        _comeOutTimeLbl = [[UILabel alloc] init];
        _comeOutTimeLbl.font = [UIFont mtc_font_26];
        _comeOutTimeLbl.textColor = [UIColor mediumFontColor];
    }
    return _comeOutTimeLbl;
}

- (UILabel *)levelStateLbl
{
    if (!_levelStateLbl)
    {
        _levelStateLbl = [[UILabel alloc] init];
        _levelStateLbl.textColor = [UIColor themeRed];
        _levelStateLbl.font = [UIFont boldSystemFontOfSize:12];
    }
    return _levelStateLbl;
}

- (UILabel *)levelTag
{
    if (!_levelTag) {
        _levelTag = [[UILabel alloc] init];
        _levelTag.backgroundColor = [UIColor themeRed];
        _levelTag.layer.cornerRadius = RoudCoradius;
        _levelTag.layer.masksToBounds = YES;
    }
    return _levelTag;
}

- (UIButton *)stateBtn
{
    if (!_stateBtn)
    {
        _stateBtn = [[UIButton alloc] init];
        [_stateBtn titleLabel].font = [UIFont mtc_font_24];
        _stateBtn.layer.cornerRadius = 10.0f;
    }
    return _stateBtn;
}

- (UIImageView *)headIcon
{
    if (!_headIcon)
    {
        _headIcon = [[UIImageView alloc] init];
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

- (NSDictionary *)StatusDict
{
    if (!_StatusDict)
    {
        _StatusDict = @{@"APPROVE":LOCAL(APPLY_SENDER_ACCEPT_TITLE),
                        @"WAITING":LOCAL(APPLY_SENDER_WAITDEAL_TITLE),
                        @"IN_PROGRESS":LOCAL(APPLY_SENDER_DEALING_TITLE),
                        @"DENY":LOCAL(APPLY_SENDER_UNACCEPT_TITLE),
                        @"CALL_BACK":LOCAL(APPLY_SENDER_BACKWARD_TITLE)};
    }
    return _StatusDict;
}

- (NSDictionary *)StatusColorDict
{
    if (!_StatusColorDict)
    {
        _StatusColorDict = @{@"APPROVE"     :[UIColor mtc_colorWithHex:0x22c064],
                             @"WAITING"     :[UIColor mtc_colorWithHex:0xc2c2c2],
                             @"IN_PROGRESS" :[UIColor mtc_colorWithHex:0x0099ff],
                             @"DENY"        :[UIColor themeRed],
                             @"CALL_BACK"   :[UIColor mtc_colorWithHex:0xff8447]};
    }
    return _StatusColorDict;
}

@end
