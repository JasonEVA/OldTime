//
//  ChatSelectForwardUserTableViewCell.m
//  launcher
//
//  Created by williamzhang on 16/3/29.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatSelectForwardUserTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
#import "AvatarUtil.h"
#import "Category.h"

@interface ChatSelectForwardUserTableViewCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation ChatSelectForwardUserTableViewCell

+ (NSString *)identifier { return NSStringFromClass(self); }
+ (CGFloat)height { return 60; }

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.tintColor = [UIColor themeBlue];
        self.multipleSelectionBackgroundView = [UIView new];
        
        [self.contentView addSubview:self.avatarImageView];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@40);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(12);
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageView.mas_right).offset(8);
            make.centerY.equalTo(self.avatarImageView);
            make.right.lessThanOrEqualTo(self.contentView).offset(-12);
        }];
    }
    return self;
}

- (void)setData:(ContactDetailModel *)dataModel {
    if (dataModel._isGroup) {
        [self.avatarImageView setImage:[UIImage imageNamed:@"group_defalut_avatar"]];
    }
    else {
        [self.avatarImageView sd_setImageWithURL:avatarURL(avatarType_80, dataModel._target) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"]];
    }
    
    [self.nameLabel setText:dataModel._nickName];
}

#pragma mark - Initializer
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.layer.cornerRadius = 3;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont mtc_font_30];
    }
    return _nameLabel;
}

@end
