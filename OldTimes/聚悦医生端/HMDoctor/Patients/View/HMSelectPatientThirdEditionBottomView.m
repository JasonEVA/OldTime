//
//  HMSelectPatientThirdEditionBottomView.m
//  HMDoctor
//
//  Created by jasonwang on 2016/11/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMSelectPatientThirdEditionBottomView.h"

@interface HMSelectPatientThirdEditionBottomView ()
@property (nonatomic, strong) UIView *line;

@end

@implementation HMSelectPatientThirdEditionBottomView

- (instancetype)init {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:self.line];
        [self addSubview:self.sendBtn];
        [self addSubview:self.selectBtn];
        [self addSubview:self.titelLb];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0.1);
        }];
        
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(20.5, 20.5));
            make.left.equalTo(self).offset(12.5);
        }];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.selectBtn.mas_right).offset(15);
        }];
        
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(self);
            make.top.equalTo(self.line.mas_bottom);
            make.width.mas_equalTo(100);
        }];
    }
    return self;
}

- (void)allSelectClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(HMSelectPatientThirdEditionBottomViewDelegateCallBack_buttonClick:)]) {
        [self.delegate HMSelectPatientThirdEditionBottomViewDelegateCallBack_buttonClick:button];
    }
}

- (UIView *)line {
    if (!_line) {
        _line = [UIView new];
        [_line setBackgroundColor:[UIColor commonLightGrayColor_ebebeb]];
    }
    return _line;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setImage:[UIImage imageNamed:@"c_contact_unselected"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"c_contact_selected"] forState:UIControlStateSelected];
        [_selectBtn setTag:0];
        [_selectBtn addTarget:self action:@selector(allSelectClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_selectBtn setHidden:YES];
    }
    return _selectBtn;
}
- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setText:@"全选"];
//        [_titelLb setHidden:YES];
    }
    return _titelLb;
}
- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setBackgroundImage:[UIImage imageColor:[UIColor colorWithHexString:@"0099ff"] size:CGSizeMake(1, 1) cornerRadius:0] forState:UIControlStateNormal];
        [_sendBtn setTitle:@"发送()" forState:UIControlStateNormal];
        [_sendBtn setTag:1];
        [_sendBtn addTarget:self action:@selector(allSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
