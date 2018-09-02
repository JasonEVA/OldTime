//
//  MeGridCollectionViewCell.m
//  Shape
//
//  Created by Andrew Shen on 15/11/16.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeGridCollectionViewCell.h"
#import <Masonry/Masonry.h>

@interface MeGridCollectionViewCell()
@property (nonatomic, strong)  UIImageView  *imageView; // <##>
@end
@implementation MeGridCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.imageView];
        [self needsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [super updateConstraints];
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_bodyTest"]];
//        [_imageView setContentMode:UIViewContentModeCenter | UIViewContentModeScaleToFill];
    }
    return _imageView;
}
@end
