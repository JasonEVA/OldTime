//
//  HMSEMainStartToolBoxCollectionViewCell.m
//  HMClient
//
//  Created by JasonWang on 2017/5/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSEMainStartToolBoxCollectionViewCell.h"

@implementation HMSEMainStartToolBoxCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titelLb];
        [self.contentView addSubview:self.unOpenImage];

        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(10);
        }];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_centerY).offset(20);
            make.centerX.equalTo(self.contentView);
        }];
        
        [self.unOpenImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImageView).offset(-10);
            make.right.equalTo(self.iconImageView).offset(15);
        }];
    }
    return self;
}

- (void)showUnopenIcon {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    
   
}


- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_ic_dd"]];
    }
    return _iconImageView;
}

- (UIImageView *)unOpenImage {
    if (!_unOpenImage) {
        _unOpenImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SEMainStartim_wkt"]];
    }
    return _unOpenImage;
}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setFont:[UIFont systemFontOfSize:15]];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
    }
    return _titelLb;
}

@end
