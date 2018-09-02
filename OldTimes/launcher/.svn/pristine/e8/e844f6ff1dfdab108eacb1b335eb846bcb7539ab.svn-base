//
//  MeetingTimeConfusedTableViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/8/10.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingTimeConfusedTableViewCell.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"
#import "Masonry.h"

@interface MeetingTimeConfusedTableViewCell()
@property (nonatomic, strong) UILabel *lblTitle;
@end

@implementation MeetingTimeConfusedTableViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.lblTitle];
        [self addSubview:self.btnCheckDetail];
        
        [self CreatFrame];
    }
    return self;
}

- (void)CreatFrame
{
    [self.btnCheckDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.width.equalTo(@70);
        make.height.equalTo(@20);
        
    }];
    
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.right.lessThanOrEqualTo(self.btnCheckDetail.mas_left);
        make.height.equalTo(@20);
    }];
}

#pragma mark - Privite Method
- (void)setLabelTextWith:(NSInteger)Count
{
    self.lblTitle.text = [NSString stringWithFormat:LOCAL(CALENDAR_OTHERSHADARRANGED_EVENT),(long)Count];
}

#pragma mark - init
- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.backgroundColor = [UIColor clearColor];
        _lblTitle.textColor = [UIColor themeRed];
        _lblTitle.font = [UIFont systemFontOfSize:14];
    }
    return _lblTitle;
}

- (UIButton *)btnCheckDetail
{
    if (!_btnCheckDetail)
    {
        _btnCheckDetail = [[UIButton alloc] init];
        _btnCheckDetail.layer.cornerRadius = 4.0f;
        _btnCheckDetail.layer.borderColor = [UIColor themeGray].CGColor;
        _btnCheckDetail.layer.borderWidth = 1.0f;
        _btnCheckDetail.titleLabel.text = LOCAL(MEETING_INPUT_CHECK_EVENT);
        _btnCheckDetail.titleLabel.textColor = [UIColor blackColor];
    }
    return _btnCheckDetail;
}
@end
