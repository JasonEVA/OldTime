//
//  NewApplyAllEventTableViewCell.m
//  launcher
//
//  Created by conanma on 16/1/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyAllEventTableViewCell.h"
#import "UIColor+Hex.h"
#import "UIFont+Util.h"
#import <Masonry/Masonry.h>


#import "UIImageView+WebCache.h"
#import "MyDefine.h"
#import "AvatarUtil.h"
#import "NSDate+String.h"
#import "DateTools.h"
#import "UIImage+Manager.h"

typedef enum{
    ComeFrom_in,
    ComeFrom_cc,
    ComeFrom_out
}ComeFrom;

typedef enum
{
    UNACCEPT = 0,       // 不被接受
    ACCEPT,             // 接受
    CANCLED,            // 驳回
    DEALING,            // 进行中
    ACCEPTADNTRANSFER   // 待审批
} APPLYEVENTSTATE;       // 请求事件状态

@interface NewApplyAllEventTableViewCell()
@property (nonatomic, strong) UIImageView *imgHead;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblTime;
@property (nonatomic, strong) UILabel *lblEndTime;
@property (nonatomic, strong) UILabel *lblFrom;
@property (nonatomic, strong) UILabel *lblContent;
@property (nonatomic, strong) UIImageView *imgAttachment;
@property (nonatomic, strong) UIImageView *imgcomment;
@property (nonatomic, strong) UILabel *lblUnread;
@property (nonatomic, strong) UILabel *lblUnreadComment;
@property (nonatomic , strong)  UIButton *stateBtn;

@end

@implementation NewApplyAllEventTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.imgHead];
        [self.contentView addSubview:self.lblName];
        [self.contentView addSubview:self.lblUnread];
        [self.contentView addSubview:self.lblFrom];
        [self.contentView addSubview:self.lblContent];
        [self.contentView addSubview:self.stateBtn];
        [self.contentView addSubview:self.lblEndTime];
        [self.contentView addSubview:self.imgAttachment];
        [self.contentView addSubview:self.imgcomment];
        [self.contentView addSubview:self.lblUnreadComment];
        [self.contentView addSubview:self.lblTime];
        
        [self setframes];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setframes
{
    [self.imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(13);
        make.top.equalTo(self.contentView).offset(10);
        make.width.height.equalTo(@40);
    }];
    
    [self.lblUnread mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgHead.mas_right).offset(10);
//        make.top.equalTo(self.imgHead);
        make.centerY.equalTo(self.lblName);
        make.width.height.equalTo(@8);
    }];
    
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblUnread.mas_right).offset(5);
        make.top.equalTo(self.imgHead);
        make.height.equalTo(@20);
    }];
    
    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-13);
        make.width.equalTo(@57);
        make.height.equalTo(@20);
    }];
    
    [self.lblEndTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgHead);
        make.right.equalTo(self.stateBtn.mas_left).offset(-5);
        make.height.equalTo(@20);
    }];
    
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self.stateBtn.mas_bottom).offset(2);
        make.centerY.equalTo(self.lblContent);
        make.right.equalTo(self.stateBtn).offset(2);
        make.height.equalTo(@16);
        make.width.equalTo(@40);
    }];
    
    [self.imgcomment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lblTime.mas_left).offset(-2);
//        make.top.bottom.equalTo(self.lblTime);
        make.centerY.equalTo(self.lblTime);
        make.width.height.equalTo(@15);
    }];
    
    [self.imgAttachment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imgcomment.mas_left).offset(-2);
//        make.top.bottom.equalTo(self.lblTime);
        make.centerY.equalTo(self.lblTime);
        make.width.height.equalTo(@15);
    }];
    
    [self.lblFrom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgHead.mas_right).offset(10);
        make.bottom.equalTo(self.imgHead).offset(-2);
//        make.centerY.equalTo(self.lblContent);
        make.height.equalTo(@16);
        make.width.equalTo(@25);
    }];
    
    [self.lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblFrom.mas_right).offset(5);
        make.top.bottom.equalTo(self.lblFrom);
    }];
    
    [self.lblUnreadComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.imgcomment).offset(-2);
        make.height.width.equalTo(@4);
    }];
    
    
}

#pragma mark - Privite Methods
- (void)changeStatement:(APPLYEVENTSTATE)state
{
    switch (state) {
        case UNACCEPT:
        {
            [self.stateBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeRed]] forState:UIControlStateNormal];
            [self.stateBtn setTitle:LOCAL(APPLY_SENDER_UNACCEPT_TITLE) forState:UIControlStateNormal];
            break;
        }
        case ACCEPT:
        {
            [self.stateBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor mtc_colorWithHex:0x22c064]] forState:UIControlStateNormal];
            [self.stateBtn setTitle:LOCAL(APPLY_SENDER_ACCEPT_TITLE) forState:UIControlStateNormal];
            break;
        }
        case CANCLED:
        {
            [self.stateBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor mtc_colorWithHex:0xff8447]] forState:UIControlStateNormal];
            [self.stateBtn setTitle:LOCAL(APPLY_SENDER_BACKWARD_TITLE) forState:UIControlStateNormal];
            break;
        }
        case DEALING:
        {
            [self.stateBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor mtc_colorWithHex:0x0099ff]] forState:UIControlStateNormal];
            [self.stateBtn setTitle:LOCAL(APPLY_SENDER_DEALING_TITLE) forState:UIControlStateNormal];
            break;
        }
        case ACCEPTADNTRANSFER:
        {
            [self.stateBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor mtc_colorWithHex:0x0099ff]] forState:UIControlStateNormal];
            [self.stateBtn setTitle:LOCAL(APPLY_SENDER_WAITDEAL_TITLE) forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}

- (void)setStateTitle:(NSString *)statusTitle
{
    //根据statu动态改变颜色
    if ([statusTitle isEqualToString:@"APPROVE"])
    {
        [self changeStatement:ACCEPT];
    }
    if ([statusTitle isEqualToString:@"WAITING"])
    {
        [self changeStatement:ACCEPTADNTRANSFER];
    }
    if ([statusTitle isEqualToString:@"IN_PROGRESS"])
    {
        [self changeStatement:DEALING];
    }
    if ([statusTitle isEqualToString:@"DENY"])
    {
        [self changeStatement:UNACCEPT];
    }
    if ([statusTitle isEqualToString:@"CALL_BACK"])
    {
        [self changeStatement:CANCLED];
    }
}

- (void)setmodel:(ApplyGetReceiveListModel *)model
{
    [self.imgHead sd_setImageWithURL:avatarURL(avatarType_80, model.CREATE_USER) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] options:SDWebImageRefreshCached];
	
    self.lblName.text = model.CREATE_USER_NAME? :@"";
	self.lblTime.text = [model getFormattedCreatTime];
    self.lblContent.text = [NSString stringWithFormat:@"%@|%@",model.T_NAME,model.A_TITLE];
	self.lblEndTime.text = model.A_IS_URGENT ? LOCAL(APPLY_ADD_PRIORITY_TITLE) : [model getFormattedDeadLineTime];
	
    [self setStateTitle:model.A_STATUS];
	
    switch (model.apply_type)
    {
        case applytype_in:
            self.lblFrom.text = @"in";
            break;
        case applytype_cc:
            self.lblFrom.text = @"cc";
            break;
        case applytype_out:
            self.lblFrom.text = @"out";
            break;
        default:
            break;
    }
    
    if (model.Unreadmsg)
    {
        self.lblUnread.hidden = NO;
        
        [self.lblName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lblUnread.mas_right).offset(5);
            make.top.equalTo(self.imgHead);
            make.height.equalTo(@20);
        }];
    }
    else
    {
        self.lblUnread.hidden = YES;
        [self.lblName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgHead.mas_right).offset(10);
            make.top.equalTo(self.imgHead);
            make.height.equalTo(@20);
        }];
    }
    
    if (model.HAS_COMMENT)
    {
        self.imgcomment.hidden = NO;
        if (model.IS_HAVEFILE)
        {
            self.imgAttachment.hidden = NO;
            
            [self.imgAttachment mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.imgcomment.mas_left).offset(-10);
                //        make.top.bottom.equalTo(self.lblTime);
                make.centerY.equalTo(self.lblTime);
                make.width.height.equalTo(@15);
            }];

            
            [self.lblContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblFrom.mas_right).offset(5);
                make.top.bottom.equalTo(self.lblFrom);
                make.right.equalTo(self.imgAttachment.mas_left).offset(-10);
            }];
        }
        else
        {
            self.imgAttachment.hidden = YES;
            [self.lblContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblFrom.mas_right).offset(5);
                make.top.bottom.equalTo(self.lblFrom);
                make.right.equalTo(self.imgcomment.mas_left).offset(-10);
            }];
        }
    }
    else
    {
        self.imgcomment.hidden = YES;
        if (model.IS_HAVEFILE)
        {
            self.imgAttachment.hidden = NO;
            [self.imgAttachment mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.lblTime.mas_left).offset(-2);
                //        make.top.bottom.equalTo(self.lblTime);
                make.centerY.equalTo(self.lblTime);
                make.width.height.equalTo(@15);
            }];
            
            [self.lblContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblFrom.mas_right).offset(5);
                make.top.bottom.equalTo(self.lblFrom);
                make.right.equalTo(self.imgAttachment.mas_left).offset(-10);
            }];
        }
        else
        {
            self.imgAttachment.hidden = YES;
            [self.lblContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lblFrom.mas_right).offset(5);
                make.top.bottom.equalTo(self.lblFrom);
                make.right.equalTo(self.lblTime.mas_left).offset(-10);
            }];
        }
    }
    
    if (model.UnreadComment)
    {
        self.lblUnreadComment.hidden = NO;
        [self.lblUnreadComment mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.imgcomment).offset(1);
            make.top.equalTo(self.imgcomment).offset(-1);
            make.height.width.equalTo(@4);
        }];
    }
    else
    {
        self.lblUnreadComment.hidden = YES;
    }
}

- (NSString *)getCreatTime:(long long)time
{
    NSString *str;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDate *today = [NSDate date];
    
	
    if (date.year == today.year && date.month == today.month && date.day == today.day)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm"];
//        str = [NSString stringWithFormat:@"%@%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY),[df stringFromDate:date]];
        str = [NSString stringWithFormat:@"%@",[df stringFromDate:date]];
    }
    else /*if (date.year == today.year)*/
    {
        str = [NSString stringWithFormat:@"%ld/%ld",date.month,date.day];
    }
    //    else
    //    {
    //        NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //        [df setDateFormat:@"yyyy/MM/dd HH:mm"];
    //        str = [NSString stringWithFormat:@"%@",[df stringFromDate:date]];
    //    }
    if ([str hasPrefix:@"1970"]) {
        str = @"";
        self.lblTime.hidden = YES;
    }
    return str;
}

- (NSString *)getDeadLineTime:(long long)time isAllDay:(BOOL)isAllDay
{
    NSString *str;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDate *today = [NSDate date];

	NSArray *arr = [[NSArray alloc] initWithObjects:LOCAL(CALENDAR_SCHEDULEBYWEEK_SUNDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_MONDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_TUESTDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_WEDNESDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_THURSDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_FRIDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_SATURDAY),nil];
    
    if (date.year == today.year && date.month == today.month && date.day == today.day)
    {

		str = [NSString stringWithFormat:@"%@%@%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY), isAllDay ? @"" : date.getClockTime, LOCAL(APPLY_DEADLINE_INFO)];
    }
    else if (date.year == today.year)
    {
		
		str = [NSString stringWithFormat:@"%ld/%ld(%@)%@",date.month,date.day,[arr objectAtIndex:date.weekday -1], isAllDay ? @"" : date.getClockTime];
    }
    else
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
		if (isAllDay) {
			[df setDateFormat:@"yyyy/MM/dd"];
		} else {
			[df setDateFormat:@"yyyy/MM/dd HH:mm"];
		}
		
        str = [NSString stringWithFormat:@"%@", [df stringFromDate:date]];
    }
    if ([str hasPrefix:@"1970"]) {
        str = @"";
    }
    return str;
}

#pragma mark - init
- (UILabel *)lblUnread
{
    if (!_lblUnread)
    {
        _lblUnread = [[UILabel alloc] init];
        [_lblUnread setBackgroundColor:[UIColor themeRed]];
        _lblUnread.layer.cornerRadius = 4.0f;
        _lblUnread.clipsToBounds = YES;
    }
    return _lblUnread;
}

- (UILabel *)lblUnreadComment
{
    if (!_lblUnreadComment)
    {
        _lblUnreadComment = [[UILabel alloc] init];
        [_lblUnreadComment setBackgroundColor:[UIColor themeRed]];
        _lblUnreadComment.layer.cornerRadius = 2.0f;
        _lblUnreadComment.clipsToBounds = YES;
        _lblUnreadComment.hidden = YES;
    }
    return _lblUnreadComment;
}

- (UILabel *)lblContent
{
    if (!_lblContent)
    {
        _lblContent = [[UILabel alloc] init];
        _lblContent.textColor = [UIColor mtc_colorWithHex:0x666666];
        [_lblContent setFont:[UIFont mtc_font_30]];
        [_lblContent setTextAlignment:NSTextAlignmentLeft];
    }
    return _lblContent;
}

- (UILabel *)lblFrom
{
    if (!_lblFrom)
    {
        _lblFrom = [[UILabel alloc] init];
        [_lblFrom setBackgroundColor:[UIColor mtc_colorWithHex:0xeeeeee]];
        [_lblFrom setTextColor:[UIColor mtc_colorWithHex:0x666666]];
        [_lblFrom setTextAlignment:NSTextAlignmentCenter];
        [_lblFrom setFont:[UIFont mtc_font_30]];
        _lblFrom.layer.cornerRadius = 2.0f;
        _lblFrom.clipsToBounds = YES;
    }
    return _lblFrom;
}

- (UIImageView *)imgHead
{
    if (!_imgHead)
    {
        _imgHead = [[UIImageView alloc] init];
        _imgHead.layer.cornerRadius = 2.0f;
    }
    return _imgHead;
}

- (UIImageView *)imgcomment
{
    if (!_imgcomment)
    {
        _imgcomment = [[UIImageView alloc]init];
        _imgcomment.image = [UIImage imageNamed:@"comment"];
    }
    return _imgcomment;
}

- (UIImageView *)imgAttachment
{
    if (!_imgAttachment)
    {
        _imgAttachment = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgAttachment.image = [UIImage imageNamed:@"paper-clip"];
        _imgAttachment.hidden = NO;
    }
    return _imgAttachment;
}

- (UILabel *)lblName
{
    if (!_lblName)
    {
        _lblName = [[UILabel alloc] init];
        _lblName.textColor = [UIColor mtc_colorWithHex:0x000000];
        _lblName.textAlignment = NSTextAlignmentLeft;
        [_lblName setFont:[UIFont mtc_font_26]];
    }
    return _lblName;
}

- (UILabel *)lblTime
{
    if (!_lblTime)
    {
        _lblTime = [[UILabel alloc] init];
        _lblTime.textAlignment = NSTextAlignmentLeft;
        _lblTime.textColor = [UIColor mtc_colorWithHex:0x666666];
        [_lblTime setFont:[UIFont mtc_font_24]];
    }
    return _lblTime;
}

- (UILabel *)lblEndTime
{
    if (!_lblEndTime)
    {
        _lblEndTime = [[UILabel alloc] init];
        _lblEndTime.textAlignment = NSTextAlignmentRight;
        _lblEndTime.font = [UIFont mtc_font_24];
        _lblEndTime.textColor = [UIColor themeRed];
    }
    return _lblEndTime;
}

- (UIButton *)stateBtn
{
    if (!_stateBtn)
    {
        _stateBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _stateBtn.layer.cornerRadius = self.frame.size.height * 0.20;
        _stateBtn.layer.masksToBounds = YES;
        [_stateBtn setTintColor:[UIColor whiteColor]];
        _stateBtn.titleLabel.font = [UIFont mtc_font_24];
        _stateBtn.userInteractionEnabled = NO;
        
    }
    return _stateBtn;
}
@end
