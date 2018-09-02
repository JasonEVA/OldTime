//
//  AppMessageTableViewCell.m
//  launcher
//
//  Created by Tab Liu on 15/9/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "AppMessageTableViewCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "AppScheduleModel.h"
#import "AppApprovalModel.h"
#import "AppTaskModel.h"
#import "AvatarUtil.h"
#import "NSDate+MsgManager.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import "ImApplicationConfigure.h"
#import "IMApplicationEnum.h"

#define UNREAD_HIGHT 5
#define HEAD_HIGHT   30
#define FONT         [UIFont systemFontOfSize:14]
#define COLOR_GRAY   [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1]
#define LOW_COLOR [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1]      //优先级低的颜色
#define HIGH_COLOR [UIColor colorWithRed:246/255.0 green:20/255.0 blue:84/255.0 alpha:1]      //优先级高的颜色
#define MEDIUM_COLOR [UIColor colorWithRed:247/255.0 green:167/255.0 blue:89/255.0 alpha:1]   //优先级中的颜色
#define GRAY_COLOR [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1]    //灰色背景颜色
#define LABEL_WIDH_SCALE  60.0/320.0
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
@implementation AppMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatCoutomView];
        [self updateConstraints];
        //[self setUIValues];
    }
    return self;
}

#pragma mark - 创建控件的方法
//- (RedPoint *)unreadMark
//{
//    if (!_unreadMark) {
//        _unreadMark = [[RedPoint alloc] init];
//        _unreadMark.hidden = YES;
////        _unreadMark.backgroundColor = [UIColor redColor];
////        _unreadMark.layer.masksToBounds = YES; // 隐藏边界
////        _unreadMark.layer.cornerRadius = UNREAD_HIGHT/2;  // 将图层的边框设置为圆脚
//    }
//    return _unreadMark;
//}
- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.userInteractionEnabled = YES;
        _headImageView.layer.masksToBounds = YES; // 隐藏边界
        _headImageView.layer.cornerRadius = 3;  // 将图层的边框设置为圆脚
    }
    return _headImageView;
}
- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.font = FONT;
    }
    return _messageLabel;
}
- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textAlignment = NSTextAlignmentRight;
        _typeLabel.font = FONT;
        _typeLabel.textColor = [UIColor colorWithRed:51/255.0 green:145/255.0 blue:255/255.0 alpha:1];
    }
    return _typeLabel;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = FONT;
        _nameLabel.textColor = COLOR_GRAY;
    }
    return _nameLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = FONT;
//        _timeLabel.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1];
        _timeLabel.textColor = [UIColor mtc_colorWithHex:0x66666];
    }
    return _timeLabel;
}
- (UIImageView *)timeIcoImageView
{
    if (!_timeIcoImageView) {
        _timeIcoImageView = [[UIImageView alloc] init];
        _timeIcoImageView.userInteractionEnabled = YES;
    }
    return _timeIcoImageView;
}
- (UILabel *)sendTimeLabel
{
    if (!_sendTimeLabel) {
        _sendTimeLabel = [[UILabel alloc] init];
        _sendTimeLabel.textAlignment = NSTextAlignmentLeft;
        _sendTimeLabel.font = FONT;
        _sendTimeLabel.textColor = COLOR_GRAY;
    }
    return _sendTimeLabel;
}
- (UIImageView *)accessoryIcoImageView
{
    if (!_accessoryIcoImageView) {
        _accessoryIcoImageView = [[UIImageView alloc] init];
        _accessoryIcoImageView.userInteractionEnabled = YES;
        _accessoryIcoImageView.hidden = YES;
    }
    return _accessoryIcoImageView;
}
- (UIImageView *)messageIcoImageView
{
    if (!_messageIcoImageView) {
        _messageIcoImageView = [[UIImageView alloc] init];
        _messageIcoImageView.userInteractionEnabled = YES;
        _messageIcoImageView.hidden = YES;
    }
    return _messageIcoImageView;
}
- (UIImageView *)locationIcoImageView
{
    if (!_locationIcoImageView) {
        _locationIcoImageView = [[UIImageView alloc] init];
        _locationIcoImageView.userInteractionEnabled = YES;
    }
    return _locationIcoImageView;
}
- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.font = FONT;
        _locationLabel.textColor = COLOR_GRAY;
    }
    return _locationLabel;
}
#pragma mark - 位置约束
- (void)updateConstraints
{
    _locationIcoImageView.image = [UIImage imageNamed:@"chat_mission_undone"];
    CGFloat top = 8;
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(13);
        make.bottom.equalTo(self).offset(-10);
        make.width.equalTo(_headImageView.mas_height);
        
    }];
//    [_unreadMark mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(5);
//        make.top.equalTo(_headImageView);
//        make.right.equalTo(_headImageView.mas_left).offset(-2);
//    }];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(top);
        make.left.equalTo(_headImageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-50);
        //make.height.equalTo(@20);
    }];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(top);
        make.right.equalTo(self).offset(-10);
        make.left.equalTo(self).offset(-50);
        //make.height.equalTo(@20);
    }];
    //-------------------------
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headImageView.mas_bottom);
        make.left.equalTo(_headImageView.mas_right).offset(10);
        make.width.lessThanOrEqualTo(@(kScreenWidth*LABEL_WIDH_SCALE));
    }];
    [_timeIcoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headImageView.mas_bottom).offset(-2);
        make.left.equalTo(_nameLabel.mas_right).offset(5);
        make.width.equalTo(@11);
        make.height.equalTo(@11);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headImageView.mas_bottom);
        make.left.equalTo(_timeIcoImageView.mas_right).offset(3);
        make.centerY.equalTo(_timeIcoImageView);
         make.width.lessThanOrEqualTo(@(kScreenWidth*LABEL_WIDH_SCALE));
    }];
    [_locationIcoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_headImageView.mas_bottom).offset(-5);
        make.left.equalTo(_timeLabel.mas_right).offset(5);
        make.width.equalTo(@12);
        make.height.equalTo(@12);
        make.centerY.equalTo(self.timeLabel);
    }];
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headImageView.mas_bottom);
        make.left.equalTo(_locationIcoImageView.mas_right).offset(5);
        //make.bottom.equalTo(_nameLabel.mas_bottom);
       
    }];
    
    if (!_messageIcoImageView.hidden) {
        [_messageIcoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_headImageView.mas_bottom);
            make.right.equalTo(self).offset(-10);
            make.width.equalTo(@14);
            make.height.equalTo(@13);
        }];
    }
    
    if (!_accessoryIcoImageView.hidden) {
        [_accessoryIcoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_headImageView.mas_bottom);
            if (_messageIcoImageView.hidden) {
                make.right.equalTo(self.mas_left).offset(-10);
            }else {
                make.right.equalTo(_messageIcoImageView.mas_left).offset(-10);
            }
            make.width.equalTo(@9);
            make.height.equalTo(@11);
        }];
    }
    [_sendTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headImageView.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-10);
		
    }];

//    [_sendTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_headImageView.mas_bottom);
//        //make.bottom.equalTo(_nameLabel.mas_bottom);
//        if (weakSelf.accessoryIcoImageView.hidden && !weakSelf.messageIcoImageView) {
//            make.right.equalTo(_messageIcoImageView.mas_left).offset(-10);
//        }else if (weakSelf.accessoryIcoImageView.hidden && weakSelf.messageIcoImageView) {
//            make.right.equalTo(weakSelf.mas_right).offset(-10);
//        }else if (!weakSelf.accessoryIcoImageView.hidden && weakSelf.messageIcoImageView) {
//            make.right.equalTo(_accessoryIcoImageView.mas_left).offset(-10);
//        }
//    }];
    
    [super updateConstraints];
}
#pragma mark - 添加
- (void)creatCoutomView
{
    NSLog(@"==%f",kScreenWidth *LABEL_WIDH_SCALE);
    NSLog(@"==%f",kScreenWidth);
    
//    [self.contentView addSubview:self.unreadMark];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.timeIcoImageView];
    [self.contentView addSubview:self.sendTimeLabel];
    [self.contentView addSubview:self.accessoryIcoImageView];
    [self.contentView addSubview:self.messageIcoImageView];
    [self.contentView addSubview:self.locationIcoImageView];
    [self.contentView addSubview:self.locationLabel];
}
#pragma mark - 设置内容
- (void)setSearchCellData:(MessageBaseModel *)model searchText:(NSString *)text
{
    //头像
    NSString *nickName = [model getNickName];
    NSString *userName = [[MessageManager share] queryContactProfileWithNickName:nickName].userName;
    if (userName == nil || [userName isEqualToString:@""]) {
        userName = [[MessageManager share] queryContactProfileWithNickName:nickName].avatar;
    }
    NSURL *urlHead = avatarURL(avatarType_default, userName);
    [self.headImageView sd_setImageWithURL:urlHead placeholderImage:[UIImage imageNamed:@"login_login_head"]];
    //昵称
    [self setNameLabelText:nickName];
    //发送时间
    NSString *time = [NSDate im_dateFormaterWithTimeInterval:model._createDate appendMinute:NO];
    [self setSendTimeLabelText:time];
    
    self.accessoryIcoImageView.hidden = YES;
    self.messageIcoImageView.hidden = YES;
    self.locationIcoImageView.hidden = YES;
    self.locationLabel.hidden = YES;
    [self setTimeIcoImageViewImage:nil];
    
    NSDictionary *applicationDictionary = model.appModel.applicationDetailDictionary;
    
    switch ((IM_Applicaion_Type)model.appModel.eventType) {
        case IM_Applicaion_task: // 任务
        {
            AppTaskModel * model1 = [AppTaskModel mj_objectWithKeyValues:applicationDictionary];
            //[self setMessageLabelText:[self text:model1.title searchText:text]];// 任务title
            [self.messageLabel setAttributedText:[self text:model1.title searchText:text]];
            
            [self setTypeLabelText:LOCAL(Application_Mission)]; //创建任务的人的昵称
            NSString * str2 =  [self formatterTimeWithData:model1.end]; // 截止时间
            [self setTimeLabelText:[NSString stringWithFormat:@"%@",str2]];
            
            [self stateFromEnglish:model1.priority];
            [self.locationIcoImageView setImage:[UIImage imageNamed:@"Item_gray"]];
            [self.locationLabel setText:model1.stateName];

        }
            break;
            
        case IM_Applicaion_schedule: // 日程(会议)
        {
            AppScheduleModel * scheduleModel = [AppScheduleModel mj_objectWithKeyValues:applicationDictionary];

			[self.messageLabel setAttributedText:[self text:scheduleModel.title searchText:text]];
            //[self setMessageLabelText:model1.title];

            [self setTypeLabelText:LOCAL(MEETING)];
            NSString * str2 =  [NSDate timeStringFromlong:scheduleModel.end];
            NSString * str1 =  [NSDate timeStringFromlong:scheduleModel.start];
            [self setTimeLabelText:[NSString stringWithFormat:@"%@~%@",str1,str2]];
            
        }
            break;
            
        case IM_Applicaion_approval: // 审批
        {
            AppApprovalModel * model1 = [AppApprovalModel mj_objectWithKeyValues:applicationDictionary];
            [self.messageLabel setAttributedText:[self text:model1.title searchText:text]];
            //[self setMessageLabelText:model1.title];
            [self setTypeLabelText:model1.approvalType];
            NSString * str3 =  [NSDate compareTwoTime:model1.start time2:model1.end];
            [self setTimeLabelText:[NSString stringWithFormat:@"%@",str3]];
            
        }
            break;
            
        default:
            break;
    }

}
// 富文本
- (NSMutableAttributedString *)text:(NSString *)string searchText:(NSString *)text
{
    NSMutableString * mutableString = [[NSMutableString alloc] initWithString:string];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    int length = 0;
    while (YES) {
        NSRange range = [mutableString rangeOfString:text options:NSCaseInsensitiveSearch];
        if (range.length > 0) {
            NSRange newRange = NSMakeRange(range.location + length, range.length);
            [str addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:1 green:242/255.0 blue:70/255.0 alpha:1] range:newRange];
            [mutableString deleteCharactersInRange:range];
            length += range.length;
        }else {
            return str;
        }
    }
    return str;
}
- (void)setHeadImageWithUidStr:(NSString *)uid model:(MessageBaseModel *)model
{
    NSURL * urlHead;
    if ([model._toLoginName isEqualToString:uid]) {
        //好友
        if (_isGroup) {
            //群聊
            NSString *nickName = [model getNickName];
            
            UserProfileModel *groupModel = [[MessageManager share] queryContactProfileWithUid:uid];
            // 发的人的uid
            NSString *userName = [groupModel getGroupMemberUserNameWithNickName:nickName];
            urlHead = avatarURL(avatarType_default, userName);
            
            [self.nameLabel setText:nickName];
        } else {
            //单聊
            urlHead = avatarURL(avatarType_default, uid);
            NSString *nickName = [model getNickName];
            [self.nameLabel setText:nickName];
        }
    }else {
        //自己
        
        urlHead = avatarURL(avatarType_default, nil);
        [self.nameLabel setText:[UnifiedUserInfoManager share].userName];
    }
    [_headImageView sd_setImageWithURL:urlHead placeholderImage:[UIImage imageNamed:@"login_login_head"]];
}

- (void)setCellData:(MessageBaseModel *)model
{
    [self setHeadImageWithUidStr:self.uidStr model:model];
    
    NSString *time = [NSDate im_dateFormaterWithTimeInterval:model._createDate appendMinute:NO];
    [self setSendTimeLabelText:time];

    [self setTimeIcoImageViewImage:nil];

    [self setAccessoryIcoImageViewImage:nil];
    [self setMessageIcoImageViewImage:nil];
    [self setLocationIcoImageViewImage:nil];
    
    self.accessoryIcoImageView.hidden = NO;
    self.messageIcoImageView.hidden = NO;
    self.locationIcoImageView.hidden = YES;
    self.locationLabel.hidden = YES;
    
    NSDictionary *applicationDictionary = model.appModel.applicationDetailDictionary;
    
    switch ((IM_Applicaion_Type)model.appModel.eventType) {
        case IM_Applicaion_task: // 任务
        {
            [self setTaskData:model];
        }
            break;
            
        case IM_Applicaion_schedule: // 日程(会议)
        {
            AppScheduleModel * model1 = [AppScheduleModel mj_objectWithKeyValues:applicationDictionary];
            [self setMessageLabelText:model1.title];
            [self setTypeLabelText:LOCAL(MEETING)];
            NSString * str2 =  [NSDate timeStringFromlong:model1.end];
            NSString * str1 =  [NSDate timeStringFromlong:model1.start];
            [self setTimeLabelText:[NSString stringWithFormat:@"%@~%@",str1,str2]];

        }
            break;

        case IM_Applicaion_approval: // 审批
        {
            AppApprovalModel * model1 = [AppApprovalModel mj_objectWithKeyValues:applicationDictionary];
            [self setMessageLabelText:model1.title];
            [self setTypeLabelText:model1.approvalType];
            NSString * str3 =  [NSDate compareTwoTime:model1.start time2:model1.end];
            [self setTimeLabelText:[NSString stringWithFormat:@"%@",str3]];

        }
            break;

        default:
            break;
    }
    
    self.accessoryIcoImageView.hidden = YES;
    self.messageIcoImageView.hidden = YES;
}

- (void)setTaskData:(MessageBaseModel *)model
{
    //设置头像
    NSString *nickName = [model getNickName];
    if (nickName && ![nickName isEqualToString:@""]) {
    }else {
//        nickName = model.sendManName;
    }
    NSString *userName = [[MessageManager share] queryContactProfileWithNickName:nickName].userName;
    NSURL *urlHead = avatarURL(avatarType_default, userName);
    [self.headImageView sd_setImageWithURL:urlHead placeholderImage:[UIImage imageNamed:@"login_login_head"]];
    
    AppTaskModel * model1 = [AppTaskModel mj_objectWithKeyValues:model.appModel.applicationDetailDictionary];
    [self setMessageLabelText:model1.title];// 任务title
    [self setTypeLabelText:LOCAL(Application_Mission)]; //创建任务的人的昵称
    NSString * str2 =  [self formatterTimeWithData:model1.end]; // 截止时间
    [self setTimeLabelText:[NSString stringWithFormat:@"截止时间%@",str2]];
    
    [self stateFromEnglish:model1.priority];
    [self.locationIcoImageView setImage:[UIImage imageNamed:@"chat_mission_undone"]];
    if ([model1.stateName isEqualToString:@"待办"]||[model1.stateName isEqualToString:@""]||[model1.stateName isEqualToString:@"WAITING"]) {
        model1.stateName= LOCAL(Application_Unfinished);
    }
    [self.locationLabel setText:model1.stateName];
    NSLog(@"name===%@",model1.stateName);
    
    self.accessoryIcoImageView.hidden = NO;
    self.messageIcoImageView.hidden = NO;
    self.locationIcoImageView.hidden = NO;
    self.locationLabel.hidden = NO;

}
//根据状态设置文本颜色
- (void)stateFromEnglish:(NSString *)state
{
    if ([state isEqualToString:@"MEDIUM"]) {
        [self.timeLabel setTextColor:MEDIUM_COLOR];
    }
    else if ([state isEqualToString:@"HIGH"])
    {
        [self.timeLabel setTextColor:HIGH_COLOR];
    }
    else
    {
        [self.timeLabel setTextColor:LOW_COLOR];
    }
}

- (NSString *)formatterTimeWithData:(long long)data
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM/dd HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:data];
    NSString * time = [formatter stringFromDate:date];
    return time;
}


//- (void)setCellIsUnread:(BOOL)isUnread
//{
//    if (isUnread) {
//        self.unreadMark.hidden = NO;
//    }else {
//        self.unreadMark.hidden = YES;
//    }
//}
- (void)setHeadImageViewImage:(NSString *)string
{
    self.headImageView.image = nil;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"image_placeholder_loading"]];
    //self.headImageView.backgroundColor = [UIColor redColor];
}
- (void)setMessageLabelText:(NSString *)string
{
    self.messageLabel.text = @"";
    self.messageLabel.text = string;
}
- (void)setTypeLabelText:(NSString *)string
{
    self.typeLabel.text = @"";
    self.typeLabel.text = string;
}
- (void)setNameLabelText:(NSString *)string
{
    self.nameLabel.text = @"";
    self.nameLabel.text = string;
}
- (void)setTimeIcoImageViewImage:(NSString *)string
{
    self.timeIcoImageView.image = [UIImage imageNamed:@"clock"];
}
- (void)setTimeLabelText:(NSString *)string
{
    self.timeLabel.text = @"";
    self.timeLabel.text = string;
}
- (void)setSendTimeLabelText:(NSString *)string
{
    self.sendTimeLabel.text = @"";
    self.sendTimeLabel.text =string;
}
- (void)setLocationIcoImageViewImage:(NSString *)string
{
    self.locationIcoImageView.image = nil;
    self.locationIcoImageView.image = [UIImage imageNamed:@"chat_mission_undone"]; // icon_datareport
}
- (void)setAccessoryIcoImageViewImage:(NSString *)string
{
    self.accessoryIcoImageView.image = nil;
    self.accessoryIcoImageView.image = [UIImage imageNamed:@"pointer"];
}
- (void)setMessageIcoImageViewImage:(NSString *)string
{
    self.messageIcoImageView.image = nil;
    self.messageIcoImageView.image = [UIImage imageNamed:@"speach"];
}

#pragma mark - 设置控件的展示或者隐藏
- (void)accessoryIcoHidden:(BOOL)hidden
{
    self.accessoryIcoImageView.hidden = hidden;
}
- (void)messageIcoImageHidden:(BOOL)hidden
{
    self.messageIcoImageView.hidden = hidden;
}

- (void)locationIcoFidden:(BOOL)hidden
{
    self.locationIcoImageView.hidden = hidden;
}
- (void)locationLabelHidden:(BOOL)hidden
{
    self.locationLabel.hidden = hidden;
}
#pragma mark - 设置控件的颜色

- (void)setTimeLabelTextColor:(BOOL)isred
{
    if (isred) {
        self.timeLabel.textColor = [UIColor redColor];
    }else {
        self.timeLabel.textColor = COLOR_GRAY;
    }
}

@end
