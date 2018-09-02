//
//  CalendarEventListTableViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/7/29.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarEventListTableViewCell.h"
#import "CalendarLaunchrModel.h"
#import <DateTools/DateTools.h>
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "Category.h"

@interface CalendarEventListTableViewCell ()

@property (nonatomic, strong) UILabel     *lblTime;
@property (nonatomic, strong) UILabel     *lblTotalTime;
@property (nonatomic, strong) UILabel     *lblContent;
@property (nonatomic, strong) UILabel     *lblAddress;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *markImg;
@property (nonatomic, strong) UILabel     *lblImportant;

@end

@implementation CalendarEventListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initFrame];
    }
    return self;
}

- (void)setWithModel:(CalendarLaunchrModel *)model DayModel:(CalendarDateDataModel *)daymodel
{
    self.lblContent.text = model.title;
    self.lblAddress.text = model.place.name;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *dateStart = model.time[0];
    NSDate *dateEnd = model.time[1];
    self.lblTime.text = [dateFormatter stringFromDate:dateStart];
    
    NSDate *TodaydateStart = daymodel._date;
    NSDate *TodaydateEnd = [NSDate dateWithTimeInterval:24* 60 *60 - 1 sinceDate:TodaydateStart];
    
    NSTimeInterval aTimer;
    
    if ([TodaydateStart isEarlierThanOrEqualTo:dateStart] && [TodaydateEnd isLaterThanOrEqualTo:dateEnd])
    {
        aTimer = [model.time[1] timeIntervalSinceDate:model.time[0]];
    }
    else if ([TodaydateStart isLaterThanOrEqualTo:dateStart] && [TodaydateStart isEarlierThan:dateEnd] && [TodaydateEnd isLaterThanOrEqualTo:dateEnd])
    {
        aTimer = [model.time[1] timeIntervalSinceDate:TodaydateStart];
    }
    else if ([TodaydateStart isEarlierThanOrEqualTo:dateStart] && [TodaydateEnd isLaterThan:dateStart] && [TodaydateEnd isEarlierThanOrEqualTo:dateEnd])
    {
        aTimer = [TodaydateEnd timeIntervalSinceDate:model.time[0]];
    }
    else if ([TodaydateStart isLaterThanOrEqualTo:dateStart] && [TodaydateEnd isEarlierThan:dateEnd])
    {
        aTimer = [TodaydateEnd timeIntervalSinceDate:TodaydateStart];
    }
    
    int hour = (int)(aTimer/3600);
    int minute = (int)(aTimer - hour*3600)/60;
    
    if (hour == 0)
    {
        if (minute == 59)
        {
            hour = hour + 1;
            self.lblTotalTime.text = [NSString stringWithFormat:@"%d%@",hour,LOCAL(CALENDAR_HOUR)];
        }
        else
        {
            self.lblTotalTime.text = [NSString stringWithFormat:@"%d%@",minute,LOCAL(CALENDAR_MINUTE)];
        }
    }
    else
    {
        if (minute >= 57)
        {
            hour = hour + 1;
            self.lblTotalTime.text = [NSString stringWithFormat:@"%d%@",hour,LOCAL(CALENDAR_HOUR)];
        }
        else if (minute <= 3)
        {
            self.lblTotalTime.text = [NSString stringWithFormat:@"%d%@",hour,LOCAL(CALENDAR_HOUR)];
        }
        else
        {
            self.lblTotalTime.text = [NSString stringWithFormat:@"%.1f%@",aTimer / 3600,LOCAL(CALENDAR_HOUR)];
        }
    }
    
    if (model.wholeDay)
    {
        self.lblTime.text = LOCAL(MISSION_ALLDAY);
        self.lblTotalTime.text = @"";
    }
    
    else if (dateStart.day == dateEnd.day && dateStart.month == dateEnd.month && dateStart.year == dateEnd.year)
    {
        if (hour == 24)
        {
            self.lblTime.text = LOCAL(MISSION_ALLDAY);
            self.lblTotalTime.text = @"";
        }
    }
    else
    {
        if (dateStart.day == TodaydateStart.day && dateStart.month == TodaydateStart.month && dateStart.year == TodaydateStart.year)
        {
            self.lblTotalTime.text = @"";
        }
        else if(dateEnd.day == TodaydateEnd.day && dateEnd.month == TodaydateEnd.month && dateEnd.year == TodaydateEnd.year)
        {
            self.lblTime.text = LOCAL(APPLY_END_TIME);
            if ([[dateFormatter stringFromDate:dateStart] isEqualToString:@"00:00"])
            {
                self.lblTotalTime.text = LOCAL(MISSION_ALLDAY);
            }
            else
            {
              self.lblTotalTime.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:dateEnd]];
            }
        }
        else
        {
            self.lblTime.text = LOCAL(MISSION_ALLDAY);
            self.lblTotalTime.text = @"";
        }
        
    }
    
    if (model.important)
    {
        self.lblImportant.hidden = NO;
    }
    else
    {
        self.lblImportant.hidden = YES;
    }
    
    if (model.eventType == eventType_meeting_event)
    {
        [self setMarkImgWithColor:GreenColor];
    }
    else if (model.eventType == eventType_calendar_event)
    {
        [self setMarkImgWithColor:BlueColor];
    }
    else if (model.eventType == eventType_statutory_festival || model.eventType == eventType_company_festival)
    {
        [self setMarkImgWithColor:RedColor];
    }
    
    if (model.place.coordinate.latitude == 200)
    {
        [self setLocationImg:NO];
    }
    else
    {
        [self setLocationImg:YES];
    }
}

-(void)initFrame {
    [self.contentView addSubview:self.markImg];
    [self.contentView addSubview:self.lblTime];
    [self.contentView addSubview:self.lblTotalTime];

    [self.markImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(13);
        make.centerY.equalTo(self.contentView).dividedBy(2).offset(6);
        make.width.height.equalTo(@10);
    }];
    
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.markImg).offset(0.5);
        make.left.equalTo(self.markImg.mas_right).offset(8);
    }];
    
    [self.lblTotalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblTime);
//        make.centerY.equalTo(self.contentView).multipliedBy(3 / 2.0);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
    
    [self.contentView addSubview:self.lblContent];
    [self.contentView addSubview:self.lblAddress];
    [self.contentView addSubview:self.lblImportant];
    
    [self.lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblTime.mas_right).offset(8);
        make.left.greaterThanOrEqualTo(self.contentView).offset(95);
        make.centerY.equalTo(self.lblTime);
    }];
    
    [self.lblAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblContent);
        make.centerY.equalTo(self.lblTotalTime);
    }];
    
    [self.lblImportant setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.lblImportant mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblContent.mas_right).offset(8);
        make.centerY.equalTo(self.lblContent);
    }];
    
    [self.contentView addSubview:self.imgView];
    [self.imgView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-13);
        make.centerY.equalTo(self.contentView);
        make.left.greaterThanOrEqualTo(self.lblImportant.mas_right).offset(8);
        make.left.greaterThanOrEqualTo(self.lblAddress.mas_right).offset(8);
    }];
}

- (void)setLocationImg:(BOOL)isShow
{
    if (isShow)
    {
        [self.imgView setImage:[UIImage imageNamed:@"Calendar_Location_Logo"]];
    }
    else
    {
        [self.imgView setImage:nil];
    }
    
}

- (void)setMarkImgWithColor:(MarkColor)Color
{
    UIColor *color;
    
    switch (Color) {
        case ClearColor:
            color = [UIColor clearColor];
            break;
        case GreenColor:
            color = [UIColor mtc_colorWithHex:0x00bd57];
            break;
        case BlueColor:
            color = [UIColor themeBlue];
            break;
        case RedColor:
            color = [UIColor themeRed];
            break;
        default:
            color = [UIColor clearColor];
            break;
    }
             
     [self.markImg setImage:[UIImage mtc_imageColor:color size:CGSizeMake(12, 12) cornerRadius:6]];
}

#pragma mark - init
- (UILabel *)lblTime
{
    if (!_lblTime)
    {
        _lblTime = [[UILabel alloc] init];
        _lblTime.textColor = [UIColor blackColor];
        _lblTime.textAlignment = NSTextAlignmentLeft;
        _lblTime.font = [UIFont mtc_font_30];
    }
    return _lblTime;
}

- (UILabel *)lblTotalTime
{
    if (!_lblTotalTime)
    {
        _lblTotalTime = [[UILabel alloc] init];
        _lblTotalTime.textColor = [UIColor mediumFontColor];
        _lblTotalTime.font = [UIFont mtc_font_26];
        _lblTotalTime.textAlignment = NSTextAlignmentLeft;
    }
    return _lblTotalTime;
}

- (UILabel *)lblContent
{
    if (!_lblContent)
    {
        _lblContent = [[UILabel alloc] init];
        _lblContent.textColor = [UIColor blackColor];
        _lblContent.font = [UIFont mtc_font_30];
    }
    return _lblContent;
}

- (UILabel *)lblAddress
{
    if (!_lblAddress)
    {
        _lblAddress = [[UILabel alloc] init];
        _lblAddress.textColor = [UIColor mediumFontColor];
        _lblAddress.font = [UIFont mtc_font_26];
    }
    return _lblAddress;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imgView;
}

- (UIImageView *)markImg
{
    if (!_markImg) {
        _markImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _markImg.layer.cornerRadius = 5.0f;
        _markImg.layer.masksToBounds = YES;
    }
    return _markImg;
}

- (UILabel *)lblImportant
{
    if (!_lblImportant)
    {
        _lblImportant = [[UILabel alloc] init];
        [_lblImportant setText:LOCAL(CALENDAR_ADD_IMPORTANT)];
        _lblImportant.font = [UIFont mtc_font_26];
        [_lblImportant setTextColor:[UIColor themeRed]];
    }
    return _lblImportant;
}
@end
