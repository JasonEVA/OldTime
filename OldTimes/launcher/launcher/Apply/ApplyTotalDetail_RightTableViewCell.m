//
//  ApplyTotalDetail_RightTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/8/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyTotalDetail_RightTableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"

@interface ApplyTotalDetail_RightTableViewCell ()



@end

@implementation ApplyTotalDetail_RightTableViewCell

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.textLabel.font = [UIFont mtc_font_30];
        self.textLabel.textColor = [UIColor minorFontColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self createFrame];
    }
    return self;
}

#pragma mark - setMethod
- (void)setItemName:(NSString *)itemName {
    self.textLabel.text = itemName;
}

- (void)setDetailText:(NSString *)detailText {
    self.timeLabel.text = detailText;
}

#pragma mark - createFrame
- (void)createFrame
{
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-13);
        make.left.greaterThanOrEqualTo(self.mas_left).offset(80);
        make.centerY.equalTo(self.contentView);
    }];
}

#pragma mark - initializer

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont mtc_font_30];
    }
    return  _timeLabel;
}
@end
