//
//  ApplicationCommentImageTableViewCell.m
//  launcher
//
//  Created by williamzhang on 15/11/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplicationCommentImageTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ApplicationCommentModel.h"
#import <DateTools/DateTools.h>
#import <Masonry/Masonry.h>
#import "AttachmentUtil.h"
#import "Category.h"

@interface ApplicationCommentImageTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *fileImageView;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, copy) void (^clickBlock)(id);

@end

@implementation ApplicationCommentImageTableViewCell

+ (NSString *)identifier { return NSStringFromClass(self);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.fileImageView];
        [self.contentView addSubview:self.timeLabel];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.contentView).offset(15);
            make.width.equalTo(@60);
        }];
        
        [self.fileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(100);
            make.top.equalTo(self.contentView).offset(15);
            make.height.width.equalTo(@60);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.fileImageView.mas_left).offset(-10);
        }];
    }
    return self;
}

#pragma mark - Interface Method
- (void)dataWithModel:(ApplicationCommentModel *)model {
    self.nameLabel.text = [model.createUserName stringByAppendingString:@":"];
    self.timeLabel.text = [model.createTime timeAgoSinceNow];
    
    UIImage *fileImage = [AttachmentUtil attachmentIconFromFileName:model.content];
    if (fileImage) {
        self.fileImageView.image = fileImage;
        return;
    }
    
    [self.fileImageView sd_setImageWithURL:[NSURL URLWithString:model.filePath] placeholderImage:[UIImage imageNamed:@"image_placeholder_loading"]];
}

- (void)clickToSee:(void (^)(id))clickBlock {
    _clickBlock = clickBlock;
}

#pragma mark - Button Click
- (void)clickToSeeImage {
    !self.clickBlock ?: self.clickBlock(self);
}

#pragma mark - Initializer
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor mtc_colorWithHex:0x959595];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (UIImageView *)fileImageView {
    if (!_fileImageView) {
        _fileImageView = [UIImageView new];
        _fileImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToSeeImage)];
        [_fileImageView addGestureRecognizer:tapGesture];
    }
    return _fileImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont mtc_font_24];
        _timeLabel.textColor = [UIColor mediumFontColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.numberOfLines = 0;
    }
    return _timeLabel;
}

@end