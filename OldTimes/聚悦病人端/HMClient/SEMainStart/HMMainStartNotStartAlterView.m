//
//  HMMainStartNotStartAlterView.m
//  HMClient
//
//  Created by JasonWang on 2017/5/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMMainStartNotStartAlterView.h"

@interface HMMainStartNotStartAlterView ()
@property(nonatomic, copy) MSAlterBlock block;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titelLb;
@end

@implementation HMMainStartNotStartAlterView


- (instancetype)init {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        
        UIView *backView = [[UIView alloc] init];
        [backView setBackgroundColor:[UIColor whiteColor]];
        [backView.layer setCornerRadius:5];
        
        [self addSubview:backView];
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@260);
            make.height.equalTo(@210);
        }];
        
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SEMainStartic_nostart"]];
        
        [backView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(backView).offset(30);
        }];
        
        self.titelLb = [UILabel new];
        [self.titelLb setText:@"任务未开始，请稍后操作。"];
        [self.titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self.titelLb setNumberOfLines:0];
        [self.titelLb setFont:[UIFont systemFontOfSize:16]];
        [self.titelLb setTextAlignment:NSTextAlignmentCenter];
        [backView addSubview:self.titelLb];
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(12);
            make.centerX.equalTo(self);
            make.width.equalTo(@175);
        }];
        
        UIButton *closeBtn = [[UIButton alloc] init];
        [closeBtn setImage:[UIImage imageNamed:@"SEMainStartic_close"] forState:UIControlStateNormal];
        [closeBtn setTag:HMMainStartAlterBtnType_Close];
        [closeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView);
            make.bottom.equalTo(backView.mas_top).offset(-15);
        }];
        
        
        UIButton *waitBtn = [[UIButton alloc] init];
        [waitBtn setTitle:@"知道了" forState:UIControlStateNormal];
        [waitBtn setBackgroundColor:[UIColor mainThemeColor]];
        [waitBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [waitBtn.layer setCornerRadius:3];
        [waitBtn.layer setBorderColor:[[UIColor mainThemeColor] CGColor]];
        [waitBtn.layer setBorderWidth:0.5];
        
        [waitBtn setTag:HMMainStartAlterBtnType_Wait];
        [waitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [backView addSubview:waitBtn];
        [waitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(backView).offset(-27);
            make.height.equalTo(@35);
            make.width.equalTo(@155);
            make.centerX.equalTo(backView);
        }];
    }
    return self;
}

- (void)configImage:(UIImage *)image titel:(NSString *)titel {
    [self.imageView setImage:image];
    [self.titelLb setText:titel];
}

- (void)btnClick:(UIButton *)btn {
    if (self.block) {
        self.block(btn.tag);
    }
}

- (void)btnClickBlock:(MSAlterBlock)block {
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
