//
//  ProjectMembersCollectionViewCell.m
//  launcher
//
//  Created by TabLiu on 16/2/19.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ProjectMembersCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <UIImageView+WebCache.h>
#import "AvatarUtil.h"

@interface ProjectMembersCollectionViewCell ()

@property (nonatomic,strong) UIImageView * headImageView ;
@property (nonatomic,strong) UILabel * nickNameLabel;

@end

@implementation ProjectMembersCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nickNameLabel];
        
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(20);
            make.width.height.equalTo(@40);
        }];
        [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headImageView.mas_bottom);
            make.centerX.equalTo(self.headImageView);
            //make.width.equalTo(self.headImageView);
            make.height.equalTo(@30);
            make.left.equalTo(self.contentView.mas_left).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
        }];
        
    }
    return self;
}

- (void)setCellData:(UserProfileModel *)model
{
    self.nickNameLabel.text = model.nickName;
    NSURL *urlHead = avatarURL(avatarType_default, model.userName);
    [self.headImageView sd_setImageWithURL:urlHead placeholderImage:[UIImage imageNamed:@"login_login_head"]];
}


- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.userInteractionEnabled = YES;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 3.0;
    }
    return _headImageView;
}
- (UILabel *)nickNameLabel
{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = [UIFont systemFontOfSize:14.0];
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nickNameLabel;
}

@end
