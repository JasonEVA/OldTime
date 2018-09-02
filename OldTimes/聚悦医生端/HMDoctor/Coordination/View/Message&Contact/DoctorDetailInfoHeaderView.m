//
//  DoctorDetailInfoHeaderView.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/18.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "DoctorDetailInfoHeaderView.h"

@interface DoctorDetailInfoHeaderView ()

@property (nonatomic, strong)  UIImageView  *avatar; // <##>
@property (nonatomic, strong)  UILabel  *name; // <##>

@end

@implementation DoctorDetailInfoHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor mainThemeColor];
        [self configElements];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.avatar.layer.cornerRadius = CGRectGetHeight(self.avatar.frame) * 0.5;
}

- (void)configAvatarPath:(NSString *)uid name:(NSString *)name {
//    NSString *baseURL = [CommonFuncs picUrlPerfix];
//    NSURL *fullPath = avatarIMURL(avatarType_80, path);
//    if ([path hasPrefix:@"http://"] || [path hasPrefix:@"https://"]) {
//        fullPath = [NSURL URLWithString:path];
//    }
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.avatar sd_setImageWithURL:avatarURL(avatarType_80,uid) placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    self.name.text = name;
}

#pragma mark - Private Method
// 设置元素控件
- (void)configElements {
    [self addSubview:self.avatar];
    [self addSubview:self.name];
    
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(100);
        make.top.equalTo(self).offset(44);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.avatar.mas_bottom).offset(15);
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
        [_avatar.layer setBorderColor:[UIColor whiteColor].CGColor];
        [_avatar.layer setBorderWidth:3];
        [_avatar setImage:[UIImage imageNamed:@"img_default_staff"]];
    }
    return _avatar;
}

- (UILabel *)name {
    if (!_name) {
        _name = [UILabel new];
        [_name setText:@"王芳"];
        [_name setTextColor:[UIColor whiteColor]];
    }
    return _name;
}
@end
