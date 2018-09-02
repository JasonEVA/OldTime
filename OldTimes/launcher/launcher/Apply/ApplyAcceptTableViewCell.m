//
//  ApplySendTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/8/11.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyAcceptTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <DateTools/DateTools.h>
#import <Masonry/Masonry.h>
#import "AvatarUtil.h"
#import "MyDefine.h"
#import "Category.h"

//评论右上角图标半径
#define messageTgRadius  2
//最左侧圆角半径
#define TagRadius 3
@interface ApplyAcceptTableViewCell ()

/**
 *  头像图图标
 */
@property (nonatomic , strong) UIImageView  *headIcon;
/**
 *  消息图标
 */
@property (nonatomic , strong) UIImageView  *messageIcon;
/**
 *  附件图标
 */
@property (nonatomic , strong) UIImageView  *CCIcon;
/**
 *  事件优先级时间
 */
@property (nonatomic , strong) UILabel  *stateLbl;
/**
 *  时间显示标签
 */
@property (nonatomic , strong) UILabel  *timeLb;
/**
 *  标题标签
 */
@property (nonatomic , strong) UILabel  *titleLb;
/**
 *  详情标签
 */
@property (nonatomic , strong) UILabel  *detailLb;
/**
 *  红色的钟
 */
@property(nonatomic, strong) UIImageView  *redClockView;


@property (nonatomic, strong) UIImageView *imgviewPass;

@property(nonatomic, assign) BOOL  isHaveComment;

@property(nonatomic, assign) BOOL  isHaveCC;

@property(nonatomic, assign) BOOL  isHaveDeadLine;

//是否显示箭头
@property (nonatomic, assign) BOOL ispass;

@property (nonatomic, strong) NSDateFormatter *df;
@end

@implementation ApplyAcceptTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self createFrame];
        self.tagIcon.hidden = YES;
    }
    return  self;
}



- (void)updateConstraints {
    [super updateConstraints];
    
    //最后期限
    if (self.isHaveDeadLine)
    {
        self.redClockView.hidden = NO;
        [self.redClockView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.stateLbl);
            make.right.equalTo(self.stateLbl.mas_left).offset(-10);
        }];
        if ([self.stateLbl.text isEqualToString:LOCAL(APPLY_ADD_PRIORITY_TITLE)] || [self.stateLbl.text isEqualToString:@""])
        {
            self.redClockView.hidden = YES;
        }
    }else
    {
        self.redClockView.hidden = YES;
    }
    
    //没有有评论
    if (!self.isHaveComment)
    {
        self.messageIcon.hidden = YES;
        
        if (self.isHaveCC)
        {
            [self.CCIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(-9);
                make.right.equalTo(self.timeLb.mas_left).offset(-15);
                make.width.equalTo(@(13));
                make.height.equalTo(@(13));
            }];
            
            if (self.ispass)
            {
                [self.imgviewPass mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.contentView).offset(-9);
                    make.right.equalTo(self.CCIcon.mas_left).offset(-15);
                    make.width.equalTo(@(13));
                    make.height.equalTo(@(13));
                }];
            }
            else
            {
                self.imgviewPass.hidden = YES;
            }
            
            self.CCIcon.hidden = NO;
        }else
        {
//            [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(self.contentView).offset(-15);
//                make.bottom.equalTo(self.contentView).offset(-9);
//            }];
            self.CCIcon.hidden = YES;
            
            if (self.ispass)
            {
                [self.imgviewPass mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.contentView).offset(-9);
                    make.right.equalTo(self.timeLb.mas_left).offset(-15);
                    make.width.equalTo(@(13));
                    make.height.equalTo(@(13));
                }];
            }
            else
            {
                self.imgviewPass.hidden = YES;
            }
        }
    }else
    {
    //如果有附件
        self.messageIcon.hidden = NO;
        if (self.isHaveCC)
        {
            [self.messageIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.timeLb.mas_left).offset(-13);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
                make.width.equalTo(@(14));
                make.height.equalTo(@(13));
                
            }];
            
            [self.messageTag mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.messageIcon).offset(messageTgRadius);
                make.top.equalTo(self.messageIcon).offset(-messageTgRadius);
                make.width.equalTo(@(messageTgRadius*2));
                make.height.equalTo(@(messageTgRadius*2));
            }];
            
            [self.CCIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.messageIcon);
                make.right.equalTo(self.messageIcon.mas_left).offset(-15);
                make.width.equalTo(@(13));
                make.height.equalTo(@(13));
            }];
            
//            [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.messageIcon);
//                make.right.equalTo(self.CCIcon.mas_left).offset(-15);
//            }];
            self.CCIcon.hidden = NO;
            
            if (self.ispass)
            {
                [self.imgviewPass mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.contentView).offset(-9);
                    make.right.equalTo(self.CCIcon.mas_left).offset(-15);
                    make.width.equalTo(@(13));
                    make.height.equalTo(@(13));
                }];
            }
            else
            {
                self.imgviewPass.hidden = YES;
            }
        }else //没有附件
        {
            self.CCIcon.hidden = YES;
            [self.messageIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.timeLb.mas_left).offset(-13);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
                make.width.equalTo(@(14));
                make.height.equalTo(@(13));
                
            }];
            
            [self.messageTag mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.messageIcon).offset(messageTgRadius);
                make.top.equalTo(self.messageIcon).offset(-messageTgRadius);
                make.width.equalTo(@(messageTgRadius*2));
                make.height.equalTo(@(messageTgRadius*2));
            }];
            
            if (self.ispass)
            {
                [self.imgviewPass mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.contentView).offset(-9);
                    make.right.equalTo(self.messageIcon.mas_left).offset(-15);
                    make.width.equalTo(@(13));
                    make.height.equalTo(@(13));
                }];
            }
            else
            {
                self.imgviewPass.hidden = YES;
            }
            
//            [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.messageIcon);
//                make.right.equalTo(self.messageIcon).offset(-30);
//            }];
        }
    }
}

#pragma mark - someSetFunction

- (void)setDataWithModel:(ApplyGetReceiveListModel *)model
{
    [self.headIcon sd_setImageWithURL:avatarURL(avatarType_80, model.CREATE_USER) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] options:SDWebImageRefreshCached];
 
    self.isHaveComment = model.HAS_COMMENT;
    self.titleLb.text = model.CREATE_USER_NAME;
    self.detailLb.text = model.A_TITLE;
    if (model.A_IS_URGENT == 1)
    {
        self.stateLbl.text = LOCAL(APPLY_ADD_PRIORITY_TITLE);
    }
    else
    {
        self.stateLbl.text = [self getDeadLineTime:model.A_DEADLINE];
    }
    self.timeLb.text = [self getCreatetime:model.CREATE_TIME];
    self.isHaveDeadLine = model.A_DEADLINE;
    //暂时先加上聊天列表图标
    if (model.IS_HAVECOMMENT)
    {
        self.messageIcon.image = [UIImage imageNamed:@"comment"];
    }
    else
    {
        self.messageIcon.image = nil;
    }
    
    
    //判断是否有新消息 来控制messageTag的显影
    if (model.Unreadmsg)
    {
        self.tagIcon.hidden = NO;
    }
    else
    {
        self.tagIcon.hidden = YES;
    }

    self.isHaveCC = model.IS_HAVEFILE;
    
    if (model.A_APPROVE_PATH.length> 0)
    {
        self.imgviewPass.hidden = NO;
        self.ispass = YES;
    }
    else
    {
        self.imgviewPass.hidden = YES;;
        self.ispass = NO;
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraints];
    
    if (model.UnreadComment)
    {
        self.messageTag.hidden = NO;
    }
    else
    {
        self.messageTag.hidden = YES;
    }
    
    
    
    
}

- (void)SearchsetDataWithModel:(ApplyGetReceiveListModel *)model
{
    [self.headIcon sd_setImageWithURL:avatarURL(avatarType_80, model.CREATE_USER) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] options:SDWebImageRefreshCached];
    self.titleLb.text = model.CREATE_USER_NAME;
    self.detailLb.text = model.A_TITLE;
    self.isHaveDeadLine = model.A_DEADLINE;
    if (model.isInSearchView)
    {
        if ([model.A_TITLE.lowercaseString rangeOfString:model.searchKey.lowercaseString].location != NSNotFound)
        {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:model.A_TITLE];
            [str addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:[model.A_TITLE.lowercaseString rangeOfString:model.searchKey.lowercaseString]];
            self.detailLb.attributedText = str;
        }
        if ([model.CREATE_USER_NAME.lowercaseString rangeOfString:model.searchKey.lowercaseString].location != NSNotFound)
        {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:model.CREATE_USER_NAME];
            [str addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:[model.CREATE_USER_NAME.lowercaseString rangeOfString:model.searchKey.lowercaseString]];
            self.titleLb.attributedText = str;
        }
    }
    
    if (model.A_IS_URGENT == 1)
    {
        self.stateLbl.text = LOCAL(APPLY_ADD_PRIORITY_TITLE);
    }
    else
    {
        self.stateLbl.text = [self getDeadLineTime:model.A_DEADLINE];
    }

    self.timeLb.text = [self getCreatetime:model.CREATE_TIME];
    //暂时先加上聊天列表图标
    self.messageIcon.image = [UIImage imageNamed:@"comment"];
}

- (NSString *)getDeadLineTime:(long long)time
{
    if (time < 0) return @"";
    NSString *str;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDate *today = [NSDate date];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:LOCAL(CALENDAR_SCHEDULEBYWEEK_SUNDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_MONDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_TUESTDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_WEDNESDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_THURSDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_FRIDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_SATURDAY),nil];
    
    if (date.year == today.year && date.month == today.month && date.day == today.day)
    {
        [self.df setDateFormat:@"HH:mm"];
        str = [NSString stringWithFormat:@"%@%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY),[self.df stringFromDate:date]];
    }
    else if (date.year == today.year)
    {
        str = [NSString stringWithFormat:@"%ld/%ld(%@)%ld:%ld",date.month,date.day,[arr objectAtIndex:date.weekday -1],date.hour,date.minute];
    }
    else
    {
        [self.df setDateFormat:@"yyyy/MM/dd HH:mm"];
        str = [NSString stringWithFormat:@"%@",[self.df stringFromDate:date]];
        if ([str hasPrefix:@"1970"]) return nil;
    }

    return str;
}

- (NSString *)getCreatetime:(long long)time
{
    NSString *str;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDate *today = [NSDate date];
    NSDate *yesterday = [today dateByAddingDays:-1];
    
    if (date.year == today.year && date.month == today.month && date.day == today.day)
    {
        [self.df setDateFormat:@"HH:mm"];
        str = [self.df stringFromDate:date];
    }
    else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day)
    {
//        str = LOCAL(CALENDAR_SCHEDULEBYWEEK_YESTERDAY);
        [self.df setDateFormat:@"MM/dd"];
        str = [self.df stringFromDate:date];
    }
    else if (date.year == date.year)
    {
        [self.df setDateFormat:@"MM/dd"];
        str = [self.df stringFromDate:date];
    }
    else
    {
        [self.df setDateFormat:@"yyyy/MM/dd"];
        str = [self.df stringFromDate:date];
    }
    return str;
}

//- (void)replace

#pragma mark - createFrame
- (void)createFrame
{
    [self.contentView addSubview:self.redClockView];
    [self.contentView addSubview:self.tagIcon];
    [self.tagIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.top.equalTo(self).offset(10);
        make.width.equalTo(@(TagRadius*2));
        make.height.equalTo(@(TagRadius*2));
    }];

    [self.contentView addSubview:self.headIcon];
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagIcon.mas_right).offset(4);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    
    [self.contentView addSubview:self.stateLbl];
    [self.stateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.top.equalTo(self.contentView).offset(10);
    }];

    [self.contentView addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headIcon.mas_right).offset(8);
        make.top.equalTo(self.headIcon);
    }];
    
    [self.contentView addSubview:self.detailLb];
    [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb);
        make.bottom.equalTo(self.headIcon);
        make.right.lessThanOrEqualTo(self.contentView).offset(-100);
    }];
    
    
    [self.messageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-9);
        make.width.equalTo(@(14));
        make.height.equalTo(@(13));
        
    }];
    
    [self.messageTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.messageIcon).offset(messageTgRadius);
        make.top.equalTo(self.messageIcon).offset(-messageTgRadius);
        make.width.equalTo(@(messageTgRadius*2));
        make.height.equalTo(@(messageTgRadius*2));
    }];
  
    [self.contentView addSubview:self.imgviewPass];
    
    [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-9);
    }];
    
    [super updateConstraints];
}

#pragma mark - Initializer
- (UILabel *)tagIcon
{
    if (!_tagIcon)
    {
        _tagIcon = [[UILabel alloc] initWithFrame:CGRectZero];
        _tagIcon.frame = CGRectMake(0, 0, TagRadius*2, TagRadius*2);
        _tagIcon.layer.cornerRadius = TagRadius;
        _tagIcon.clipsToBounds = YES;
        _tagIcon.hidden = YES;
        _tagIcon.backgroundColor = [UIColor redColor];
    }
    return _tagIcon;
}

- (UIImageView *)headIcon
{
    if (!_headIcon)
    {
        _headIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headIcon.layer.cornerRadius = 5;
        _headIcon.clipsToBounds = YES;
    }
    return _headIcon;
}

- (UIImageView *)messageIcon
{
    if (!_messageIcon)
    {
        _messageIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.messageIcon];    }
    return _messageIcon;
}

- (UIImageView *)CCIcon
{
    if (!_CCIcon)
    {
        _CCIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _CCIcon.image = [UIImage imageNamed:@"paper-clip"];
        _CCIcon.hidden = YES;
        [self.contentView addSubview:_CCIcon];
    }
    return _CCIcon;
}

- (UILabel *)stateLbl
{
    if (!_stateLbl)
    {
        _stateLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _stateLbl.font = [UIFont mtc_font_26];
        _stateLbl.textAlignment = NSTextAlignmentRight;
        _stateLbl.textColor = [UIColor themeRed];
    }
    return _stateLbl;
}

- (UILabel *)timeLb
{
    if (!_timeLb)
    {
        _timeLb = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLb.font = [UIFont systemFontOfSize:10];
        _timeLb.textColor = [UIColor minorFontColor];
        [self.contentView addSubview:self.timeLb];
    }
    return _timeLb;
}

- (UILabel *)detailLb
{
    if (!_detailLb)
    {
        _detailLb = [[UILabel alloc]initWithFrame:CGRectZero];
        _detailLb.textColor = [UIColor mediumFontColor];
        _detailLb.font = [UIFont mtc_font_26];
    }
    return _detailLb;
}

- (UILabel *)titleLb
{
    if (!_titleLb)
    {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLb.font = [UIFont mtc_font_30];
    }
    return _titleLb;
}
- (UILabel *)messageTag
{
    if (!_messageTag) {
        _messageTag = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, messageTgRadius*2, messageTgRadius*2)];
        _messageTag.backgroundColor = [UIColor redColor];
        _messageTag.layer.cornerRadius = messageTgRadius;
        _messageTag.layer.masksToBounds = YES;
        _messageTag.hidden = YES;
        [self.contentView addSubview:_messageTag];
    }
    return _messageTag;
}

-(NSDateFormatter *)df
{
    if (!_df)
    {
        static NSDateFormatter *formatter = nil;
        if (!formatter) {
            formatter = [NSDateFormatter new];
        }
        _df = formatter;
    }
    return _df;
}

- (UIImageView *)redClockView
{
    if (!_redClockView)
    {
        _redClockView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock_red"]];
    }
    return _redClockView;
}

- (UIImageView *)imgviewPass
{
    if (!_imgviewPass)
    {
        _imgviewPass = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowright"]];
    }
    return _imgviewPass;
}
@end
