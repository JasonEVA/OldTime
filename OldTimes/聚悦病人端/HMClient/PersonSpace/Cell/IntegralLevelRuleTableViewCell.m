//
//  IntegralLevelRuleTableViewCell.m
//  HMClient
//
//  Created by yinquan on 2017/7/17.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "IntegralLevelRuleTableViewCell.h"


@interface IntegralLevelRuleTableViewCell ()


@property (nonatomic, strong) UIView* iconView;
@property (nonatomic, strong) UIImageView* iconImageViwe;
@property (nonatomic, strong) UIView* levelLineView;
@property (nonatomic, strong) UILabel* levelLabel;
@property (nonatomic, strong) UIView* numberLineView;
@property (nonatomic, strong) UILabel* numberLabel;

- (void) setIntegralVipLevel:(IntegralVIPLevel) vipLevel;
@end

@implementation IntegralLevelRuleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView showLeftLine];
        [self.contentView showRightLine];
        [self.contentView showBottomLine];
        [self configSubviews];
    }
    return self;
}

- (void) configSubviews
{
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.width.mas_equalTo(@48);
    }];
    
    [self.iconImageViwe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(19, 19));
        make.center.equalTo(self.iconView);
    }];
    
    [self.levelLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.iconView.mas_right);
        make.width.mas_equalTo(@0.5);
    }];
    
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.levelLineView).with.offset(15);
        make.width.mas_equalTo(@(124 * kScreenWidth / 375));
    }];
    
    [self.numberLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.levelLabel.mas_right);
        make.width.mas_equalTo(@0.5);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.numberLineView.mas_right).offset(15);
        make.right.equalTo(self.contentView);
    }];

}

- (void) setIntegralVipLevel:(IntegralVIPLevel) vipLevel
{
    [self.iconImageViwe setImage:[self vipLevelImage:vipLevel]];
    [self.levelLabel setText:[self vipLevelName:vipLevel]];
    [self.numberLabel setText:[self vipLevelNumber:vipLevel]];
}

- (UIImage*) vipLevelImage:(IntegralVIPLevel) vipLevel
{
    UIImage* vipImage = [UIImage imageNamed:[NSString stringWithFormat:@"integral_level_%ld", vipLevel + 1]];
    
    return vipImage;
}

- (NSString*) vipLevelName:(IntegralVIPLevel) vipLevel
{
    NSString* levelName = nil;
    switch (vipLevel)
    {
        case IntegralVIP_Normal:
        {
            levelName = @"普通";
            break;
        }
        case IntegralVIP_Steel:
        {
            levelName = @"铁牌";
            break;
        }
        case IntegralVIP_Bronze:
        {
            levelName = @"铜牌";
            break;
        }
        case IntegralVIP_Silver:
        {
            levelName = @"银牌";
            break;
        }
        case IntegralVIP_Golden:
        {
            levelName = @"金牌";
            break;
        }
        case IntegralVIP_Platinum:
        {
            levelName = @"铂金";
            break;
        }
        case IntegralVIP_Diamond:
        {
            levelName = @"钻石";
            break;
        }
        case IntegralVIP_Crown:
        {
            levelName = @"皇冠";
            break;
        }
            
        default:
            break;
    }
    return levelName;
}

- (NSString*) vipLevelNumber:(IntegralVIPLevel) vipLevel
{
    NSString* levelNumber = nil;
    switch (vipLevel)
    {
        case IntegralVIP_Normal:
        {
            levelNumber = @"0-500";
            break;
        }
        case IntegralVIP_Steel:
        {
            levelNumber = @"501-1000";
            break;
        }
        case IntegralVIP_Bronze:
        {
            levelNumber = @"1001-3000";
            break;
        }
        case IntegralVIP_Silver:
        {
            levelNumber = @"3001-6000";
            break;
        }
        case IntegralVIP_Golden:
        {
            levelNumber = @"6001-10000";
            break;
        }
        case IntegralVIP_Platinum:
        {
            levelNumber = @"10001-20000";
            break;
        }
        case IntegralVIP_Diamond:
        {
            levelNumber = @"20001-40000";
            break;
        }
        case IntegralVIP_Crown:
        {
            levelNumber = @"40000+";
            break;
        }
            
        default:
            break;
    }
    return levelNumber;
}


#pragma - settingAndGetting

- (UIView*) iconView
{
    if (!_iconView) {
        _iconView = [[UIView alloc] init];
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

- (UIImageView*) iconImageViwe
{
    if (!_iconImageViwe)
    {
        _iconImageViwe = [[UIImageView alloc] init];
        [self.iconView addSubview:_iconImageViwe];
    }
    return _iconImageViwe;
}

- (UIView*) levelLineView
{
    if (!_levelLineView) {
        _levelLineView = [[UIView alloc] init];
        [self.contentView addSubview:_levelLineView];
        [_levelLineView setBackgroundColor:[UIColor commonControlBorderColor]];
    }
    return _levelLineView;
}

- (UILabel*) levelLabel
{
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_levelLabel];
        
        [_levelLabel setTextColor:[UIColor commonTextColor]];
        [_levelLabel setFont:[UIFont systemFontOfSize:18]];
        
        
    }
    return _levelLabel;
}

- (UIView*) numberLineView
{
    if (!_numberLineView) {
        _numberLineView = [[UIView alloc] init];
        [self.contentView addSubview:_numberLineView];
        [_numberLineView setBackgroundColor:[UIColor commonControlBorderColor]];
    }
    return _numberLineView;
}

- (UILabel*) numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_numberLabel];
        
        [_numberLabel setTextColor:[UIColor commonTextColor]];
        [_numberLabel setFont:[UIFont systemFontOfSize:18]];
    }
    return _numberLabel;
}

@end
