//
//  ChatEventScheduleTableViewCell.m
//  launcher
//
//  Created by jasonwang on 15/10/10.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatEventScheduleTableViewCell.h"
#import "Images.h"
#import "AppScheduleModel.h"
#import "NSDate+MsgManager.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import "NSDate+String.h"
#import "Category.h"

typedef enum : NSUInteger {
    Attend,
    Not_Attend,
} AttendEnum;

#define FONT_2 14
#define OFFSET 10
#define GRAY_COLOR [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1]
#define BLUE_COLOR [UIColor colorWithRed:27/255.0 green:131/255.0 blue:254/255.0 alpha:1]
static BOOL isScheduleHandled = NO;
static CGFloat const kChatEventScheduleCellNoHandledStateHeight = 193;
static CGFloat  const kChatEventScheduleCellHandledStateHeight = 156;

@interface ChatEventScheduleTableViewCell()
@property (nonatomic, strong) UIImageView *dateIcon;  //日期图标
@property (nonatomic, strong) UILabel *date;          //日期
@property (nonatomic, strong) UILabel *time;          //时间
@property (nonatomic, strong) UILabel *duration;      //时长
@property (nonatomic, strong) UIImageView *siteIcon;  //会议地址图标
@property (nonatomic, strong) UILabel *site;         //会议地点
@property (nonatomic, strong) UIButton *joinButton;   //参加按钮
@property (nonatomic, strong) UIButton *refuseButton; //
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIView *line3;
////文字图标，在结果已定时显示
//@property (nonatomic, strong) UILabel *dateLabel;
//@property (nonatomic, strong) UILabel *siteLabel;

//@property (nonatomic) BOOL canSelect;           //是否已处理

@property (nonatomic, strong) AppScheduleModel *scheduleModel;
@property (nonatomic, strong) MessageAppModel *messageAppModel;

@end

@implementation ChatEventScheduleTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - setData

- (void)setCellData:(MessageBaseModel *)model
{
    //取出下层model
    self.messageAppModel = model.appModel;
    self.scheduleModel = [AppScheduleModel mj_objectWithKeyValues:self.messageAppModel.applicationDetailDictionary];
    //设置标题
    [self.eventContentLabel setText:self.scheduleModel.title];
    if (self.scheduleModel.roomName.length != 0)
    {
        //设置会议场地
        [self.site setText:self.scheduleModel.roomName];
    }
    else
    {
        [self.site setText:self.scheduleModel.external];
    }
    
    //处理日期及设置
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:self.scheduleModel.start/1000];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:self.scheduleModel.end/1000];
    [self.date setText:[date1 mtc_startToEndDate:date2]];
    //处理时间段及设置
//    NSString *startTime = [NSDate timeStringFromlong:self.scheduleModel.start];
//    NSString *endTime = [NSDate timeStringFromlong:self.scheduleModel.end];
//    NSString *time = [NSString stringWithFormat:@"%@~%@",startTime,endTime];
//    [self.time setText:time];
    //设置发送人信息及发送时间
    //[self.sendManLabel setText:model.getNickName];
    [self setEventSendManLabel:self.messageAppModel.msgFrom];
    [self.sendTimeLabel setText:[NSDate im_dateFormaterWithTimeInterval:model._createDate appendMinute:NO]];
    //设置持续时长
    [self.duration setText:[NSDate compareTwoTime:self.scheduleModel.start time2:self.scheduleModel.end]];
    
    
    [self.eventTypeLabel setText:LOCAL(Application_Calendar)];
    
    [self.eventStatusLabel setText:LOCAL(MEETING_ATTEND)];
    [self.eventStatusLabel setTextColor:BLUE_COLOR];
//    //设置是否已处理
//    if(self.messageAppModel.msgHandleStatus == 1)
//    {
//        self.canSelect = NO;
//    }
//    else
//    {
//        self.canSelect = YES;
//    }
    if (self.messageAppModel.msgHandleStatus) {
        //已处理，隐藏下方按钮
        [self.line2 setHidden:YES];
        [self.line3 setHidden:YES];
        [self.joinButton setHidden:YES];
        [self.refuseButton setHidden:YES];
    }
    else
    {
        //未处理，显示下方按钮
        [self.line2 setHidden:NO];
        [self.line3 setHidden:NO];
        [self.joinButton setHidden:NO];
        [self.refuseButton setHidden:NO];
    }
    

    //设置是否已读
    if (self.messageAppModel.msgReadStatus == 0) {
        [self.redpoint setHidden:NO];
    }
    else
    {
        [self.redpoint setHidden:YES];
    }
}

+ (CGFloat)cellHeight {
	if (isScheduleHandled) {
		return kChatEventScheduleCellHandledStateHeight;
	} else {
		return kChatEventScheduleCellNoHandledStateHeight;
	}
}

- (void)setScheduleEventHandleStateWithAppModel:(MessageAppModel *)model {
	isScheduleHandled = model.msgHandleStatus == 1;
}

#pragma mark - updateConstraints

- (void)updateConstraints
{
//    if (self.canSelect) {
    [self.dateIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(OFFSET);
        make.width.height.mas_equalTo(16);
        make.top.equalTo(self.line1.mas_bottom).offset(OFFSET);
    }];
    
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateIcon.mas_right).offset(OFFSET);
//        make.width.lessThanOrEqualTo(@200);
        make.centerY.equalTo(self.dateIcon);
    }];
    
    [self.siteIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.dateIcon);
        make.top.equalTo(self.dateIcon.mas_bottom).offset(OFFSET);
        make.height.equalTo(self.dateIcon).offset(2);
        make.width.equalTo(self.dateIcon).offset(-2);
    }];
    
    [self.site mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.date);
        make.centerY.equalTo(self.siteIcon);
        make.right.equalTo(self.bgView).offset(-15);
    }];

    
    [self.duration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.date.mas_right).offset(OFFSET);
        make.right.lessThanOrEqualTo(self.bgView).offset(-10);
        make.centerY.equalTo(self.date);
        make.width.equalTo(@80);
    }];
    
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.siteIcon.mas_bottom).offset(OFFSET + 3);
    }];
    
    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom);
        make.left.equalTo(self.bgView);
        make.height.mas_equalTo(45);
        
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.top.equalTo(self.joinButton);
        make.left.equalTo(self.joinButton.mas_right);
        make.bottom.equalTo(self.bgView);
        
    }];
    
    [self.refuseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line3.mas_right);
        make.height.width.equalTo(self.joinButton);
        make.right.equalTo(self.bgView);
        make.top.equalTo(self.joinButton);
    }];

    [super updateConstraints];
}

#pragma mark - Button Click
- (void)btnAttendbtn:(UIButton *)btn
{
    
    //按钮暴力点击防御
    [self.refuseButton mtc_deterClickedRepeatedly];
    [self.joinButton mtc_deterClickedRepeatedly];
    
    BOOL agree;
    if (btn.tag == Attend)
    {
        // 参加
        agree = YES;
    }
    else {
        // 拒绝
        agree = NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(ChatEventScheduleTableViewCellDelegateCallBack_btnAttendClicked: ShowId:)])
    {
        AppScheduleModel *scheduleModel = [AppScheduleModel mj_objectWithKeyValues:self.messageAppModel.applicationDetailDictionary];
        [self.delegate ChatEventScheduleTableViewCellDelegateCallBack_btnAttendClicked:agree ShowId:scheduleModel.id];
    }
}


#pragma mark - initComponent

- (void)initComponent
{
    [self.bgView addSubview:self.dateIcon];
    [self.bgView addSubview:self.date];
    [self.bgView addSubview:self.time];
    [self.bgView addSubview:self.duration];
    [self.bgView addSubview:self.site];
    [self.bgView addSubview:self.siteIcon];
    [self.bgView addSubview:self.line3];
    [self.bgView addSubview:self.line2];
    [self.bgView addSubview:self.joinButton];
    [self.bgView addSubview:self.refuseButton];
//    [self.bgView addSubview:self.dateLabel];
//    [self.bgView addSubview:self.siteLabel];
}


#pragma mark - init UI
- (UIImageView *)dateIcon
{
    if (!_dateIcon) {
        _dateIcon = [[UIImageView alloc] init];
        [_dateIcon setImage:[UIImage imageNamed:IMG_CHAT_APP_CALENDAR]];
    }
    return _dateIcon;
}

- (UIImageView *)siteIcon
{
    if (!_siteIcon) {
        _siteIcon = [[UIImageView alloc] init];
        [_siteIcon setImage:[UIImage imageNamed:IMG_CHAT_APP_POINTER]];
    }
    return _siteIcon;
}

- (UIView *)line2
{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor mtc_colorWithHex:0xebebeb];
    }
    return _line2;
}

- (UIView *)line3
{
    if (!_line3) {
        _line3 = [[UIView alloc] init];
        _line3.backgroundColor = [UIColor mtc_colorWithHex:0xebebeb];
    }
    return _line3;
}

- (UILabel *)date
{
    if (!_date) {
        _date = [[UILabel alloc] init];
        _date.font = [UIFont systemFontOfSize:FONT_2];
        [_date setAdjustsFontSizeToFitWidth:YES];
    }
    return _date;
}

- (UILabel *)time
{
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.font = [UIFont systemFontOfSize:FONT_2];
    }
    return _time;
}

- (UILabel *)duration
{
    if (!_duration) {
        _duration = [[UILabel alloc] init];
        _duration.font = [UIFont systemFontOfSize:FONT_2];
        [_duration setTextColor:[UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1]];
        [_duration setAdjustsFontSizeToFitWidth:YES];
    }
    return _duration;
}

- (UILabel *)site
{
    if (!_site) {
        _site = [[UILabel alloc] init];
        _site.font = [UIFont systemFontOfSize:FONT_2];
    }
    return _site;
}

- (UIButton *)joinButton
{
    if (!_joinButton) {
        _joinButton = [[UIButton alloc] init];
        [_joinButton setTitle:LOCAL(MEETING_ATTEND) forState:UIControlStateNormal];
        [_joinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_joinButton addTarget:self action:@selector(btnAttendbtn:) forControlEvents:UIControlEventTouchUpInside];
        _joinButton.tag = Attend;
    }
    return _joinButton;
}

- (UIButton *)refuseButton
{
    if (!_refuseButton) {
        _refuseButton = [[UIButton alloc] init];
        [_refuseButton setTitle:LOCAL(MEETING_NOTATTEND) forState:UIControlStateNormal];
        [_refuseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_refuseButton addTarget:self action:@selector(btnAttendbtn:) forControlEvents:UIControlEventTouchUpInside];
        _refuseButton.tag = Not_Attend;
    }
    return _refuseButton;
}

//- (UILabel *)dateLabel
//{
//    if (!_dateLabel) {
//        _dateLabel = [[UILabel alloc] init];
//        [_dateLabel setText:[NSString stringWithFormat:@"%@ :",LOCAL(CALENDAR_SCHEDULEBYWEEK_TIME)]];
//        _dateLabel.font = [UIFont systemFontOfSize:FONT_2];
//        [_dateLabel setTextColor:GRAY_COLOR];
//    }
//    return _dateLabel;
//}
//
//- (UILabel *)siteLabel  // -------
//{
//    if (!_siteLabel) {
//        _siteLabel = [[UILabel alloc] init];
//        [_siteLabel setText:[NSString stringWithFormat:@"%@ :",LOCAL(PLACE)]];
//        _siteLabel.font = [UIFont systemFontOfSize:FONT_2];
//        [_siteLabel setTextColor:GRAY_COLOR];
//    }
//    return _siteLabel;
//}

- (AppScheduleModel *)scheduleModel
{
    if (!_scheduleModel) {
        _scheduleModel = [[AppScheduleModel alloc] init];
    }
    return _scheduleModel;
}

- (MessageAppModel *)messageAppModel
{
    if (!_messageAppModel) {
        _messageAppModel = [[MessageAppModel alloc] init];
        
    }
    return _messageAppModel;
}

@end
