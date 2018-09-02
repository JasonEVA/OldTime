//
//  HMBottomShotView.m
//  HMClient
//
//  Created by jasonwang on 2016/10/11.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMBottomShotView.h"

@interface HMBottomShotView()
@property (nonatomic, copy) shotBlock block;
@end

@implementation HMBottomShotView


- (instancetype)init {
    if (self = [super init]) {
        
        UIButton *selectBtn = [UIButton new];
        [selectBtn setImage:[UIImage imageNamed:@"ic_yihuanqun"] forState:UIControlStateNormal];
        [selectBtn setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        [selectBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
        [selectBtn setTag:1];
        [selectBtn addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *textLb = [UILabel new];
        [textLb setText:@"医患群"];
        [selectBtn addSubview:textLb];
        
        [textLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selectBtn.imageView.mas_bottom).offset(5);
            make.centerX.equalTo(selectBtn);
        }];
        
        UIButton *selectBtn1 = [UIButton new];
        [selectBtn1 setImage:[UIImage imageNamed:@"ic_guanhuai"] forState:UIControlStateNormal];
        [selectBtn1 setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        [selectBtn1 setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
        [selectBtn1 setTag:2];
        [selectBtn1 addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *textLb1 = [UILabel new];
        [textLb1 setText:@"医生关怀"];
        [selectBtn1 addSubview:textLb1];
        
        [textLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selectBtn1.imageView.mas_bottom).offset(5);
            make.centerX.equalTo(selectBtn1);
        }];

        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

        [cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [cancelBtn setTag:0];
        [cancelBtn addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:selectBtn];
        [self addSubview:cancelBtn];
        [self addSubview:selectBtn1];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@45);
        }];
        
        [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.width.equalTo(selectBtn1);
            make.right.equalTo(selectBtn1.mas_left);
            make.bottom.equalTo(cancelBtn.mas_top);
            make.height.equalTo(@125);
        }];
        
        [selectBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.equalTo(selectBtn.mas_right);
            make.width.equalTo(selectBtn);
            make.bottom.equalTo(cancelBtn.mas_top);
            make.height.equalTo(@125);
        }];
    }
    return self;
}
- (void)clickbutton:(UIButton *)button {
    if (self.block) {
        self.block(button.tag);
    }
}

- (void)btnClick:(shotBlock)block {
    self.block = block;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
