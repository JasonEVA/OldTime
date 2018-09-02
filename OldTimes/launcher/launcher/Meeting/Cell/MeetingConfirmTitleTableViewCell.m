//
//  MeetingConfirmTitleTableViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/8/14.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingConfirmTitleTableViewCell.h"
#import <DateTools/DateTools.h>
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"

@interface MeetingConfirmTitleTableViewCell()

@property (nonatomic, strong) UIImageView *imgViewClock;
@property (nonatomic, strong) UIImageView *lockImageView;
@end

@implementation MeetingConfirmTitleTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createFrame];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createFrame
{
    [self.contentView addSubview:self.lblTitle];
//    [self.lblTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(13);
//        make.top.equalTo(self.contentView).offset(10);
//        make.right.equalTo(self.contentView).offset(-13);
//    }];
    
    [self.contentView addSubview:self.lockImageView];
    
    [self.contentView addSubview:self.lblTime];
   
    [self.contentView addSubview:self.lblAddress];
 
    [self.contentView addSubview:self.imgViewClock];
  
    [self.contentView addSubview:self.btnAttend];
  
    [self.contentView addSubview:self.btnRefused];
    [self initConstraints];
    [self setNeedsUpdateConstraints];
}
- (void)initConstraints
{
    [self.lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(13);
        make.top.equalTo(self.contentView).offset(12);
        make.width.and.height.equalTo(@15);
    }];
    
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(13);
        make.top.equalTo(self.lblTitle.mas_bottom).offset(8);
    }];
    [self.btnRefused mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblAddress.mas_bottom).offset(13);
        make.height.width.equalTo(self.btnAttend);
        make.left.equalTo(self.contentView.mas_centerX).offset(10);
    }];
    [self.btnAttend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblAddress.mas_bottom).offset(13);
        make.right.equalTo(self.mas_centerX).offset(-10);
        make.width.equalTo(@(90));
        make.height.equalTo(@(30));
    }];
    [self.lblAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(13);
        make.top.equalTo(self.lblTime.mas_bottom).offset(8);
        make.right.equalTo(self.contentView);
    }];
    [self.imgViewClock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblTime.mas_right).offset(12);
        make.top.equalTo(self.lblTitle.mas_bottom).offset(8.5);
        make.width.height.equalTo(@(15));
    }];
    
}
- (void)setData:(NewMeetingModel *)model
{
    if (!model.isVisible) {
		self.lockImageView.hidden=NO;
        [self.lblTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(30);
            make.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-13);
        }];
    }else{
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(13);
            make.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-13);
        }];
        self.lockImageView.hidden=YES;
    }
    self.lblTitle.text = model.title;

    NSString *time = [model.startTime mtc_startToEndDate:model.endTime];
    
    self.lblTime.text = time;
    self.lblAddress.text = model.showName;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.textColor = [UIColor themeBlue];
        _lblTitle.font = [UIFont mtc_font_30];
    }
    return _lblTitle;
}

-(UIImageView *)lockImageView
{
    if (!_lockImageView) {
        _lockImageView=[[UIImageView alloc]init];
        [_lockImageView setImage:[UIImage imageNamed:@"peoLock"]];
    }
    return _lockImageView;
}

- (UILabel *)lblTime
{
    if (!_lblTime)
    {
        _lblTime = [[UILabel alloc] init];
        _lblTime.textColor = [UIColor blackColor];
        _lblTime.font = [UIFont mtc_font_26];
    }
    return _lblTime;
}

- (UILabel *)lblAddress
{
    if (!_lblAddress)
    {
        _lblAddress = [[UILabel alloc] init];
        _lblAddress.textColor = [UIColor blackColor];
        _lblAddress.font = [UIFont mtc_font_26];
    }
    return _lblAddress;
}

- (UIButton *)btnAttend
{
    if (!_btnAttend)
    {
        _btnAttend = [[UIButton alloc] init];
        [_btnAttend setTitleColor:[UIColor themeGreen] forState:UIControlStateNormal];
        _btnAttend.layer.cornerRadius = 10.0f;
        _btnAttend.layer.borderColor = [UIColor themeGreen].CGColor;
        _btnAttend.layer.borderWidth = 1.0f;
        [_btnAttend setTitle:LOCAL(MEETING_ATTEND) forState:UIControlStateNormal];
        _btnAttend.clipsToBounds = YES;
        _btnAttend.titleLabel.font = [UIFont mtc_font_24];
        _btnAttend.tag = 111;
    }
    return _btnAttend;
}

- (UIButton *)btnRefused
{
    if (!_btnRefused)
    {
        _btnRefused = [[UIButton alloc] init];
        [_btnRefused setTitleColor:[UIColor themeRed] forState:UIControlStateNormal];
        _btnRefused.layer.cornerRadius = 10.0f;
        _btnRefused.layer.borderColor = [UIColor themeRed].CGColor;
        _btnRefused.layer.borderWidth = 1.0f;
        [_btnRefused setTitle:LOCAL(MEETING_NOTATTEND) forState:UIControlStateNormal];
        _btnRefused.clipsToBounds = YES;
        _btnRefused.titleLabel.font = [UIFont mtc_font_24];
        _btnRefused.tag = 222;
    }
    return _btnRefused;
}

- (UIImageView *)imgViewClock
{
    if (!_imgViewClock) {
        _imgViewClock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Meeting_Clock"]];
    }
    return _imgViewClock;
}
@end
