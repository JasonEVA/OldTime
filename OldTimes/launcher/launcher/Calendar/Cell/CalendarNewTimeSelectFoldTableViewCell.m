//
//  CalendarNewTimeSelectFoldTableViewCell.m
//  launcher
//
//  Created by William Zhang on 15/8/13.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarNewTimeSelectFoldTableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"

@interface CalendarNewTimeSelectFoldTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation CalendarNewTimeSelectFoldTableViewCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

+ (CGFloat)height {
    return 40;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImage *image = [UIImage imageNamed:@"calendar_downArrows"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self setAccessoryView:imageView];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
        }];
        
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.left.equalTo(self.titleLabel.mas_right).offset(10);
            make.right.lessThanOrEqualTo(self.contentView);
        }];
    }
    
    return self;
}

#pragma mark - Interface Method
- (void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
}

- (void)setStartDate:(NSDate *)date endData:(NSDate *)endDate wholeDay:(BOOL)isWholeDay {
    [self.detailLabel setText:[date mtc_startToEndDate:endDate wholeDay:isWholeDay]];
}

#pragma mark - Initializer
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.font = [UIFont mtc_font_30];
        _titleLabel.textColor = [UIColor minorFontColor];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = UILabel.new;
        _detailLabel.font = [UIFont mtc_font_30];
        [_detailLabel setAdjustsFontSizeToFitWidth:YES];
    }
    return _detailLabel;
}

@end
