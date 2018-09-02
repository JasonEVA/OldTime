//
//  ShopBaseInfoView.m
//  Shape
//
//  Created by Andrew Shen on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "ShopBaseInfoView.h"
#import <Masonry.h>
#import "UIColor+Hex.h"
#import "MyDefine.h"

@interface ShopBaseInfoView()

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIImageView *sex;
@property (nonatomic, strong) UILabel *location;


@end
@implementation ShopBaseInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.background];
        [self.background addSubview:self.avatar];
        [self.background addSubview:self.name];
        [self.background addSubview:self.sex];
        [self.background addSubview:self.location];
        [self needsUpdateConstraints];

    }
    return self;
}

- (void)updateConstraints
{
    [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.background).offset(30);
        make.centerY.equalTo(self.background);
        make.width.height.equalTo(@60);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar.mas_right).offset(18);
        make.right.lessThanOrEqualTo(self.background);
        make.bottom.equalTo(self.mas_centerY).offset(-5);
    }];
    
    [self.sex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name);
        make.top.equalTo(self.mas_centerY).offset(5);
    }];
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sex.mas_right).offset(8);
        make.centerY.equalTo(self.sex);
        make.right.lessThanOrEqualTo(self.background);

    }];
    [super updateConstraints];
    
}

#pragma mark - init UI

- (UIImageView *)background
{
    
    if (!_background) {
        _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_backView"]];
        [_background setContentMode:UIViewContentModeScaleAspectFill];
        [_background setClipsToBounds:YES];
    }
    return _background;
}

- (UIImageView *)avatar
{
    
    if (!_avatar) {
        _avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_icon"]];
        _avatar.layer.cornerRadius = 30;
        [_avatar setClipsToBounds:YES];
    }
    return _avatar;
}

- (UIImageView *)sex
{
    
    if (!_sex) {
        _sex = [[UIImageView alloc]init];
        [_sex setImage:[UIImage imageNamed:@"me_man"]];
    }
    return _sex;
}

- (UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc]init];
        [_name setText:@"Shape官方"];
        [_name setTextColor:[UIColor whiteColor]];
        _name.font = [UIFont systemFontOfSize:fontSize_15];
    }
    return _name;
}

- (UILabel *)location
{
    if (!_location) {
        _location = [[UILabel alloc]init];
        [_location setText:@"浙江 杭州"];
        [_location setTextColor:[UIColor colorLightGray_989898]];
        _location.font = [UIFont systemFontOfSize:fontSize_13];
    }
    return _location;
}

@end
