//
//  ChatManagerAvatarView.m
//  launcher
//
//  Created by Andrew Shen on 15/9/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatManagerAvatarView.h"
#import "UIImage+Manager.h"
#import "UIColor+Hex.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "AvatarUtil.h"


static CGFloat const btnDeleteWidth = 15;
@interface ChatManagerAvatarView()

@property (nonatomic, strong)  UIImageView  *imageView; // avatar
@property (nonatomic, strong)  UIButton  *btnDelete; // <##>
@end

@implementation ChatManagerAvatarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.imageView];
        [self addSubview:self.btnDelete];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.equalTo(self.imageView.mas_width);
        make.left.equalTo(self).offset(13);
        make.right.equalTo(self).offset(-13);
    }];
    
    [self.btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(btnDeleteWidth));
        make.centerX.equalTo(self.imageView.mas_right);
        make.centerY.equalTo(self.imageView.mas_top);
    }];
    
    [super updateConstraints];
}

// 设置头像
- (void)setAvatar:(NSString *)strAvatar {
    if (self.tag >= avatar_add) {
        return;
    }
    
    NSURL *urlHead = avatarURL(avatarType_default, strAvatar);
    [self.imageView sd_setImageWithURL:urlHead placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (self.tag < avatar_add) {
            if (urlHead == imageURL) {
				if (image) {
					self.imageView.image = image;
				} else {
					self.imageView.image = [UIImage imageNamed:@"contact_default_headPic"];
				}
            }
        } else if (self.tag == avatar_add) {
            self.imageView.image = [UIImage imageNamed:@"chat_group_add"];
        } else if (self.tag == avatar_delete) {
            self.imageView.image = [UIImage imageNamed:@"chat_group_delete"];
        }
    }];
}
//设置圆角大小
- (void)setAvatarHaveCorners:(float)corners
{
    [self.imageView.layer setCornerRadius:corners];
}
/**
 *  是否编辑头像
 *
 *  @param edit 是否编辑
 */
- (void)avatarEdit:(BOOL)edit {
    if (self.tag == avatar_others) {
        [self.btnDelete setHidden:!edit];
    }
}

/**
 *  设置编辑事件
 */
- (void)setEditTarget:(id)target event:(SEL)event {
    [self.btnDelete addTarget:target action:event forControlEvents:UIControlEventTouchUpInside];
}

- (void)setTag:(NSInteger)tag {
    ChatGroupAvatarTag currentTag = (ChatGroupAvatarTag)tag;
    [super setTag:currentTag];
    switch (currentTag) {
        case avatar_host: {
            [self.btnDelete setHidden:YES];
            [self.imageView setImage:[UIImage imageNamed:@"contact_default_headPic"]];

            break;
        }
        case avatar_add: {
            [self.btnDelete setHidden:YES];
            [self.imageView setImage:[UIImage imageNamed:@"chat_group_add"]];
            break;
        }
        case avatar_delete: {
            [self.btnDelete setHidden:YES];
            [self.imageView setImage:[UIImage imageNamed:@"chat_group_delete"]];

            break;
        }
        case avatar_others: {
            [self.btnDelete setHidden:YES];
            [self.imageView setImage:[UIImage imageNamed:@"contact_default_headPic"]];

            break;
        }
        default: {
            break;
        }
    }
}
#pragma mark - Init
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setImage:[UIImage imageNamed:@"contact_default_headPic"]];
        _imageView.layer.cornerRadius = 2.5;
        _imageView.clipsToBounds = YES;
        [_imageView setUserInteractionEnabled:YES];
    }
    return _imageView;
}

- (UIButton *)btnDelete {
    if (!_btnDelete) {
        _btnDelete = [[UIButton alloc] init];
        [_btnDelete setBackgroundImage:[UIImage imageNamed:@"chat_icon_delete_NEW"] forState:UIControlStateNormal];
        [_btnDelete.layer setCornerRadius:btnDeleteWidth * 0.5];
        [_btnDelete.layer setMasksToBounds:YES];
    }
    return _btnDelete;
}
@end
