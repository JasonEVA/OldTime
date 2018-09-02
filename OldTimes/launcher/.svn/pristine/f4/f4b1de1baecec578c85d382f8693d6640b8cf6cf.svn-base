//
//  NewMissionTodayTableViewCell.m
//  launcher
//
//  Created by conanma on 16/2/1.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMissionTodayTableViewCell.h"
#import <Masonry/Masonry.h>

@interface NewMissionTodayTableViewCell()
@property (nonatomic, strong) UILabel *lblLine;
@property (nonatomic, strong) UIButton *btnDone;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIButton *btnEndTime;
@property (nonatomic, strong) UIButton *btnComeFrom;
@property (nonatomic, strong) UIImageView *imgViewAttachment;
@property (nonatomic, strong) UIImageView *imgViewComment;
@end

@implementation NewMissionTodayTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.lblLine];
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.btnDone];
        [self.contentView addSubview:self.btnEndTime];
        [self.contentView addSubview:self.btnComeFrom];
        [self.contentView addSubview:self.imgViewAttachment];
        [self.contentView addSubview:self.imgViewComment];
        
        [self setframes];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Privite Methods
- (void)setframes
{
    [self.lblLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@5);
    }];
    
    [self.btnDone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblLine.mas_right).offset(5);
        make.top.equalTo(self.contentView).offset(20);
        make.width.height.equalTo(@20);
    }];
    
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.btnDone.mas_right).offset(10);
        make.height.equalTo(@20);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.btnEndTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@16);
        make.left.equalTo(self.lblTitle);
    }];
    
    [self.imgViewAttachment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnComeFrom.mas_right).offset(5);
        make.top.bottom.equalTo(self.btnComeFrom);
        make.width.equalTo(@15);
    }];
    
    [self.imgViewComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgViewAttachment.mas_right).offset(5);
        make.top.bottom.equalTo(self.btnComeFrom);
        make.width.equalTo(@18);
    }];
}

- (void)setdata
{
    
}

#pragma mark - init
- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
        [_lblTitle setTextAlignment:NSTextAlignmentLeft];
        [_lblTitle setFont:[UIFont systemFontOfSize:15]];
        [_lblTitle setTextColor:[UIColor blackColor]];
    }
    return _lblTitle;
}

- (UILabel *)lblLine
{
    if (!_lblLine)
    {
        _lblLine = [[UILabel alloc] init];
    }
    return _lblLine;
}

- (UIButton *)btnDone
{
    if (!_btnDone)
    {
        _btnDone = [[UIButton alloc] init];
        [_btnDone setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_btnDone setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    }
    return _btnDone;
}

- (UIButton *)btnEndTime
{
    if (!_btnEndTime)
    {
        _btnEndTime = [[UIButton alloc] init];
        [_btnEndTime setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _btnEndTime.enabled = NO;
        [_btnEndTime setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _btnEndTime;
}

- (UIButton *)btnComeFrom
{
    if (!_btnComeFrom)
    {
        _btnComeFrom = [[UIButton alloc] init];
        _btnComeFrom.enabled = NO;
        [_btnComeFrom setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    return _btnComeFrom;
}

- (UIImageView *)imgViewAttachment
{
    if (!_imgViewAttachment)
    {
        _imgViewAttachment = [[UIImageView alloc] init];
        [_imgViewAttachment setImage:[UIImage imageNamed:@""]];
    }
    return _imgViewAttachment;
}

- (UIImageView *)imgViewComment
{
    if (!_imgViewComment)
    {
        _imgViewComment = [[UIImageView alloc] init];
        [_imgViewComment setImage:[UIImage imageNamed:@""]];
    }
    return _imgViewComment;
}
@end
