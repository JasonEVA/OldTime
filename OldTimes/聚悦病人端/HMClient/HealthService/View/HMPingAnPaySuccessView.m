//
//  HMPingAnPaySuccessView.m
//  HMClient
//
//  Created by jasonwang on 2016/11/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMPingAnPaySuccessView.h"

@interface HMPingAnPaySuccessView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *successLb;
@end

@implementation HMPingAnPaySuccessView

- (instancetype)init {
    if (self = [super init]) {
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];

        [self addSubview:self.contentView];
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.serviceNameLb];
        [self.contentView addSubview:self.successLb];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(150);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.height.equalTo(@300);
        }];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(45);
            make.centerX.equalTo(self.contentView);
        }];
        
        [self.successLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconView.mas_bottom).offset(25);
            make.centerX.equalTo(self.contentView);
        }];
        
        [self.serviceNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.successLb.mas_bottom).offset(15);
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-45);
        }];
    }
    return self;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView.layer setCornerRadius:4];
        [_contentView setClipsToBounds:YES];
    }
    return _contentView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pingan_paysuccess"]];
    }
    return _iconView;
}

- (UILabel *)successLb {
    if (!_successLb) {
        _successLb = [UILabel new];
        [_successLb setText:@"您已成功订购"];
        [_successLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_successLb setFont:[UIFont font_30]];
    }
    return _successLb;
}

- (UILabel *)serviceNameLb {
    if (!_serviceNameLb) {
        _serviceNameLb = [UILabel new];
        [_serviceNameLb setText:@"心里套餐"];
        [_serviceNameLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_serviceNameLb setFont:[UIFont font_36]];
    }
    return _serviceNameLb;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
