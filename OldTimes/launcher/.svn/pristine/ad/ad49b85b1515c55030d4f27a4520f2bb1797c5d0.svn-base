//
//  AtMeMessageTableViewCell.m
//  launcher
//
//  Created by williamzhang on 15/12/7.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "AtMeMessageTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MintcodeIM/MintcodeIM.h>
#import "NSDate+MsgManager.h"
#import <Masonry/Masonry.h>
#import "AvatarUtil.h"
#import "Category.h"
#import "MyDefine.h"

@interface AtMeMessageTableViewCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation AtMeMessageTableViewCell

+ (NSString *)identifer { return NSStringFromClass(self);}
+ (CGFloat)height       { return 60;}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.timeLabel];
        
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(13);
            make.width.height.equalTo(@40);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageView.mas_right).offset(8);
            make.top.equalTo(self.avatarImageView);
            make.right.lessThanOrEqualTo(self.timeLabel.mas_left).offset(-8);
        }];
        
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.bottom.equalTo(self.avatarImageView);
            make.right.equalTo(self.contentView).offset(-13);
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel);
            make.right.equalTo(self.contentView).offset(-13);
        }];
    }
    return self;
}

- (void)setDataWithModel:(MessageBaseModel *)model {
    NSString *timeString = [NSDate im_dateFormaterWithTimeInterval:model._createDate];
    [self.timeLabel setText:timeString];
    
    [self.titleLabel setText:[model getNickName]];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:LOCAL(CHAT_AT) attributes:@{NSFontAttributeName:[UIFont mtc_font_26],
                                                                                                                        NSForegroundColorAttributeName:[UIColor themeRed]}];
    [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:model._content attributes:@{NSFontAttributeName:[UIFont mtc_font_26],NSForegroundColorAttributeName:[UIColor mediumFontColor]}]];
    [self.subTitleLabel setAttributedText:attributeString];
    
    [self.avatarImageView sd_setImageWithURL:avatarURL(avatarType_80, [model getUserName]) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"]];
}

#pragma mark - Initializer
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.layer.cornerRadius = 5.0;
        _avatarImageView.clipsToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont mtc_font_30];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
    }
    return _subTitleLabel;
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
