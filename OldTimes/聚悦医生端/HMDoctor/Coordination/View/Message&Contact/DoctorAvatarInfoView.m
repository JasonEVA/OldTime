//
//  DoctorAvatarInfoView.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "DoctorAvatarInfoView.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "UserProfileModel+ProfileExtension.h"

@interface DoctorAvatarInfoView()
@property (nonatomic, strong)  UIImageView  *avatar; // <##>
@property (nonatomic, strong)  UILabel  *name; // <##>
@property (nonatomic, strong)  UILabel  *position; // <##>

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

- (void)configMemberInfo:(UserProfileModel *)model {
//    NSString *baseURL = [CommonFuncs picUrlPerfix];
//    NSString *fullPath = [baseURL stringByAppendingString:model.avatar ?: @""];
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.avatar sd_setImageWithURL:avatarURL(avatarType_80, model.userName) placeholderImage:[UIImage imageNamed:@"img_default_staff"]];

    [self.name setText:[self getNikeNameWithMolde:model]];
    [self.position setText:[model getHm_position]];

}
#pragma mark - Interface Method
- (NSString *)getNikeNameWithMolde:(UserProfileModel *)model {
    NSString *nikeName = @"";
    UserProfileModel *tempModel = [[MessageManager share] queryContactProfileWithUid:model.userName];
    if (tempModel) {
        nikeName = tempModel.nickName;
    }
    else {
        nikeName = model.nickName;
    }
    return nikeName;
}
- (void)configImage:(UIImage *)image name:(NSString *)name position:(NSString *)position {
    [self.avatar setImage:image];
    [self.name setText:name];
    [self.position setText:position];
}

#pragma mark - Private Method
// 设置元素控件
- (void)configElements {
    
    [self addSubview:self.avatar];
    [self addSubview:self.name];
    [self addSubview:self.position];
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@60);
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar.mas_bottom).offset(9);
        make.centerX.equalTo(self);
        make.left.greaterThanOrEqualTo(self);
        make.right.lessThanOrEqualTo(self);
    }];
    [self.position mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset(4);
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
        [_avatar setImage:[UIImage imageNamed:@"img_default_staff"]];
    }
    return _avatar;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        [_name setText:@"王芳"];
        [_name setFont:[UIFont font_26]];
        [_name setTextColor:[UIColor commonBlackTextColor_333333]];
    }
    return _name;
}

- (UILabel *)position {
    if (!_position) {
        _position = [UILabel new];
        [_position setTextColor:[UIColor commonDarkGrayColor_666666]];
        [_position setFont:[UIFont font_24]];
        [_position setText:@"糖尿病专家"];
    }
    return _position;
}
@end
