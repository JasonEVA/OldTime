//
//  CalendarAndMeetingTableViewCell.m
//  launcher
//
//  Created by William Zhang on 15/8/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarAndMeetingTableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"

@interface CalendarAndMeetingTableViewCell ()

@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation CalendarAndMeetingTableViewCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

+ (CGFloat)height {
    return 60;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    [self.contentView addSubview:self.locationImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(13);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.centerY.equalTo(self.contentView).multipliedBy(3 / 2.0);
        make.right.equalTo(self.titleLabel);
    }];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).dividedBy(2);
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-13);
        
        // 根据是否选中状态更改文字位置
        if (self.locationImageView.image) {
            make.left.equalTo(self.locationImageView.mas_right).offset(8);
        } else {
            make.left.equalTo(self.contentView).offset(13);
        }
    }];
    
    [super updateConstraints];
}

#pragma mark - Interface Method
- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle selected:(BOOL)selected {
    self.titleLabel.text = title;
    
    if (selected) {
        self.locationImageView.image = [UIImage imageNamed:@"Calendar_Location_Logo"];
        self.subTitleLabel.text = LOCAL(MEETING_ADDRESS_CHANGED);
    } else {
        self.locationImageView.image = nil;
        self.subTitleLabel.text = subTitle;
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

#pragma mark - Initializer
- (UIImageView *)locationImageView {
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc] init];
        _locationImageView.image = nil;
    }
    return _locationImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont mtc_font_30];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont mtc_font_26];
        _subTitleLabel.textColor = [UIColor mediumFontColor];
    }
    return _subTitleLabel;
}

@end
