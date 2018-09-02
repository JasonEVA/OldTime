//
//  MeVerifiedcodeTableViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/9/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeVerifiedcodeTableViewCell.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"
#import <Masonry.h>

@interface MeVerifiedcodeTableViewCell()
@property (nonatomic) NSInteger TimerIndex;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation MeVerifiedcodeTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addSubview:self.tfdVerify];
        [self addSubview:self.btnConfirm];
        [self addSubview:self.lblTitle];
        [self CreateFrames];
        self.TimerIndex = 60;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Privite Methods
- (void)CreateFrames
{
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.width.equalTo(@80);
        make.height.equalTo(@25);
    }];
    
    [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self);
        make.width.equalTo(@130);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self.tfdVerify mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.lblTitle.mas_right);
        make.right.equalTo(self.btnConfirm.mas_left);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void)btnSendClick:(UIButton *)btn
{
    self.btnConfirm.enabled = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(TImerRepeat) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)TImerRepeat
{
    [self.btnConfirm setTitle:[NSString stringWithFormat:@"%@(%ld)",LOCAL(ME_HAD_SENT),self.TimerIndex--] forState:UIControlStateNormal];
    if (self.TimerIndex == 0)
    {
        [self.timer invalidate];
        self.TimerIndex = 60;
        self.btnConfirm.selected = NO;
        self.btnConfirm.enabled = YES;
        [self.btnConfirm setTitle:LOCAL(ME_GET_CHECK_CODE) forState:UIControlStateNormal];
    }
}

#pragma mark - init
- (UITextField *)tfdVerify
{
    if (!_tfdVerify)
    {
        _tfdVerify = [[UITextField alloc] init];
        _tfdVerify.textAlignment = NSTextAlignmentLeft;
        _tfdVerify.font = [UIFont systemFontOfSize:14];
        _tfdVerify.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _tfdVerify.returnKeyType = UIReturnKeyDone;
        _tfdVerify.clearButtonMode = YES;
        _tfdVerify.textColor = [UIColor blackColor];
    }
    return _tfdVerify;
}

- (UIButton *)btnConfirm
{
    if (!_btnConfirm)
    {
        _btnConfirm = [[UIButton alloc] init];
        _btnConfirm.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnConfirm setTitle:LOCAL(ME_GET_CHECK_CODE) forState:UIControlStateNormal];
        [_btnConfirm setTitle:[NSString stringWithFormat:@"%@(60)",LOCAL(ME_HAD_SENT)] forState:UIControlStateSelected];
        [_btnConfirm setTitleColor:[UIColor colorWithRed:112.0/255 green:112.0/255 blue:112.0/255 alpha:1] forState:UIControlStateSelected];
        [_btnConfirm setTitleColor:[UIColor colorWithRed:112.0/255 green:112.0/255 blue:112.0/255 alpha:1] forState:UIControlStateNormal];
        [_btnConfirm addTarget:self action:@selector(btnSendClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnConfirm.enabled = YES;
        _btnConfirm.layer.borderColor = [UIColor grayBackground].CGColor;
        _btnConfirm.layer.borderWidth = 1.0f;
    }
    return _btnConfirm;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.font = [UIFont systemFontOfSize:14];
        _lblTitle.textAlignment = NSTextAlignmentLeft;
        _lblTitle.textColor = [UIColor colorWithRed:112.0/255 green:112.0/255 blue:112.0/255 alpha:1];
    }
    return _lblTitle;
}
@end
