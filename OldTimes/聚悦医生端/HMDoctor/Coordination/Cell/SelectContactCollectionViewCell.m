//
//  SelectContactCollectionViewCell.m
//  launcher
//
//  Created by williamzhang on 15/10/13.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "SelectContactCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MintcodeIMKit/MintcodeIMKit.h>
#import <Masonry/Masonry.h>

@interface SelectContactCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SelectContactCollectionViewCell

+ (NSString *)identifier { return NSStringFromClass(self);}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - Interface Method

- (void)configCellImageViewWithImagePath:(NSString *)imagePath {
    NSURL *url = [NSURL URLWithString:imagePath];
    if (![imagePath hasPrefix:@"http://"] && ![imagePath hasPrefix:@"https://"]) {
//        NSString *baseURL = [CommonFuncs picUrlPerfix];
//        imagePath = [baseURL stringByAppendingString:imagePath ?: @""];
        url = avatarIMURL(avatarType_80, imagePath);
    }
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
}

#pragma mark - Initializer
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.layer.cornerRadius = 3;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

@end
