//
//  ForwardAttachmentTableViewCell.m
//  launcher
//
//  Created by williamzhang on 16/4/5.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ForwardAttachmentTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ChatIMConfigure.h"
#import "IMUtility.h"
#import "Category.h"
#import "MyDefine.h"

@interface ForwardAttachmentTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *sizeLabel;

@end

@implementation ForwardAttachmentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.sizeLabel];
        
        [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.bottom.equalTo(self.avatarImageView);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.sizeLabel.mas_right).offset(8);
            make.centerY.equalTo(self.sizeLabel);
            make.right.lessThanOrEqualTo(self.contentView).offset(-8);
        }];
    }
    return self;
}

- (void)setMessageModel:(MessageBaseModel *)model {
    [super setMessageModel:model];
    
    [self.nameLabel setText:model.attachModel.fileName];
    [self.sizeLabel setText:model.attachModel.fileSizeString];
    [self.titleLabel setText:[NSString stringWithFormat:@"%@%@", LOCAL(FROM), [model getNickName]]];
    
    if (model._type == msg_personal_file) {
        
        UIImage *image = [IMUtility fileIconFromFileName:model.attachModel.fileName];
        [self.avatarImageView setImage:image];
    }
    else
    {
        if ([model._nativeThumbnailUrl length]) {
            NSString *fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeThumbnailUrl];
            UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
            [self.avatarImageView setImage:image];
            return;
        }
        
        SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
        NSString *cookie = [NSString stringWithFormat:@"AppName=%@;UserName=%@", im_appName, [[UnifiedUserInfoManager share] userShowID]];
        [downloader setValue:cookie forHTTPHeaderField:@"Cookie"];
        
        NSString *fullPath = [NSString stringWithFormat:@"%@%@", im_IP_http, model.attachModel.thumbnail];
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:fullPath] placeholderImage:[UIImage imageNamed:@"image_placeholder_loading"] options:SDWebImageHandleCookies];
    }
}

#pragma mark - Initializer
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont mtc_font_30];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [UILabel new];
        _sizeLabel.font = [UIFont mtc_font_26];
        _sizeLabel.textColor = [UIColor mediumFontColor];
    }
    return _sizeLabel;
}

@end
