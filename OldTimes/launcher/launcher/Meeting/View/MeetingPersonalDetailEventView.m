//
//  MeetingPersonalDetailEventView.m
//  launcher
//
//  Created by Conan Ma on 15/8/14.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingPersonalDetailEventView.h"
#import "PlaceModel.h"
#import "Masonry.h"
#import "MyDefine.h"
#import "CalendarLaunchrModel.h"
@interface MeetingPersonalDetailEventView()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblEventName;
@property (nonatomic, strong) UILabel *lblTime;
@property (nonatomic, strong) UILabel *lblAddress;
@property (nonatomic, strong) UIImageView *imgViewEvent;
@property (nonatomic, strong) UIImageView *imgViewTime;
@property (nonatomic, strong) UIImageView *imgViewAddress;
@property (nonatomic, strong) UILabel *lblCutOffLine;
@property (nonatomic, strong) NSArray *arrList;
@end

@implementation MeetingPersonalDetailEventView
-(instancetype)initWithArray:(NSArray *)arrList
{
    if (self = [super init])
    {
        self.arrList = arrList;
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        
        [self addSubview:self.contentView];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        //上／左／下／右
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self).offset(154);
            make.height.equalTo(@(175));
        }];
        
        [self setdata];
        [self initComponents];
        
        UITapGestureRecognizer *TapGestureRecgnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:TapGestureRecgnizer];
    }
    return self;
}

- (void)initComponents
{
    [self.contentView addSubview:self.lblTitle];
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(12);
        make.height.equalTo(@(25));
    }];
    
    [self.contentView addSubview:self.lblCutOffLine];
    [self.lblCutOffLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.lblTitle.mas_bottom).offset(10);
        make.height.equalTo(@(1));
    }];
    
    [self.contentView addSubview:self.imgViewEvent];
    [self.imgViewEvent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.lblCutOffLine.mas_bottom).offset(16);
        make.width.height.equalTo(@(18));
    }];
    
    [self.contentView addSubview:self.imgViewTime];
    [self.imgViewTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(self.imgViewEvent);
        make.top.equalTo(self.imgViewEvent).offset(30);
    }];
    
    [self.contentView addSubview:self.imgViewAddress];
    [self.imgViewAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.imgViewEvent);
        make.top.equalTo(self.imgViewTime).offset(30);
        make.width.equalTo(@(14));
        make.left.equalTo(self.contentView).offset(21.5);
    }];
    
    [self.contentView addSubview:self.lblEventName];
    [self.lblEventName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgViewAddress.mas_right).offset(15);
        make.top.equalTo(self.lblCutOffLine.mas_bottom).offset(12);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@(25));
    }];
    
    [self.contentView addSubview:self.lblTime];
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblEventName);
        make.top.equalTo(self.lblEventName.mas_bottom).offset(5);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@(25));
    }];
    
    [self.contentView addSubview:self.lblAddress];
    [self.lblAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblEventName);
        make.top.equalTo(self.lblTime.mas_bottom).offset(5);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@(25));
    }];
}

- (void)setdata
{
    self.lblTitle.text = [NSString stringWithFormat:@"%@%@",[self.arrList objectAtIndex:0],LOCAL(MEETING_PERSONAL_SCHEDULE_DETAIL)];
    
    self.lblEventName.text = [self.arrList objectAtIndex:1];
    
    self.lblTime.text = [self.arrList objectAtIndex:2];
    
    PlaceModel *model = [self.arrList objectAtIndex:3];
    self.lblAddress.text = model.name;
}

- (void)singleTap:(UITapGestureRecognizer*)tap
{
    [self dismiss];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

#pragma mark - init
- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5.0;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        _lblTitle.textColor = [UIColor blackColor];
        _lblTitle.font = [UIFont systemFontOfSize:16];
    }
    return _lblTitle;
}

- (UILabel *)lblEventName
{
    if (!_lblEventName)
    {
        _lblEventName = [[UILabel alloc] init];
        _lblEventName.textAlignment = NSTextAlignmentLeft;
        _lblEventName.textColor = [UIColor blackColor];
        _lblEventName.font = [UIFont systemFontOfSize:13];
//        _lblEventName
    }
    return _lblEventName;
}

- (UILabel *)lblTime
{
    if (!_lblTime)
    {
        _lblTime = [[UILabel alloc] init];
        _lblTime.textAlignment = NSTextAlignmentLeft;
        _lblTime.textColor = [UIColor blackColor];
        _lblTime.font = [UIFont systemFontOfSize:13];
    }
    return _lblTime;
}

- (UILabel *)lblAddress
{
    if (!_lblAddress)
    {
        _lblAddress = [[UILabel alloc] init];
        _lblAddress.textAlignment = NSTextAlignmentLeft;
        _lblAddress.textColor = [UIColor blackColor];
        _lblAddress.font = [UIFont systemFontOfSize:13];
    }
    return _lblAddress;
}

- (UILabel *)lblCutOffLine
{
    if (!_lblCutOffLine)
    {
        _lblCutOffLine = [[UILabel alloc] init];
        _lblCutOffLine.backgroundColor = [UIColor colorWithRed:194.0/255 green:194.0/255 blue:194.0/255 alpha:1];
    }
    return _lblCutOffLine;
}

- (UIImageView *)imgViewEvent
{
    if (!_imgViewEvent)
    {
        _imgViewEvent = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Meeting_EventName"]];
    }
    return _imgViewEvent;
}

- (UIImageView *)imgViewTime
{
    if (!_imgViewTime)
    {
        _imgViewTime = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Meeting_EventTime"]];
    }
    return _imgViewTime;
}

- (UIImageView *)imgViewAddress
{
    if (!_imgViewAddress)
    {
        _imgViewAddress = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Meeting_EventAddress"]];
    }
    return _imgViewAddress;
}

- (NSArray *)arrList
{
    if (!_arrList)
    {
        _arrList = [[NSArray alloc] init];
    }
    return _arrList;
}
@end
