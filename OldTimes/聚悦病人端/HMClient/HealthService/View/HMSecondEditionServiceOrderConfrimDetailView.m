//
//  HMSecondEditionServiceOrderConfrimDetailView.m
//  HMClient
//
//  Created by jasonwang on 2016/11/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMSecondEditionServiceOrderConfrimDetailView.h"
#import "ServiceInfo.h"

@interface HMSecondEditionServiceOrderConfrimDetailView ()
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *deadlineLb;
@property (nonatomic, strong) UILabel *servicerLb;
@end

@implementation HMSecondEditionServiceOrderConfrimDetailView

- (instancetype)init {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setCornerRadius:4];
        [self.layer setShadowOffset:CGSizeMake(0, 3)];
        [self.layer setShadowOpacity:0.1];
        
        [self addSubview:self.titelLb];
        [self addSubview:self.line];
        [self addSubview:self.deadlineLb];
        [self addSubview:self.servicerLb];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(20);
            make.left.equalTo(self).offset(17.5);
            make.right.lessThanOrEqualTo(self).offset(-17.5);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titelLb.mas_bottom).offset(15);
            make.left.equalTo(self).offset(17.5);
            make.right.equalTo(self).offset(-17.5);
            make.height.equalTo(@0.5);
        }];
        
        [self.deadlineLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb);
            make.top.equalTo(self.line.mas_bottom).offset(15);
            make.right.lessThanOrEqualTo(self).offset(-17.5);
        }];
        
        [self.servicerLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb);
            make.top.equalTo(self.deadlineLb.mas_bottom).offset(10);
            make.right.lessThanOrEqualTo(self).offset(-17.5);
        }];
    }
    return self;
}

- (void)fillDataWith:(ServiceDetail *)model {
    [self.titelLb setText:model.comboName];
    [self.servicerLb setText:[NSString stringWithFormat:@"服务者：%@",model.mainProviderName]];
    [self.deadlineLb setText:[NSString stringWithFormat:@"服务期限：%ld%@", model.comboBillWayNum, model.comboBillWayName]];
}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setFont:[UIFont font_36]];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titelLb setText:@"心里服务"];
    }
    return _titelLb;
}
- (UILabel *)deadlineLb {
    if (!_deadlineLb) {
        _deadlineLb = [UILabel new];
        [_deadlineLb setFont:[UIFont font_30]];
        [_deadlineLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_deadlineLb setText:@"服务期限：1年"];
    }
    return _deadlineLb;
}
- (UILabel *)servicerLb {
    if (!_servicerLb) {
        _servicerLb = [UILabel new];
        [_servicerLb setFont:[UIFont font_30]];
        [_servicerLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_servicerLb setText:@"服务者：专家"];
    }
    return _servicerLb;
}

- (UIView *)line {
    if (!_line) {
        _line = [UIView new];
        [_line setBackgroundColor:[UIColor colorWithHexString:@"e5e5e5"]];
    }
    return _line;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
