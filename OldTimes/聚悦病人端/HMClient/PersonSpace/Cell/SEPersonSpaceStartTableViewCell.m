//
//  SEPersonSpaceStartTableViewCell.m
//  HMClient
//
//  Created by yinquan on 2017/7/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "SEPersonSpaceStartTableViewCell.h"

@interface SEPersonSpaceStartTableViewCell ()

@property (nonatomic, strong) UIImageView* notOpenedImageView;
@end

@implementation SEPersonSpaceStartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) showHotIcon:(BOOL) show
{
    [self.hotImageView setHidden:!show];
}

- (void) showOpened:(BOOL) opened
{
    [self.notOpenedImageView setHidden:opened];
    if (opened)
    {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else
    {
        [self setAccessoryType:UITableViewCellAccessoryNone];
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(10);
    }];
    
    [self.hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.centerY.mas_equalTo(CGSizeMake(12, 12));
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.titleLabel.mas_right).with.offset(10);
    }];
    
    [self.notOpenedImageView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.bottom.right.equalTo(self.contentView);
    }];
    
}

#pragma mark - settingAndGetting
- (UIImageView*) iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UILabel*) titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_titleLabel setTextColor:[UIColor commonTextColor]];
    }
    return _titleLabel;
}

- (UIImageView*) hotImageView
{
    if (!_hotImageView) {
        _hotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mi_ic_fire"]];
        [self.contentView addSubview:_hotImageView];
        [_hotImageView setHidden:YES];
    }
    return _hotImageView;
}

- (UIImageView*) notOpenedImageView
{
    if (!_notOpenedImageView) {
        _notOpenedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"im_wkt"]];
        [self.contentView addSubview:_notOpenedImageView];
        [_notOpenedImageView setHidden:YES];
    }
    return _notOpenedImageView;
}

@end
