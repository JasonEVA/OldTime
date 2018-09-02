//
//  NewApplyTotalDetail_RightTableViewCell.m
//  launcher
//
//  Created by conanma on 16/1/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyTotalDetail_RightTableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"

@interface NewApplyTotalDetail_RightTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation NewApplyTotalDetail_RightTableViewCell
+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self createFrame];
    }
    return self;
}

#pragma mark - setMethod
- (void)setItemName:(NSString *)itemName {
    self.titleLabel.text = itemName;
}

- (void)setDetailText:(NSString *)detailText {
    self.timeLabel.text = detailText;
}

#pragma mark - createFrame
- (void)createFrame
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(13);
        make.centerY.equalTo(self.contentView);
        make.right.lessThanOrEqualTo(self.timeLabel.mas_left).offset(-5);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-13);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(100);
    }];
}

#pragma mark - Initializer

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font      = [UIFont mtc_font_30];
        _titleLabel.textColor = [UIColor minorFontColor];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont mtc_font_30];
    }
    return  _timeLabel;
}

@end
