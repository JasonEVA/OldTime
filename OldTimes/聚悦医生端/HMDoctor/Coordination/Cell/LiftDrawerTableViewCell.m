//
//  LiftDrawerTableViewCell.m
//  launcher
//
//  Created by TabLiu on 16/2/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "LiftDrawerTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "TaskTypeTitleAndCountModel.h"

#define Blue_Color  [UIColor colorWithRed:8/255.0 green:119/255.0 blue:192/255.0 alpha:1]

@interface LiftDrawerTableViewCell ()


@property (nonatomic,strong) UIImageView * iconImageView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * ratioLabel;

@end

@implementation LiftDrawerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor colorWithHex:0x0099ff alpha:0.8]];
        UIView *backView = [UIView new];
        [backView setBackgroundColor:[UIColor colorWithHexString:@"0088e3"]];
        self.selectedBackgroundView = backView;

        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.ratioLabel];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(25);
            make.centerY.equalTo(self.contentView);
        }];
        [self.ratioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-25);
            make.centerY.equalTo(self.contentView);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
            make.centerY.equalTo(self.contentView);
            make.right.lessThanOrEqualTo(self.ratioLabel.mas_left).offset(-5);
        }];
    }
    return self;
}

#pragma mark - Interface Method

- (void)configCellDataWithModel:(TaskTypeTitleAndCountModel *)model iconName:(NSString *)iconName {
    
    self.iconImageView.image = [UIImage imageNamed:iconName];
    self.titleLabel.text = model.tabName;
    self.ratioLabel.text = [NSString stringWithFormat:@"%ld",(long)model.count];
}

- (void)configCellIsSelect:(BOOL)isSelect
{
    if (isSelect) {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:6/255.0 green:102/255.0 blue:165/255.0 alpha:1]];
    }else {
        [self.contentView setBackgroundColor:Blue_Color];
    }
}

#pragma mark - Private Method

- (void)setIconImageName:(NSString *)imgName
{
    self.iconImageView.image = [UIImage imageNamed:imgName];
}

- (void)setCellTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setNumberWithUnRead:(NSInteger)unreadNum allNumber:(NSInteger)allNumber isShow:(BOOL)isShow
{
    if (!isShow) {
        self.ratioLabel.hidden = YES;
        return;
    }
    self.ratioLabel.hidden = NO;
    self.ratioLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)allNumber - (long)unreadNum,(long)allNumber];
}

- (void)setNumberWithAllNumber:(NSInteger)allNumber
{
    self.ratioLabel.hidden = NO;
    self.ratioLabel.text = [NSString stringWithFormat:@"%ld",(long)allNumber];
}



#pragma mark - UI

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.userInteractionEnabled = YES;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"fffffff"];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLabel;
}

- (UILabel *)ratioLabel
{
    if (!_ratioLabel) {
        _ratioLabel = [[UILabel alloc] init];
        _ratioLabel.textColor = [UIColor colorWithHexString:@"fffffff"];
        _ratioLabel.font = [UIFont systemFontOfSize:15.0];
        _ratioLabel.textAlignment = NSTextAlignmentRight;
    }
    return _ratioLabel;
}

@end
