//
//  HMSEPersonSpaceTopCollectionViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/4/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSEPersonSpaceTopCollectionViewCell.h"

@interface HMSEPersonSpaceTopCollectionViewCell ()

@end

@implementation HMSEPersonSpaceTopCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titelLb];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_centerY).offset(10);
            make.centerX.equalTo(self.contentView);
        }];
    }
    return self;
}


- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_ic_dd"]];
    }
    return _iconImageView;
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
