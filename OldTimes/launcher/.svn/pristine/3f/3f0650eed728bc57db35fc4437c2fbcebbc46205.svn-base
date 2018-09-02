//
//  FriendValidRemarkCell.m
//  launcher
//
//  Created by kylehe on 16/4/1.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "FriendValidRemarkCell.h"
#import <Masonry/Masonry.h>

@interface FriendValidRemarkCell ()

@property(nonatomic, strong) UILabel  *titleLabel;

@property(nonatomic, strong) UIImageView  *indicateView;

@property(nonatomic, strong) UILabel  *remarkLale;

@end

@implementation FriendValidRemarkCell

+(NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createFrame];
    }
    return self;
}

#pragma mark - interFaceMethod
- (void)setRemark:(NSString *)remark
{
    self.remarkLale.text = remark;
}

#pragma mark - createFrame
- (void)createFrame
{
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.indicateView];
    [self.indicateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-3);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.remarkLale];
    [self.remarkLale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.indicateView.mas_left).offset(3);
        make.centerY.equalTo(self.contentView);
    }];
}

#pragma mark - setterAndGetter
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:19];
        _titleLabel.text = @"设置备注";
    }
    return _titleLabel;
}

- (UIImageView *)indicateView
{
    if (!_indicateView)
    {
        _indicateView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more_btn_icon"]];
    }
    return _indicateView;
}

- (UILabel *)remarkLale
{
    if (!_remarkLale)
    {
        _remarkLale = [[UILabel alloc] init];
    }
    return _remarkLale;
}

@end
