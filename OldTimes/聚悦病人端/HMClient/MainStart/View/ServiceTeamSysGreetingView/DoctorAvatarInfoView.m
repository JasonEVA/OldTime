//
//  DoctorAvatarInfoView.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "DoctorAvatarInfoView.h"

@interface DoctorAvatarInfoView()
@property (nonatomic, strong)  UIImageView  *avatar; // <##>
@property (nonatomic, strong)  UILabel  *name; // <##>
@property (nonatomic, strong)  UIImageView  *leaderFlag; // <##>
@end

@implementation DoctorAvatarInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configElements];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.avatar.layer.cornerRadius = CGRectGetHeight(self.avatar.frame) * 0.5;
}
#pragma mark - Interface Method

- (void)configImageName:(NSString *)imageName name:(NSString *)name teamLeader:(BOOL)teamLeader {
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:imageName ?: @""] placeholderImage:[UIImage imageNamed:@"icon_default_staff"]];
    [self.name setText:name];
    self.leaderFlag.hidden = !teamLeader;
}

#pragma mark - Private Method
// 设置元素控件
- (void)configElements {
    
    [self addSubview:self.avatar];
    [self addSubview:self.name];
    [self addSubview:self.leaderFlag];
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@45);
        make.width.lessThanOrEqualTo(self).priorityMedium();
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];
    [self.leaderFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.avatar);
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar.mas_bottom).offset(8);
        make.centerX.equalTo(self);
        make.left.greaterThanOrEqualTo(self);
        make.right.lessThanOrEqualTo(self);
    }];
}

// 设置数据
- (void)configData {
    
}

#pragma mark - Init

- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.clipsToBounds = YES;
        [_avatar setImage:[UIImage imageNamed:@"icon_default_staff"]];
        _avatar.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatar.layer.borderWidth = 1.5;
    }
    return _avatar;
}
- (UIImageView *)leaderFlag {
    if (!_leaderFlag) {
        _leaderFlag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_doctorLeader_flag"]];
    }
    return _leaderFlag;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        [_name setFont:[UIFont font_24]];
        [_name setTextColor:[UIColor colorWithHexString:@"ffffff"]];
    }
    return _name;
}


@end
