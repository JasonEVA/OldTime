//
//  MessageHeadImageVIew.m
//  Titans
//
//  Created by Remon Lv on 14-8-27.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "MessageHeadImageVIew.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MintcodeIM/MintcodeIM.h>
#import <Masonry/Masonry.h>
#import "RoundCountView.h"
#import "AvatarUtil.h"
#import "MyDefine.h"
#import "Category.h"

static const CGFloat countBackGroundSize = 18;

@interface MessageHeadImageVIew ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *countBackgroundImageView;
@property (nonatomic, strong) RoundCountView *countView;

@property (nonatomic) CGFloat countWidth;
@property (nonatomic) CGFloat muteNotification;

@end

@implementation MessageHeadImageVIew

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.avatarImageView];
        [self addSubview:self.countBackgroundImageView];
        [self addSubview:self.countView];

        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self);
            make.width.height.equalTo(@40);
        }];
        
        [self.countBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.avatarImageView.mas_right);
            make.centerY.equalTo(self.avatarImageView.mas_top);
        }];
        
        [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.width.height.equalTo(self.countBackgroundImageView);
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat cornerRadius = countBackGroundSize;
    if (self.muteNotification)
    {
        cornerRadius = 10;
    }
    [self.countBackgroundImageView.layer setCornerRadius:cornerRadius / 2];
    [self.layer setCornerRadius:cornerRadius / 2];
}

- (void)setImage:(UIImage *)image InfoCount:(NSInteger)count
{
    [self.avatarImageView setImage:image];
    [self.countView setAppCount:count];
    [self.countView setHidden:(count <= 0)];
    [self.countBackgroundImageView setHidden:self.countView.hidden];
    
    [self.countBackgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@10);
    }];
}

- (void)setImage:(UIImage *)image imgUrlstring:(NSString *)imgurlstr InfoCount:(NSInteger)count
{
    if (imgurlstr.length)
    {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:imgurlstr] placeholderImage:image];
    }
    else
    {
        [self.avatarImageView setImage:image];
    }
    [self.countView setAppCount:count];
    [self.countView setHidden:(count <= 0)];
    [self.countBackgroundImageView setHidden:self.countView.hidden];
    
    [self.countBackgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@10);
    }];
}

- (void)setImageAndCountWithModel:(ContactDetailModel *)model {
    NSURL *urlHead = avatarURL(avatarType_80, model._target);
    NSString *placeholderImageName = @"contact_default_headPic";
    if (model._isGroup) {
        // TODO: 群头像路径
        //urlHead = ava
        placeholderImageName = @"group_defalut_avatar";
        //打卡处：群头像问题 －－ 第二次修改
//        [self.avatarImageView sd_setImageWithURL:urlHead placeholderImage:[UIImage imageNamed:placeholderImageName]];
        self.avatarImageView.image = [UIImage imageNamed:placeholderImageName];
    } else {
        [self.avatarImageView sd_setImageWithURL:urlHead placeholderImage:[UIImage imageNamed:placeholderImageName]];
    }
    
    [self.countView setCount:model._countUnread];
    [self.countView setHidden:(model._countUnread <= 0)];
    [self.countBackgroundImageView setHidden:self.countView.hidden];
}

- (void)setImageWithContactModel:(ContactDetailModel *)model {
    NSInteger count = model._countUnread;
    
    self.muteNotification = model._muteNotification;
    [self setImageAndCountWithModel:model];
    self.countWidth = countBackGroundSize;
    
    [self.countBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.avatarImageView.mas_right);
        make.centerY.equalTo(self.avatarImageView.mas_top);
        make.height.equalTo(@(countBackGroundSize));
        if (count == 1)
        {
            make.width.equalTo(@(countBackGroundSize));
        }
    }];
    
    if (self.muteNotification != 0 && count) {
        [self.countBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.avatarImageView.mas_right);
            make.centerY.equalTo(self.avatarImageView.mas_top);
            make.width.height.equalTo(@10);
        }];
        
        [self.countView setAppCount:count];
    }
}

#pragma mark - Initializer
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.layer.cornerRadius = 2.5;
        _avatarImageView.clipsToBounds = YES;
        
//        _avatarImageView.layer.shouldRasterize = YES;
//        _avatarImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    return _avatarImageView;
}

- (UIImageView *)countBackgroundImageView {
    if (!_countBackgroundImageView) {
        _countBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage mtc_imageColor:[UIColor clearColor] size:CGSizeZero cornerRadius:countBackGroundSize / 2]];
//        _countBackgroundImageView = [UIImageView new];
//        [_countBackgroundImageView setBackgroundColor:[UIColor themeRed]];
//        [_countBackgroundImageView.layer setCornerRadius:countBackGroundSize / 2];
        [_countBackgroundImageView setClipsToBounds:YES];
//        [_countBackgroundImageView setContentMode:UIViewContentModeScaleToFill];
    }
    return _countBackgroundImageView;
}

- (RoundCountView *)countView {
    if (!_countView) {
        _countView = [[RoundCountView alloc] init];
    }
    return _countView;
}

@end
