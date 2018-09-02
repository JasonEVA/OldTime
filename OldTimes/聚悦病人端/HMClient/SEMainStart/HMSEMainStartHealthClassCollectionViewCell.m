//
//  HMSEMainStartHealthClassCollectionViewCell.m
//  HMClient
//
//  Created by JasonWang on 2017/5/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSEMainStartHealthClassCollectionViewCell.h"
#import "UIImage+EX.h"
#import "HealthEducationItem.h"

@interface HMSEMainStartHealthClassCollectionViewCell ()
@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UILabel *titelLb;
@end

@implementation HMSEMainStartHealthClassCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.backView];
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
        UIView *blackView = [[UIView alloc] init];
        [blackView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.4]];
        [self.backView addSubview:blackView];
        [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.backView);
            make.height.equalTo(@30);
        }];
        
        [self.backView addSubview:self.titelLb];
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(blackView);
            make.left.greaterThanOrEqualTo(self.backView).offset(10);
            make.right.lessThanOrEqualTo(self.backView).offset(-10);
        }];

    }
    return self;
}

- (void)fillDataWithModel:(HealthEducationItem *)model {
    [self.backView sd_setImageWithURL:[NSURL URLWithString:model.classPic] placeholderImage:[UIImage at_imageWithColor:[UIColor commonBackgroundColor] size:CGSizeMake(220, 123)]];
    [self.titelLb setText:model.title];
}

- (UIImageView *)backView {
    if (!_backView) {
        _backView = [[UIImageView alloc] initWithImage:[UIImage at_imageWithColor:[UIColor commonBackgroundColor] size:CGSizeMake(220, 123)]];
        [_backView.layer setCornerRadius:3];
        [_backView setClipsToBounds:YES];

        
    }
    return _backView;
}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_titelLb setFont:[UIFont systemFontOfSize:16]];
    }
    return _titelLb;
}

@end
