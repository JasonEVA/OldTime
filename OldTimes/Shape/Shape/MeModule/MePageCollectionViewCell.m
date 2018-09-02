//
//  MePageCollectionViewCell.m
//  Shape
//
//  Created by Andrew Shen on 15/11/16.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MePageCollectionViewCell.h"
#import <Masonry/Masonry.h>

@interface MePageCollectionViewCell()
@property (nonatomic, strong)  UIImageView  *imageView; // <##>
@property (nonatomic, strong)  UILabel  *date; // <##>
@end
@implementation MePageCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;

        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.date];
        [self needsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-40);
    }];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
    }];
    [super updateConstraints];
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
//        [_imageView setContentMode:UIViewContentModeCenter | UIViewContentModeScaleAspectFill];
        [_imageView setImage:[UIImage imageNamed:@"me_bodyTest"]];
        [_imageView.layer setCornerRadius:3];
        [_imageView.layer setMasksToBounds:YES];
    }
    return _imageView;
}
- (UILabel *)date {
    if (!_date) {
        _date = [[UILabel alloc] init];
        [_date setText:@"2015-09-12"];
        [_date setFont:[UIFont systemFontOfSize:15]];
        [_date setTextColor:[UIColor grayColor]];
    }
    return _date;
}
@end
