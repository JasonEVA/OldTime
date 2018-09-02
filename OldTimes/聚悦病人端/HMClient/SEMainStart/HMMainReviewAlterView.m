//
//  HMMainReviewAlterView.m
//  HMClient
//
//  Created by jasonwang on 2017/5/18.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMMainReviewAlterView.h"
#import "PlanMessionListItem.h"

@interface HMMainReviewAlterView ()
@property(nonatomic, copy) MSReviewAlterBlock block;
@property (nonatomic, strong) UILabel *titelLb;
@end

@implementation HMMainReviewAlterView

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
            make.height.equalTo(@236);
        }];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SEMainStartic_fucha"]];
        
        [backView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(backView).offset(30);
        }];
        
        self.titelLb = [UILabel new];
        [self.titelLb setText:@"亲，请及时复查哦！复查项目"];
        [self.titelLb setNumberOfLines:0];
        [self.titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self.titelLb setFont:[UIFont systemFontOfSize:16]];
        
        [backView addSubview:self.titelLb];
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(12);
            make.centerX.equalTo(self);
            make.width.equalTo(@150);
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
        
        UIButton *goonBtn = [[UIButton alloc] init];
        [goonBtn setTitle:@"已复查" forState:UIControlStateNormal];
        [goonBtn setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [goonBtn setBackgroundColor:[UIColor whiteColor]];
        
        [goonBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [goonBtn.layer setCornerRadius:3];
        [goonBtn.layer setBorderColor:[[UIColor mainThemeColor] CGColor]];
        [goonBtn.layer setBorderWidth:0.5];
        
        [goonBtn setTag:HMMainStartAlterBtnType_Goon];
        [goonBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [backView addSubview:goonBtn];
        [goonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(backView).offset(-27);
            make.height.equalTo(@35);
            make.left.equalTo(backView).offset(15);
        }];
        
        UIButton *waitBtn = [[UIButton alloc] init];
        [waitBtn setTitle:@"待会就去" forState:UIControlStateNormal];
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
            make.width.equalTo(goonBtn);
            make.right.equalTo(backView).offset(-15);
            make.left.equalTo(goonBtn.mas_right).offset(10);
        }];
    }
    return self;
}

- (void)fillDataWith:(PlanMessionListItem *)model {
    [self.titelLb setText:[NSString stringWithFormat:@"亲，请及时复查哦！复查项目：%@",model.taskCon]];
}
- (void)btnClick:(UIButton *)btn {
    if (self.block) {
        self.block(btn.tag);
    }
}

- (void)btnClickBlock:(MSReviewAlterBlock)block {
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
