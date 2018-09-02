//
//  HMSelectPatientGroupHeaderView.m
//  HMDoctor
//
//  Created by jasonwang on 2016/11/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMSelectPatientGroupHeaderView.h"

@interface HMSelectPatientGroupHeaderView ()
@property (nonatomic, strong) UIImageView *ivArrow;
@property (nonatomic, strong) UILabel *lbGroupname;
@property (nonatomic, strong) UILabel *countLb;
@property (nonatomic, strong) UIButton *ivSelected;
@property (nonatomic, copy) HMAllSelectBottonClick block;
@end

@implementation HMSelectPatientGroupHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
/*禁止组全选
        [self addSubview:self.ivSelected];
        [self.ivSelected mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20.5, 20.5));
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
        }];
*/
        self.ivArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"c_grayArrow"]];
        [self addSubview:self.ivArrow];
        [self.ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12.5);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(@10);
            make.height.mas_equalTo(@10);
        }];
        
        self.countLb = [[UILabel alloc] init];
        [self addSubview:self.countLb];
        [self.countLb setFont:[UIFont systemFontOfSize:15]];
        [self.countLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        
        [self.countLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-15);
        }];
        
        self.lbGroupname = [[UILabel alloc]init];
        [self addSubview:self.lbGroupname];
        [self.lbGroupname setFont:[UIFont systemFontOfSize:15]];
        [self.lbGroupname setTextColor:[UIColor commonTextColor]];
        
        [self.lbGroupname mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.ivArrow.mas_right).with.offset(7.5);
            make.right.lessThanOrEqualTo(self.countLb.mas_left).offset(-10);
        }];

    }
    return self;
}

- (void) setGroupName:(NSString*) name
{
    [self.lbGroupname setText:name];
}

- (void)fillCount:(NSString *)count {
    [self.countLb setText:count];
}

- (void) setIsExpanded:(BOOL) isExpanded
{
    //icon_down_list_arrow
    [self.ivArrow setImage:[UIImage imageNamed:@"c_grayArrow"]];
    if (!isExpanded)
    {
        [self.ivArrow setImage:[UIImage imageNamed:@"r_grayArrow"]];
    }
}

- (void) setIsSelected:(BOOL) selected
{
    //c_contact_nonSelect c_contact_selected
    [self.ivSelected setSelected:selected];
}

- (void)allClick {
    if (self.block) {
        self.block();
    }
}
- (void)allSelectBottonClick:(HMAllSelectBottonClick)click {
    self.block = click;
}

- (UIButton *)ivSelected {
    if (!_ivSelected) {
        _ivSelected = [[UIButton alloc] init];
        [_ivSelected setImage:[UIImage imageNamed:@"c_contact_unselected"] forState:UIControlStateNormal];
        [_ivSelected setImage:[UIImage imageNamed:@"c_contact_selected"] forState:UIControlStateSelected];
        
        [_ivSelected addTarget:self action:@selector(allClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ivSelected;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
