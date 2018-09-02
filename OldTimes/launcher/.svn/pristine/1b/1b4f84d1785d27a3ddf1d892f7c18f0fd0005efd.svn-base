//
//  ImageCollectionViewCell.m
//  launcher
//
//  Created by Tab Liu on 15/9/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ImageCollectionViewCell.h"
#import "Masonry.h"
#import "NSDate+String.h"
#import <MJExtension/MJExtension.h>
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "NSDate+MsgManager.h"
#import "MyDefine.h"
#import "ChatIMConfigure.h"

#define FONT [UIFont systemFontOfSize:10]
#define IMG_PLACEHOLDER_LOADING [UIImage imageNamed:@"image_placeholder_loading"]

//static NSString * const im_IP_http = @"http://192.168.1.251:20001/launchr";
static NSString * const person_nickName    = @"nickName";

@implementation ImageCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.timeLabel];
        [self.bgView addSubview:self.locationLabel];
        [self updateConstraints];
    }
    return self;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = FONT;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.userInteractionEnabled = YES;
        [_timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _timeLabel;
}
- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textColor = [UIColor whiteColor];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.font = FONT;
        _locationLabel.userInteractionEnabled = YES;
    }
    return _locationLabel;
}
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}
- (void)updateConstraints
{
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@20);
    }];
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(5);
        make.top.equalTo(_bgView);
        make.bottom.equalTo(_bgView);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationLabel.mas_right).offset(5);
        make.top.equalTo(_bgView);
        make.bottom.equalTo(_bgView);
        make.right.equalTo(_bgView).offset(-5);
    }];
    [super updateConstraints];
}

- (void)setValue:(MessageBaseModel *)model
{
    NSString *time = [NSDate im_dateFormaterWithTimeInterval:model._createDate];
    self.timeLabel.text = time;

    if (model._nativeThumbnailUrl.length != 0) {
        NSString * str = model._nativeThumbnailUrl;
        self.locationLabel.text = [model getNickName];
        NSString *fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:str];
        UIImage * image = [UIImage imageWithContentsOfFile:fullPath];
        self.imageView.image = image;
    }else {
        NSString * str= @"";
        if ([model.attachModel.thumbnail isEqualToString:@""] || model.attachModel.thumbnail == nil) {
            str = model.attachModel.fileUrl;
        }else {
            str = model.attachModel.thumbnail;
        }
        SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
        NSString * string = [NSString stringWithFormat:@"AppName=launchr;UserName=%@",[UnifiedUserInfoManager share].userShowID];
        [manager setValue:string forHTTPHeaderField:@"Cookie"];

        self.locationLabel.text = [model getNickName];
        NSString *fullPath = [NSString stringWithFormat:@"%@%@",im_IP_http,str];

        [self.imageView sd_setImageWithURL:[NSURL URLWithString:fullPath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!image) {
                //添加裂图 ☜(ﾟヮﾟ☜) 图片获取不到就显示裂图
                [self.imageView setImage:[UIImage imageNamed:@"expried"]];
            }
        }];

    }
}

@end
