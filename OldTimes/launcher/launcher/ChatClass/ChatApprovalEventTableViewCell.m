//
//  ChatApprovalEventTableViewCell.m
//  launcher
//
//  Created by TabLiu on 15/11/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatApprovalEventTableViewCell.h"
#import "MyDefine.h"
#import "AppApprovalModel.h"
#import "NSDate+MsgManager.h"
#import "NSDate+DateTools.h"
#import "NSDate+String.h"
#import "UIButton+DeterReClicked.h"

typedef NS_ENUM(NSInteger, ChatApprovalEventType) {
    Define          = 0,
    _total          = 1,
    _deadline       = 2,
    only_Class      = 3,
};

#define FONT 14
#define GREEN_COLOR [UIColor colorWithRed:39/255.0 green:184/255.0 blue:81/255.0 alpha:1]
#define BLUE_COLOR [UIColor colorWithRed:27/255.0 green:131/255.0 blue:254/255.0 alpha:1]

@interface ChatApprovalEventTableViewCell ()

@property (nonatomic,strong) UIImageView * timeIconimage;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UILabel * totalTimeLabel;

@property (nonatomic,strong) UIImageView * timeIntervalIconImage;
@property (nonatomic,strong) UILabel * timeIntervalLabel;

@property (nonatomic,strong) UIImageView * ClassIconImage;
@property (nonatomic,strong) UILabel * classLabel ;

@property (nonatomic,strong) UIImageView * moneyIconImage;
@property (nonatomic,strong) UILabel * moneyLabel ;

@property (nonatomic,strong) UIView * line2;
@property (nonatomic,strong) UIView * line3;
@property (nonatomic,strong) UIView * line4 ;

@property (nonatomic,strong) UIButton * unStandardButton;//打回
@property (nonatomic,strong) UIButton * vetoButton;      //否决
@property (nonatomic,strong) UIButton * consentButton;   //同意

@property (nonatomic) ChatApprovalEventType  chatApprovalEventType ;

@end

@implementation ChatApprovalEventTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.timeIconimage];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.totalTimeLabel];
        
        [self.contentView addSubview:self.timeIntervalIconImage];
        [self.contentView addSubview:self.timeIntervalLabel];
        
        [self.contentView addSubview:self.ClassIconImage];
        [self.contentView addSubview:self.classLabel];
        [self.contentView addSubview:self.moneyLabel];
        
        [self.bgView addSubview:self.line2];
        [self.bgView addSubview:self.line3];
        [self.bgView addSubview:self.line4];
        
        [self.contentView addSubview:self.unStandardButton];
        [self.contentView addSubview:self.vetoButton];
        [self.contentView addSubview:self.consentButton];
        
    }
    return self;
}

- (void)setCellData:(MessageBaseModel *)model
{
    _hight = 120;
    //取出下层MODEL
    MessageAppModel *  messageAppModel = model.appModel;
    AppApprovalModel * taskModel = [AppApprovalModel mj_objectWithKeyValues:messageAppModel.applicationDetailDictionary];
    //设置发送人及发送时间
    //[self.sendManLabel setText:model.getNickName];
    [self setEventSendManLabel:messageAppModel.msgFrom];
    [self.sendTimeLabel setText:[NSDate im_dateFormaterWithTimeInterval:model._createDate]];
    [self.eventTypeLabel setText:LOCAL(APPLY_ACCEPT_ACCEPTBTN_TITLE)];
    //设置标题
    self.eventContentLabel.text = taskModel.title;
    
    if (![taskModel.title length]) {
        self.eventContentLabel.text = messageAppModel.msgTitle;
    }
    
    //设置审批类型
    self.classLabel.text =  taskModel.approvalType;
    //设置未读标志
    if (messageAppModel.msgReadStatus == 0) {
        [self.redpoint setHidden:NO];
    }
    else
    {
        [self.redpoint setHidden:YES];
    }
    
    // 费用是否隐藏
    if ([taskModel.fee floatValue] > 0) {
        self.moneyLabel.hidden = NO;
        self.moneyLabel.text = taskModel.fee;
    }else {
        self.moneyLabel.hidden = YES;
    }
    // 设置 消息是否已处理
    if (messageAppModel.msgHandleStatus) {
        [self setBtnHidden:YES];
    }else {
        [self setBtnHidden:NO];
    }

    // 判断 要展示的界面效果
    if (taskModel.start == taskModel.end && taskModel.deadline <= 0) {
        // 仅 分类
        _chatApprovalEventType = only_Class;
        
        self.timeIconimage.hidden = YES;
        self.timeLabel.hidden = YES;
        self.totalTimeLabel.hidden = YES;
        
        self.timeIntervalIconImage.hidden = YES;
        self.timeIntervalLabel.hidden = YES;
        
        self.ClassIconImage.hidden = NO;
        self.classLabel.hidden = NO;

        //[self onlyClassFrome];
        
    }else if (taskModel.start == taskModel.end && taskModel.deadline > 0) {
        // 截止
        _chatApprovalEventType = _deadline;

        self.timeIconimage.hidden = YES;
        self.timeLabel.hidden = YES;
        self.totalTimeLabel.hidden = YES;
        
        self.timeIntervalIconImage.hidden = NO;
        self.timeIntervalLabel.hidden = NO;
        
        self.ClassIconImage.hidden = NO;
        self.classLabel.hidden = NO;

        NSString * deadlineString = [self getDeadLineTime:taskModel.deadline];
        self.timeIntervalLabel.text = [NSString stringWithFormat:@"%@截止",deadlineString];

        //[self deadlineFrome];
        
    }else if (taskModel.start != taskModel.end && taskModel.deadline <= 0) {
        // 时间段
        _chatApprovalEventType = _total;

        self.timeIconimage.hidden = NO;
        self.timeLabel.hidden = NO;
        self.totalTimeLabel.hidden = NO;
        
        self.timeIntervalIconImage.hidden = YES;
        self.timeIntervalLabel.hidden = YES;
        
        self.ClassIconImage.hidden = NO;
        self.classLabel.hidden = NO;

        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:taskModel.start/1000];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:taskModel.end/1000];
        NSString * string = [date1 mtc_startToEndDate:date2];
        
        //设置时间及时长
        self.timeLabel.text  = string;
        self.totalTimeLabel.text = [NSDate compareTwoTime:taskModel.start time2:taskModel.end];
        self.totalTimeLabel.hidden = NO;
        
        //[self totalFrome];
        
    }else if (taskModel.start != taskModel.end && taskModel.deadline > 0) {
        //define
        // 截止
        _chatApprovalEventType = Define;

        self.timeIconimage.hidden = NO;
        self.timeLabel.hidden = NO;
        self.totalTimeLabel.hidden = NO;
        
        self.timeIntervalIconImage.hidden = NO;
        self.timeIntervalLabel.hidden = NO;
        
        self.ClassIconImage.hidden = NO;
        self.classLabel.hidden = NO;

        NSString * deadlineString = [self getDeadLineTime:taskModel.deadline];
        self.timeIntervalLabel.text = [NSString stringWithFormat:@"%@截止",deadlineString];;
        // 时间段
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:taskModel.start/1000];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:taskModel.end/1000];
        NSString * string = [date1 mtc_startToEndDate:date2];
        //设置时间及时长
        self.timeLabel.text  = string;
        self.totalTimeLabel.text = [NSDate compareTwoTime:taskModel.start time2:taskModel.end];
        self.totalTimeLabel.hidden = NO;
        
        //[self defineFrome];
    }
    [self setNeedsUpdateConstraints];
    
}

- (void)setBtnHidden:(BOOL)isHidden
{
    _line2.hidden = isHidden;
    _line3.hidden = isHidden;
    _line4.hidden = isHidden;
    _unStandardButton.hidden = isHidden;//打回
    _vetoButton.hidden = isHidden;      //否决
    _consentButton.hidden = isHidden;   //同意
}

#pragma mark - tool
- (NSString *)getDeadLineTime:(long long)time
{
    NSString *str;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDate *today = [NSDate date];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:LOCAL(CALENDAR_SCHEDULEBYWEEK_SUNDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_MONDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_TUESTDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_WEDNESDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_THURSDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_FRIDAY),LOCAL(CALENDAR_SCHEDULEBYWEEK_SATURDAY),nil];
    
    if (date.year == today.year && date.month == today.month && date.day == today.day)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm"];
        //        str = [NSString stringWithFormat:@"%@%@%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY),[df stringFromDate:date],LOCAL(APPLY_ACCEPT_BEFORE)];
        //去掉截止
        str = [NSString stringWithFormat:@"%@%@",LOCAL(CALENDAR_SCHEDULEBYWEEK_TODAY),[df stringFromDate:date]];
    }
    else if (date.year == today.year)
    {
        //        str = [NSString stringWithFormat:@"%ld/%ld(%@)%ld:%ld%@",date.month,date.day,[arr objectAtIndex:date.weekday -1],date.hour,date.minute,LOCAL(APPLY_ACCEPT_BEFORE)];
        //去掉截止
        str = [NSString stringWithFormat:@"%ld/%ld(%@)%ld:%ld",(long)date.month,date.day,[arr objectAtIndex:date.weekday -1],date.hour,date.minute];
    }
    else
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy/MM/dd HH:mm"];
        //        str = [NSString stringWithFormat:@"%@%@",[df stringFromDate:date],LOCAL(APPLY_ACCEPT_BEFORE)];
        //去掉截止
        str = [NSString stringWithFormat:@"%@",[df stringFromDate:date]];
    }
    if ([str hasPrefix:@"1970"]) return nil;
    return str;
}

- (void)updateConstraints
{
    switch (_chatApprovalEventType) {
        case Define:
            [self defineFrome];
            break;
        case _deadline:
            [self deadlineFrome];
            break;
        case _total:
            [self totalFrome];
            break;
        case only_Class:
            [self onlyClassFrome];
            break;

        default:
            break;
    }
    if (self.line2.hidden == NO) {
        [self.line2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left);
            make.right.equalTo(self.bgView.mas_right);
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-41);
            make.height.equalTo(@1);
        }];
        //按钮
        float with = ([[UIScreen mainScreen] bounds].size.width - 26)/3 - 1;
        [self.unStandardButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line2.mas_bottom);
            make.left.equalTo(self.bgView.mas_left);
            make.bottom.equalTo(self.bgView.mas_bottom);
            make.width.mas_equalTo(@(with));
        }];
        //线
        [self.line3 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line2.mas_bottom);
            make.left.equalTo(self.unStandardButton.mas_right);
            make.bottom.equalTo(self.bgView.mas_bottom);
            make.right.equalTo(self.vetoButton.mas_left);
        }];
        
        [self.vetoButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line2.mas_bottom);
            make.left.equalTo(self.unStandardButton.mas_right).offset(1);
            make.bottom.equalTo(self.bgView.mas_bottom);
            make.width.equalTo(self.unStandardButton);
        }];
        //线
        [self.line4 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line2.mas_bottom);
            make.left.equalTo(self.vetoButton.mas_right);
            make.bottom.equalTo(self.bgView.mas_bottom);
            make.right.equalTo(self.consentButton.mas_left);
        }];
        
        [self.consentButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line2.mas_bottom);
            make.left.equalTo(self.vetoButton.mas_right).offset(1);
            make.bottom.equalTo(self.bgView.mas_bottom);
            make.width.equalTo(self.unStandardButton);
        }];
    }

    [super updateConstraints];
}

#pragma mark - set frome 
- (void)totalFrome
{
    [self.timeIconimage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1.mas_bottom).offset(15);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.width.height.equalTo(@16);
    }];
    [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeIconimage.mas_centerY);
        make.left.equalTo(self.timeIconimage.mas_right).offset(10);
    }];
    [self.totalTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeIconimage.mas_centerY);
        make.left.equalTo(self.timeLabel.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.bgView).offset(-10);
        make.width.equalTo(@80);
    }];
    
    if (self.line2.hidden == YES) {
        [self.ClassIconImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-10);
            make.left.equalTo(self.bgView.mas_left).offset(10);
            make.width.equalTo(@16);
            make.height.equalTo(@16);
        }];
        
    }else {
        [self.ClassIconImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-50);
            make.left.equalTo(self.bgView.mas_left).offset(10);
            make.width.equalTo(@16);
            make.height.equalTo(@16);
        }];
    }
    [self.classLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ClassIconImage.mas_centerY);
        make.left.equalTo(self.ClassIconImage.mas_right).offset(10);
    }];
    [self.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.classLabel.mas_centerY);
        make.left.equalTo(self.classLabel.mas_right).offset(10);
    }];
 
}
- (void)deadlineFrome
{
    [self.timeIntervalIconImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ClassIconImage.mas_top).offset(-15);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.width.equalTo(@16);
        make.height.equalTo(@16);
    }];
    [self.timeIntervalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeIntervalIconImage.mas_centerY);
        make.left.equalTo(self.timeIntervalIconImage.mas_right).offset(10);
    }];
    
    if (self.line2.hidden == YES) {
        [self.ClassIconImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-10);
            make.left.equalTo(self.bgView.mas_left).offset(10);
            make.width.equalTo(@16);
            make.height.equalTo(@16);
        }];
        
    }else {
        [self.ClassIconImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-50);
            make.left.equalTo(self.bgView.mas_left).offset(10);
            make.width.equalTo(@16);
            make.height.equalTo(@16);
        }];
    }
    [self.classLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ClassIconImage.mas_centerY);
        make.left.equalTo(self.ClassIconImage.mas_right).offset(10);
    }];
    [self.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.classLabel.mas_centerY);
        make.left.equalTo(self.classLabel.mas_right).offset(10);
    }];
    
}
- (void)onlyClassFrome
{
    if (self.line2.hidden == YES) {
        [self.ClassIconImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-10);
            make.left.equalTo(self.bgView.mas_left).offset(10);
            make.width.equalTo(@16);
            make.height.equalTo(@16);
        }];
        
    }else {
        [self.ClassIconImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-50);
            make.left.equalTo(self.bgView.mas_left).offset(10);
            make.width.equalTo(@16);
            make.height.equalTo(@16);
        }];
    }
    [self.classLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ClassIconImage.mas_centerY);
        make.left.equalTo(self.ClassIconImage.mas_right).offset(10);
    }];
    [self.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.classLabel.mas_centerY);
        make.left.equalTo(self.classLabel.mas_right).offset(10);
    }];
    

}
- (void)defineFrome
{
    [self.timeIconimage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1.mas_bottom).offset(15);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.width.height.equalTo(@16);
    }];
    [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeIconimage.mas_centerY);
        make.left.equalTo(self.timeIconimage.mas_right).offset(10);
    }];
    [self.totalTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeIconimage.mas_centerY);
        make.left.equalTo(self.timeLabel.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.bgView).offset(-10);
        make.width.equalTo(@80);
    }];
    
    [self.timeIntervalIconImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ClassIconImage.mas_top).offset(-15);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.width.equalTo(@16);
        make.height.equalTo(@16);
    }];
    [self.timeIntervalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeIntervalIconImage.mas_centerY);
        make.left.equalTo(self.timeIntervalIconImage.mas_right).offset(10);
    }];
    if (self.line2.hidden == YES) {
        [self.ClassIconImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-10);
            make.left.equalTo(self.bgView.mas_left).offset(10);
            make.width.equalTo(@16);
            make.height.equalTo(@16);
        }];

    }else {
        [self.ClassIconImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-50);
            make.left.equalTo(self.bgView.mas_left).offset(10);
            make.width.equalTo(@16);
            make.height.equalTo(@16);
        }];
    }
    [self.classLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ClassIconImage.mas_centerY);
        make.left.equalTo(self.ClassIconImage.mas_right).offset(10);
    }];
    [self.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.classLabel.mas_centerY);
        make.left.equalTo(self.classLabel.mas_right).offset(10);
    }];
}





#pragma mark - UI

- (UIImageView *)timeIconimage
{
    if (!_timeIconimage) {
        _timeIconimage = [[UIImageView alloc] init];
        _timeIconimage.userInteractionEnabled = YES;
        _timeIconimage.image = [UIImage imageNamed:@"calendar"];
    }
    return _timeIconimage;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.font = [UIFont systemFontOfSize:FONT];
        [_timeLabel setAdjustsFontSizeToFitWidth:YES];
    }
    return _timeLabel;
}

- (UILabel * )totalTimeLabel
{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textAlignment = NSTextAlignmentLeft;
        _totalTimeLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
        _totalTimeLabel.font = [UIFont systemFontOfSize:FONT];
        [_totalTimeLabel setAdjustsFontSizeToFitWidth:YES];
    }
    return _totalTimeLabel;
}

- (UIImageView *)timeIntervalIconImage
{
    if (!_timeIntervalIconImage) {
        _timeIntervalIconImage = [[UIImageView alloc] init];
        _timeIntervalIconImage.userInteractionEnabled = YES;
        _timeIntervalIconImage.image = [UIImage imageNamed:@"clock_red"];
    }
    return _timeIntervalIconImage;
}
- (UILabel *)timeIntervalLabel
{
    if (!_timeIntervalLabel) {
        _timeIntervalLabel = [[UILabel alloc] init];
        _timeIntervalLabel.textColor = [UIColor colorWithRed:251/255.0 green:27/255.0 blue:91/255.0 alpha:1];
        _timeIntervalLabel.textAlignment = NSTextAlignmentLeft;
        _timeIntervalLabel.font = [UIFont systemFontOfSize:FONT];
    }
    return _timeIntervalLabel;
}

- (UIImageView *)ClassIconImage
{
    if (!_ClassIconImage) {
        _ClassIconImage = [[UIImageView alloc] init];
        _ClassIconImage.userInteractionEnabled = YES;
        _ClassIconImage.image = [UIImage imageNamed:@"tag"];
    }
    return _ClassIconImage;
}

- (UILabel *)classLabel
{
    if (!_classLabel) {
        _classLabel = [[UILabel alloc] init];
        _classLabel.textColor = [UIColor blackColor];
        _classLabel.font = [UIFont systemFontOfSize:FONT];
    }
    return _classLabel;
}

- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor blackColor];
        _moneyLabel.font = [UIFont systemFontOfSize:FONT];
    }
    return _moneyLabel;
}

- (UIView *)line2
{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }
    return _line2;
}
- (UIView *)line3
{
    if (!_line3) {
        _line3 = [[UIView alloc] init];
        _line3.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }
    return _line3;
}
- (UIView *)line4
{
    if (!_line4) {
        _line4 = [[UIView alloc] init];
        _line4.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }
    return _line4;
}


- (UIButton *)unStandardButton
{
    if (!_unStandardButton) {
        _unStandardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unStandardButton setTitle:LOCAL(APPLY_SENDER_BACKWARD_TITLE) forState:UIControlStateNormal];
        [_unStandardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_unStandardButton setImage:[UIImage imageNamed:@"backward-gray"] forState:UIControlStateNormal];
//        [_unStandardButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        [_unStandardButton addTarget:self action:@selector(unStandardButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unStandardButton;
}

- (UIButton *)vetoButton{
    if (!_vetoButton) {
        _vetoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vetoButton setTitle:LOCAL(REFUSE) forState:UIControlStateNormal];
        [_vetoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_vetoButton setImage:[UIImage imageNamed:@"X_gray"] forState:UIControlStateNormal];
//        [_vetoButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        [_vetoButton addTarget:self action:@selector(vetoButtonCilck) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _vetoButton;
}
- (UIButton *)consentButton{
    if (!_consentButton) {
        _consentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_consentButton setTitle:LOCAL(APPLY_SENDER_ACCEPT_TITLE) forState:UIControlStateNormal];
        [_consentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_consentButton setImage:[UIImage imageNamed:@"Accept"] forState:UIControlStateNormal];
//        [_consentButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        [_consentButton addTarget:self action:@selector(consentButtonCilck) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _consentButton;
}

#pragma mark - btn
- (void)unStandardButtonCilck
{
    //按钮暴力点击防御
    [self.unStandardButton mtc_deterClickedRepeatedly];
    
    [self delegateBackButtonClickType:Back_to];
    
}
- (void)vetoButtonCilck
{
    //按钮暴力点击防御
    [self.vetoButton mtc_deterClickedRepeatedly];
    
    [self delegateBackButtonClickType:unPass];
    
}
- (void)consentButtonCilck
{
    //按钮暴力点击防御
    [self.consentButton mtc_deterClickedRepeatedly];
    
    [self delegateBackButtonClickType:pass];
    
}

- (void)delegateBackButtonClickType:(NSString *)type
{
    if (_delegate && [_delegate respondsToSelector:@selector(approvalCellButtonClick: path_row:)]) {
        [_delegate approvalCellButtonClick:type path_row:self.path_row];
    }
}

@end
