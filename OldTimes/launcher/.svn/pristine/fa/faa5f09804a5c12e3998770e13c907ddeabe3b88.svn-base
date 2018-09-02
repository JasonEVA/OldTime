//
//  ForwardBaseTableViewCell.m
//  launcher
//
//  Created by williamzhang on 16/4/5.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ForwardBaseTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UnifiedUserInfoManager.h"
#import "IMNickNameManager.h"
#import "NSDate+MsgManager.h"
#import "AvatarUtil.h"
#import "Category.h"

@implementation ForwardBaseTableViewCell

+ (NSString *)identifier { return NSStringFromClass(self); }
+ (CGFloat)height { return 60; }

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@40);
            make.left.equalTo(self.contentView).offset(12);
            make.top.equalTo(self.contentView).offset(10);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageView.mas_right).offset(8);
            make.top.equalTo(self.avatarImageView);
            make.right.lessThanOrEqualTo(self.timeLabel.mas_left).offset(-12);
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-12);
            make.top.equalTo(self.nameLabel);
        }];
    }
    return self;
}

#pragma mark - Interface Method
- (void)setMessageModel:(MessageBaseModel *)model {
    NSString *avatarUid = [model getUserName];
    NSString *userNickName = [model getNickName];;
    
    [self.avatarImageView sd_setImageWithURL:avatarURL(avatarType_80, avatarUid) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"]];
    
    self.nameLabel.text = [IMNickNameManager showNickNameWithOriginNickName:userNickName userId:avatarUid];
    self.timeLabel.text = [NSDate im_dateFormaterWithTimeInterval:model._createDate showWeek:YES appendMinute:YES];
}

#pragma mark - Initializer
@synthesize avatarImageView = _avatarImageView, nameLabel = _nameLabel, timeLabel = _timeLabel;

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.layer.cornerRadius = 5;
        _avatarImageView.clipsToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont mtc_font_30];
        
        [_nameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont mtc_font_24];
        _timeLabel.textColor = [UIColor minorFontColor];
        [_timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _timeLabel;
}

@end
