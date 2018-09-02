//
//  MessageHeadImageVIew.m
//  Titans
//
//  Created by Remon Lv on 14-8-27.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "MessageHeadImageVIew.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MintcodeIMKit/MintcodeIMKit.h>
#import <Masonry/Masonry.h>
#import "RoundCountView.h"
#import "MyDefine.h"
#import "ClientHelper.h"
#define COLOR_BG [UIColor colorWithRed:238.0/255.0 green:44.0/255.0 blue:76.0/255.0 alpha:1.0]

static const CGFloat unReadCountLbSize = 18; //带数字红点尺寸
static const CGFloat redPointSize = 10;        //不带数字尺寸

@interface MessageHeadImageVIew ()

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *unReadCountLb;
@property (nonatomic, strong) UIView *redPoint;

@property (nonatomic) CGFloat muteNotification;

@end

@implementation MessageHeadImageVIew

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.avatarImageView];
        [self addSubview:self.redPoint];
        [self addSubview:self.unReadCountLb];


        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self);
            make.width.height.equalTo(@40);
        }];
        
        [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView).offset(-4);
            make.right.equalTo(self.avatarImageView).offset(4);
            make.width.height.equalTo(@(redPointSize));
        }];
        
        [self.unReadCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView).offset(-4);
            make.centerX.equalTo(self.avatarImageView.mas_right).offset(-5);
            make.height.equalTo(@(unReadCountLbSize));
            make.left.lessThanOrEqualTo(self.avatarImageView.mas_right).offset(-14);
            make.right.greaterThanOrEqualTo(self.avatarImageView.mas_right).offset(4);
        }];
    }
    return self;
}


- (void)setImage:(UIImage *)image InfoCount:(NSInteger)count
{
    [self.avatarImageView setImage:image];
    [self.redPoint setHidden:!count];
    [self.unReadCountLb setHidden:YES];
}

- (void)setImage:(UIImage *)image imgUrlstring:(NSString *)imgurlstr InfoCount:(NSInteger)count
{
    if (imgurlstr.length)
    {
         // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
        // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:imgurlstr] placeholderImage:image];
    }
    else
    {
        [self.avatarImageView setImage:image];
    }
    [self.redPoint setHidden:!count];
    [self.unReadCountLb setHidden:YES];
}

- (void)setImageAndCountWithModel:(ContactDetailModel *)model {

    NSString *placeholderImageName = @"img_default_staff";
    if (model._isGroup) {
        placeholderImageName = @"group_defalut_avatar";
        self.avatarImageView.image = [UIImage imageNamed:placeholderImageName];
    }
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.avatarImageView sd_setImageWithURL:avatarURL(avatarType_80, model._target) placeholderImage:[UIImage imageNamed:placeholderImageName]];
}

- (void)setImageWithContactModel:(ContactDetailModel *)model {
    NSInteger count = model._countUnread;
    
    self.muteNotification = !model._muteNotification;
    //群头像暂时屏蔽
//    [self setImageAndCountWithModel:model];
    if (!count) {
        [self.redPoint setHidden:YES];
        [self.unReadCountLb setHidden:YES];
    }
    else {
        [self.redPoint setHidden:self.muteNotification];
        [self.unReadCountLb setHidden:!self.muteNotification];
        [self.unReadCountLb setText:count > 99 ? [NSString stringWithFormat:@"⋅⋅⋅  "] : [NSString stringWithFormat:@"%ld  ",count]];
    }
}

#pragma mark - Initializer
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.layer.cornerRadius = 2.5;
        _avatarImageView.clipsToBounds = YES;
        [_avatarImageView setImage:[UIImage imageNamed:@"group_defalut_avatar"]];
    }
    return _avatarImageView;
}

- (UIView *)redPoint {
    if (!_redPoint) {
        _redPoint = [UIView new];
        [_redPoint setBackgroundColor:COLOR_BG];
        [_redPoint.layer setCornerRadius:redPointSize / 2];
        [_redPoint setClipsToBounds:YES];
    }
    return _redPoint;
}

- (UILabel *)unReadCountLb {
    if (!_unReadCountLb) {
        _unReadCountLb = [UILabel new];
        [_unReadCountLb.layer setBackgroundColor:[COLOR_BG CGColor]];
        [_unReadCountLb.layer setCornerRadius:unReadCountLbSize / 2];
        [_unReadCountLb.layer setBorderWidth:1];
        [_unReadCountLb.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [_unReadCountLb setClipsToBounds:YES];
        [_unReadCountLb setTextColor:[UIColor whiteColor]];
        [_unReadCountLb setFont:[UIFont systemFontOfSize:12]];
        [_unReadCountLb setTextAlignment:NSTextAlignmentCenter];
    }
    return _unReadCountLb;
}

@end
